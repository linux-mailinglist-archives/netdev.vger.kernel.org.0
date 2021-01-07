Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870692ED2EA
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbhAGOkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:40:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42430 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728119AbhAGOks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 09:40:48 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107ET59E178622;
        Thu, 7 Jan 2021 09:40:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=xOCPKU0dEnjuNr06NzWAMCukYaa5YvoGKM1Gsr3VTEA=;
 b=gNCZcDDa+2pKMD2Py1BmBCAaDOSGs0aDXNH5KcufyY3zFJZM/574d/59r4YKkLqkpTBL
 4pgS7ilniSwpKOaQhGXr5qLHkACm2JGkQNdaPKrzrsKhf6qRacGKOzxudpj4uHu7Xsd9
 U5IIC1GwjMx1qvlguw8jnyu1XwHmKpIYcaXt/ykIZ/gSBnJ/GjaMxsX2hPzdaOJI47Ji
 DRg7BdIGWiekED+SvdhdC7kdO9ZhLCRbluezgAYBDjzN7bshMDZl/nufpEQsK7E6Qa57
 dzbSzqHZgkim3yU9j6YJsSDb6B9uBrWdkuWKw1vG8G55uBPSUkkOA1TdkbK0pl27EAXQ gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x43ggdy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 09:40:06 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 107EU7wI185174;
        Thu, 7 Jan 2021 09:40:06 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x43ggdwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 09:40:05 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107Eclxh011043;
        Thu, 7 Jan 2021 14:40:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 35tgf8cxbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 14:40:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107Ee13l37290326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 14:40:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53829A405E;
        Thu,  7 Jan 2021 14:40:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2449BA4059;
        Thu,  7 Jan 2021 14:40:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jan 2021 14:40:01 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Dmitry Kozlov <xeb@mail.ru>
Subject: [PATCH net-next] ppp: clean up endianness conversions
Date:   Thu,  7 Jan 2021 15:39:56 +0100
Message-Id: <20210107143956.25549-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_06:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=938 phishscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sparse complains about some harmless endianness issues:

> drivers/net/ppp/pptp.c:281:21: warning: incorrect type in assignment (different base types)
> drivers/net/ppp/pptp.c:281:21:    expected unsigned int [usertype] ack
> drivers/net/ppp/pptp.c:281:21:    got restricted __be32
> drivers/net/ppp/pptp.c:283:23: warning: cast to restricted __be32

Here 'ack' is assigned a value in network-order, and then also the
byte-swapped value in host-order. Clean this up by doing the byte-swap
as part of the assignment.

> drivers/net/ppp/pptp.c:358:26: warning: cast from restricted __be16
> drivers/net/ppp/pptp.c:358:26: warning: incorrect type in argument 1 (different base types)
> drivers/net/ppp/pptp.c:358:26:    expected unsigned short [usertype] call_id
> drivers/net/ppp/pptp.c:358:26:    got restricted __be16 [usertype]

Here we use the wrong flavour of byte-swap. Use ntohs(), which of course
gives the same result.

Cc: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/net/ppp/pptp.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index ee5058445d06..0fe78826c8fa 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -278,10 +278,8 @@ static int pptp_rcv_core(struct sock *sk, struct sk_buff *skb)
 		header = (struct pptp_gre_header *)(skb->data);
 
 		/* ack in different place if S = 0 */
-		ack = GRE_IS_SEQ(header->gre_hd.flags) ? header->ack : header->seq;
-
-		ack = ntohl(ack);
-
+		ack = GRE_IS_SEQ(header->gre_hd.flags) ? ntohl(header->ack) :
+							 ntohl(header->seq);
 		if (ack > opt->ack_recv)
 			opt->ack_recv = ack;
 		/* also handle sequence number wrap-around  */
@@ -355,7 +353,7 @@ static int pptp_rcv(struct sk_buff *skb)
 		/* if invalid, discard this packet */
 		goto drop;
 
-	po = lookup_chan(htons(header->call_id), iph->saddr);
+	po = lookup_chan(ntohs(header->call_id), iph->saddr);
 	if (po) {
 		skb_dst_drop(skb);
 		nf_reset_ct(skb);
-- 
2.17.1

