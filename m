Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571AC2C19B4
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgKWX6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:58:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728032AbgKWX6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:58:15 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNW58U082187
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=60FjilWmYEpuiGTl8TyNuJp4HbVcELMH6w0s53MgTEo=;
 b=ioW3AvtEmA/vOmWHyprPp7Lhav0zrsldVD7gxpspzw67Pd7riwj2Z9jGAHAN9VT6+2zk
 CNSo/LWg2RAmod5BKGRTVnVQkuKCsWCG/Mkd6Wh8WPZhkdbN0bZrUbJZfNEFbAQKDBCi
 0gxUjIj1nfmCaq6ooNcgWFmCwzdj7xP0odxr9GYLshELEbhCrFqnGH6oQS2s/IOvwbwj
 zhI2sEA/6UE03/otdxqa+Y+YhNQAJ6c/38wW0AmOcG7ClKeNvGAJd9ehAf3V15s7mFiR
 XFems1OWldLYaShSC+GIjCTv7DdsMkrn5rlUS3YOYAJYoegd/CAX9wfetiwWCuHQpXsv lA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350ga2dcdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 18:58:14 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ANNqccp025697
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:13 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 34xth8u0uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 23:58:13 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ANNwDq364160208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Nov 2020 23:58:13 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D66B28060;
        Mon, 23 Nov 2020 23:58:13 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03FD228059;
        Mon, 23 Nov 2020 23:58:13 +0000 (GMT)
Received: from ltcalpine2-lp16.aus.stglabs.ibm.com (unknown [9.40.195.199])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Nov 2020 23:58:12 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, ljp@linux.ibm.com
Subject: [PATCH net v2 7/9] ibmvnic: send_login should check for crq errors
Date:   Mon, 23 Nov 2020 18:57:55 -0500
Message-Id: <20201123235757.6466-8-drt@linux.ibm.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20201123235757.6466-1-drt@linux.ibm.com>
References: <20201123235757.6466-1-drt@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=1 mlxscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

send_login() does not check for the result of ibmvnic_send_crq() of the
login request. This results in the driver needlessly retrying the login
10 times even when CRQ is no longer active. Check the return code and
give up in case of errors in sending the CRQ.

The only time we want to retry is if we get a PARITALSUCCESS response
from the partner.

Fixes: 032c5e82847a2 ("Driver for IBM System i/p VNIC protocol")

Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 6d01cc8ec6b6..79a8b78d93ca 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -850,10 +850,8 @@ static int ibmvnic_login(struct net_device *netdev)
 		adapter->init_done_rc = 0;
 		reinit_completion(&adapter->init_done);
 		rc = send_login(adapter);
-		if (rc) {
-			netdev_warn(netdev, "Unable to login\n");
+		if (rc)
 			return rc;
-		}
 
 		if (!wait_for_completion_timeout(&adapter->init_done,
 						 timeout)) {
@@ -3726,15 +3724,16 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	struct ibmvnic_login_rsp_buffer *login_rsp_buffer;
 	struct ibmvnic_login_buffer *login_buffer;
 	struct device *dev = &adapter->vdev->dev;
+	struct vnic_login_client_data *vlcd;
 	dma_addr_t rsp_buffer_token;
 	dma_addr_t buffer_token;
 	size_t rsp_buffer_size;
 	union ibmvnic_crq crq;
+	int client_data_len;
 	size_t buffer_size;
 	__be64 *tx_list_p;
 	__be64 *rx_list_p;
-	int client_data_len;
-	struct vnic_login_client_data *vlcd;
+	int rc;
 	int i;
 
 	if (!adapter->tx_scrq || !adapter->rx_scrq) {
@@ -3840,16 +3839,23 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	crq.login.len = cpu_to_be32(buffer_size);
 
 	adapter->login_pending = true;
-	ibmvnic_send_crq(adapter, &crq);
+	rc = ibmvnic_send_crq(adapter, &crq);
+	if (rc) {
+		adapter->login_pending = false;
+		netdev_err(adapter->netdev, "Failed to send login, rc=%d\n", rc);
+		goto buf_rsp_map_failed;
+	}
 
 	return 0;
 
 buf_rsp_map_failed:
 	kfree(login_rsp_buffer);
+	adapter->login_rsp_buf = NULL;
 buf_rsp_alloc_failed:
 	dma_unmap_single(dev, buffer_token, buffer_size, DMA_TO_DEVICE);
 buf_map_failed:
 	kfree(login_buffer);
+	adapter->login_buf = NULL;
 buf_alloc_failed:
 	return -1;
 }
-- 
2.26.2

