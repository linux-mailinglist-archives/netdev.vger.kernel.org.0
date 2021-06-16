Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EF13A93D3
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhFPH3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:35 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7296 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhFPH3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:07 -0400
Received: from localhost (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4c7n5tQ9z1BN7t;
        Wed, 16 Jun 2021 15:21:57 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 05/15] net: cosa: move out assignment in if condition
Date:   Wed, 16 Jun 2021 15:23:31 +0800
Message-ID: <1623828221-48349-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
References: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Should not use assignment in if condition.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 7b57233..9b57b3a 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -355,7 +355,8 @@ static int __init cosa_init(void)
 			goto out;
 		}
 	} else {
-		if (!(cosa_major=register_chrdev(0, "cosa", &cosa_fops))) {
+		cosa_major = register_chrdev(0, "cosa", &cosa_fops);
+		if (!cosa_major) {
 			pr_warn("unable to register chardev\n");
 			err = -EIO;
 			goto out;
@@ -563,7 +564,8 @@ static int cosa_probe(int base, int irq, int dma)
 		sema_init(&chan->wsem, 1);
 
 		/* Register the network interface */
-		if (!(chan->netdev = alloc_hdlcdev(chan))) {
+		chan->netdev = alloc_hdlcdev(chan);
+		if (!chan->netdev) {
 			pr_warn("%s: alloc_hdlcdev failed\n", chan->name);
 			err = -ENOMEM;
 			goto err_hdlcdev;
@@ -925,15 +927,15 @@ static int cosa_open(struct inode *inode, struct file *file)
 	int ret = 0;
 
 	mutex_lock(&cosa_chardev_mutex);
-	if ((n=iminor(file_inode(file))>>CARD_MINOR_BITS)
-		>= nr_cards) {
+	n = iminor(file_inode(file)) >> CARD_MINOR_BITS;
+	if (n >= nr_cards) {
 		ret = -ENODEV;
 		goto out;
 	}
 	cosa = cosa_cards+n;
 
-	if ((n=iminor(file_inode(file))
-		& ((1<<CARD_MINOR_BITS)-1)) >= cosa->nchannels) {
+	n = iminor(file_inode(file)) & ((1 << CARD_MINOR_BITS) - 1);
+	if (n >= cosa->nchannels) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -1095,7 +1097,8 @@ static inline int cosa_start(struct cosa_data *cosa, int address)
 		return -EPERM;
 	}
 	cosa->firmware_status &= ~COSA_FW_RESET;
-	if ((i=startmicrocode(cosa, address)) < 0) {
+	i = startmicrocode(cosa, address);
+	if (i < 0) {
 		pr_notice("cosa%d: start microcode at 0x%04x failed: %d\n",
 			  cosa->num, address, i);
 		return -EIO;
@@ -1475,7 +1478,8 @@ static int readmem(struct cosa_data *cosa, char __user *microcode, int length, i
 		char c;
 		int i;
 
-		if ((i=get_wait_data(cosa)) == -1) {
+		i = get_wait_data(cosa);
+		if (i == -1) {
 			pr_info("0x%04x bytes remaining\n", length);
 			return -11;
 		}
@@ -1523,9 +1527,10 @@ static int cosa_reset_and_read_id(struct cosa_data *cosa, char *idstring)
 	 * the port returns '\r', '\n' or '\x2e' permanently.
 	 */
 	for (i=0; i<COSA_MAX_ID_STRING-1; i++, prev=curr) {
-		if ((curr = get_wait_data(cosa)) == -1) {
+		curr = get_wait_data(cosa);
+		if (curr == -1)
 			return -1;
-		}
+
 		curr &= 0xff;
 		if (curr != '\r' && curr != '\n' && curr != 0x2e)
 			idstring[id++] = curr;
-- 
2.8.1

