Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB8510679E
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 09:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVIPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 03:15:31 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38565 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfKVIPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 03:15:31 -0500
Received: by mail-pf1-f193.google.com with SMTP id c13so3128034pfp.5
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 00:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qlM/DhhHQDpL3YtYcnZLk/6Qdio6q1bCFa224hVcykM=;
        b=p6UdXgFNoLE64zF/62LIXetiPQKcSHvGk+ULdXla3s9Y7/+vJJMova+Msb6wmXlfQP
         LqY/WAJmfkaCr1L8HbJWv8YZPl6MQn2lm16UiTsMwSrkoQ7SDtxEdb9E+LJ1Fj6zJY8J
         YXDokieUQIHt6v6ISboLMdLTYEmT4/PXSQsIvxkfBSh05WMbRWwVo6tUtBqms2bQa3Wi
         NegEeiL1CXfr7oTTptAxwk2L/JzQC6+6XXir9N6ajyHpoRsVqpXrMxXDUxDgwBcr8j+/
         F6uL9ImOZSQemek83yyBOVieH6FbglGXg1scZfop7mzldunUBWb1NvBIbJuvmrXeEqRu
         fqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qlM/DhhHQDpL3YtYcnZLk/6Qdio6q1bCFa224hVcykM=;
        b=Rd1gWki6rE70CzIZjiCgUOGiLmOQi6Yi88HAfSSbI0tJ8I5CyDYw29W9BmMV8K+hbz
         zi8D4fonvwZ4cDezSnA0kDg93OWNZU2VWP6WhMyaLcV+bNA33YRNXKu0n/E/B4cNQP6H
         DAj7sx7onH9ZP4a0dOAIWA5pIUummt8HLSmLGt0YhoY3r4XgKrYRiBwXYupRO6YXUPY5
         P+lDRUNCdLyD/EfrJkpegaljSG8wsh9G/48KIgSNCpPi6Zq8nc7Nr5Azp5aurgtI+P4X
         3m0fpVACKnY3VaG4SSQUcg2ViybdyzsHLz/jhgdoXxfNXdCVArK+4u3kAfO1YfyYP9In
         9VOg==
X-Gm-Message-State: APjAAAVQIFesxZ3A9S7GvTC2B+kdYpR2ifhZS56GE149oA7MBXupaoHm
        wIdqtpNIcJk7+WvIrZ6V2XY=
X-Google-Smtp-Source: APXvYqwIZa//lGv8Ms3wu3lsDTsGjze8wRj9g+JFecG4X7IH+CWbBfci/U3zlVX99rtW08lmLMK1sg==
X-Received: by 2002:a63:b144:: with SMTP id g4mr13879989pgp.87.1574410530368;
        Fri, 22 Nov 2019 00:15:30 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id h5sm2065890pjc.9.2019.11.22.00.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 00:15:29 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] net: use rhashtable_lookup() instead of rhashtable_lookup_fast()
Date:   Fri, 22 Nov 2019 08:15:19 +0000
Message-Id: <20191122081519.20918-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rhashtable_lookup_fast() internally calls rcu_read_lock() then,
calls rhashtable_lookup(). So if rcu_read_lock() is already held,
rhashtable_lookup() is enough.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/infiniband/hw/hfi1/sdma.c                | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 2 +-
 drivers/net/ethernet/netronome/nfp/bpf/offload.c | 4 ++--
 net/tipc/socket.c                                | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index c61b6022575e..5774dfc22e18 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -881,8 +881,8 @@ struct sdma_engine *sdma_select_user_engine(struct hfi1_devdata *dd,
 
 	cpu_id = smp_processor_id();
 	rcu_read_lock();
-	rht_node = rhashtable_lookup_fast(dd->sdma_rht, &cpu_id,
-					  sdma_rht_params);
+	rht_node = rhashtable_lookup(dd->sdma_rht, &cpu_id,
+				     sdma_rht_params);
 
 	if (rht_node && rht_node->map[vl]) {
 		struct sdma_rht_map_elem *map = rht_node->map[vl];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3a707d788022..aabeca7a085c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3876,7 +3876,7 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	int err;
 
 	rcu_read_lock();
-	flow = rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
+	flow = rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
 	if (!flow || !same_flow_direction(flow, flags)) {
 		err = -EINVAL;
 		goto errout;
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index 06927ba5a3ae..95a0d3910e31 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -458,8 +458,8 @@ int nfp_bpf_event_output(struct nfp_app_bpf *bpf, const void *data,
 		return -EINVAL;
 
 	rcu_read_lock();
-	record = rhashtable_lookup_fast(&bpf->maps_neutral, &map_id,
-					nfp_bpf_maps_neutral_params);
+	record = rhashtable_lookup(&bpf->maps_neutral, &map_id,
+				   nfp_bpf_maps_neutral_params);
 	if (!record || map_id_full > U32_MAX) {
 		rcu_read_unlock();
 		cmsg_warn(bpf, "perf event: map id %lld (0x%llx) not recognized, dropping event\n",
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 5d7859aac78e..a1c8d722ca20 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2880,7 +2880,7 @@ static struct tipc_sock *tipc_sk_lookup(struct net *net, u32 portid)
 	struct tipc_sock *tsk;
 
 	rcu_read_lock();
-	tsk = rhashtable_lookup_fast(&tn->sk_rht, &portid, tsk_rht_params);
+	tsk = rhashtable_lookup(&tn->sk_rht, &portid, tsk_rht_params);
 	if (tsk)
 		sock_hold(&tsk->sk);
 	rcu_read_unlock();
-- 
2.17.1

