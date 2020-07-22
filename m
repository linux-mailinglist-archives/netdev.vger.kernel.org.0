Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED40122A1FD
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbgGVWMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:12:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59380 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387421AbgGVWMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:12:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MM711F027569;
        Wed, 22 Jul 2020 15:12:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=abvwJyxQ5+FVGDhi3/w7dacNEWbcUQpv4mD6cdlqFSk=;
 b=Fi1UECe3nN7oqmktzUTw5sjwWSupwCXlNkqLEV2ukApFy3CS645Iq3TAm8XlT+Dq52Pv
 CYa7rPZwmcihmvF/xwJr1CdfRf+fK1eVmz03XqYARj8upd3Rle4JphprXtywCBYiyoV0
 V5hQOGlPwUXRIXzhOR4TDIC07XloU/TLuD3rkmS14gLB02u1KLL6g6NOVlK0onSp0vUy
 +CP4iN8HgQe27HKCIjno2m+aMpjyKDMir6U3qgIU06B0KODXULSYfuBsnAjZ0GdMa4Mf
 SJWSEwFpXeSQG05Jpp/W5ujuemz3bJ7zaemr/CUqz7BLXiFRkKIlUfzxtNtnE6ZwFyic Fw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxentx9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 15:12:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:12:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 15:12:20 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 47E6A3F703F;
        Wed, 22 Jul 2020 15:12:14 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Doug Ledford" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 11/15] qed: introduce qed_chain_get_elem_used{,u32}()
Date:   Thu, 23 Jul 2020 01:10:41 +0300
Message-ID: <20200722221045.5436-12-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722221045.5436-1-alobakin@marvell.com>
References: <20200722221045.5436-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_16:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reverse-variants of qed_chain_get_elem_left{,u32}() to be able to
know current chain occupation. They will be used in the upcoming qede
XDP_REDIRECT code.
They share most of the logics with the mentioned ones, so were reused
to collapse the latters.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 include/linux/qed/qed_chain.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index 434479e2ab65..4d58dc8943f0 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -203,7 +203,7 @@ static inline u32 qed_chain_get_cons_idx_u32(const struct qed_chain *chain)
 	return chain->u.chain32.cons_idx;
 }
 
-static inline u16 qed_chain_get_elem_left(const struct qed_chain *chain)
+static inline u16 qed_chain_get_elem_used(const struct qed_chain *chain)
 {
 	u32 prod = qed_chain_get_prod_idx(chain);
 	u32 cons = qed_chain_get_cons_idx(chain);
@@ -217,10 +217,15 @@ static inline u16 qed_chain_get_elem_left(const struct qed_chain *chain)
 	if (chain->mode == QED_CHAIN_MODE_NEXT_PTR)
 		used -= (u16)(prod / elem_per_page - cons / elem_per_page);
 
-	return (u16)(chain->capacity - used);
+	return used;
 }
 
-static inline u32 qed_chain_get_elem_left_u32(const struct qed_chain *chain)
+static inline u16 qed_chain_get_elem_left(const struct qed_chain *chain)
+{
+	return (u16)(chain->capacity - qed_chain_get_elem_used(chain));
+}
+
+static inline u32 qed_chain_get_elem_used_u32(const struct qed_chain *chain)
 {
 	u64 prod = qed_chain_get_prod_idx_u32(chain);
 	u64 cons = qed_chain_get_cons_idx_u32(chain);
@@ -234,7 +239,12 @@ static inline u32 qed_chain_get_elem_left_u32(const struct qed_chain *chain)
 	if (chain->mode == QED_CHAIN_MODE_NEXT_PTR)
 		used -= (u32)(prod / elem_per_page - cons / elem_per_page);
 
-	return chain->capacity - used;
+	return used;
+}
+
+static inline u32 qed_chain_get_elem_left_u32(const struct qed_chain *chain)
+{
+	return chain->capacity - qed_chain_get_elem_used_u32(chain);
 }
 
 static inline u16 qed_chain_get_usable_per_page(const struct qed_chain *chain)
-- 
2.25.1

