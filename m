Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FA38EE7E
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731950AbfHOOmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:42:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41890 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729838AbfHOOmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:42:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEVZld117883;
        Thu, 15 Aug 2019 14:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wvi3w8wMmoMmInDDg0H/0r2Cykpu1RjZFZEfBbBEMF4=;
 b=UFl8GqtMcqCPNbfCKIezqnJXoPQSbXU4W3M5f+CQSLTU8HxLSkFO1FFOW+J41m3mYXBs
 TaqR8sllJwP5b/3Jum6Pbf7rnafM3HwnVYcbL6ceI20yQfPRNJJ3k1ZSYIVpH95++nol
 OsyYElx6z8YnGrSUBUyRKlITi3jICrbIyyEV4gbsi4Gg5YWYtBdKUMacy52iTHX6Twhu
 scEAHSDZ6CwQHNkgQESkLhCJHU1X5uDsfAcdcBRvX0711ggsARxbg+CBXtg22PsyZiwF
 RZrIxQ0s8XxpBs92kD4FQSTUy25r6aRp521bu3XD+s1qJBRYkI1BPLGcIcNXP9hB5fz8 Yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u9nvpk7nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:42:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEWrg5044684;
        Thu, 15 Aug 2019 14:42:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2ucs881cjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 14:42:16 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FEeRMW062176;
        Thu, 15 Aug 2019 14:42:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ucs881cja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:42:15 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7FEgEla026959;
        Thu, 15 Aug 2019 14:42:14 GMT
Received: from [10.159.252.166] (/10.159.252.166)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 07:42:13 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next v2 2/4] RDS: don't use GFP_ATOMIC for sk_alloc in
 rds_create
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
 <cover.1565879451.git.gerd.rausch@oracle.com>
Message-ID: <31c65073-0a9a-28b5-eb73-4ec784b0393e@oracle.com>
Date:   Thu, 15 Aug 2019 07:42:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1565879451.git.gerd.rausch@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mason <chris.mason@oracle.com>
Date: Fri, 3 Feb 2012 11:08:51 -0500

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Bang Nguyen <bang.nguyen@oracle.com>
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
---
 net/rds/af_rds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 2b969f99ef13..7228892046cf 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -705,7 +705,7 @@ static int rds_create(struct net *net, struct socket *sock, int protocol,
 	if (sock->type != SOCK_SEQPACKET || protocol)
 		return -ESOCKTNOSUPPORT;
 
-	sk = sk_alloc(net, AF_RDS, GFP_ATOMIC, &rds_proto, kern);
+	sk = sk_alloc(net, AF_RDS, GFP_KERNEL, &rds_proto, kern);
 	if (!sk)
 		return -ENOMEM;
 
-- 
2.22.1


