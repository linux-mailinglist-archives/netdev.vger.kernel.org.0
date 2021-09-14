Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807D440A95E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhINIgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:36:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230263AbhINIgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:36:32 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18E8VMiv014197;
        Tue, 14 Sep 2021 04:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Tdr18JUpXvYXBWtmHc17ac8UPo5g6XdpX7wbg5ltxWs=;
 b=SNoiTOcJZITdwe5/r1T3W1DeF33g/kzRselcmCf2YJZXPhZR72e42lLwpBDsTHhnF9Mw
 bDSzkK+H5CJzgRKveHEYFG3zn4YtlMSHwG8UfEuamW8R3sy3wAugP4kSRX3Pse2vhNXc
 EFDUCw+f7gas9xw+GqsDpwUKwzlxF6fP5NbbKw3qgAXr3QTs1DQSgKQCOf3lgHtwRlZI
 Eb5iP2gGttwBviOs0STbCw88zdew/xjYE0y/zhkXsvejzvRrWnfS2I2ElXNFwplCj6E/
 8HiK0dxRJDQxeq/ihClMOC0TdWCXSwS4ObZlZNIWkF3lUCWAoKhRbEWoATQxInSy9Oh4 6Q== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2r9s01k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:35:14 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18E8WBUA015957;
        Tue, 14 Sep 2021 08:35:12 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3b0m38yyuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:35:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18E8UbOA58458576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:30:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 851BDA4040;
        Tue, 14 Sep 2021 08:35:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38B6EA405B;
        Tue, 14 Sep 2021 08:35:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 08:35:08 +0000 (GMT)
From:   Guvenc Gulce <guvenc@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net-next 1/3] net/smc: add support for user defined EIDs
Date:   Tue, 14 Sep 2021 10:35:05 +0200
Message-Id: <20210914083507.511369-2-guvenc@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914083507.511369-1-guvenc@linux.ibm.com>
References: <20210914083507.511369-1-guvenc@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fYve7FMLZGg9BsAOaOT4K8QVLjbciOJl
X-Proofpoint-GUID: fYve7FMLZGg9BsAOaOT4K8QVLjbciOJl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

SMC-Dv2 allows users to define EIDs which allows to create separate
name spaces enabling users to cluster their SMC-Dv2 connections.
Add support for user defined EIDs and extent the generic netlink
interface so users can add, remove and dump EIDs.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Guvenc Gulce  <guvenc@linux.ibm.com>
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
---
 include/uapi/linux/smc.h |  15 +++
 net/smc/af_smc.c         |  34 +++--
 net/smc/smc.h            |   3 -
 net/smc/smc_clc.c        | 263 +++++++++++++++++++++++++++++++++++++--
 net/smc/smc_clc.h        |  16 ++-
 net/smc/smc_core.h       |   1 +
 net/smc/smc_netlink.c    |  32 ++++-
 net/smc/smc_netlink.h    |   2 +
 8 files changed, 335 insertions(+), 31 deletions(-)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 0f7f87c70baf..e3728af2832b 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -38,6 +38,9 @@ enum {				/* SMC PNET Table commands */
 #define SMC_GENL_FAMILY_VERSION		1
 
 #define SMC_PCI_ID_STR_LEN		16 /* Max length of pci id string */
+#define SMC_MAX_HOSTNAME_LEN		32 /* Max length of the hostname */
+#define SMC_MAX_UEID			4  /* Max number of user EIDs */
+#define SMC_MAX_EID_LEN			32 /* Max length of an EID */
 
 /* SMC_GENL_FAMILY commands */
 enum {
@@ -49,6 +52,10 @@ enum {
 	SMC_NETLINK_GET_DEV_SMCR,
 	SMC_NETLINK_GET_STATS,
 	SMC_NETLINK_GET_FBACK_STATS,
+	SMC_NETLINK_DUMP_UEID,
+	SMC_NETLINK_ADD_UEID,
+	SMC_NETLINK_REMOVE_UEID,
+	SMC_NETLINK_FLUSH_UEID,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -242,4 +249,12 @@ enum {
 	__SMC_NLA_FBACK_STATS_MAX,
 	SMC_NLA_FBACK_STATS_MAX = __SMC_NLA_FBACK_STATS_MAX - 1
 };
+
+/* SMC_NETLINK_UEID attributes */
+enum {
+	SMC_NLA_EID_TABLE_UNSPEC,
+	SMC_NLA_EID_TABLE_ENTRY,	/* string */
+	__SMC_NLA_EID_TABLE_MAX,
+	SMC_NLA_EID_TABLE_MAX = __SMC_NLA_EID_TABLE_MAX - 1
+};
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c038efc23ce3..e5d62acbe401 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -829,7 +829,7 @@ static int smc_connect_rdma(struct smc_sock *smc,
 	smc_rmb_sync_sg_for_device(&smc->conn);
 
 	reason_code = smc_clc_send_confirm(smc, ini->first_contact_local,
-					   SMC_V1);
+					   SMC_V1, NULL);
 	if (reason_code)
 		goto connect_abort;
 
@@ -883,6 +883,7 @@ static int smc_connect_ism(struct smc_sock *smc,
 			   struct smc_clc_msg_accept_confirm *aclc,
 			   struct smc_init_info *ini)
 {
+	u8 *eid = NULL;
 	int rc = 0;
 
 	ini->is_smcd = true;
@@ -918,8 +919,15 @@ static int smc_connect_ism(struct smc_sock *smc,
 	smc_rx_init(smc);
 	smc_tx_init(smc);
 
+	if (aclc->hdr.version > SMC_V1) {
+		struct smc_clc_msg_accept_confirm_v2 *clc_v2 =
+			(struct smc_clc_msg_accept_confirm_v2 *)aclc;
+
+		eid = clc_v2->eid;
+	}
+
 	rc = smc_clc_send_confirm(smc, ini->first_contact_local,
-				  aclc->hdr.version);
+				  aclc->hdr.version, eid);
 	if (rc)
 		goto connect_abort;
 	mutex_unlock(&smc_server_lgr_pending);
@@ -1533,9 +1541,8 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	pclc_smcd = smc_get_clc_msg_smcd(pclc);
 	smc_v2_ext = smc_get_clc_v2_ext(pclc);
 	smcd_v2_ext = smc_get_clc_smcd_v2_ext(smc_v2_ext);
-	if (!smcd_v2_ext ||
-	    !smc_v2_ext->hdr.flag.seid) { /* no system EID support for SMCD */
-		smc_find_ism_store_rc(SMC_CLC_DECL_NOSEID, ini);
+	if (!smcd_v2_ext) {
+		smc_find_ism_store_rc(SMC_CLC_DECL_NOV2DEXT, ini);
 		goto not_found;
 	}
 
@@ -1555,13 +1562,13 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	}
 	mutex_unlock(&smcd_dev_list.mutex);
 
-	if (ini->ism_dev[0]) {
-		smc_ism_get_system_eid(ini->ism_dev[0], &eid);
-		if (memcmp(eid, smcd_v2_ext->system_eid, SMC_MAX_EID_LEN))
-			goto not_found;
-	} else {
+	if (!ini->ism_dev[0])
+		goto not_found;
+
+	smc_ism_get_system_eid(ini->ism_dev[0], &eid);
+	if (!smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext,
+			       smcd_v2_ext->system_eid, eid))
 		goto not_found;
-	}
 
 	/* separate - outside the smcd_dev_list.lock */
 	smcd_version = ini->smcd_version;
@@ -1579,6 +1586,7 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	}
 	/* no V2 ISM device could be initialized */
 	ini->smcd_version = smcd_version;	/* restore original value */
+	ini->negotiated_eid[0] = 0;
 
 not_found:
 	ini->smcd_version &= ~SMC_V2;
@@ -1788,7 +1796,8 @@ static void smc_listen_work(struct work_struct *work)
 
 	/* send SMC Accept CLC message */
 	rc = smc_clc_send_accept(new_smc, ini->first_contact_local,
-				 ini->smcd_version == SMC_V2 ? SMC_V2 : SMC_V1);
+				 ini->smcd_version == SMC_V2 ? SMC_V2 : SMC_V1,
+				 ini->negotiated_eid);
 	if (rc)
 		goto out_unlock;
 
@@ -2662,6 +2671,7 @@ static void __exit smc_exit(void)
 	proto_unregister(&smc_proto);
 	smc_pnet_exit();
 	smc_nl_exit();
+	smc_clc_exit();
 	unregister_pernet_subsys(&smc_net_stat_ops);
 	unregister_pernet_subsys(&smc_net_ops);
 	rcu_barrier();
diff --git a/net/smc/smc.h b/net/smc/smc.h
index d65e15f0c944..5e7def3ab730 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -29,9 +29,6 @@
 					 * devices
 					 */
 
-#define SMC_MAX_HOSTNAME_LEN	32
-#define SMC_MAX_EID_LEN		32
-
 extern struct proto smc_proto;
 extern struct proto smc_proto6;
 
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index e286dafd6e88..a3d99f894f52 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -26,6 +26,7 @@
 #include "smc_clc.h"
 #include "smc_ib.h"
 #include "smc_ism.h"
+#include "smc_netlink.h"
 
 #define SMCR_CLC_ACCEPT_CONFIRM_LEN 68
 #define SMCD_CLC_ACCEPT_CONFIRM_LEN 48
@@ -39,6 +40,223 @@ static const char SMCD_EYECATCHER[4] = {'\xe2', '\xd4', '\xc3', '\xc4'};
 
 static u8 smc_hostname[SMC_MAX_HOSTNAME_LEN];
 
+struct smc_clc_eid_table {
+	rwlock_t lock;
+	struct list_head list;
+	u8 ueid_cnt;
+	u8 seid_enabled;
+};
+
+static struct smc_clc_eid_table smc_clc_eid_table;
+
+struct smc_clc_eid_entry {
+	struct list_head list;
+	u8 eid[SMC_MAX_EID_LEN];
+};
+
+/* The size of a user EID is 32 characters.
+ * Valid characters should be (single-byte character set) A-Z, 0-9, '.' and '-'.
+ * Blanks should only be used to pad to the expected size.
+ * First character must be alphanumeric.
+ */
+static bool smc_clc_ueid_valid(char *ueid)
+{
+	char *end = ueid + SMC_MAX_EID_LEN;
+
+	while (--end >= ueid && isspace(*end))
+		;
+	if (end < ueid)
+		return false;
+	if (!isalnum(*ueid) || islower(*ueid))
+		return false;
+	while (ueid <= end) {
+		if ((!isalnum(*ueid) || islower(*ueid)) && *ueid != '.' &&
+		    *ueid != '-')
+			return false;
+		ueid++;
+	}
+	return true;
+}
+
+static int smc_clc_ueid_add(char *ueid)
+{
+	struct smc_clc_eid_entry *new_ueid, *tmp_ueid;
+	int rc;
+
+	if (!smc_clc_ueid_valid(ueid))
+		return -EINVAL;
+
+	/* add a new ueid entry to the ueid table if there isn't one */
+	new_ueid = kzalloc(sizeof(*new_ueid), GFP_KERNEL);
+	if (!new_ueid)
+		return -ENOMEM;
+	memcpy(new_ueid->eid, ueid, SMC_MAX_EID_LEN);
+
+	write_lock(&smc_clc_eid_table.lock);
+	if (smc_clc_eid_table.ueid_cnt >= SMC_MAX_UEID) {
+		rc = -ERANGE;
+		goto err_out;
+	}
+	list_for_each_entry(tmp_ueid, &smc_clc_eid_table.list, list) {
+		if (!memcmp(tmp_ueid->eid, ueid, SMC_MAX_EID_LEN)) {
+			rc = -EEXIST;
+			goto err_out;
+		}
+	}
+	list_add_tail(&new_ueid->list, &smc_clc_eid_table.list);
+	smc_clc_eid_table.ueid_cnt++;
+	write_unlock(&smc_clc_eid_table.lock);
+	return 0;
+
+err_out:
+	write_unlock(&smc_clc_eid_table.lock);
+	kfree(new_ueid);
+	return rc;
+}
+
+int smc_nl_add_ueid(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *nla_ueid = info->attrs[SMC_NLA_EID_TABLE_ENTRY];
+	char *ueid;
+
+	if (!nla_ueid || nla_len(nla_ueid) != SMC_MAX_EID_LEN + 1)
+		return -EINVAL;
+	ueid = (char *)nla_data(nla_ueid);
+
+	return smc_clc_ueid_add(ueid);
+}
+
+/* remove one or all ueid entries from the table */
+static int smc_clc_ueid_remove(char *ueid)
+{
+	struct smc_clc_eid_entry *lst_ueid, *tmp_ueid;
+	int rc = -ENOENT;
+
+	/* remove table entry */
+	write_lock(&smc_clc_eid_table.lock);
+	list_for_each_entry_safe(lst_ueid, tmp_ueid, &smc_clc_eid_table.list,
+				 list) {
+		if (!ueid || !memcmp(lst_ueid->eid, ueid, SMC_MAX_EID_LEN)) {
+			list_del(&lst_ueid->list);
+			smc_clc_eid_table.ueid_cnt--;
+			kfree(lst_ueid);
+			rc = 0;
+		}
+	}
+	write_unlock(&smc_clc_eid_table.lock);
+	return rc;
+}
+
+int smc_nl_remove_ueid(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *nla_ueid = info->attrs[SMC_NLA_EID_TABLE_ENTRY];
+	char *ueid;
+
+	if (!nla_ueid || nla_len(nla_ueid) != SMC_MAX_EID_LEN + 1)
+		return -EINVAL;
+	ueid = (char *)nla_data(nla_ueid);
+
+	return smc_clc_ueid_remove(ueid);
+}
+
+int smc_nl_flush_ueid(struct sk_buff *skb, struct genl_info *info)
+{
+	smc_clc_ueid_remove(NULL);
+	return 0;
+}
+
+static int smc_nl_ueid_dumpinfo(struct sk_buff *skb, u32 portid, u32 seq,
+				u32 flags, char *ueid)
+{
+	char ueid_str[SMC_MAX_EID_LEN + 1];
+	void *hdr;
+
+	hdr = genlmsg_put(skb, portid, seq, &smc_gen_nl_family,
+			  flags, SMC_NETLINK_DUMP_UEID);
+	if (!hdr)
+		return -ENOMEM;
+	snprintf(ueid_str, sizeof(ueid_str), "%s", ueid);
+	if (nla_put_string(skb, SMC_NLA_EID_TABLE_ENTRY, ueid_str)) {
+		genlmsg_cancel(skb, hdr);
+		return -EMSGSIZE;
+	}
+	genlmsg_end(skb, hdr);
+	return 0;
+}
+
+static int _smc_nl_ueid_dump(struct sk_buff *skb, u32 portid, u32 seq,
+			     int start_idx)
+{
+	struct smc_clc_eid_entry *lst_ueid;
+	int idx = 0;
+
+	read_lock(&smc_clc_eid_table.lock);
+	list_for_each_entry(lst_ueid, &smc_clc_eid_table.list, list) {
+		if (idx++ < start_idx)
+			continue;
+		if (smc_nl_ueid_dumpinfo(skb, portid, seq, NLM_F_MULTI,
+					 lst_ueid->eid)) {
+			--idx;
+			break;
+		}
+	}
+	read_unlock(&smc_clc_eid_table.lock);
+	return idx;
+}
+
+int smc_nl_dump_ueid(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	int idx;
+
+	idx = _smc_nl_ueid_dump(skb, NETLINK_CB(cb->skb).portid,
+				cb->nlh->nlmsg_seq, cb_ctx->pos[0]);
+
+	cb_ctx->pos[0] = idx;
+	return skb->len;
+}
+
+static bool _smc_clc_match_ueid(u8 *peer_ueid)
+{
+	struct smc_clc_eid_entry *tmp_ueid;
+
+	list_for_each_entry(tmp_ueid, &smc_clc_eid_table.list, list) {
+		if (!memcmp(tmp_ueid->eid, peer_ueid, SMC_MAX_EID_LEN))
+			return true;
+	}
+	return false;
+}
+
+bool smc_clc_match_eid(u8 *negotiated_eid,
+		       struct smc_clc_v2_extension *smc_v2_ext,
+		       u8 *peer_eid, u8 *local_eid)
+{
+	bool match = false;
+	int i;
+
+	negotiated_eid[0] = 0;
+	read_lock(&smc_clc_eid_table.lock);
+	if (smc_clc_eid_table.seid_enabled &&
+	    smc_v2_ext->hdr.flag.seid &&
+	    !memcmp(peer_eid, local_eid, SMC_MAX_EID_LEN)) {
+		memcpy(negotiated_eid, peer_eid, SMC_MAX_EID_LEN);
+		match = true;
+		goto out;
+	}
+
+	for (i = 0; i < smc_v2_ext->hdr.eid_cnt; i++) {
+		if (_smc_clc_match_ueid(smc_v2_ext->user_eids[i])) {
+			memcpy(negotiated_eid, smc_v2_ext->user_eids[i],
+			       SMC_MAX_EID_LEN);
+			match = true;
+			goto out;
+		}
+	}
+out:
+	read_unlock(&smc_clc_eid_table.lock);
+	return match;
+}
+
 /* check arriving CLC proposal */
 static bool smc_clc_msg_prop_valid(struct smc_clc_msg_proposal *pclc)
 {
@@ -550,6 +768,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 	if (ini->smc_type_v2 == SMC_TYPE_N) {
 		pclc_smcd->v2_ext_offset = 0;
 	} else {
+		struct smc_clc_eid_entry *ueident;
 		u16 v2_ext_offset;
 		u8 *eid = NULL;
 
@@ -560,10 +779,19 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 						pclc_prfx->ipv6_prefixes_cnt *
 						sizeof(ipv6_prfx[0]);
 		pclc_smcd->v2_ext_offset = htons(v2_ext_offset);
-		v2_ext->hdr.eid_cnt = 0;
+
+		read_lock(&smc_clc_eid_table.lock);
+		v2_ext->hdr.eid_cnt = smc_clc_eid_table.ueid_cnt;
+		plen += smc_clc_eid_table.ueid_cnt * SMC_MAX_EID_LEN;
+		i = 0;
+		list_for_each_entry(ueident, &smc_clc_eid_table.list, list) {
+			memcpy(v2_ext->user_eids[i++], ueident->eid,
+			       sizeof(ueident->eid));
+		}
+		v2_ext->hdr.flag.seid = smc_clc_eid_table.seid_enabled;
+		read_unlock(&smc_clc_eid_table.lock);
 		v2_ext->hdr.ism_gid_cnt = ini->ism_offered_cnt;
 		v2_ext->hdr.flag.release = SMC_RELEASE;
-		v2_ext->hdr.flag.seid = 1;
 		v2_ext->hdr.smcd_v2_ext_offset = htons(sizeof(*v2_ext) -
 				offsetofend(struct smc_clnt_opts_area_hdr,
 					    smcd_v2_ext_offset) +
@@ -572,7 +800,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 			smc_ism_get_system_eid(ini->ism_dev[0], &eid);
 		else
 			smc_ism_get_system_eid(ini->ism_dev[1], &eid);
-		if (eid)
+		if (eid && v2_ext->hdr.flag.seid)
 			memcpy(smcd_v2_ext->system_eid, eid, SMC_MAX_EID_LEN);
 		plen += sizeof(*v2_ext) + sizeof(*smcd_v2_ext);
 		if (ini->ism_offered_cnt) {
@@ -607,7 +835,8 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 	}
 	if (ini->smc_type_v2 != SMC_TYPE_N) {
 		vec[i].iov_base = v2_ext;
-		vec[i++].iov_len = sizeof(*v2_ext);
+		vec[i++].iov_len = sizeof(*v2_ext) +
+				   (v2_ext->hdr.eid_cnt * SMC_MAX_EID_LEN);
 		vec[i].iov_base = smcd_v2_ext;
 		vec[i++].iov_len = sizeof(*smcd_v2_ext);
 		if (ini->ism_offered_cnt) {
@@ -635,7 +864,8 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 /* build and send CLC CONFIRM / ACCEPT message */
 static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 				       struct smc_clc_msg_accept_confirm_v2 *clc_v2,
-				       int first_contact, u8 version)
+				       int first_contact, u8 version,
+				       u8 *eid)
 {
 	struct smc_connection *conn = &smc->conn;
 	struct smc_clc_msg_accept_confirm *clc;
@@ -663,11 +893,8 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		if (version == SMC_V1) {
 			clc->hdr.length = htons(SMCD_CLC_ACCEPT_CONFIRM_LEN);
 		} else {
-			u8 *eid = NULL;
-
 			clc_v2->chid = htons(smc_ism_get_chid(conn->lgr->smcd));
-			smc_ism_get_system_eid(conn->lgr->smcd, &eid);
-			if (eid)
+			if (eid[0])
 				memcpy(clc_v2->eid, eid, SMC_MAX_EID_LEN);
 			len = SMCD_CLC_ACCEPT_CONFIRM_LEN_V2;
 			if (first_contact)
@@ -732,7 +959,7 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 
 /* send CLC CONFIRM message across internal TCP socket */
 int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
-			 u8 version)
+			 u8 version, u8 *eid)
 {
 	struct smc_clc_msg_accept_confirm_v2 cclc_v2;
 	int reason_code = 0;
@@ -742,7 +969,7 @@ int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
 	memset(&cclc_v2, 0, sizeof(cclc_v2));
 	cclc_v2.hdr.type = SMC_CLC_CONFIRM;
 	len = smc_clc_send_confirm_accept(smc, &cclc_v2, clnt_first_contact,
-					  version);
+					  version, eid);
 	if (len < ntohs(cclc_v2.hdr.length)) {
 		if (len >= 0) {
 			reason_code = -ENETUNREACH;
@@ -757,7 +984,7 @@ int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
 
 /* send CLC ACCEPT message across internal TCP socket */
 int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
-			u8 version)
+			u8 version, u8 *negotiated_eid)
 {
 	struct smc_clc_msg_accept_confirm_v2 aclc_v2;
 	int len;
@@ -765,7 +992,7 @@ int smc_clc_send_accept(struct smc_sock *new_smc, bool srv_first_contact,
 	memset(&aclc_v2, 0, sizeof(aclc_v2));
 	aclc_v2.hdr.type = SMC_CLC_ACCEPT;
 	len = smc_clc_send_confirm_accept(new_smc, &aclc_v2, srv_first_contact,
-					  version);
+					  version, negotiated_eid);
 	if (len < ntohs(aclc_v2.hdr.length))
 		len = len >= 0 ? -EPROTO : -new_smc->clcsock->sk->sk_err;
 
@@ -785,4 +1012,14 @@ void __init smc_clc_init(void)
 	u = utsname();
 	memcpy(smc_hostname, u->nodename,
 	       min_t(size_t, strlen(u->nodename), sizeof(smc_hostname)));
+
+	INIT_LIST_HEAD(&smc_clc_eid_table.list);
+	rwlock_init(&smc_clc_eid_table.lock);
+	smc_clc_eid_table.ueid_cnt = 0;
+	smc_clc_eid_table.seid_enabled = 1;
+}
+
+void smc_clc_exit(void)
+{
+	smc_clc_ueid_remove(NULL);
 }
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 32d37f7b70f2..0699e0cee308 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -14,8 +14,10 @@
 #define _SMC_CLC_H
 
 #include <rdma/ib_verbs.h>
+#include <linux/smc.h>
 
 #include "smc.h"
+#include "smc_netlink.h"
 
 #define SMC_CLC_PROPOSAL	0x01
 #define SMC_CLC_ACCEPT		0x02
@@ -158,6 +160,7 @@ struct smc_clc_msg_proposal {	/* clc proposal message sent by Linux */
 } __aligned(4);
 
 #define SMC_CLC_MAX_V6_PREFIX		8
+#define SMC_CLC_MAX_UEID		8
 
 struct smc_clc_msg_proposal_area {
 	struct smc_clc_msg_proposal		pclc_base;
@@ -165,6 +168,7 @@ struct smc_clc_msg_proposal_area {
 	struct smc_clc_msg_proposal_prefix	pclc_prfx;
 	struct smc_clc_ipv6_prefix	pclc_prfx_ipv6[SMC_CLC_MAX_V6_PREFIX];
 	struct smc_clc_v2_extension		pclc_v2_ext;
+	u8			user_eids[SMC_CLC_MAX_UEID][SMC_MAX_EID_LEN];
 	struct smc_clc_smcd_v2_extension	pclc_smcd_v2_ext;
 	struct smc_clc_smcd_gid_chid		pclc_gidchids[SMC_MAX_ISM_DEVS];
 	struct smc_clc_msg_trail		pclc_trl;
@@ -330,10 +334,18 @@ int smc_clc_wait_msg(struct smc_sock *smc, void *buf, int buflen,
 int smc_clc_send_decline(struct smc_sock *smc, u32 peer_diag_info, u8 version);
 int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini);
 int smc_clc_send_confirm(struct smc_sock *smc, bool clnt_first_contact,
-			 u8 version);
+			 u8 version, u8 *eid);
 int smc_clc_send_accept(struct smc_sock *smc, bool srv_first_contact,
-			u8 version);
+			u8 version, u8 *negotiated_eid);
 void smc_clc_init(void) __init;
+void smc_clc_exit(void);
 void smc_clc_get_hostname(u8 **host);
+bool smc_clc_match_eid(u8 *negotiated_eid,
+		       struct smc_clc_v2_extension *smc_v2_ext,
+		       u8 *peer_eid, u8 *local_eid);
+int smc_nl_dump_ueid(struct sk_buff *skb, struct netlink_callback *cb);
+int smc_nl_add_ueid(struct sk_buff *skb, struct genl_info *info);
+int smc_nl_remove_ueid(struct sk_buff *skb, struct genl_info *info);
+int smc_nl_flush_ueid(struct sk_buff *skb, struct genl_info *info);
 
 #endif
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index c043ecdca5c4..83d30b06016f 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -310,6 +310,7 @@ struct smc_init_info {
 	u8			first_contact_local;
 	unsigned short		vlan_id;
 	u32			rc;
+	u8			negotiated_eid[SMC_MAX_EID_LEN];
 	/* SMC-R */
 	struct smc_clc_msg_local *ib_lcl;
 	struct smc_ib_device	*ib_dev;
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index 6fb6f96c1d17..4548ff2df245 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -19,11 +19,19 @@
 #include "smc_core.h"
 #include "smc_ism.h"
 #include "smc_ib.h"
+#include "smc_clc.h"
 #include "smc_stats.h"
 #include "smc_netlink.h"
 
-#define SMC_CMD_MAX_ATTR 1
+const struct nla_policy
+smc_gen_ueid_policy[SMC_NLA_EID_TABLE_MAX + 1] = {
+	[SMC_NLA_EID_TABLE_UNSPEC]	= { .type = NLA_UNSPEC },
+	[SMC_NLA_EID_TABLE_ENTRY]	= { .type = NLA_STRING,
+					    .len = SMC_MAX_EID_LEN,
+					  },
+};
 
+#define SMC_CMD_MAX_ATTR 1
 /* SMC_GENL generic netlink operation definition */
 static const struct genl_ops smc_gen_nl_ops[] = {
 	{
@@ -66,6 +74,28 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		/* can be retrieved by unprivileged users */
 		.dumpit = smc_nl_get_fback_stats,
 	},
+	{
+		.cmd = SMC_NETLINK_DUMP_UEID,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smc_nl_dump_ueid,
+	},
+	{
+		.cmd = SMC_NETLINK_ADD_UEID,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_nl_add_ueid,
+		.policy = smc_gen_ueid_policy,
+	},
+	{
+		.cmd = SMC_NETLINK_REMOVE_UEID,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_nl_remove_ueid,
+		.policy = smc_gen_ueid_policy,
+	},
+	{
+		.cmd = SMC_NETLINK_FLUSH_UEID,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_nl_flush_ueid,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
diff --git a/net/smc/smc_netlink.h b/net/smc/smc_netlink.h
index 5ce2c0a89ccd..e8c6c3f0e98c 100644
--- a/net/smc/smc_netlink.h
+++ b/net/smc/smc_netlink.h
@@ -17,6 +17,8 @@
 
 extern struct genl_family smc_gen_nl_family;
 
+extern const struct nla_policy smc_gen_ueid_policy[];
+
 struct smc_nl_dmp_ctx {
 	int pos[3];
 };
-- 
2.25.1

