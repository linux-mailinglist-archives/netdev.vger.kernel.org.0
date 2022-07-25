Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C11858034D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 19:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiGYRH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 13:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236338AbiGYRHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 13:07:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059FD17A8C
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 10:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658768875; x=1690304875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x9ME1vZkDFFq3vIc3bHTC8f3jXRDsGsn/+NC+S2tG4c=;
  b=j+1zjYSiB93pzaGpST6iz+UNb+6yxnlaw6/K+lP3wzwx7Ry2SFuT8Bpp
   QiZaR413Yt8t8D3ZxkiUzvkX3DPSNvTfNT8+DgTMqWf0LaIvEO7qNYjan
   QKk0gDsPKhsD20CX1NiVf/rfIRSANZVEEGzgqGkW0yPiClvPvjwAdxz3e
   1+0zieUmphrPZ/Q5f5K+0l1R3Krd7YlJJ0DQbWYo8lBqGdZfhKrBOHCmM
   rR16R1CXVB9GclfuXU386hhofQAAP0rCBac2bsG2Vjue1AIsFYWgtftd2
   zN1AjxE5Q199c920XV9N6thHO5SgH28y15zfx35uGEjDlStU8k10w4K7I
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="270785657"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="270785657"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 10:07:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="845577981"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 25 Jul 2022 10:07:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net 2/3] iavf: Fix 'tc qdisc show' listing too many queues
Date:   Mon, 25 Jul 2022 10:04:51 -0700
Message-Id: <20220725170452.920964-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
References: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix tc qdisc show dev <ethX> root displaying too many fq_codel qdiscs.
tc_modify_qdisc, which is caller of ndo_setup_tc, expects driver to call
netif_set_real_num_tx_queues, which prepares qdiscs.
Without this patch, fq_codel qdiscs would not be adjusted to number of
queues on VF.
e.g.:
tc qdisc show dev <ethX>
qdisc mq 0: root
qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
tc qdisc add dev <ethX> root mqprio num_tc 2 map 1 0 0 0 0 0 0 0 queues 1@0 1@1 hw 1 mode channel shaper bw_rlimit max_rate 5000Mbit 150Mbit
tc qdisc show dev <ethX>
qdisc mqprio 8003: root tc 2 map 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             queues:(0:0) (1:1)
             mode:channel
             shaper:bw_rlimit   max_rate:5Gbit 150Mbit
qdisc fq_codel 0: parent 8003:4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent 8003:3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent 8003:2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent 8003:1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64

While after fix:
tc qdisc add dev <ethX> root mqprio num_tc 2 map 1 0 0 0 0 0 0 0 queues 1@0 1@1 hw 1 mode channel shaper bw_rlimit max_rate 5000Mbit 150Mbit
tc qdisc show dev <ethX> #should show 2, shows 4
qdisc mqprio 8004: root tc 2 map 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             queues:(0:0) (1:1)
             mode:channel
             shaper:bw_rlimit   max_rate:5Gbit 150Mbit
qdisc fq_codel 0: parent 8004:2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
qdisc fq_codel 0: parent 8004:1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64

Fixes: d5b33d024496 ("i40evf: add ndo_setup_tc callback to i40evf")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Co-developed-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Co-developed-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  5 +++++
 drivers/net/ethernet/intel/iavf/iavf_main.c | 21 +++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index c241fbc30f93..a988c08e906f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -431,6 +431,11 @@ struct iavf_adapter {
 	/* lock to protect access to the cloud filter list */
 	spinlock_t cloud_filter_list_lock;
 	u16 num_cloud_filters;
+	/* snapshot of "num_active_queues" before setup_tc for qdisc add
+	 * is invoked. This information is useful during qdisc del flow,
+	 * to restore correct number of queues
+	 */
+	int orig_num_active_queues;
 
 #define IAVF_MAX_FDIR_FILTERS 128	/* max allowed Flow Director filters */
 	u16 fdir_active_fltr;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 51ae10eb348c..3dbfaead2ac7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3429,6 +3429,7 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 			netif_tx_disable(netdev);
 			iavf_del_all_cloud_filters(adapter);
 			adapter->aq_required = IAVF_FLAG_AQ_DISABLE_CHANNELS;
+			total_qps = adapter->orig_num_active_queues;
 			goto exit;
 		} else {
 			return -EINVAL;
@@ -3472,7 +3473,21 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 				adapter->ch_config.ch_info[i].offset = 0;
 			}
 		}
+
+		/* Take snapshot of original config such as "num_active_queues"
+		 * It is used later when delete ADQ flow is exercised, so that
+		 * once delete ADQ flow completes, VF shall go back to its
+		 * original queue configuration
+		 */
+
+		adapter->orig_num_active_queues = adapter->num_active_queues;
+
+		/* Store queue info based on TC so that VF gets configured
+		 * with correct number of queues when VF completes ADQ config
+		 * flow
+		 */
 		adapter->ch_config.total_qps = total_qps;
+
 		netif_tx_stop_all_queues(netdev);
 		netif_tx_disable(netdev);
 		adapter->aq_required |= IAVF_FLAG_AQ_ENABLE_CHANNELS;
@@ -3489,6 +3504,12 @@ static int __iavf_setup_tc(struct net_device *netdev, void *type_data)
 		}
 	}
 exit:
+	if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
+		return 0;
+
+	netif_set_real_num_rx_queues(netdev, total_qps);
+	netif_set_real_num_tx_queues(netdev, total_qps);
+
 	return ret;
 }
 
-- 
2.35.1

