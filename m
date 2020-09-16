Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80B326BA19
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 04:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgIPC1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 22:27:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12715 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726269AbgIPC1v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 22:27:51 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 18E7FC10482E2933FAB9;
        Wed, 16 Sep 2020 10:27:49 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 10:27:40 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next] ath5k: convert to use DEFINE_SEQ_ATTRIBUTE macro
Date:   Wed, 16 Sep 2020 10:50:15 +0800
Message-ID: <20200916025015.3992315-1-liushixin2@huawei.com>
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
 drivers/net/wireless/ath/ath5k/debug.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 2eaba1ccab20..4b41160e5d38 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -161,33 +161,14 @@ static int reg_show(struct seq_file *seq, void *p)
 	return 0;
 }
 
-static const struct seq_operations register_seq_ops = {
+static const struct seq_operations registers_sops = {
 	.start = reg_start,
 	.next  = reg_next,
 	.stop  = reg_stop,
 	.show  = reg_show
 };
 
-static int open_file_registers(struct inode *inode, struct file *file)
-{
-	struct seq_file *s;
-	int res;
-	res = seq_open(file, &register_seq_ops);
-	if (res == 0) {
-		s = file->private_data;
-		s->private = inode->i_private;
-	}
-	return res;
-}
-
-static const struct file_operations fops_registers = {
-	.open = open_file_registers,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-	.owner = THIS_MODULE,
-};
-
+DEFINE_SEQ_ATTRIBUTE(registers);
 
 /* debugfs: beacons */
 
@@ -1005,7 +986,7 @@ ath5k_debug_init_device(struct ath5k_hw *ah)
 		return;
 
 	debugfs_create_file("debug", 0600, phydir, ah, &fops_debug);
-	debugfs_create_file("registers", 0400, phydir, ah, &fops_registers);
+	debugfs_create_file("registers", 0400, phydir, ah, &registers_fops);
 	debugfs_create_file("beacon", 0600, phydir, ah, &fops_beacon);
 	debugfs_create_file("reset", 0200, phydir, ah, &fops_reset);
 	debugfs_create_file("antenna", 0600, phydir, ah, &fops_antenna);
-- 
2.25.1

