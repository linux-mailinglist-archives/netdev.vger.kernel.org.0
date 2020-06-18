Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80501FF596
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 16:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgFROsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 10:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbgFROsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 10:48:20 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A630120888;
        Thu, 18 Jun 2020 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592491700;
        bh=QH2nfQCx3FKC23sTM/8/VxQdnmc0s8mbe5/N+FV3My0=;
        h=Date:From:To:Cc:Subject:From;
        b=vJANcm5u/EAWRFkTW3CKmd8bLGSOgSYlsEvMEUAOOotj+0w43nMxiFmeVbHSdT9Hz
         LActFnCXnl9BAS2nlG0AC3N7LALty4ADu6ECV8Oo2NZJUWjBbiBI/RCUKGCwTTwJeO
         J3hQOlzJKLmJPSJLilGQq9VxraREqgfTfVgX4+NM=
Date:   Thu, 18 Jun 2020 09:53:42 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net/sched: cls_u32: Use struct_size() in kzalloc()
Message-ID: <20200618145342.GA15946@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sched/cls_u32.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index e15ff335953d..771b068f8254 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -796,9 +796,7 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 	struct tc_u32_sel *s = &n->sel;
 	struct tc_u_knode *new;
 
-	new = kzalloc(sizeof(*n) + s->nkeys*sizeof(struct tc_u32_key),
-		      GFP_KERNEL);
-
+	new = kzalloc(struct_size(new, sel.keys, s->nkeys), GFP_KERNEL);
 	if (!new)
 		return NULL;
 
-- 
2.27.0

