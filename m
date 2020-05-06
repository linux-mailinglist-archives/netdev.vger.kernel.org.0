Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E0E1C6E30
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgEFKRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 06:17:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgEFKRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 06:17:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046ADvpH051418;
        Wed, 6 May 2020 10:17:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=5QsreUelOplYtAgVkG5OUeMKbLPHYUfdazV03WxYvR4=;
 b=b054CYlxS/eWWdXoEUvfzhRcZ5GbtgWiuvCE9m4sI58UCILbdQq8NHARdEgYz+vL7XbT
 7gKIcXJJ4fKDBzZ8tACZXQDDUXJValVUz60di6fiUbd6C0PIFIm1FFRf4Kskv55aud9G
 8wkSdPtLTptPKgIyHUoxJ0gLDlQV3nJzI4xbQTBDUVoq681TnAGWRFHIg4u2A50iYOm7
 bmEFDhmnnZNPMuTC0xl8gi8gbrK9c92cq6wKPQLg7qKdkI/8zabniWAOLfQNlmd2R0Wj
 /ytzh7H3niJZc1ZL/UZEpFPRZi1vM7qA9gt8iwKgu3+BMtBuFYE1G2VRyG3wHUw5A8tO Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn9bkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 10:17:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046ACbRo159004;
        Wed, 6 May 2020 10:17:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30us7m8u72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 10:17:05 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 046AH4Dh010396;
        Wed, 6 May 2020 10:17:04 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 03:17:03 -0700
Date:   Wed, 6 May 2020 13:16:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 net] net: mvpp2: cls: Prevent buffer overflow in
 mvpp2_ethtool_cls_rule_del()
Message-ID: <20200506101656.GC77004@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506101622.GB77004@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "info->fs.location" is a u32 that comes from the user via the
ethtool_set_rxnfc() function.  We need to check for invalid values to
prevent a buffer overflow.

I copy and pasted this check from the mvpp2_ethtool_cls_rule_ins()
function.

Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 8972cdd559e85..7352244c5e68b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1428,6 +1428,9 @@ int mvpp2_ethtool_cls_rule_del(struct mvpp2_port *port,
 	struct mvpp2_ethtool_fs *efs;
 	int ret;
 
+	if (info->fs.location >= MVPP2_N_RFS_ENTRIES_PER_FLOW)
+		return -EINVAL;
+
 	efs = port->rfs_rules[info->fs.location];
 	if (!efs)
 		return -EINVAL;
-- 
2.26.2

