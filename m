Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3CD690766
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjBIL2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjBIL1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:27:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25C35D1F8;
        Thu,  9 Feb 2023 03:20:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C973561A22;
        Thu,  9 Feb 2023 11:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED121C433A0;
        Thu,  9 Feb 2023 11:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941595;
        bh=iRRaVW8waMS3swKNOM/fpWoKvde37F2jbZWpvCGZsz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgQZr8sChoLkaC/Ilp+nWF+tAxR9VEq5bWDawEfuW30aX/a3X/jl0N1ZeZuNVQ8eD
         3g+hQb1xpuAuWG6UpiyUpPFUTjIrXZGxXhtpz5FnRW5TZ6fxV+uJZaRkHOUzxFuHYa
         m8RHwVLReM4nNeIduQmN42IBTSmV7hOQYFonUHOvZjGxXZfaPsTn7gEf4v0kIpBRXr
         dk+1yp+GADoXD8xtA5IJEKv7FopN9t1KhEde/AUKxgOdMQZ39TLQ4UNO+e9Vxq8OI4
         45WL4riVR2g2F0tGZqkHL1o0lxIn9t+0zK+DL3+CBL8FfcBmgcjBxxvcJMKhuSDxxW
         M3gpmy3yFRJIw==
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
Subject: [PATCH AUTOSEL 5.4 08/10] net: sched: sch: Bounds check priority
Date:   Thu,  9 Feb 2023 06:19:17 -0500
Message-Id: <20230209111921.1893095-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111921.1893095-1-sashal@kernel.org>
References: <20230209111921.1893095-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 8184c87da8bec..e635713cb41dd 100644
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

