Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA58E52B632
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbiERJCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbiERJB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:01:59 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465831CB21;
        Wed, 18 May 2022 02:01:58 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u27so892252wru.8;
        Wed, 18 May 2022 02:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FYpoKEm2ZNoR6LpFioWoDJ+UH6AtMYPHN9gRTWCmXRo=;
        b=c+9A9KkB5oL0xK8g54RNTAZAH0OKfV/9jnI+3Afdk02zCLSoL97w07nhwvK9F4ykqr
         scODxa/81V6Bz8ajeoHd0uvrMh1qDBblcNOYgBsxJDrAyW0sCwDODGoJfNjxYSmQaFXX
         sQtG8DtSqQFxCFIUuoi2z3GGNm5Uk56eyjakHvUM9yQxXf2VV0fbI7FUzBi2AtiyFIDK
         fHJUL7cfvHcKIYr/jra+sFGcqxboIF31VgtOZsL8wp6E7k08tnZoGBC9saRlHoj6jVw5
         1a+pZPMFoMdzL8q7yCjJQhQQempAQPrbELVrfo2oRqQI6hLQkdAeJ10vebRmsowT3D9f
         r96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FYpoKEm2ZNoR6LpFioWoDJ+UH6AtMYPHN9gRTWCmXRo=;
        b=VXeNL4c3JfUwYn6tjF9WegxKLwf9sTBMNA58reck/x8Hv5BaC0cxbfDuJSrVPVBS0K
         WliNYbXTokLopjpopGNmdbh05OEafWpzdDIb1V6fnRsfenm8wn1tX2Fj9re8MizaKf2s
         NBRaexKLIrqIarVUhuxf2lZ8wlQV8cOtQNF/VBFwOnskDI79qjOUBXd3iEv+m4Zaxia8
         w+ugPWSj2shzLbboKBkPntcIy0H1u6ILMHCiY0/tfG8uaFin2CHjRA3IxE+yXjf+12Bz
         TFX0h63Tm5kTeeuQWGMrYKExezhroxhuo5nPWcHuVPNSq8IcLkBksh4Ftb9VH3hOZChM
         c3PQ==
X-Gm-Message-State: AOAM5307dFakwZIQR2JaPEcXM1eRv/MSrviPVT6JipewrcJxpbnRnWym
        ZmaHM0GTBkuMOnhSS2sPogE=
X-Google-Smtp-Source: ABdhPJyLif867YDr+QtvVcgmW5cd0duj16GklB9NIxCvEhQomlvNnSh9GcjK2Nw3oZDzrAyDqgAURg==
X-Received: by 2002:a5d:680b:0:b0:20d:932:8d55 with SMTP id w11-20020a5d680b000000b0020d09328d55mr11952553wru.389.1652864516810;
        Wed, 18 May 2022 02:01:56 -0700 (PDT)
Received: from localhost.localdomain (52.pool85-60-27.dynamic.orange.es. [85.60.27.52])
        by smtp.gmail.com with ESMTPSA id o3-20020a05600002c300b0020c547f75easm1606124wry.101.2022.05.18.02.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 02:01:56 -0700 (PDT)
From:   Carlos Fernandez <carlos.escuin@gmail.com>
X-Google-Original-From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     pabeni@redhat.com, carlos.fernandez@technica-engineering.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] Retrieve MACSec-XPN attributes before offloading
Date:   Wed, 18 May 2022 11:01:51 +0200
Message-Id: <20220518090151.7601-1-carlos.fernandez@technica-engineering.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220518085745.7022-1-carlos.fernandez@technica-engineering.de>
References: <20220518085745.7022-1-carlos.fernandez@technica-engineering.de>
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
