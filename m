Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DD33771C7
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 14:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhEHMid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 08:38:33 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51269 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhEHMi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 08:38:28 -0400
Received: from localhost.localdomain ([37.4.249.151]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MHWvH-1lk5JZ1wgb-00DW9t; Sat, 08 May 2021 14:37:20 +0200
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 3/3 net-next] net: qca_spi: Introduce stat about bad signature
Date:   Sat,  8 May 2021 14:36:35 +0200
Message-Id: <1620477395-12740-4-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620477395-12740-1-git-send-email-stefan.wahren@i2se.com>
References: <1620477395-12740-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V03:K1:hTAdZudLB0O1qGOMwLsXCKisf+g+CQ4SWZ7xf+WmX4m1+2zAg2x
 4Sne7TOergYWAb2dwZ9BhK2et90Rqq/weS1y5NaWLEKsRA2FJMxN/B3cIfbFrXjwwc7P4V7
 +6jAY2/8VaA8gpYKALUlWRrVtBC67xfOwrPy+WLXF0hYpPNjaJf/7mQYg7man4E6dPhVGXW
 8+lPPo8HNWBCOVZRvOV0A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:prqYyrZ+S5M=:wxmBbhxfwX4G3CXoZeCxkN
 pJ71xzZ4+Hh+TOuCRYk29A2iFfsMdyOhx5pn0m+5tx2MM8rf8AUe3f+ML56wSO2teqGVm7ShR
 KHlqiDf6D7I7nyeLMweQuplPJR7TZj/mBDlCNjmJB0pY332vmNxn8rHTiqXw6eObZrEJZFvPk
 trBP7mka1tm3jXooDP5NbuRMgSNSJqo2X3nHS7P7feVmoiwitZFJmHVnnDVCpUNDd+ZVnzIWj
 PJcz0giMezzR+CRQhnkm0fla7ltNyGjnQakuINOm4F8s8ljHwWNsy4WvHKe1D8CkkXudgnvWb
 Ls0rTt3l3o+wo0xR6bVsHPxiAn02YUFgfhzEV+GLKLmhXeJh/eQfO0zYJT+96szh5h4f4ktZW
 k7SiiRHh0mqpP6q8890DbBTzpOZYN0bn6MASt7wucqbUbPOSZj3P+RuJK+yCFUfWZ0fRawXiV
 iUrIFLF2MbLaqzX1nCTmKRBGYMso9xh9vTOX65+oLO/hJXE7+DqXWVMKG2aoKnYX+Y+QCkhsm
 s4pOMW3xoCdGS9q4KUn8ko=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to identify significant signature issues add a new stat counter,
which increases on bad signature values that causes a sync loss.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/net/ethernet/qualcomm/qca_debug.c | 1 +
 drivers/net/ethernet/qualcomm/qca_spi.c   | 4 ++++
 drivers/net/ethernet/qualcomm/qca_spi.h   | 1 +
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index 702aa21..d59fff2 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -62,6 +62,7 @@ static const char qcaspi_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"SPI errors",
 	"Write verify errors",
 	"Buffer available errors",
+	"Bad signature",
 };
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 0937ceb..79fe3ec 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -504,6 +504,9 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 		qcaspi_read_register(qca, SPI_REG_SIGNATURE, &signature);
 		qcaspi_read_register(qca, SPI_REG_SIGNATURE, &signature);
 		if (signature != QCASPI_GOOD_SIGNATURE) {
+			if (qca->sync == QCASPI_SYNC_READY)
+				qca->stats.bad_signature++;
+
 			qca->sync = QCASPI_SYNC_UNKNOWN;
 			netdev_dbg(qca->net_dev, "sync: got CPU on, but signature was invalid, restart\n");
 			return;
@@ -531,6 +534,7 @@ qcaspi_qca7k_sync(struct qcaspi *qca, int event)
 
 		if (signature != QCASPI_GOOD_SIGNATURE) {
 			qca->sync = QCASPI_SYNC_UNKNOWN;
+			qca->stats.bad_signature++;
 			netdev_dbg(qca->net_dev, "sync: bad signature, restart\n");
 			/* don't reset right away */
 			return;
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.h b/drivers/net/ethernet/qualcomm/qca_spi.h
index d13a67e..3067356 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -75,6 +75,7 @@ struct qcaspi_stats {
 	u64 spi_err;
 	u64 write_verify_failed;
 	u64 buf_avail_err;
+	u64 bad_signature;
 };
 
 struct qcaspi {
-- 
2.7.4

