Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0A6277CDE
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgIYA1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgIYA1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:27:51 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F83C0613CE;
        Thu, 24 Sep 2020 17:27:51 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b124so1360397pfg.13;
        Thu, 24 Sep 2020 17:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0gV4Lh5wxTO/1WcDiiW/t3qWkGft8ICQIniBYMPSC4=;
        b=ssB2ViMv+f5O5Wl8gt98ARhOq/RlTgmuyW6RjeGzTsab+DYtpzYqbkaOOFZ8btNC7p
         6c3GMOvC/9hsjMw6FXrmf40vgUdIDVB0GObpqZHJ7qlE+zveg9IzoX9hJnhfwNbkpWWa
         uxI4MDvzAUNXjJ4qDaNMxBH9xHWp5wC6CrILDDTYwIS0h79NEpndfbQmIiG9Us9yRew6
         BIOd2/WDIzcsy8WcE7ByEEr4kBiTvDpeanwexGl6ftoWFpEHLo5RHmKqC12JyOmU+c4V
         5A+F5ERc+AyhSigwtJ9jCwO1EcCXUUY77p0S3FSvVTjr5AV3obumPM9NwmuiQO+wWY50
         PbCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R0gV4Lh5wxTO/1WcDiiW/t3qWkGft8ICQIniBYMPSC4=;
        b=G3X8lD/EDIoJks3Upaybj4JOTem7fmxlaxbQqs1IGwhQiNkGTzIoe0dNOn041aG63p
         8gowLZBNpQsX/ihJZv3T4f1a55w6/VMuqetisH+G7BeKd5Jz1miTv+yG1DtVRFkpFVt4
         X5hoOUJllA2rWjcgTysyAlBJNJHFjr2FdelJF3HuRT1IKK0FEa6VZtWCOhgv9JelmIm9
         xw8YjBSkAIcZktBErtwspMpMldQ3Np469e5FiEMqPM85tSjr7u2WQYHLLPmiOkM0lALy
         aq3n7FqwRLriTkdxkCKw8MDNZL3vDMLp96eSL2mBEaMSyYvw9k08Za0z9xkKQLiU7axQ
         dZYw==
X-Gm-Message-State: AOAM530+fzCfEinV4mfkLho1dYmol2Z2fbITV3UWPahZYE1+G/DONQdq
        qf7e9s7nwcBT5RupUFqzdyMPeuHzF+OfUg==
X-Google-Smtp-Source: ABdhPJyYHBoNj6zyOweekszLijcb3Sec90ggP+O/LgU6uPRiYtL1KMKmR6G9upEwYLD8H6iM6XUxdQ==
X-Received: by 2002:a17:902:d303:b029:d2:63a9:ff1e with SMTP id b3-20020a170902d303b02900d263a9ff1emr609780plc.39.1600993670242;
        Thu, 24 Sep 2020 17:27:50 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z129sm433097pgb.84.2020.09.24.17.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 17:27:49 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, vladimir.oltean@nxp.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: vlan: Avoid using BUG() in vlan_proto_idx()
Date:   Thu, 24 Sep 2020 17:27:44 -0700
Message-Id: <20200925002746.79571-1-f.fainelli@gmail.com>
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
Changes in v2:
- changed signature to return int
- changed message to use ntohs()
- renamed an index variable to 'pidx' instead of 'pdix'

 net/8021q/vlan.c |  3 +++
 net/8021q/vlan.h | 19 +++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

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
index bb7ec1a3915d..953405362795 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -36,7 +36,7 @@ struct vlan_info {
 	struct rcu_head		rcu;
 };
 
-static inline unsigned int vlan_proto_idx(__be16 proto)
+static inline int vlan_proto_idx(__be16 proto)
 {
 	switch (proto) {
 	case htons(ETH_P_8021Q):
@@ -44,8 +44,8 @@ static inline unsigned int vlan_proto_idx(__be16 proto)
 	case htons(ETH_P_8021AD):
 		return VLAN_PROTO_8021AD;
 	default:
-		BUG();
-		return 0;
+		WARN(1, "invalid VLAN protocol: 0x%04x\n", ntohs(proto));
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
+	int pidx = vlan_proto_idx(vlan_proto);
 	struct net_device **array;
-	if (!vg)
+
+	if (!vg || pidx < 0)
 		return;
-	array = vg->vlan_devices_arrays[vlan_proto_idx(vlan_proto)]
+	array = vg->vlan_devices_arrays[pidx]
 				       [vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
 	array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] = dev;
 }
-- 
2.25.1

