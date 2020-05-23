Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A9C1DF9C0
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 19:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbgEWRri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 13:47:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387515AbgEWRrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 13:47:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NHfZGI061426;
        Sat, 23 May 2020 17:47:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=+K7hQZPEXSyknr5qcG7D4mkj48QK4TpEeGTcX08C/ss=;
 b=AqD505EQz3V9MBm8s4Q2RU8YHY/vna50cBXOf1fEDcZjDRi489GMpKosyh+oAe2+AT3v
 uqhenmCnBOrdBxYRl150TOZlSUTS4mHQB30bC87q46BQeWUsmq1crivMnOwKG1zMZE1H
 khANm2GiBbYH5e30S8lXuNfAeybzMvO4rHf6g564r53qtutLCEWvlQ70iHDtcVgERyOp
 dJ/asBivQhW4D7xdQHQT2rxrkhY/gzxEWo/dUuE7QomGAPDPtyK9pirklT16LFbdXIDd
 2v2Nl7wqoAoIIO3tKTOiuDQ24IVY8R+ovkCvreLEOhAWZnTTRs54bW+QpOWLWLBlwNNd Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 316vfn16td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 17:47:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NHhKp2080621;
        Sat, 23 May 2020 17:47:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 316un1djh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 17:47:05 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04NHkx1e010453;
        Sat, 23 May 2020 17:47:00 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 23 May 2020 10:46:59 -0700
Date:   Sat, 23 May 2020 20:46:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ipv4:  potential underflow in compat_ip_setsockopt()
Message-ID: <20200523174648.GA105146@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9630 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9630 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of "n" is capped at 0x1ffffff but it checked for negative
values.  I don't think this causes a problem but I'm not certain and
it's harmless to prevent it.

Fixes: 2e04172875c9 ("ipv4: do compat setsockopt for MCAST_MSFILTER directly")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---

 net/ipv4/ip_sockglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index a2469bc57cfe..f43d5f12aa86 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1347,8 +1347,8 @@ int compat_ip_setsockopt(struct sock *sk, int level, int optname,
 	{
 		const int size0 = offsetof(struct compat_group_filter, gf_slist);
 		struct compat_group_filter *gf32;
+		unsigned int n;
 		void *p;
-		int n;
 
 		if (optlen < size0)
 			return -EINVAL;
-- 
2.26.2

