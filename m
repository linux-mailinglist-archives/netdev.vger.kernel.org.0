Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F404D3A7997
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 10:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhFOI43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 04:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhFOI4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 04:56:25 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5751C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 01:54:20 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a20so17448270wrc.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 01:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIOhETM+EiJzX3M67FluR6OxyqKts44R0QlrZRKeU18=;
        b=CDZCdxhEGcqV+2ZYAVwknZI7YLKcrXwarlmYVkDWkfJFf5af8AEwcdTH0fVy20k6cr
         BrEOfoHw1fFpDdxSsC4BRI2g3KCLkDDw0bPVOpNy8kj+74OBaQrcSdjSmgKq5/kMnHRR
         wybj7pweBX0aj8HrG7BQlhJ6jDUtF5uRUcoWVwc7VTrm9YpZCWj2t8oEklY0+h3Xjql7
         AvYvLXNqCHq8MDwtj5me0t5j7bXGzmboa4Ump/zfFg3dzF90gX3MuCjcKWDcDv80uNG2
         LBNw+FUZhYJI+OBAdJTGeezsw75UmUNjMyp4Rw7ctYGdLf72YAFdlZVrQjzKAi/+Y6iQ
         SqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIOhETM+EiJzX3M67FluR6OxyqKts44R0QlrZRKeU18=;
        b=uM0Yly/pukCxaBCSyn4cZHmQMvdqldT0XDWUmG81T1RlaXzIHlMBSzXLDHJy/wIOZv
         erlpAMsIr5MKEqLJqiC3ZZxNIzJEW22+wQG3Uz0cU4VX/9+pE2X7RyI/WJjxWrW3kSg/
         XtFzLbHUNqkF/vcxgPTyQxdO/o/LHcWWweiqaHlE+LQu3h2oY4/If1dmfyfGSFFGrjau
         gX0M8OvdH0z5p9mX+f5Dm+/+OqhYZ03yUgKW8g55O6qBkEG1CfnfevP+91Ewp+C91EPk
         v3QzvMUsAPRbhojNsnGXycaYNsR8JrKCf4OAMFsSnObfQmHvcB2HwdPdpWZXkSsRe/yq
         fhLw==
X-Gm-Message-State: AOAM531zVlKH90mcN7iiOPWJ4fvVMvaFkNAtZxGgB0/+hi1lXmSnaS94
        TWMCyes8Grnvf/ryJwLvXG7iHcUS/lABctA=
X-Google-Smtp-Source: ABdhPJy73LZmtEGxYNZnd8Kser0BHwMH2gG+wxl1Sugzn4rtEzv3clf3s7paGtefLA41ZEE15078xw==
X-Received: by 2002:a5d:6d05:: with SMTP id e5mr24271846wrq.154.1623747259185;
        Tue, 15 Jun 2021 01:54:19 -0700 (PDT)
Received: from balnab.. ([37.17.237.224])
        by smtp.gmail.com with ESMTPSA id p187sm15355683wmp.28.2021.06.15.01.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 01:54:18 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     netdev@vger.kernel.org
Cc:     j.vosburgh@gmail.com, Jussi Maki <joamaki@gmail.com>
Subject: [PATCH net-next] net: bonding: Use per-cpu rr_tx_counter
Date:   Tue, 15 Jun 2021 08:54:15 +0000
Message-Id: <20210615085415.1696103-1-joamaki@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The round-robin rr_tx_counter was shared across CPUs leading to
significant cache thrashing at high packet rates. This patch switches
the round-robin packet counter to use a per-cpu variable to decide
the destination slave.

On a test with 2x100Gbit ICE nic with pktgen_sample_04_many_flows.sh
(-s 64 -t 32) the tx rate was 19.6Mpps before and 22.3Mpps after
this patch.

"perf top -e cache_misses" before:
    12.31%  [bonding]       [k] bond_xmit_roundrobin_slave_get
    10.59%  [sch_fq_codel]  [k] fq_codel_dequeue
     9.34%  [kernel]        [k] skb_release_data
after:
    15.42%  [sch_fq_codel]  [k] fq_codel_dequeue
    10.06%  [kernel]        [k] __memset
     9.12%  [kernel]        [k] skb_release_data

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 drivers/net/bonding/bond_main.c | 18 +++++++++++++++---
 include/net/bonding.h           |  2 +-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index eb79a9f05914..1d9137e77dfc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4202,16 +4202,16 @@ static u32 bond_rr_gen_slave_id(struct bonding *bond)
 		slave_id = prandom_u32();
 		break;
 	case 1:
-		slave_id = bond->rr_tx_counter;
+		slave_id = this_cpu_inc_return(*bond->rr_tx_counter);
 		break;
 	default:
 		reciprocal_packets_per_slave =
 			bond->params.reciprocal_packets_per_slave;
-		slave_id = reciprocal_divide(bond->rr_tx_counter,
+		slave_id = this_cpu_inc_return(*bond->rr_tx_counter);
+		slave_id = reciprocal_divide(slave_id,
 					     reciprocal_packets_per_slave);
 		break;
 	}
-	bond->rr_tx_counter++;
 
 	return slave_id;
 }
@@ -4852,6 +4852,9 @@ static void bond_destructor(struct net_device *bond_dev)
 
 	if (bond->wq)
 		destroy_workqueue(bond->wq);
+
+	if (bond->rr_tx_counter)
+		free_percpu(bond->rr_tx_counter);
 }
 
 void bond_setup(struct net_device *bond_dev)
@@ -5350,6 +5353,15 @@ static int bond_init(struct net_device *bond_dev)
 	if (!bond->wq)
 		return -ENOMEM;
 
+	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN) {
+		bond->rr_tx_counter = alloc_percpu(u32);
+		if (!bond->rr_tx_counter) {
+			destroy_workqueue(bond->wq);
+			bond->wq = NULL;
+			return -ENOMEM;
+		}
+	}
+
 	spin_lock_init(&bond->stats_lock);
 	netdev_lockdep_set_classes(bond_dev);
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 019e998d944a..15335732e166 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -232,7 +232,7 @@ struct bonding {
 	char     proc_file_name[IFNAMSIZ];
 #endif /* CONFIG_PROC_FS */
 	struct   list_head bond_list;
-	u32      rr_tx_counter;
+	u32 __percpu *rr_tx_counter;
 	struct   ad_bond_info ad_info;
 	struct   alb_bond_info alb_info;
 	struct   bond_params params;
-- 
2.30.2

