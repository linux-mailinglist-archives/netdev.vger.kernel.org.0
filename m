Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4235FD243
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiJMBKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiJMBKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:10:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C55AC4AE;
        Wed, 12 Oct 2022 18:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B097761684;
        Thu, 13 Oct 2022 00:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD032C433D7;
        Thu, 13 Oct 2022 00:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665621507;
        bh=fIBx0fk/i8Gefd9ZrizLeDWC35/uKkbdvMp4L+ilGNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eNs9F9rFjafI66l1WW5TTwHbmhFJfSVZnqqopbkioUXtDKPK3ZXJ5vS3L3IWP7hEg
         3mpiVdYUZhVOW1o8sirKSi/2D8i355P6m6fVomdolTfp+Flio7KfrTYPtJqpGDQUtB
         y0SIq1IsGnlPN9et7Rern9nsc3exKuFw0aqCtCtPxQF5M86EPfKdeJgu78+jctC4RH
         kViRiN6Elm0D4SWR4uRwsgsX/ufs0VoLz7wF8QlKNo8ooSjpPJy4eNXoW5d3oelkpz
         v2nNtb23iJq83ftiFPOcfb/QX7ToN8YGHxfj+llW+wIaCbm8TEY8mGrSXoP6tGT3Xc
         EjpdQTw0eq/CA==
Date:   Wed, 12 Oct 2022 17:38:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Message-ID: <20221012173825.45d6fbf2@kernel.org>
In-Reply-To: <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
References: <20210817194003.2102381-1-weiwan@google.com>
        <20221012163300.795e7b86@kernel.org>
        <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022 17:17:38 -0700 Shakeel Butt wrote:
> Did the revert of this patch fix the issue you are seeing? The reason
> I am asking is because this patch should not change the behavior.
> Actually someone else reported the similar issue for UDP RX at [1] and
> they tested the revert as well. The revert did not fix the issue for
> them.
> 
> Wei has a better explanation at [2] why this patch is not the cause
> for these issues.

We're talking TCP here, to be clear. I haven't tested a revert, yet (not
that easy to test with a real workload) but I'm relatively confident the
change did introduce an "unforced" call, specifically this bit:

@@ -2728,10 +2728,12 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
 	struct proto *prot = sk->sk_prot;
 	long allocated = sk_memory_allocated_add(sk, amt);
+	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
 	bool charged = true;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt)))
+	if (memcg_charge &&
+	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
+						gfp_memcg_charge())))

where gfp_memcg_charge() is GFP_NOWAIT in softirq.

The above gets called from (inverted stack):
 tcp_data_queue()
 tcp_try_rmem_schedule(sk, skb, skb->truesize)
 tcp_try_rmem_schedule()
 sk_rmem_schedule()
 __sk_mem_schedule()
 __sk_mem_raise_allocated()

Is my confidence unjustified? :)
