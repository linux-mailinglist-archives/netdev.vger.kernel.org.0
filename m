Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90D63247A9
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbhBXXxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:53:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234137AbhBXXxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:53:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49C5864F0A;
        Wed, 24 Feb 2021 23:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614210762;
        bh=7vOlEGQlHC2/15ACeOdae2VcST2YMFo6RG28jxny+dc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OfVrdQH2iXLnC/RUtoOrjYngZWjl0lMECkCZ/uxfGA+MlQy1GsLxuwnGTk+hGT9UY
         EZ2JJQx5YXxqm4qc1H8x7KeHrH7CzypAKfGZXZ+PM1PlvxEghHV5MaGxKsGS9tLA0S
         NI6tn92aVpEbcOP3T/g9Tdo+pwpN1tt+aEuxcuVr5wdZqpw0sl0/ZIW9V3ihmrofiG
         zp99tW39eAEfMe36koEiNj0wcbV/2GSVQEVadKmkZtiS2pwfki1GZTOB/aGt6VGnOo
         bWdKD/CMPbRug2pFK2LKC2RjthBH+jT4LsD/D/g04avjgrMq6y4yM2clKnCvVVANMJ
         d1M9X6bWDQv1g==
Date:   Wed, 24 Feb 2021 15:52:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 23:30:23 +0100 Eric Dumazet wrote:
> On Wed, Feb 24, 2021 at 10:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Just to find out what the LoC is I sketched this out:
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index ddf4cfc12615..77f09ced9ee4 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -348,6 +348,7 @@ struct napi_struct {
> >         struct hlist_node       napi_hash_node;
> >         unsigned int            napi_id;
> >         struct task_struct      *thread;
> > +       struct list_head        thread_poll_list;
> >  };
> 
> offlist, since it seems this conversation is upsetting you.

Interesting, vger seems to be CCed but it isn't appearing on the ML.
Perhaps just a vger delay :S

Not really upsetting. I'm just trying to share what I learned devising
more advanced pollers. The bits get really messy really quickly.
Especially that the proposed fix adds a bit for a poor bystander (busy
poll) while it's the threaded IRQ that is incorrectly not preserving
its ownership.

> Additional 16 bytes here, possibly in a shared cache line, [1]
> I prefer using a bit in hot n->state, we have plenty of them available.

Right, presumably the location of the new member could be optimized.
I typed this proposal up in a couple of minutes.

> We worked hours with Alexander, Wei, I am sorry you think we did a poor job.
> I really thought we instead solved the issue at hand.
> 
> May I suggest you defer your idea of redesigning the NAPI model for
> net-next ?

Seems like you decided on this solution off list and now the fact that
there is a discussion on the list is upsetting you. May I suggest that
discussions should be conducted on list to avoid such situations?
