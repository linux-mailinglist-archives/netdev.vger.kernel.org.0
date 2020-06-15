Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7EF1F9FD9
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgFOTBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:01:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47868 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729844AbgFOTBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:01:44 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05FIiBmH104307;
        Mon, 15 Jun 2020 15:01:42 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31n42kg02r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 15:01:42 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05FIKmit024443;
        Mon, 15 Jun 2020 19:01:41 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 31mpe90tsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 19:01:41 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05FJ1dCK15335892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 19:01:39 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F7A6BE054;
        Mon, 15 Jun 2020 19:01:39 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E2C9BE058;
        Mon, 15 Jun 2020 19:01:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.224.51])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jun 2020 19:01:38 +0000 (GMT)
From:   David Christensen <drc@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Cc:     linux-kernel@vger.kernel.org,
        David Christensen <drc@linux.vnet.ibm.com>
Subject: [PATCH] tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes
Date:   Mon, 15 Jun 2020 12:01:19 -0700
Message-Id: <20200615190119.382589-1-drc@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.18.2
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_03:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0
 cotscore=-2147483648 adultscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver function tg3_io_error_detected() calls napi_disable twice,
without an intervening napi_enable, when the number of EEH errors exceeds
eeh_max_freezes, resulting in an indefinite sleep while holding rtnl_lock.

The function is called once with the PCI state pci_channel_io_frozen and
then called again with the state pci_channel_io_perm_failure when the
number of EEH failures in an hour exceeds eeh_max_freezes.

Protecting the calls to napi_enable/napi_disable with a new state
variable prevents the long sleep.

Signed-off-by: David Christensen <drc@linux.vnet.ibm.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 18 +++++++++++++++---
 drivers/net/ethernet/broadcom/tg3.h |  1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 7a3b22b35238..953f535e0ceb 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7373,22 +7373,34 @@ static void tg3_napi_disable(struct tg3 *tp)
 {
 	int i;
 
+	if (!tp->napi_enabled)
+		return;
+
 	for (i = tp->irq_cnt - 1; i >= 0; i--)
 		napi_disable(&tp->napi[i].napi);
+
+	tp->napi_enabled = false;
 }
 
 static void tg3_napi_enable(struct tg3 *tp)
 {
 	int i;
 
+	if (tp->napi_enabled)
+		return;
+
 	for (i = 0; i < tp->irq_cnt; i++)
 		napi_enable(&tp->napi[i].napi);
+
+	tp->napi_enabled = true;
 }
 
 static void tg3_napi_init(struct tg3 *tp)
 {
 	int i;
 
+	tp->napi_enabled = false;
+
 	netif_napi_add(tp->dev, &tp->napi[0].napi, tg3_poll, 64);
 	for (i = 1; i < tp->irq_cnt; i++)
 		netif_napi_add(tp->dev, &tp->napi[i].napi, tg3_poll_msix, 64);
@@ -7400,6 +7412,8 @@ static void tg3_napi_fini(struct tg3 *tp)
 
 	for (i = 0; i < tp->irq_cnt; i++)
 		netif_napi_del(&tp->napi[i].napi);
+
+	tp->napi_enabled = false;
 }
 
 static inline void tg3_netif_stop(struct tg3 *tp)
@@ -18194,10 +18208,8 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
 
 done:
 	if (state == pci_channel_io_perm_failure) {
-		if (netdev) {
-			tg3_napi_enable(tp);
+		if (netdev)
 			dev_close(netdev);
-		}
 		err = PCI_ERS_RESULT_DISCONNECT;
 	} else {
 		pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 6953d0546acb..0681f4b9ec79 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -3430,6 +3430,7 @@ struct tg3 {
 	u32                             ape_hb;
 	unsigned long                   ape_hb_interval;
 	unsigned long                   ape_hb_jiffies;
+	bool				napi_enabled;
 };
 
 /* Accessor macros for chip and asic attributes
-- 
2.18.2

