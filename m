Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0C54CE486
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 12:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiCELW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 06:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiCELWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 06:22:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FD54C789
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:22:04 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646479322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WZOt6spQRcdebq/mtE9uDiTLJIwxzfTlt+Y7JO6aRms=;
        b=j+XZVfex0HCqPgGUqE3RkfXAh1px2VN/yRNNMvyezAd/IFdSihNmbSrKLlFEcU82iA7QPi
        esnfeLP4YzqapZ/rhZ0JL5NbJWnDHfm7o9GQuT2t3RGSgdZvS5/9WjxQluETpoT289DjOG
        QNUujrPPzP2sBDlByXqZaP2t77LAQja/9EJQvaNSJLpKm7dT3rNCvekN7xHyqR64FyReab
        btc5FcQYHD9OeEG6kXF5/yK1xYep6ixN+ONK203W8D17JVpjnwSPKhdztMYesYf02EAYZM
        J8L+6n2fhWrJuSiTWO5oN9l3fjQ5Ajz8NaVdS/5tJQ+x5JhNMcWq/FdeX1uc5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646479322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WZOt6spQRcdebq/mtE9uDiTLJIwxzfTlt+Y7JO6aRms=;
        b=jkDYF/hKURac8vP8oJhSeB2tVsDQ88QMev7ROIMNsY47OcKZH86ho0bgtuzcO+7AhGYdj/
        iHEzT0aRdmNcg5AA==
To:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 3/3] micrel: Use generic ptp_msg_is_sync() function
Date:   Sat,  5 Mar 2022 12:21:27 +0100
Message-Id: <20220305112127.68529-4-kurt@linutronix.de>
In-Reply-To: <20220305112127.68529-1-kurt@linutronix.de>
References: <20220305112127.68529-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use generic ptp_msg_is_sync() function to avoid code duplication.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/phy/micrel.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 81a76322254c..9e6b29b23935 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1976,17 +1976,6 @@ static int lan8814_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
 }
 
-static bool is_sync(struct sk_buff *skb, int type)
-{
-	struct ptp_header *hdr;
-
-	hdr = ptp_parse_header(skb, type);
-	if (!hdr)
-		return false;
-
-	return ((ptp_get_msgtype(hdr, type) & 0xf) == 0);
-}
-
 static void lan8814_txtstamp(struct mii_timestamper *mii_ts,
 			     struct sk_buff *skb, int type)
 {
@@ -1994,7 +1983,7 @@ static void lan8814_txtstamp(struct mii_timestamper *mii_ts,
 
 	switch (ptp_priv->hwts_tx_type) {
 	case HWTSTAMP_TX_ONESTEP_SYNC:
-		if (is_sync(skb, type)) {
+		if (ptp_msg_is_sync(skb, type)) {
 			kfree_skb(skb);
 			return;
 		}
-- 
2.30.2

