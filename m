Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932C3516F78
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 14:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384994AbiEBMWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 08:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377770AbiEBMWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 08:22:13 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30007167C2;
        Mon,  2 May 2022 05:18:44 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b19so19317746wrh.11;
        Mon, 02 May 2022 05:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WIpumGU76fy6Q2rBLSbndwpcAjiNC5TWyx8e5ZMdPnE=;
        b=evPU9kZc+kl8DmkB++3DrVzHNnWpvCcv3xgSFZWN4TAaca9s5v8yeHA7QUGkY+82KP
         Or6M7B5IRhMSU0U0PueN5isbBtKW/nMDBprsiZBsCBFPgWSpuPq45LeAD6CLPjHdxzQF
         grtOHgKV37WkwbImfp39ckNy+kiaBcLOiatwWeV15RmsXOPOJlEWjh+C+CRi/95hFy+D
         C1kPObEArsGGJUUCPMrEorCt4fx+JVSJwm1/OnLfCYjOMhi65yBt8JNBH25akETAfdvQ
         1/nSr58mVhSwF43QgdnuFFBkTgbdFkmlCu8WtQKLO4mNdoHFUHFGPPvQ0BfMPGrZz2WN
         6Y8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WIpumGU76fy6Q2rBLSbndwpcAjiNC5TWyx8e5ZMdPnE=;
        b=X/7qrnRW5U6gf7UA+Lr6KP1zWHpFGc9puf1nSO4JzEnHVo+PXAwcHdopwXnvubLobJ
         L9tA0kwJ1lSdCATNAuC6R+eexcUXN0XHB/YExYWwzYeuvfanAo5Y3YeSaD0asCNLm73U
         ymuE4cM1x7ZRNDIcp3a9mZoVIzNuVZsl5hskCWvQsLQ9XopD4e9Y94Hg8SfWr5woEZuz
         WTOo9eYiuniantIcSP+FfHoYvrILpJX3qEeKy8yWocTmfkxisysQ+/yEfwBP5Dv8iLVA
         Yr/BFidNtD/NuN1LGVBUpHyXwxL9J6qhzTrCtUiHi7Xfv6low/CE8mxceKiCxuNcp4SP
         2DPA==
X-Gm-Message-State: AOAM533ISRkvrxCJjUSnU5RBlm6ylLrJz1IjVGkZNdETDCHjklNBzjZQ
        vtKKp7M9Y5b991114rW5//s=
X-Google-Smtp-Source: ABdhPJyA0/kauL5QWKC6H0F5Dm2JIe8dgNGtwHS7He4LpNNd/92sk2Fc0fQ5E+ACG9QMf51E3EvxpQ==
X-Received: by 2002:a05:6000:2a3:b0:20a:ef18:a09a with SMTP id l3-20020a05600002a300b0020aef18a09amr8991747wry.588.1651493922691;
        Mon, 02 May 2022 05:18:42 -0700 (PDT)
Received: from localhost.localdomain (52.pool85-60-27.dynamic.orange.es. [85.60.27.52])
        by smtp.gmail.com with ESMTPSA id l7-20020adfa387000000b0020c5253d8fbsm6930335wrb.71.2022.05.02.05.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 05:18:42 -0700 (PDT)
From:   Carlos Fernansez <carlos.escuin@gmail.com>
Cc:     carlos.fernandez@technica-enineering.de,
        Carlos Fernandez <carlos.fernandez@technica-engineering.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/macsec copy salt to MACSec ctx for XPN
Date:   Mon,  2 May 2022 14:18:37 +0200
Message-Id: <20220502121837.22794-1-carlos.escuin@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <XPN copy to MACSec context>
References: <XPN copy to MACSec context>
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

From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

Salt and KeyId copied to offloading context.

If not, offloaded phys cannot work with XPN

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

