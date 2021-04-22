Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B0A3682D4
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 16:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236487AbhDVO5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 10:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236439AbhDVO5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 10:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C48461139;
        Thu, 22 Apr 2021 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619103395;
        bh=kw0pWMkWXFuF1F7rsGSx80rSSiGlGJHwV6BPXjt52bA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KCbFKLWCABf4oZ5sr1XEmxQQJDG895ZlxthnFNBvy0SnMc6+EaJv24eer9rvAoGwl
         x2f+xQRkn/U/7acD68jPB3UpigC9sNsrTyHtU33540hxz3JaaoXa1JdpQ2iztGWorY
         DRZSjCTfOcWR/HhojsEy5IOxra0KUT6jbQhQHemaykuOqoX15i6J6rpOPxC5biwUCK
         EObabJqFYly3GCixhom9rI0ZzfV1P8WgSObqrnedqatb7n4jhyqC6LqvFAgjIkI/z2
         7EKld2gZKgUqPFlNlWqeTgth+e1KQyKGDRRB5x4aFKHjLx7MZYSNPv2wSi3SBMXM+o
         p9wna2hUDN3gw==
Date:   Thu, 22 Apr 2021 17:56:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: wwan: core: Return poll error in case of
 port removal
Message-ID: <YIGOn2LRInk8SKEW@unreal>
References: <1619084614-24925-1-git-send-email-loic.poulain@linaro.org>
 <YIFUvMCCivi62Rb4@unreal>
 <CAMZdPi8fMu-Be4Rfxcd3gafyUhNozV0RS3idS_eF6gjYW3E9qw@mail.gmail.com>
 <YIFzLUNliMn1DO6h@unreal>
 <CAMZdPi_GvNeY605HW6MfJrACViHTp20NyAtpm1Gbe-7F1=GzZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi_GvNeY605HW6MfJrACViHTp20NyAtpm1Gbe-7F1=GzZA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:37:10PM +0200, Loic Poulain wrote:
> On Thu, 22 Apr 2021 at 14:59, Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Thu, Apr 22, 2021 at 01:21:47PM +0200, Loic Poulain wrote:
> > > Hi Leon,
> > >
> > > On Thu, 22 Apr 2021 at 12:49, Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Thu, Apr 22, 2021 at 11:43:34AM +0200, Loic Poulain wrote:
> > > > > Ensure that the poll system call returns error flags when port is
> > > > > removed, allowing user side to properly fail, without trying read
> > > > > or write. Port removal leads to nullified port operations, add a
> > > > > is_port_connected() helper to safely check the status.
> > > > >
> > > > > Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> > > > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > > > ---
> > > > >  drivers/net/wwan/wwan_core.c | 17 +++++++++++++++--
> > > > >  1 file changed, 15 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> > > > > index 5be5e1e..c965b21 100644
> > > > > --- a/drivers/net/wwan/wwan_core.c
> > > > > +++ b/drivers/net/wwan/wwan_core.c
> > > > > @@ -369,14 +369,25 @@ static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
> > > > >       return ret;
> > > > >  }
> > > > >
> > > > > +static bool is_port_connected(struct wwan_port *port)
> > > > > +{
> > > > > +     bool connected;
> > > > > +
> > > > > +     mutex_lock(&port->ops_lock);
> > > > > +     connected = !!port->ops;
> > > > > +     mutex_unlock(&port->ops_lock);
> > > > > +
> > > > > +     return connected;
> > > > > +}
> > > >
> > > > The above can't be correct. What prevents to change the status of
> > > > port->ops right before or after your mutex_lock/mutex_unlock?
> > >
> > > Nothing, this is just to protect access to the variable (probably
> > > overkill though), which can be concurrently nullified in port removal,
> > > and to check if the event (poll wake-up) has been caused by removal of
> > > the port, no port operation (port->ops...) is actually called on that
> > > condition. If the status is changed right after the check, then any
> > > subsequent poll/read/write syscall will simply fail properly.
> >
> > Taking locks when it is not needed is not overkill, but bug.
> 
> Ok understood, so going to rework that patch properly.

Thanks
