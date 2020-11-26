Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2282C4BD4
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgKZAJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:09:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65192 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728829AbgKZAJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 19:09:46 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ02nWK127348;
        Wed, 25 Nov 2020 19:09:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f38h962TttxPgntCwQdKXshmrHHd2yNqplsXSg2JjyE=;
 b=rc78owxFyph+qWdKCCEPis2ii8Gke4L5PeDtaUEDnU/U8JdP9dOuzDnJLwhh0ebRhnRl
 hhp62GGR5YdZH3t5TFWIj7BtXRnd8WyhQpuS1yWNcCLnVd5oXYH0HAzDSLVda4NSi+Qq
 2sXn++1ezVDXL96Rqsr74HV2+74jNgUZB5pRcvL5eFWO9JAVC6ggMIl4WVSYKv87u87J
 woBEdRPII4wIWEJmZlggzbXz2DkLzmcu5I22AsYnrFu/SGht0zBWQRYv/eUhfTedzfZF
 dUFyiwuzVRc26KkKymBUGyXIaoJW8M/sHHA7fNbUQe/l6pGX72KrPUfQOQF52a4tNPMY yA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351yjcjm0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 19:09:40 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ084ru023039;
        Thu, 26 Nov 2020 00:09:40 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 351uh82pg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 00:09:40 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ09d2i9896592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 00:09:39 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DCACAC059;
        Thu, 26 Nov 2020 00:09:39 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3A8BAC05F;
        Thu, 26 Nov 2020 00:09:38 +0000 (GMT)
Received: from linux-i8xm.aus.stglabs.ibm.com (unknown [9.40.195.200])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 00:09:38 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     ljp@linux.ibm.com, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net v3 9/9] ibmvnic: reduce wait for completion time
Date:   Wed, 25 Nov 2020 18:04:32 -0600
Message-Id: <20201126000432.29897-10-drt@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126000432.29897-1-drt@linux.ibm.com>
References: <20201126000432.29897-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_07:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=1 mlxscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce the wait time for Command Response Queue response from 30 seconds
to 20 seconds, as recommended by VIOS and Power Hypervisor teams.

Fixes: bd0b672313941 ("ibmvnic: Move login and queue negotiation into ibmvnic_open")
Fixes: 53da09e92910f ("ibmvnic: Add set_link_state routine for setting adapter link state")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index a17856be2828..d6b2686aed0f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -834,7 +834,7 @@ static void release_napi(struct ibmvnic_adapter *adapter)
 static int ibmvnic_login(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	int retry_count = 0;
 	int retries = 10;
 	bool retry;
@@ -938,7 +938,7 @@ static void release_resources(struct ibmvnic_adapter *adapter)
 static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 {
 	struct net_device *netdev = adapter->netdev;
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	union ibmvnic_crq crq;
 	bool resend;
 	int rc;
@@ -5125,7 +5125,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 {
 	struct device *dev = &adapter->vdev->dev;
-	unsigned long timeout = msecs_to_jiffies(30000);
+	unsigned long timeout = msecs_to_jiffies(20000);
 	u64 old_num_rx_queues, old_num_tx_queues;
 	int rc;
 
-- 
2.26.2

