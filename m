Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5EC146B0D
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAWOUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:20:06 -0500
Received: from mga12.intel.com ([192.55.52.136]:19596 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgAWOUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 09:20:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 06:20:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="245398167"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 23 Jan 2020 06:20:03 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E0EF017E; Thu, 23 Jan 2020 16:20:02 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] net: atm: use %*ph to print small buffer
Date:   Thu, 23 Jan 2020 16:20:02 +0200
Message-Id: <20200123142002.51239-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use %*ph format to print small buffer as hex string.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/atm/atm_sysfs.c | 22 +++++--------
 net/atm/lec.c       | 76 ++++++++++++---------------------------------
 2 files changed, 28 insertions(+), 70 deletions(-)

diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
index 39b94ca5f65d..aa1b57161f3b 100644
--- a/net/atm/atm_sysfs.c
+++ b/net/atm/atm_sysfs.c
@@ -33,23 +33,17 @@ static ssize_t show_atmaddress(struct device *cdev,
 	unsigned long flags;
 	struct atm_dev *adev = to_atm_dev(cdev);
 	struct atm_dev_addr *aaddr;
-	int bin[] = { 1, 2, 10, 6, 1 }, *fmt = bin;
-	int i, j, count = 0;
+	int count = 0;
 
 	spin_lock_irqsave(&adev->lock, flags);
 	list_for_each_entry(aaddr, &adev->local, entry) {
-		for (i = 0, j = 0; i < ATM_ESA_LEN; ++i, ++j) {
-			if (j == *fmt) {
-				count += scnprintf(buf + count,
-						   PAGE_SIZE - count, ".");
-				++fmt;
-				j = 0;
-			}
-			count += scnprintf(buf + count,
-					   PAGE_SIZE - count, "%02x",
-					   aaddr->addr.sas_addr.prv[i]);
-		}
-		count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "%1phN.%2phN.%10phN.%6phN.%1phN\n",
+				   &aaddr->addr.sas_addr.prv[0],
+				   &aaddr->addr.sas_addr.prv[1],
+				   &aaddr->addr.sas_addr.prv[3],
+				   &aaddr->addr.sas_addr.prv[13],
+				   &aaddr->addr.sas_addr.prv[19]);
 	}
 	spin_unlock_irqrestore(&adev->lock, flags);
 
diff --git a/net/atm/lec.c b/net/atm/lec.c
index b57368e70aab..25fa3a7b72bd 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -799,14 +799,9 @@ static const char *lec_arp_get_status_string(unsigned char status)
 
 static void lec_info(struct seq_file *seq, struct lec_arp_table *entry)
 {
-	int i;
-
-	for (i = 0; i < ETH_ALEN; i++)
-		seq_printf(seq, "%2.2x", entry->mac_addr[i] & 0xff);
-	seq_printf(seq, " ");
-	for (i = 0; i < ATM_ESA_LEN; i++)
-		seq_printf(seq, "%2.2x", entry->atm_addr[i] & 0xff);
-	seq_printf(seq, " %s %4.4x", lec_arp_get_status_string(entry->status),
+	seq_printf(seq, "%pM ", entry->mac_addr);
+	seq_printf(seq, "%*phN ", ATM_ESA_LEN, entry->atm_addr);
+	seq_printf(seq, "%s %4.4x", lec_arp_get_status_string(entry->status),
 		   entry->flags & 0xffff);
 	if (entry->vcc)
 		seq_printf(seq, "%3d %3d ", entry->vcc->vpi, entry->vcc->vci);
@@ -1354,7 +1349,7 @@ static void dump_arp_table(struct lec_priv *priv)
 {
 	struct lec_arp_table *rulla;
 	char buf[256];
-	int i, j, offset;
+	int i, offset;
 
 	pr_info("Dump %p:\n", priv);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
@@ -1362,14 +1357,10 @@ static void dump_arp_table(struct lec_priv *priv)
 				     &priv->lec_arp_tables[i], next) {
 			offset = 0;
 			offset += sprintf(buf, "%d: %p\n", i, rulla);
-			offset += sprintf(buf + offset, "Mac: %pM",
+			offset += sprintf(buf + offset, "Mac: %pM ",
 					  rulla->mac_addr);
-			offset += sprintf(buf + offset, " Atm:");
-			for (j = 0; j < ATM_ESA_LEN; j++) {
-				offset += sprintf(buf + offset,
-						  "%2.2x ",
-						  rulla->atm_addr[j] & 0xff);
-			}
+			offset += sprintf(buf + offset, "Atm: %*ph ", ATM_ESA_LEN,
+					  rulla->atm_addr);
 			offset += sprintf(buf + offset,
 					  "Vcc vpi:%d vci:%d, Recv_vcc vpi:%d vci:%d Last_used:%lx, Timestamp:%lx, No_tries:%d ",
 					  rulla->vcc ? rulla->vcc->vpi : 0,
@@ -1392,12 +1383,9 @@ static void dump_arp_table(struct lec_priv *priv)
 		pr_info("No forward\n");
 	hlist_for_each_entry(rulla, &priv->lec_no_forward, next) {
 		offset = 0;
-		offset += sprintf(buf + offset, "Mac: %pM", rulla->mac_addr);
-		offset += sprintf(buf + offset, " Atm:");
-		for (j = 0; j < ATM_ESA_LEN; j++) {
-			offset += sprintf(buf + offset, "%2.2x ",
-					  rulla->atm_addr[j] & 0xff);
-		}
+		offset += sprintf(buf + offset, "Mac: %pM ", rulla->mac_addr);
+		offset += sprintf(buf + offset, "Atm: %*ph ", ATM_ESA_LEN,
+				  rulla->atm_addr);
 		offset += sprintf(buf + offset,
 				  "Vcc vpi:%d vci:%d, Recv_vcc vpi:%d vci:%d Last_used:%lx, Timestamp:%lx, No_tries:%d ",
 				  rulla->vcc ? rulla->vcc->vpi : 0,
@@ -1417,12 +1405,9 @@ static void dump_arp_table(struct lec_priv *priv)
 		pr_info("Empty ones\n");
 	hlist_for_each_entry(rulla, &priv->lec_arp_empty_ones, next) {
 		offset = 0;
-		offset += sprintf(buf + offset, "Mac: %pM", rulla->mac_addr);
-		offset += sprintf(buf + offset, " Atm:");
-		for (j = 0; j < ATM_ESA_LEN; j++) {
-			offset += sprintf(buf + offset, "%2.2x ",
-					  rulla->atm_addr[j] & 0xff);
-		}
+		offset += sprintf(buf + offset, "Mac: %pM ", rulla->mac_addr);
+		offset += sprintf(buf + offset, "Atm: %*ph ", ATM_ESA_LEN,
+				  rulla->atm_addr);
 		offset += sprintf(buf + offset,
 				  "Vcc vpi:%d vci:%d, Recv_vcc vpi:%d vci:%d Last_used:%lx, Timestamp:%lx, No_tries:%d ",
 				  rulla->vcc ? rulla->vcc->vpi : 0,
@@ -1442,12 +1427,9 @@ static void dump_arp_table(struct lec_priv *priv)
 		pr_info("Multicast Forward VCCs\n");
 	hlist_for_each_entry(rulla, &priv->mcast_fwds, next) {
 		offset = 0;
-		offset += sprintf(buf + offset, "Mac: %pM", rulla->mac_addr);
-		offset += sprintf(buf + offset, " Atm:");
-		for (j = 0; j < ATM_ESA_LEN; j++) {
-			offset += sprintf(buf + offset, "%2.2x ",
-					  rulla->atm_addr[j] & 0xff);
-		}
+		offset += sprintf(buf + offset, "Mac: %pM ", rulla->mac_addr);
+		offset += sprintf(buf + offset, "Atm: %*ph ", ATM_ESA_LEN,
+				  rulla->atm_addr);
 		offset += sprintf(buf + offset,
 				  "Vcc vpi:%d vci:%d, Recv_vcc vpi:%d vci:%d Last_used:%lx, Timestamp:%lx, No_tries:%d ",
 				  rulla->vcc ? rulla->vcc->vpi : 0,
@@ -1973,17 +1955,8 @@ lec_vcc_added(struct lec_priv *priv, const struct atmlec_ioc *ioc_data,
 		 * Vcc which we don't want to make default vcc,
 		 * attach it anyway.
 		 */
-		pr_debug("LEC_ARP:Attaching data direct, not default: %2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x\n",
-			 ioc_data->atm_addr[0], ioc_data->atm_addr[1],
-			 ioc_data->atm_addr[2], ioc_data->atm_addr[3],
-			 ioc_data->atm_addr[4], ioc_data->atm_addr[5],
-			 ioc_data->atm_addr[6], ioc_data->atm_addr[7],
-			 ioc_data->atm_addr[8], ioc_data->atm_addr[9],
-			 ioc_data->atm_addr[10], ioc_data->atm_addr[11],
-			 ioc_data->atm_addr[12], ioc_data->atm_addr[13],
-			 ioc_data->atm_addr[14], ioc_data->atm_addr[15],
-			 ioc_data->atm_addr[16], ioc_data->atm_addr[17],
-			 ioc_data->atm_addr[18], ioc_data->atm_addr[19]);
+		pr_debug("LEC_ARP:Attaching data direct, not default: %*phN\n",
+			 ATM_ESA_LEN, ioc_data->atm_addr);
 		entry = make_entry(priv, bus_mac);
 		if (entry == NULL)
 			goto out;
@@ -1999,17 +1972,8 @@ lec_vcc_added(struct lec_priv *priv, const struct atmlec_ioc *ioc_data,
 		dump_arp_table(priv);
 		goto out;
 	}
-	pr_debug("LEC_ARP:Attaching data direct, default: %2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x%2.2x\n",
-		 ioc_data->atm_addr[0], ioc_data->atm_addr[1],
-		 ioc_data->atm_addr[2], ioc_data->atm_addr[3],
-		 ioc_data->atm_addr[4], ioc_data->atm_addr[5],
-		 ioc_data->atm_addr[6], ioc_data->atm_addr[7],
-		 ioc_data->atm_addr[8], ioc_data->atm_addr[9],
-		 ioc_data->atm_addr[10], ioc_data->atm_addr[11],
-		 ioc_data->atm_addr[12], ioc_data->atm_addr[13],
-		 ioc_data->atm_addr[14], ioc_data->atm_addr[15],
-		 ioc_data->atm_addr[16], ioc_data->atm_addr[17],
-		 ioc_data->atm_addr[18], ioc_data->atm_addr[19]);
+	pr_debug("LEC_ARP:Attaching data direct, default: %*phN\n",
+		 ATM_ESA_LEN, ioc_data->atm_addr);
 	for (i = 0; i < LEC_ARP_TABLE_SIZE; i++) {
 		hlist_for_each_entry(entry,
 				     &priv->lec_arp_tables[i], next) {
-- 
2.24.1

