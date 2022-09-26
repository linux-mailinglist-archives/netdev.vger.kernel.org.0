Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089355EB361
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiIZVoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiIZVoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:44:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27277A260B;
        Mon, 26 Sep 2022 14:44:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5E4C61387;
        Mon, 26 Sep 2022 21:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB347C433D6;
        Mon, 26 Sep 2022 21:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664228642;
        bh=l/lWJrT4cHiOPDK7ygIeGv7vATX25bNh8bpEBLU1M/w=;
        h=Date:From:To:Cc:Subject:From;
        b=dHWzkwPfoc2i2YpAkIG5D2BDig+nx/fYd4f/IQrpYPFIpvruiuOk81hfIKJkGwdEL
         Pyg3Oa3zG8VIvPBQDALhZ8OkDPekTW9kcFGK3xWmwsQdwOjkz775V7bSDkOuOmAIH1
         EL92Jut+cMYQUBRd8UgjrCbQSZ6eBP6naEC9dd/2h15dF8S11kUeqIShFtQMV/ftxy
         wu9ijQqg6HdX0J6UTL6zQudoK2brincVUaAeuIgj12CpY9rOBOljabLrUftrFShKkJ
         0NyEjF605JhLBX7RFBd0CocLPP1BOdDhOCaJoQdfdAj7oy9+pZ0wDl72NINYMDo8KE
         dPyIesWa6qtcg==
Date:   Mon, 26 Sep 2022 16:43:56 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] can: ucan: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <YzIdHDdz30BH4SAv@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members in unions.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/214
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/can/usb/ucan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index 7c35f50fda4e..b53e709943bc 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -245,7 +245,8 @@ struct ucan_message_in {
 		/* CAN transmission complete
 		 * (type == UCAN_IN_TX_COMPLETE)
 		 */
-		struct ucan_tx_complete_entry_t can_tx_complete_msg[0];
+		DECLARE_FLEX_ARRAY(struct ucan_tx_complete_entry_t,
+				   can_tx_complete_msg);
 	} __aligned(0x4) msg;
 } __packed __aligned(0x4);
 
-- 
2.34.1

