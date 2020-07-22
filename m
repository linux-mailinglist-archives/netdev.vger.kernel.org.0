Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A35822A1DD
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733247AbgGVWL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:11:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13066 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733226AbgGVWLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:11:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MM6fei019797;
        Wed, 22 Jul 2020 15:11:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=nnuyyoiJD7ZTQL8VO7tW2BAxPk4CVEZ/FEeHiAG1BJ4=;
 b=TtHUy2kKyKWmrkIYVszIMvsv1X/ioCOKoYCvFiEaQKM5Stg9YPUdZlRPZ8yyewnvy0qu
 XqNejMdV4Lb74FSjqaIFHoc5Xz4JIAA4GOXQdDAp2ZNpElh6yhrGHcOpm/sKNzqjy9hb
 6Mght4BZPO0hit5w/0cGajEfLEsiMnt/bWZOXVgU3fIQqU6aAyDze1vRDwQ+xAxJTPGc
 +i3IJnOEf+GfYTb2XMLXo6hUmPeWegOSuhnmI3NvEVItyFZ09a+6bNTP974yb9dq5lC3
 W98NMJXyK4dCilebIKfQb4ZdG5rITNORdnB2mnKK91rTWekQtuucqXIinviVTmSyOWvD jA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkt0kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 15:11:35 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:11:33 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 15:11:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jul 2020 15:11:33 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id 8796F3F703F;
        Wed, 22 Jul 2020 15:11:26 -0700 (PDT)
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
Subject: [PATCH v2 net-next 04/15] qed: prevent possible double-frees of the chains
Date:   Thu, 23 Jul 2020 01:10:34 +0300
Message-ID: <20200722221045.5436-5-alobakin@marvell.com>
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

Zero-initialize chain on qed_chain_free(), so it couldn't be freed
twice and provoke undefined behaviour.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_chain.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_chain.c b/drivers/net/ethernet/qlogic/qed/qed_chain.c
index bab02ff32514..917b783433f7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_chain.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_chain.c
@@ -92,8 +92,10 @@ void qed_chain_free(struct qed_dev *cdev, struct qed_chain *chain)
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

