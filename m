Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA4931A9A9
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhBMCtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:49:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231394AbhBMCtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:49:24 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11D2hkvP076716
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 21:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=scnQzp5kbnQ/E+M/CpD3o4+QE/qZswcIQD/Sq5gQGOo=;
 b=Jni7iT682ScQXN/54iDDj6pl/wvegvDiws2+NF+uT9WYkOblinc8/v8edHAblS3nTYXs
 ocj3L0kImtzpC+xxnznImJyzsBvphhTRBHDowh/DWRggYpM5ugloj7FLepatOXgPHP9s
 +2mRD9SGcoAVw3DNjP5kofHei5h9PTBRtSXHFlXQVmN3MVA0tzdv/ZIxIJgYY79MuGJs
 i4bAQtjgzWXrnBj2AmAtiowKD3St919BIRTlvdFac0DQa5nb9INzIY6ZzzaiBcGhPEwR
 3lgT4QIkY2IpXezTvO4GngyTgxo++5FFlEoZA7I1XXrXj68DsXrFMgMxEuxXwx4IPak1 hw== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36p680g2qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 21:48:44 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11D2knv5021479
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 02:48:43 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 36hjradv8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 02:48:43 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11D2mf1g25100652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Feb 2021 02:48:41 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF32DC6055;
        Sat, 13 Feb 2021 02:48:41 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB735C605A;
        Sat, 13 Feb 2021 02:48:40 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.198.213])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 13 Feb 2021 02:48:40 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     sukadev@linux.ibm.com, drt@linux.ibm.com,
        Lijun Pan <ljp@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net] ibmvnic: add memory barrier to protect long term buffer
Date:   Fri, 12 Feb 2021 20:48:40 -0600
Message-Id: <20210213024840.56036-1-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-13_01:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=916
 clxscore=1015 impostorscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130022
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_rmb() barrier is added to load the long term buffer before copying
it to socket buffer; and dma_wmb() barrier is added to update the
long term buffer before it being accessed by VIOS (virtual i/o server).

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Acked-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index c8b0d99608d5..cd201f89ce6c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1705,6 +1705,9 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		skb_copy_from_linear_data(skb, dst, skb->len);
 	}
 
+	/* post changes to long_term_buff *dst before VIOS accessing it */
+	dma_wmb();
+
 	tx_pool->consumer_index =
 	    (tx_pool->consumer_index + 1) % tx_pool->num_buffers;
 
@@ -2544,6 +2547,8 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
 		offset = be16_to_cpu(next->rx_comp.off_frame_data);
 		flags = next->rx_comp.flags;
 		skb = rx_buff->skb;
+		/* load long_term_buff before copying to skb */
+		dma_rmb();
 		skb_copy_to_linear_data(skb, rx_buff->data + offset,
 					length);
 
-- 
2.23.0

