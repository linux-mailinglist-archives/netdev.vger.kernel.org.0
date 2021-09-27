Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4225F41A2CC
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 00:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbhI0WQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 18:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237364AbhI0WQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 18:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AAB8610A2;
        Mon, 27 Sep 2021 22:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632780890;
        bh=I6vpnDbNhhUsp54rvz1mBOT9j/vZz9K4WQuPuoIW0Gs=;
        h=Date:From:To:Cc:Subject:From;
        b=muuQ+/aAo1K+cXU1Ad0D5sMxg4AYcoyNKjkWotosE083Kh+Enxz9QlEcKd70i+Tfm
         Jbcu/FpwvPemCIL7bivkKw2DNpd4/gYKnP6rijTmNsZuXejBBBxaypU4QN3mhvFgMg
         j0S+WvEcAyP5RM37aLXFedMeCyFJamNmV9UysS36bKS+kLRnpV85lXLiW5SelEBeGX
         Etxsi+pvTs7QWSsVgVU1wH41QOWxHKs4OY7SPDFZA3LQx13EGZw64pOEU7yD6mtNSV
         XPfw2xS+OiBH3oofM92JnYVhblWm2aGMJWgoghOyWhdGbcwikOMMcHqcMAQ3KBqo16
         jC26lV6WUkPpw==
Date:   Mon, 27 Sep 2021 17:18:49 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net_sched: Use struct_size() and flex_array_size()
 helpers
Message-ID: <20210927221849.GA188050@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() and flex_array_size() helpers instead of
an open-coded version, in order to avoid any potential type mistakes
or integer overflows that, in the worse scenario, could lead to heap
overflows.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sched/sch_api.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 12f39a2dffd4..91820f67275c 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -507,7 +507,8 @@ static struct qdisc_size_table *qdisc_get_stab(struct nlattr *opt,
 	list_for_each_entry(stab, &qdisc_stab_list, list) {
 		if (memcmp(&stab->szopts, s, sizeof(*s)))
 			continue;
-		if (tsize > 0 && memcmp(stab->data, tab, tsize * sizeof(u16)))
+		if (tsize > 0 &&
+		    memcmp(stab->data, tab, flex_array_size(stab, data, tsize)))
 			continue;
 		stab->refcnt++;
 		return stab;
@@ -519,14 +520,14 @@ static struct qdisc_size_table *qdisc_get_stab(struct nlattr *opt,
 		return ERR_PTR(-EINVAL);
 	}
 
-	stab = kmalloc(sizeof(*stab) + tsize * sizeof(u16), GFP_KERNEL);
+	stab = kmalloc(struct_size(stab, data, tsize), GFP_KERNEL);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
 
 	stab->refcnt = 1;
 	stab->szopts = *s;
 	if (tsize > 0)
-		memcpy(stab->data, tab, tsize * sizeof(u16));
+		memcpy(stab->data, tab, flex_array_size(stab, data, tsize));
 
 	list_add_tail(&stab->list, &qdisc_stab_list);
 
-- 
2.27.0

