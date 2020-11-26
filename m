Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217DF2C4BE4
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgKZAN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:13:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47116 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728350AbgKZAN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 19:13:27 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ02ZOI114753;
        Wed, 25 Nov 2020 19:13:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0lWDTDSz1dPOr5lrUPX8QW3utRI69g9d8XRhFBfcnR4=;
 b=mGbszlZB3wnQfjQmfInR/wxRHyGGD0Ezo9PPH4NkaTIWfGQ6xGfWRBRbkqczfCIllOvm
 jn7rwxJgcQu5ia3vBxI8pIW0uXXGPvdtXI9OIgkTQhJjj1IcQ+6rl1FjrKBsJfOdBHcQ
 Y0+3VqLk0npnWvZKw9jVJIR9aivViFkTDPEy1zwFLXXWZDjFOjAZIAyfapLDsat9vvX8
 JI+Sh5XbCV20ZwwiGgkG4vYLJD3QzxnvEX+Jf4TvCfMpgc9fh+9qUejowihWAimfsYie
 +xNBeBqsf2XOR/6v8NUvAmjhSrzQPTdTlfhFBjcbpQaLElOUocpO9M5/D3CApPfpm4jG OQ== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 351q2us8g5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Nov 2020 19:13:23 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0APNsDH6030700;
        Thu, 26 Nov 2020 00:09:27 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 34xth9b443-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 00:09:27 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQ09Qgs63635954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 00:09:27 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC75EAC059;
        Thu, 26 Nov 2020 00:09:26 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7474AAC05E;
        Thu, 26 Nov 2020 00:09:26 +0000 (GMT)
Received: from linux-i8xm.aus.stglabs.ibm.com (unknown [9.40.195.200])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 26 Nov 2020 00:09:26 +0000 (GMT)
From:   Dany Madden <drt@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     ljp@linux.ibm.com, sukadev@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, Dany Madden <drt@linux.ibm.com>
Subject: [PATCH net v3 1/9] ibmvnic: handle inconsistent login with reset
Date:   Wed, 25 Nov 2020 18:04:24 -0600
Message-Id: <20201126000432.29897-2-drt@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126000432.29897-1-drt@linux.ibm.com>
References: <20201126000432.29897-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_07:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=1 impostorscore=0 bulkscore=0 mlxlogscore=703
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 adultscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inconsistent login with the vnicserver is causing the device to be
removed. This does not give the device a chance to recover from error
state. This patch schedules a FATAL reset instead to bring the adapter
up.

Fixes: 032c5e82847a2 ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2aa40b2f225c..dcb23015b6b4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4412,7 +4412,7 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	     adapter->req_rx_add_queues !=
 	     be32_to_cpu(login_rsp->num_rxadd_subcrqs))) {
 		dev_err(dev, "FATAL: Inconsistent login and login rsp\n");
-		ibmvnic_remove(adapter->vdev);
+		ibmvnic_reset(adapter, VNIC_RESET_FATAL);
 		return -EIO;
 	}
 	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
-- 
2.26.2

