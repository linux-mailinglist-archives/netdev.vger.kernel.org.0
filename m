Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49BB67EC27
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 18:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbjA0RLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 12:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbjA0RLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:11:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2554C18;
        Fri, 27 Jan 2023 09:10:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0490961D04;
        Fri, 27 Jan 2023 17:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AE9C433EF;
        Fri, 27 Jan 2023 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674839388;
        bh=gWUbK0c4RR1yn+JaQjbB3L0M42JkQ49jpNPbeYG/EdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CGkMbCd86HIzYSIxgC+1VgVYp54QrgxBmiEjocBcjp0sg+YSRkNmyKk13FqRwexef
         SJtzeQyp/QhZ0KuciAFJl/uap4GKzAqnZid+yxpHF+vY7zdmFABQRp8axWxLOjhQlf
         fKdZa3Phz5tkAbXH3fw7TPdM+tAZiT7C1YlSKVndjGHS7YKzDPFLNeau7OpcdCIjXY
         0AQtAHtaIwGy8fwTvA7C9nMxVar+8QbL1hXaWcIgs/ZBijm0kHH8cv8+JZO0DrBar5
         gF8CfW2EJLX3/P/R41YmQmWVuW02IbXVYEHFW1GGvqCUrxQUZLAuivKb4FZXbAzf2s
         GHoylZp3RdSdQ==
Date:   Fri, 27 Jan 2023 09:09:46 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <20230127170946.zey6xbr4sm4kvh3x@treble>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230127165236.rjcp6jm6csdta6z3@treble>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 08:52:38AM -0800, Josh Poimboeuf wrote:
> On Fri, Jan 27, 2023 at 11:37:02AM +0100, Peter Zijlstra wrote:
> > On Thu, Jan 26, 2023 at 08:43:55PM -0800, Josh Poimboeuf wrote:
> > > Here's another idea, have we considered this?  Have livepatch set
> > > TIF_NEED_RESCHED on all kthreads to force them into schedule(), and then
> > > have the scheduler call klp_try_switch_task() if TIF_PATCH_PENDING is
> > > set.
> > > 
> > > Not sure how scheduler folks would feel about that ;-)
> 
> Hmmmm, with preemption I guess the above doesn't work for kthreads
> calling cond_resched() instead of what vhost_worker() does (explicit
> need_resched/schedule).

Though I guess we could hook into cond_resched() too if we make it a
non-NOP for PREEMPT+LIVEPATCH?

-- 
Josh
