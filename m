Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5295EB223
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiIZUc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiIZUcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:32:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD95A4B90
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 13:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664224342; x=1695760342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rEgVx8YEjEfIoDVie6jskmWt58BSvMdKVzYkqaLaSZk=;
  b=jz4FkEb3IqT9qxAIt7SDrzsTuhJIevbp/vB5/9vbrmcwp/3Lr/8D+dxO
   xYR4KzxKxgP3S+mF3m28H3y/l5ZeCX31X+EYx8oUjhX/dfxN4yiEMz47R
   n+z60/bNPCYoDgf01W69n8/t9VtZYh8iZHeSu4ZeiV4AR01f4PkJ6g7s/
   fGes5MGaPazKOVReE+FnLk6vsbmhCiUidLQgJeod8xFDb41XFktniSFPI
   re/Nd+gBdnSujzP1jpclqIdjGkL0E0zR1sVh09dVPk++J38d7uOQeqMeK
   9Pfzu85Zkj3F4bvn1mm+qM9bY2HNQ2mTEjbYzd3FP2M/T7+f1q2V0hy2y
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="281508586"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="281508586"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 13:32:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="616547447"
X-IronPort-AV: E=Sophos;i="5.93,347,1654585200"; 
   d="scan'208";a="616547447"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 26 Sep 2022 13:32:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Jaron <michalx.jaron@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
Date:   Mon, 26 Sep 2022 13:32:13 -0700
Message-Id: <20220926203214.3678419-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
References: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

During tx rings configuration default XPS queue config is set and
__I40E_TX_XPS_INIT_DONE is locked. XPS CPUs maps are cleared in
every reset by netdev_set_num_tc() call regardless it was set by
user or driver. If reset with reinit occurs __I40E_TX_XPS_INIT_DONE
flag is removed and XPS mapping is set to default again but after
reset without reinit this flag is still set and XPS CPUs to queues
mapping stays cleared.

Add code to preserve xps_cpus mapping as cpumask for every queue
and restore those mapping at the end of reset.

Fixes: 6f853d4f8e93 ("i40e: allow XPS with QoS enabled")
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      |   6 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c | 109 ++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index d86b6d349ea9..238d00d3423a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1306,4 +1306,10 @@ static inline u32 i40e_is_tc_mqprio_enabled(struct i40e_pf *pf)
 	return pf->flags & I40E_FLAG_TC_MQPRIO;
 }
 
+/* reverse XPS CPUs to tx queues map */
+struct i40e_qmap_rev {
+	struct cpumask cpus;
+	int vsi_id;
+};
+
 #endif /* _I40E_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e3d9804aeb25..452ed104766e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10793,6 +10793,83 @@ static int i40e_reset(struct i40e_pf *pf)
 	return ret;
 }
 
+#ifdef CONFIG_XPS
+/**
+ * i40e_preserve_xps_settings - preserve XPS maps before reset
+ * @vsi: pointer to the targeted VSI
+ * @qr: pointer to the structure with XPS mapping
+ *
+ * Read queues mapping from every CPU and save it as a CPU mask for every
+ * queue.
+ **/
+static void
+i40e_preserve_xps_settings(struct i40e_vsi *vsi, struct i40e_qmap_rev *qr)
+{
+	int cpu, q_idx, cpu_idx, cpus = num_online_cpus();
+	struct net_device *netdev = vsi->netdev;
+	struct xps_dev_maps *dev_maps;
+	struct xps_map *map;
+	u64 bitmap_arr;
+
+	if (!netdev || vsi->type != I40E_VSI_MAIN)
+		return;
+
+	if (cpus < vsi->num_queue_pairs) {
+		dev_warn(&vsi->back->pdev->dev,
+			 "There are more queues than cpus. To set xps maps properly reinitialize queues.\n");
+		return;
+	}
+
+	rcu_read_lock();
+
+	if (!netdev->xps_maps[XPS_CPUS])
+		goto out;
+
+	dev_maps = rcu_dereference(netdev->xps_maps[XPS_CPUS]);
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		cpu_idx = cpumask_local_spread(cpu, -1);
+		if (!dev_maps->attr_map[cpu_idx])
+			continue;
+
+		map = rcu_dereference(dev_maps->attr_map[cpu_idx]);
+		bitmap_arr = cpu_idx;
+		do_div(bitmap_arr, BITS_PER_LONG);
+		for (q_idx = 0; q_idx < map->len; q_idx++) {
+			qr[map->queues[q_idx]].vsi_id = vsi->id;
+			qr[map->queues[q_idx]].cpus.bits[bitmap_arr] |=
+				BIT(cpu_idx);
+		}
+	}
+
+out:
+	rcu_read_unlock();
+}
+
+/**
+ * i40e_restore_xps_settings - restore XPS maps after reset
+ * @vsi: pointer to the targeted VSI
+ * @qr: pointer to the structure with XPS mapping
+ *
+ * Set previously preserved XPS CPUs to queues mapping.
+ **/
+static void
+i40e_restore_xps_settings(struct i40e_vsi *vsi, struct i40e_qmap_rev *qr)
+{
+	struct net_device *netdev = vsi->netdev;
+	int q_count, q;
+
+	q_count = min_t(unsigned int, num_online_cpus(), vsi->num_queue_pairs);
+
+	if (vsi->type != I40E_VSI_MAIN)
+		return;
+
+	for (q = 0; q < q_count; q++)
+		if (qr[q].vsi_id == vsi->id)
+			netif_set_xps_queue(netdev, &qr[q].cpus, q);
+}
+
+#endif /* CONFIG_XPS */
 /**
  * i40e_rebuild - rebuild using a saved config
  * @pf: board private structure
@@ -10804,6 +10881,9 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 {
 	const bool is_recovery_mode_reported = i40e_check_recovery_mode(pf);
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
+#ifdef CONFIG_XPS
+	struct i40e_qmap_rev *qr = NULL;
+#endif /* CONFIG_XPS */
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status ret;
 	u32 val;
@@ -10919,6 +10999,22 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	}
 
 #endif /* CONFIG_I40E_DCB */
+#ifdef CONFIG_XPS
+	if (!reinit) {
+		int cpus = num_possible_cpus();
+
+		qr = kcalloc(cpus, sizeof(struct i40e_qmap_rev), GFP_KERNEL);
+		if (!qr) {
+			ret = -ENOMEM;
+			goto end_unlock;
+		}
+
+		for (v = 0; v < pf->num_alloc_vsi; v++)
+			if (pf->vsi[v])
+				i40e_preserve_xps_settings(pf->vsi[v], qr);
+	}
+
+#endif /* CONFIG_XPS */
 	if (!lock_acquired)
 		rtnl_lock();
 	ret = i40e_setup_pf_switch(pf, reinit, true);
@@ -11073,6 +11169,16 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 
 	i40e_reset_all_vfs(pf, true);
 
+#ifdef CONFIG_XPS
+	if (!reinit) {
+		for (v = 0; v < pf->num_alloc_vsi; v++)
+			if (pf->vsi[v])
+				i40e_restore_xps_settings(pf->vsi[v], qr);
+	} else {
+		dev_info(&pf->pdev->dev, "XPS maps were reset to default after queue re-initialization");
+	}
+
+#endif /* CONFIG_XPS */
 	/* tell the firmware that we're starting */
 	i40e_send_version(pf);
 
@@ -11082,6 +11188,9 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 end_unlock:
 	if (!lock_acquired)
 		rtnl_unlock();
+#ifdef CONFIG_XPS
+	kfree(qr);
+#endif /* CONFIG_XPS */
 end_core_reset:
 	clear_bit(__I40E_RESET_FAILED, pf->state);
 clear_recovery:
-- 
2.35.1

