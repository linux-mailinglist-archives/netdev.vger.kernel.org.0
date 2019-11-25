Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9BC91096A5
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfKYXN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:13:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727171AbfKYXNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:13:12 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPMvK9m169744;
        Mon, 25 Nov 2019 18:13:05 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wfjyxegqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 18:13:05 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAPMtQee010074;
        Mon, 25 Nov 2019 23:13:04 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 2wevd6e3ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 23:13:04 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAPND2vI61931878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Nov 2019 23:13:02 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC4E3BE058;
        Mon, 25 Nov 2019 23:13:02 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72D93BE053;
        Mon, 25 Nov 2019 23:13:01 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.224.141])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 25 Nov 2019 23:13:01 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com,
        julietk@linux.vnet.ibm.com, Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net v2 1/4] ibmvnic: Fix completion structure initialization
Date:   Mon, 25 Nov 2019 17:12:53 -0600
Message-Id: <1574723576-27553-2-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
References: <20191125112359.7a468352@cakuba.hsd1.ca.comcast.net>
 <1574723576-27553-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_06:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 phishscore=0
 mlxscore=0 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0
 adultscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911250181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix multiple calls to init_completion for device completion
structures. Instead, initialize them during device probe and
reinitialize them later as needed.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f59d9a8e35e2..48225297a5e2 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -176,7 +176,7 @@ static int alloc_long_term_buff(struct ibmvnic_adapter *adapter,
 	ltb->map_id = adapter->map_id;
 	adapter->map_id++;
 
-	init_completion(&adapter->fw_done);
+	reinit_completion(&adapter->fw_done);
 	rc = send_request_map(adapter, ltb->addr,
 			      ltb->size, ltb->map_id);
 	if (rc) {
@@ -215,7 +215,7 @@ static int reset_long_term_buff(struct ibmvnic_adapter *adapter,
 
 	memset(ltb->buff, 0, ltb->size);
 
-	init_completion(&adapter->fw_done);
+	reinit_completion(&adapter->fw_done);
 	rc = send_request_map(adapter, ltb->addr, ltb->size, ltb->map_id);
 	if (rc)
 		return rc;
@@ -943,7 +943,7 @@ static int ibmvnic_get_vpd(struct ibmvnic_adapter *adapter)
 	if (adapter->vpd->buff)
 		len = adapter->vpd->len;
 
-	init_completion(&adapter->fw_done);
+	reinit_completion(&adapter->fw_done);
 	crq.get_vpd_size.first = IBMVNIC_CRQ_CMD;
 	crq.get_vpd_size.cmd = GET_VPD_SIZE;
 	rc = ibmvnic_send_crq(adapter, &crq);
@@ -1689,7 +1689,7 @@ static int __ibmvnic_set_mac(struct net_device *netdev, u8 *dev_addr)
 	crq.change_mac_addr.cmd = CHANGE_MAC_ADDR;
 	ether_addr_copy(&crq.change_mac_addr.mac_addr[0], dev_addr);
 
-	init_completion(&adapter->fw_done);
+	reinit_completion(&adapter->fw_done);
 	rc = ibmvnic_send_crq(adapter, &crq);
 	if (rc) {
 		rc = -EIO;
@@ -2316,7 +2316,7 @@ static int wait_for_reset(struct ibmvnic_adapter *adapter)
 	adapter->fallback.rx_entries = adapter->req_rx_add_entries_per_subcrq;
 	adapter->fallback.tx_entries = adapter->req_tx_entries_per_subcrq;
 
-	init_completion(&adapter->reset_done);
+	reinit_completion(&adapter->reset_done);
 	adapter->wait_for_reset = true;
 	rc = ibmvnic_reset(adapter, VNIC_RESET_CHANGE_PARAM);
 	if (rc)
@@ -2332,7 +2332,7 @@ static int wait_for_reset(struct ibmvnic_adapter *adapter)
 		adapter->desired.rx_entries = adapter->fallback.rx_entries;
 		adapter->desired.tx_entries = adapter->fallback.tx_entries;
 
-		init_completion(&adapter->reset_done);
+		reinit_completion(&adapter->reset_done);
 		adapter->wait_for_reset = true;
 		rc = ibmvnic_reset(adapter, VNIC_RESET_CHANGE_PARAM);
 		if (rc)
@@ -2603,7 +2603,7 @@ static void ibmvnic_get_ethtool_stats(struct net_device *dev,
 	    cpu_to_be32(sizeof(struct ibmvnic_statistics));
 
 	/* Wait for data to be written */
-	init_completion(&adapter->stats_done);
+	reinit_completion(&adapter->stats_done);
 	rc = ibmvnic_send_crq(adapter, &crq);
 	if (rc)
 		return;
@@ -4403,7 +4403,7 @@ static int send_query_phys_parms(struct ibmvnic_adapter *adapter)
 	memset(&crq, 0, sizeof(crq));
 	crq.query_phys_parms.first = IBMVNIC_CRQ_CMD;
 	crq.query_phys_parms.cmd = QUERY_PHYS_PARMS;
-	init_completion(&adapter->fw_done);
+	reinit_completion(&adapter->fw_done);
 	rc = ibmvnic_send_crq(adapter, &crq);
 	if (rc)
 		return rc;
@@ -4955,6 +4955,9 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	INIT_LIST_HEAD(&adapter->rwi_list);
 	spin_lock_init(&adapter->rwi_lock);
 	init_completion(&adapter->init_done);
+	init_completion(&adapter->fw_done);
+	init_completion(&adapter->reset_done);
+	init_completion(&adapter->stats_done);
 	clear_bit(0, &adapter->resetting);
 
 	do {
-- 
2.12.3

