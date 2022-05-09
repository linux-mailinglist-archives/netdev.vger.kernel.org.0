Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5649520347
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239680AbiEIRLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbiEIRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:11:50 -0400
Received: from smtpcmd12132.aruba.it (smtpcmd12132.aruba.it [62.149.156.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F080D17B879
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:07:50 -0700 (PDT)
Received: from localhost.localdomain ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id o6rMnQWIJPF2eo6rMnMWqh; Mon, 09 May 2022 19:07:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1652116069; bh=YSzghGkQG9IKiyCgShp4fjbw3t+wnbGnbQfbUoit2jU=;
        h=From:To:Subject:Date:MIME-Version;
        b=mb+Y0WbL2esxB/k87IeigpvmKVCPCOUSibSYskH4Vrl/zg1YAbNnqkvwWhsUh6ntw
         Wt1SbNQ24TbgDQpGtk+ifHdfkrjfeGPKjDApAuwWtZ/4M4gaMytlwIeVdfcTjxl4uO
         rsAcQIftZK1FmTgLDnanAu8AOwFzEEN269BKz/JPeX5iocuSZDofIbg9cX6g0RLj+1
         mTNFTiQKkS69KoZNOl0Vk/ddKkWAfIxG8+ORd4554b8l8cqPxuXULnXASW4OI941v4
         Zfr4MaCYpwmL4EuY2/8nqzlRIiiFJyK1OrODFWak9xlKzr0qyMRIjcwbmBTRtqVVVB
         JySAh7Eah8r1Q==
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Subject: [PATCH RESEND 1/2] can: j1939: make sure that sent DAT frames are marked as TX
Date:   Mon,  9 May 2022 19:07:45 +0200
Message-Id: <20220509170746.29893-2-devid.filoni@egluetechnologies.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509170746.29893-1-devid.filoni@egluetechnologies.com>
References: <20220509170746.29893-1-devid.filoni@egluetechnologies.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfF2xFHXIDDCHho1rSwAjnvHsr7MldqGXEXI/b06PUrL496M8myXTv1OYev0GlY3MhHta2oerXL+X3ejE9wxBNBRWHhDg8gnJeBe6Zt7lbA5xl+qb8WJy
 9YS6eDR+qU4jExyX2T4gcH9ypA/BfT6VQ2lMPcM36m2QGW9CACGUemajuzJSsjqAOcnVH8+nN0X9Gf2z5Srt6/Pz21IVh2pwa+FP9HqX42SkYml+IQb2a4nE
 TN5WNQWGhzDrA/XN18oCuHdfd4O/ZJkwAzfJ0EqMsrFiFAC+Yi3+6FMahBz7aCV/Q6UnUPaOhucYZ3ZrFFC1n1FZj9wf6vuqsw67eu4y5a+PQ2mnP6HMbDSH
 E5xsrS7JqJmRG7eIjt0cJt0sTpOIS8heGcVUYiK/s8XlFW3b3CTd1KCaJ3FNcdYysR45qknJoFdBvguIkYTmiRp/js/y3g+NrhJZ3y9K5n6F+tGcvx8uKECh
 mfkLbaagIFG1o2AMXEJbpcjRs7OW0NQgEa58XvOMFOWicByCMoNfwIkNEXWHmLS/ZsE3JWcteS2o5xVwvwrJhGVNSbFJgVHBQLJYeRIncxK4O56sJ3pM7f6A
 hqnDgp09+rSA8OTzkWjgyIQXKon7VQDf02RMToDorF6lK9eyB19MKbEuXNC8f4wJUXIPRSCTGR7X/ZIsBy2hxuQe3nn8gFXOSbrssuXC/MyXTQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 9d71dd0 ("can: add support of SAE J1939 protocol")
Signed-off-by: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
---
 net/can/j1939/transport.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 307ee1174a6e..030f5fe901e1 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -621,18 +621,30 @@ static int j1939_tp_tx_dat(struct j1939_session *session,
 			   const u8 *dat, int len)
 {
 	struct j1939_priv *priv = session->priv;
+	struct sk_buff *se_skb;
 	struct sk_buff *skb;
+	int ret;
 
 	skb = j1939_tp_tx_dat_new(priv, &session->skcb,
 				  false, false);
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
+	se_skb = j1939_session_skb_get(session);
+	if (se_skb)
+		can_skb_set_owner(skb, se_skb->sk);
+
 	skb_put_data(skb, dat, len);
 	if (j1939_tp_padding && len < 8)
 		memset(skb_put(skb, 8 - len), 0xff, 8 - len);
 
-	return j1939_send_one(priv, skb);
+	ret = j1939_send_one(priv, skb);
+
+	if (ret)
+		kfree_skb(se_skb);
+	else
+		consume_skb(se_skb);
+	return ret;
 }
 
 static int j1939_xtp_do_tx_ctl(struct j1939_priv *priv,
-- 
2.25.1

