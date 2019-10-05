Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005DFCCAC3
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 17:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfJEPTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 11:19:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfJEPTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 11:19:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x95F91aW050859;
        Sat, 5 Oct 2019 15:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=oGOdeFTOCYRQYQ9d+ryLcttvRz8VQfHVuZKZJpIb3AM=;
 b=i5OLs3uaETaLdVpgLC/nr1i72eDrj2nkFOz9dZFaD560e6XilneBOxYRMxGXxJirAzSq
 9tRYyrQfVVE8sNNFNLscVpwHrXngJIFEg+NSnqVM4ewqzNQX5knoX/UnL9ZhI/pFq6u8
 CSzF4ZDiRIk6YgVMqfZ+DImQEBWJxIuOJdDgrm6MW5BKxPlbsXZB0oUWIhfVJ1y8Nz+2
 14Zc+P75fv5lLwI4ieOfedRFbjHviA2u0gKhT9x/bFkRDgeekbSfd3t0MvxLiINsnEGi
 6MQ67x9nEeg1zApzWDuC4qhSCCEo68H7tlRYKQ5OuibkwSxEC1GUOhbtjzuiVQ83auNY Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vek4q1jdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Oct 2019 15:19:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x95FEFGO195351;
        Sat, 5 Oct 2019 15:19:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vek0bbwud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Oct 2019 15:19:26 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x95FJNwb016063;
        Sat, 5 Oct 2019 15:19:23 GMT
Received: from manjunathpatil.us.oracle.com (/10.211.44.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 05 Oct 2019 08:19:23 -0700
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
To:     jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     manjunath.b.patil@oracle.com, cspradlin@google.com,
        christophe.jaillet@wanadoo.fr
Subject: [PATCH 1/1] ixgbe: protect TX timestamping from API misuse
Date:   Sat,  5 Oct 2019 08:20:03 -0700
Message-Id: <1570288803-14880-1-git-send-email-manjunath.b.patil@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9401 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910050154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9401 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910050154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HW timestamping can only be requested for a packet if the NIC is first
setup via ioctl(SIOCSHWTSTAMP). If this step was skipped, then the ixgbe
driver still allowed TX packets to request HW timestamping. In this
situation, we see 'clearing Tx Timestamp hang' noise in the log.

Fix this by checking that the NIC is configured for HW TX timestamping
before accepting a HW TX timestamping request.

similar-to:
	(26bd4e2 igb: protect TX timestamping from API misuse)
	(0a6f2f0 igb: Fix a test with HWTSTAMP_TX_ON)

Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1ce2397..dd24aeb 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8640,7 +8640,8 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 	    adapter->ptp_clock) {
-		if (!test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
+		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
+		    !test_and_set_bit_lock(__IXGBE_PTP_TX_IN_PROGRESS,
 					   &adapter->state)) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			tx_flags |= IXGBE_TX_FLAGS_TSTAMP;
-- 
1.7.1

