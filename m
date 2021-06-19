Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3193ADA43
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhFSN6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 09:58:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26150 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhFSN6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 09:58:21 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15JDqGr7013084;
        Sat, 19 Jun 2021 13:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=CfcMWbyIReYH5b6bYFX2Dq+/nXa57kbLDh0RJX7M4FI=;
 b=h/t/0+AHvrJygbHM3csmnsRXFym6+rd5Bx30abGd7lbWrRIzahl+trqz/Q5iIWw+w8RF
 KyoSK1FKcb3ljVs+s7rS8lmIpo8rlrgYphJllmVj/LNCMjeK7QZ4KmGBVcnAKRmfr/8E
 89dwzjyDhIiVXksmOQZcmpHvJbWmX7X7fvUi6+ou2dMrO6l9+VP0tcprBeA4l7VpDiTE
 /Ji+FivuwfmX4bLpDi3SoK/Z5wLO3qLF68tS1n+yeOoHQGTChA1tmENhhd3s6boT4k31
 HQwLmIRmbyAvY4LR3Zv7VhkmDbcat2j2jDmsVWp6wFvQkHhx07tJkvNkTuQA5w6kWPg6 hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3998f88ecj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:56:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15JDtF7M033757;
        Sat, 19 Jun 2021 13:56:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3998d2v7qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:56:01 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15JDu0R1034876;
        Sat, 19 Jun 2021 13:56:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3998d2v7q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:56:00 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15JDtucT017968;
        Sat, 19 Jun 2021 13:55:56 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Jun 2021 06:55:55 -0700
Date:   Sat, 19 Jun 2021 16:55:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] netfilter: nfnetlink_hook: fix check for snprintf()
 overflow
Message-ID: <YM33YmacZTH820Cv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: 59xZomSJ1zK34HQRUqnV_sZvjO8W55VC
X-Proofpoint-ORIG-GUID: 59xZomSJ1zK34HQRUqnV_sZvjO8W55VC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel version of snprintf() can't return negatives.  The
"ret > (int)sizeof(sym)" check is off by one because and it should be
>=.  Finally, we need to set a negative error code.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netfilter/nfnetlink_hook.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 58fda6ac663b..50b4e3c9347a 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -126,8 +126,10 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 
 #ifdef CONFIG_KALLSYMS
 	ret = snprintf(sym, sizeof(sym), "%ps", ops->hook);
-	if (ret < 0 || ret > (int)sizeof(sym))
+	if (ret >= sizeof(sym)) {
+		ret = -EINVAL;
 		goto nla_put_failure;
+	}
 
 	module_name = strstr(sym, " [");
 	if (module_name) {
-- 
2.30.2

