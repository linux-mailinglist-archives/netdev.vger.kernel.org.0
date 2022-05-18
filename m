Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C7C52B579
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbiERI6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbiERI6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:58:04 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23D511E1F8;
        Wed, 18 May 2022 01:57:51 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j24so1722451wrb.1;
        Wed, 18 May 2022 01:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=++E55hZspdAJCzLSvywdQwQZHF/X7XZ809bGoexAor0=;
        b=TbEBnTQyjTjmMJGUkj0b1r7ZVmt/I8cv3MPj5q2tE98vHgWKXx9QWyMUCkHT1KADXj
         d44XzQdhEK2uz1FDpC7AQ+xMZyNMm7KsEiatXddFjP91uxdA+23xn+Cp9RNnVryUz6n2
         6x0CnwddbxOriaiZQpw6qkTwhYgem6uPeAtDhpj5fdSyVYVsL5Rz4f5TnkYR99z9Frc7
         uAih2nnl+Ueen9DTcmxLiEkY+wIKsNW8uDkIw0Ay9gzF19042wua5mJC1Al3uwLr5G//
         FX1Wggd9aCTQuo5xSinFo3owiJp4HbS1S9JKqRupXECVQk/+08eb3+N8z34TVfLX5X9/
         N5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=++E55hZspdAJCzLSvywdQwQZHF/X7XZ809bGoexAor0=;
        b=dKxGuOBT/kgvVttlCG71RI5zJvDAFrHbi3fCnzkDq80WVV/HWe036Hzaj7AaQQb86d
         m9WM28Io3xKQhASi5LOd7OsrcTihL1YCjeqV7/SFs5r6xgbnUtvC/2ozZW76xG+R8XN2
         2qtLS5Ef/Iw+hdzHwBic3HHYX+YiXAPgFRxGYdb+IKsCCMeBETufHbPGJ9pie9LKu74w
         OgWUlfqsg2kfCYguLuBExGpJVEZsiVeFYpdwfR3V1Udu57PSnVPrZQUdRNspEXSPNFv3
         WkeMHpK5EJjZcvIX18xXjE9N8xu/rVCxXTA9AYr/lgZ3wHm4BHxwPlYXwnt9xt0taL5h
         x/4Q==
X-Gm-Message-State: AOAM530Uuz5AWGkuQ1EmwE31VcObCHI4Kz5nZDEyd0rzAegxyPs3Qd4f
        QyEuo5DmsQ/XMomU//rMRp8=
X-Google-Smtp-Source: ABdhPJyf8iGn1AjGKhe2Bk+FqNmSXn1bIBjrmjHO9QH4qwtHNlMhe+/NgIr1/THeuCi7eCetcKw95A==
X-Received: by 2002:adf:eac9:0:b0:20d:cdd:a719 with SMTP id o9-20020adfeac9000000b0020d0cdda719mr10296156wrn.0.1652864270017;
        Wed, 18 May 2022 01:57:50 -0700 (PDT)
Received: from localhost.localdomain (52.pool85-60-27.dynamic.orange.es. [85.60.27.52])
        by smtp.gmail.com with ESMTPSA id bi22-20020a05600c3d9600b003942a244f33sm3742630wmb.12.2022.05.18.01.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 01:57:49 -0700 (PDT)
From:   Carlos Fernandez <carlos.escuin@gmail.com>
X-Google-Original-From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     pabeni@redhat.com, carlos.fernandez@technica-engineering.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] Retrieve MACSec-XPN attributes before offloading
Date:   Wed, 18 May 2022 10:57:45 +0200
Message-Id: <20220518085745.7022-1-carlos.fernandez@technica-engineering.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506105540.9868-1-carlos.fernandez@technica-engineering.de>
References: <20220506105540.9868-1-carlos.fernandez@technica-engineering.de>
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
-- 
2.25.1

