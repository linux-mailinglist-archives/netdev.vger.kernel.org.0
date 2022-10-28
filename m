Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85DB611865
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJ1Q4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJ1Qzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:55:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A0814D28
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 09:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666976095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdcDk47USY1AAs2NC9Jgcp38nSNmzzXOjaUWiRf+Iv4=;
        b=EqzcE6ufYOatEIBlno9Mz6DP3yMMTQwjMnfvhMOikFIkkUxSVDp14w8y8YXEt3BT7WgF5g
        3AIyFpvp7+yVFDRR0ZMrIlfyoB8AevnAr69uK9PhMvc50AY5F0Aa1s7yMu+PsWB6aYSRUV
        tXGyn2IWqgI4FTO8ZLRnVHQxp7kQa0Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-396-9x9OIlFFP16S9gcTlz5-cw-1; Fri, 28 Oct 2022 12:54:53 -0400
X-MC-Unique: 9x9OIlFFP16S9gcTlz5-cw-1
Received: by mail-wm1-f70.google.com with SMTP id r187-20020a1c44c4000000b003c41e9ae97dso1229003wma.6
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 09:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VdcDk47USY1AAs2NC9Jgcp38nSNmzzXOjaUWiRf+Iv4=;
        b=VvUPV6qjbpQ6ixN8EIFu6+wJ6zwuXCgQuagqA3t7bZhwol3cHrMG6BgcLLPdNfsB/X
         N4uWEpHZ6xWmP/qDHgRGtAZMBz3U5CosvbAwytcaav6mQ555IxsRgBroshh8DAkt/bF/
         ZxJ74DN8Cc3CloWARmdVCwyiTfiuSn89KwIG2Vo/r/FQ8AFRgOJler+82cm1gYuqcIL7
         nOlHsBaZt3rNAmeCBcapo/uJuVAnGP4dKKN/VS71WIbQmkeTTuCAoo511I6nxPvHNqDq
         XacV45CaL9zwN1ZCBatxhpx3C8x/AZdPDTYMpV9vCYbYKEeAR4UnZEdkCTP5DRMJAqSf
         8KJg==
X-Gm-Message-State: ACrzQf0cyjd5s5Zmf32FxOmLb4k2C8rRxGhPrnxorzF9Oe75SYJoflsP
        e/2w+iHkJloMJNkQsG9DNzhmxrGrHqZiQkO2v1V1TgK3PSb/VfYbk5L3Mz34cffFB2yOzrkGUej
        uaVGQnPI6btUkEzBbgcdAH4lYOIedemFIxw9Yg3XEc+xtDi1fehFDLVSHuRPi+nMUG9Wh
X-Received: by 2002:a05:600c:5252:b0:3c6:f478:96db with SMTP id fc18-20020a05600c525200b003c6f47896dbmr129969wmb.116.1666976087608;
        Fri, 28 Oct 2022 09:54:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7f0szCZRq/AyWSF4FAbMLi4c+VZ61awGxbMQMux0B+kV44EN3ui369YGc5WFbD9TcBb6f5Wg==
X-Received: by 2002:a05:600c:5252:b0:3c6:f478:96db with SMTP id fc18-20020a05600c525200b003c6f47896dbmr129938wmb.116.1666976087392;
        Fri, 28 Oct 2022 09:54:47 -0700 (PDT)
Received: from vschneid.remote.csb ([149.71.65.94])
        by smtp.gmail.com with ESMTPSA id l2-20020a7bc342000000b003c6c182bef9sm9239733wmj.36.2022.10.28.09.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 09:54:46 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v6 2/3] sched/topology: Introduce for_each_numa_hop_mask()
Date:   Fri, 28 Oct 2022 17:54:28 +0100
Message-Id: <20221028165429.1368452-1-vschneid@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221028164959.1367250-1-vschneid@redhat.com>
References: <20221028164959.1367250-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recently introduced sched_numa_hop_mask() exposes cpumasks of CPUs
reachable within a given distance budget, wrap the logic for iterating over
all (distance, mask) values inside an iterator macro.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/topology.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 64199545d7cf6..2223c987a1383 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -255,5 +255,22 @@ sched_numa_hop_mask(unsigned int node, unsigned int hops)
 }
 #endif	/* CONFIG_NUMA */
 
+/**
+ * for_each_numa_hop_mask - iterate over cpumasks of increasing NUMA distance
+ *                          from a given node.
+ * @mask: the iteration variable.
+ * @node: the NUMA node to start the search from.
+ *
+ * Requires rcu_lock to be held.
+ *
+ * Yields cpu_online_mask for @node == NUMA_NO_NODE.
+ */
+#define for_each_numa_hop_mask(mask, node)				       \
+	for (unsigned int __hops = 0;					       \
+	     mask = (node != NUMA_NO_NODE || __hops) ?			       \
+		     sched_numa_hop_mask(node, __hops) :		       \
+		     cpu_online_mask,					       \
+	     !IS_ERR_OR_NULL(mask);					       \
+	     __hops++)
 
 #endif /* _LINUX_TOPOLOGY_H */
-- 
2.31.1

