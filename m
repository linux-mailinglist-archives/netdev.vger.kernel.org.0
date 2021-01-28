Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A92C307507
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhA1LmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:42:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231475AbhA1Ll7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:41:59 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SBXLWx078631;
        Thu, 28 Jan 2021 06:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6C2bh9juBQyi7bCGUZHUaxrCIO1bcm/XBcU/bw8Zb+w=;
 b=fK5aZZWwK0DrseRoqCCIW42Mmh/3BHv1s1FCfVW+EBH7n9qc/Kw9wNZNUxw1qgsXWr8T
 tk+NKfBCbAsNfSqkyDOwNvayYTqDPV87m21TZO3PjnhBYjex+0MiTJE9GInSm7nRTL39
 DManA566LZxPewvGcc3q4cedFDX0VB+24eXohpx7305ZtgZXNFROht7uKTYHmro7tITL
 lmEpdNvObpUckKPWcyZuHNPq/ehU+oxA4/3tYSfE13XyQnPCh2rGJIPiBtda64QFQBEj
 0svhR5CnLLtQ6ljjoqDd0GC7HmHL7Vrn5Zc/R2hoyLyTFb0ZOxZzVfhEXNe9Av+2DBzS sA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bqkx95h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:41:17 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBc2mR023777;
        Thu, 28 Jan 2021 11:41:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 368be8crv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:41:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBfCTN33948130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:41:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9436C4C046;
        Thu, 28 Jan 2021 11:41:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 496CA4C04A;
        Thu, 28 Jan 2021 11:41:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:41:12 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/5] net/af_iucv: build SG skbs for TRANS_HIPER sockets
Date:   Thu, 28 Jan 2021 12:41:08 +0100
Message-Id: <20210128114108.39409-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210128114108.39409-1-jwi@linux.ibm.com>
References: <20210128114108.39409-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-28,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TX path no longer falls apart when some of its SG skbs are later
linearized by lower layers of the stack. So enable the use of SG skbs
in iucv_sock_sendmsg() again.

This effectively reverts
commit dc5367bcc556 ("net/af_iucv: don't use paged skbs for TX on HiperSockets").

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 0e0656db4ae7..6092d5cb7168 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -256,7 +256,9 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 			err = -EMSGSIZE;
 			goto err_free;
 		}
-		skb_trim(skb, skb->dev->mtu);
+		err = pskb_trim(skb, skb->dev->mtu);
+		if (err)
+			goto err_free;
 	}
 	skb->protocol = cpu_to_be16(ETH_P_AF_IUCV);
 
@@ -996,7 +998,7 @@ static int iucv_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (iucv->transport == AF_IUCV_TRANS_HIPER) {
 		headroom = sizeof(struct af_iucv_trans_hdr) +
 			   LL_RESERVED_SPACE(iucv->hs_dev);
-		linear = len;
+		linear = min(len, PAGE_SIZE - headroom);
 	} else {
 		if (len < PAGE_SIZE) {
 			linear = len;
-- 
2.17.1

