Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7F322EB7A
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgG0LwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:52:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17894 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726873AbgG0LwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:52:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RBpaGm000720;
        Mon, 27 Jul 2020 04:52:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0818; bh=Nd7arwfxNZtpVI9ZnivLJIX8lOylM+VZWcCMVyaqn9U=;
 b=vWluG5lrFsWCaoupxBxbOhIK2ZbtQqq8wTryqRE+EDrnw48/fkraCqbexYOqXkdohl6H
 4OPqi46wNPtT+a5f6kUopgF+GHo1bF79efqDgJzLT65iFLRTbWyVYm52sOwrIJJ/h2yU
 /g4/eAu4QYUQ89CDgPmPXB4zEwG/+QZ3asDOHFbWWkkL8l3hiuLfLeU0GdGIFHmM8nSY
 l+DWHi0Cds9jHaO30H6zL1/u0QDkPvPxhgj+3KIm6XfwtBThETfgkUQmQAikXEjs/IcK
 cnk5sgkix/MIbctK7kBcaDtnTYOgia4oR1/pTOtcP59NmR/1PvSuAXINdgmqReYdfJnx 0w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3qq5f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 04:52:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 04:52:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jul 2020 04:52:05 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 27ECF3F703F;
        Mon, 27 Jul 2020 04:52:01 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next] qed: fix the allocation of the chains with an external PBL
Date:   Mon, 27 Jul 2020 14:51:33 +0300
Message-ID: <20200727115133.1631-1-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_07:2020-07-27,2020-07-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan reports static checker warning:

"The patch 9b6ee3cf95d3: "qed: sanitize PBL chains allocation" from Jul
23, 2020, leads to the following static checker warning:

	drivers/net/ethernet/qlogic/qed/qed_chain.c:299 qed_chain_alloc_pbl()
	error: uninitialized symbol 'pbl_virt'.

drivers/net/ethernet/qlogic/qed/qed_chain.c
   249  static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain)
   250  {
   251          struct device *dev = &cdev->pdev->dev;
   252          struct addr_tbl_entry *addr_tbl;
   253          dma_addr_t phys, pbl_phys;
   254          __le64 *pbl_virt;
                ^^^^^^^^^^^^^^^^
[...]
   271          if (chain->b_external_pbl)
   272                  goto alloc_pages;
                        ^^^^^^^^^^^^^^^^ uninitialized
[...]
   298                  /* Fill the PBL table with the physical address of the page */
   299                  pbl_virt[i] = cpu_to_le64(phys);
                        ^^^^^^^^^^^
[...]
"

This issue was introduced with commit c3a321b06a80 ("qed: simplify
initialization of the chains with an external PBL"), when
chain->pbl_sp.table_virt initialization was moved up to
qed_chain_init_params().
Fix it by initializing pbl_virt with an already filled chain struct field.

Fixes: c3a321b06a80 ("qed: simplify initialization of the chains with an external PBL")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_chain.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_chain.c b/drivers/net/ethernet/qlogic/qed/qed_chain.c
index f8efd36d66e0..b83d17b14e85 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_chain.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -268,8 +268,10 @@ static int qed_chain_alloc_pbl(struct qed_dev *cdev, struct qed_chain *chain)
 
 	chain->pbl.pp_addr_tbl = addr_tbl;
 
-	if (chain->b_external_pbl)
+	if (chain->b_external_pbl) {
+		pbl_virt = chain->pbl_sp.table_virt;
 		goto alloc_pages;
+	}
 
 	size = array_size(page_cnt, sizeof(*pbl_virt));
 	if (unlikely(size == SIZE_MAX))
-- 
2.25.1

