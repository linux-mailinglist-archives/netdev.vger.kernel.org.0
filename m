Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5889D2D9FD6
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441037AbgLNTDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441011AbgLNTCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 14:02:46 -0500
Date:   Mon, 14 Dec 2020 11:02:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607972525;
        bh=zIT+RfkMaTLVfc0tAIyPbugltMRzxeNIAeprhgXt9Rg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=sGotVaSd6bvGd7GebHK1/aYCOykYkLhZZNDTV2IOZGVphZQczVhupdeVflEXZFuLy
         UD7NhFIj0wSmcqHpZzXlAFo/uFfAL/+4OZ18YpCaprE6QQpEMBzsze5sptkYk169qV
         sw4XhS7Df7fIulClMYRrz1Hl78hfGzCuGMcwArN3VRcwtz/Z0ZFWuKCjUc13W5Fyyw
         +qDRd5xqhSo1TxWsVl6z+L9pDOgK+VJgOo7AOtrMXR5e1kzkoAigp+UaND0aVXt7hx
         tjsRVKZQHt7lbsioAdMc8PePTH8IKVRWPobPH7f6ssrG4L2+50iv3XqucDlqGcfaFK
         mybMqpt9K8ztg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH net-next v4 2/3] net: implement threaded-able napi poll
 loop support
Message-ID: <20201214110203.7a1e8729@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_BM_H=2bhYBtJ3LtBT0DBPBeVLyuC=BRQv=H3Ww2eecWA@mail.gmail.com>
References: <20201209005444.1949356-1-weiwan@google.com>
        <20201209005444.1949356-3-weiwan@google.com>
        <20201212145022.6f2698d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201212145503.285a8bfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_BM_H=2bhYBtJ3LtBT0DBPBeVLyuC=BRQv=H3Ww2eecWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 09:59:21 -0800 Wei Wang wrote:
> On Sat, Dec 12, 2020 at 2:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sat, 12 Dec 2020 14:50:22 -0800 Jakub Kicinski wrote:  
> > > > @@ -6731,6 +6790,7 @@ void napi_disable(struct napi_struct *n)
> > > >             msleep(1);
> > > >
> > > >     hrtimer_cancel(&n->timer);
> > > > +   napi_kthread_stop(n);  
> > >
> > > I'm surprised that we stop the thread on napi_disable() but there is no
> > > start/create in napi_enable(). NAPIs can (and do get) disabled and
> > > enabled again. But that'd make your code crash with many popular
> > > drivers if you tried to change rings with threaded napi enabled so I
> > > feel like I must be missing something..  
> >
> > Ah, not crash, 'cause the flag gets cleared. Is it intentional that any
> > changes that disable NAPIs cause us to go back to non-threaded NAPI?
> > I think I had the "threaded" setting stored in struct netdevice in my
> > patches, is there a reason not to do that?
> 
> Thanks for the comments!
> 
> The reason that I did not record it in dev is: there is a slight
> chance that during creation of the kthreads, failures occur and we
> flip back all NAPIs to use non-threaded mode. I am not sure the
> recorded value in dev should be what user desires, or what the actual
> situation is. Same as after the driver does a
> napi_disabe()/napi_enable(). It might occur that the dev->threaded =
> true, but the operation to re-create the kthreads fail and we flip
> back to non-thread mode. This seems to get things more complicated.
> What I expect is the user only enables the threaded mode after the
> device is up and alive, with all NAPIs attached to dev, and enabled.
> And user has to check the sysfs to make sure that the operation
> succeeds.
> And any operation that brings down the device, will flip this back to
> default, which is non-threaded mode.

It is quite an annoying problem to address, given all relevant NAPI
helpers seem to return void :/ But we're pushing the problem onto the
user just because of internal API structure.

This reminds me of PTP / timestamping issues some NICs had once upon 
a time. The timing application enables HW time stamping, then later some
other application / orchestration changes a seemingly unrelated config,
and since NIC has to reset itself it looses the timestamping config.
Now the time app stops getting HW time stamps, but those are best
effort anyway, so it just assumes the NIC couldn't stamp given frame
(for every frame), not that config got completely broken. The system
keeps running with suboptimal time for months.

What does the deployment you're expecting to see looks like? What
entity controls enabling the threaded mode on a system? Application?
Orchestration? What's the flow?

"Forgetting" config based on driver-dependent events feels very fragile.
