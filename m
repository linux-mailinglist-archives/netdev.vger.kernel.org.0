Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC4229A59
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732700AbgGVOkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:40:42 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48442 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732657AbgGVOkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:40:31 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06MEeQSd111116;
        Wed, 22 Jul 2020 09:40:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595428826;
        bh=DIxOOQwIi12wLQSGUItZsPXBRsZgdqTGMtvo+XZ3cO0=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=HNIL8ZlzDxm7H3H1awpXNdTzi5TO+oUo172vVcxxsVGIU1G5Z3v4J34r9uALBIxOn
         WoOML6D8gA86X6jj7HidLdotXPDxIOH6pTw2Byw8ZZDTXAnOtZii3CsGWQxJk3g+C9
         bxfyvaJniIQJePPFc8wBeGvFGhvGkG0VR9U1Cqs4=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06MEeQSC073594
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 09:40:26 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 22
 Jul 2020 09:40:26 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 22 Jul 2020 09:40:26 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06MEeMLF043940;
        Wed, 22 Jul 2020 09:40:26 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next v5 PATCH 7/7] net: prp: enhance debugfs to display PRP info
Date:   Wed, 22 Jul 2020 10:40:22 -0400
Message-ID: <20200722144022.15746-8-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722144022.15746-1-m-karicheri2@ti.com>
References: <20200722144022.15746-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print PRP specific information from node table as part of debugfs
node table display. Also display the node as DAN-H or DAN-P depending
on the info from node table.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr/hsr_debugfs.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index c1932c0a15be..3b6f675bd55a 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -24,7 +24,7 @@ static struct dentry *hsr_debugfs_root_dir;
 
 static void print_mac_address(struct seq_file *sfp, unsigned char *mac)
 {
-	seq_printf(sfp, "%02x:%02x:%02x:%02x:%02x:%02x:",
+	seq_printf(sfp, "%02x:%02x:%02x:%02x:%02x:%02x ",
 		   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 }
 
@@ -35,20 +35,32 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 	struct hsr_priv *priv = (struct hsr_priv *)sfp->private;
 	struct hsr_node *node;
 
-	seq_puts(sfp, "Node Table entries\n");
-	seq_puts(sfp, "MAC-Address-A,   MAC-Address-B, time_in[A], ");
-	seq_puts(sfp, "time_in[B], Address-B port\n");
+	seq_printf(sfp, "Node Table entries for (%s) device\n",
+		   (priv->prot_version == PRP_V1 ? "PRP" : "HSR"));
+	seq_puts(sfp, "MAC-Address-A,    MAC-Address-B,    time_in[A], ");
+	seq_puts(sfp, "time_in[B], Address-B port, ");
+	if (priv->prot_version == PRP_V1)
+		seq_puts(sfp, "SAN-A, SAN-B, DAN-P\n");
+	else
+		seq_puts(sfp, "DAN-H\n");
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(node, &priv->node_db, mac_list) {
 		/* skip self node */
 		if (hsr_addr_is_self(priv, node->macaddress_A))
 			continue;
 		print_mac_address(sfp, &node->macaddress_A[0]);
-		seq_puts(sfp, " ");
 		print_mac_address(sfp, &node->macaddress_B[0]);
-		seq_printf(sfp, "0x%lx, ", node->time_in[HSR_PT_SLAVE_A]);
-		seq_printf(sfp, "0x%lx ", node->time_in[HSR_PT_SLAVE_B]);
-		seq_printf(sfp, "0x%x\n", node->addr_B_port);
+		seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_A]);
+		seq_printf(sfp, "%10lx, ", node->time_in[HSR_PT_SLAVE_B]);
+		seq_printf(sfp, "%14x, ", node->addr_B_port);
+
+		if (priv->prot_version == PRP_V1)
+			seq_printf(sfp, "%5x, %5x, %5x\n",
+				   node->san_a, node->san_b,
+				   (node->san_a == 0 && node->san_b == 0));
+		else
+			seq_printf(sfp, "%5x\n", 1);
 	}
 	rcu_read_unlock();
 	return 0;
@@ -57,7 +69,8 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 /* hsr_node_table_open - Open the node_table file
  *
  * Description:
- * This routine opens a debugfs file node_table of specific hsr device
+ * This routine opens a debugfs file node_table of specific hsr
+ * or prp device
  */
 static int
 hsr_node_table_open(struct inode *inode, struct file *filp)
-- 
2.17.1

