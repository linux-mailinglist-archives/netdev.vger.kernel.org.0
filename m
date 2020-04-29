Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F7B1BE236
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgD2PLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbgD2PLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:41 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF37Sd028822;
        Wed, 29 Apr 2020 11:11:34 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q7qhsxtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:34 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFAtwE021568;
        Wed, 29 Apr 2020 15:11:32 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 30mcu7wu90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBTk330081050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80E58AE05D;
        Wed, 29 Apr 2020 15:11:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32E54AE05A;
        Wed, 29 Apr 2020 15:11:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:29 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 01/13] net/smc: rework pnet table to support SMC-R failover
Date:   Wed, 29 Apr 2020 17:10:37 +0200
Message-Id: <20200429151049.49979-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pnet table stored pnet ids in the smc device structures. When a
device is going down its smc device structure is freed, and when the
device is brought online again it no longer has a pnet id set.
Rework the pnet table implementation to store the device name with their
assigned pnet id and apply the pnet id to devices when they are
registered.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_ib.c   |   5 +-
 net/smc/smc_ism.c  |   3 +-
 net/smc/smc_pnet.c | 539 ++++++++++++++++++++++++++-------------------
 net/smc/smc_pnet.h |   2 +
 4 files changed, 319 insertions(+), 230 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 04b6fefb8bce..440f9e319a38 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -579,8 +579,9 @@ static void smc_ib_add_dev(struct ib_device *ibdev)
 	     i++) {
 		set_bit(i, &smcibdev->port_event_mask);
 		/* determine pnetids of the port */
-		smc_pnetid_by_dev_port(ibdev->dev.parent, i,
-				       smcibdev->pnetid[i]);
+		if (smc_pnetid_by_dev_port(ibdev->dev.parent, i,
+					   smcibdev->pnetid[i]))
+			smc_pnetid_by_table_ib(smcibdev, i + 1);
 	}
 	schedule_work(&smcibdev->port_event_work);
 }
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 5c4727d5066e..32be2da2cb85 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -296,7 +296,8 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 	device_initialize(&smcd->dev);
 	dev_set_name(&smcd->dev, name);
 	smcd->ops = ops;
-	smc_pnetid_by_dev_port(parent, 0, smcd->pnetid);
+	if (smc_pnetid_by_dev_port(parent, 0, smcd->pnetid))
+		smc_pnetid_by_table_smcd(smcd);
 
 	spin_lock_init(&smcd->lock);
 	spin_lock_init(&smcd->lgr_lock);
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 2a5ed47c3e08..bd01c71b827a 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -50,29 +50,26 @@ static struct nla_policy smc_pnet_policy[SMC_PNETID_MAX + 1] = {
 
 static struct genl_family smc_pnet_nl_family;
 
-/**
- * struct smc_user_pnetentry - pnet identifier name entry for/from user
- * @list: List node.
- * @pnet_name: Pnet identifier name
- * @ndev: pointer to network device.
- * @smcibdev: Pointer to IB device.
- * @ib_port: Port of IB device.
- * @smcd_dev: Pointer to smcd device.
- */
-struct smc_user_pnetentry {
-	struct list_head list;
-	char pnet_name[SMC_MAX_PNETID_LEN + 1];
-	struct net_device *ndev;
-	struct smc_ib_device *smcibdev;
-	u8 ib_port;
-	struct smcd_dev *smcd_dev;
+enum smc_pnet_nametype {
+	SMC_PNET_ETH	= 1,
+	SMC_PNET_IB	= 2,
 };
 
 /* pnet entry stored in pnet table */
 struct smc_pnetentry {
 	struct list_head list;
 	char pnet_name[SMC_MAX_PNETID_LEN + 1];
-	struct net_device *ndev;
+	enum smc_pnet_nametype type;
+	union {
+		struct {
+			char eth_name[IFNAMSIZ + 1];
+			struct net_device *ndev;
+		};
+		struct {
+			char ib_name[IB_DEVICE_NAME_MAX + 1];
+			u8 ib_port;
+		};
+	};
 };
 
 /* Check if two given pnetids match */
@@ -106,14 +103,15 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	/* remove netdevices */
+	/* remove table entry */
 	write_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist,
 				 list) {
 		if (!pnet_name ||
 		    smc_pnet_match(pnetelem->pnet_name, pnet_name)) {
 			list_del(&pnetelem->list);
-			dev_put(pnetelem->ndev);
+			if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev)
+				dev_put(pnetelem->ndev);
 			kfree(pnetelem);
 			rc = 0;
 		}
@@ -155,9 +153,9 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 	return rc;
 }
 
-/* Remove a pnet entry mentioning a given network device from the pnet table.
+/* Add the reference to a given network device to the pnet table.
  */
-static int smc_pnet_remove_by_ndev(struct net_device *ndev)
+static int smc_pnet_add_by_ndev(struct net_device *ndev)
 {
 	struct smc_pnetentry *pnetelem, *tmp_pe;
 	struct smc_pnettable *pnettable;
@@ -171,10 +169,10 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 
 	write_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
-		if (pnetelem->ndev == ndev) {
-			list_del(&pnetelem->list);
-			dev_put(pnetelem->ndev);
-			kfree(pnetelem);
+		if (pnetelem->type == SMC_PNET_ETH && !pnetelem->ndev &&
+		    !strncmp(pnetelem->eth_name, ndev->name, IFNAMSIZ)) {
+			dev_hold(ndev);
+			pnetelem->ndev = ndev;
 			rc = 0;
 			break;
 		}
@@ -183,80 +181,67 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 	return rc;
 }
 
-/* Append a pnetid to the end of the pnet table if not already on this list.
+/* Remove the reference to a given network device from the pnet table.
  */
-static int smc_pnet_enter(struct smc_pnettable *pnettable,
-			  struct smc_user_pnetentry *new_pnetelem)
+static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 {
-	u8 pnet_null[SMC_MAX_PNETID_LEN] = {0};
-	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
-	struct smc_pnetentry *tmp_pnetelem;
-	struct smc_pnetentry *pnetelem;
-	bool new_smcddev = false;
-	struct net_device *ndev;
-	bool new_netdev = true;
-	bool new_ibdev = false;
-
-	if (new_pnetelem->smcibdev) {
-		struct smc_ib_device *ib_dev = new_pnetelem->smcibdev;
-		int ib_port = new_pnetelem->ib_port;
+	struct smc_pnetentry *pnetelem, *tmp_pe;
+	struct smc_pnettable *pnettable;
+	struct net *net = dev_net(ndev);
+	struct smc_net *sn;
+	int rc = -ENOENT;
 
-		spin_lock(&smc_ib_devices.lock);
-		if (smc_pnet_match(ib_dev->pnetid[ib_port - 1], pnet_null)) {
-			memcpy(ib_dev->pnetid[ib_port - 1],
-			       new_pnetelem->pnet_name, SMC_MAX_PNETID_LEN);
-			ib_dev->pnetid_by_user[ib_port - 1] = true;
-			new_ibdev = true;
-		}
-		spin_unlock(&smc_ib_devices.lock);
-	}
-	if (new_pnetelem->smcd_dev) {
-		struct smcd_dev *smcd_dev = new_pnetelem->smcd_dev;
+	/* get pnettable for namespace */
+	sn = net_generic(net, smc_net_id);
+	pnettable = &sn->pnettable;
 
-		spin_lock(&smcd_dev_list.lock);
-		if (smc_pnet_match(smcd_dev->pnetid, pnet_null)) {
-			memcpy(smcd_dev->pnetid, new_pnetelem->pnet_name,
-			       SMC_MAX_PNETID_LEN);
-			smcd_dev->pnetid_by_user = true;
-			new_smcddev = true;
+	write_lock(&pnettable->lock);
+	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
+		if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev == ndev) {
+			dev_put(pnetelem->ndev);
+			pnetelem->ndev = NULL;
+			rc = 0;
+			break;
 		}
-		spin_unlock(&smcd_dev_list.lock);
 	}
+	write_unlock(&pnettable->lock);
+	return rc;
+}
 
-	if (!new_pnetelem->ndev)
-		return (new_ibdev || new_smcddev) ? 0 : -EEXIST;
+/* Apply pnetid to ib device when no pnetid is set.
+ */
+static bool smc_pnet_apply_ib(struct smc_ib_device *ib_dev, u8 ib_port,
+			      char *pnet_name)
+{
+	u8 pnet_null[SMC_MAX_PNETID_LEN] = {0};
+	bool applied = false;
 
-	/* check if (base) netdev already has a pnetid. If there is one, we do
-	 * not want to add a pnet table entry
-	 */
-	ndev = pnet_find_base_ndev(new_pnetelem->ndev);
-	if (!smc_pnetid_by_dev_port(ndev->dev.parent, ndev->dev_port,
-				    ndev_pnetid))
-		return (new_ibdev || new_smcddev) ? 0 : -EEXIST;
+	spin_lock(&smc_ib_devices.lock);
+	if (smc_pnet_match(ib_dev->pnetid[ib_port - 1], pnet_null)) {
+		memcpy(ib_dev->pnetid[ib_port - 1], pnet_name,
+		       SMC_MAX_PNETID_LEN);
+		ib_dev->pnetid_by_user[ib_port - 1] = true;
+		applied = true;
+	}
+	spin_unlock(&smc_ib_devices.lock);
+	return applied;
+}
 
-	/* add a new netdev entry to the pnet table if there isn't one */
-	tmp_pnetelem = kzalloc(sizeof(*pnetelem), GFP_KERNEL);
-	if (!tmp_pnetelem)
-		return -ENOMEM;
-	memcpy(tmp_pnetelem->pnet_name, new_pnetelem->pnet_name,
-	       SMC_MAX_PNETID_LEN);
-	tmp_pnetelem->ndev = new_pnetelem->ndev;
+/* Apply pnetid to smcd device when no pnetid is set.
+ */
+static bool smc_pnet_apply_smcd(struct smcd_dev *smcd_dev, char *pnet_name)
+{
+	u8 pnet_null[SMC_MAX_PNETID_LEN] = {0};
+	bool applied = false;
 
-	write_lock(&pnettable->lock);
-	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
-		if (pnetelem->ndev == new_pnetelem->ndev)
-			new_netdev = false;
-	}
-	if (new_netdev) {
-		dev_hold(tmp_pnetelem->ndev);
-		list_add_tail(&tmp_pnetelem->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
-	} else {
-		write_unlock(&pnettable->lock);
-		kfree(tmp_pnetelem);
+	spin_lock(&smcd_dev_list.lock);
+	if (smc_pnet_match(smcd_dev->pnetid, pnet_null)) {
+		memcpy(smcd_dev->pnetid, pnet_name, SMC_MAX_PNETID_LEN);
+		smcd_dev->pnetid_by_user = true;
+		applied = true;
 	}
-
-	return (new_netdev || new_ibdev || new_smcddev) ? 0 : -EEXIST;
+	spin_unlock(&smcd_dev_list.lock);
+	return applied;
 }
 
 /* The limit for pnetid is 16 characters.
@@ -323,57 +308,167 @@ static struct smcd_dev *smc_pnet_find_smcd(char *smcd_name)
 	return smcd_dev;
 }
 
-/* Parse the supplied netlink attributes and fill a pnetentry structure.
- * For ethernet and infiniband device names verify that the devices exist.
+static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
+			    char *eth_name, char *pnet_name)
+{
+	struct smc_pnetentry *tmp_pe, *new_pe;
+	struct net_device *ndev, *base_ndev;
+	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
+	bool new_netdev;
+	int rc;
+
+	/* check if (base) netdev already has a pnetid. If there is one, we do
+	 * not want to add a pnet table entry
+	 */
+	rc = -EEXIST;
+	ndev = dev_get_by_name(net, eth_name);	/* dev_hold() */
+	if (ndev) {
+		base_ndev = pnet_find_base_ndev(ndev);
+		if (!smc_pnetid_by_dev_port(base_ndev->dev.parent,
+					    base_ndev->dev_port, ndev_pnetid))
+			goto out_put;
+	}
+
+	/* add a new netdev entry to the pnet table if there isn't one */
+	rc = -ENOMEM;
+	new_pe = kzalloc(sizeof(*new_pe), GFP_KERNEL);
+	if (!new_pe)
+		goto out_put;
+	new_pe->type = SMC_PNET_ETH;
+	memcpy(new_pe->pnet_name, pnet_name, SMC_MAX_PNETID_LEN);
+	strncpy(new_pe->eth_name, eth_name, IFNAMSIZ);
+	new_pe->ndev = ndev;
+
+	rc = -EEXIST;
+	new_netdev = true;
+	write_lock(&pnettable->lock);
+	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
+		if (tmp_pe->type == SMC_PNET_ETH &&
+		    !strncmp(tmp_pe->eth_name, eth_name, IFNAMSIZ)) {
+			new_netdev = false;
+			break;
+		}
+	}
+	if (new_netdev) {
+		list_add_tail(&new_pe->list, &pnettable->pnetlist);
+		write_unlock(&pnettable->lock);
+	} else {
+		write_unlock(&pnettable->lock);
+		kfree(new_pe);
+		goto out_put;
+	}
+	return 0;
+
+out_put:
+	if (ndev)
+		dev_put(ndev);
+	return rc;
+}
+
+static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
+			   u8 ib_port, char *pnet_name)
+{
+	struct smc_pnetentry *tmp_pe, *new_pe;
+	struct smc_ib_device *ib_dev;
+	bool smcddev_applied = true;
+	bool ibdev_applied = true;
+	struct smcd_dev *smcd_dev;
+	bool new_ibdev;
+
+	/* try to apply the pnetid to active devices */
+	ib_dev = smc_pnet_find_ib(ib_name);
+	if (ib_dev)
+		ibdev_applied = smc_pnet_apply_ib(ib_dev, ib_port, pnet_name);
+	smcd_dev = smc_pnet_find_smcd(ib_name);
+	if (smcd_dev)
+		smcddev_applied = smc_pnet_apply_smcd(smcd_dev, pnet_name);
+	/* Apply fails when a device has a hardware-defined pnetid set, do not
+	 * add a pnet table entry in that case.
+	 */
+	if (!ibdev_applied || !smcddev_applied)
+		return -EEXIST;
+
+	/* add a new ib entry to the pnet table if there isn't one */
+	new_pe = kzalloc(sizeof(*new_pe), GFP_KERNEL);
+	if (!new_pe)
+		return -ENOMEM;
+	new_pe->type = SMC_PNET_IB;
+	memcpy(new_pe->pnet_name, pnet_name, SMC_MAX_PNETID_LEN);
+	strncpy(new_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX);
+	new_pe->ib_port = ib_port;
+
+	new_ibdev = true;
+	write_lock(&pnettable->lock);
+	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
+		if (tmp_pe->type == SMC_PNET_IB &&
+		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
+			new_ibdev = false;
+			break;
+		}
+	}
+	if (new_ibdev) {
+		list_add_tail(&new_pe->list, &pnettable->pnetlist);
+		write_unlock(&pnettable->lock);
+	} else {
+		write_unlock(&pnettable->lock);
+		kfree(new_pe);
+	}
+	return (new_ibdev) ? 0 : -EEXIST;
+}
+
+/* Append a pnetid to the end of the pnet table if not already on this list.
  */
-static int smc_pnet_fill_entry(struct net *net,
-			       struct smc_user_pnetentry *pnetelem,
-			       struct nlattr *tb[])
+static int smc_pnet_enter(struct net *net, struct nlattr *tb[])
 {
-	char *string, *ibname;
+	char pnet_name[SMC_MAX_PNETID_LEN + 1];
+	struct smc_pnettable *pnettable;
+	bool new_netdev = false;
+	bool new_ibdev = false;
+	struct smc_net *sn;
+	u8 ibport = 1;
+	char *string;
 	int rc;
 
-	memset(pnetelem, 0, sizeof(*pnetelem));
-	INIT_LIST_HEAD(&pnetelem->list);
+	/* get pnettable for namespace */
+	sn = net_generic(net, smc_net_id);
+	pnettable = &sn->pnettable;
 
 	rc = -EINVAL;
 	if (!tb[SMC_PNETID_NAME])
 		goto error;
 	string = (char *)nla_data(tb[SMC_PNETID_NAME]);
-	if (!smc_pnetid_valid(string, pnetelem->pnet_name))
+	if (!smc_pnetid_valid(string, pnet_name))
 		goto error;
 
-	rc = -EINVAL;
 	if (tb[SMC_PNETID_ETHNAME]) {
 		string = (char *)nla_data(tb[SMC_PNETID_ETHNAME]);
-		pnetelem->ndev = dev_get_by_name(net, string);
-		if (!pnetelem->ndev)
+		rc = smc_pnet_add_eth(pnettable, net, string, pnet_name);
+		if (!rc)
+			new_netdev = true;
+		else if (rc != -EEXIST)
 			goto error;
 	}
 
 	/* if this is not the initial namespace, stop here */
 	if (net != &init_net)
-		return 0;
+		return new_netdev ? 0 : -EEXIST;
 
 	rc = -EINVAL;
 	if (tb[SMC_PNETID_IBNAME]) {
-		ibname = (char *)nla_data(tb[SMC_PNETID_IBNAME]);
-		ibname = strim(ibname);
-		pnetelem->smcibdev = smc_pnet_find_ib(ibname);
-		pnetelem->smcd_dev = smc_pnet_find_smcd(ibname);
-		if (!pnetelem->smcibdev && !pnetelem->smcd_dev)
-			goto error;
-		if (pnetelem->smcibdev) {
-			if (!tb[SMC_PNETID_IBPORT])
-				goto error;
-			pnetelem->ib_port = nla_get_u8(tb[SMC_PNETID_IBPORT]);
-			if (pnetelem->ib_port < 1 ||
-			    pnetelem->ib_port > SMC_MAX_PORTS)
+		string = (char *)nla_data(tb[SMC_PNETID_IBNAME]);
+		string = strim(string);
+		if (tb[SMC_PNETID_IBPORT]) {
+			ibport = nla_get_u8(tb[SMC_PNETID_IBPORT]);
+			if (ibport < 1 || ibport > SMC_MAX_PORTS)
 				goto error;
 		}
+		rc = smc_pnet_add_ib(pnettable, string, ibport, pnet_name);
+		if (!rc)
+			new_ibdev = true;
+		else if (rc != -EEXIST)
+			goto error;
 	}
-
-	return 0;
+	return (new_netdev || new_ibdev) ? 0 : -EEXIST;
 
 error:
 	return rc;
@@ -381,28 +476,22 @@ static int smc_pnet_fill_entry(struct net *net,
 
 /* Convert an smc_pnetentry to a netlink attribute sequence */
 static int smc_pnet_set_nla(struct sk_buff *msg,
-			    struct smc_user_pnetentry *pnetelem)
+			    struct smc_pnetentry *pnetelem)
 {
 	if (nla_put_string(msg, SMC_PNETID_NAME, pnetelem->pnet_name))
 		return -1;
-	if (pnetelem->ndev) {
+	if (pnetelem->type == SMC_PNET_ETH) {
 		if (nla_put_string(msg, SMC_PNETID_ETHNAME,
-				   pnetelem->ndev->name))
+				   pnetelem->eth_name))
 			return -1;
 	} else {
 		if (nla_put_string(msg, SMC_PNETID_ETHNAME, "n/a"))
 			return -1;
 	}
-	if (pnetelem->smcibdev) {
-		if (nla_put_string(msg, SMC_PNETID_IBNAME,
-			dev_name(pnetelem->smcibdev->ibdev->dev.parent)) ||
+	if (pnetelem->type == SMC_PNET_IB) {
+		if (nla_put_string(msg, SMC_PNETID_IBNAME, pnetelem->ib_name) ||
 		    nla_put_u8(msg, SMC_PNETID_IBPORT, pnetelem->ib_port))
 			return -1;
-	} else if (pnetelem->smcd_dev) {
-		if (nla_put_string(msg, SMC_PNETID_IBNAME,
-				   dev_name(&pnetelem->smcd_dev->dev)) ||
-		    nla_put_u8(msg, SMC_PNETID_IBPORT, 1))
-			return -1;
 	} else {
 		if (nla_put_string(msg, SMC_PNETID_IBNAME, "n/a") ||
 		    nla_put_u8(msg, SMC_PNETID_IBPORT, 0xff))
@@ -415,21 +504,8 @@ static int smc_pnet_set_nla(struct sk_buff *msg,
 static int smc_pnet_add(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
-	struct smc_user_pnetentry pnetelem;
-	struct smc_pnettable *pnettable;
-	struct smc_net *sn;
-	int rc;
-
-	/* get pnettable for namespace */
-	sn = net_generic(net, smc_net_id);
-	pnettable = &sn->pnettable;
 
-	rc = smc_pnet_fill_entry(net, &pnetelem, info->attrs);
-	if (!rc)
-		rc = smc_pnet_enter(pnettable, &pnetelem);
-	if (pnetelem.ndev)
-		dev_put(pnetelem.ndev);
-	return rc;
+	return smc_pnet_enter(net, info->attrs);
 }
 
 static int smc_pnet_del(struct sk_buff *skb, struct genl_info *info)
@@ -450,7 +526,7 @@ static int smc_pnet_dump_start(struct netlink_callback *cb)
 
 static int smc_pnet_dumpinfo(struct sk_buff *skb,
 			     u32 portid, u32 seq, u32 flags,
-			     struct smc_user_pnetentry *pnetelem)
+			     struct smc_pnetentry *pnetelem)
 {
 	void *hdr;
 
@@ -469,91 +545,32 @@ static int smc_pnet_dumpinfo(struct sk_buff *skb,
 static int _smc_pnet_dump(struct net *net, struct sk_buff *skb, u32 portid,
 			  u32 seq, u8 *pnetid, int start_idx)
 {
-	struct smc_user_pnetentry tmp_entry;
 	struct smc_pnettable *pnettable;
 	struct smc_pnetentry *pnetelem;
-	struct smc_ib_device *ibdev;
-	struct smcd_dev *smcd_dev;
 	struct smc_net *sn;
 	int idx = 0;
-	int ibport;
 
 	/* get pnettable for namespace */
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	/* dump netdevices */
+	/* dump pnettable entries */
 	read_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetid && !smc_pnet_match(pnetelem->pnet_name, pnetid))
 			continue;
 		if (idx++ < start_idx)
 			continue;
-		memset(&tmp_entry, 0, sizeof(tmp_entry));
-		memcpy(&tmp_entry.pnet_name, pnetelem->pnet_name,
-		       SMC_MAX_PNETID_LEN);
-		tmp_entry.ndev = pnetelem->ndev;
+		/* if this is not the initial namespace, dump only netdev */
+		if (net != &init_net && pnetelem->type != SMC_PNET_ETH)
+			continue;
 		if (smc_pnet_dumpinfo(skb, portid, seq, NLM_F_MULTI,
-				      &tmp_entry)) {
+				      pnetelem)) {
 			--idx;
 			break;
 		}
 	}
 	read_unlock(&pnettable->lock);
-
-	/* if this is not the initial namespace, stop here */
-	if (net != &init_net)
-		return idx;
-
-	/* dump ib devices */
-	spin_lock(&smc_ib_devices.lock);
-	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
-		for (ibport = 0; ibport < SMC_MAX_PORTS; ibport++) {
-			if (ibdev->pnetid_by_user[ibport]) {
-				if (pnetid &&
-				    !smc_pnet_match(ibdev->pnetid[ibport],
-						    pnetid))
-					continue;
-				if (idx++ < start_idx)
-					continue;
-				memset(&tmp_entry, 0, sizeof(tmp_entry));
-				memcpy(&tmp_entry.pnet_name,
-				       ibdev->pnetid[ibport],
-				       SMC_MAX_PNETID_LEN);
-				tmp_entry.smcibdev = ibdev;
-				tmp_entry.ib_port = ibport + 1;
-				if (smc_pnet_dumpinfo(skb, portid, seq,
-						      NLM_F_MULTI,
-						      &tmp_entry)) {
-					--idx;
-					break;
-				}
-			}
-		}
-	}
-	spin_unlock(&smc_ib_devices.lock);
-
-	/* dump smcd devices */
-	spin_lock(&smcd_dev_list.lock);
-	list_for_each_entry(smcd_dev, &smcd_dev_list.list, list) {
-		if (smcd_dev->pnetid_by_user) {
-			if (pnetid && !smc_pnet_match(smcd_dev->pnetid, pnetid))
-				continue;
-			if (idx++ < start_idx)
-				continue;
-			memset(&tmp_entry, 0, sizeof(tmp_entry));
-			memcpy(&tmp_entry.pnet_name, smcd_dev->pnetid,
-			       SMC_MAX_PNETID_LEN);
-			tmp_entry.smcd_dev = smcd_dev;
-			if (smc_pnet_dumpinfo(skb, portid, seq, NLM_F_MULTI,
-					      &tmp_entry)) {
-				--idx;
-				break;
-			}
-		}
-	}
-	spin_unlock(&smcd_dev_list.lock);
-
 	return idx;
 }
 
@@ -659,6 +676,9 @@ static int smc_pnet_netdev_event(struct notifier_block *this,
 	case NETDEV_UNREGISTER:
 		smc_pnet_remove_by_ndev(event_dev);
 		return NOTIFY_OK;
+	case NETDEV_REGISTER:
+		smc_pnet_add_by_ndev(event_dev);
+		return NOTIFY_OK;
 	default:
 		return NOTIFY_DONE;
 	}
@@ -744,7 +764,7 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 
 	read_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
-		if (ndev == pnetelem->ndev) {
+		if (pnetelem->type == SMC_PNET_ETH && ndev == pnetelem->ndev) {
 			/* get pnetid of netdev device */
 			memcpy(pnetid, pnetelem->pnet_name, SMC_MAX_PNETID_LEN);
 			rc = 0;
@@ -755,6 +775,34 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 	return rc;
 }
 
+/* find a roce device for the given pnetid */
+static void _smc_pnet_find_roce_by_pnetid(u8 *pnet_id,
+					  struct smc_init_info *ini)
+{
+	struct smc_ib_device *ibdev;
+	int i;
+
+	ini->ib_dev = NULL;
+	spin_lock(&smc_ib_devices.lock);
+	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
+		for (i = 1; i <= SMC_MAX_PORTS; i++) {
+			if (!rdma_is_port_valid(ibdev->ibdev, i))
+				continue;
+			if (smc_pnet_match(ibdev->pnetid[i - 1], pnet_id) &&
+			    smc_ib_port_active(ibdev, i) &&
+			    !test_bit(i - 1, ibdev->ports_going_away) &&
+			    !smc_ib_determine_gid(ibdev, i, ini->vlan_id,
+						  ini->ib_gid, NULL)) {
+				ini->ib_dev = ibdev;
+				ini->ib_port = i;
+				goto out;
+			}
+		}
+	}
+out:
+	spin_unlock(&smc_ib_devices.lock);
+}
+
 /* if handshake network device belongs to a roce device, return its
  * IB device and port
  */
@@ -801,8 +849,6 @@ static void smc_pnet_find_roce_by_pnetid(struct net_device *ndev,
 					 struct smc_init_info *ini)
 {
 	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
-	struct smc_ib_device *ibdev;
-	int i;
 
 	ndev = pnet_find_base_ndev(ndev);
 	if (smc_pnetid_by_dev_port(ndev->dev.parent, ndev->dev_port,
@@ -811,25 +857,7 @@ static void smc_pnet_find_roce_by_pnetid(struct net_device *ndev,
 		smc_pnet_find_rdma_dev(ndev, ini);
 		return; /* pnetid could not be determined */
 	}
-
-	spin_lock(&smc_ib_devices.lock);
-	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
-		for (i = 1; i <= SMC_MAX_PORTS; i++) {
-			if (!rdma_is_port_valid(ibdev->ibdev, i))
-				continue;
-			if (smc_pnet_match(ibdev->pnetid[i - 1], ndev_pnetid) &&
-			    smc_ib_port_active(ibdev, i) &&
-			    !test_bit(i - 1, ibdev->ports_going_away) &&
-			    !smc_ib_determine_gid(ibdev, i, ini->vlan_id,
-						  ini->ib_gid, NULL)) {
-				ini->ib_dev = ibdev;
-				ini->ib_port = i;
-				goto out;
-			}
-		}
-	}
-out:
-	spin_unlock(&smc_ib_devices.lock);
+	_smc_pnet_find_roce_by_pnetid(ndev_pnetid, ini);
 }
 
 static void smc_pnet_find_ism_by_pnetid(struct net_device *ndev,
@@ -895,3 +923,60 @@ void smc_pnet_find_ism_resource(struct sock *sk, struct smc_init_info *ini)
 out:
 	return;
 }
+
+/* Lookup and apply a pnet table entry to the given ib device.
+ */
+int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
+{
+	char *ib_name = smcibdev->ibdev->name;
+	struct smc_pnettable *pnettable;
+	struct smc_pnetentry *tmp_pe;
+	struct smc_net *sn;
+	int rc = -ENOENT;
+
+	/* get pnettable for init namespace */
+	sn = net_generic(&init_net, smc_net_id);
+	pnettable = &sn->pnettable;
+
+	read_lock(&pnettable->lock);
+	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
+		if (tmp_pe->type == SMC_PNET_IB &&
+		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX) &&
+		    tmp_pe->ib_port == ib_port) {
+			smc_pnet_apply_ib(smcibdev, ib_port, tmp_pe->pnet_name);
+			rc = 0;
+			break;
+		}
+	}
+	read_unlock(&pnettable->lock);
+
+	return rc;
+}
+
+/* Lookup and apply a pnet table entry to the given smcd device.
+ */
+int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
+{
+	const char *ib_name = dev_name(&smcddev->dev);
+	struct smc_pnettable *pnettable;
+	struct smc_pnetentry *tmp_pe;
+	struct smc_net *sn;
+	int rc = -ENOENT;
+
+	/* get pnettable for init namespace */
+	sn = net_generic(&init_net, smc_net_id);
+	pnettable = &sn->pnettable;
+
+	read_lock(&pnettable->lock);
+	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
+		if (tmp_pe->type == SMC_PNET_IB &&
+		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
+			smc_pnet_apply_smcd(smcddev, tmp_pe->pnet_name);
+			rc = 0;
+			break;
+		}
+	}
+	read_unlock(&pnettable->lock);
+
+	return rc;
+}
diff --git a/net/smc/smc_pnet.h b/net/smc/smc_pnet.h
index 4564e4d69c2e..ea207f8fc6f7 100644
--- a/net/smc/smc_pnet.h
+++ b/net/smc/smc_pnet.h
@@ -46,5 +46,7 @@ void smc_pnet_exit(void);
 void smc_pnet_net_exit(struct net *net);
 void smc_pnet_find_roce_resource(struct sock *sk, struct smc_init_info *ini);
 void smc_pnet_find_ism_resource(struct sock *sk, struct smc_init_info *ini);
+int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port);
+int smc_pnetid_by_table_smcd(struct smcd_dev *smcd);
 
 #endif
-- 
2.17.1

