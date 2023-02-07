Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8BE68E06C
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjBGSq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjBGSqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:46:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66A91E1D5
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675795564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xRfiteU6Z5eSfEoYMfTI1Sg7EmhHOPUjXfD4F8jwvMo=;
        b=VEU44sIbo28zl6rwtCAKjiPqa6E0h/+ITKSkndp8qWIzlOeVLmMo8neT1Tp/ljfbjYeDVm
        +VuUwx+gXpiLT56DA4hBBITHgPBj3RYWTtEXm9jWkKWpLG4FLWEyEJI3OCV7DKUhpqADq3
        rH7EdkY89BR69ergT29sNaXmd0DiYwY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-2TmPw43SN7-ax755pKnArA-1; Tue, 07 Feb 2023 13:46:02 -0500
X-MC-Unique: 2TmPw43SN7-ax755pKnArA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25943811E6E;
        Tue,  7 Feb 2023 18:46:02 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3683401014C;
        Tue,  7 Feb 2023 18:46:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH v4 net-next 2/4] net-sysctl: factor-out rpm mask manipulation helpers
Date:   Tue,  7 Feb 2023 19:44:56 +0100
Message-Id: <c1b1b0d0c8a2250eb47743496a9e1b7e003a6d81.1675789134.git.pabeni@redhat.com>
In-Reply-To: <cover.1675789134.git.pabeni@redhat.com>
References: <cover.1675789134.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will simplify the following patch. No functional change
intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v2 -> v3: factor out the new rps_cpumask_housekeeping() helper
---
 net/core/dev.h       |  2 ++
 net/core/net-sysfs.c | 72 ++++++++++++++++++++++++++------------------
 2 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/net/core/dev.h b/net/core/dev.h
index a065b7571441..e075e198092c 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -9,6 +9,7 @@ struct net_device;
 struct netdev_bpf;
 struct netdev_phys_item_id;
 struct netlink_ext_ack;
+struct cpumask;
 
 /* Random bits of netdevice that don't need to be exposed */
 #define FLOW_LIMIT_HISTORY	(1 << 7)  /* must be ^2 and !overflow buckets */
@@ -134,4 +135,5 @@ static inline void netif_set_gro_ipv4_max_size(struct net_device *dev,
 	WRITE_ONCE(dev->gro_ipv4_max_size, size);
 }
 
+int rps_cpumask_housekeeping(struct cpumask *mask);
 #endif
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ca55dd747d6c..2126970a4bfd 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -831,42 +831,18 @@ static ssize_t show_rps_map(struct netdev_rx_queue *queue, char *buf)
 	return len < PAGE_SIZE ? len : -EINVAL;
 }
 
-static ssize_t store_rps_map(struct netdev_rx_queue *queue,
-			     const char *buf, size_t len)
+static int netdev_rx_queue_set_rps_mask(struct netdev_rx_queue *queue,
+					cpumask_var_t mask)
 {
-	struct rps_map *old_map, *map;
-	cpumask_var_t mask;
-	int err, cpu, i;
 	static DEFINE_MUTEX(rps_map_mutex);
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
-		return -ENOMEM;
-
-	err = bitmap_parse(buf, len, cpumask_bits(mask), nr_cpumask_bits);
-	if (err) {
-		free_cpumask_var(mask);
-		return err;
-	}
-
-	if (!cpumask_empty(mask)) {
-		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN));
-		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_WQ));
-		if (cpumask_empty(mask)) {
-			free_cpumask_var(mask);
-			return -EINVAL;
-		}
-	}
+	struct rps_map *old_map, *map;
+	int cpu, i;
 
 	map = kzalloc(max_t(unsigned int,
 			    RPS_MAP_SIZE(cpumask_weight(mask)), L1_CACHE_BYTES),
 		      GFP_KERNEL);
-	if (!map) {
-		free_cpumask_var(mask);
+	if (!map)
 		return -ENOMEM;
-	}
 
 	i = 0;
 	for_each_cpu_and(cpu, mask, cpu_online_mask)
@@ -893,9 +869,45 @@ static ssize_t store_rps_map(struct netdev_rx_queue *queue,
 
 	if (old_map)
 		kfree_rcu(old_map, rcu);
+	return 0;
+}
 
+int rps_cpumask_housekeeping(struct cpumask *mask)
+{
+	if (!cpumask_empty(mask)) {
+		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN));
+		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_WQ));
+		if (cpumask_empty(mask))
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static ssize_t store_rps_map(struct netdev_rx_queue *queue,
+			     const char *buf, size_t len)
+{
+	cpumask_var_t mask;
+	int err;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	err = bitmap_parse(buf, len, cpumask_bits(mask), nr_cpumask_bits);
+	if (err)
+		goto out;
+
+	err = rps_cpumask_housekeeping(mask);
+	if (err)
+		goto out;
+
+	err = netdev_rx_queue_set_rps_mask(queue, mask);
+
+out:
 	free_cpumask_var(mask);
-	return len;
+	return err ? : len;
 }
 
 static ssize_t show_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
-- 
2.39.1

