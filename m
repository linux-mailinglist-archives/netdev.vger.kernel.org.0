Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F53569BBB
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiGGHff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbiGGHfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:35:20 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A973631DCC;
        Thu,  7 Jul 2022 00:35:19 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266NFQsS008099;
        Thu, 7 Jul 2022 00:35:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=xpaArNJ4AWE45LSWWVu6b4G+hFkzJa6QYgPD3XQDAus=;
 b=MWM2mSwrgBlXqDGkOzjLXH46a0b7JUFFW1V89Iem15b57g7ye++Gtg0gSSG/usTNsPup
 NVgUqhPzqPjCl8kZbH36+0OBrKn9rMyg2rb4h4vNWLcJ8zlk7lMbMojUQ+a7wstY54Y3
 hJ7zsebSpBZFmPVfchWTksSkk9eH+PVScm6uS/VlzOHGWorDqmGq2x507THIFIhNDPMC
 zKqpzOO91HJCyXpgZrkbV+eTvXmCIPtr0+KgeBCzFbMmgkhaNcv7QiN2aTox/UuLpws/
 Pweu2Efw578lT+bCwPRdK4uTpSpvlcOC05HmFGPgfxWSyg1umMbaNoX3fmCb+94vzQTb 5Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h5kwj1gue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 00:35:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jul
 2022 00:35:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 7 Jul 2022 00:35:12 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id 1BFD73F707C;
        Thu,  7 Jul 2022 00:35:09 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH V3 07/12] octeontx2-af: Debugsfs support for exact match.
Date:   Thu, 7 Jul 2022 13:03:48 +0530
Message-ID: <20220707073353.2752279-8-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707073353.2752279-1-rkannoth@marvell.com>
References: <20220707073353.2752279-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: vS_au9Sb_AvQKkf7uKkVVaHH2YC43ghl
X-Proofpoint-GUID: vS_au9Sb_AvQKkf7uKkVVaHH2YC43ghl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There debugfs files created.
1. General information on exact match table
2. Exact match table entries.
3. NPC mcam drop on hit count stats.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 179 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_npc_hash.c       |   1 -
 2 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 2ad73b180276..f42a09f04b25 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -18,6 +18,7 @@
 #include "cgx.h"
 #include "lmac_common.h"
 #include "npc.h"
+#include "rvu_npc_hash.h"
 
 #define DEBUGFS_DIR_NAME "octeontx2"
 
@@ -2600,6 +2601,170 @@ static int rvu_dbg_npc_mcam_show_rules(struct seq_file *s, void *unused)
 
 RVU_DEBUG_SEQ_FOPS(npc_mcam_rules, npc_mcam_show_rules, NULL);
 
+static int rvu_dbg_npc_exact_show_entries(struct seq_file *s, void *unused)
+{
+	struct npc_exact_table_entry *mem_entry[NPC_EXACT_TBL_MAX_WAYS] = { 0 };
+	struct npc_exact_table_entry *cam_entry;
+	struct npc_exact_table *table;
+	struct rvu *rvu = s->private;
+	int i, j;
+
+	u8 bitmap = 0;
+
+	table = rvu->hw->table;
+
+	mutex_lock(&table->lock);
+
+	/* Check if there is at least one entry in mem table */
+	if (!table->mem_tbl_entry_cnt)
+		goto dump_cam_table;
+
+	/* Print table headers */
+	seq_puts(s, "\n\tExact Match MEM Table\n");
+	seq_puts(s, "Index\t");
+
+	for (i = 0; i < table->mem_table.ways; i++) {
+		mem_entry[i] = list_first_entry_or_null(&table->lhead_mem_tbl_entry[i],
+							struct npc_exact_table_entry, list);
+
+		seq_printf(s, "Way-%d\t\t\t\t\t", i);
+	}
+
+	seq_puts(s, "\n");
+	for (i = 0; i < table->mem_table.ways; i++)
+		seq_puts(s, "\tChan  MAC                     \t");
+
+	seq_puts(s, "\n\n");
+
+	/* Print mem table entries */
+	for (i = 0; i < table->mem_table.depth; i++) {
+		bitmap = 0;
+		for (j = 0; j < table->mem_table.ways; j++) {
+			if (!mem_entry[j])
+				continue;
+
+			if (mem_entry[j]->index != i)
+				continue;
+
+			bitmap |= BIT(j);
+		}
+
+		/* No valid entries */
+		if (!bitmap)
+			continue;
+
+		seq_printf(s, "%d\t", i);
+		for (j = 0; j < table->mem_table.ways; j++) {
+			if (!(bitmap & BIT(j))) {
+				seq_puts(s, "nil\t\t\t\t\t");
+				continue;
+			}
+
+			seq_printf(s, "0x%x %pM\t\t\t", mem_entry[j]->chan,
+				   mem_entry[j]->mac);
+			mem_entry[j] = list_next_entry(mem_entry[j], list);
+		}
+		seq_puts(s, "\n");
+	}
+
+dump_cam_table:
+
+	if (!table->cam_tbl_entry_cnt)
+		goto done;
+
+	seq_puts(s, "\n\tExact Match CAM Table\n");
+	seq_puts(s, "index\tchan\tMAC\n");
+
+	/* Traverse cam table entries */
+	list_for_each_entry(cam_entry, &table->lhead_cam_tbl_entry, list) {
+		seq_printf(s, "%d\t0x%x\t%pM\n", cam_entry->index, cam_entry->chan,
+			   cam_entry->mac);
+	}
+
+done:
+	mutex_unlock(&table->lock);
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(npc_exact_entries, npc_exact_show_entries, NULL);
+
+static int rvu_dbg_npc_exact_show_info(struct seq_file *s, void *unused)
+{
+	struct npc_exact_table *table;
+	struct rvu *rvu = s->private;
+	int i;
+
+	table = rvu->hw->table;
+
+	seq_puts(s, "\n\tExact Table Info\n");
+	seq_printf(s, "Exact Match Feature : %s\n",
+		   rvu->hw->cap.npc_exact_match_enabled ? "enabled" : "disable");
+	if (!rvu->hw->cap.npc_exact_match_enabled)
+		return 0;
+
+	seq_puts(s, "\nMCAM Index\tMAC Filter Rules Count\n");
+	for (i = 0; i < table->num_drop_rules; i++)
+		seq_printf(s, "%d\t\t%d\n", i, table->cnt_cmd_rules[i]);
+
+	seq_puts(s, "\nMcam Index\tPromisc Mode Status\n");
+	for (i = 0; i < table->num_drop_rules; i++)
+		seq_printf(s, "%d\t\t%s\n", i, table->promisc_mode[i] ? "on" : "off");
+
+	seq_puts(s, "\n\tMEM Table Info\n");
+	seq_printf(s, "Ways : %d\n", table->mem_table.ways);
+	seq_printf(s, "Depth : %d\n", table->mem_table.depth);
+	seq_printf(s, "Mask : 0x%llx\n", table->mem_table.mask);
+	seq_printf(s, "Hash Mask : 0x%x\n", table->mem_table.hash_mask);
+	seq_printf(s, "Hash Offset : 0x%x\n", table->mem_table.hash_offset);
+
+	seq_puts(s, "\n\tCAM Table Info\n");
+	seq_printf(s, "Depth : %d\n", table->cam_table.depth);
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(npc_exact_info, npc_exact_show_info, NULL);
+
+static int rvu_dbg_npc_exact_drop_cnt(struct seq_file *s, void *unused)
+{
+	struct npc_exact_table *table;
+	struct rvu *rvu = s->private;
+	struct npc_key_field *field;
+	u16 chan, pcifunc;
+	int blkaddr, i;
+	u64 cfg, cam1;
+	char *str;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	table = rvu->hw->table;
+
+	field = &rvu->hw->mcam.rx_key_fields[NPC_CHAN];
+
+	seq_puts(s, "\n\t Exact Hit on drop status\n");
+	seq_puts(s, "\npcifunc\tmcam_idx\tHits\tchan\tstatus\n");
+
+	for (i = 0; i < table->num_drop_rules; i++) {
+		pcifunc = rvu_npc_exact_drop_rule_to_pcifunc(rvu, i);
+		cfg = rvu_read64(rvu, blkaddr, NPC_AF_MCAMEX_BANKX_CFG(i, 0));
+
+		/* channel will be always in keyword 0 */
+		cam1 = rvu_read64(rvu, blkaddr,
+				  NPC_AF_MCAMEX_BANKX_CAMX_W0(i, 0, 1));
+		chan = field->kw_mask[0] & cam1;
+
+		str = (cfg & 1) ? "enabled" : "disabled";
+
+		seq_printf(s, "0x%x\t%d\t\t%llu\t0x%x\t%s\n", pcifunc, i,
+			   rvu_read64(rvu, blkaddr,
+				      NPC_AF_MATCH_STATX(table->counter_idx[i])),
+			   chan, str);
+	}
+
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(npc_exact_drop_cnt, npc_exact_drop_cnt, NULL);
+
 static void rvu_dbg_npc_init(struct rvu *rvu)
 {
 	rvu->rvu_dbg.npc = debugfs_create_dir("npc", rvu->rvu_dbg.root);
@@ -2608,8 +2773,22 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
 			    &rvu_dbg_npc_mcam_info_fops);
 	debugfs_create_file("mcam_rules", 0444, rvu->rvu_dbg.npc, rvu,
 			    &rvu_dbg_npc_mcam_rules_fops);
+
 	debugfs_create_file("rx_miss_act_stats", 0444, rvu->rvu_dbg.npc, rvu,
 			    &rvu_dbg_npc_rx_miss_act_fops);
+
+	if (!rvu->hw->cap.npc_exact_match_enabled)
+		return;
+
+	debugfs_create_file("exact_entries", 0444, rvu->rvu_dbg.npc, rvu,
+			    &rvu_dbg_npc_exact_entries_fops);
+
+	debugfs_create_file("exact_info", 0444, rvu->rvu_dbg.npc, rvu,
+			    &rvu_dbg_npc_exact_info_fops);
+
+	debugfs_create_file("exact_drop_cnt", 0444, rvu->rvu_dbg.npc, rvu,
+			    &rvu_dbg_npc_exact_drop_cnt_fops);
+
 }
 
 static int cpt_eng_sts_display(struct seq_file *filp, u8 eng_type)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index d8f4f55a7d65..386895df9012 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1458,7 +1458,6 @@ void rvu_npc_exact_reset(struct rvu *rvu, u16 pcifunc)
  *      @rvu: resource virtualization unit.
  *
  *	Initialize HW and SW resources to manage 4way-2K table and fully
-	u8 cgx_id, lmac_id;
  *	associative 32-entry mcam table.
  *	Return: 0 upon success.
  */
-- 
2.25.1

