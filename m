Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A36F6D9C93
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239763AbjDFPpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjDFPpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:45:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1803A8A50
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 08:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F25564742
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 15:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E98C4339B;
        Thu,  6 Apr 2023 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680795911;
        bh=iHcP0z5sTfNE5J+vMpLJShy5TqU6kNFr78jesExyAH0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=orgNMW+gb2NDclvi0uHyLvB2Le0wDdj/J0gJqfSXwWX+SCrXQCN80PEj985HWdIyq
         5Bdc7ePqAeA1ZwouwtexT4gK1edQUNOYkh6TnoDffWLg2ILTTAn+EvqhPmQMzthNXx
         WsSF70fhvQ2ckvZFjAzD/g+ESez7mL31mFvYWuLrqlxcyfFcoAmuvr4MLBtPcM93Wt
         HeIEX4A3lGk9yzdVzIZQEvJb72ErqCrP6y93FwMaLrrmswjLkyemfJWblWhTSPS1mm
         ovNkNSViTVGdrURzENm6jPH9I+SFvfo6+YRS4r+EN8efJDCLmO9sVx61ffr933mdug
         mlM9YMdhzDfCA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 93D5815404B4; Thu,  6 Apr 2023 08:45:10 -0700 (PDT)
Date:   Thu, 6 Apr 2023 08:45:10 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <c3b05efb-e691-4947-84f9-cf524e7d2cd9@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20230401115854.371a5b4c@kernel.org>
 <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
 <20230403085601.44f04cd2@kernel.org>
 <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
 <20230403120345.0c02232c@kernel.org>
 <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
 <1e9bbdde-df97-4319-a4b7-e426c4351317@paulmck-laptop>
 <ZC5VbfkTIluwKYDn@gondor.apana.org.au>
 <dba8aec7-f236-4cb6-b53b-fabefcfa295a@paulmck-laptop>
 <20230406074648.4c26a795@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406074648.4c26a795@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 07:46:48AM -0700, Jakub Kicinski wrote:
> On Thu, 6 Apr 2023 07:17:09 -0700 Paul E. McKenney wrote:
> > > > Mightn't preemption or interrupts cause further issues?  Or are preemption
> > > > and/or interrupts disabled across the relevant sections of code?  
> > > 
> > > The code in question is supposed to run in softirq context.  So
> > > both interrupts and preemption should be disabled.  
> > 
> > Agreed, preemption will be enabled in softirq, but interrupts can still
> > happen, correct?
> 
> Starting the queue only happens from softirq (I hope) and stopping 
> can happen from any context. So we're risking false-starts again.
> I think this puts to bed any hope of making this code safe against
> false-starts with just barriers :(

Is it possible to jam all the relevant state into a single variable?
(I believe that that answer is "no", but just in case asking this question
inspires someone to come up with a good idea.)

							Thanx, Paul
