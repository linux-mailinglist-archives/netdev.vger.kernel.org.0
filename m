Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7AD3159A2
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhBIWov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:44:51 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14450 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234083AbhBIWU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:20:59 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119LAa5v009740;
        Tue, 9 Feb 2021 13:27:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=fH3SI0DpVb0iRE7M/kQwz2LwsohmCqkkR62LgBxfuzM=;
 b=XB7P/Bt3kA5ka4qLe/S2cgdkuRCAWMd83CGFbAmnl6c7LeMqDx67pmN6GWjU3b6k0ptW
 SE5/KWTqS+RLZNfdBikHA1aTEubh4kEc7E9J/pzdObzIREIIqsM7X+M9SIrHE6VX4II8
 ED8CLTcJjLH5Vcy3Rntaz1zo3PwdBhBg9Hy/OwnKOjR5DkHdJa+Ol1nnXJuHBiZU9JvL
 PggAVOTjYIUtdEvxWPUA4kkYBi+yRrNmcJc4UjJ9qMoA4qfNEA+0t+Y4pjGZgkrbuuyj
 AlIaqaQAQHQcQ7b9t5+ziod4TgykrPgMwkZ95tlTwTcpeEhPQkti976tpkVNdaIRm1XK UA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrj6bx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:27:12 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 13:27:11 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 13:27:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Feb 2021 13:27:10 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id AC28F3F7040;
        Tue,  9 Feb 2021 13:27:10 -0800 (PST)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <davem@davemloft.net>, <bupadhaya@marvell.com>
Subject: [PATCH v2 net-next 1/3] qede: add netpoll support for qede driver
Date:   Tue, 9 Feb 2021 13:26:57 -0800
Message-ID: <1612906019-31724-2-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1612906019-31724-1-git-send-email-bupadhaya@marvell.com>
References: <1612906019-31724-1-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_07:2021-02-09,2021-02-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

handle netpoll case when qede_poll is called by
netpoll layer with budget 0

Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 70c8d3cd85c0..8c47a9d2a965 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1450,7 +1450,8 @@ int qede_poll(struct napi_struct *napi, int budget)
 	rx_work_done = (likely(fp->type & QEDE_FASTPATH_RX) &&
 			qede_has_rx_work(fp->rxq)) ?
 			qede_rx_int(fp, budget) : 0;
-	if (rx_work_done < budget) {
+	/* Handle case where we are called by netpoll with a budget of 0 */
+	if (rx_work_done < budget || !budget) {
 		if (!qede_poll_is_more_work(fp)) {
 			napi_complete_done(napi, rx_work_done);
 
-- 
2.17.1

