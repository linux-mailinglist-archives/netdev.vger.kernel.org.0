Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FA2648A88
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiLIWG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiLIWGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:06:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83399B6DBB;
        Fri,  9 Dec 2022 14:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1240A62369;
        Fri,  9 Dec 2022 22:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257ADC433D2;
        Fri,  9 Dec 2022 22:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670623551;
        bh=9QnxbRoY+pBX1dZprX1kqF0RngWjQqOSexpJVjiSliA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dqvLBb/iWlF6fD29z+elVd6K7AWA58vr+UX/x+1MGvl8cPu8U364JG6x1alMAxlB3
         +rkip2RApgFTJCUvLeBEtfEi1VWMrO+It2/ol4snzqRd9r8BMKkFMSKzjpRQFZephY
         dLq5+Slm1l7Q4cBnUjfL6kZWwsSbD39yq/pspcEYbCKSCOFG1OxLwuNHBc+lkjzmT7
         zWsMUQy80lS9+9pYgBQ20b+ZLbS5HVeBTdxTIcCileHqf09YRqu3087861bNtw3znW
         RpSuUnlD15QQ/5ydCmubCZiIM8StOdcrSWXPvUJ3v9GLfY/dD4DyB/gL9xpt62EhCq
         YIU/GuaePYFvQ==
Date:   Fri, 9 Dec 2022 14:05:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@meta.com>
Subject: Re: [PULL] Networking for v6.1 final / v6.1-rc9 (with the diff stat
 :S)
Message-ID: <20221209140550.571e6b65@kernel.org>
In-Reply-To: <20221209130001.0f90f7f8@kernel.org>
References: <20221208205639.1799257-1-kuba@kernel.org>
        <20221208210009.1799399-1-kuba@kernel.org>
        <CAHk-=wji_NB6hO+35Ruty3DjQkZ+0MkAG9RZpfXNTiWv4NZH3w@mail.gmail.com>
        <20221209130001.0f90f7f8@kernel.org>
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

On Fri, 9 Dec 2022 13:00:01 -0800 Jakub Kicinski wrote:
> On Fri, 9 Dec 2022 10:25:09 -0800 Linus Torvalds wrote:
> > > There is an outstanding regression in BPF / Peter's static calls stuff,    
> > 
> > Looks like it's not related to the static calls. Jiri says that
> > reverting that static call change makes no difference, and currently
> > suspects a RCU race instead:
> > 
> >   https://lore.kernel.org/bpf/Y5M9P95l85oMHki9@krava/T/#t
> > 
> > Hmm?  
> 
> Yes. I can't quickly grok how the static call changes impacted 
> the locking. I'll poke the BPF people to give us a sense of urgency.
> IDK how likely it is to get hold of Peter Z..

Adding Alexei et al. to the CC.
What I understood from off-list comments is the issue is not 
a showstopper and synchronize_rcu_tasks() seems like a good fix.
