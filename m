Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65011BFAEA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgD3N4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729207AbgD3N4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:14 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDasol146144;
        Thu, 30 Apr 2020 09:56:12 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30pjmmrjk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:12 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmQ9f020272;
        Thu, 30 Apr 2020 13:56:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 30mcu7xn9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu7sG61603876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1DB04C046;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B29C4C050;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:07 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 13/14] net/smc: remove handling of CONFIRM_RKEY_CONTINUE
Date:   Thu, 30 Apr 2020 15:55:50 +0200
Message-Id: <20200430135551.26267-14-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 suspectscore=3 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new SMC-R multiple link support will support a maximum of 3 links,
and one CONFIRM_RKEY LLC message can transport 3 rkeys of an rmb buffer.
There is no need for the LLC message type CONFIRM_RKEY_CONTINUE which is
needed when more than 3 rkeys per rmb buffer needs to be exchanged.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_llc.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index e458207bde9e..92c9a8a8aaf9 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -98,12 +98,6 @@ struct smc_llc_msg_confirm_rkey {	/* type 0x06 */
 	u8 reserved;
 };
 
-struct smc_llc_msg_confirm_rkey_cont {	/* type 0x08 */
-	struct smc_llc_hdr hd;
-	u8 num_rkeys;
-	struct smc_rmb_rtoken rtoken[SMC_LLC_RKEYS_PER_MSG];
-};
-
 #define SMC_LLC_DEL_RKEY_MAX	8
 #define SMC_LLC_FLAG_RKEY_RETRY	0x10
 #define SMC_LLC_FLAG_RKEY_NEG	0x20
@@ -123,7 +117,6 @@ union smc_llc_msg {
 	struct smc_llc_msg_del_link delete_link;
 
 	struct smc_llc_msg_confirm_rkey confirm_rkey;
-	struct smc_llc_msg_confirm_rkey_cont confirm_rkey_cont;
 	struct smc_llc_msg_delete_rkey delete_rkey;
 
 	struct smc_llc_msg_test_link test_link;
@@ -628,14 +621,6 @@ static void smc_llc_rmt_delete_rkey(struct smc_link_group *lgr)
 	smc_llc_flow_qentry_del(&lgr->llc_flow_rmt);
 }
 
-static void smc_llc_rx_confirm_rkey_cont(struct smc_link *link,
-				      struct smc_llc_msg_confirm_rkey_cont *llc)
-{
-	/* ignore rtokens for other links, we have only one link */
-	llc->hd.flags |= SMC_LLC_FLAG_RESP;
-	smc_llc_send_message(link, llc);
-}
-
 /* flush the llc event queue */
 static void smc_llc_event_flush(struct smc_link_group *lgr)
 {
@@ -701,7 +686,9 @@ static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
 		}
 		return;
 	case SMC_LLC_CONFIRM_RKEY_CONT:
-		smc_llc_rx_confirm_rkey_cont(link, &llc->confirm_rkey_cont);
+		/* not used because max links is 3, and 3 rkeys fit into
+		 * one CONFIRM_RKEY message
+		 */
 		break;
 	case SMC_LLC_DELETE_RKEY:
 		/* new request from remote, assign to remote flow */
@@ -770,7 +757,7 @@ static void smc_llc_rx_response(struct smc_link *link,
 			smc_lgr_schedule_free_work_fast(link->lgr);
 		break;
 	case SMC_LLC_CONFIRM_RKEY_CONT:
-		/* unused as long as we don't send this type of msg */
+		/* not used because max links is 3 */
 		break;
 	}
 	kfree(qentry);
-- 
2.17.1

