Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE7F690750
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjBIL1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjBIL0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:26:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BB355E62;
        Thu,  9 Feb 2023 03:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B721D61A24;
        Thu,  9 Feb 2023 11:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BDAC4339C;
        Thu,  9 Feb 2023 11:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941554;
        bh=A+gJ2nzORJdxjwNeq+kRRbloxVVHgTfd5THuI4ZiEpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPODauugMBlJWlFpiiqpSi0m5zNVKBPN2IEU++VOBiRuClpMlMaxncujq7csSrTmT
         KHjOQg9lm7YkFP3fKZGWtFVQz+dfC0KKjhctTYjuhtKAe2IdbzWN96QAgpw4CRrTaQ
         CB7Oy7leXdSP9FpFmBDqOVpf2vhMXVRlkaQviE3yZ+tRERGUvzbw6F3ncTeQ3d8IYp
         xjK4yyA0/zMQ427cHXmt4lRdbtjDunRv/jxlEQv6NaYNanfpPJEIrO2RyCFNZN9XrP
         pNxAFrBDqOoAs2utcPVNaiPvx0SucYAA19OdpXsa20h4d9SIPJ93fnjKMfmepS6nJJ
         g2mAJJoimrMOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 10/13] net: sched: sch: Bounds check priority
Date:   Thu,  9 Feb 2023 06:18:28 -0500
Message-Id: <20230209111833.1892896-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111833.1892896-1-sashal@kernel.org>
References: <20230209111833.1892896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit de5ca4c3852f896cacac2bf259597aab5e17d9e3 ]

Nothing was explicitly bounds checking the priority index used to access
clpriop[]. WARN and bail out early if it's pathological. Seen with GCC 13:

../net/sched/sch_htb.c: In function 'htb_activate_prios':
../net/sched/sch_htb.c:437:44: warning: array subscript [0, 31] is outside array bounds of 'struct htb_prio[8]' [-Warray-bounds=]
  437 |                         if (p->inner.clprio[prio].feed.rb_node)
      |                             ~~~~~~~~~~~~~~~^~~~~~
../net/sched/sch_htb.c:131:41: note: while referencing 'clprio'
  131 |                         struct htb_prio clprio[TC_HTB_NUMPRIO];
      |                                         ^~~~~~

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20230127224036.never.561-kees@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index c3ba018fd083e..c3e773d2ca419 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -405,7 +405,10 @@ static void htb_activate_prios(struct htb_sched *q, struct htb_class *cl)
 	while (cl->cmode == HTB_MAY_BORROW && p && mask) {
 		m = mask;
 		while (m) {
-			int prio = ffz(~m);
+			unsigned int prio = ffz(~m);
+
+			if (WARN_ON_ONCE(prio > ARRAY_SIZE(p->inner.clprio)))
+				break;
 			m &= ~(1 << prio);
 
 			if (p->inner.clprio[prio].feed.rb_node)
-- 
2.39.0

