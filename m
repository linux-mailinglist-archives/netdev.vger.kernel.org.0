Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A066126BA1B
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 04:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIPC2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 22:28:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58212 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726388AbgIPC1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 22:27:55 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A9B5F8E99C0D23CD06C6;
        Wed, 16 Sep 2020 10:27:52 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 10:27:42 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Vishal Kulkarni <vishal@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next] cxgb4vf: convert to use DEFINE_SEQ_ATTRIBUTE macro
Date:   Wed, 16 Sep 2020 10:50:18 +0800
Message-ID: <20200916025018.3992419-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEFINE_SEQ_ATTRIBUTE macro to simplify the code.

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   | 92 +++----------------
 1 file changed, 11 insertions(+), 81 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index e2fe78e2e242..2820a0bb971b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -2017,33 +2017,14 @@ static void mboxlog_stop(struct seq_file *seq, void *v)
 {
 }
 
-static const struct seq_operations mboxlog_seq_ops = {
+static const struct seq_operations mboxlog_sops = {
 	.start = mboxlog_start,
 	.next  = mboxlog_next,
 	.stop  = mboxlog_stop,
 	.show  = mboxlog_show
 };
 
-static int mboxlog_open(struct inode *inode, struct file *file)
-{
-	int res = seq_open(file, &mboxlog_seq_ops);
-
-	if (!res) {
-		struct seq_file *seq = file->private_data;
-
-		seq->private = inode->i_private;
-	}
-	return res;
-}
-
-static const struct file_operations mboxlog_fops = {
-	.owner   = THIS_MODULE,
-	.open    = mboxlog_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
-
+DEFINE_SEQ_ATTRIBUTE(mboxlog);
 /*
  * Show SGE Queue Set information.  We display QPL Queues Sets per line.
  */
@@ -2171,31 +2152,14 @@ static void *sge_queue_next(struct seq_file *seq, void *v, loff_t *pos)
 	return *pos < entries ? (void *)((uintptr_t)*pos + 1) : NULL;
 }
 
-static const struct seq_operations sge_qinfo_seq_ops = {
+static const struct seq_operations sge_qinfo_sops = {
 	.start = sge_queue_start,
 	.next  = sge_queue_next,
 	.stop  = sge_queue_stop,
 	.show  = sge_qinfo_show
 };
 
-static int sge_qinfo_open(struct inode *inode, struct file *file)
-{
-	int res = seq_open(file, &sge_qinfo_seq_ops);
-
-	if (!res) {
-		struct seq_file *seq = file->private_data;
-		seq->private = inode->i_private;
-	}
-	return res;
-}
-
-static const struct file_operations sge_qinfo_debugfs_fops = {
-	.owner   = THIS_MODULE,
-	.open    = sge_qinfo_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(sge_qinfo);
 
 /*
  * Show SGE Queue Set statistics.  We display QPL Queues Sets per line.
@@ -2317,31 +2281,14 @@ static void *sge_qstats_next(struct seq_file *seq, void *v, loff_t *pos)
 	return *pos < entries ? (void *)((uintptr_t)*pos + 1) : NULL;
 }
 
-static const struct seq_operations sge_qstats_seq_ops = {
+static const struct seq_operations sge_qstats_sops = {
 	.start = sge_qstats_start,
 	.next  = sge_qstats_next,
 	.stop  = sge_qstats_stop,
 	.show  = sge_qstats_show
 };
 
-static int sge_qstats_open(struct inode *inode, struct file *file)
-{
-	int res = seq_open(file, &sge_qstats_seq_ops);
-
-	if (res == 0) {
-		struct seq_file *seq = file->private_data;
-		seq->private = inode->i_private;
-	}
-	return res;
-}
-
-static const struct file_operations sge_qstats_proc_fops = {
-	.owner   = THIS_MODULE,
-	.open    = sge_qstats_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(sge_qstats);
 
 /*
  * Show PCI-E SR-IOV Virtual Function Resource Limits.
@@ -2415,31 +2362,14 @@ static void interfaces_stop(struct seq_file *seq, void *v)
 {
 }
 
-static const struct seq_operations interfaces_seq_ops = {
+static const struct seq_operations interfaces_sops = {
 	.start = interfaces_start,
 	.next  = interfaces_next,
 	.stop  = interfaces_stop,
 	.show  = interfaces_show
 };
 
-static int interfaces_open(struct inode *inode, struct file *file)
-{
-	int res = seq_open(file, &interfaces_seq_ops);
-
-	if (res == 0) {
-		struct seq_file *seq = file->private_data;
-		seq->private = inode->i_private;
-	}
-	return res;
-}
-
-static const struct file_operations interfaces_proc_fops = {
-	.owner   = THIS_MODULE,
-	.open    = interfaces_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(interfaces);
 
 /*
  * /sys/kernel/debugfs/cxgb4vf/ files list.
@@ -2452,10 +2382,10 @@ struct cxgb4vf_debugfs_entry {
 
 static struct cxgb4vf_debugfs_entry debugfs_files[] = {
 	{ "mboxlog",    0444, &mboxlog_fops },
-	{ "sge_qinfo",  0444, &sge_qinfo_debugfs_fops },
-	{ "sge_qstats", 0444, &sge_qstats_proc_fops },
+	{ "sge_qinfo",  0444, &sge_qinfo_fops },
+	{ "sge_qstats", 0444, &sge_qstats_fops },
 	{ "resources",  0444, &resources_fops },
-	{ "interfaces", 0444, &interfaces_proc_fops },
+	{ "interfaces", 0444, &interfaces_fops },
 };
 
 /*
-- 
2.25.1

