Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACE53680F9
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbhDVNAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236120AbhDVNAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 09:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7AD361421;
        Thu, 22 Apr 2021 12:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619096369;
        bh=iNdy13cocASRA3fthfuvBCyourfe9nLIS9UqG/OSWhA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SNJrNQeZIEu0is8Kddx3zYtuIF7OoheImP7s1O1GU95priUTs2AEbu30qea3Vvirx
         dLKNWqoDfxSyG2STjzYbbB6gkBeCI97bz9viuFYjwNRXf9P9eHMZOahEF53eMtsND+
         Oz4tb9gYXGZ7W9n1eby1IDRqZAgBgApviTxHIy1D7xpwq22GAkuMnGwO3Wqu9JV/fI
         MhbqQOUb6tYAetIbnPKKiSfFXaeyn8NNtWdxOVUWzQuL5TWw+LgWCrU8at+06P4/QE
         fJIObM+Rfu+b1zmIuKsjOlP5jsMHiXobaM9dkbI15l9tZ1mfE+P+gDp+5yrSSAxeXe
         nb7ASKeoBUXJw==
Date:   Thu, 22 Apr 2021 15:59:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: wwan: core: Return poll error in case of
 port removal
Message-ID: <YIFzLUNliMn1DO6h@unreal>
References: <1619084614-24925-1-git-send-email-loic.poulain@linaro.org>
 <YIFUvMCCivi62Rb4@unreal>
 <CAMZdPi8fMu-Be4Rfxcd3gafyUhNozV0RS3idS_eF6gjYW3E9qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi8fMu-Be4Rfxcd3gafyUhNozV0RS3idS_eF6gjYW3E9qw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 01:21:47PM +0200, Loic Poulain wrote:
> Hi Leon,
> 
> On Thu, 22 Apr 2021 at 12:49, Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Thu, Apr 22, 2021 at 11:43:34AM +0200, Loic Poulain wrote:
> > > Ensure that the poll system call returns error flags when port is
> > > removed, allowing user side to properly fail, without trying read
> > > or write. Port removal leads to nullified port operations, add a
> > > is_port_connected() helper to safely check the status.
> > >
> > > Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > ---
> > >  drivers/net/wwan/wwan_core.c | 17 +++++++++++++++--
> > >  1 file changed, 15 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> > > index 5be5e1e..c965b21 100644
> > > --- a/drivers/net/wwan/wwan_core.c
> > > +++ b/drivers/net/wwan/wwan_core.c
> > > @@ -369,14 +369,25 @@ static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
> > >       return ret;
> > >  }
> > >
> > > +static bool is_port_connected(struct wwan_port *port)
> > > +{
> > > +     bool connected;
> > > +
> > > +     mutex_lock(&port->ops_lock);
> > > +     connected = !!port->ops;
> > > +     mutex_unlock(&port->ops_lock);
> > > +
> > > +     return connected;
> > > +}
> >
> > The above can't be correct. What prevents to change the status of
> > port->ops right before or after your mutex_lock/mutex_unlock?
> 
> Nothing, this is just to protect access to the variable (probably
> overkill though), which can be concurrently nullified in port removal,
> and to check if the event (poll wake-up) has been caused by removal of
> the port, no port operation (port->ops...) is actually called on that
> condition. If the status is changed right after the check, then any
> subsequent poll/read/write syscall will simply fail properly.

Taking locks when it is not needed is not overkill, but bug.

I wander if all these is_*_blocked() checks can be trusted if port->ops
pointer flips.

Thanks

> 
> Regards,
> Loic
