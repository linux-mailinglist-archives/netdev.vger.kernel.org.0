Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5A864AE21
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 04:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbiLMDUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 22:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLMDUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 22:20:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764311B7B3;
        Mon, 12 Dec 2022 19:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E55F1612CB;
        Tue, 13 Dec 2022 03:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5C5C433EF;
        Tue, 13 Dec 2022 03:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670901641;
        bh=fNJ0HmIL0o/ygNc/5g8Y2/L+rcNUzRLfm5SoXCV5ny4=;
        h=From:To:Cc:Subject:Date:From;
        b=nn8AJtTWF6VS/D+U24ClC9evCfOXHIzOwm3bhhm3vjTtFxOcdR8lzQccO3Bc+kktm
         CluQQZPXo+ud0mBk+YsLzFmUI6RrJu3CEcTkYJsnALoVqfxgb7vpxA5QgkfJidRn6S
         1U06sipvsois9LY/GLZIEWZdeZE0I0JJesEMsaZri2foyOA7ljhs6gFBKDhzwtSvNV
         xhYNGq30C0FF2xeKapXLRceBnA4WkGhfJYTFFlK/Jq1bSdZG9RalU+vJEcFNztfClc
         hxChvPuS7N5MPefEZnWzWlzOOgw2DlypEXMftdMo5YKxk2rv6V2nzSjVjgI0ioEhEf
         6S0RdlBo9h7Gg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, horms@verge.net.au,
        ja@ssi.bg, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        jwiesner@suse.de, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH net-next] ipvs: fix type warning in do_div() on 32 bit
Date:   Mon, 12 Dec 2022 19:20:37 -0800
Message-Id: <20221213032037.844517-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

32 bit platforms without 64bit div generate the following warning:

net/netfilter/ipvs/ip_vs_est.c: In function 'ip_vs_est_calc_limits':
include/asm-generic/div64.h:222:35: warning: comparison of distinct pointer types lacks a cast
  222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
      |                                   ^~
net/netfilter/ipvs/ip_vs_est.c:694:17: note: in expansion of macro 'do_div'
  694 |                 do_div(val, loops);
      |                 ^~~~~~
include/asm-generic/div64.h:222:35: warning: comparison of distinct pointer types lacks a cast
  222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
      |                                   ^~
net/netfilter/ipvs/ip_vs_est.c:700:33: note: in expansion of macro 'do_div'
  700 |                                 do_div(val, min_est);
      |                                 ^~~~~~

first argument of do_div() should be unsigned. We can't just cast
as do_div() updates it as well, so we need an lval.
Make val unsigned in the first place, all paths check that the value
they assign to this variables are non-negative already.

Fixes: 705dd3444081 ("ipvs: use kthreads for stats estimation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: horms@verge.net.au
CC: ja@ssi.bg
CC: pablo@netfilter.org
CC: kadlec@netfilter.org
CC: fw@strlen.de
CC: jwiesner@suse.de
CC: lvs-devel@vger.kernel.org
CC: netfilter-devel@vger.kernel.org
CC: coreteam@netfilter.org
---
 net/netfilter/ipvs/ip_vs_est.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index df56073bb282..ce2a1549b304 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -640,9 +640,10 @@ static int ip_vs_est_calc_limits(struct netns_ipvs *ipvs, int *chain_max)
 	int i, loops, ntest;
 	s32 min_est = 0;
 	ktime_t t1, t2;
-	s64 diff, val;
 	int max = 8;
 	int ret = 1;
+	s64 diff;
+	u64 val;
 
 	INIT_HLIST_HEAD(&chain);
 	mutex_lock(&__ip_vs_mutex);
-- 
2.38.1

