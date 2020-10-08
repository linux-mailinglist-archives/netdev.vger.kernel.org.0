Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296FE287C0F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgJHTGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:06:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgJHTGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:06:44 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 098J0k1T036183
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 15:06:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aAQqzQ7/gGPOEh+om+A3VuXxcKPBjyug6lMuW8CYHVU=;
 b=ki5ofLH8YaNey0mjbiZdt2OZgxF3cmOdqEWYZ+I69eDEsemJsWNhY106/tvdqgamgwO/
 f7DVz1bkpwk7tlfKt7ynwlcNRyNefafEZwzViOYtNo6lACqkzgf3w+WKlZ29/xkUxNtR
 sqSARAE8ikI1qypzljqd3XnY5xxyt2jo71cPzUsDCGeBqGExMs2WwckH/yhy7QP/JnwL
 rAWJogfElRhe9B31cNpdjKMaefqD+XDGp0QicRU+rSSJorZkhOvM/Lz9I7SfaTVCbJI4
 1leKHvZE+1PeaD8UDBBzbCsJt2S2k/hL8MYlSrN67mfZc29PMuMM6KovnLKikGS0p/+c 8w== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3427xp1bjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 15:06:43 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 098IrRal018835
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 19:06:43 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 341carb07m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 19:06:43 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 098J6dXR42795430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Oct 2020 19:06:39 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C58C8BE059;
        Thu,  8 Oct 2020 19:06:39 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F1B7BE054;
        Thu,  8 Oct 2020 19:06:38 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.160.28.108])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  8 Oct 2020 19:06:38 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com
Subject: [ PATCH v1 1/2] ibmveth: Switch order of ibmveth_helper calls.
Date:   Thu,  8 Oct 2020 12:05:37 -0700
Message-Id: <20201008190538.6223-2-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20201008190538.6223-1-dwilder@us.ibm.com>
References: <20201008190538.6223-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-08_12:2020-10-08,2020-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 mlxlogscore=952 suspectscore=1 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ibmveth_rx_csum_helper() must be called after ibmveth_rx_mss_helper()
as ibmveth_rx_csum_helper() may alter ip and tcp checksum values.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index c5c7326..3935a7e 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1385,16 +1385,16 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
 			skb_put(skb, length);
 			skb->protocol = eth_type_trans(skb, netdev);
 
-			if (csum_good) {
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
-				ibmveth_rx_csum_helper(skb, adapter);
-			}
-
 			if (length > netdev->mtu + ETH_HLEN) {
 				ibmveth_rx_mss_helper(skb, mss, lrg_pkt);
 				adapter->rx_large_packets++;
 			}
 
+			if (csum_good) {
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				ibmveth_rx_csum_helper(skb, adapter);
+			}
+
 			napi_gro_receive(napi, skb);	/* send it up */
 
 			netdev->stats.rx_packets++;
-- 
1.8.3.1

