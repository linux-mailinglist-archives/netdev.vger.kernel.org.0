Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6D755DF24
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiF1LQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiF1LQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:16:23 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052932D1DE;
        Tue, 28 Jun 2022 04:16:22 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o16so17202242wra.4;
        Tue, 28 Jun 2022 04:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=khKbGoD/EsCCSptEY2l7mXv0XjlFAynzPduQhYuFFhI=;
        b=qfaJW/EmJ4YwhHlj2/AFKWE4FYfUYGz8TJQVOXiBK/of0V9uYRiex1uKba3zt/lwCe
         PVyT0aof9JJD4IJu/Kivg0ppXcweF+WBwMrsKB7+2JnJ29cR1Wewgwq5Uct+FUQvVC3m
         5cLD6UhXTBL8iH61R8itHfH3VzV+WRGPs9WepefdD1IZJUtEvVSgEuP2DTmbedKJO8UW
         kZJ7VN9RrZPMEPCgoSooKFCStaVHMK5SwPmKr67hFUV0FNEziS8hLUU14vzJndJf7BSo
         klRiPjyuReJfs/gXsTgyK1SqLBA0znUsoIopu/UgpPekyO5MYCuWzbG9JLfMz1Jycb5y
         tgzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=khKbGoD/EsCCSptEY2l7mXv0XjlFAynzPduQhYuFFhI=;
        b=yJgkGEAzxveU6ZDntDgFVcmH2xzcjF6OWZer6nrAoKtqtoBzkodH7a1ujDh011alDr
         3Kwnfa0zKesPaJIT3wyPL49a7eYav3GHSGVrDIVkTRQRTSXBBcq2oqiQ71zDYge6h2bW
         c11wspTB3H0/3jEsQ+dwGookCXGn0slnarYmxIqMa82MLS2hqn5jgzJWFhhR5wikBIcz
         zVDjxv0SSUo8FYohXPw8vUuzgvLPELk1og4b6escyux6qq6ipXeUwjCtH89qPBf89nXL
         QQr1h+w3z2UqXDNszICQsMjQ6Myk6SjYM1wuVJkCagaoGB8GYV7HDxRNradqQ6EX2c4l
         hwbw==
X-Gm-Message-State: AJIora8gUvu78AD0b/5rMLpgCGjNCSq0A9w6oxsNUW80FLewbSQAPnks
        GdonAL2VrE4kjOzaODQqJjbHKP7v0EtZtQ==
X-Google-Smtp-Source: AGRyM1s2gS1+xR/Q7VDKrY0SAQhYxZhlWh7z8FX4wUlDAxJHqo883Lkso09hiOzc64pgGSjFaRVyFQ==
X-Received: by 2002:a5d:62c4:0:b0:21b:c031:a94b with SMTP id o4-20020a5d62c4000000b0021bc031a94bmr14878911wrv.624.1656414980558;
        Tue, 28 Jun 2022 04:16:20 -0700 (PDT)
Received: from cfernandez-Prestige-15-A11SCS.. (136.red-2-136-200.staticip.rima-tde.net. [2.136.200.136])
        by smtp.gmail.com with ESMTPSA id c16-20020adfe750000000b002103a7c5c91sm13152649wrn.43.2022.06.28.04.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 04:16:20 -0700 (PDT)
From:   Carlos Fernandez <carlos.escuin@gmail.com>
X-Google-Original-From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mayflowerera@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Subject: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before offloading
Date:   Tue, 28 Jun 2022 13:16:17 +0200
Message-Id: <20220628111617.28001-1-carlos.fernandez@technica-engineering.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220524114134.366696-1-carlos.fernandez@technica-engineering.de>
References: <20220524114134.366696-1-carlos.fernandez@technica-engineering.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When MACsec offloading is used with XPN, before mdo_add_rxsa
and mdo_add_txsa functions are called, the key salt is not
copied to the macsec context struct. Offloaded phys will need
this data when performing offloading.

Fix by copying salt and id to context struct before calling the
offloading functions.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
---
 drivers/net/macsec.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 832f09ac075e..4f2bd3d722c3 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1804,6 +1804,14 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	rx_sa->sc = rx_sc;
 
+	if (secy->xpn) {
+		rx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+		nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
+			   MACSEC_SALT_LEN);
+	}
+
+	nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
@@ -1826,13 +1834,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 			goto cleanup;
 	}
 
-	if (secy->xpn) {
-		rx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
-		nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
-			   MACSEC_SALT_LEN);
-	}
-
-	nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);
 
 	rtnl_unlock();
@@ -2046,6 +2047,14 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	if (assoc_num == tx_sc->encoding_sa && tx_sa->active)
 		secy->operational = true;
 
+	if (secy->xpn) {
+		tx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
+		nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
+			   MACSEC_SALT_LEN);
+	}
+
+	nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
@@ -2068,13 +2077,6 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 			goto cleanup;
 	}
 
-	if (secy->xpn) {
-		tx_sa->ssci = nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
-		nla_memcpy(tx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SALT],
-			   MACSEC_SALT_LEN);
-	}
-
-	nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(tx_sc->sa[assoc_num], tx_sa);
 
 	rtnl_unlock();

