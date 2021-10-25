Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B5439EDE
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhJYTEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:04:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33788 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233862AbhJYTDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:03:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PIamwc001235;
        Mon, 25 Oct 2021 12:01:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=VzHy2VOcYp3S+kEdpdX9Z1Icp9eu6BQBW9sTloD5gog=;
 b=T86WMR6Bd8mClhWIeG2JJPJe9Q6shEtKlFCq+8lt05V4tTMFYXo8m1Z4aBu9rxMcXdis
 od10OEZdtfcd+5SCSdghDyDpmL64qNGbKle3jjTI5Ltuk9AUXXRvt6H8/dB/iHAsZw6n
 /xK0XHzhnxsOKMSPiVwiGsyqHGhxqvEg12sJVslG5iGeS0yodb5RL7D5FVcItG3NgMom
 KJO1n5J87A+tkovFoY38a6iYP208pCJD5oynLQoJc4pKkadyxqRA1+tC7YapVs3jlpLj
 mTZwytMWHZ6J4DFv2WDSDmOe4MMH9Cfw1OhoO2RNrZdkzrOAY+0NWgjA9sXZcPJn3V+T Dw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bwtjrj6yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 12:01:32 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 25 Oct
 2021 12:01:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 25 Oct 2021 12:01:31 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 215DD3F70AF;
        Mon, 25 Oct 2021 12:01:27 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
CC:     Rakesh Babu <rsaladi2@marvell.com>,
        Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Subject: [net PATCH 2/2] octeontx2-af: Display all enabled PF VF rsrc_alloc entries.
Date:   Tue, 26 Oct 2021 00:30:45 +0530
Message-ID: <20211025190045.7462-3-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211025190045.7462-1-rsaladi2@marvell.com>
References: <20211025190045.7462-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: aaGBq4gfjCcCoA8e6PumgomtkmrFp3kK
X-Proofpoint-GUID: aaGBq4gfjCcCoA8e6PumgomtkmrFp3kK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we are using a fixed buffer size of length 2048 to display
rsrc_alloc output. As a result a maximum of 2048 characters of
rsrc_alloc output is displayed, which may lead sometimes to display only
partial output. This patch fixes this dependency on max limit of buffer
size and displays all PF VF entries.

Each column of the debugfs entry "rsrc_alloc" uses a fixed width of 12
characters to print the list of LFs of each block for a PF/VF. If the
length of list of LFs of a block exceeds this fixed width then the list
gets truncated and displays only a part of the list. This patch fixes
this by using the maximum possible length of list of LFs among all
blocks of all PFs and VFs entries as the width size.

Fixes: f7884097141b ("octeontx2-af: Formatting debugfs entry
rsrc_alloc.")
Fixes: 23205e6d06d4 ("octeontx2-af: Dump current resource provisioning
status")
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 138 ++++++++++++++----
 1 file changed, 106 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 6c589ca9b577..c7e12464c243 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -226,18 +226,85 @@ static const struct file_operations rvu_dbg_##name##_fops = { \

 static void print_nix_qsize(struct seq_file *filp, struct rvu_pfvf *pfvf);

+static void get_lf_str_list(struct rvu_block block, int pcifunc,
+			    char *lfs)
+{
+	int lf = 0, seq = 0, len = 0, prev_lf = block.lf.max;
+
+	for_each_set_bit(lf, block.lf.bmap, block.lf.max) {
+		if (lf >= block.lf.max)
+			break;
+
+		if (block.fn_map[lf] != pcifunc)
+			continue;
+
+		if (lf == prev_lf + 1) {
+			prev_lf = lf;
+			seq = 1;
+			continue;
+		}
+
+		if (seq)
+			len += sprintf(lfs + len, "-%d,%d", prev_lf, lf);
+		else
+			len += (len ? sprintf(lfs + len, ",%d", lf) :
+				      sprintf(lfs + len, "%d", lf));
+
+		prev_lf = lf;
+		seq = 0;
+	}
+
+	if (seq)
+		len += sprintf(lfs + len, "-%d", prev_lf);
+
+	lfs[len] = '\0';
+}
+
+static int get_max_column_width(struct rvu *rvu)
+{
+	int index, pf, vf, lf_str_size = 12, buf_size = 256;
+	struct rvu_block block;
+	u16 pcifunc;
+	char *buf;
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
+		for (vf = 0; vf <= rvu->hw->total_vfs; vf++) {
+			pcifunc = pf << 10 | vf;
+			if (!pcifunc)
+				continue;
+
+			for (index = 0; index < BLK_COUNT; index++) {
+				block = rvu->hw->block[index];
+				if (!strlen(block.name))
+					continue;
+
+				get_lf_str_list(block, pcifunc, buf);
+				if (lf_str_size <= strlen(buf))
+					lf_str_size = strlen(buf) + 1;
+			}
+		}
+	}
+
+	kfree(buf);
+	return lf_str_size;
+}
+
 /* Dumps current provisioning status of all RVU block LFs */
 static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 					  char __user *buffer,
 					  size_t count, loff_t *ppos)
 {
-	int index, off = 0, flag = 0, go_back = 0, len = 0;
+	int index, off = 0, flag = 0, len = 0, i = 0;
 	struct rvu *rvu = filp->private_data;
-	int lf, pf, vf, pcifunc;
+	int bytes_not_copied = 0;
 	struct rvu_block block;
-	int bytes_not_copied;
-	int lf_str_size = 12;
+	int pf, vf, pcifunc;
 	int buf_size = 2048;
+	int lf_str_size;
 	char *lfs;
 	char *buf;

@@ -249,6 +316,9 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 	if (!buf)
 		return -ENOSPC;

+	/* Get the maximum width of a column */
+	lf_str_size = get_max_column_width(rvu);
+
 	lfs = kzalloc(lf_str_size, GFP_KERNEL);
 	if (!lfs) {
 		kfree(buf);
@@ -262,65 +332,69 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 					 "%-*s", lf_str_size,
 					 rvu->hw->block[index].name);
 		}
+
 	off += scnprintf(&buf[off], buf_size - 1 - off, "\n");
+	bytes_not_copied = copy_to_user(buffer + (i * off), buf, off);
+	if (bytes_not_copied)
+		goto out;
+
+	i++;
+	*ppos += off;
 	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
 		for (vf = 0; vf <= rvu->hw->total_vfs; vf++) {
+			off = 0;
+			flag = 0;
 			pcifunc = pf << 10 | vf;
 			if (!pcifunc)
 				continue;

 			if (vf) {
 				sprintf(lfs, "PF%d:VF%d", pf, vf - 1);
-				go_back = scnprintf(&buf[off],
-						    buf_size - 1 - off,
-						    "%-*s", lf_str_size, lfs);
+				off = scnprintf(&buf[off],
+						buf_size - 1 - off,
+						"%-*s", lf_str_size, lfs);
 			} else {
 				sprintf(lfs, "PF%d", pf);
-				go_back = scnprintf(&buf[off],
-						    buf_size - 1 - off,
-						    "%-*s", lf_str_size, lfs);
+				off = scnprintf(&buf[off],
+						buf_size - 1 - off,
+						"%-*s", lf_str_size, lfs);
 			}

-			off += go_back;
-			for (index = 0; index < BLKTYPE_MAX; index++) {
+			for (index = 0; index < BLK_COUNT; index++) {
 				block = rvu->hw->block[index];
 				if (!strlen(block.name))
 					continue;
 				len = 0;
 				lfs[len] = '\0';
-				for (lf = 0; lf < block.lf.max; lf++) {
-					if (block.fn_map[lf] != pcifunc)
-						continue;
+				get_lf_str_list(block, pcifunc, lfs);
+				if (strlen(lfs))
 					flag = 1;
-					len += sprintf(&lfs[len], "%d,", lf);
-				}

-				if (flag)
-					len--;
-				lfs[len] = '\0';
 				off += scnprintf(&buf[off], buf_size - 1 - off,
 						 "%-*s", lf_str_size, lfs);
-				if (!strlen(lfs))
-					go_back += lf_str_size;
 			}
-			if (!flag)
-				off -= go_back;
-			else
-				flag = 0;
-			off--;
-			off +=	scnprintf(&buf[off], buf_size - 1 - off, "\n");
+			if (flag) {
+				off +=	scnprintf(&buf[off],
+						  buf_size - 1 - off, "\n");
+				bytes_not_copied = copy_to_user(buffer +
+								(i * off),
+								buf, off);
+				if (bytes_not_copied)
+					goto out;
+
+				i++;
+				*ppos += off;
+			}
 		}
 	}

-	bytes_not_copied = copy_to_user(buffer, buf, off);
+out:
 	kfree(lfs);
 	kfree(buf);
-
 	if (bytes_not_copied)
 		return -EFAULT;

-	*ppos = off;
-	return off;
+	return *ppos;
 }

 RVU_DEBUG_FOPS(rsrc_status, rsrc_attach_status, NULL);
--
2.17.1
