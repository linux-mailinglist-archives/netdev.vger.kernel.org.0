Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A9051D60C
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 12:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391089AbiEFK7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 06:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391083AbiEFK7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 06:59:30 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818A72125F;
        Fri,  6 May 2022 03:55:47 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 125-20020a1c1983000000b003941f354c62so4157796wmz.0;
        Fri, 06 May 2022 03:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MiSdeuIWfJPHE02m0fnyecGEq/W7GHoLUnL16Dqju/k=;
        b=O8AiPdJT+IpJW26Bu8XAWVpVSaAlhbrZFBrtU+xNmuwUr4z1n8Lfo6Dez6JVnSZw3Y
         DxWZ4k6zHHkAJEcxm6JD/DDTCgxzFNYgS58zRKlxeA7m847yL2L3xbbAzroPPUs8GzqY
         fs+IxV//2pSRjBIi7U8swFqMqqdCCAELT2GdQ2cM6DMtR+RIvnj6fCOj+Rdi/JoEcczG
         Yj1a9XwCoNBRUvfoiM+ri2YeEUeo0dqXtI81vLA/EcfBK3b5vUNcycqchKbRTBCf9Ofj
         rO9Fj7sp+30szZzKD+WLNZmFM7/CxqFppkdO4PJ2M41vn9KLyE2IeOC6SsVAWb3DBfSB
         LrbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MiSdeuIWfJPHE02m0fnyecGEq/W7GHoLUnL16Dqju/k=;
        b=kj9NI4TydtUbbP9o3n0+OD1ANi3l0sPjjv50onGdOCkRwbNjNPbTAqQVQj9D0l/QdM
         9b77KbxA1F0tOgzEozrsbW3LhbORXq7QFFouOtHA9Urht0VdRvfe900QJwwc8OCoQtVA
         suwXjxjjq2cUBGXyEXAvJO7m1KExdyjhXeWDpoIduUw8kdBDx7uhUPomRC5jkYzhaPfG
         77wDpdLEqRDTXUKcqEyqzRVg2irfnrGDSxIw3h9C3bn39K7H5iXLfI57M/wtT7dawIxl
         U497Tt/poaKO7FsHRIuCOV5U7qkZucMpJLBbdHC7nWaO9NXkHlVyGgxnL/WPxaIldUQM
         +JDQ==
X-Gm-Message-State: AOAM531cDTb3jgRWcrjoHfF+VfupWgqJm/lH35h42vIMArpr0fXA9rjH
        usJu/JCtclDNzWrKKqtI1IU=
X-Google-Smtp-Source: ABdhPJzs0oMneS1c0XF1SbfGLq5qEyW+UjmnghBw+Zmpjr3zONou2rvHLl5fWk56j7LojJpw5Rsb7g==
X-Received: by 2002:a1c:3b54:0:b0:394:3910:3c7b with SMTP id i81-20020a1c3b54000000b0039439103c7bmr2710106wma.3.1651834545983;
        Fri, 06 May 2022 03:55:45 -0700 (PDT)
Received: from localhost.localdomain (52.pool85-60-27.dynamic.orange.es. [85.60.27.52])
        by smtp.gmail.com with ESMTPSA id l13-20020a7bc34d000000b003942a244ebfsm3771969wmj.4.2022.05.06.03.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 03:55:45 -0700 (PDT)
From:   Carlos Fernandez <carlos.escuin@gmail.com>
X-Google-Original-From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     pabeni@redhat.com, carlos.fernandez@technica-engineering.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: macsec: retrieve the XPN attributes before offloading
Date:   Fri,  6 May 2022 12:55:40 +0200
Message-Id: <20220506105540.9868-1-carlos.fernandez@technica-engineering.de>
X-Mailer: git-send-email 2.25.1
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
