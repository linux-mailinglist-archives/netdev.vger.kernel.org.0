Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A027110B43
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 18:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbfEAQXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 12:23:18 -0400
Received: from gateway23.websitewelcome.com ([192.185.50.250]:27373 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726101AbfEAQXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 12:23:18 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 937CF1AF66
        for <netdev@vger.kernel.org>; Wed,  1 May 2019 11:23:17 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Ls0rh07bTiQerLs0rhfpZe; Wed, 01 May 2019 11:23:17 -0500
X-Authority-Reason: nr=8
Received: from [189.250.119.203] (port=36490 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hLs0q-001tWw-5p; Wed, 01 May 2019 11:23:16 -0500
Date:   Wed, 1 May 2019 11:23:15 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] net: sched: cls_u32: use struct_size() helper
Message-ID: <20190501162315.GA27166@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.119.203
X-Source-L: No
X-Exim-ID: 1hLs0q-001tWw-5p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.119.203]:36490
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace code of the following form:

sizeof(*s) + s->nkeys*sizeof(struct tc_u32_key)

with:

struct_size(s, keys, s->nkeys)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/sched/cls_u32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 04e9ef088535..4b8710a266cc 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -847,7 +847,7 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 	/* Similarly success statistics must be moved as pointers */
 	new->pcpu_success = n->pcpu_success;
 #endif
-	memcpy(&new->sel, s, sizeof(*s) + s->nkeys*sizeof(struct tc_u32_key));
+	memcpy(&new->sel, s, struct_size(s, keys, s->nkeys));
 
 	if (tcf_exts_init(&new->exts, net, TCA_U32_ACT, TCA_U32_POLICE)) {
 		kfree(new);
-- 
2.21.0

