Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEF840A960
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhINIgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:36:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56552 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230491AbhINIge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:36:34 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18E6UNi7016104;
        Tue, 14 Sep 2021 04:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mKt9BhduL0o+K5FCP09PCkDBUGNZJjYSeXmf+hBqX1I=;
 b=PKAJ0kv2qnx4oPsMlWtnsD2gu6So0aNuxIe6tbH9wK+k1yl5H6LEifxdJ/YhfvaoFZRW
 8x0OT3xVjmQPO3HwlpJ5lNhp6kFGMqm2b3q4Akrg7gAQ+ym95XmPVM+naDh3M0aVzWK3
 chlYvhfaCjh3jmCo0AeYiJ95/J1UFjhYWd2umjTifGD2kyYGgsmrahM7A3v2fz9f4CHq
 wNcSum+ubcQHUkVbtbwpQk5FMQRrCW3oRAZOVBGmX2NQC9c+BXBI6gMeRwqDE6xm6AGW
 7JPL/mUETY70NyN4ZD3XnhhQM03mdYAqfQ8oTJz3HU0Qen4Nb2MjaGkUVYFtmq2h9WUy fw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b2phejpjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:35:14 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18E8XO0J005454;
        Tue, 14 Sep 2021 08:35:13 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3b0m39rwku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:35:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18E8UfkR58720662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:30:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42F5AA4059;
        Tue, 14 Sep 2021 08:35:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02D43A406F;
        Tue, 14 Sep 2021 08:35:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 08:35:08 +0000 (GMT)
From:   Guvenc Gulce <guvenc@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net-next 3/3] net/smc: add generic netlink support for system EID
Date:   Tue, 14 Sep 2021 10:35:07 +0200
Message-Id: <20210914083507.511369-4-guvenc@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914083507.511369-1-guvenc@linux.ibm.com>
References: <20210914083507.511369-1-guvenc@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KUE-O7jk2PgVk5qgC6LLguPGEgeqENv0
X-Proofpoint-GUID: KUE-O7jk2PgVk5qgC6LLguPGEgeqENv0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140026
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

With SMC-Dv2 users can configure if the static system EID should be used
during CLC handshake, or if only user EIDs are allowed.
Add generic netlink support to enable and disable the system EID, and
to retrieve the system EID and its current enabled state.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Guvenc Gulce  <guvenc@linux.ibm.com>
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
---
 include/uapi/linux/smc.h | 12 ++++++++
 net/smc/smc_clc.c        | 62 ++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_clc.h        |  3 ++
 net/smc/smc_netlink.c    | 15 ++++++++++
 4 files changed, 92 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index e3728af2832b..b175bd0165a1 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -56,6 +56,9 @@ enum {
 	SMC_NETLINK_ADD_UEID,
 	SMC_NETLINK_REMOVE_UEID,
 	SMC_NETLINK_FLUSH_UEID,
+	SMC_NETLINK_DUMP_SEID,
+	SMC_NETLINK_ENABLE_SEID,
+	SMC_NETLINK_DISABLE_SEID,
 };
 
 /* SMC_GENL_FAMILY top level attributes */
@@ -257,4 +260,13 @@ enum {
 	__SMC_NLA_EID_TABLE_MAX,
 	SMC_NLA_EID_TABLE_MAX = __SMC_NLA_EID_TABLE_MAX - 1
 };
+
+/* SMC_NETLINK_SEID attributes */
+enum {
+	SMC_NLA_SEID_UNSPEC,
+	SMC_NLA_SEID_ENTRY,	/* string */
+	SMC_NLA_SEID_ENABLED,	/* u8 */
+	__SMC_NLA_SEID_TABLE_MAX,
+	SMC_NLA_SEID_TABLE_MAX = __SMC_NLA_SEID_TABLE_MAX - 1
+};
 #endif /* _UAPI_LINUX_SMC_H */
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 5a5ebf752860..4afd9e71e5c2 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -143,6 +143,10 @@ static int smc_clc_ueid_remove(char *ueid)
 			rc = 0;
 		}
 	}
+	if (!rc && !smc_clc_eid_table.ueid_cnt) {
+		smc_clc_eid_table.seid_enabled = 1;
+		rc = -EAGAIN;	/* indicate success and enabling of seid */
+	}
 	write_unlock(&smc_clc_eid_table.lock);
 	return rc;
 }
@@ -216,6 +220,64 @@ int smc_nl_dump_ueid(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+int smc_nl_dump_seid(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
+	char seid_str[SMC_MAX_EID_LEN + 1];
+	u8 seid_enabled;
+	void *hdr;
+	u8 *seid;
+
+	if (cb_ctx->pos[0])
+		return skb->len;
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &smc_gen_nl_family, NLM_F_MULTI,
+			  SMC_NETLINK_DUMP_SEID);
+	if (!hdr)
+		return -ENOMEM;
+	if (!smc_ism_is_v2_capable())
+		goto end;
+
+	smc_ism_get_system_eid(&seid);
+	snprintf(seid_str, sizeof(seid_str), "%s", seid);
+	if (nla_put_string(skb, SMC_NLA_SEID_ENTRY, seid_str))
+		goto err;
+	read_lock(&smc_clc_eid_table.lock);
+	seid_enabled = smc_clc_eid_table.seid_enabled;
+	read_unlock(&smc_clc_eid_table.lock);
+	if (nla_put_u8(skb, SMC_NLA_SEID_ENABLED, seid_enabled))
+		goto err;
+end:
+	genlmsg_end(skb, hdr);
+	cb_ctx->pos[0]++;
+	return skb->len;
+err:
+	genlmsg_cancel(skb, hdr);
+	return -EMSGSIZE;
+}
+
+int smc_nl_enable_seid(struct sk_buff *skb, struct genl_info *info)
+{
+	write_lock(&smc_clc_eid_table.lock);
+	smc_clc_eid_table.seid_enabled = 1;
+	write_unlock(&smc_clc_eid_table.lock);
+	return 0;
+}
+
+int smc_nl_disable_seid(struct sk_buff *skb, struct genl_info *info)
+{
+	int rc = 0;
+
+	write_lock(&smc_clc_eid_table.lock);
+	if (!smc_clc_eid_table.ueid_cnt)
+		rc = -ENOENT;
+	else
+		smc_clc_eid_table.seid_enabled = 0;
+	write_unlock(&smc_clc_eid_table.lock);
+	return rc;
+}
+
 static bool _smc_clc_match_ueid(u8 *peer_ueid)
 {
 	struct smc_clc_eid_entry *tmp_ueid;
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 0699e0cee308..974d01d16bb5 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -347,5 +347,8 @@ int smc_nl_dump_ueid(struct sk_buff *skb, struct netlink_callback *cb);
 int smc_nl_add_ueid(struct sk_buff *skb, struct genl_info *info);
 int smc_nl_remove_ueid(struct sk_buff *skb, struct genl_info *info);
 int smc_nl_flush_ueid(struct sk_buff *skb, struct genl_info *info);
+int smc_nl_dump_seid(struct sk_buff *skb, struct netlink_callback *cb);
+int smc_nl_enable_seid(struct sk_buff *skb, struct genl_info *info);
+int smc_nl_disable_seid(struct sk_buff *skb, struct genl_info *info);
 
 #endif
diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
index 4548ff2df245..f13ab0661ed5 100644
--- a/net/smc/smc_netlink.c
+++ b/net/smc/smc_netlink.c
@@ -96,6 +96,21 @@ static const struct genl_ops smc_gen_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.doit = smc_nl_flush_ueid,
 	},
+	{
+		.cmd = SMC_NETLINK_DUMP_SEID,
+		/* can be retrieved by unprivileged users */
+		.dumpit = smc_nl_dump_seid,
+	},
+	{
+		.cmd = SMC_NETLINK_ENABLE_SEID,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_nl_enable_seid,
+	},
+	{
+		.cmd = SMC_NETLINK_DISABLE_SEID,
+		.flags = GENL_ADMIN_PERM,
+		.doit = smc_nl_disable_seid,
+	},
 };
 
 static const struct nla_policy smc_gen_nl_policy[2] = {
-- 
2.25.1

