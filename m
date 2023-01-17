Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284C566E791
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 21:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjAQUQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 15:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbjAQUPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 15:15:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9C837F17
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CD3CB81995
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 19:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A42C433EF;
        Tue, 17 Jan 2023 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673982621;
        bh=L5iHG6RXE3eLyp4+i7CQSnoSsu83vaY6Mab9LCsg2cg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FdVrzSj9C4caukADD4XP3sYXVPqV7ugd4I28TDFyjSa65YBM9AL+uGoiylpgZY9tg
         uF3gOIZdxN3hL/UsK/RTzUVZtgXziy9d8Qqvchdrb8MLGW0DyEDL2QYaHes7YmEggd
         bKdeStjQD87S9vOxyEqH2nm+FP9TtVb+Suxg6kUU0wpKm/447bvim4Ya6ismCJVPr4
         Ei4S1QSE2+Eb1fwmJKTr5+K6M3VlWAnPAvhYyTsLrLKsGGlGQln1cLGU+qbTVUAijk
         HPDPrkWy7DuWUulu4wEzBGcIjp0zV/o9/OAdOgIcknf88cOrgObt5X4wczjBgNW2Xj
         qUFY9KkeFKy9g==
Date:   Tue, 17 Jan 2023 11:10:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        jhs@mojatatu.com, jiri@resnulli.us, john.hurley@netronome.com
Subject: Re: [PATCH net] net: sched: gred: prevent races when adding
 offloads to stats
Message-ID: <20230117111019.50c47ea1@kernel.org>
In-Reply-To: <7e0d5d6891697d24f9f9509fb8626ea9129b5eb2.camel@redhat.com>
References: <20230113044137.1383067-1-kuba@kernel.org>
        <Y8Ni7XYRj5/feifn@pop-os.localdomain>
        <7e0d5d6891697d24f9f9509fb8626ea9129b5eb2.camel@redhat.com>
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

On Tue, 17 Jan 2023 10:00:56 +0100 Paolo Abeni wrote:
> On Sat, 2023-01-14 at 18:20 -0800, Cong Wang wrote:
> > On Thu, Jan 12, 2023 at 08:41:37PM -0800, Jakub Kicinski wrote:  
> > > Naresh reports seeing a warning that gred is calling
> > > u64_stats_update_begin() with preemption enabled.
> > > Arnd points out it's coming from _bstats_update().  
> > 
> > The stack trace looks confusing to me without further decoding.
> > 
> > Are you sure we use sch->qstats/bstats in __dev_queue_xmit() there
> > not any netdev stats? It may be a false positive one as they may end up
> > with the same lockdep class.  

I didn't repro this myself, TBH, but there is u64_stats_update_begin() 
inside _bstats_update(). Pretty sure it will trigger the warning that
preemption is not disabled on non-SMP systems.

> I'm unsure I read you comment correctly. Please note that the
> referenced message includes several splats. The first one - arguably
> the most relevant - points to the lack of locking in the gred control
> path.

Yup, I'm not really sure if we're fixing the right splat for the bug.
But I am fairly confident we should be holding a lock while writing
bstats from the dump path, enqueue/dequeue may run concurrently.

> The posted patch LGTM, could you please re-phrase your doubts?


