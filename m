Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAFB109DC3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 13:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfKZMTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 07:19:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46972 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbfKZMTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 07:19:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQCICW0103400;
        Tue, 26 Nov 2019 12:19:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=H5kW62GH3vPPSnBzEG0zyB0k+SIDB5HMgCv653aAMPY=;
 b=E0l4JG1iCJleF4ywLr8NRlZN4BaFWI72mYS+pjvLQxbmhtki0yd0ppXFb7TCxcg4I0cf
 wJyf0DeTGoXRYoPEgP7/uz68jO+CYDZUoQMAxdXTjTpvNbLCD3dOsjuf2zxnzYlyBhq2
 PVLWQiciHoB1RgsoTlGxoRoQTZjGLK7mbYVcpn+RciyTBA1Ts+0xcz39+duBQaKcFEJx
 s1JlpqzITQ5R1OogxygIjwGVxw32HufCuWBRLPvB9C/unpmFiNT0r4LKh+ZQketMauOU
 xZ+AdbtMJ9u4etTj18nn15Ao90uoi8117XoMrMLLA7FyRa7odcTNqIQmXIi+46X/2yke Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wewdr6b2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:19:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAQC8j9M033395;
        Tue, 26 Nov 2019 12:19:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wgvh9wfhh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 12:19:05 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAQCJ2m1020759;
        Tue, 26 Nov 2019 12:19:03 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 04:19:02 -0800
Date:   Tue, 26 Nov 2019 15:18:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: dsa: silence a static checker warning
Message-ID: <20191126121854.6omnd7upthqsrwgj@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911260110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9452 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911260110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code is harmless but it triggers a Smatch static checker warning:

    net/dsa/tag_8021q.c:108 dsa_8021q_restore_pvid()
    error: uninitialized symbol 'pvid'.

I believe that UBSan will complain at run time as well.  The solution is
to just re-order the conditions.

Fixes: c80ed84e7688 ("net: dsa: tag_8021q: Fix dsa_8021q_restore_pvid for an absent pvid")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/dsa/tag_8021q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 9e5a883a9f0c..4dd1dc27bc98 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -106,7 +106,7 @@ static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
 	slave = ds->ports[port].slave;
 
 	err = br_vlan_get_pvid(slave, &pvid);
-	if (!pvid || err < 0)
+	if (err < 0 || !pvid)
 		/* There is no pvid on the bridge for this port, which is
 		 * perfectly valid. Nothing to restore, bye-bye!
 		 */
