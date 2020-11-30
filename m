Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893752C81B5
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgK3KGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:06:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgK3KGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 05:06:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AU9xBhm078632;
        Mon, 30 Nov 2020 10:04:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=89d0xM4SUH4a0fX74f4jEtNnPihawrq2u89AGEQ/K1I=;
 b=v3Cb2GUa5tO1ck9uZJVgTSfz+Rqgf8BbP8CWZySuiRS1/MNhwFWwNMtwQlb6BS0HJNpX
 ZojXTgzG2Fvtwb7uvXkg9ITVM0TglIFIXygOBQ1NyY1YoVigALg05yrXDCMyvbfG0wAG
 jOqphwIZGcajIQ39bHzyLoIvcq8boyKIl3UUA/ouDVTu0y7192w5r74TANPHlVZnQ3AL
 ET1ROYKM8FjYAvM9Kg2RmmZlLLYXmibim+fYLMlBx33AVDAJ91GP4Q0XdXRqqn0pyWzA
 Cx5stsAD6qWNtAKI/54XICGwfGBrlFS817x6+GJnGSdhnNyJoM2SyqMh+rWv2pvCu3Q5 VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqc9sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 10:04:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUA1GcJ076901;
        Mon, 30 Nov 2020 10:04:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540fuucxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 10:04:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUA4b0q001002;
        Mon, 30 Nov 2020 10:04:37 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 02:04:36 -0800
Date:   Mon, 30 Nov 2020 13:04:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Hendry <andrew.hendry@gmail.com>,
        =?utf-8?B?a2l5aW4o5bC55LquKQ==?= <kiyin@tencent.com>,
        Martin Schiller <ms@dev.tdt.de>
Cc:     "security@kernel.org" <security@kernel.org>,
        "linux-distros@vs.openwall.org" <linux-distros@vs.openwall.org>,
        =?utf-8?B?aHVudGNoZW4o6ZmI6ZizKQ==?= <huntchen@tencent.com>,
        =?utf-8?B?ZGFubnl3YW5nKOeOi+Wuhyk=?= <dannywang@tencent.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net] net/x25: prevent a couple of overflows
Message-ID: <20201130100425.GB2789@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61d3e7e75f704996bf312ef5d271bcea@tencent.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "kiyin(尹亮)" <kiyin@tencent.com>

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

The x25 protocol only allows 15 character addresses so putting a NUL
terminator as the 16th character is safe and obviously preferable to
reading out of bounds.

Signed-off-by: "kiyin(尹亮)" <kiyin@tencent.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---

 net/x25/af_x25.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 0bbb283f23c9..3180f15942fe 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -686,6 +686,8 @@ static int x25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		goto out;
 	}
 
+	addr->sx25_addr.x25_addr[X25_ADDR_LEN - 1] = '\0';
+
 	/* check for the null_x25_address */
 	if (strcmp(addr->sx25_addr.x25_addr, null_x25_address.x25_addr)) {
 
@@ -779,6 +781,7 @@ static int x25_connect(struct socket *sock, struct sockaddr *uaddr,
 		goto out;
 
 	rc = -ENETUNREACH;
+	addr->sx25_addr.x25_addr[X25_ADDR_LEN - 1] = '\0';
 	rt = x25_get_route(&addr->sx25_addr);
 	if (!rt)
 		goto out;
-- 
2.28.0
