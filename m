Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9C037721F
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 15:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhEHNcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 09:32:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhEHNcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 09:32:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 148DQc1v065614;
        Sat, 8 May 2021 13:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=NyGDGUetUFrCLm3ZQ409Z0sTueN2O1nrtLlx0iXFuzo=;
 b=rxwNfkJM1p0DZQBi0HU4kOvp/prah4/fV3TXucnAmW9MTNxb+YNGO/3lT6VxLGwXss6I
 f4VdzZBkxuV7DsT/mVtFIkWlSxtl/SHj41mnPmi3g9YndXbAeTSnehnPVJ4s21cB6PpO
 Q095JSyJqVI89QwmoPdfit4Vp5Ax+bquF0ym1vM392C/qWlHw9MZ0JT0M765qJrDUu5D
 9XGfzRCN9Ifww/ikC+5Uf8ZLevJKr2AKco7TrFrZ0E1TMm9Fx5wUDRiiVpGrwqH7ijlx
 +DORBakB+EufcH060FuZRyZEg5XKgTqAiR947XZLP76/Ij5itA/pR3nGW0E5OblpGr0f Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38djkm8eax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 May 2021 13:30:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 148DTnhd017853;
        Sat, 8 May 2021 13:30:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 38dhyjx3pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 May 2021 13:30:50 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 148DUnIH020446;
        Sat, 8 May 2021 13:30:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 38dhyjx3n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 May 2021 13:30:49 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 148DUgN0017780;
        Sat, 8 May 2021 13:30:42 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 08 May 2021 06:30:42 -0700
Date:   Sat, 8 May 2021 16:30:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: dsa: fix a crash if ->get_sset_count() fails
Message-ID: <YJaSe3RPgn7gKxZv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: 7bNA72TTi-_Bz2ZxTwcV_qOhqw5Fs_8z
X-Proofpoint-ORIG-GUID: 7bNA72TTi-_Bz2ZxTwcV_qOhqw5Fs_8z
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9978 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105080100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ds->ops->get_sset_count() fails then it "count" is a negative error
code such as -EOPNOTSUPP.  Because "i" is an unsigned int, the negative
error code is type promoted to a very high value and the loop will
corrupt memory until the system crashes.

Fix this by checking for error codes and changing the type of "i" to
just int.

Fixes: badf3ada60ab ("net: dsa: Provide CPU port statistics to master netdev")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/dsa/master.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 052a977914a6..63adbc21a735 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -147,8 +147,7 @@ static void dsa_master_get_strings(struct net_device *dev, uint32_t stringset,
 	struct dsa_switch *ds = cpu_dp->ds;
 	int port = cpu_dp->index;
 	int len = ETH_GSTRING_LEN;
-	int mcount = 0, count;
-	unsigned int i;
+	int mcount = 0, count, i;
 	uint8_t pfx[4];
 	uint8_t *ndata;
 
@@ -178,6 +177,8 @@ static void dsa_master_get_strings(struct net_device *dev, uint32_t stringset,
 		 */
 		ds->ops->get_strings(ds, port, stringset, ndata);
 		count = ds->ops->get_sset_count(ds, port, stringset);
+		if (count < 0)
+			return;
 		for (i = 0; i < count; i++) {
 			memmove(ndata + (i * len + sizeof(pfx)),
 				ndata + i * len, len - sizeof(pfx));
-- 
2.30.2

