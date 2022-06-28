Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE6955EEA2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiF1Txd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiF1Tu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C7A2BB02;
        Tue, 28 Jun 2022 12:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445792; x=1687981792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n5bnddshct4lzfMKnn45sHWwTzSqDqX5LzB68we3Q6Q=;
  b=Im4sDK6NiaLeCnl/W2PkC6o4jIf3WZC948fOzJVRf8CniDqR+Qbtj4p6
   mKR3HpecQ37hErlyN23Jo920xlfxyFUDvhCmRfoOC1o2ZLOkM+8Yrjl+y
   5opLdkwMAaGOA2R97jyp4wIyskFpIeqGj0PbcvxDViDjQsomWwRUlOh6A
   huDTw2yRhO3l09sagLEH72QqT9toNRXtihivghqOWQb+lyr8qOKxieYdi
   sowCWaLvFEGAfzZs/cBIm6fHtyH0uxobBIOuPSmm/Al20XPNg1WpcfKlM
   GHOxRy3oC8D5ILgcml+9Gt1Q+r3qC08ML0XoJvKnHAiFGzsY9uocKKwOK
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="281869648"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="281869648"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="836809505"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jun 2022 12:49:39 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9X022013;
        Tue, 28 Jun 2022 20:49:38 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 33/52] bpf, cpumap: add option to set a timeout for deferred flush
Date:   Tue, 28 Jun 2022 21:47:53 +0200
Message-Id: <20220628194812.1453059-34-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GRO efficiency depends a lot on the batch size. With the size of 8,
it is less efficient than e.g. with NAPI and the size of 64.
To do less percentage of full flushes and not hold GRO packets for
too long, use the GRO hrtimer to wake up the kthread even if there's
no new frames in the ptr_ring. Its value is being passed from the
user side inside the corresponding &bpf_cpumap_val on map creation,
in nanoseconds.
When the timeout is 0/unset, the behaviour is the same as it was
prior to the change.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/cpumap.c            | 39 +++++++++++++++++++++++++++++-----
 tools/include/uapi/linux/bpf.h |  1 +
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1caaec1de625..097719ee2172 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5989,6 +5989,7 @@ struct bpf_cpumap_val {
 		int   fd;	/* prog fd on map write */
 		__u32 id;	/* prog id on map read */
 	} bpf_prog;
+	__u64 timeout;		/* timeout to wait for new packets, in ns */
 };
 
 enum sk_action {
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 2d0edf8f6a05..145f49de0931 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -95,7 +95,8 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	/* check sanity of attributes */
 	if (attr->max_entries == 0 || attr->key_size != 4 ||
 	    (value_size != offsetofend(struct bpf_cpumap_val, qsize) &&
-	     value_size != offsetofend(struct bpf_cpumap_val, bpf_prog.fd)) ||
+	     value_size != offsetofend(struct bpf_cpumap_val, bpf_prog.fd) &&
+	     value_size != offsetofend(struct bpf_cpumap_val, timeout)) ||
 	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
 
@@ -312,18 +313,42 @@ static void cpu_map_gro_flush(struct bpf_cpu_map_entry *rcpu,
 		/* If the ring is not empty, there'll be a new iteration
 		 * soon, and we only need to do a full flush if a tick is
 		 * long (> 1 ms).
-		 * If the ring is empty, to not hold GRO packets in the
-		 * stack for too long, do a full flush.
+		 * If the ring is empty, and there were some new packets
+		 * processed, either do a partial flush and spin up a timer
+		 * to flush the rest if the timeout is set, or do a full
+		 * flush otherwise.
+		 * No new packets with non-zero gro_bitmask can mean that we
+		 * probably came from the timer call and/or there's [almost]
+		 * no activity here right now. To not hold GRO packets in
+		 * the stack for too long, do a full flush.
 		 * This is equivalent to how NAPI decides whether to perform
 		 * a full flush (by batches of up to 64 frames tho).
 		 */
 		if (__ptr_ring_empty(rcpu->queue))
-			flush_old = false;
+			flush_old = new ? !!rcpu->value.timeout : false;
 
 		__gro_flush(&rcpu->gro, flush_old);
 	}
 
 	gro_normal_list(&rcpu->gro);
+
+	/* Non-zero gro_bitmask at this point means that we have some packets
+	 * held in the GRO engine after a partial flush. If we have a timeout
+	 * set up, and there are no signs of a new kthread iteration, launch
+	 * a timer to flush them as well.
+	 */
+	if (rcpu->gro.bitmask && __ptr_ring_empty(rcpu->queue))
+		gro_timer_start(&rcpu->gro, rcpu->value.timeout);
+}
+
+static enum hrtimer_restart cpu_map_gro_watchdog(struct hrtimer *timer)
+{
+	const struct bpf_cpu_map_entry *rcpu;
+
+	rcpu = container_of(timer, typeof(*rcpu), gro.timer);
+	wake_up_process(rcpu->kthread);
+
+	return HRTIMER_NORESTART;
 }
 
 static int cpu_map_kthread_run(void *data)
@@ -489,8 +514,9 @@ __cpu_map_entry_alloc(struct bpf_map *map, struct bpf_cpumap_val *value,
 	rcpu->cpu    = cpu;
 	rcpu->map_id = map->id;
 	rcpu->value.qsize  = value->qsize;
+	rcpu->value.timeout = value->timeout;
 
-	gro_init(&rcpu->gro, NULL);
+	gro_init(&rcpu->gro, cpu_map_gro_watchdog);
 
 	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, map, fd))
 		goto free_gro;
@@ -606,6 +632,9 @@ static int cpu_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EEXIST;
 	if (unlikely(cpumap_value.qsize > 16384)) /* sanity limit on qsize */
 		return -EOVERFLOW;
+	/* Don't allow timeout longer than 1 ms -- 1 tick on HZ == 1000 */
+	if (unlikely(cpumap_value.timeout > 1 * NSEC_PER_MSEC))
+		return -ERANGE;
 
 	/* Make sure CPU is a valid possible cpu */
 	if (key_cpu >= nr_cpumask_bits || !cpu_possible(key_cpu))
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 436b925adfb3..a3579cdb0225 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5989,6 +5989,7 @@ struct bpf_cpumap_val {
 		int   fd;	/* prog fd on map write */
 		__u32 id;	/* prog id on map read */
 	} bpf_prog;
+	__u64 timeout;		/* timeout to wait for new packets, in ns */
 };
 
 enum sk_action {
-- 
2.36.1

