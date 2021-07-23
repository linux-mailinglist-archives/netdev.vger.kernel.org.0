Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15A33D4021
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhGWRWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhGWRW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:22:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E79CC061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:03:01 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so4755658pji.5
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pgZVut7s34f862AzhrzjW+rEtNGMQ8fAZFSLYMy4cbU=;
        b=IQ1OsmHWIkl3VFpYa8GUUdVuVLcEkqtDJKWhyq++yF3KIvMHXmynXFWyy8zbt5uvKV
         +eKKm7WTSdLoTD7gtx3hv6ZhGtAVpEtVUHmWRwbV4HbPsOuJVnoOyO/0xtYD8adWkQqV
         pNTF7FmBL/SaSv3yULQL5x/Uz3NpeEtacWtd0fA4E6p/EDvRvJp9GFmQOsSSv25/zoCB
         VLVhq7roAQ9qipntD4qnw5SLQCATm6hrpIM5Qndd+Lk705RXsFl04h+XICX099otlLbx
         mwTF7ZMv/r1hBQhhIt3u3NzF628YCTLzYW+9G+hjCltmjCPL9d4JO7N9UdgYwrcXzj7z
         CtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pgZVut7s34f862AzhrzjW+rEtNGMQ8fAZFSLYMy4cbU=;
        b=m4C7smoCU+zcD6NeLLVdn/Xg4qC+5kKvI/69CRsKzAJp9f4iRLOBzHUxmwQBA23w95
         Taff1JY7Aq1vit9AwCKuuwZdI3ysAMtabEv/dnoAu5kcPXetnAGNGrV4Td75hjZYRvTO
         NN5qZyaFLnq4nYqPhMOt99QcbCG05vah62sMnhcLmUfAy7ae5NYXXXg1rgp5++xDhl4c
         TaEDWMw5x10vmtG/Teb4BNEdM0Hyg9m9+j8/Lr9ddKw9+J7DstWTXREBn8rzb8VCVQQA
         //2d64QxeMvx9yV6N2oiine2j96bp0bRi4/nYrJMuF6yWnIf526ZSci1qtKHMs/oKY9l
         V7cw==
X-Gm-Message-State: AOAM531pER2wQsQWo9yTVV2uKG1E8BszXX+WXwFdJ+wnGkTcoeS59Vlv
        zDZ1EhsVqrP0Re3NdbmfxRlsaA==
X-Google-Smtp-Source: ABdhPJzC2okB5RMUpqS5b/NHXUqLRhHTmhzAI0wkXvSphEwrTUdZji0InTrLxfFzy1n/BqUWD/PHPQ==
X-Received: by 2002:a17:90a:4501:: with SMTP id u1mr5689230pjg.37.1627063380940;
        Fri, 23 Jul 2021 11:03:00 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c23sm19437934pfo.174.2021.07.23.11.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 11:03:00 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 2/5] ionic: catch no ptp support earlier
Date:   Fri, 23 Jul 2021 11:02:46 -0700
Message-Id: <20210723180249.57599-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210723180249.57599-1-snelson@pensando.io>
References: <20210723180249.57599-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If PTP configuration is attempted on ports that don't support
it, such as VF ports, the driver will return an error status
-95, or EOPNOSUPP and print an error message
    enp98s0: hwstamp set failed: -95

Because some daemons can retry every few seconds, this can end
up filling the dmesg log and pushing out other more useful
messages.

We can catch this issue earlier in our handling and return
the error without a log message.

Fixes: 829600ce5e4e ("ionic: add ts_config replay")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.h |  7 ++-----
 drivers/net/ethernet/pensando/ionic/ionic_phc.c | 10 +++++++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index af291303bd7a..69ab59fedb6c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -302,7 +302,7 @@ int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 int ionic_lif_size(struct ionic *ionic);
 
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
-int ionic_lif_hwstamp_replay(struct ionic_lif *lif);
+void ionic_lif_hwstamp_replay(struct ionic_lif *lif);
 int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr);
 int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr);
 ktime_t ionic_lif_phc_ktime(struct ionic_lif *lif, u64 counter);
@@ -311,10 +311,7 @@ void ionic_lif_unregister_phc(struct ionic_lif *lif);
 void ionic_lif_alloc_phc(struct ionic_lif *lif);
 void ionic_lif_free_phc(struct ionic_lif *lif);
 #else
-static inline int ionic_lif_hwstamp_replay(struct ionic_lif *lif)
-{
-	return -EOPNOTSUPP;
-}
+static inline void ionic_lif_hwstamp_replay(struct ionic_lif *lif) {}
 
 static inline int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index a87c87e86aef..6e2403c71608 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -188,6 +188,9 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 	struct hwtstamp_config config;
 	int err;
 
+	if (!lif->phc || !lif->phc->ptp)
+		return -EOPNOTSUPP;
+
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
@@ -203,15 +206,16 @@ int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
 	return 0;
 }
 
-int ionic_lif_hwstamp_replay(struct ionic_lif *lif)
+void ionic_lif_hwstamp_replay(struct ionic_lif *lif)
 {
 	int err;
 
+	if (!lif->phc || !lif->phc->ptp)
+		return;
+
 	err = ionic_lif_hwstamp_set_ts_config(lif, NULL);
 	if (err)
 		netdev_info(lif->netdev, "hwstamp replay failed: %d\n", err);
-
-	return err;
 }
 
 int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr)
-- 
2.17.1

