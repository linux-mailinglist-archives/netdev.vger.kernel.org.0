Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5116B1AF1A7
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 17:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgDRPbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 11:31:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50440 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgDRPby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 11:31:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03IFSGGm157503;
        Sat, 18 Apr 2020 15:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=J2kcKHBsQ/rNEwbufVTDX2JwS72Xi6HwFgB/KpwKK/U=;
 b=swvLn91XdX9ei8YYb7K9P86sIMsQiX0ZPl3k9l8bEfd2Sx7z68AVa8+0BtDE/OxK1AWt
 y4kig5YT+xCrVkC6zG/v7MI7t+c3aNOxOZmyeVLLM2iJ07V9jUAqBvJbkhHBHVcXnI1G
 tbw1hxSehD6L5kflLN3YeZ9KzujFXZKUG8R8KdzmZbDKz0j7mPE5n4ED4Ax6yK/HHok2
 LgqjMZOazTeMynIF6iYcvtrfwg85/GkueDUmGzsmot2x8vwar95iLWZ8d2K+0uERfoO+
 pRfpxmv6NKteadcP281Jt8nukK7CBL6S34+8lAFMwGn6tLlo2O3rtudbYYZrX1zIDZH7 gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30fsgkhbd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Apr 2020 15:31:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03IFRD8f062715;
        Sat, 18 Apr 2020 15:31:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 30frvm3dfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 18 Apr 2020 15:31:22 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03IFVLpb070115;
        Sat, 18 Apr 2020 15:31:21 GMT
Received: from control-surface.uk.oracle.com (dhcp-10-175-171-153.vpn.oracle.com [10.175.171.153])
        by userp3020.oracle.com with ESMTP id 30frvm3df1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 18 Apr 2020 15:31:21 +0000
Received: from control-surface.uk.oracle.com (localhost [127.0.0.1])
        by control-surface.uk.oracle.com (8.15.2/8.15.2) with ESMTPS id 03IFVIGC019972
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sat, 18 Apr 2020 16:31:18 +0100
Received: (from jch@localhost)
        by control-surface.uk.oracle.com (8.15.2/8.15.2/Submit) id 03IFVIRB019971;
        Sat, 18 Apr 2020 16:31:18 +0100
X-Authentication-Warning: control-surface.uk.oracle.com: jch set sender to john.haxby@oracle.com using -f
From:   John Haxby <john.haxby@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     John Haxby <john.haxby@oracle.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/1] ipv6: fix restrict IPV6_ADDRFORM operation
Date:   Sat, 18 Apr 2020 16:30:49 +0100
Message-Id: <2728d063cd3c34c25eec068e06a0676199a84f62.1587221721.git.john.haxby@oracle.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <cover.1587221721.git.john.haxby@oracle.com>
References: <cover.1587221721.git.john.haxby@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9595 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=959 malwarescore=0 clxscore=1011
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004180130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation") fixed a
problem found by syzbot an unfortunate logic error meant that it
also broke IPV6_ADDRFORM.

Rearrange the checks so that the earlier test is just one of the series
of checks made before moving the socket from IPv6 to IPv4.

Fixes: b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation")
Signed-off-by: John Haxby <john.haxby@oracle.com>
Cc: stable@vger.kernel.org
---
 net/ipv6/ipv6_sockglue.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index debdaeba5d8c..18d05403d3b5 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -183,15 +183,14 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 					retv = -EBUSY;
 					break;
 				}
-			} else if (sk->sk_protocol == IPPROTO_TCP) {
-				if (sk->sk_prot != &tcpv6_prot) {
-					retv = -EBUSY;
-					break;
-				}
-				break;
-			} else {
+			}
+			if (sk->sk_protocol == IPPROTO_TCP &&
+			    sk->sk_prot != &tcpv6_prot) {
+				retv = -EBUSY;
 				break;
 			}
+			if (sk->sk_protocol != IPPROTO_TCP)
+				break;
 			if (sk->sk_state != TCP_ESTABLISHED) {
 				retv = -ENOTCONN;
 				break;
-- 
2.25.3

