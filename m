Return-Path: <netdev+bounces-7199-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 583C571F0BC
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCF3B1C2101D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D8D46FFF;
	Thu,  1 Jun 2023 17:28:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9E442501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:28:32 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0FC197
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685640510; x=1717176510;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VTCQVlNvw+HDeCLZctIdNaIhEf7FG4AyishSLgIg3PE=;
  b=b9sfLdR4PHLOF3YOHaQNpV8O451b/REPfrQt+r7dpMsiokDl7gX8Hqo+
   Ub5I6fwWRlbPTJqdErXY8Mf2BlNfQemRCe84ZfoKtUDgR/lerDo3WwkXu
   9NLvJtHkhYDb4lyqeDsDhntmzqtia7jSTLGx2k6SHEC4R6IPIuecZuvXI
   k8vn+W/Y8LkCaLK/gPgyEUl3q6d0JuwjpkTAlWwMvvyUBBL/AjM1hsX6W
   WiehDJWFDAOrGbT7tZBt7kjsTBp4XynX7d6KuMhUlvK6BUdPlnEv6cI6U
   wWK1mntw/2wguuYgTLol0T5U0fJXZ+7f3iR7rWrLlMfTt1L9F8xSIHonD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="355647469"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="355647469"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 10:28:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="701638178"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="701638178"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2023 10:28:29 -0700
Subject: [net-next/RFC PATCH v1 1/4] net: Introduce new napi fields for
 rx/tx queues
From: Amritha Nambiar <amritha.nambiar@intel.com>
To: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc: sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date: Thu, 01 Jun 2023 10:42:25 -0700
Message-ID: <168564134580.7284.16867711571036004706.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
References: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce new napi fields 'napi_rxq_list' and 'napi_txq_list'
for rx and tx queue set associated with the napi and
initialize them. Handle their removal as well.

This enables a mapping of each napi instance with the
queue/queue-set on the corresponding irq line.

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 include/linux/netdevice.h |    7 +++++++
 net/core/dev.c            |   21 +++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 08fbd4622ccf..49f64401af7c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -342,6 +342,11 @@ struct gro_list {
  */
 #define GRO_HASH_BUCKETS	8
 
+struct napi_queue {
+	struct list_head	q_list;
+	u16			queue_index;
+};
+
 /*
  * Structure for NAPI scheduling similar to tasklet but with weighting
  */
@@ -376,6 +381,8 @@ struct napi_struct {
 	/* control-path-only fields follow */
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
+	struct list_head	napi_rxq_list;
+	struct list_head	napi_txq_list;
 };
 
 enum {
diff --git a/net/core/dev.c b/net/core/dev.c
index 3393c2f3dbe8..9ee8eb3ef223 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6401,6 +6401,9 @@ void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 	 */
 	if (dev->threaded && napi_kthread_create(napi))
 		dev->threaded = 0;
+
+	INIT_LIST_HEAD(&napi->napi_rxq_list);
+	INIT_LIST_HEAD(&napi->napi_txq_list);
 }
 EXPORT_SYMBOL(netif_napi_add_weight);
 
@@ -6462,6 +6465,23 @@ static void flush_gro_hash(struct napi_struct *napi)
 	}
 }
 
+static void __napi_del_queue(struct napi_queue *napi_queue)
+{
+	list_del_rcu(&napi_queue->q_list);
+	kfree(napi_queue);
+}
+
+static void napi_del_queues(struct napi_struct *napi)
+{
+	struct napi_queue *napi_queue, *n;
+
+	list_for_each_entry_safe(napi_queue, n, &napi->napi_rxq_list, q_list)
+		__napi_del_queue(napi_queue);
+
+	list_for_each_entry_safe(napi_queue, n, &napi->napi_txq_list, q_list)
+		__napi_del_queue(napi_queue);
+}
+
 /* Must be called in process context */
 void __netif_napi_del(struct napi_struct *napi)
 {
@@ -6479,6 +6499,7 @@ void __netif_napi_del(struct napi_struct *napi)
 		kthread_stop(napi->thread);
 		napi->thread = NULL;
 	}
+	napi_del_queues(napi);
 }
 EXPORT_SYMBOL(__netif_napi_del);
 


