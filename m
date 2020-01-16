Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7B813D791
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 11:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgAPKKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 05:10:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgAPKKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 05:10:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GA8GWi195989;
        Thu, 16 Jan 2020 10:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2019-08-05; bh=A48lvgff9f3FP8xzoanAxkYJs0lSCvmWa9yCU5f4Fjs=;
 b=seDASBRYWM7MlRD52mCb7moMHJGxZrBsIsKKeBL0lQT9gHjCKeE3mc9Xsap1Dp+8D79n
 cUP+yCvKUvaywajG0Xsh8Ct1MGhokg5fF2Bxx/4HN3XD882WPti0G2l5NBvK7hB0woSx
 CcTWBdwQN5Mui/fceh9m+SjkXxk9HhOZr/7ypdFvLrtsLMhdAb+9nYxqYzLi0jP83QLJ
 rFNbl82bD7y73/R9IPju1BosXPUJPzYUaOUcjOw2jwxzxl2nHd6/F0tHB3aLjQzL/yVm
 WZjqvtil/jUNZ+lUN4OED+KZjxEnzGM+AuthovzX4GMQuoqU14L8sUIPQKNtp9Dq39Iv yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73u1gbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 10:10:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GAAJOu103796;
        Thu, 16 Jan 2020 10:10:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xj1aumcj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 10:10:29 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00GA9fgl006723;
        Thu, 16 Jan 2020 10:09:42 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 02:09:40 -0800
Date:   Thu, 16 Jan 2020 13:09:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot <syzbot+f9d4095107fc8749c69c@syzkaller.appspotmail.com>
Subject: [PATCH] netfilter: nf_tables: fix memory leak in
 nf_tables_parse_netdev_hooks()
Message-ID: <20200116100931.ot2ef4jvsw4ldye2@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000ffbba3059c3b5352@google.com>
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160086
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot detected a leak in nf_tables_parse_netdev_hooks().  If the hook
already exists, then the error handling doesn't free the newest "hook".

Reported-by: syzbot+f9d4095107fc8749c69c@syzkaller.appspotmail.com
Fixes: b75a3e8371bc ("netfilter: nf_tables: allow netdevice to be used only once per flowtable")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 273f3838318b..7728e9fd5de4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1676,6 +1676,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			goto err_hook;
 		}
 		if (nft_hook_list_find(hook_list, hook)) {
+			kfree(hook);
 			err = -EEXIST;
 			goto err_hook;
 		}
-- 
2.11.0

