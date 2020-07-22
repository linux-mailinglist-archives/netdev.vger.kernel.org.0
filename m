Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35677229C40
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbgGVPz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:55:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53302 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732693AbgGVPz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:55:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MFUKaQ010157;
        Wed, 22 Jul 2020 08:54:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=NHYXpnEUf5iCHZyZ8LU8/WVrH0I6Dnunraq5pn7e6Rg=;
 b=vKTtrI3Rt10r4u6YIyNAZ1b5Y69FCnLKfc7zl71zgvwJZUdJmZeJ1ur0Wr2hnUrlsBOB
 G9gY27ne35AG2zwhxm+1/jlag4UfB1hI/e0Axn0fD01igfjU4TnSNZUgPSyTJTpWpFSE
 jLyP/5KOYEh5LUxxKPfmtxX611y+wgTWY+ZCMrNa6pobpqV4JusITu1klIE7IABwowcC
 6fcdSDgGsKYKR0FAsAEoiyyo8az8F3Wjg8RCrbbE/p/rB1Nxlk7T/tz65gv/FpHCWtr4
 nTP+ysORXz+xDLdIYhlggtIM9kAdY3D8uP9KYrJUCTvk5eV1sf7k7+cx1hdkzgRh2wp6 qg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxensfq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:54:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 08:54:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 08:54:55 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id C140C3F703F;
        Wed, 22 Jul 2020 08:54:49 -0700 (PDT)
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
Subject: [PATCH net-next 04/15] qed: prevent possible double-frees of the chains
Date:   Wed, 22 Jul 2020 18:53:38 +0300
Message-ID: <20200722155349.747-5-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200722155349.747-1-alobakin@marvell.com>
References: <20200722155349.747-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_09:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-initialize chain on qed_chain_free(), so it couldn't be freed
twice and provoke undefined behaviour.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_chain.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_chain.c b/drivers/net/ethernet/qlogic/qed/qed_chain.c
index 40cc26f7f20b..fd2d985793dc 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_chain.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -90,8 +90,10 @@ void qed_chain_free(struct qed_dev *cdev, struct qed_chain *chain)
 		qed_chain_free_pbl(cdev, chain);
 		break;
 	default:
-		break;
+		return;
 	}
+
+	qed_chain_init_mem(chain, NULL, 0);
 }
 
 static int
-- 
2.25.1

