Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164422A41D2
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgKCK01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:26:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48478 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728075AbgKCKZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:25:55 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3A4COr149952;
        Tue, 3 Nov 2020 05:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=4DxaAfsgE/O4+MsSExBhv76sXVp+ABKyhcyXPUMN6mI=;
 b=G696SSMvimNfnPenAfOc2URZzT9PDFDtFy+eVinTv/H8qqnIIBoMdqRUpbYFK1FHodO/
 sFGPBJYWRjMBwlSDRkgUHejqQeuu5FEnnoCLa6P55olV2HHXoDayxnRiqlDJmIRGWOqU
 S6qDRbA/EcGyxaPGLShD5a8CFzEpdNcJltbHR5HmBcmKCp352D4PrzW61pdG9RzGNdE6
 AsLyIHCbOAoetW8HCftFehvqn6plqCymC2vc4hX1qWvCEARVNkYh/fuBQPP5IYLzQdEj
 k8M7HIHxLRh4Ti0AxQGFLUL6ctL+8yFcqqThuhwB8ZYNCfUVQcEiIqYD/Kx3hUrit0QZ cQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ju9x082g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 05:25:53 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A3AO95l020874;
        Tue, 3 Nov 2020 10:25:51 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 34h01ub1f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 10:25:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A3APmJ161997456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Nov 2020 10:25:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C091AA4054;
        Tue,  3 Nov 2020 10:25:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 897DCA405C;
        Tue,  3 Nov 2020 10:25:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  3 Nov 2020 10:25:48 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, raspl@linux.ibm.com
Subject: [PATCH net-next v2 08/15] net/smc: Add ability to work with extended SMC netlink API
Date:   Tue,  3 Nov 2020 11:25:24 +0100
Message-Id: <20201103102531.91710-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201103102531.91710-1-kgraul@linux.ibm.com>
References: <20201103102531.91710-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_07:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxlogscore=769 impostorscore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 malwarescore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030066
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

