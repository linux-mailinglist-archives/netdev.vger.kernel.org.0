Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A9129587F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 08:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504251AbgJVGmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 02:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504076AbgJVGmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 02:42:10 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E642C0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 23:42:10 -0700 (PDT)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 09M6Opn6012328;
        Thu, 22 Oct 2020 07:42:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=jan2016.eng;
 bh=Ybsx2uf4qIk1nT3y7GfRuF+1mXSpR2HhEI19YVf08fU=;
 b=anYdm1JK41zzoKpQY/V8ml3jFGyY0Ok6qIOOrm4l/8QJX1wtV5oWcsNqmsldu8E2BkgO
 Doh3Sh3cR+mBofoPgocD9CwNrO7BJhxEvMpWX1CJ3MF4+zy3ojVny0+TDKkp7ceMjYPD
 5gIil7xmTnIb0Oqyo6U+4BQw1HnJGSLvNoPz+dcvh4u/3nWV0wVrMAbccCktFuqnN10j
 8XCOFfbyPOU2Dmn/oSQxqlyHIydoz3nlERPWZ5/8E2pOCrLlQcsq16UnwPJt86Umwonw
 0wpQSEakEdZ6lz5SZfR1I4/KkFMT4WWd9n07s9RsMZ2x6jPmYm+2sz49XWq5sfxN92og aQ== 
Received: from prod-mail-ppoint8 (a72-247-45-34.deploy.static.akamaitechnologies.com [72.247.45.34] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 347s1gppea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 07:42:05 +0100
Received: from pps.filterd (prod-mail-ppoint8.akamai.com [127.0.0.1])
        by prod-mail-ppoint8.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09M6Z3oG027818;
        Thu, 22 Oct 2020 02:42:05 -0400
Received: from email.msg.corp.akamai.com ([172.27.123.30])
        by prod-mail-ppoint8.akamai.com with ESMTP id 347uxyfer7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 02:42:04 -0400
Received: from bos-lhv87c.bos01.corp.akamai.com (172.28.41.203) by
 usma1ex-dag1mb6.msg.corp.akamai.com (172.27.123.65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 22 Oct 2020 02:42:03 -0400
From:   Ke Li <keli@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kli@udel.edu>,
        Ke Li <keli@akamai.com>, Ji Li <jli@akamai.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net v2] net: Properly typecast int values to set sk_max_pacing_rate
Date:   Thu, 22 Oct 2020 02:41:46 -0400
Message-ID: <20201022064146.79873-1-keli@akamai.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.28.41.203]
X-ClientProxiedBy: USMA1EX-CAS1.msg.corp.akamai.com (172.27.123.30) To
 usma1ex-dag1mb6.msg.corp.akamai.com (172.27.123.65)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_02:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=1 mlxlogscore=928
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220042
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_02:2020-10-20,2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=898 mlxscore=0 spamscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010220042
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.34)
 smtp.mailfrom=keli@akamai.com smtp.helo=prod-mail-ppoint8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In setsockopt(SO_MAX_PACING_RATE) on 64bit systems, sk_max_pacing_rate,
after extended from 'u32' to 'unsigned long', takes unintentionally
hiked value whenever assigned from an 'int' value with MSB=1, due to
binary sign extension in promoting s32 to u64, e.g. 0x80000000 becomes
0xFFFFFFFF80000000.

Thus inflated sk_max_pacing_rate causes subsequent getsockopt to return
~0U unexpectedly. It may also result in increased pacing rate.

Fix by explicitly casting the 'int' value to 'unsigned int' before
assigning it to sk_max_pacing_rate, for zero extension to happen.

Fixes: 76a9ebe811fb ("net: extend sk_pacing_rate to unsigned long")
Signed-off-by: Ji Li <jli@akamai.com>
Signed-off-by: Ke Li <keli@akamai.com>
Cc: Eric Dumazet <edumazet@google.com>
---
v2: wrap the line in net/core/filter.c to less than 80 chars.

 net/core/filter.c | 3 ++-
 net/core/sock.c   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index c5e2a1c5fd8d..9370cd917fb9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4693,7 +4693,8 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				cmpxchg(&sk->sk_pacing_status,
 					SK_PACING_NONE,
 					SK_PACING_NEEDED);
-			sk->sk_max_pacing_rate = (val == ~0U) ? ~0UL : val;
+			sk->sk_max_pacing_rate = (val == ~0U) ?
+						 ~0UL : (unsigned int)val;
 			sk->sk_pacing_rate = min(sk->sk_pacing_rate,
 						 sk->sk_max_pacing_rate);
 			break;
diff --git a/net/core/sock.c b/net/core/sock.c
index 4e8729357122..727ea1cc633c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1163,7 +1163,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 
 	case SO_MAX_PACING_RATE:
 		{
-		unsigned long ulval = (val == ~0U) ? ~0UL : val;
+		unsigned long ulval = (val == ~0U) ? ~0UL : (unsigned int)val;
 
 		if (sizeof(ulval) != sizeof(val) &&
 		    optlen >= sizeof(ulval) &&

base-commit: 287d35405989cfe0090e3059f7788dc531879a8d
-- 
2.17.1

