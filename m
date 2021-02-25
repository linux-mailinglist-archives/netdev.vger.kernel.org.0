Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9A23247C4
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhBYAIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236218AbhBYAIK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 19:08:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A37C64F10;
        Thu, 25 Feb 2021 00:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614211647;
        bh=u6VhaDjblGQt09dHUrdXoY4QMhHnKG3zcBDdAJehWFc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lW+fAzUsDkOM1ZzJyvBsCbrv37VRY2uCWd3Kc3DjJaaSsE1LJg1EBGW1/4Qk7Bpn9
         HseC7v/7FbCLmqrR7MHBM5x1229TnA5D7M73F4itnhqAchfRwYB2AkkB55WGfjxmZF
         kD9UwRZ0Z8tSI4qKf9eQVLtPZrMG/uQ5gY+mcrssOR9XShNwZ0IufEksNALrlqmWk9
         EG0bZmSukKM+EABkIrDV2+YDhgk5b1jF9sQ/XE7HjcHTmeUCIBBKFrcskm7TOiGqz0
         2gOZlHNS+RlhdESP0mIAlnV82Cgi4AbUwTBCTRfjfFJlAK/fyZCzJKQzuxQcddR5xc
         c3wPFgvfTG84A==
Date:   Wed, 24 Feb 2021 16:07:23 -0800
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
Message-ID: <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
        <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 00:59:25 +0100 Eric Dumazet wrote:
> On Thu, Feb 25, 2021 at 12:52 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > Interesting, vger seems to be CCed but it isn't appearing on the ML.
> > Perhaps just a vger delay :S
> >
> > Not really upsetting. I'm just trying to share what I learned devising
> > more advanced pollers. The bits get really messy really quickly.
> > Especially that the proposed fix adds a bit for a poor bystander (busy
> > poll) while it's the threaded IRQ that is incorrectly not preserving
> > its ownership.
> >  
> > > Additional 16 bytes here, possibly in a shared cache line, [1]
> > > I prefer using a bit in hot n->state, we have plenty of them available.  
> >
> > Right, presumably the location of the new member could be optimized.
> > I typed this proposal up in a couple of minutes.
> >  
> > > We worked hours with Alexander, Wei, I am sorry you think we did a poor job.
> > > I really thought we instead solved the issue at hand.
> > >
> > > May I suggest you defer your idea of redesigning the NAPI model for
> > > net-next ?  
> >
> > Seems like you decided on this solution off list and now the fact that
> > there is a discussion on the list is upsetting you. May I suggest that
> > discussions should be conducted on list to avoid such situations?  
> 
> We were trying to not pollute the list (with about 40 different emails so far)
> 
> (Note this was not something I initiated, I only hit Reply all button)
> 
> OK, I will shut up, since you seem to take over this matter, and it is
> 1am here in France.

Are you okay with adding a SCHED_THREADED bit for threaded NAPI to be
set in addition to SCHED? At least that way the bit is associated with
it's user. IIUC since the extra clear_bit() in busy poll was okay so
should be a new set_bit()?
