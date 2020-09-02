Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1D725B244
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgIBQ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:58:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25930 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728348AbgIBQ6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 12:58:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082GtnjF000408;
        Wed, 2 Sep 2020 09:58:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=HfLGWVT61UNS/cXkR1d4W38nYUJr20AN9NFkloL7BCg=;
 b=Fm6CrbRqJH58iItA26/ythzMrro/CUUXp2cfajE8460QSQLPT821abgnasKYnm+3nu3J
 K8c/QvGU7CqBYYjw+Q16Ef02qX9ZgcHEMb3FQ9N67PpgoSfrPYAWkSyObsUAoZHxnFiI
 yMKSPDmdKO5/WmyMj6aZrDEhwsnc3xE1XAg0I9JUNLIUqOQnPQZZ42P/xdpD/qjcA8kl
 8T5jK3iq7Yc6xwfbuRUwQDpAQEunkW14MN6mvEWCilZjRY5yUJ8576m0AosRIsLWYEwd
 eVHGq2bmHkK/49EYwpsN3C5BTeTIN5mTxcKgwfX24UXWAv6WGgmTuCdhEM0i5mYAES9c fw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phq7jdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 09:58:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 09:58:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 09:58:19 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 9EB503F7048;
        Wed,  2 Sep 2020 09:58:16 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <mkalderon@marvell.com>, <aelior@marvell.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <davem@davemloft.net>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH rdma-next 4/8] RDMA/qedr: Fix return code if accept is called on a destroyed qp
Date:   Wed, 2 Sep 2020 19:57:37 +0300
Message-ID: <20200902165741.8355-5-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200902165741.8355-1-michal.kalderon@marvell.com>
References: <20200902165741.8355-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_11:2020-09-02,2020-09-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In iWARP, accept could be called after a QP is already destroyed.
In this case an error should be returned and not success.

Fixes: 82af6d19d8d9 ("RDMA/qedr: Fix synchronization methods and memory leaks in qedr")
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 97fc7dd353b0..c7169d2c69e5 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -736,7 +736,7 @@ int qedr_iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	struct qedr_dev *dev = ep->dev;
 	struct qedr_qp *qp;
 	struct qed_iwarp_accept_in params;
-	int rc = 0;
+	int rc;
 
 	DP_DEBUG(dev, QEDR_MSG_IWARP, "Accept on qpid=%d\n", conn_param->qpn);
 
@@ -759,8 +759,10 @@ int qedr_iw_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	params.ord = conn_param->ord;
 
 	if (test_and_set_bit(QEDR_IWARP_CM_WAIT_FOR_CONNECT,
-			     &qp->iwarp_cm_flags))
+			     &qp->iwarp_cm_flags)) {
+		rc = -EINVAL;
 		goto err; /* QP already destroyed */
+	}
 
 	rc = dev->ops->iwarp_accept(dev->rdma_ctx, &params);
 	if (rc) {
-- 
2.14.5

