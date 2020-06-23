Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEDD82053ED
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 15:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732812AbgFWNx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 09:53:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16786 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732839AbgFWNxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 09:53:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NDjF1e024287;
        Tue, 23 Jun 2020 06:53:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=iVD95T4xNQcfYDJCC94cFP8qzLDBa4oYxpm8YvPU2tk=;
 b=mlsaLnX2BaWYxggR74V2tVdi1B28D8eo/1WyN9CHCR1buFaCEVV9HHvEIlJeaD6M/pso
 44rTWaNMDVFtECi7d3DlXSFlzPuIu/oUEtbzkP1aX2OSSVQuxCP6qfGpcYxqesG7RGFx
 jMEygClE1Ow5vInI54GGO9xg2Ri4Z7aUl1k5uvF4ws3FnYPogL4rTeBucFnV7YZZQBV8
 rOs3w/7jrchndQc6FPSwUiyODkod/neM+ek2XXMYneZRwtnjtnEt6+rqvNwpq6az3tzj
 S42zjUyw1cgIQ75qUVfd0JTW8XZy/yqheKOD6BPrQoKVzFv/4lXbywR80pGlvAgyEiz3 sQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 31ujw9r10g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 06:53:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 06:53:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 23 Jun 2020 06:53:51 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 039BF3F703F;
        Tue, 23 Jun 2020 06:53:47 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        "Denis Bolotin" <denis.bolotin@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net 9/9] net: qed: fix "maybe uninitialized" warning
Date:   Tue, 23 Jun 2020 16:51:37 +0300
Message-ID: <20200623135136.3185-10-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200623135136.3185-1-alobakin@marvell.com>
References: <20200623135136.3185-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'abs_ppfid' in qed_dev.c:qed_llh_add_mac_filter() always gets
printed, but is initialized only under 'ref_cnt == 1' condition. This
results in:

In file included from ./include/linux/kernel.h:15:0,
                 from ./include/asm-generic/bug.h:19,
                 from ./arch/x86/include/asm/bug.h:86,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/io.h:11,
                 from drivers/net/ethernet/qlogic/qed/qed_dev.c:35:
drivers/net/ethernet/qlogic/qed/qed_dev.c: In function 'qed_llh_add_mac_filter':
./include/linux/printk.h:358:2: warning: 'abs_ppfid' may be used uninitialized
in this function [-Wmaybe-uninitialized]
  printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~
drivers/net/ethernet/qlogic/qed/qed_dev.c:983:17: note: 'abs_ppfid' was declared
here
  u8 filter_idx, abs_ppfid;
                 ^~~~~~~~~

...under W=1+.

Fix this by initializing it with zero.

Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for offload protocols")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index b41ada668948..3aa51374e727 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -980,7 +980,7 @@ int qed_llh_add_mac_filter(struct qed_dev *cdev,
 	struct qed_hwfn *p_hwfn = QED_LEADING_HWFN(cdev);
 	struct qed_ptt *p_ptt = qed_ptt_acquire(p_hwfn);
 	union qed_llh_filter filter = {};
-	u8 filter_idx, abs_ppfid;
+	u8 filter_idx, abs_ppfid = 0;
 	u32 high, low, ref_cnt;
 	int rc = 0;
 
-- 
2.25.1

