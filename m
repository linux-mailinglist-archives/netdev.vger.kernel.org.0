Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25D6DA721
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239513AbjDGB5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjDGB5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA6D76A2;
        Thu,  6 Apr 2023 18:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C005064D98;
        Fri,  7 Apr 2023 01:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640BFC433EF;
        Fri,  7 Apr 2023 01:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680832623;
        bh=ZzGxI235rjV/nq6p6p1j5KBf5gZ8kyr7gt8ZhVBPgKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kqRxnSIU0JMFy+2YfxoZJExrwJo2ZsVrump0w+1MbM3vJggg6pG+UscKnGsdgxEEY
         jO+Jn4JTY1Mxi4snJxNhHHqs0+8ibJljEoAyYSWUGPB+6ZqcVb4CJEVlNfTqu5wQGd
         5RqFMpg4WtnLxU9kzVR8C5cCmqcIsaBfX7q2L8hc8NPRFptRONiSSVwsiLHLI7pEQi
         fZlwGkiOqgczuAj2WluJ7qwuH3SJbFMmd4IbEpgVYvN6EXO1tN99fcB6OanXmWfuAH
         6ts5JMtnV63xMt9GdtQaE8eNo0cDAClu2KRnK9gJZMGRov0Irqzj9BjhGyW+xLLm2p
         4THzWM82g3LAA==
Date:   Thu, 6 Apr 2023 18:57:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the
 verifier.
Message-ID: <20230406185701.066c9243@kernel.org>
In-Reply-To: <CAADnVQK8UH3Z8L9YckBXpPeeFTVFj0rn+widaEavfGDOEsiqmg@mail.gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
        <20230404145131.GB3896@maniforge>
        <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
        <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
        <20230404185147.17bf217a@kernel.org>
        <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
        <20230405111926.7930dbcc@kernel.org>
        <CAADnVQLhLuB2HG4WqQk6T=oOq2dtXkwy0TjQbnxa4cVDLHq7bg@mail.gmail.com>
        <20230406084217.44fff254@kernel.org>
        <CAADnVQLOMa=p2m++uTH1i5odXrO5mF9Y++dJZuZyL3gC3MEm0w@mail.gmail.com>
        <20230406182351.532edf53@kernel.org>
        <CAADnVQK8UH3Z8L9YckBXpPeeFTVFj0rn+widaEavfGDOEsiqmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 18:32:33 -0700 Alexei Starovoitov wrote:
> > Check if your git config is right:
> >
> > $ git config --get pw.server
> > https://patchwork.kernel.org/api/1.1/
> >
> > that's where $srv comes from  
> 
> Ahh. All works now!
> I like the new output.
> I'll play with it more.
> Should -M be a default? Any downside?

There should be no difference, AFAICT. I'm happy with making it 
the default.

There's a minor difference in the merge-message formatting between
-c and -s we could possibly remove if we make -M the default. 
Daniel uses the subject of the series as a fake branch name on the
 
  Merge branch '$branch_name'

line, while I convert the subject to a format which can be a real
branch name in git (no spaces, special chars etc) and put the subject
as the first line of the merge text.
