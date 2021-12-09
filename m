Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF6046EB02
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhLIPYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:24:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:60802 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235386AbhLIPYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 10:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639063244; x=1670599244;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bdw1RTX2kWck3hV4J6vEWkVw9pJC5wrYcReD90eFdFI=;
  b=DhTGnqSakI+MKl+5lEP0J9E24iEvmbwuvfiOZYmQyGR0WyWoHkKPIUa+
   0cyrXquDuxadqULR7xDOd4nMaDSPIpnASC8fbM/7jE1VkOkr2tSkmNR3B
   1n8C6f+oXZBMY4Q0UhBVY9RSiTyB+1/FlCseO9uSCkrXJfD1NxpDoFzZ7
   d3xRtV3111AQ9GzxOBheX4hEGogMhzCd5sr+wzrhacLgzYr+c2BeV4p9T
   a4r2peON6N2NS7ZG4g9sE5vLZ29IYnMijuWFDC0dos6XqN+n3c2gMCWw5
   lYuxwy9rj0nW2G0m2M2uVIkte5bkNbcJuZQ+nddff1R6GCgH+/OuDyYos
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="235631457"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="235631457"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 07:20:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="601585429"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Dec 2021 07:20:34 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 1/2] net: stmmac: fix tc flower deletion for VLAN priority Rx steering
Date:   Thu,  9 Dec 2021 23:16:30 +0800
Message-Id: <20211209151631.138326-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209151631.138326-1-boon.leong.ong@intel.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To replicate the issue:-

1) Add 2 flower filters for VLAN Priority based frame steering:-
$ IFDEVNAME=eth0
$ tc qdisc add dev $IFDEVNAME ingress
$ tc qdisc add dev $IFDEVNAME root mqprio num_tc 8 \
   map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0 \
   queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
$ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
   flower vlan_prio 0 hw_tc 0
$ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
   flower vlan_prio 1 hw_tc 1

2) Get the 'pref' id
$ tc filter show dev $IFDEVNAME ingress

3) Delete a specific tc flower record
$ tc filter del dev $IFDEVNAME parent ffff: pref 49151

From dmesg, we will observe kernel NULL pointer ooops

[  197.170464] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  197.171367] #PF: supervisor read access in kernel mode
[  197.171367] #PF: error_code(0x0000) - not-present page
[  197.171367] PGD 0 P4D 0
[  197.171367] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  197.171367] CPU: 0 PID: 3216 Comm: tc Tainted: G     U      E     5.16.0-rc2+ #12
[  197.171367] Hardware name: Intel Corporation Elkhart Lake Embedded Platform/ElkhartLake LPDDR4x T3 CRB, BIOS EHLSFWI1.R00.3273.A04.2107240322 07/24/2021
[  197.171367] RIP: 0010:tc_setup_cls+0x20b/0x4a0 [stmmac]
[  197.171367] Code: fe ff ff c7 43 14 00 00 00 00 48 c7 03 00 00 00 00 c7 43 1c 00 00 00 00 49 8b 44 24 28 48 8b bd b0 00 00 00 41 0f b7 54 24 58 <48> 8b 00 0f bf 8f 38 08 00 00 81 ea e0 ff 00 00 8b 00 25 00 04 00
[  197.171367] RSP: 0018:ffff940940a037c0 EFLAGS: 00010246
[  197.171367] RAX: 0000000000000000 RBX: ffff92e826cae2c8 RCX: ffff92e825f39000
[  197.171367] RDX: 0000000000000000 RSI: ffff92e826cae2a8 RDI: ffff92e82f0c0000
[  197.171367] RBP: ffff92e82f0c0940 R08: 0000000000000000 R09: ffff92e825f39434
[  197.171367] R10: ffff92e826c5af00 R11: ffff940940a038a8 R12: ffff940940a038a8
[  197.171367] R13: 0000000000000000 R14: 0000000000000000 R15: ffff92e830a5b600
[  197.171367] FS:  00007fa7b0c47740(0000) GS:ffff92e964200000(0000) knlGS:0000000000000000
[  197.171367] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  197.171367] CR2: 0000000000000000 CR3: 0000000124c50000 CR4: 0000000000350ef0
[  197.171367] Call Trace:
[  197.171367]  <TASK>
[  197.171367]  ? __stmmac_disable_all_queues+0xa8/0xe0 [stmmac]
[  197.171367]  stmmac_setup_tc_block_cb+0x70/0x110 [stmmac]
[  197.171367]  tc_setup_cb_destroy+0xb3/0x180
[  197.171367]  fl_hw_destroy_filter+0x94/0xc0 [cls_flower]
[  197.171367]  __fl_delete+0x16a/0x180 [cls_flower]
[  197.171367]  fl_destroy+0xb9/0x140 [cls_flower]
[  197.171367]  tcf_proto_destroy+0x1d/0xa0
[  197.171367]  tc_del_tfilter+0x3c9/0x7b0
[  197.171367]  ? tc_dump_tfilter+0x310/0x310
[  197.171367]  rtnetlink_rcv_msg+0x2bf/0x370
[  197.171367]  ? preempt_count_add+0x68/0xa0
[  197.171367]  ? _raw_spin_lock_irqsave+0x19/0x40
[  197.171367]  ? _raw_spin_unlock_irqrestore+0x1f/0x31
[  197.171367]  ? rtnl_calcit.isra.0+0x130/0x130
[  197.171367]  netlink_rcv_skb+0x4e/0x100
[  197.171367]  netlink_unicast+0x18e/0x230
[  197.171367]  netlink_sendmsg+0x245/0x480
[  197.171367]  sock_sendmsg+0x5b/0x60
[  197.171367]  ____sys_sendmsg+0x20b/0x280
[  197.171367]  ? copy_msghdr_from_user+0x5c/0x90
[  197.171367]  ___sys_sendmsg+0x7c/0xc0
[  197.171367]  ? folio_add_lru+0x52/0x80
[  197.171367]  ? __sys_sendto+0xee/0x160
[  197.171367]  __sys_sendmsg+0x59/0xa0
[  197.171367]  do_syscall_64+0x40/0x90
[  197.171367]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  197.171367] RIP: 0033:0x7fa7b0d64397
[  197.171367] Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[  197.171367] RSP: 002b:00007ffdd88b58e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  197.171367] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa7b0d64397
[  197.171367] RDX: 0000000000000000 RSI: 00007ffdd88b5960 RDI: 0000000000000003
[  197.171367] RBP: 0000000061b05c21 R08: 0000000000000001 R09: 0000564584e47890
[  197.171367] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[  197.171367] R13: 00007ffdd88b9a80 R14: 00000000bfff0000 R15: 0000564584e3e420
[  197.171367]  </TASK>
[  197.171367] Modules linked in: cls_flower sch_mqprio sch_ingress dwmac_intel(E) stmmac(E) pcs_xpcs phylink marvell marvell10g libphy 8021q bnep bluetooth ecryptfs nfsd sch_fq_codel uio uhid snd_soc_dmic snd_sof_pci_intel_tgl x86_pkg_temp_thermal snd_sof_intel_hda_common kvm_intel iTCO_wdt iTCO_vendor_support soundwire_intel mei_hdcp kvm soundwire_generic_allocation soundwire_cadence soundwire_bus irqbypass snd_sof_xtensa_dsp ax88179_178a snd_soc_acpi_intel_match intel_rapl_msr pcspkr usbnet snd_soc_acpi mii snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec i2c_i801 snd_hda_core intel_ish_ipc tpm_crb 8250_lpss intel_ishtp tpm_tis i915 mei_me i2c_smbus mei tpm_tis_core dw_dmac_core tpm spi_dw_pci parport_pc intel_pmc_core spi_dw thermal parport ttm fuse configfs snd_sof_pci snd_sof snd_soc_core snd_compress ac97_bus ledtrig_audio snd_pcm snd_timer snd soundcore [last unloaded: libphy]
[  197.171367] CR2: 0000000000000000
[  197.171367] ---[ end trace 8b8d1c617c39093d ]---

This patch reimplements the tc flower rx frame steering for VLAN priority
by keeping a record of flow_cls_offload added. The implementation also
makes way to support EtherType based RX frame steering later.

Fixes: 0e039f5cf86c ("net: stmmac: add RX frame steering based on VLAN priority in tc flower")
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  | 17 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 86 ++++++++++++++++---
 2 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 4f5292cadf5..18a262ef17f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -171,6 +171,19 @@ struct stmmac_flow_entry {
 	int is_l4;
 };
 
+/* Rx Frame Steering */
+enum stmmac_rfs_type {
+	STMMAC_RFS_T_VLAN,
+	STMMAC_RFS_T_MAX,
+};
+
+struct stmmac_rfs_entry {
+	unsigned long cookie;
+	int in_use;
+	int type;
+	int tc;
+};
+
 struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
 	u32 tx_coal_frames[MTL_MAX_TX_QUEUES];
@@ -288,6 +301,10 @@ struct stmmac_priv {
 	struct stmmac_tc_entry *tc_entries;
 	unsigned int flow_entries_max;
 	struct stmmac_flow_entry *flow_entries;
+	unsigned int rfs_entries_max[STMMAC_RFS_T_MAX];
+	unsigned int rfs_entries_cnt[STMMAC_RFS_T_MAX];
+	unsigned int rfs_entries_total;
+	struct stmmac_rfs_entry *rfs_entries;
 
 	/* Pulse Per Second output */
 	struct stmmac_pps_cfg pps[STMMAC_PPS_MAX];
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 1c4ea0b1b84..d0a2b289f46 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -232,11 +232,33 @@ static int tc_setup_cls_u32(struct stmmac_priv *priv,
 	}
 }
 
+static int tc_rfs_init(struct stmmac_priv *priv)
+{
+	int i;
+
+	priv->rfs_entries_max[STMMAC_RFS_T_VLAN] = 8;
+
+	for (i = 0; i < STMMAC_RFS_T_MAX; i++)
+		priv->rfs_entries_total += priv->rfs_entries_max[i];
+
+	priv->rfs_entries = devm_kcalloc(priv->device,
+					 priv->rfs_entries_total,
+					 sizeof(*priv->rfs_entries),
+					 GFP_KERNEL);
+	if (!priv->rfs_entries)
+		return -ENOMEM;
+
+	dev_info(priv->device, "Enabled RFS Flow TC (entries=%d)\n",
+		 priv->rfs_entries_total);
+
+	return 0;
+}
+
 static int tc_init(struct stmmac_priv *priv)
 {
 	struct dma_features *dma_cap = &priv->dma_cap;
 	unsigned int count;
-	int i;
+	int ret, i;
 
 	if (dma_cap->l3l4fnum) {
 		priv->flow_entries_max = dma_cap->l3l4fnum;
@@ -250,10 +272,14 @@ static int tc_init(struct stmmac_priv *priv)
 		for (i = 0; i < priv->flow_entries_max; i++)
 			priv->flow_entries[i].idx = i;
 
-		dev_info(priv->device, "Enabled Flow TC (entries=%d)\n",
+		dev_info(priv->device, "Enabled L3L4 Flow TC (entries=%d)\n",
 			 priv->flow_entries_max);
 	}
 
+	ret = tc_rfs_init(priv);
+	if (ret)
+		return -ENOMEM;
+
 	if (!priv->plat->fpe_cfg) {
 		priv->plat->fpe_cfg = devm_kzalloc(priv->device,
 						   sizeof(*priv->plat->fpe_cfg),
@@ -607,16 +633,45 @@ static int tc_del_flow(struct stmmac_priv *priv,
 	return ret;
 }
 
+static struct stmmac_rfs_entry *tc_find_rfs(struct stmmac_priv *priv,
+					    struct flow_cls_offload *cls,
+					    bool get_free)
+{
+	int i;
+
+	for (i = 0; i < priv->rfs_entries_total; i++) {
+		struct stmmac_rfs_entry *entry = &priv->rfs_entries[i];
+
+		if (entry->cookie == cls->cookie)
+			return entry;
+		if (get_free && entry->in_use == false)
+			return entry;
+	}
+
+	return NULL;
+}
+
 #define VLAN_PRIO_FULL_MASK (0x07)
 
 static int tc_add_vlan_flow(struct stmmac_priv *priv,
 			    struct flow_cls_offload *cls)
 {
+	struct stmmac_rfs_entry *entry = tc_find_rfs(priv, cls, false);
 	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_dissector *dissector = rule->match.dissector;
 	int tc = tc_classid_to_hwtc(priv->dev, cls->classid);
 	struct flow_match_vlan match;
 
+	if (!entry) {
+		entry = tc_find_rfs(priv, cls, true);
+		if (!entry)
+			return -ENOENT;
+	}
+
+	if (priv->rfs_entries_cnt[STMMAC_RFS_T_VLAN] >=
+	    priv->rfs_entries_max[STMMAC_RFS_T_VLAN])
+		return -ENOENT;
+
 	/* Nothing to do here */
 	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_VLAN))
 		return -EINVAL;
@@ -638,6 +693,12 @@ static int tc_add_vlan_flow(struct stmmac_priv *priv,
 
 		prio = BIT(match.key->vlan_priority);
 		stmmac_rx_queue_prio(priv, priv->hw, prio, tc);
+
+		entry->in_use = true;
+		entry->cookie = cls->cookie;
+		entry->tc = tc;
+		entry->type = STMMAC_RFS_T_VLAN;
+		priv->rfs_entries_cnt[STMMAC_RFS_T_VLAN]++;
 	}
 
 	return 0;
@@ -646,20 +707,19 @@ static int tc_add_vlan_flow(struct stmmac_priv *priv,
 static int tc_del_vlan_flow(struct stmmac_priv *priv,
 			    struct flow_cls_offload *cls)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
-	struct flow_dissector *dissector = rule->match.dissector;
-	int tc = tc_classid_to_hwtc(priv->dev, cls->classid);
+	struct stmmac_rfs_entry *entry = tc_find_rfs(priv, cls, false);
 
-	/* Nothing to do here */
-	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_VLAN))
-		return -EINVAL;
+	if (!entry || !entry->in_use || entry->type != STMMAC_RFS_T_VLAN)
+		return -ENOENT;
 
-	if (tc < 0) {
-		netdev_err(priv->dev, "Invalid traffic class\n");
-		return -EINVAL;
-	}
+	stmmac_rx_queue_prio(priv, priv->hw, 0, entry->tc);
+
+	entry->in_use = false;
+	entry->cookie = 0;
+	entry->tc = 0;
+	entry->type = 0;
 
-	stmmac_rx_queue_prio(priv, priv->hw, 0, tc);
+	priv->rfs_entries_cnt[STMMAC_RFS_T_VLAN]--;
 
 	return 0;
 }
-- 
2.25.1

