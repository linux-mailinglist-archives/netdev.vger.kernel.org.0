Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C171D563E35
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 06:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbiGBEO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 00:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiGBEO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 00:14:27 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EFC35878;
        Fri,  1 Jul 2022 21:14:26 -0700 (PDT)
Date:   Fri, 1 Jul 2022 21:14:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656735264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=86pSrNFDNIvdsNXyylnmCBolwNgnWJdDU5gGiJPFH88=;
        b=qBUf1b2e3UhLARinoyYs2raGhI0dqQSKMM6pryMjBTjEUMYZn2KY/qPEGGAlJawz/usX1+
        FxEBtKYYE8/O3lXQTgh61HQMhvLa3r3GlhgO9XSEELIg/oCFQEPZ3+t36CwuKh4ar3yYOC
        BEvF+NnGXiWF9808cWUO5k9tQkm9SAU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/4] bpf: Make non-preallocated allocation low
 priority
Message-ID: <Yr/GGj+yCD8dZJbp@castle>
References: <20220629154832.56986-1-laoar.shao@gmail.com>
 <20220629154832.56986-2-laoar.shao@gmail.com>
 <ede2c8ea-693d-fe70-12a2-bf8ccca97eb0@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ede2c8ea-693d-fe70-12a2-bf8ccca97eb0@iogearbox.net>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 11:47:00PM +0200, Daniel Borkmann wrote:
> Hi Yafang,
> 
> On 6/29/22 5:48 PM, Yafang Shao wrote:
> > GFP_ATOMIC doesn't cooperate well with memcg pressure so far, especially
> > if we allocate too much GFP_ATOMIC memory. For example, when we set the
> > memcg limit to limit a non-preallocated bpf memory, the GFP_ATOMIC can
> > easily break the memcg limit by force charge. So it is very dangerous to
> > use GFP_ATOMIC in non-preallocated case. One way to make it safe is to
> > remove __GFP_HIGH from GFP_ATOMIC, IOW, use (__GFP_ATOMIC |
> > __GFP_KSWAPD_RECLAIM) instead, then it will be limited if we allocate
> > too much memory.
> > 
> > We introduced BPF_F_NO_PREALLOC is because full map pre-allocation is
> > too memory expensive for some cases. That means removing __GFP_HIGH
> > doesn't break the rule of BPF_F_NO_PREALLOC, but has the same goal with
> > it-avoiding issues caused by too much memory. So let's remove it.
> > 
> > __GFP_KSWAPD_RECLAIM doesn't cooperate well with memcg pressure neither
> > currently. But the memcg code can be improved to make
> > __GFP_KSWAPD_RECLAIM work well under memcg pressure.
> 
> Ok, but could you also explain in commit desc why it's a specific problem
> to BPF hashtab?
> 
> Afaik, there is plenty of other code using GFP_ATOMIC | __GFP_NOWARN outside
> of BPF e.g. under net/, so it's a generic memcg problem?

I'd be careful here and not change it all together.

__GFP_NOWARN might be used to suppress warnings which otherwise would be too
verbose and disruptive (especially if we talk about /net allocations in
conjunction with netconsole) and might not mean a low/lower priority.

> Why are lpm trie and local storage map for BPF not affected (at least I don't
> see them covered in the patch)?

Yes, it would be nice to fix this consistently over the bpf code.
Yafang, would you mind to fix it too?

Thanks!

Roman
