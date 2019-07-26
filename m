Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A0C771EC
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388222AbfGZTQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:16:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63848 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387455AbfGZTQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:16:13 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6QJDOXT026331
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:16:12 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2u03nj90a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:16:12 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 26 Jul 2019 12:16:10 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id D05662543D3B7; Fri, 26 Jul 2019 12:16:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH net-next] ipv6: remove printk
Date:   Fri, 26 Jul 2019 12:16:09 -0700
Message-ID: <20190726191609.3601197-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=989 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260225
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv6_find_hdr() prints a non-rate limited error message
when it cannot find an ipv6 header at a specific offset.
This could be used as a DoS, so just remove it.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/ipv6/exthdrs_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index b358f1a4dd08..da46c4284676 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -197,10 +197,8 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 		struct ipv6hdr _ip6, *ip6;
 
 		ip6 = skb_header_pointer(skb, *offset, sizeof(_ip6), &_ip6);
-		if (!ip6 || (ip6->version != 6)) {
-			printk(KERN_ERR "IPv6 header not found\n");
+		if (!ip6 || (ip6->version != 6))
 			return -EBADMSG;
-		}
 		start = *offset + sizeof(struct ipv6hdr);
 		nexthdr = ip6->nexthdr;
 	}
-- 
2.17.1

