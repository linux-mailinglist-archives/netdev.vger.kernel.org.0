Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB83B2FE2B6
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbhAUGYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:24:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726824AbhAUGR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 01:17:58 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L6DBvv069618
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2BRI/6LxGYgs8uyS+3/JheMItaT5+zYuLxyeQBMplNo=;
 b=nkhaZ5R7GMbaXubHUn0yQLZsvsbEKxwLYopV16W4PFDo81LAlbtrf6mWNGwGvzOBevFu
 9qfXVzOgFfZ+C5LJuWTFZcoUeB/vz59j6hIYJHG+pxXMK/Km/5EqF2Gxa2zC/N/b2JqE
 JQYS0iH9A8AAvUATJeA47boU3TID0cl2JPppez2eDhRh0D84phbtB2Ox4uDeby9o2fzV
 dt0XIO5b/Mo/Wgq3K60amh9blTca8MIHIprj6wqab+FKgxXe1eROT/ohzi23qhAC9SNt
 pwXWNL1y/Mt8ldE+VW7DBrAt0Jd79msR5QcxpGxfwBxFbWYdyjYfmotMuByKAvpcIuwp Xw== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3674580330-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 01:17:14 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L6DXZn009157
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:17:14 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3668pc1w2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:17:14 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L6HDC022085926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 06:17:13 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F077A78066;
        Thu, 21 Jan 2021 06:17:12 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 788697805E;
        Thu, 21 Jan 2021 06:17:12 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.137.249])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 06:17:12 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 2/3] ibmvnic: remove unnecessary rmb() inside ibmvnic_poll
Date:   Thu, 21 Jan 2021 00:17:09 -0600
Message-Id: <20210121061710.53217-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20210121061710.53217-1-ljp@linux.ibm.com>
References: <20210121061710.53217-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_02:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=908
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rmb() was introduced to load rx_scrq->msgs after calling
pending_scrq(). Now since pending_scrq() itself already
has dma_rmb() at the end of the function, rmb() is
duplicated and can be removed.

Fixes: ec20f36bb41a ("ibmvnic: Correctly re-enable interrupts in NAPI polling routine")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 8e043683610f..933e8fb71a8b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2577,7 +2577,6 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 		if (napi_complete_done(napi, frames_processed)) {
 			enable_scrq_irq(adapter, rx_scrq);
 			if (pending_scrq(adapter, rx_scrq)) {
-				rmb();
 				if (napi_reschedule(napi)) {
 					disable_scrq_irq(adapter, rx_scrq);
 					goto restart_poll;
-- 
2.23.0

