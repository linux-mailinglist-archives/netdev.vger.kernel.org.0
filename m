Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D826317165
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhBJU3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:29:42 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55616 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232102AbhBJU30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:29:26 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11AKQEDT017521;
        Wed, 10 Feb 2021 12:28:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=fH3SI0DpVb0iRE7M/kQwz2LwsohmCqkkR62LgBxfuzM=;
 b=AOKqDvmgIxRyZ11djzHyyfzKHvyTSGj7d+rrg8W7mmqkqD0dbT/ivz6CY4xsiNzA4MyP
 jvfvh9Ey0+Qfc0Jw9ba/1m0QUcR/Hs5vWB+fVnZ8xeu3AXPmSO6vb6agsBf2VfqvuxSR
 9SYwsN2Dc3uZ4J+tEB4z7oDSTzdzYeTJQnJScSQuRQkBDUH15AgIx+LmEQ+lVEwBsLSv
 aXeRNw+dBKcn171pywzF2j+AQ220JNNK4tOETWp5WaHtPOa67xA6BjOlSd8EjpdorPbG
 TPmlQc1t+jYbQv09Pg5vmBE+yR3rUMPpkqeLzObb5decc4/B0nVx8De3oQ3v3UJ6hGsH xQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrn6fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 12:28:44 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 12:28:42 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 12:28:42 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 12:28:42 -0800
Received: from dc5-eodlnx05.marvell.com (dc5-eodlnx05.marvell.com [10.69.113.147])
        by maili.marvell.com (Postfix) with ESMTP id B6BDC3F7043;
        Wed, 10 Feb 2021 12:28:42 -0800 (PST)
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <aelior@marvell.com>,
        <irusskikh@marvell.com>
CC:     <davem@davemloft.net>, <bupadhaya@marvell.com>
Subject: [PATCH v3 net-next 1/3] qede: add netpoll support for qede driver
Date:   Wed, 10 Feb 2021 12:28:29 -0800
Message-ID: <1612988911-10799-2-git-send-email-bupadhaya@marvell.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1612988911-10799-1-git-send-email-bupadhaya@marvell.com>
References: <1612988911-10799-1-git-send-email-bupadhaya@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_10:2021-02-10,2021-02-10 signatures=0
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

