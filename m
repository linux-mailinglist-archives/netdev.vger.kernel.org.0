Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03D91C2566
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 14:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgEBMgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 08:36:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727853AbgEBMgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 08:36:18 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 042CVNcU047210;
        Sat, 2 May 2020 08:36:14 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s1su0ga5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 08:36:14 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 042CZGP6027044;
        Sat, 2 May 2020 12:36:12 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 30s0g60a8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 12:36:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 042Ca9xa65601548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 12:36:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B79DBA4054;
        Sat,  2 May 2020 12:36:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 799C4A405B;
        Sat,  2 May 2020 12:36:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  2 May 2020 12:36:09 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 04/13] net/smc: first part of add link processing as SMC server
Date:   Sat,  2 May 2020 14:35:43 +0200
Message-Id: <20200502123552.17204-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200502123552.17204-1-kgraul@linux.ibm.com>
References: <20200502123552.17204-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_06:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 suspectscore=1
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First set of functions to process an ADD_LINK LLC request as an SMC
server. Find an alternate IB device, determine the new link group type
and get the index for the new link. Then initialize the link and send
the ADD_LINK LLC message to the peer. Save the contents of the response,
ready the link, map all used buffers and register the buffers with the
IB device. If any error occurs, stop the processing and clear the link.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index d56ca60597d4..954eda708c91 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -863,6 +863,94 @@ static void smc_llc_process_cli_add_link(struct smc_link_group *lgr)
 	mutex_unlock(&lgr->llc_conf_mutex);
 }
 
+int smc_llc_srv_add_link(struct smc_link *link)
+{
+	enum smc_lgr_type lgr_new_t = SMC_LGR_SYMMETRIC;
+	struct smc_link_group *lgr = link->lgr;
+	struct smc_llc_msg_add_link *add_llc;
+	struct smc_llc_qentry *qentry = NULL;
+	struct smc_link *link_new;
+	struct smc_init_info ini;
+	int lnk_idx, rc = 0;
+
+	/* ignore client add link recommendation, start new flow */
+	ini.vlan_id = lgr->vlan_id;
+	smc_pnet_find_alt_roce(lgr, &ini, link->smcibdev);
+	if (!ini.ib_dev) {
+		lgr_new_t = SMC_LGR_ASYMMETRIC_LOCAL;
+		ini.ib_dev = link->smcibdev;
+		ini.ib_port = link->ibport;
+	}
+	lnk_idx = smc_llc_alloc_alt_link(lgr, lgr_new_t);
+	if (lnk_idx < 0)
+		return 0;
+
+	rc = smcr_link_init(lgr, &lgr->lnk[lnk_idx], lnk_idx, &ini);
+	if (rc)
+		return rc;
+	link_new = &lgr->lnk[lnk_idx];
+	rc = smc_llc_send_add_link(link,
+				   link_new->smcibdev->mac[ini.ib_port - 1],
+				   link_new->gid, link_new, SMC_LLC_REQ);
+	if (rc)
+		goto out_err;
+	/* receive ADD LINK response over the RoCE fabric */
+	qentry = smc_llc_wait(lgr, link, SMC_LLC_WAIT_TIME, SMC_LLC_ADD_LINK);
+	if (!qentry) {
+		rc = -ETIMEDOUT;
+		goto out_err;
+	}
+	add_llc = &qentry->msg.add_link;
+	if (add_llc->hd.flags & SMC_LLC_FLAG_ADD_LNK_REJ) {
+		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+		rc = -ENOLINK;
+		goto out_err;
+	}
+	if (lgr->type == SMC_LGR_SINGLE &&
+	    (!memcmp(add_llc->sender_gid, link->peer_gid, SMC_GID_SIZE) &&
+	     !memcmp(add_llc->sender_mac, link->peer_mac, ETH_ALEN))) {
+		lgr_new_t = SMC_LGR_ASYMMETRIC_PEER;
+	}
+	smc_llc_save_add_link_info(link_new, add_llc);
+	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+
+	rc = smc_ib_ready_link(link_new);
+	if (rc)
+		goto out_err;
+	rc = smcr_buf_map_lgr(link_new);
+	if (rc)
+		goto out_err;
+	rc = smcr_buf_reg_lgr(link_new);
+	if (rc)
+		goto out_err;
+	/* tbd: rc = smc_llc_srv_rkey_exchange(link, link_new); */
+	if (rc)
+		goto out_err;
+	/* tbd: rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t); */
+	if (rc)
+		goto out_err;
+	return 0;
+out_err:
+	smcr_link_clear(link_new);
+	return rc;
+}
+
+static void smc_llc_process_srv_add_link(struct smc_link_group *lgr)
+{
+	struct smc_link *link = lgr->llc_flow_lcl.qentry->link;
+	int rc;
+
+	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+
+	mutex_lock(&lgr->llc_conf_mutex);
+	rc = smc_llc_srv_add_link(link);
+	if (!rc && lgr->type == SMC_LGR_SYMMETRIC) {
+		/* delete any asymmetric link */
+		/* tbd: smc_llc_delete_asym_link(lgr); */
+	}
+	mutex_unlock(&lgr->llc_conf_mutex);
+}
+
 /* worker to process an add link message */
 static void smc_llc_add_link_work(struct work_struct *work)
 {
-- 
2.17.1

