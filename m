Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30102ABFA9
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732225AbgKIPS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:18:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731896AbgKIPS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:18:27 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A9F3Ele056621;
        Mon, 9 Nov 2020 10:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=4DxaAfsgE/O4+MsSExBhv76sXVp+ABKyhcyXPUMN6mI=;
 b=RBO6EQ1Fvz5bGTfhUtMrIcMBLSqsIt+sH051du6s6oi2LEqRgXGIXXNYghbmnLcrd3hf
 eTBL+eyIRFsLiQk7HN8wQc2g3ukzKTRaJoJ7yiQ5s9bbQ08C73tXjVdt9sghOnrK7g5A
 y/1jptW+W/0DG54WcCA9WoGJ8L3/iirySWo667Bc2j4UxU7gHsAlDboXpB0eTCFhFXPx
 NjuJmwFe4V2dGsewGTWsWdIhUV6wqD6KJJnSH2C+y5fhPE0L1GJJBCqD2bl2PlCUVocm
 4oBcOlhdI2Mabjird8wiiqv9Q7XCeOrnD+m88flrnilX29c3OWB1kbiwAdKlddK79h4R nA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34q74ejsn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 10:18:25 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A9FCIib002785;
        Mon, 9 Nov 2020 15:18:23 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 34q08407gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Nov 2020 15:18:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A9FIKC06161072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Nov 2020 15:18:20 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9370CA4065;
        Mon,  9 Nov 2020 15:18:20 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64D45A405C;
        Mon,  9 Nov 2020 15:18:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  9 Nov 2020 15:18:20 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v4 08/15] net/smc: Add ability to work with extended SMC netlink API
Date:   Mon,  9 Nov 2020 16:18:07 +0100
Message-Id: <20201109151814.15040-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201109151814.15040-1-kgraul@linux.ibm.com>
References: <20201109151814.15040-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-09_07:2020-11-05,2020-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 mlxlogscore=796 phishscore=0 spamscore=0
 impostorscore=0 suspectscore=1 mlxscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guvenc Gulce <guvenc@linux.ibm.com>

smc_diag module should be able to work with legacy and
extended netlink api. This is done by using the sequence field
of the netlink message header. Sequence field is optional and was
filled with a constant value MAGIC_SEQ in the current
implementation.
New constant values MAGIC_SEQ_V2 and MAGIC_SEQ_V2_ACK are used to
signal the usage of the new Netlink API between userspace and
kernel.

Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 include/uapi/linux/smc_diag.h |  7 +++++++
 net/smc/smc_diag.c            | 21 +++++++++++++--------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
index 8cb3a6fef553..236c1c52d562 100644
--- a/include/uapi/linux/smc_diag.h
+++ b/include/uapi/linux/smc_diag.h
@@ -6,6 +6,13 @@
 #include <linux/inet_diag.h>
 #include <rdma/ib_user_verbs.h>
 
+/* Sequence numbers */
+enum {
+	MAGIC_SEQ = 123456,
+	MAGIC_SEQ_V2,
+	MAGIC_SEQ_V2_ACK,
+};
+
 /* Request structure */
 struct smc_diag_req {
 	__u8	diag_family;
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 44be723c97fe..bc2b616524ff 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -293,19 +293,24 @@ static int smc_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	return skb->len;
+}
+
 static int smc_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
 {
 	struct net *net = sock_net(skb->sk);
-
+	struct netlink_dump_control c = {
+		.min_dump_alloc = SKB_WITH_OVERHEAD(32768),
+	};
 	if (h->nlmsg_type == SOCK_DIAG_BY_FAMILY &&
 	    h->nlmsg_flags & NLM_F_DUMP) {
-		{
-			struct netlink_dump_control c = {
-				.dump = smc_diag_dump,
-				.min_dump_alloc = SKB_WITH_OVERHEAD(32768),
-			};
-			return netlink_dump_start(net->diag_nlsk, skb, h, &c);
-		}
+		if (h->nlmsg_seq >= MAGIC_SEQ_V2)
+			c.dump = smc_diag_dump_ext;
+		else
+			c.dump = smc_diag_dump;
+		return netlink_dump_start(net->diag_nlsk, skb, h, &c);
 	}
 	return 0;
 }
-- 
2.17.1

