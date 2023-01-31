Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BC16832D9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjAaQik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAaQij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:38:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5811811648;
        Tue, 31 Jan 2023 08:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E48C3B81DAB;
        Tue, 31 Jan 2023 16:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12C9C433D2;
        Tue, 31 Jan 2023 16:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675183115;
        bh=248Wx21U7izZei4iGTQKUHGrKjUkjyIfMTBFMWa5b3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TPQ6riY0fE5L5i4o3yhzKKCRoiq5WLnTGkDT+B7POeq2f7YR1bapJ6niuu4cTJKz/
         MN6TXWa1FJxRjfx4eObVfj3+9H7lYnCs9yDI8qRLpyL+PnM+CCvuyStW21LjPyqpQj
         OFn4wRFyYBIwpUYmonYGWEiwQZdt3p75bl6Rzj41dzvJ/K8xxlGBVkbupQqclLBY6d
         rvIzpC2Rm3DP0erCk4QAOSC3jHQQ/xvCR0QgzhxjCgc2o0eEAjSeVjbME9Qb57W8dl
         MRtnrquG/V8BR+7+A3rO5/Ck3zYaZdK50drlN5LPZEKZWHZ7eU7yjQcpHITd7HpP0B
         fyIaWF4gWklpQ==
Date:   Tue, 31 Jan 2023 08:38:32 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <20230131163832.z46ihurbmjcwuvck@treble>
References: <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
 <Y9gOMCWGmoc5GQMj@FVFF77S0Q05N>
 <20230130194823.6y3rc227bvsgele4@treble>
 <Y9jr0fP7DtA9Of1L@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9jr0fP7DtA9Of1L@FVFF77S0Q05N>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 10:22:09AM +0000, Mark Rutland wrote:
> > Hm, it might be nice if our out-of-line static call implementation would
> > automatically do a static key check as part of static_call_cond() for
> > NULL-type static calls.
> > 
> > But the best answer is probably to just add inline static calls to
> > arm64.  Is the lack of objtool the only thing blocking that?
> 
> The major issues were branch range limitations (and needing the linker to add
> PLTs),

Does the compiler do the right thing (e.g., force PLT) if the branch
target is outside the translation unit?  I'm wondering if we could for
example use objtool to help enforce such rules at the call site.

> and painful instruction patching requirements (e.g. the architecture's
> "CMODX" rules for Concurrent MODification and eXecution of instructions). We
> went with the static key scheme above because that was what our assembled code
> generation would devolve to anyway.
> 
> If we knew each call-site would only call a particular function or skip the
> call, then we could do better (and would probably need something like objtool
> to NOP that out at compile time), but since we don't know the callee at build
> time we can't ensure we have a PLT in range when necessary.

Unfortunately most static calls have multiple destinations.  And most
don't have the option of being NULL.

-- 
Josh
