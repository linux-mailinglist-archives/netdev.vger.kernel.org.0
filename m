Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8398C077
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfHMSVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:21:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbfHMSVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:21:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DI8l0u107450;
        Tue, 13 Aug 2019 18:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=/BtR4CALONFjuHetAAPz5NFH2tiIko4ij5f62sqtDP4=;
 b=Q2b3yORKT2AyyLxj5yx/3uw7ASw38l6k+oOZixlYw4TcrAGZX12v6ibbTbIRWhi1Bwcq
 L7Lk7daDoTrQ2i66UBRa4JmhER40R664LRiZ/SPalNmH/MD1J4zSZ5T04EZ7Dlq6x561
 LJAwH1LUX3M4oewzQJU+0rvdUG38EnncZllC3sUkiekNzFHt2d/kaF3PWwrBwJQPKO+W
 FsbqzYOU9xGgVtdSOKbZKrWnKbMRoUMuJVvZFTsy+RU3OUEa47ei4SnL0CtRfkG5k3g2
 YnV22fDrOTVPdvad8YkjzgCCjn6rc6YMuKDVgfUkbmMNBu9NFjOqgyuM1V9puPVUq/U4 Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvp83r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:21:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DICjWi189678;
        Tue, 13 Aug 2019 18:21:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2ubwcx34h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 18:21:20 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DIK4Je014761;
        Tue, 13 Aug 2019 18:21:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ubwcx34gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:21:19 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DILIMK011159;
        Tue, 13 Aug 2019 18:21:18 GMT
Received: from [10.211.54.53] (/10.211.54.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 11:21:18 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 3/5] RDS: don't use GFP_ATOMIC for sk_alloc in
 rds_create
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <14aa4df7-3b7d-157d-1e9a-9c49ff5feb3b@oracle.com>
Date:   Tue, 13 Aug 2019 11:21:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130171
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
2.22.0


