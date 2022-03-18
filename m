Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968CF4DE17D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240273AbiCRS63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240279AbiCRS6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:58:22 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF480232D3D;
        Fri, 18 Mar 2022 11:56:57 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EE046C0003;
        Fri, 18 Mar 2022 18:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647629816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0VBTWFnPt10DhCOjE82lW1MDcj14jZmYXZWn9//SL0M=;
        b=EZZhdBWnA/c3gGpg8ExPsmiyktDNhQ2j4f+F2cUN8U3vrX44Bmh5/LNgxbz0BPWyROZyCc
        1kNqMJbfgJOsUimgEJxFKtrpoZejh/NstvhoEo4k6BE7Fs2exaLg3ElvNKfT5iee5qzQJj
        iEIZVCz54VSh5NiWza8dmA9P4p95U2XYu2SPCfUGyCEUwM2jUFnEDVnvzjST+vvYvivUFS
        p7KIsLKiuN03+elg5TE7c/tz4L7NtjyrzVri5Nh8fXDpUX5sWrwuliBkk3OVr9znhMegGn
        ziowKYXPFIqTvlMDVDpM0QALru2UPn/PR213v57vldtQvQfk+raz6Cg02Y6srw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v4 06/11] net: ieee802154: at86rf230: Error out upon failed offloaded transmissions
Date:   Fri, 18 Mar 2022 19:56:39 +0100
Message-Id: <20220318185644.517164-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318185644.517164-1-miquel.raynal@bootlin.com>
References: <20220318185644.517164-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's parse the TRAC register in the Tx path in order to know if the
offloaded transmission was successful. If not, let's return early with
an error code.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/at86rf230.c | 10 +++++++++-
 drivers/net/ieee802154/at86rf230.h |  8 ++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 8a03722cd1f7..d3cf6d23b57e 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -660,8 +660,16 @@ at86rf230_tx_trac_check(void *context)
 {
 	struct at86rf230_state_change *ctx = context;
 	struct at86rf230_local *lp = ctx->lp;
+	u8 trac = TRAC_MASK(ctx->buf[1]);
 
-	at86rf230_async_state_change(lp, ctx, STATE_TX_ON, at86rf230_tx_on);
+	switch (trac) {
+	case TRAC_SUCCESS:
+	case TRAC_SUCCESS_DATA_PENDING:
+		at86rf230_async_state_change(lp, ctx, STATE_TX_ON, at86rf230_tx_on);
+		break;
+	default:
+		at86rf230_async_error(lp, ctx, -EIO);
+	}
 }
 
 static void
diff --git a/drivers/net/ieee802154/at86rf230.h b/drivers/net/ieee802154/at86rf230.h
index fbdfb705c7a3..042bb27287a3 100644
--- a/drivers/net/ieee802154/at86rf230.h
+++ b/drivers/net/ieee802154/at86rf230.h
@@ -208,5 +208,13 @@
 #define STATE_TRANSITION_IN_PROGRESS 0x1F
 
 #define TRX_STATE_MASK		(0x1F)
+#define TRAC_MASK(x)		((x & 0xe0) >> 5)
+
+#define TRAC_SUCCESS			0
+#define TRAC_SUCCESS_DATA_PENDING	1
+#define TRAC_SUCCESS_WAIT_FOR_ACK	2
+#define TRAC_CHANNEL_ACCESS_FAILURE	3
+#define TRAC_NO_ACK			5
+#define TRAC_INVALID			7
 
 #endif /* !_AT86RF230_H */
-- 
2.27.0

