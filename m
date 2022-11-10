Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3DF624D0A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiKJVcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiKJVco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:32:44 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480841D6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:32:43 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKxv05021472
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=24AVpmIaJ/BDwgP95Ju8/77eZp6jG4MTIzKoNWDFWkg=;
 b=DQytAJfIqwFimsYMporMDwUNmfxOUhv+oZBQ/uaXwM1og4dIUNO/p4I2KkG7Qax4jFHt
 3E5PCcW4+ITf2hsA1y3ynfQM6+2DzKdF7F+j7IOrznmXrPOqKcUEyQbhXun8xIwd0J+8
 7tAIOwcKZkDHNeW0qEZUTOY1xfBpoB8wZLdJd1fdNIwlZvqqu09qOGIM/BX/ThDxrM4p
 DlFuQGk5suisdtnAxC4br9gGJ54872/2MMY4ReHPjnth+a90xi8bYB4cr3qQHhIt9GmE
 ldLzDFlRQ73uf4sXWy6nFC2filx0hBd1ZXCQpvG2WiWs7r6du6jKL2OQGHjoGvcidSfl Gg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ks8u2rrdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:42 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AALTG6B028735
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:41 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 3kngne0err-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 21:32:41 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AALWfRk27984448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 21:32:41 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 667875805A;
        Thu, 10 Nov 2022 21:32:39 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 517DC5805E;
        Thu, 10 Nov 2022 21:32:38 +0000 (GMT)
Received: from li-8d37cfcc-31b9-11b2-a85c-83226d7135c9.ibm.com (unknown [9.160.178.220])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 10 Nov 2022 21:32:38 +0000 (GMT)
From:   Nick Child <nnac123@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@linux.ibm.com, haren@linux.ibm.com, ricklind@us.ibm.com,
        mmc@linux.ibm.com, Nick Child <nnac123@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: [PATCH net-next 2/3] ibmvnic: Add hotpluggable CPU callbacks to reassign affinity hints
Date:   Thu, 10 Nov 2022 15:32:17 -0600
Message-Id: <20221110213218.28662-3-nnac123@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221110213218.28662-1-nnac123@linux.ibm.com>
References: <20221110213218.28662-1-nnac123@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ltHRQ91C86qD9kak6E8ydO5qjAnXZDlh
X-Proofpoint-GUID: ltHRQ91C86qD9kak6E8ydO5qjAnXZDlh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_13,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CPU's are added and removed, ibmvnic devices will reassign
hint values. Introduce a new cpu hotplug state CPUHP_IBMVNIC_DEAD
to signal to ibmvnic devices that the CPU has been removed and it
is time to reset affinity hint assignments. On the other hand,
when CPU's are being added, add a state instance to
CPUHP_AP_ONLINE_DYN which will trigger a reassignment of affinity
hints once the new CPU's are online. This implementation is based
on the virtio_net driver.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Nick Child <nnac123@linux.ibm.com>
Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
Reviewed-by: Haren Myneni <haren@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 89 +++++++++++++++++++++++++++++-
 drivers/net/ethernet/ibm/ibmvnic.h |  4 ++
 include/linux/cpuhotplug.h         |  1 +
 3 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0c969bdaf94d..2fc0d50dbb86 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -298,6 +298,57 @@ static void ibmvnic_set_affinity(struct ibmvnic_adapter *adapter)
 	}
 }
 
+static int ibmvnic_cpu_online(unsigned int cpu, struct hlist_node *node)
+{
+	struct ibmvnic_adapter *adapter;
+
+	adapter = hlist_entry_safe(node, struct ibmvnic_adapter, node);
+	ibmvnic_set_affinity(adapter);
+	return 0;
+}
+
+static int ibmvnic_cpu_dead(unsigned int cpu, struct hlist_node *node)
+{
+	struct ibmvnic_adapter *adapter;
+
+	adapter = hlist_entry_safe(node, struct ibmvnic_adapter, node_dead);
+	ibmvnic_set_affinity(adapter);
+	return 0;
+}
+
+static int ibmvnic_cpu_down_prep(unsigned int cpu, struct hlist_node *node)
+{
+	struct ibmvnic_adapter *adapter;
+
+	adapter = hlist_entry_safe(node, struct ibmvnic_adapter, node);
+	ibmvnic_clean_affinity(adapter);
+	return 0;
+}
+
+static enum cpuhp_state ibmvnic_online;
+
+static int ibmvnic_cpu_notif_add(struct ibmvnic_adapter *adapter)
+{
+	int ret;
+
+	ret = cpuhp_state_add_instance_nocalls(ibmvnic_online, &adapter->node);
+	if (ret)
+		return ret;
+	ret = cpuhp_state_add_instance_nocalls(CPUHP_IBMVNIC_DEAD,
+					       &adapter->node_dead);
+	if (!ret)
+		return ret;
+	cpuhp_state_remove_instance_nocalls(ibmvnic_online, &adapter->node);
+	return ret;
+}
+
+static void ibmvnic_cpu_notif_remove(struct ibmvnic_adapter *adapter)
+{
+	cpuhp_state_remove_instance_nocalls(ibmvnic_online, &adapter->node);
+	cpuhp_state_remove_instance_nocalls(CPUHP_IBMVNIC_DEAD,
+					    &adapter->node_dead);
+}
+
 static long h_reg_sub_crq(unsigned long unit_address, unsigned long token,
 			  unsigned long length, unsigned long *number,
 			  unsigned long *irq)
@@ -6292,10 +6343,19 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	}
 	dev_info(&dev->dev, "ibmvnic registered\n");
 
+	rc = ibmvnic_cpu_notif_add(adapter);
+	if (rc) {
+		netdev_err(netdev, "Registering cpu notifier failed\n");
+		goto cpu_notif_add_failed;
+	}
+
 	complete(&adapter->probe_done);
 
 	return 0;
 
+cpu_notif_add_failed:
+	unregister_netdev(netdev);
+
 ibmvnic_register_fail:
 	device_remove_file(&dev->dev, &dev_attr_failover);
 
@@ -6346,6 +6406,8 @@ static void ibmvnic_remove(struct vio_dev *dev)
 
 	spin_unlock_irqrestore(&adapter->state_lock, flags);
 
+	ibmvnic_cpu_notif_remove(adapter);
+
 	flush_work(&adapter->ibmvnic_reset);
 	flush_delayed_work(&adapter->ibmvnic_delayed_reset);
 
@@ -6476,15 +6538,40 @@ static struct vio_driver ibmvnic_driver = {
 /* module functions */
 static int __init ibmvnic_module_init(void)
 {
+	int ret;
+
+	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "net/ibmvnic:online",
+				      ibmvnic_cpu_online,
+				      ibmvnic_cpu_down_prep);
+	if (ret < 0)
+		goto out;
+	ibmvnic_online = ret;
+	ret = cpuhp_setup_state_multi(CPUHP_IBMVNIC_DEAD, "net/ibmvnic:dead",
+				      NULL, ibmvnic_cpu_dead);
+	if (ret)
+		goto err_dead;
+
+	ret = vio_register_driver(&ibmvnic_driver);
+	if (ret)
+		goto err_vio_register;
+
 	pr_info("%s: %s %s\n", ibmvnic_driver_name, ibmvnic_driver_string,
 		IBMVNIC_DRIVER_VERSION);
 
-	return vio_register_driver(&ibmvnic_driver);
+	return 0;
+err_vio_register:
+	cpuhp_remove_multi_state(CPUHP_IBMVNIC_DEAD);
+err_dead:
+	cpuhp_remove_multi_state(ibmvnic_online);
+out:
+	return ret;
 }
 
 static void __exit ibmvnic_module_exit(void)
 {
 	vio_unregister_driver(&ibmvnic_driver);
+	cpuhp_remove_multi_state(CPUHP_IBMVNIC_DEAD);
+	cpuhp_remove_multi_state(ibmvnic_online);
 }
 
 module_init(ibmvnic_module_init);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 6720fec1ae67..b35c9b6f913b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -984,6 +984,10 @@ struct ibmvnic_adapter {
 	int reset_done_rc;
 	bool wait_for_reset;
 
+	/* CPU hotplug instances for online & dead */
+	struct hlist_node node;
+	struct hlist_node node_dead;
+
 	/* partner capabilities */
 	u64 min_tx_queues;
 	u64 min_rx_queues;
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index f61447913db9..c8bc85a87b1e 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -69,6 +69,7 @@ enum cpuhp_state {
 	CPUHP_X86_APB_DEAD,
 	CPUHP_X86_MCE_DEAD,
 	CPUHP_VIRT_NET_DEAD,
+	CPUHP_IBMVNIC_DEAD,
 	CPUHP_SLUB_DEAD,
 	CPUHP_DEBUG_OBJ_DEAD,
 	CPUHP_MM_WRITEBACK_DEAD,
-- 
2.31.1

