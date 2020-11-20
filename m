Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282372BB954
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgKTWlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:41:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729113AbgKTWlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:41:03 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMXDna006966
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bJqZbN8tHFBV0krRjzBwgkG7xUxnBs7Jckiwz7BB7No=;
 b=CtzMTRl+2dgjLzmfBo/MR00gjGk0x11gSmowtqX8KuQ1N+HVDzniljXrRgt09QgG9bar
 51pxdgfiWVcjMM9gAWGSAfNnehY4rJxuZ6owTirlv5eT67t0nIm2GGuHFzIl8x95ZXJh
 dnnA9YXkf4Dt9rX12V4XXnCjEtizI2RSO/5zPqGGrDnkLhaBuZjtuTklq3IzOe65YYlF
 q+eLh6hnrEJ19KUmGBaJ/B33iMuvFd2liUZUVHak2o7iaNgxxyiL58IoP1K8L47KYIKd
 vdczerFLaBURJgs3dVL/GBae3FtaGL0EOabQmVdEpc1iWMk2ma53zDptUvJRdgE5lwKO BA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34xhk88whu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:41:01 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMe8gW017259
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:01 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 34w5w8tnee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:41:01 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMeqGg37355946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:40:52 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 757E96E050;
        Fri, 20 Nov 2020 22:40:58 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D16C76E05B;
        Fri, 20 Nov 2020 22:40:57 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.85.186.201])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:40:57 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: [PATCH net 09/15] ibmvnic: send_login should check for crq errors
Date:   Fri, 20 Nov 2020 16:40:43 -0600
Message-Id: <20201120224049.46933-10-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201120224049.46933-1-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0
 adultscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

send_login() does not check for the result of ibmvnic_send_crq() of the
login request. This results in the driver needlessly retrying the login
10 times even when CRQ is no longer active. Check the return code and
give up in case of errors in sending the CRQ.

The only time we want to retry is if we get a PARITALSUCCESS response
from the partner.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index c8242c0bfee0..9d2eebd31ff6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -852,10 +852,8 @@ static int ibmvnic_login(struct net_device *netdev)
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
@@ -3764,15 +3762,16 @@ static int send_login(struct ibmvnic_adapter *adapter)
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
@@ -3878,16 +3877,23 @@ static int send_login(struct ibmvnic_adapter *adapter)
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
2.23.0

