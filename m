Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C41153298A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 13:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbiEXLmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 07:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiEXLmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 07:42:17 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D22F5FA4;
        Tue, 24 May 2022 04:41:52 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id t13so6131046wrg.9;
        Tue, 24 May 2022 04:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=khKbGoD/EsCCSptEY2l7mXv0XjlFAynzPduQhYuFFhI=;
        b=g4rypx58tcbIeZ9dEoOu2IhAZzA24PypYCuawL6zV4oCNrYLp843cXL2yyPCkSDOlr
         u73LEkBku9I27+kai2WdDvydOM02xTgSEHtdQiBB8cMaRF4i2k3/i0at9lo2YX6EdwM6
         dsaQt8bxMg7h4ncDPzMRVp+QZqz4qzS1o9tQty/mVdTV6/VUyYQl6yzO6uqjUa6sy/EA
         npQ+SlbWG8CwlcpTEJ8TEx1ZJWseftntXdq6x9png5H1NOQacBtYgv2qR0X7YPMJTAJt
         fzVPko2mmXIpMVuDuIfh1MVpOb+3U9Bumdr0tmpJAwUl/Wjf2jWpBbZtIAnqOpM6a0e2
         Uaiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=khKbGoD/EsCCSptEY2l7mXv0XjlFAynzPduQhYuFFhI=;
        b=S/XR9wcs+X2q/mNXSNP2BxFGybjYgkLEqvmrOuLxEyj0iSHZu2gODIsmVfgg1h4rRZ
         YNV4DW5sAxeEJhEmQO/ed8+9Y5eD+PwPbUcNieTVIrloibVfgMAQlupf5Jwr8pOD+9RY
         k2pPaI9Bei6CKphb34rYtgvl2hwl9dYL2DgusqJiAIlO90miVaUOHkoZAl0GJxPxofq3
         HDfOjcWg9LXEjMzuLJIEEDOAJMI46CyqsTmBIt9zvnYPqjx4OgTQrOMZ88MZsriuC87t
         MKpwqigregDRVA6PeAsduh7HojgMbmE83bZVrBxLr8XCRt6BXmKEmUrRd9ua70jToGa/
         XrCw==
X-Gm-Message-State: AOAM5313uKdPglllhmEoPff3KQ8UDzLW8BVyO/81VXC7BKMMZnYFIyPw
        i3RsGtl/c1lM4B9HxmUrAKw=
X-Google-Smtp-Source: ABdhPJyBzPrEpB79+6FRJBOs3wpbfTH40+snxRZ1qJdAZORJ2XiqGxa0U/v3zuus44a6stFNFBdrxQ==
X-Received: by 2002:a05:6000:1608:b0:20f:f5ca:9985 with SMTP id u8-20020a056000160800b0020ff5ca9985mr1577690wrb.340.1653392505451;
        Tue, 24 May 2022 04:41:45 -0700 (PDT)
Received: from localhost.localdomain (4.red-83-50-171.dynamicip.rima-tde.net. [83.50.171.4])
        by smtp.gmail.com with ESMTPSA id ay3-20020a05600c1e0300b003942a244f39sm2128396wmb.18.2022.05.24.04.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 04:41:45 -0700 (PDT)
From:   Carlos Fernandez <carlos.escuin@gmail.com>
X-Google-Original-From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Cc:     carlos.fernandez@technica-engineering.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Era Mayflower <mayflowerera@gmail.com>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before offloading
Date:   Tue, 24 May 2022 13:41:34 +0200
Message-Id: <20220524114134.366696-1-carlos.fernandez@technica-engineering.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
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

