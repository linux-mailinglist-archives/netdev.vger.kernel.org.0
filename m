Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6217D40A95B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhINIgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:36:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhINIgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:36:32 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18E8TMmG019980;
        Tue, 14 Sep 2021 04:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2OqGADfPgYovJGVb6YGQ1zVOzDAuC0N51xhUh3goNM4=;
 b=SoGejVUvr7mvtmU/51y/0ihPFqsLRqtFc0OQAJ1x2pLJxHHIcSmzhWov+jByRnFyqRPi
 mzNvgAjz1WIsgoyBrg6At6/I3ZTYbW3hR+ZS6aSmHriFippn2kmiygvDErLM0STM58js
 lVMLasnXzL6TH0A54Tywg6ZKa84kqpprTtpjIXk5zXUKe0LHA4xkGiZjdAW6Y32cyIjU
 KQxpx2LLHqghgBTfsRrB3kd2rmZm+PuPJBS7ac9WD0Lb6CudII02W5KNyaWuoN2EreYF
 uhMNwA+QaeFUPY730ea0qY2lGi8bBoz9CGn8E4Gm2GnVOlNNSWyw+zCoENfiIJO/aZ3I UQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2r97044b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:35:14 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18E8XPhC014061;
        Tue, 14 Sep 2021 08:35:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3b0m398v2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:35:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18E8Ue0l56230232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:30:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA328A4040;
        Tue, 14 Sep 2021 08:35:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E3D2A405E;
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
Subject: [PATCH net-next 2/3] net/smc: keep static copy of system EID
Date:   Tue, 14 Sep 2021 10:35:06 +0200
Message-Id: <20210914083507.511369-3-guvenc@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914083507.511369-1-guvenc@linux.ibm.com>
References: <20210914083507.511369-1-guvenc@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d3S5JIPK6Gw_-Ufp71A5TKXP6YfDbGt8
X-Proofpoint-GUID: d3S5JIPK6Gw_-Ufp71A5TKXP6YfDbGt8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-11_02,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 spamscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

The system EID is retrieved using an registered ISM device each time
when needed. This adds some unnecessary complexity at all places where
the system EID is needed, but no ISM device is at hand.
Simplify the code and save the system EID in a static variable in
smc_ism.c.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Guvenc Gulce  <guvenc@linux.ibm.com>
Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
---
 net/smc/af_smc.c   |  2 +-
 net/smc/smc_clc.c  |  5 +----
 net/smc/smc_core.c | 10 ++--------
 net/smc/smc_ism.c  | 16 ++++++++++++----
 net/smc/smc_ism.h  |  2 +-
 5 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e5d62acbe401..f69ef3f2019f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1565,7 +1565,7 @@ static void smc_find_ism_v2_device_serv(struct smc_sock *new_smc,
 	if (!ini->ism_dev[0])
 		goto not_found;
 
-	smc_ism_get_system_eid(ini->ism_dev[0], &eid);
+	smc_ism_get_system_eid(&eid);
 	if (!smc_clc_match_eid(ini->negotiated_eid, smc_v2_ext,
 			       smcd_v2_ext->system_eid, eid))
 		goto not_found;
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index a3d99f894f52..5a5ebf752860 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -796,10 +796,7 @@ int smc_clc_send_proposal(struct smc_sock *smc, struct smc_init_info *ini)
 				offsetofend(struct smc_clnt_opts_area_hdr,
 					    smcd_v2_ext_offset) +
 				v2_ext->hdr.eid_cnt * SMC_MAX_EID_LEN);
-		if (ini->ism_dev[0])
-			smc_ism_get_system_eid(ini->ism_dev[0], &eid);
-		else
-			smc_ism_get_system_eid(ini->ism_dev[1], &eid);
+		smc_ism_get_system_eid(&eid);
 		if (eid && v2_ext->hdr.flag.seid)
 			memcpy(smcd_v2_ext->system_eid, eid, SMC_MAX_EID_LEN);
 		plen += sizeof(*v2_ext) + sizeof(*smcd_v2_ext);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index af227b65669e..4d0fcd8f8eba 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -223,7 +223,6 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
 	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
 	char hostname[SMC_MAX_HOSTNAME_LEN + 1];
 	char smc_seid[SMC_MAX_EID_LEN + 1];
-	struct smcd_dev *smcd_dev;
 	struct nlattr *attrs;
 	u8 *seid = NULL;
 	u8 *host = NULL;
@@ -252,13 +251,8 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
 		if (nla_put_string(skb, SMC_NLA_SYS_LOCAL_HOST, hostname))
 			goto errattr;
 	}
-	mutex_lock(&smcd_dev_list.mutex);
-	smcd_dev = list_first_entry_or_null(&smcd_dev_list.list,
-					    struct smcd_dev, list);
-	if (smcd_dev)
-		smc_ism_get_system_eid(smcd_dev, &seid);
-	mutex_unlock(&smcd_dev_list.mutex);
-	if (seid && smc_ism_is_v2_capable()) {
+	if (smc_ism_is_v2_capable()) {
+		smc_ism_get_system_eid(&seid);
 		memcpy(smc_seid, seid, SMC_MAX_EID_LEN);
 		smc_seid[SMC_MAX_EID_LEN] = 0;
 		if (nla_put_string(skb, SMC_NLA_SYS_SEID, smc_seid))
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 9cb2df289963..fd28cc498b98 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -23,6 +23,7 @@ struct smcd_dev_list smcd_dev_list = {
 };
 
 static bool smc_ism_v2_capable;
+static u8 smc_ism_v2_system_eid[SMC_MAX_EID_LEN];
 
 /* Test if an ISM communication is possible - same CPC */
 int smc_ism_cantalk(u64 peer_gid, unsigned short vlan_id, struct smcd_dev *smcd)
@@ -42,9 +43,12 @@ int smc_ism_write(struct smcd_dev *smcd, const struct smc_ism_position *pos,
 	return rc < 0 ? rc : 0;
 }
 
-void smc_ism_get_system_eid(struct smcd_dev *smcd, u8 **eid)
+void smc_ism_get_system_eid(u8 **eid)
 {
-	smcd->ops->get_system_eid(smcd, eid);
+	if (!smc_ism_v2_capable)
+		*eid = NULL;
+	else
+		*eid = smc_ism_v2_system_eid;
 }
 
 u16 smc_ism_get_chid(struct smcd_dev *smcd)
@@ -435,9 +439,12 @@ int smcd_register_dev(struct smcd_dev *smcd)
 	if (list_empty(&smcd_dev_list.list)) {
 		u8 *system_eid = NULL;
 
-		smc_ism_get_system_eid(smcd, &system_eid);
-		if (system_eid[24] != '0' || system_eid[28] != '0')
+		smcd->ops->get_system_eid(smcd, &system_eid);
+		if (system_eid[24] != '0' || system_eid[28] != '0') {
 			smc_ism_v2_capable = true;
+			memcpy(smc_ism_v2_system_eid, system_eid,
+			       SMC_MAX_EID_LEN);
+		}
 	}
 	/* sort list: devices without pnetid before devices with pnetid */
 	if (smcd->pnetid[0])
@@ -533,4 +540,5 @@ EXPORT_SYMBOL_GPL(smcd_handle_irq);
 void __init smc_ism_init(void)
 {
 	smc_ism_v2_capable = false;
+	memset(smc_ism_v2_system_eid, 0, SMC_MAX_EID_LEN);
 }
diff --git a/net/smc/smc_ism.h b/net/smc/smc_ism.h
index 113efc7352ed..004b22a13ffa 100644
--- a/net/smc/smc_ism.h
+++ b/net/smc/smc_ism.h
@@ -48,7 +48,7 @@ int smc_ism_unregister_dmb(struct smcd_dev *dev, struct smc_buf_desc *dmb_desc);
 int smc_ism_write(struct smcd_dev *dev, const struct smc_ism_position *pos,
 		  void *data, size_t len);
 int smc_ism_signal_shutdown(struct smc_link_group *lgr);
-void smc_ism_get_system_eid(struct smcd_dev *dev, u8 **eid);
+void smc_ism_get_system_eid(u8 **eid);
 u16 smc_ism_get_chid(struct smcd_dev *dev);
 bool smc_ism_is_v2_capable(void);
 void smc_ism_init(void);
-- 
2.25.1

