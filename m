Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFCA257F25
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgHaQ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:58:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2666 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbgHaQ6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:58:24 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VGpA3k003661
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=oXocsymrjddOGtWqnW5zr2HzNwGiTPjB5iXRxhmYkUo=;
 b=QorLElUg/7a82y32/T+VI+14nTT93BcCfvsc8ebf4yRb+l5702buySIau45y7RMT0l15
 ckVq8HefpqqFDBbFeotxOqqnsx7DHhC5SFGJQ9lgTjIg1zw105fsrlZUzAo7nJ3Xd7jm
 e8z4hk55l1qqDoY+JWV4/TaDVYBDv8OFlys4kIu4p9VskGvNb6xGTT4xGBh31fIYQOQA
 ijAEQUTxkXoqzubipCccRCzmLbtdjTe1b9ueG9Xu/j0sHDjbPswqQ2+XjfeGPobek1aQ
 DUAnkMe0sArZggODNAU6Iq+dYlNvgdbSzUxTBFv7YJ2OlnQM4+uqg0k7NL69X87HBeqa 2g== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33953er3rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:58:22 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VGrMdu032202
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:21 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 337en95vf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:58:21 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VGwKWu41287984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:58:20 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3E7EB2064;
        Mon, 31 Aug 2020 16:58:20 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED5B1B205F;
        Mon, 31 Aug 2020 16:58:19 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.160.96.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 16:58:19 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [PATCH net-next 4/5] ibmvnic: Reporting device ACL settings through sysfs
Date:   Mon, 31 Aug 2020 11:58:12 -0500
Message-Id: <1598893093-14280-5-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_07:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 adultscore=0 phishscore=0 clxscore=1015 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Access Control Lists can be defined for each IBM VNIC
adapter at time of creation. MAC address and VLAN ID's
may be specified, as well as a Port VLAN ID (PVID).
These may all be requested though read-only sysfs files:
mac_acl, vlan_acl, and pvid. When these files are read,
a series of Command-Response Queue (CRQ) commands is sent to
firmware. The first command requests the size of the ACL
data. The driver allocates a buffer of this size and passes
the address in a second CRQ command to firmware, which then
writes the ACL data to this buffer. This data is then parsed
and printed to the respective sysfs file.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 199 +++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/ibm/ibmvnic.h |  26 ++++-
 2 files changed, 222 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 91b9cc3..36dfa69 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1163,6 +1163,60 @@ static int __ibmvnic_open(struct net_device *netdev)
 	return rc;
 }
 
+static int ibmvnic_query_acl_sz(struct ibmvnic_adapter *adapter)
+{
+	union ibmvnic_crq crq;
+
+	memset(&crq, 0, sizeof(crq));
+	crq.acl_query.first = IBMVNIC_CRQ_CMD;
+	crq.acl_query.cmd = ACL_QUERY;
+
+	if (ibmvnic_send_crq(adapter, &crq))
+		return -EIO;
+	return 0;
+}
+
+static int ibmvnic_request_acl_buf(struct ibmvnic_adapter *adapter)
+{
+	struct device *dev = &adapter->vdev->dev;
+	union ibmvnic_crq rcrq;
+	int rc;
+
+	rc = 0;
+	adapter->acl_buf = kmalloc(adapter->acl_buf_sz, GFP_KERNEL);
+	if (!adapter->acl_buf) {
+		rc = -ENOMEM;
+		goto acl_alloc_err;
+	}
+	adapter->acl_buf_token = dma_map_single(dev, adapter->acl_buf,
+						adapter->acl_buf_sz,
+						DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, adapter->acl_buf_token)) {
+		rc = -ENOMEM;
+		goto acl_dma_err;
+	}
+	memset(&rcrq, 0, sizeof(rcrq));
+	rcrq.acl_query.first = IBMVNIC_CRQ_CMD;
+	rcrq.acl_query.cmd = ACL_QUERY;
+	rcrq.acl_query.ioba = cpu_to_be32(adapter->acl_buf_token);
+	rcrq.acl_query.len = cpu_to_be32(adapter->acl_buf_sz);
+	if (ibmvnic_send_crq(adapter, &rcrq)) {
+		rc = -EIO;
+		goto acl_query_err;
+	}
+	return 0;
+acl_query_err:
+	dma_unmap_single(dev, adapter->acl_buf_token,
+			 adapter->acl_buf_sz, DMA_FROM_DEVICE);
+	adapter->acl_buf_token = 0;
+	adapter->acl_buf_sz = 0;
+acl_dma_err:
+	kfree(adapter->acl_buf);
+	adapter->acl_buf = NULL;
+acl_alloc_err:
+	return rc;
+}
+
 static int ibmvnic_open(struct net_device *netdev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
@@ -4635,6 +4689,25 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
 	return rc;
 }
 
+static void handle_acl_query_rsp(struct ibmvnic_adapter *adapter,
+				 union ibmvnic_crq *crq)
+{
+	struct net_device *netdev = adapter->netdev;
+	u8 rcode;
+
+	rcode = crq->acl_query_rsp.rc.code;
+	adapter->fw_done_rc = rcode;
+	/* NOMEMORY is returned when ACL buffer size request is successful */
+	if (rcode == NOMEMORY) {
+		adapter->acl_buf_sz = be32_to_cpu(crq->acl_query_rsp.len);
+		netdev_dbg(netdev, "ACL buffer size is %d.\n",
+			   adapter->acl_buf_sz);
+	} else if (rcode != SUCCESS) {
+		netdev_err(netdev, "ACL query failed, rc = %u\n", rcode);
+	}
+	complete(&adapter->fw_done);
+}
+
 static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			       struct ibmvnic_adapter *adapter)
 {
@@ -4798,6 +4871,9 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 		adapter->fw_done_rc = handle_query_phys_parms_rsp(crq, adapter);
 		complete(&adapter->fw_done);
 		break;
+	case ACL_QUERY_RSP:
+		handle_acl_query_rsp(adapter, crq);
+		break;
 	default:
 		netdev_err(netdev, "Got an invalid cmd type 0x%02x\n",
 			   gen_crq->cmd);
@@ -5199,6 +5275,9 @@ static int ibmvnic_remove(struct vio_dev *dev)
 }
 
 static struct device_attribute dev_attr_failover;
+static struct device_attribute dev_attr_vlan_acl;
+static struct device_attribute dev_attr_mac_acl;
+static struct device_attribute dev_attr_pvid;
 
 static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
@@ -5234,10 +5313,130 @@ static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+static int ibmvnic_get_acls(struct ibmvnic_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	int rc;
+
+	mutex_lock(&adapter->fw_lock);
+	reinit_completion(&adapter->fw_done);
+	adapter->fw_done_rc = 0;
+	rc = ibmvnic_query_acl_sz(adapter);
+	if (rc) {
+		netdev_err(netdev, "Query ACL buffer size failed, rc = %d\n",
+			   rc);
+		goto out;
+	}
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
+	if (rc) {
+		netdev_err(netdev,
+			   "Query ACL buffer size did not complete, rc = %d\n",
+			   rc);
+		goto out;
+	}
+	/* NOMEMORY is returned when the ACL buffer size is retrieved
+	 * successfully
+	 */
+	if (adapter->fw_done_rc != NOMEMORY) {
+		netdev_err(netdev, "Unable to get ACL buffer size, rc = %d\n",
+			   adapter->fw_done_rc);
+		rc = -EIO;
+		goto out;
+	}
+	reinit_completion(&adapter->fw_done);
+	rc = ibmvnic_request_acl_buf(adapter);
+	if (rc) {
+		netdev_err(netdev, "ACL buffer request failed, rc = %d\n", rc);
+		goto out;
+	}
+	rc = ibmvnic_wait_for_completion(adapter, &adapter->fw_done, 10000);
+	if (rc) {
+		netdev_err(netdev,
+			   "ACL buffer request did not complete, rc = %d\n",
+			   rc);
+		goto out;
+	}
+	if (adapter->fw_done_rc != SUCCESS) {
+		netdev_err(netdev, "Unable to retrieve ACL buffer, rc = %d\n",
+			   adapter->fw_done_rc);
+		rc = -EIO;
+	}
+out:
+	mutex_unlock(&adapter->fw_lock);
+	return rc;
+}
+
+static ssize_t acl_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct ibmvnic_acl_buffer *acl_buf;
+	struct ibmvnic_adapter *adapter;
+	struct net_device *netdev;
+	int num_entries;
+	ssize_t rsize;
+	int offset;
+	int rc;
+	int i;
+
+	rsize = 0;
+	netdev = dev_get_drvdata(dev);
+	adapter = netdev_priv(netdev);
+	rc = ibmvnic_get_acls(adapter);
+	if (rc)
+		return rc;
+	acl_buf = adapter->acl_buf;
+	if (attr == &dev_attr_mac_acl) {
+		offset = be32_to_cpu(acl_buf->offset_mac_addrs);
+		num_entries = be32_to_cpu(acl_buf->num_mac_addrs);
+		if (num_entries == 0)
+			goto out;
+		for (i = 0; i < num_entries; i++) {
+			char *entry = (char *)acl_buf + offset + i * 6;
+
+			rsize += scnprintf(buf + rsize, PAGE_SIZE,
+					   "%pM\n", entry);
+		}
+	} else if (attr == &dev_attr_vlan_acl) {
+		offset = be32_to_cpu(acl_buf->offset_vlan_ids);
+		num_entries = be32_to_cpu(acl_buf->num_vlan_ids);
+		if (num_entries == 0)
+			goto out;
+		for (i = 0 ; i < num_entries; i++) {
+			char *entry = (char *)acl_buf + offset + i * 2;
+
+			rsize += scnprintf(buf + rsize, PAGE_SIZE, "%d\n",
+					   be16_to_cpup((__be16 *)entry));
+		}
+	} else if (attr == &dev_attr_pvid) {
+		u16 pvid, vid;
+		u8 pri;
+
+		pvid = be16_to_cpu(acl_buf->pvid);
+		vid = pvid & VLAN_VID_MASK;
+		pri = (pvid & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+
+		rsize = scnprintf(buf, PAGE_SIZE, "%d\n%d\n", vid, pri);
+	}
+out:
+	dma_unmap_single(dev, adapter->acl_buf_token, adapter->acl_buf_sz,
+			 DMA_FROM_DEVICE);
+	kfree(adapter->acl_buf);
+	adapter->acl_buf = NULL;
+	adapter->acl_buf_token = 0;
+	adapter->acl_buf_sz = 0;
+	return rsize;
+}
+
 static DEVICE_ATTR_WO(failover);
+static DEVICE_ATTR(mac_acl, 0444, acl_show, NULL);
+static DEVICE_ATTR(vlan_acl, 0444, acl_show, NULL);
+static DEVICE_ATTR(pvid, 0444, acl_show, NULL);
 
 static struct attribute *dev_attrs[] = {
 	&dev_attr_failover.attr,
+	&dev_attr_mac_acl.attr,
+	&dev_attr_vlan_acl.attr,
+	&dev_attr_pvid.attr,
 	NULL,
 };
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index e497392..4768626 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -195,12 +195,15 @@ struct ibmvnic_acl_buffer {
 #define INITIAL_VERSION_IOB 1
 	u8 mac_acls_restrict;
 	u8 vlan_acls_restrict;
-	u8 reserved1[22];
+	__be16 pvid;
+	u8 reserved1[52];
+	__be32 max_mac_addrs;
 	__be32 num_mac_addrs;
 	__be32 offset_mac_addrs;
+	__be32 max_vlan_ids;
 	__be32 num_vlan_ids;
 	__be32 offset_vlan_ids;
-	u8 reserved2[80];
+	u8 reserved2[40];
 } __packed __aligned(8);
 
 /* descriptors have been changed, how should this be defined?  1? 4? */
@@ -585,6 +588,19 @@ struct ibmvnic_acl_query {
 	u8 reserved2[4];
 } __packed __aligned(8);
 
+struct ibmvnic_acl_query_rsp {
+	u8 first;
+	u8 cmd;
+#define ACL_EXISTS      0x8000
+#define VLAN_ACL_ON     0x4000
+#define MAC_ACL_ON      0x2000
+#define PVID_ON	        0x1000
+	__be16 flags;
+	u8 reserved[4];
+	__be32 len;
+	struct ibmvnic_rc rc;
+} __packed __aligned(8);
+
 struct ibmvnic_tune {
 	u8 first;
 	u8 cmd;
@@ -695,7 +711,7 @@ struct ibmvnic_query_map_rsp {
 	struct ibmvnic_get_vpd get_vpd;
 	struct ibmvnic_get_vpd_rsp get_vpd_rsp;
 	struct ibmvnic_acl_query acl_query;
-	struct ibmvnic_generic_crq acl_query_rsp;
+	struct ibmvnic_acl_query_rsp acl_query_rsp;
 	struct ibmvnic_tune tune;
 	struct ibmvnic_generic_crq tune_rsp;
 	struct ibmvnic_request_map request_map;
@@ -1001,6 +1017,10 @@ struct ibmvnic_adapter {
 	dma_addr_t login_rsp_buf_token;
 	int login_rsp_buf_sz;
 
+	struct ibmvnic_acl_buffer *acl_buf;
+	dma_addr_t acl_buf_token;
+	int acl_buf_sz;
+
 	atomic_t running_cap_crqs;
 	bool wait_capability;
 
-- 
1.8.3.1

