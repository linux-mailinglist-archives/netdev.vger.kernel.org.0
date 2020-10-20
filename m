Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215CD29325C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389440AbgJTAcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbgJTAcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:32:14 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77C5C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:32:14 -0700 (PDT)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09K0W2s5018335;
        Tue, 20 Oct 2020 01:32:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=jan2016.eng;
 bh=mrspxpKaIj3MQZ8vKyklBN2Bf3azi2rHdAMyQlEJoqw=;
 b=jAPUMmVLaKqRJ2Q5a4sawmSNoeT3DujGl4/5oHYxnHhfKgJ0CcPxX84EMaGcY6cKpogp
 lthklU0bykZ2Ysx3VoLI+eGi+oFc/HUUjZRBqS+c8baP3dC9k3qHKuKelOhbwpBnoK5F
 4kUTtRfRU1j3vUXhI7bkvE7QVCM1Y6Ln493+GdGV4UH/ce7xfqJrLXS7bVB/NwqsPpL+
 4Mmd3doL1hnzc6pUl2K84ZBzX+oB2lyeej6dOSeNVzDCnvHyvryhs4NsdAK47e+Cs9qz
 JJUqsmQM17OBgaDhChWJ3l/4KlhYV0q1KojYdLsbbyVz8Lp9V1cR/2DwbRACDRsV7p4M eQ== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 347r91v1ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Oct 2020 01:32:07 +0100
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09K0LCdW026288;
        Mon, 19 Oct 2020 20:32:07 -0400
Received: from email.msg.corp.akamai.com ([172.27.165.112])
        by prod-mail-ppoint7.akamai.com with ESMTP id 347uxxryw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Oct 2020 20:32:07 -0400
Received: from bos-lhv87c.bos01.corp.akamai.com (172.28.41.203) by
 ustx2ex-dag1mb6.msg.corp.akamai.com (172.27.165.124) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 19 Oct 2020 19:32:06 -0500
From:   Ke Li <keli@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <kli@udel.edu>, Ke Li <keli@akamai.com>, Ji Li <jli@akamai.com>
Subject: [PATCH net] net: Properly typecast int values to set sk_max_pacing_rate
Date:   Mon, 19 Oct 2020 20:31:49 -0400
Message-ID: <20201020003149.215357-1-keli@akamai.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.28.41.203]
X-ClientProxiedBy: usma1ex-cas4.msg.corp.akamai.com (172.27.123.57) To
 ustx2ex-dag1mb6.msg.corp.akamai.com (172.27.165.124)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_13:2020-10-16,2020-10-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=958 adultscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200000
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-19_13:2020-10-16,2020-10-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 clxscore=1011 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=1 bulkscore=0 mlxlogscore=939
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200001
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.33)
 smtp.mailfrom=keli@akamai.com smtp.helo=prod-mail-ppoint7
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
 net/core/filter.c | 2 +-
 net/core/sock.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index c5e2a1c5fd8d..43f20c14864c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4693,7 +4693,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				cmpxchg(&sk->sk_pacing_status,
 					SK_PACING_NONE,
 					SK_PACING_NEEDED);
-			sk->sk_max_pacing_rate = (val == ~0U) ? ~0UL : val;
+			sk->sk_max_pacing_rate = (val == ~0U) ? ~0UL : (unsigned int)val;
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

base-commit: 0e8b8d6a2d85344d80dda5beadd98f5f86e8d3d3
-- 
2.17.1

