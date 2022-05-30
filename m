Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091A4538142
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbiE3OSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241413AbiE3ORe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:17:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6CD559B;
        Mon, 30 May 2022 06:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ABC960FD4;
        Mon, 30 May 2022 13:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEB7C3411F;
        Mon, 30 May 2022 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918398;
        bh=4FSrYTcjJKXPVdDoyaJUWxXh5uWevkD+L6Qli9rjWgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrjrfzxjFNl5zwZbxgg/sUuemVB7evbnl9GRKOUxpibKtfXeWq8xKjOZJmPKW2N+k
         1PzALp4KErEHkw0e0Z4glyboJMsoZnP/H5AHPYwB8wOknbFH+snxHs1vQiBSPl2juB
         uOM8ASIcRk5UKoYaqQV8+taP/PLumT/MrK9Ezzn0YpEUW9TnR0KS0hSm710Rncf3Ub
         Bd2ZOUyKVUP4I31dRAmXxp5ylfbdUxZBbHQyfpKXSJDL9d085j0MzRPJElT+xx2zrS
         Id/QlIb4vtc5SGP8mepuNJgLnIdFU2Ge90DKBp8tfQdsZk+YCKsYZRaLtiGfhXwpEg
         LuzamxuTxnbWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ndesaulniers@google.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 67/76] can: mcp251xfd: silence clang's -Wunaligned-access warning
Date:   Mon, 30 May 2022 09:43:57 -0400
Message-Id: <20220530134406.1934928-67-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 1a6dd9996699889313327be03981716a8337656b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index fa1246e39980..766dbd19bba6 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -426,7 +426,7 @@ struct mcp251xfd_hw_tef_obj {
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

