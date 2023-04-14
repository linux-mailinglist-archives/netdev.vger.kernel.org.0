Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606056E2BB2
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjDNVYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjDNVYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:24:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6B272AA;
        Fri, 14 Apr 2023 14:24:08 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4ec817735a7so65959e87.3;
        Fri, 14 Apr 2023 14:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681507447; x=1684099447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3L0ATs2K15l9KRiiuDKNOs5Kicmg+FttDgu2qaNiHk=;
        b=r3IQeT7/hjmVw1V1jC+isz9z9kdwxJ3mht6m/lu8GQwCjPmwoLCpfXqhMvsge61d8S
         5r6XwNKntpTT5kkI48rSOsfyDkRQpc5UFdx8wox0SjourRS1tPgw4VAnIUtqC7MURSO6
         kFregwbsNpCn/nPLpr+qg4w5sDHsb1z2BwzFj9Pts/yYihvTGpclni/4RIskockWh1fl
         v5XdcF0db7oidNvT79jhsgD1D5SlwdrDuI0szUckcCEJt1naA2R+/cPIdDKCaNR409NJ
         xuQCkp1kmiXGs4Cyc4V8UtPi6a2V3aoMF7mK/sWHlsC+jy65NcZsuRXxuqo3KPIYGnJi
         wQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681507447; x=1684099447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3L0ATs2K15l9KRiiuDKNOs5Kicmg+FttDgu2qaNiHk=;
        b=LAengAPRwlhFPgVEiZ2qYEN3JqkpcruMqs62ORicI0pBBDmucyLaumuAamXmfuYSXc
         FCwfKRBJjV8krji4xyF5zeb5yPLkSE2ll0/FUVhRFWhh+MdvToEdCSBHwAq6KFqRVTvv
         u+FF48gLJR4RT2pXXW+ESc7R47n1lj/MfEmXxoSrl7GWfr68frnmOztRlqIwxA+yJRsw
         R/Ww/fqcCqcI8ATEt8qPX+jKu7HqAiQ/kgqTTcCekewlAgzWdIKe0ZutUMiNCCyWND/V
         +bDnCNIzLa6WGE+xuIi5wxMUhGqQkjibBcbvpz8e6EHGKkl2T6xJ2uEpEdqm3uDXfvW0
         4zRQ==
X-Gm-Message-State: AAQBX9csch7PwGJlAqg1Ml5yRjTHccxgdWsHD0YJOUd4plKytFJm5s+K
        fbIjKqnZOSkAMwHtnqU0YSA=
X-Google-Smtp-Source: AKy350a96dPHO1SUt34Z40J/9mcdMAfyS39vxkGCFffQ7Zo1OiM4D/9sVmoeIjsndPIyNRD7Ty9IOw==
X-Received: by 2002:a19:a40e:0:b0:4e8:3f38:7d21 with SMTP id q14-20020a19a40e000000b004e83f387d21mr54986lfc.28.1681507447134;
        Fri, 14 Apr 2023 14:24:07 -0700 (PDT)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id m11-20020a056512014b00b004ecad67a925sm961263lfo.66.2023.04.14.14.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 14:24:06 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Marko <robimarko@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/3] wifi: ath11k: look for DT node for each radio
Date:   Fri, 14 Apr 2023 23:23:55 +0200
Message-Id: <20230414212356.9326-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230414212356.9326-1-zajec5@gmail.com>
References: <20230414212356.9326-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Updated DT binding allows describing each chip radio.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/ath/ath11k/core.h |  2 ++
 drivers/net/wireless/ath/ath11k/mac.c  | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 0830276e5028..1a583adf2ab1 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -13,6 +13,7 @@
 #include <linux/bitfield.h>
 #include <linux/dmi.h>
 #include <linux/ctype.h>
+#include <linux/of.h>
 #include <linux/rhashtable.h>
 #include <linux/average.h>
 #include "qmi.h"
@@ -592,6 +593,7 @@ struct ath11k_per_peer_tx_stats {
 struct ath11k {
 	struct ath11k_base *ab;
 	struct ath11k_pdev *pdev;
+	struct device_node *np;
 	struct ieee80211_hw *hw;
 	struct ieee80211_ops *ops;
 	struct ath11k_pdev_wmi *wmi;
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index cad832e0e6b8..ad5a22d12bd3 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -9344,6 +9344,25 @@ int ath11k_mac_register(struct ath11k_base *ab)
 	return ret;
 }
 
+static struct device_node *ath11k_mac_find_radio_node(struct ath11k_base *ab, int i)
+{
+	struct device_node *np;
+
+	for_each_child_of_node(ab->dev->of_node, np) {
+		u32 reg;
+		int err;
+
+		if (strcmp(np->name, "radio"))
+			continue;
+
+		err = of_property_read_u32(np, "reg", &reg);
+		if (!err && reg == i)
+			return np;
+	}
+
+	return NULL;
+}
+
 int ath11k_mac_allocate(struct ath11k_base *ab)
 {
 	struct ieee80211_hw *hw;
@@ -9369,6 +9388,7 @@ int ath11k_mac_allocate(struct ath11k_base *ab)
 		ar->ab = ab;
 		ar->pdev = pdev;
 		ar->pdev_idx = i;
+		ar->np = ath11k_mac_find_radio_node(ab, i);
 		ar->lmac_id = ath11k_hw_get_mac_from_pdev_id(&ab->hw_params, i);
 
 		ar->wmi = &ab->wmi_ab.wmi[i];
-- 
2.34.1

