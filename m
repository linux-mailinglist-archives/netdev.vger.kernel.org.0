Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F85A276799
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 06:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIXEQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 00:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgIXEQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 00:16:38 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BE3C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 21:16:38 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 34so1080379pgo.13
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 21:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QsQxjipYpqWkLQJiWqeoNnHMMxFC2hc49JYfv+0lhwU=;
        b=Zy7MIYdVTgsya3ZeGW0FHIub01TvygbRa87bHtrxbdVr88rcuAnfDcojboEInY9XOe
         g1NnCfix/1HJJSiI9hbgKtJXrZniCmutLwMA05uCmu2B2Htc2xRtiQvJDxEEjtoRBmQ4
         rS3zOZZtRfwCbeoK/pccG/rcoVZEdW6wfFh08vDt6gvUM3Zil2ef/rt6PQPO4Yf0Ty6d
         LFh0NlaDr6YD4AEBOS5mDzi4Q5tyvzdOZ/rckVSqn/wQ0LFGf8fIYSJcJGNHvNiKragT
         yQf1wO1E4Y2U7NGN1/Yqno6rR434NfGzNOK3xvr39fkqjS0U1yZCz68lV5BFcuAAkde2
         wVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QsQxjipYpqWkLQJiWqeoNnHMMxFC2hc49JYfv+0lhwU=;
        b=dp9pELqbytp/n7DLyCqi/wPqUpDuCKPgY7E/4JE09anuy6MKSjWpqvFZkv0wZ51tpS
         2WF3FIX1r8Lh0xlhVL3f9L5rIxy+8mhR6WKlazLaGStsy3Du4ds2cRyiOhhcF1tKE1mo
         zthMETsBs+3GiiqpTBiOZAuXRE5aWbv2Zxrx3Z1YCyqzcEXJ9D1uvbbVlXsNQwa5ro06
         Fvrn2qmt8ACdqTmrog9mo22gtX7/EjQWgbGV1F577KLGgUa6fH6RIhecua3aI0TrRAjk
         s8rarZfypKZPZqDB/7Zs1QMobmErBV5I9HIjwJ4S38EYwnlWErVmaZ2kAfP9SGTo57LP
         rG/w==
X-Gm-Message-State: AOAM531HTuMdrKANEV8iTHoY0MCD6RiwkuDpMBdhR7mBGNF9HmFmu/z4
        jEmRdbkS6J29UksP2LRVswchrWkh/sXhjw==
X-Google-Smtp-Source: ABdhPJy3y2cRjb+6SKZGinXBWq5G+h2nF4PV9dqELdw9O3vnaMlS2d4KW0Jr1cEshe3D1fb540PvCw==
X-Received: by 2002:a65:42c2:: with SMTP id l2mr2525041pgp.61.1600920997416;
        Wed, 23 Sep 2020 21:16:37 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id hg16sm798624pjb.37.2020.09.23.21.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 21:16:36 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, vladimir.oltean@nxp.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next] net: vlan: Avoid using BUG() in vlan_proto_idx()
Date:   Wed, 23 Sep 2020 21:16:27 -0700
Message-Id: <20200924041627.33106-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While we should always make sure that we specify a valid VLAN protocol
to vlan_proto_idx(), killing the machine when an invalid value is
specified is too harsh and not helpful for debugging. All callers are
capable of dealing with an error returned by vlan_proto_idx() so check
the index value and propagate it accordingly.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/8021q/vlan.c |  3 +++
 net/8021q/vlan.h | 17 ++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index d4bcfd8f95bf..6c08de1116c1 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -57,6 +57,9 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
 	ASSERT_RTNL();
 
 	pidx  = vlan_proto_idx(vlan_proto);
+	if (pidx < 0)
+		return -EINVAL;
+
 	vidx  = vlan_id / VLAN_GROUP_ARRAY_PART_LEN;
 	array = vg->vlan_devices_arrays[pidx][vidx];
 	if (array != NULL)
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index bb7ec1a3915d..143e9c12dbd6 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -44,8 +44,8 @@ static inline unsigned int vlan_proto_idx(__be16 proto)
 	case htons(ETH_P_8021AD):
 		return VLAN_PROTO_8021AD;
 	default:
-		BUG();
-		return 0;
+		WARN(1, "invalid VLAN protocol: 0x%04x\n", htons(proto));
+		return -EINVAL;
 	}
 }
 
@@ -64,17 +64,24 @@ static inline struct net_device *vlan_group_get_device(struct vlan_group *vg,
 						       __be16 vlan_proto,
 						       u16 vlan_id)
 {
-	return __vlan_group_get_device(vg, vlan_proto_idx(vlan_proto), vlan_id);
+	int pidx = vlan_proto_idx(vlan_proto);
+
+	if (pidx < 0)
+		return NULL;
+
+	return __vlan_group_get_device(vg, pidx, vlan_id);
 }
 
 static inline void vlan_group_set_device(struct vlan_group *vg,
 					 __be16 vlan_proto, u16 vlan_id,
 					 struct net_device *dev)
 {
+	int pdix = vlan_proto_idx(vlan_proto);
 	struct net_device **array;
-	if (!vg)
+
+	if (!vg || pdix < 0)
 		return;
-	array = vg->vlan_devices_arrays[vlan_proto_idx(vlan_proto)]
+	array = vg->vlan_devices_arrays[pdix]
 				       [vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
 	array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] = dev;
 }
-- 
2.25.1

