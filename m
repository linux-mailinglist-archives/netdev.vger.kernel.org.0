Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7737732480E
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhBYAuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:50:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235472AbhBYAub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 19:50:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BB064ED6;
        Thu, 25 Feb 2021 00:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614214190;
        bh=bhAqUnLOjS0NNyB/CCOfR9kSnbadoKTlZ+uYfom8UwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LmOsmvfw/3y+PdnBuapGfagyroIJSqWNG0MlJE6tu7aN4vLWWo/N9Cb8zqyOLpNTh
         V8c3xzyqrHTL1OYGDHm9mKdHxhKuXo10J99DMBzUfbefuNMUZYZnSMzo6BBDQuVDcm
         oZK7cratkfiHd0z0078VRKNYCFRVNSJ2YyPP3BYwnizDrLUzyYCDQI/jkLlIB3HqIi
         RMy1lZzdNRWytyUluU5eNl0TimSt983MkFgKxWCYgD+mToC05XEu10xLRp0R6y//FE
         A3cE/qQ8wWkKz3IQl9JJVRbll1Dlf+I8dTtUhs2CaLzBKM5d02CsivxHGZNBpOTLZC
         rI+eWbQfgnLZA==
Date:   Wed, 24 Feb 2021 16:49:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210224164946.2822585d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_Cp-Q4BRr_Ohd7ee7NchQBB37+vgBrauZQJLtGzgcqZWw@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
        <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
        <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <CAEA6p_BGgazFPRf-wMkBukwk4nzXiXoDVEwWp+Fp7A5OtuMjQA@mail.gmail.com>
        <20210224163257.7c96fb74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_Cp-Q4BRr_Ohd7ee7NchQBB37+vgBrauZQJLtGzgcqZWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 16:44:55 -0800 Wei Wang wrote:
> On Wed, Feb 24, 2021 at 4:33 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Wed, 24 Feb 2021 16:16:58 -0800 Wei Wang wrote:  
> > > On Wed, Feb 24, 2021 at 4:11 PM Alexander Duyck <alexanderduyck@fb.com> wrote:  
>  [...]  
> > >
> > > Please help hold on to the patch for now. I think Martin is still
> > > seeing issues on his setup even with this patch applied. I have not
> > > yet figured out why. But I think we should not merge this patch until
> > > the issue is cleared. Will update this thread with progress.  
> >
> > If I'm looking right __busy_poll_stop() is only called if the last
> > napi poll used to re-enable IRQs consumed full budget. You need to
> > clear your new bit in busy_poll_stop(), not in __busy_poll_stop().
> > That will fix the case when hand off back to the normal poller (sirq,
> > or thread) happens without going thru __napi_schedule().  
> 
> If the budget is not fully consumed, napi_complete_done() should have
> been called by the driver which will clear SCHED_BUSY_POLL bit.

Ah, right.
