Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4A239A5EA
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFCQlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:41:53 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:34336 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFCQlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 12:41:52 -0400
Received: by mail-lj1-f182.google.com with SMTP id bn21so7972629ljb.1;
        Thu, 03 Jun 2021 09:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H8lb6eizzgSPHFKT9be5e/0O9La7mP/YjKJCQ8I16io=;
        b=pG0JQoeA1S0PfLGQcQH0N3epPCHliz0S+PkeQP1MoU9TNBKm2X56q+NIN6f2s5FX5k
         QKKte6eebjEeq980f/7XLEVeCsrIymjBqudo1A2MXth+LSonq2Zchss1lMZpJhpJaoK/
         TDS35CPinQffWqoLoLmq3tyFhA9aB5yn2HnmNZxWOFpoXhmy7u+QUK4duiFdjON3d+7U
         C9PrJS+4MRle9LacmZdfKdOyPOy4DmlVbZOKSGNKlJfCArksrXL9bxl8JoSMZaA7vSh2
         qrdEewFjrBWXEWI0TqHE58qVp/h3tAmL5yNItfP99olcgjU3o9GxjEKC5LwIgeYXeiBa
         UpbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H8lb6eizzgSPHFKT9be5e/0O9La7mP/YjKJCQ8I16io=;
        b=qqqCrlQXheXBd72wIA1N7Zz7b+4liq/S7c2KV0j1mJXILCUAb7Dg4naLz9/3eYeLqQ
         V/Pd9Dsu7F6VPTy6g1Qg3i1EY6Yc6QYufav0uTXhlZaaav5SRtppJe0F6ggU9F6pUdLI
         yj7IeYyxovueBudRIDLxmYmNHNvkNIaicLhlDjodNgZ0fRpA0mztXNZaE95rTETnHjKP
         R0ZTct71R1zhUMeHomFn/6E1OO+s01xIfb90HCXhUufbSQBhMnmEEm1X9HyWw8LmWJgD
         yZdy8JlqTR+HVxExDQLkyBLjJc5uZVOUQv47SmPx+AahyZV9dQ4WU9qUvl2Q3FlIaGYX
         VxnQ==
X-Gm-Message-State: AOAM530HJ8uDO9czBKPUdy8soGVDuyue77VEpQBePNkFmKlmjPr5UoTZ
        6xtAUCkTla8T7YKGkrsJAlQ=
X-Google-Smtp-Source: ABdhPJx5UPMFVe3Hb8Rpi3z/mkT74p4T57S3sTtcSOLeUrn5icPJCnprOwRHuV9vQ7Dc7Wru3YNdJw==
X-Received: by 2002:a2e:994c:: with SMTP id r12mr183686ljj.235.1622738335897;
        Thu, 03 Jun 2021 09:38:55 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id e29sm360067lfb.258.2021.06.03.09.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:38:55 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        sjur.brandeland@stericsson.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 2/4] net: caif: add proper error handling
Date:   Thu,  3 Jun 2021 19:38:51 +0300
Message-Id: <13757f9aaea3484864b8149365b4361eb802853b.1622737854.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622737854.git.paskripkin@gmail.com>
References: <cover.1622737854.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

caif_enroll_dev() can fail in some cases. Ingnoring
these cases can lead to memory leak due to not assigning
link_support pointer to anywhere.

Fixes: 7c18d2205ea7 ("caif: Restructure how link caif link layer enroll")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 include/net/caif/caif_dev.h |  2 +-
 include/net/caif/cfcnfg.h   |  2 +-
 net/caif/caif_dev.c         |  8 +++++---
 net/caif/cfcnfg.c           | 16 +++++++++++-----
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/net/caif/caif_dev.h b/include/net/caif/caif_dev.h
index 48ecca8530ff..b655d8666f55 100644
--- a/include/net/caif/caif_dev.h
+++ b/include/net/caif/caif_dev.h
@@ -119,7 +119,7 @@ void caif_free_client(struct cflayer *adap_layer);
  * The link_support layer is used to add any Link Layer specific
  * framing.
  */
-void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
+int caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
 			struct cflayer *link_support, int head_room,
 			struct cflayer **layer, int (**rcv_func)(
 				struct sk_buff *, struct net_device *,
diff --git a/include/net/caif/cfcnfg.h b/include/net/caif/cfcnfg.h
index 2aa5e91d8457..8819ff4db35a 100644
--- a/include/net/caif/cfcnfg.h
+++ b/include/net/caif/cfcnfg.h
@@ -62,7 +62,7 @@ void cfcnfg_remove(struct cfcnfg *cfg);
  * @fcs:	Specify if checksum is used in CAIF Framing Layer.
  * @head_room:	Head space needed by link specific protocol.
  */
-void
+int
 cfcnfg_add_phy_layer(struct cfcnfg *cnfg,
 		     struct net_device *dev, struct cflayer *phy_layer,
 		     enum cfcnfg_phy_preference pref,
diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index c10e5a55758d..fffbe41440b3 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -308,7 +308,7 @@ static void dev_flowctrl(struct net_device *dev, int on)
 	caifd_put(caifd);
 }
 
-void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
+int caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
 		     struct cflayer *link_support, int head_room,
 		     struct cflayer **layer,
 		     int (**rcv_func)(struct sk_buff *, struct net_device *,
@@ -319,11 +319,12 @@ void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
 	enum cfcnfg_phy_preference pref;
 	struct cfcnfg *cfg = get_cfcnfg(dev_net(dev));
 	struct caif_device_entry_list *caifdevs;
+	int res;
 
 	caifdevs = caif_device_list(dev_net(dev));
 	caifd = caif_device_alloc(dev);
 	if (!caifd)
-		return;
+		return -ENOMEM;
 	*layer = &caifd->layer;
 	spin_lock_init(&caifd->flow_lock);
 
@@ -344,7 +345,7 @@ void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
 	strlcpy(caifd->layer.name, dev->name,
 		sizeof(caifd->layer.name));
 	caifd->layer.transmit = transmit;
-	cfcnfg_add_phy_layer(cfg,
+	res = cfcnfg_add_phy_layer(cfg,
 				dev,
 				&caifd->layer,
 				pref,
@@ -354,6 +355,7 @@ void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
 	mutex_unlock(&caifdevs->lock);
 	if (rcv_func)
 		*rcv_func = receive;
+	return res;
 }
 EXPORT_SYMBOL(caif_enroll_dev);
 
diff --git a/net/caif/cfcnfg.c b/net/caif/cfcnfg.c
index 399239a14420..cac30e676ac9 100644
--- a/net/caif/cfcnfg.c
+++ b/net/caif/cfcnfg.c
@@ -450,7 +450,7 @@ cfcnfg_linkup_rsp(struct cflayer *layer, u8 channel_id, enum cfctrl_srv serv,
 	rcu_read_unlock();
 }
 
-void
+int
 cfcnfg_add_phy_layer(struct cfcnfg *cnfg,
 		     struct net_device *dev, struct cflayer *phy_layer,
 		     enum cfcnfg_phy_preference pref,
@@ -459,7 +459,7 @@ cfcnfg_add_phy_layer(struct cfcnfg *cnfg,
 {
 	struct cflayer *frml;
 	struct cfcnfg_phyinfo *phyinfo = NULL;
-	int i;
+	int i, res = 0;
 	u8 phyid;
 
 	mutex_lock(&cnfg->lock);
@@ -473,12 +473,15 @@ cfcnfg_add_phy_layer(struct cfcnfg *cnfg,
 			goto got_phyid;
 	}
 	pr_warn("Too many CAIF Link Layers (max 6)\n");
+	res = -EEXIST;
 	goto out;
 
 got_phyid:
 	phyinfo = kzalloc(sizeof(struct cfcnfg_phyinfo), GFP_ATOMIC);
-	if (!phyinfo)
+	if (!phyinfo) {
+		res = -ENOMEM;
 		goto out_err;
+	}
 
 	phy_layer->id = phyid;
 	phyinfo->pref = pref;
@@ -492,8 +495,10 @@ cfcnfg_add_phy_layer(struct cfcnfg *cnfg,
 
 	frml = cffrml_create(phyid, fcs);
 
-	if (!frml)
+	if (!frml) {
+		res = -ENOMEM;
 		goto out_err;
+	}
 	phyinfo->frm_layer = frml;
 	layer_set_up(frml, cnfg->mux);
 
@@ -511,11 +516,12 @@ cfcnfg_add_phy_layer(struct cfcnfg *cnfg,
 	list_add_rcu(&phyinfo->node, &cnfg->phys);
 out:
 	mutex_unlock(&cnfg->lock);
-	return;
+	return res;
 
 out_err:
 	kfree(phyinfo);
 	mutex_unlock(&cnfg->lock);
+	return res;
 }
 EXPORT_SYMBOL(cfcnfg_add_phy_layer);
 
-- 
2.31.1

