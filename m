Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257366E5D92
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 11:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjDRJix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 05:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjDRJir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 05:38:47 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6276EAF;
        Tue, 18 Apr 2023 02:38:45 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id q21so162375ljp.0;
        Tue, 18 Apr 2023 02:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681810723; x=1684402723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3L0ATs2K15l9KRiiuDKNOs5Kicmg+FttDgu2qaNiHk=;
        b=nyhv9S0CNC/PjzJe5IhoxOI5OUcKQW6S/FB8RtNgOqP3iwEQkVqxo0wzEMV7CETBYi
         ZgdGmaLFOKFWOpW/gQlZcVce05Ip3BlZOc3Ssey0E3xi/OSLhlmxUl/ziXV1e+0t4SMi
         gmi/iUWo1+nNmk/FFJxuAqz5E+IFneKtFit4KIOKrcKn81EEdEmEGRVPZslOxN4iX/iG
         lvK6PrzD9RbCwBpEgpWDAwBmK61cRHUJ8i0KJ7qO79I0TEvIXm7mHsT4nFVr3fRB3Y7C
         z4wAsvpWsjOa16RLxrg8nKP6zuEmvbQUqBC8bts2Km4HGCK/AvFNkzVTO8AXLGlAjciF
         ca1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681810723; x=1684402723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3L0ATs2K15l9KRiiuDKNOs5Kicmg+FttDgu2qaNiHk=;
        b=kOxNS1j07wzd3w7vDu3Q7xIVRKesQfGwZ17DU5CzMreORThVHZ1uQuQ7VLRA80cmJf
         ijIuoR2rWAoSdKiyhY9UOfksLdNb0tAgUCxGW6gMqCm4xkv4Y8rG9iXTRdtj9FE5jdL1
         KOWpbOTr1ZVhawl1mqeHoYx1bj+AHTt2CT8uwni8CRjoaCUuZ+rQt7wYDJ/W4e7keo+A
         2l74WU7RzhoS0UJiSIBltr+7ouWJkYiJFUK3ZkC4r8QZwNHJ/3TGsQ+rID+QIr5pb7zP
         kfGbHQP+qe7W4pGMABHTQK8QMVlaQMhS+jeLAscrvVp2ilByPGy/gtcOGzxcWq3ap8kK
         /iIQ==
X-Gm-Message-State: AAQBX9eXzokPLmdGE3C8rCGrRYHEfmhySTeh45wX3VR22f1sn48cJdTG
        han/T7MUfu8F4Qp1G7Ge3Qk=
X-Google-Smtp-Source: AKy350aAZVr9gDKCYEA8tQIss8/jDCz0fJfn3QG0JlbQJC+0CUZwVHCflgLzuVWWCmHnlncRScdl6g==
X-Received: by 2002:a2e:92c5:0:b0:2a8:e480:a3c8 with SMTP id k5-20020a2e92c5000000b002a8e480a3c8mr334644ljh.44.1681810723462;
        Tue, 18 Apr 2023 02:38:43 -0700 (PDT)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id x27-20020a05651c105b00b002a8c2a4fe99sm967813ljm.28.2023.04.18.02.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 02:38:43 -0700 (PDT)
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
Subject: [PATCH V2 2/3] wifi: ath11k: look for DT node for each radio
Date:   Tue, 18 Apr 2023 11:38:21 +0200
Message-Id: <20230418093822.24005-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418093822.24005-1-zajec5@gmail.com>
References: <20230418093822.24005-1-zajec5@gmail.com>
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

