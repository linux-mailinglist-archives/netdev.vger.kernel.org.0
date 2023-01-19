Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8616674436
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjASVW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjASVWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:22:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9197C4A1E2
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 13:16:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3543061D77
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A12CC433D2;
        Thu, 19 Jan 2023 21:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674162989;
        bh=3r7251pGlbjcXf1DbjeF+3XbHByF8MTutJhtYrhy9V8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e42MjFY3GCI1Eh2104VSsZpZqjiZDicWbCnMDaUGiUre15cdxK7LFjm0oKNTyReGR
         Yt2w4GBbwAt8hC0TjINEVyUXi8HFy46yze4HYyVIgYBAChynh4a0ppWjyXWsdbnxqg
         BMivN3xs5lPsQLYewc1nxZ4ee9is0yG1aW0P5Sy4qrr+umwj+apXGoscYAZKigHQug
         NLBAG6J6TVvdKb8KTMLxcgSyS4FcksIieB4SuiW4EwQQwO4LcxhqJkHtM3QK82ecbo
         Z7TYVxsMTNTngn5dTL1prTTvlhq0ak6B5qaZhxlVsH3EdImPyym0b7ofR7IPq9/dvU
         f0OZD6l5dcW/g==
Date:   Thu, 19 Jan 2023 13:16:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [PATCH net] net: sched: gred: prevent races when adding
 offloads to stats
Message-ID: <20230119131628.52cb23f9@kernel.org>
In-Reply-To: <Y8ml6VQ2L+YQqGmB@pop-os.localdomain>
References: <20230113044137.1383067-1-kuba@kernel.org>
        <Y8Ni7XYRj5/feifn@pop-os.localdomain>
        <7e0d5d6891697d24f9f9509fb8626ea9129b5eb2.camel@redhat.com>
        <20230117111019.50c47ea1@kernel.org>
        <Y8ml6VQ2L+YQqGmB@pop-os.localdomain>
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

On Thu, 19 Jan 2023 12:19:53 -0800 Cong Wang wrote:
> > > I'm unsure I read you comment correctly. Please note that the
> > > referenced message includes several splats. The first one - arguably
> > > the most relevant - points to the lack of locking in the gred control
> > > path.  
> > 
> > Yup, I'm not really sure if we're fixing the right splat for the bug.
> > But I am fairly confident we should be holding a lock while writing
> > bstats from the dump path, enqueue/dequeue may run concurrently.  
> 
> Explain htb_dump_class_stats()? :) I see two _bstats_update() calls but
> I don't see any tree lock there.

I don't know the HTB offload, if the datapath writes to the same
cl->bstats then it's buggy in the same way. But maybe it doesn't - 
the HTB offload is local (as in offloads normal host egress) while
the RED offloads are for switches so the data flows both thru the
"representor" netdevs and therefore the SW instance and the offload 
on the HW forwarding path.
