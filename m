Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64503B2612
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 06:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhFXEQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 00:16:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhFXEQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 00:16:14 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15O43xVJ060818
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mEZn8qNBjQZXblnPJ6rViTFgKjTuzX4SgZnycYJalck=;
 b=sIVHP8ALFhUeHzpbHbaiAcVaJ9GzszYLfQTbRyIFtWcrs5FLrVkkh7A69ldmz2pEuz8Z
 KFCy6dPbYuUN5C2XjWXk9nmlBESKKaksgAHweIpa0sDYWi4sVwtGWiwd40GMf9OqrNYU
 7L8So+RgbSqTQJHE4LgoJUPF4r1RqVGGGPjRpFJMmUpTpn7aHRaYVXAgjlKIcNjrkU5h
 /9/reFnZigEJ/ZVpCmPPVTDFrqf3LKLtna0AB7auffZe4rdcKbUVu2wcgdlgMnezGAv3
 fO/+0m+HAwvJ6QPaWXE+pVSvWyMmc+WKmlF6DXdKtUZa4H0jDockZHv1Zodi6zf8wk+d Sw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39chkf9ukw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 00:13:25 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15O4AkCj029681
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:25 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 39987a71pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 04:13:25 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15O4DNli28442990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 04:13:23 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 630AA6A04D;
        Thu, 24 Jun 2021 04:13:23 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A6D76A047;
        Thu, 24 Jun 2021 04:13:22 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.85.145.253])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 04:13:22 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, sukadev@linux.ibm.com,
        Brian King <brking@linux.ibm.com>, cforno12@linux.ibm.com
Subject: [PATCH net 4/7] ibmvnic: account for bufs already saved in indir_buf
Date:   Wed, 23 Jun 2021 21:13:13 -0700
Message-Id: <20210624041316.567622-5-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624041316.567622-1-sukadev@linux.ibm.com>
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u1fvgWdYAib1WymBGOMWq0NNFXwKHZ-J
X-Proofpoint-ORIG-GUID: u1fvgWdYAib1WymBGOMWq0NNFXwKHZ-J
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_14:2021-06-23,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes a crash in replenish_rx_pool() when called from ibmvnic_poll()
after a previous call to replenish_rx_pool() encountered an error when
allocating a socket buffer.

Thanks to Rick Lindsley and Dany Madden for helping debug the crash.

Fixes: 4f0b6812e9b9 ("ibmvnic: Introduce batched RX buffer descriptor transmission")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index fa402e20c137..b1d7caaa4fb7 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -351,7 +351,14 @@ static void replenish_rx_pool(struct ibmvnic_adapter *adapter,
 
 	rx_scrq = adapter->rx_scrq[pool->index];
 	ind_bufp = &rx_scrq->ind_buf;
-	for (i = 0; i < count; ++i) {
+
+	/* netdev_skb_alloc() could have failed after we saved a few skbs
+	 * in the indir_buf and we would not have sent them to VIOS yet.
+	 * To account for them, start the loop at ind_bufp->index rather
+	 * than 0. If we pushed all the skbs to VIOS, ind_bufp->index will
+	 * be 0.
+	 */
+	for (i = ind_bufp->index; i < count; ++i) {
 		skb = netdev_alloc_skb(adapter->netdev, pool->buff_size);
 		if (!skb) {
 			dev_err(dev, "Couldn't replenish rx buff\n");
-- 
2.31.1

