Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5CE69A304
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjBQAmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjBQAmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:42:06 -0500
Received: from out-29.mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281FB5383B
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 16:42:02 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676594521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7BZhouGy5/f4a60x0MUqcPVSvRlOuobJBu4MftYfrM=;
        b=n4eUE0ML7Ivjb421cBcKSOdOBTz1X8USjjl+gK3pJFTb2clGhWyBsO6ChdSlh+0iCRjYB1
        +2uyJEaR330yH8vITYPi82WA6UeNa6OgQaFJLUfrq2zmo+ITtBqMrwP4U7fiK1URgvJv3F
        b5GnfDkd1ky0QZh0aIYj/KfgK8U79HI=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 2/4] bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state
Date:   Thu, 16 Feb 2023 16:41:48 -0800
Message-Id: <20230217004150.2980689-3-martin.lau@linux.dev>
In-Reply-To: <20230217004150.2980689-1-martin.lau@linux.dev>
References: <20230217004150.2980689-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The bpf_fib_lookup() helper does not only look up the fib (ie. route)
but it also looks up the neigh. Before returning the neigh, the helper
does not check for NUD_VALID. When a neigh state (neigh->nud_state)
is in NUD_FAILED, its dmac (neigh->ha) could be all zeros. The helper
still returns SUCCESS instead of NO_NEIGH in this case. Because of the
SUCCESS return value, the bpf prog directly uses the returned dmac
and ends up filling all zero in the eth header.

This patch checks for NUD_VALID and returns NO_NEIGH if the
neigh is not valid.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2ce06a72a5ba..8daaaf76ab15 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5849,7 +5849,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
 	}
 
-	if (!neigh)
+	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
 	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
@@ -5964,7 +5964,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	 * not needed here.
 	 */
 	neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
-	if (!neigh)
+	if (!neigh || !(neigh->nud_state & NUD_VALID))
 		return BPF_FIB_LKUP_RET_NO_NEIGH;
 
 	return bpf_fib_set_fwd_params(params, neigh, dev, mtu);
-- 
2.30.2

