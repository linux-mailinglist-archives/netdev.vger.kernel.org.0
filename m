Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C031718A2AB
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 19:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgCRSyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 14:54:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43146 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgCRSyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 14:54:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IIqxQB037904;
        Wed, 18 Mar 2020 18:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=K+2+UW5AAi399IBbiBChcnI5JGEPlrbNpMAbGzARvzA=;
 b=sJ5AlBNEQdkl+8ujyX224VzsdujrBNWpW4HGxRX2/S0WYIeK64gn9wcuIoGXvx5qOvZH
 EaD0JRmPebOTjijDpVSVfeSNi2hYLR9L5nRuCUuxfcq5NWCS9sQM+shB6PqOkrwCCcxb
 YvcSpHuG/qQz845/u1OkDqNAam3SQt04p+6dOno9heqsDgi749NB3v/0nfAblvEMhHOU
 2DXGSzwSERP+P65VGelbCtzkdr5MChjNMR+h60jxw6i0wonusgwA5SWmNFPs1YM4po3U
 qdSwYIoHIBai6yUnLdz07hEvzlZYarCO4MX37YPcLKtAAOk+vtLkRIQoqhPT6eQsoUDm +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yrpprcg9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 18:53:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IIqjJk188301;
        Wed, 18 Mar 2020 18:53:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ys8tugg7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 18:53:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02IIrhYM029651;
        Wed, 18 Mar 2020 18:53:43 GMT
Received: from dhcp-10-175-176-88.vpn.oracle.com (/10.175.176.88)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 11:53:42 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org
Cc:     posk@google.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH net] selftests/net: add definition for SOL_DCCP to fix compilation errors for old libc
Date:   Wed, 18 Mar 2020 18:53:21 +0000
Message-Id: <1584557601-25202-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=3 mlxlogscore=934 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180084
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=3 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1011
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=996 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many systems build/test up-to-date kernels with older libcs, and
an older glibc (2.17) lacks the definition of SOL_DCCP in
/usr/include/bits/socket.h (it was added in the 4.6 timeframe).

Adding the definition to the test program avoids a compilation
failure that gets in the way of building tools/testing/selftests/net.
The test itself will work once the definition is added; either
skipping due to DCCP not being configured in the kernel under test
or passing, so there are no other more up-to-date glibc dependencies
here it seems beyond that missing definition.

Fixes: 11fb60d1089f ("selftests: net: reuseport_addr_any: add DCCP")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/net/reuseport_addr_any.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/reuseport_addr_any.c b/tools/testing/selftests/net/reuseport_addr_any.c
index c623393..b8475cb2 100644
--- a/tools/testing/selftests/net/reuseport_addr_any.c
+++ b/tools/testing/selftests/net/reuseport_addr_any.c
@@ -21,6 +21,10 @@
 #include <sys/socket.h>
 #include <unistd.h>
 
+#ifndef SOL_DCCP
+#define SOL_DCCP 269
+#endif
+
 static const char *IP4_ADDR = "127.0.0.1";
 static const char *IP6_ADDR = "::1";
 static const char *IP4_MAPPED6 = "::ffff:127.0.0.1";
-- 
1.8.3.1

