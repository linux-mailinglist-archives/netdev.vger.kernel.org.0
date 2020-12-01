Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5842CA6E5
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 16:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391572AbgLAPWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:22:34 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36076 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390132AbgLAPWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:22:33 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FBOo0165710;
        Tue, 1 Dec 2020 15:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=FrOA1XUFmPKn8mKk+UnDtvZGiAQ6NVgplGG9s+uq6wU=;
 b=RV4iVKxim1xX5+cg5G9TC04TjU2egA+AW/3svD3xDSakxXrHwW9NWePfJjou7ivxwMZQ
 zC2A7FdPXWe5gKWkL8llp0LukPL3tEyAadOcJG/nDdnZxt6FWvZ8LbHOuYMa0ehQBEb9
 iD5cBqfDKVP0wGCVQU41n+YlaJCNy0VtAn5FbnLOMXKrKZ88VosqRPbB03k8UhM3Cs2R
 DfWjs54RatvoeAaQEvbxKcNZEiCPsauPNHRhCO6cPdr7WFv9v3s7b9jVSIT2uhT+rfOi
 kdvT6vgOtVW7z3AoQftch5HBDrGRvbhxqW6n9iaxfflcTmR2VG8J06iTgUDZqv3S/6mm jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyqk2aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 15:15:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1FAP3v066373;
        Tue, 1 Dec 2020 15:15:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35404n0anr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 15:15:25 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1FFKqd023845;
        Tue, 1 Dec 2020 15:15:20 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 07:15:19 -0800
Date:   Tue, 1 Dec 2020 18:15:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Hendry <andrew.hendry@gmail.com>,
        =?utf-8?B?a2l5aW4o5bC55LquKQ==?= <kiyin@tencent.com>,
        security@kernel.org, linux-distros@vs.openwall.org,
        =?utf-8?B?aHVudGNoZW4o6ZmI6ZizKQ==?= <huntchen@tencent.com>,
        =?utf-8?B?ZGFubnl3YW5nKOeOi+Wuhyk=?= <dannywang@tencent.com>,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net v2] net/x25: prevent a couple of overflows
Message-ID: <X8ZeAKm8FnFpN//B@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ecf3321f20cc4f6dcf02b5b73105da58@dev.tdt.de>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .x25_addr[] address comes from the user and is not necessarily
NUL terminated.  This leads to a couple problems.  The first problem is
that the strlen() in x25_bind() can read beyond the end of the buffer.

The second problem is more subtle and could result in memory corruption.
The call tree is:
  x25_connect()
  --> x25_write_internal()
      --> x25_addr_aton()

The .x25_addr[] buffers are copied to the "addresses" buffer from
x25_write_internal() so it will lead to stack corruption.

Verify that the strings are NUL terminated and return -EINVAL if they
are not.

Reported-by: "kiyin(尹亮)" <kiyin@tencent.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
The first patch put a NUL terminator on the end of the string and this
patch returns an error instead.  I don't have a strong preference, which
patch to go with.

 net/x25/af_x25.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 9232cdb42ad9..d41fffb2507b 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -675,7 +675,8 @@ static int x25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	int len, i, rc = 0;
 
 	if (addr_len != sizeof(struct sockaddr_x25) ||
-	    addr->sx25_family != AF_X25) {
+	    addr->sx25_family != AF_X25 ||
+	    strnlen(addr->sx25_addr.x25_addr, X25_ADDR_LEN) == X25_ADDR_LEN) {
 		rc = -EINVAL;
 		goto out;
 	}
@@ -769,7 +770,8 @@ static int x25_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	rc = -EINVAL;
 	if (addr_len != sizeof(struct sockaddr_x25) ||
-	    addr->sx25_family != AF_X25)
+	    addr->sx25_family != AF_X25 ||
+	    strnlen(addr->sx25_addr.x25_addr, X25_ADDR_LEN) == X25_ADDR_LEN)
 		goto out;
 
 	rc = -ENETUNREACH;
-- 
2.29.2
