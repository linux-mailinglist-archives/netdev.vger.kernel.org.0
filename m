Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C64851BF94
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377422AbiEEMl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377291AbiEEMlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:41:49 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F6D554AD;
        Thu,  5 May 2022 05:38:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id l18so8451114ejc.7;
        Thu, 05 May 2022 05:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/Dde4UNfL6ypJvuFq7SbKuCVgXOqEoZbvuwh4Syunc=;
        b=EHYu39dg1X6wSQygmCU6TlatQ8i/+/wXPb6+zlpywyhl44xvgS84FY+9a+m/J/8twQ
         5tX2YSrlDMzbGN5/7QoDUqjnrZpJxsoZy5fOmUnHsVEYuqKNVt1Yo74NmNlIR5UgwkaR
         4RySGhKkMfPO6Ojr5tYnxxLv7ONUhfDgPJInuYfhblbXQCVoTzWZNU37Slg/+Pj73MKz
         isrP21eizd8oX/Ru4Z8u2mIguNk+xM2tOGaK7dMpiPAkycb4Qq0orGQzH3rPrWwtcC9Q
         gwcIxCVH2agcTXlY4bfXa+V3Ti7M7nw8+Moioc8Lpj31XnH9jPnzpd7MY4G01pjRV5HW
         ogXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/Dde4UNfL6ypJvuFq7SbKuCVgXOqEoZbvuwh4Syunc=;
        b=UTULfZMDdoCV23cfPip7WImZ9iiD+v0QzgbA34RQ5xx9RBkY71p1jGKO2gwPgzadaU
         AGOX3NuvRFJ1H7CIs5GsQs2N42GFBCGCluq0jFaXl2GiiX9kxQ+BhkyDaRREzOBv3Aan
         SOmNj0enMLYJz6a1OGpHpBvd1GhcqW7Ng4/FuWvzajnFsjzdJ3ETKm+RQ63sVwryJimA
         MbJSSnzdqNTLV5lBlpjK14+feP/yWhacxVCIfSNmWhZnoFO8C3eCurr6tYnHl6hEZamH
         jHJqtlD6Uq8+sRtBlqWatRyez7Dj1zBIRZtstYlJd0vjlt2LXOLfAeSg69A9DV+0csAm
         P2ZQ==
X-Gm-Message-State: AOAM530yf0NtoiC7AD9y2hXbR0KDEFqifig6+y4R/cVCkQ7+NxjCuHLI
        s5T4MPPiFtSIOSuQ8eDT5hs=
X-Google-Smtp-Source: ABdhPJyEiMCNEphmoHgIo6UH3s2odeBPsJ505+enAJUiDgcS754G/jsXazX3wC0wvqZTLlBTXkWQVg==
X-Received: by 2002:a17:907:9811:b0:6f3:a389:a203 with SMTP id ji17-20020a170907981100b006f3a389a203mr26905918ejc.381.1651754288512;
        Thu, 05 May 2022 05:38:08 -0700 (PDT)
Received: from localhost.localdomain (136.red-2-136-200.staticip.rima-tde.net. [2.136.200.136])
        by smtp.gmail.com with ESMTPSA id qv48-20020a17090787b000b006f3ef214d9esm724345ejc.4.2022.05.05.05.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 05:38:08 -0700 (PDT)
From:   Carlos Fernandez <carlos.escuin@gmail.com>
X-Google-Original-From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     pabeni@redhat.com, carlos.fernandez@technica-enineering.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Subject: [PATCH] net: macsec: XPN Salt copied before passing offload context
Date:   Thu,  5 May 2022 14:38:03 +0200
Message-Id: <20220505123803.17553-1-carlos.fernandez@technica-engineering.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <[PATCH] net/macsec copy salt to MACSec ctx for XPN>
References: <[PATCH] net/macsec copy salt to MACSec ctx for XPN>
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

When macsec offloading is used with XPN, before mdo_add_rxsa
and mdo_add_txsa functions are called, the key salt is not
copied to the macsec context struct.

Fix by copying salt to context struct before calling the
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

