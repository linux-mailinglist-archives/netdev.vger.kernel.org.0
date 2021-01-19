Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21102FBB1A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391487AbhASPYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:24:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41118 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389176AbhASPYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:24:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JFEOhi132159;
        Tue, 19 Jan 2021 15:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=BuOTiRYcdWRNuN55ywy8NIJkNTkiMNPEJVra2jqLaWs=;
 b=ATBdtJS6yCI+5bEpEr+oI+BuGThINlWW7FEEiwYy4mdiSFExfU6JBRxlZrVXytf/zYSO
 Kux++EKVbB+6KqM46la53mPQiB5uYp8CnVMS0PIibfD500+95Bioi4BMSN0iT7NJ8rYd
 aMmGl51HZMKgyAFgt5ee9REbzv8tjyxiiJS0/WEgdegCfNFZ3KxWSeroapInViUDrc9r
 JwNY3yyd/OQUZSQdsmop2MhsJ1yD0V8dLdIZXaMN5pz1as/F2s0tN7tD9UoNNVqkTy8V
 qS5tGU/of4LViZfmtmvNfQJpXsY9s0DuFt4APhV2k50lHCVhLfhGdcr48g+G4sl1Vwib UA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 363nnahqv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:23:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JFGZvj120612;
        Tue, 19 Jan 2021 15:23:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3649qpce47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:23:44 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10JFNghG016525;
        Tue, 19 Jan 2021 15:23:43 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 06:53:42 -0800
Date:   Tue, 19 Jan 2021 17:53:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "; Andrew Lunn" <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: dsa: Fix off by one in dsa_loop_port_vlan_add()
Message-ID: <YAbyb5kBJQlpYCs2@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The > comparison is intended to be >= to prevent reading beyond the
end of the ps->vlans[] array.  It doesn't affect run time though because
the ps->vlans[] array has VLAN_N_VID (4096) elements and the vlan->vid
cannot be > 4094 because it is checked earlier.

Fixes: 98cd1552ea27 ("net: dsa: Mock-up driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I'm not 100% sure where this is checked but the other code has comments
and assumptions that say that it is and Smatch says that it is.  If I
had to guess, I would say that the check is in the nla policy.

[NL80211_ATTR_VLAN_ID] = NLA_POLICY_RANGE(NLA_U16, 1, VLAN_N_VID - 2),

This patch is against linux-next.  I could re-write it against net if
you want.  Another option would be to just delete the sanity check.

 drivers/net/dsa/dsa_loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 5f69216376fe..8c283f59158b 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -207,7 +207,7 @@ static int dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
 	struct mii_bus *bus = ps->bus;
 	struct dsa_loop_vlan *vl;
 
-	if (vlan->vid > ARRAY_SIZE(ps->vlans))
+	if (vlan->vid >= ARRAY_SIZE(ps->vlans))
 		return -ERANGE;
 
 	/* Just do a sleeping operation to make lockdep checks effective */
-- 
2.29.2

