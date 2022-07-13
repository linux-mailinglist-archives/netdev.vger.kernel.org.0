Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44021572A2D
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 02:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGMANy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 20:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGMANx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 20:13:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830741F63D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 17:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA83B617AD
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02F2C3411C;
        Wed, 13 Jul 2022 00:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657671231;
        bh=BSoel1d72yeMS1sc4Ks16RlXNKUWmB/81LfyT72LXTE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rQS/tya0CRv9mUwwPdQOJ6XGupnJVrezEpwHtftQ/kiZt4PP+IlV5FbaEjC1Z4YQB
         sWjTYe3WHsInO1B2daAkU7DpAc8tgHjZm4r+byzfmJCAcJL1+KRs2HnhUQ/CqJ0GUS
         N8FWdLRfUsO9q8/PVGSz3GWe0yeqwE95dN9+fEtlFX6mWZbmwaq/dZJ7XNvhOFzfGw
         f3oWet8HrDbySrT4cWUi76+vC99OpRY43MqYB/j85yqUm2XEQ7iekC1E0IHk0Pyc7T
         rfXd+m56cC3aUYiNs4Sdjz6BB90+7fotmz9Ua195ncQmPc9IQq0RCRJiKgW9me9MFo
         I3/hwWOj9hhEQ==
Date:   Tue, 12 Jul 2022 17:13:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jiri Pirko <jiri@nvidia.com>, Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <20220712171341.29e2e91c@kernel.org>
In-Reply-To: <Ys0OvOtwVz7Aden9@nanopsycho>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
        <20220620130426.00818cbf@kernel.org>
        <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
        <20220630111327.3a951e3b@kernel.org>
        <YsbBbBt+DNvBIU2E@nanopsycho>
        <20220707131649.7302a997@kernel.org>
        <YsfcUlF9KjFEGGVW@nanopsycho>
        <20220708110535.63a2b8e9@kernel.org>
        <YskOt0sbTI5DpFUu@nanopsycho>
        <20220711102957.0b278c12@kernel.org>
        <Ys0OvOtwVz7Aden9@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 08:03:40 +0200 Jiri Pirko wrote:
> >AFAIU the problem is that you want to control endpoints which are not
> >ndevs with this API. Is that the main or only reason? Can we agree that
> >it's legitimate but will result in muddying the netdev model (which in
> >itself is good and complete)?  
> 
> I don't think this has anything to do with netdev model. 
> It is actually out of the scope of it, therefore there cannot be any mudding of it.

You should have decided that rate limiting was out of scope for netdev
before we added tc qdisc and tc police support. Now those offloads are
there, used by people and it's too late.

If you want to create a common way to rate limit functions you must
provide plumbing for the existing methods (at least tc police,
preferably legacy NDO as well) to automatically populate the new API.
