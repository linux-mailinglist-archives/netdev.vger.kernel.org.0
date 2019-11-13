Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF81FBA6D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 22:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfKMVGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 16:06:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7080 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbfKMVGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 16:06:24 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADKwDVP040647
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 16:06:23 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8q18dd4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 16:06:22 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xADL5A4k021518
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:06:22 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 2w5n36p52q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:06:22 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADL6KU551708260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 21:06:20 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A65296E04E;
        Wed, 13 Nov 2019 21:06:20 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65E516E052;
        Wed, 13 Nov 2019 21:06:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.211.141.91])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 21:06:20 +0000 (GMT)
From:   Cris Forno <cforno12@linux.vnet.ibm.com>
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, Cris Forno <cforno12@linux.vnet.ibm.com>
Subject: [PATCH net-net v2] ibmveth: Detect unsupported packets before sending to the hypervisor
Date:   Wed, 13 Nov 2019 15:06:16 -0600
Message-Id: <20191113210616.55737-1-cforno12@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=645 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130174
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
changes in v2
-demoted messages to netdev_dbg
-reversed christmas tree ordering for local variables
---
 drivers/net/ethernet/ibm/ibmveth.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index d654c23..1e0208f 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1011,6 +1011,29 @@ static int ibmveth_send(struct ibmveth_adapter *adapter,
 	return 0;
 }
 
+static int ibmveth_is_packet_unsupported(struct sk_buff *skb,
+					 struct net_device *netdev)
+{
+	struct ethhdr *ether_header;
+	int ret = 0;
+
+	ether_header = eth_hdr(skb);
+
+	if (ether_addr_equal(ether_header->h_dest, netdev->dev_addr)) {
+		netdev_dbg(netdev, "veth doesn't support loopback packets, dropping packet.\n");
+		netdev->stats.tx_dropped++;
+		ret = -EOPNOTSUPP;
+	}
+
+	if (!ether_addr_equal(ether_header->h_source, netdev->dev_addr)) {
+		netdev_dbg(netdev, "source packet MAC address does not match veth device's, dropping packet.\n");
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

