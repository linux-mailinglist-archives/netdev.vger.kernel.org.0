Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3616E2BA2
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjDNVUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDNVUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ECF194;
        Fri, 14 Apr 2023 14:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66C6264A4A;
        Fri, 14 Apr 2023 21:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EAEC433D2;
        Fri, 14 Apr 2023 21:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681507230;
        bh=Nt5sAYDkqVFKgXOKuvGH+lBuk6l7+Tpahfx8XzQQnSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nu67awMtPYdY1ih14Ofn1O9ZMWxIjP6jko3fZ1XP2mRJqN+3HX0qPFhKYXt9TyMJm
         b3QOxB55iFkR2l3rpftyTNBwFWFYJ6Cw0k9EIqNKUpJIXRx61zPoo5F+ub7YYlU13L
         huJV2f0QpTD13Y4ZrC2VFY+3k6Ozw/lEYEVhIycc=
Date:   Fri, 14 Apr 2023 14:20:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Yixin Shen <bobankhshen@gmail.com>, leon@kernel.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        ncardwell@google.com, netdev@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH net-next] lib/win_minmax: export symbol of
 minmax_running_min
Message-Id: <20230414142029.6da5c1bfbf1da82cd0f1c085@linux-foundation.org>
In-Reply-To: <CANn89i+k9Qn_8bpJb+Cgh_b4VYYVNArSGG3LmR+d3sxjxdxxbw@mail.gmail.com>
References: <20230413171918.GX17993@unreal>
        <20230414022736.63374-1-bobankhshen@gmail.com>
        <CANn89i+k9Qn_8bpJb+Cgh_b4VYYVNArSGG3LmR+d3sxjxdxxbw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 16:17:40 +0200 Eric Dumazet <edumazet@google.com> wrote:

> On Fri, Apr 14, 2023 at 4:27 AM Yixin Shen <bobankhshen@gmail.com> wrote:
> >
> > > Please provide in-tree kernel user for that EXPORT_SYMBOL.
> >
> > It is hard to provide such an in-tree kernel user. We are trying to
> > implement newer congestion control algorithms as dynamically loaded modules.
> > For example, Copa(NSDI'18) which is adopted by Facebook needs to maintain
> > such windowed min filters. Althought it is true that we can just
> > copy-and-paste the code inside lib/win_minmax, it it more convenient to
> > give the same status of minmax_running_min as minmax_running_max.
> > It is confusing that only minmax_running_max is exported.
> 
> This is needed by net/ipv4/tcp_bbr.c , which can be a module.
> 
> > If this patch is rejected because the changes are too significant,
> 
> Well, this path would soon be reverted by people using bots/tools to
> detect unused functions,
> or unused EXPORT symbols.
> 
> So there is no point accepting it, before you submit the CC in the
> official linux tree.

It seems pretty darn screwy that we export minmax_running_max() but not
minmax_running_min().

I'd be OK taking the patch just so we aren't pretty darn screwy.  But
it would be perfectly OK to include that one-liner within the patchset
which adds a minmax_running_min() user.

