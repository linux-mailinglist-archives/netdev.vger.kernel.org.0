Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C2767DCEB
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 05:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjA0EoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 23:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjA0EoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 23:44:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E267F3E095;
        Thu, 26 Jan 2023 20:44:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F444B81F87;
        Fri, 27 Jan 2023 04:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5F7C433EF;
        Fri, 27 Jan 2023 04:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674794637;
        bh=+cJ1DsPBTY7CESz0OY4T0y5peEivaA4nsOSxTJ5WbAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pXopEucyjzxNXM0ayhwm7Yzc53TTvNjDLzg1dGAjt3VY+8ydct8GZqAgdECdAnc11
         Md+v0wa7pHT44WB1twzVLlngxf8VmxbcZNichmq+jDTmyvR4m7+C1tomDhcqC8Lh6H
         m4QAS5E8n6vIDpYdV9pEdFvd88yY8pfMIyNGvi3I+J8cutRHdQbF3YFkDtO7AnneBP
         fuk/dwPovjDJ4Opvgs+TSfbvh2sJymHuxRCo3KA0NN9QFSRByd+QwGqRqWVqcbmq1b
         2AhEd+5AQO6LO1eNyNTJN06cW7u+zSqDvZbliJH0RegXjVg3/iXsn8Q1a4NhWWQuad
         6vsYpRxgOnO1w==
Date:   Thu, 26 Jan 2023 20:43:55 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
Cc:     Petr Mladek <pmladek@suse.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <20230127044355.frggdswx424kd5dq@treble>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9LswwnPAf+nOVFG@do-x1extreme>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 03:12:35PM -0600, Seth Forshee (DigitalOcean) wrote:
> On Thu, Jan 26, 2023 at 06:03:16PM +0100, Petr Mladek wrote:
> > On Fri 2023-01-20 16:12:20, Seth Forshee (DigitalOcean) wrote:
> > > We've fairly regularaly seen liveptches which cannot transition within kpatch's
> > > timeout period due to busy vhost worker kthreads.
> > 
> > I have missed this detail. Miroslav told me that we have solved
> > something similar some time ago, see
> > https://lore.kernel.org/all/20220507174628.2086373-1-song@kernel.org/
> 
> Interesting thread. I had thought about something along the lines of the
> original patch, but there are some ideas in there that I hadn't
> considered.

Here's another idea, have we considered this?  Have livepatch set
TIF_NEED_RESCHED on all kthreads to force them into schedule(), and then
have the scheduler call klp_try_switch_task() if TIF_PATCH_PENDING is
set.

Not sure how scheduler folks would feel about that ;-)

-- 
Josh
