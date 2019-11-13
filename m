Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF77FB3FE
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfKMPor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:44:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbfKMPoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:44:46 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADFfYiU042777
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 10:44:45 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8kmw3gc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 10:44:44 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xADFZQmC002374
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 15:44:43 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 2w5n36ud1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 15:44:43 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADFifcr23527894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 15:44:41 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B17E428060;
        Wed, 13 Nov 2019 15:44:41 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1057D28059;
        Wed, 13 Nov 2019 15:44:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.211.141.91])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 15:44:40 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH net-next] ibmveth: Detect unsupported packets before sending to the hypervisor
Date:   Wed, 13 Nov 2019 09:44:07 -0600
Message-Id: <20191113154407.50653-1-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=596 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when ibmveth receive a loopback packet, it reports an
ambiguous error message "tx: h_send_logical_lan failed with rc=-4"
because the hypervisor rejects those types of packets. This fix
detects loopback packet and assures the source packet's MAC address
matches the driver's MAC address before transmitting to the
hypervisor.

Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index d654c23..e8bb6c7 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1011,6 +1011,29 @@ static int ibmveth_send(struct ibmveth_adapter *adapter,
 	return 0;
 }
 
+static int ibmveth_is_packet_unsupported(struct sk_buff *skb,
+					 struct net_device *netdev)
+{
+	int ret = 0;
+	struct ethhdr *ether_header;
+
+	ether_header = eth_hdr(skb);
+
+	if (ether_addr_equal(ether_header->h_dest, netdev->dev_addr)) {
+		netdev_err(netdev, "veth doesn't support loopback packets, dropping packet.\n");
+		netdev->stats.tx_dropped++;
+		ret = -EOPNOTSUPP;
+	}
+
+	if (!ether_addr_equal(ether_header->h_source, netdev->dev_addr)) {
+		netdev_err(netdev, "source packet MAC address does not match veth device's, dropping packet.\n");
+		netdev->stats.tx_dropped++;
+		ret = -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
 static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 				      struct net_device *netdev)
 {
@@ -1022,6 +1045,9 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
 	dma_addr_t dma_addr;
 	unsigned long mss = 0;
 
+	if (ibmveth_is_packet_unsupported(skb, netdev))
+		goto out;
+
 	/* veth doesn't handle frag_list, so linearize the skb.
 	 * When GRO is enabled SKB's can have frag_list.
 	 */
-- 
1.8.3.1

