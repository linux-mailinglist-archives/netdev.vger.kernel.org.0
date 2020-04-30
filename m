Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE8B1BFADF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgD3N41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:56:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728094AbgD3N4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:56:22 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UDai30141495;
        Thu, 30 Apr 2020 09:56:13 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30qxvqam8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 09:56:13 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UDmXpY002922;
        Thu, 30 Apr 2020 13:56:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 30mcu5aquf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 13:56:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UDu4F259179318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 13:56:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAE8B4C04A;
        Thu, 30 Apr 2020 13:56:04 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 884FA4C040;
        Thu, 30 Apr 2020 13:56:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 13:56:04 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 03/14] net/smc: introduce link group type
Date:   Thu, 30 Apr 2020 15:55:40 +0200
Message-Id: <20200430135551.26267-4-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430135551.26267-1-kgraul@linux.ibm.com>
References: <20200430135551.26267-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_08:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a type field to the link group which reflects the current link group
redundancy state.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 70399217ad6f..51366a9f4980 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -197,6 +197,14 @@ struct smc_rtoken {				/* address/key of remote RMB */
 
 struct smcd_dev;
 
+enum smc_lgr_type {				/* redundancy state of lgr */
+	SMC_LGR_NONE,			/* no active links, lgr to be deleted */
+	SMC_LGR_SINGLE,			/* 1 active RNIC on each peer */
+	SMC_LGR_SYMMETRIC,		/* 2 active RNICs on each peer */
+	SMC_LGR_ASYMMETRIC_PEER,	/* local has 2, peer 1 active RNICs */
+	SMC_LGR_ASYMMETRIC_LOCAL,	/* local has 1, peer 2 active RNICs */
+};
+
 enum smc_llc_flowtype {
 	SMC_LLC_FLOW_NONE	= 0,
 	SMC_LLC_FLOW_ADD_LINK	= 2,
@@ -246,6 +254,8 @@ struct smc_link_group {
 			DECLARE_BITMAP(rtokens_used_mask, SMC_RMBS_PER_LGR_MAX);
 						/* used rtoken elements */
 			u8			next_link_id;
+			enum smc_lgr_type	type;
+						/* redundancy state */
 			struct list_head	llc_event_q;
 						/* queue for llc events */
 			spinlock_t		llc_event_q_lock;
-- 
2.17.1

