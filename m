Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A43232A44
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 05:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgG3DLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 23:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbgG3DLC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 23:11:02 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7485C22B48;
        Thu, 30 Jul 2020 03:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596078662;
        bh=H2NODBbkkSUD6I63me+UYQ1BgU7CvdVwALXoiuzsRNU=;
        h=Date:From:To:Cc:Subject:From;
        b=RbZqcquCI0GudeIh3+q9R4S1n+n3KGUJ3JSutRSSooo1brOev6qu5ddM6TxjmqW1p
         qvB3Dd6T2TkJJefiZjlQMUScNKw503BN44Onz7f0PN7WVBzVM55JuuiM700JXRlrl5
         Z9K1G4x3b0/ZdqmNrmpWJpnLjyEKiJ42iySmG6fY=
Date:   Wed, 29 Jul 2020 22:17:00 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] net/sched: act_pedit: Use flex_array_size() helper in
 memcpy()
Message-ID: <20200730031700.GA23745@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the flex_array_size() helper to calculate the size of a
flexible array member within an enclosing structure.

This helper offers defense-in-depth against potential integer
overflows, while at the same time makes it explicitly clear that
we are dealing with a flexible array member.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sched/act_pedit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 66986db062ed..c158bfed86d5 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -436,8 +436,7 @@ static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
 		return -ENOBUFS;
 
 	spin_lock_bh(&p->tcf_lock);
-	memcpy(opt->keys, p->tcfp_keys,
-	       p->tcfp_nkeys * sizeof(struct tc_pedit_key));
+	memcpy(opt->keys, p->tcfp_keys, flex_array_size(opt, keys, p->tcfp_nkeys));
 	opt->index = p->tcf_index;
 	opt->nkeys = p->tcfp_nkeys;
 	opt->flags = p->tcfp_flags;
-- 
2.27.0

