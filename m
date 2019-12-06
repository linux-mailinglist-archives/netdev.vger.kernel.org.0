Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC980115151
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 14:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfLFNtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 08:49:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfLFNtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 08:49:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6DiQHg186594;
        Fri, 6 Dec 2019 13:49:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=t/WR3JWAIKf0txQrPrU6Lz69CufYIFeTrvhqCTSD0iM=;
 b=GpnqiQ7el6BT5HMB1VY/a8zmKxM5N6ovy+WBf7IEARM/CU1/Zq7zlNBJ1ewzOkhgCpij
 JTzVGrMkWhEJ3DDghIlaVrsl7RroAkFf9ojKlHxHS8/nG8hlJtGcPwL5yVjOAXaq43gT
 lS1XoWe6E4EsvcYRPt1a787UrKuLDu7JzZFzSHAwQ9lA1vKHBS+RIQcHcWj0zFey1+jt
 OhTbdLpNmG46hiz7Fqf+H/vSMFVeR/j9zVmXv08N2YjeXkqIJAqnpmSAkZXrNE9SbvoS
 xsjuM1cH2gPYVdiALb0jzVX01nQyT8n388rnHNu2lJQRRwb/Q88UrmZVy2KQmrZ2FgFL sA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wkgcqv66h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 13:49:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6Dn2tq068682;
        Fri, 6 Dec 2019 13:49:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wqcbc8k3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 13:49:33 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB6DnWBP011252;
        Fri, 6 Dec 2019 13:49:33 GMT
Received: from lab02.no.oracle.com (/10.172.144.56)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Dec 2019 05:49:32 -0800
From:   =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net: netlink: Fix uninit-value in netlink_recvmsg()
Date:   Fri,  6 Dec 2019 14:49:23 +0100
Message-Id: <20191206134923.2771651-1-haakon.bugge@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=891
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9462 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=974 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb_recv_datagram() returns NULL, netlink_recvmsg() will return an
arbitrarily value.

Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
---
 net/netlink/af_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 90b2ab9dd449..bb7276f9c9f8 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1936,6 +1936,7 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		return -EOPNOTSUPP;
 
 	copied = 0;
+	err = 0;
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (skb == NULL)
-- 
2.20.1

