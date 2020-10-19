Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FCF292CC1
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgJSR2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:28:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42940 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgJSR2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 13:28:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JHMg8W017795;
        Mon, 19 Oct 2020 17:27:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=pGnY5GYUyhri6gQa1/cFHNQMG5DjWL8tkM5jJLXjTbk=;
 b=iAi5v4D6o78VpgY8atDp5PnvtydOhQUBP7J/afP/cqsDYGPfSz4/xyNErxj9QBI2zunW
 0gEPOdcpyo/bKaTYmhVLTgKTpk3bZATwuMJrwfRf77mSy9xvhb6ZhWnVpWIyVhWYvCes
 677S8Jp9EHwzCHR9xXxluIL1F93t2fC0fHxbkvKEfVOBI38O/5buzdRoJdKJlCk8xTsj
 DSlQ8+7Np6SfR26a8MBmgw/yo49M78YGjRRuKim9qUr6NkZXFDv2FaX2olNIXPuudOnR
 iPnZXd8z0hAAvRBWGsXMfiioS2SY+9DnGCXPfS1x3biCzlMo7YCOcx/SqgEU1dt9JknV +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4apwuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 17:27:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JHOqF9023649;
        Mon, 19 Oct 2020 17:25:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 348ahv7852-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 17:25:56 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09JHPtxa026342;
        Mon, 19 Oct 2020 17:25:55 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by userp3030.oracle.com with ESMTP id 348ahv784h-1;
        Mon, 19 Oct 2020 17:25:55 +0000
From:   saeed.mirzamohammadi@oracle.com
To:     linux-kernel@vger.kernel.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH linux-5.9 1/1] net: netfilter: fix KASAN: slab-out-of-bounds Read in nft_flow_rule_create
Date:   Mon, 19 Oct 2020 10:25:32 -0700
Message-Id: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>

This patch fixes the issue due to:

BUG: KASAN: slab-out-of-bounds in nft_flow_rule_create+0x622/0x6a2
net/netfilter/nf_tables_offload.c:40
Read of size 8 at addr ffff888103910b58 by task syz-executor227/16244

The error happens when expr->ops is accessed early on before performing the boundary check and after nft_expr_next() moves the expr to go out-of-bounds.

This patch checks the boundary condition before expr->ops that fixes the slab-out-of-bounds Read issue.

Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 net/netfilter/nf_tables_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9ef37c1b7b3b..1273e3c0d4b8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -37,7 +37,7 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 	struct nft_expr *expr;
 
 	expr = nft_expr_first(rule);
-	while (expr->ops && expr != nft_expr_last(rule)) {
+	while (expr != nft_expr_last(rule) && expr->ops) {
 		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
 			num_actions++;
 
@@ -61,7 +61,7 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 	ctx->net = net;
 	ctx->dep.type = NFT_OFFLOAD_DEP_UNSPEC;
 
-	while (expr->ops && expr != nft_expr_last(rule)) {
+	while (expr != nft_expr_last(rule) && expr->ops) {
 		if (!expr->ops->offload) {
 			err = -EOPNOTSUPP;
 			goto err_out;
-- 
2.27.0

