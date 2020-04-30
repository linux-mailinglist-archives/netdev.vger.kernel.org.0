Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89591BFB01
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgD3N5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:57:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728620AbgD3N4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:11 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDam7C065265;
        Thu, 30 Apr 2020 09:56:10 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mhqaw0db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:10 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmUrc031754;
        Thu, 30 Apr 2020 13:56:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu72qe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDsujh66257166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:54:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18E514C04E;
        Thu, 30 Apr 2020 13:56:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5CA84C050;
        Thu, 30 Apr 2020 13:56:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:04 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 04/14] net/smc: add logic to evaluate CONFIRM_LINK messages to LLC layer
Date:   Thu, 30 Apr 2020 15:55:41 +0200
Message-Id: <20200430135551.26267-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 adultscore=0 suspectscore=1
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce smc_llc_eval_conf_link() to evaluate the CONFIRM_LINK message
contents. This implements this logic at the LLC layer. The function will
be used by af_smc.c to process the received LLC layer messages.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 11 +++++++++++
 net/smc/smc_llc.h |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index a146b3b43580..9248b90fe37e 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -946,6 +946,17 @@ int smc_llc_do_delete_rkey(struct smc_link *link,
 	return rc;
 }
 
+/* evaluate confirm link request or response */
+int smc_llc_eval_conf_link(struct smc_llc_qentry *qentry,
+			   enum smc_llc_reqresp type)
+{
+	if (type == SMC_LLC_REQ)	/* SMC server assigns link_id */
+		qentry->link->link_id = qentry->msg.confirm_link.link_num;
+	if (!(qentry->msg.raw.hdr.flags & SMC_LLC_FLAG_NO_RMBE_EYEC))
+		return -ENOTSUPP;
+	return 0;
+}
+
 /***************************** init, exit, misc ******************************/
 
 static struct smc_wr_rx_handler smc_llc_rx_handlers[] = {
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index 49e99ff00ee7..637acf91ffb7 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -66,6 +66,8 @@ int smc_llc_do_delete_rkey(struct smc_link *link,
 int smc_llc_flow_initiate(struct smc_link_group *lgr,
 			  enum smc_llc_flowtype type);
 void smc_llc_flow_stop(struct smc_link_group *lgr, struct smc_llc_flow *flow);
+int smc_llc_eval_conf_link(struct smc_llc_qentry *qentry,
+			   enum smc_llc_reqresp type);
 struct smc_llc_qentry *smc_llc_wait(struct smc_link_group *lgr,
 				    struct smc_link *lnk,
 				    int time_out, u8 exp_msg);
-- 
2.17.1

