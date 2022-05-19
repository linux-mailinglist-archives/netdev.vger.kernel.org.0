Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68ADD52DE59
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbiESUXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244692AbiESUXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:23:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3978EC1EE2
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:23:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nrmgE-0005IV-MD
        for netdev@vger.kernel.org; Thu, 19 May 2022 22:23:30 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id EC9C88263C
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 20:23:28 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 598738262F;
        Thu, 19 May 2022 20:23:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bbdc383a;
        Thu, 19 May 2022 20:23:26 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 4/4] can: mcp251xfd: silence clang's -Wunaligned-access warning
Date:   Thu, 19 May 2022 22:23:08 +0200
Message-Id: <20220519202308.1435903-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220519202308.1435903-1-mkl@pengutronix.de>
References: <20220519202308.1435903-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

clang emits a -Wunaligned-access warning on union
mcp251xfd_tx_ojb_load_buf.

The reason is that field hw_tx_obj (not declared as packed) is being
packed right after a 16 bits field inside a packed struct:

| union mcp251xfd_tx_obj_load_buf {
| 	struct __packed {
| 		struct mcp251xfd_buf_cmd cmd;
| 		  /* ^ 16 bits fields */
| 		struct mcp251xfd_hw_tx_obj_raw hw_tx_obj;
| 		  /* ^ not declared as packed */
| 	} nocrc;
| 	struct __packed {
| 		struct mcp251xfd_buf_cmd_crc cmd;
| 		struct mcp251xfd_hw_tx_obj_raw hw_tx_obj;
| 		__be16 crc;
| 	} crc;
| } ____cacheline_aligned;

Starting from LLVM 14, having an unpacked struct nested in a packed
struct triggers a warning. c.f. [1].

This is a false positive because the field is always being accessed
with the relevant put_unaligned_*() function. Adding __packed to the
structure declaration silences the warning.

[1] https://github.com/llvm/llvm-project/issues/55520

Link: https://lore.kernel.org/all/20220518114357.55452-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 1d43bccc29bf..2b0309fedfac 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -441,7 +441,7 @@ struct mcp251xfd_hw_tef_obj {
 /* The tx_obj_raw version is used in spi async, i.e. without
  * regmap. We have to take care of endianness ourselves.
  */
-struct mcp251xfd_hw_tx_obj_raw {
+struct __packed mcp251xfd_hw_tx_obj_raw {
 	__le32 id;
 	__le32 flags;
 	u8 data[sizeof_field(struct canfd_frame, data)];
-- 
2.35.1


