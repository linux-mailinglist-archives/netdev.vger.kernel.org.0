Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7C01C765E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbgEFQbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:31:16 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58226 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730135AbgEFQao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:44 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUePd116970;
        Wed, 6 May 2020 11:30:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782640;
        bh=9LE9eXZasQk176rF4p3NIKvT/TvKZtJkmV5cK0LlcCU=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=kBjKZAtvyGPqDihkhuUHuPQUpix1zHVbJaJaL474zOtgvqS/YpUY14W7Ap6rTc2N2
         9Ieau0tu6k2P0hppeFknh0Nkhnz268PGFjirktp/Nv47hhERwgMyDfpCfvcJONtrV0
         0Hwgw/YAKur3O+nUxbzrqaURUyy3BPy8lFUyIshc=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUetB022075
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:40 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:40 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:40 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDq119719;
        Wed, 6 May 2020 11:30:40 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 13/13] net: prp: enhance debugfs to display PRP specific info in node table
Date:   Wed, 6 May 2020 12:30:33 -0400
Message-ID: <20200506163033.3843-14-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print PRP specific information from node table as part of debugfs
node table display

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/hsr_prp_debugfs.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/hsr-prp/hsr_prp_debugfs.c b/net/hsr-prp/hsr_prp_debugfs.c
index 7d8dd5ab3afd..28580de4de44 100644
--- a/net/hsr-prp/hsr_prp_debugfs.c
+++ b/net/hsr-prp/hsr_prp_debugfs.c
@@ -37,7 +37,11 @@ hsr_prp_node_table_show(struct seq_file *sfp, void *data)
 
 	seq_puts(sfp, "Node Table entries\n");
 	seq_puts(sfp, "MAC-Address-A,   MAC-Address-B, time_in[A], ");
-	seq_puts(sfp, "time_in[B], Address-B port\n");
+	seq_puts(sfp, "time_in[B], Address-B port");
+	if (priv->prot_version == PRP_V1)
+		seq_puts(sfp, ", san_a, san_b\n");
+	else
+		seq_puts(sfp, "\n");
 	rcu_read_lock();
 	list_for_each_entry_rcu(node, &priv->node_db, mac_list) {
 		/* skip self node */
@@ -48,7 +52,12 @@ hsr_prp_node_table_show(struct seq_file *sfp, void *data)
 		print_mac_address(sfp, &node->macaddress_B[0]);
 		seq_printf(sfp, "0x%lx, ", node->time_in[HSR_PRP_PT_SLAVE_A]);
 		seq_printf(sfp, "0x%lx ", node->time_in[HSR_PRP_PT_SLAVE_B]);
-		seq_printf(sfp, "0x%x\n", node->addr_B_port);
+		seq_printf(sfp, "0x%x", node->addr_B_port);
+
+		if (priv->prot_version == PRP_V1)
+			seq_printf(sfp, ", %x, %x\n", node->san_a, node->san_b);
+		else
+			seq_puts(sfp, "\n");
 	}
 	rcu_read_unlock();
 	return 0;
@@ -57,7 +66,8 @@ hsr_prp_node_table_show(struct seq_file *sfp, void *data)
 /* hsr_prp_node_table_open - Open the node_table file
  *
  * Description:
- * This routine opens a debugfs file node_table of specific hsr device
+ * This routine opens a debugfs file node_table of specific hsr
+ * or prp device
  */
 static int
 hsr_prp_node_table_open(struct inode *inode, struct file *filp)
-- 
2.17.1

