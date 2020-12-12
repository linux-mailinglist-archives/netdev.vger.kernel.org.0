Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5F42D8A78
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 23:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408123AbgLLWzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 17:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLWzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 17:55:45 -0500
Date:   Sat, 12 Dec 2020 14:55:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607813704;
        bh=LEOR6XaiRf8nT2mGSyaN1ZdPTqCRm20er+8qHgXXm4A=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=gyWHaFMt7yBZ2Re3ppAMrw42XY4iMpVeJVLV7MthcBznqHamwojo5N4QIg0sGiI+v
         9+W5eEFvWnYznMV2u1sd1EGIrHw/pJlEldIc/N5bPj4oPFzxTMgZinA/JaCtIgULAH
         H4JCdqeckmQ5W7gScfYcOOWnFezeB8Oe8zPwQFH1Mgj0QI2HGL8hRYAVRMLbHGXe/x
         yvHH7mPBAWxoi/g/MtT+Jha+CJtBUXDiDsCMzPEFKHn5/Luq/Z+0yzQcF40axlRO0B
         P84DReP1M4VF4iUBGjD1l7Km4vTiDQNLuzu2PuKD9uiNWSaaSBRnZoAdC2O8NqdfZB
         SrKltn2K9VTxw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH net-next v4 2/3] net: implement threaded-able napi poll
 loop support
Message-ID: <20201212145503.285a8bfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201212145022.6f2698d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201209005444.1949356-1-weiwan@google.com>
        <20201209005444.1949356-3-weiwan@google.com>
        <20201212145022.6f2698d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Dec 2020 14:50:22 -0800 Jakub Kicinski wrote:
> > @@ -6731,6 +6790,7 @@ void napi_disable(struct napi_struct *n)
> >  		msleep(1);
> >  
> >  	hrtimer_cancel(&n->timer);
> > +	napi_kthread_stop(n);  
> 
> I'm surprised that we stop the thread on napi_disable() but there is no
> start/create in napi_enable(). NAPIs can (and do get) disabled and
> enabled again. But that'd make your code crash with many popular
> drivers if you tried to change rings with threaded napi enabled so I
> feel like I must be missing something..

Ah, not crash, 'cause the flag gets cleared. Is it intentional that any
changes that disable NAPIs cause us to go back to non-threaded NAPI?
I think I had the "threaded" setting stored in struct netdevice in my
patches, is there a reason not to do that?

In fact your patches may _require_ the device to be up to enable
threaded NAPI if NAPIs are allocated in open.
