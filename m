Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3261A301B61
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 12:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbhAXLUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 06:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbhAXLU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 06:20:27 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18975C061573;
        Sun, 24 Jan 2021 03:19:46 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id m6so6720701pfm.6;
        Sun, 24 Jan 2021 03:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3mlNxluoOUFXyf7eipu0PmfQvN2acVkWiu4QSIwRsEA=;
        b=qy8p0e/Cgsi1dPzfQhUxQ8EMrTzh33+d4fxEXhoPAd6u+fMPZmpSbQDRhllQM5OaQN
         7hObRxVho+ndfpKPChb5gxJQ6r01CX/o2dSwQi5ldwVj+6Rbcf+Ko+wOikJIL3dgOcFL
         acCVyCDlo4f4+fGj+u1n9iAao9YM9sSKUpQaGr8jth9MOaifh5EATGgqFGiO2nAqbQhg
         vNeTUxvp6KqRkH+TrbSJA/uqga64OOUYDYe3wKYGULWzvRkAwcJPAU2yYXpmy0xGzS9K
         VzJqvKKpot+R06fNyDiC184YneCT7igRhbA3Wu61ktotgVFDztScASDTrxRr1H4PclUn
         W7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3mlNxluoOUFXyf7eipu0PmfQvN2acVkWiu4QSIwRsEA=;
        b=RNElWX8vXtCvMbdg4b0XPj+4L7HPoRPmpr+1kJKFu2QohKy+cl4lGoDNETU1CGaxnI
         ZczYP6GT1V+Upwoi/k3uG2iRxEGkTzrwUQMrBzs+tHt1jlCTN8b3PLAkw5F0q3XJaX8M
         BLukI/OgDWKaslGec+RSIM3t0XVHfG9xw/URTGOGT3Mty0lPixoaYJrx9MeH/6L0X8/c
         vsnorDlMozc8bvhlldCqhRlqSd9HWeBlwRgHQozi49Y8DoLgkZ+uvWk+fh1t6IOaGtg9
         QhudXss6cOLPhV4iwSEH4jtN/15Y5FKfuqE+rNKlRbHjBJA/hNj7OLoFMkOU04TPLf4+
         hbgA==
X-Gm-Message-State: AOAM533Hz1gAwGDiEmdwmOk8hRxAWZlmZLkaRAo8/gJg5dQebnCDieWF
        DdCFZybZdRejavBJxB21PkaGRPlwU42xdHxKOhQ=
X-Google-Smtp-Source: ABdhPJwvX0ybp1SFh54EN0MagOI0gutIt5ypVXFQl8EgTllirWPShn/3w9bm1Q4uExmAD3b9BD0/mMR4PVLdvxvmDsI=
X-Received: by 2002:a62:52d6:0:b029:1c0:aed7:c88 with SMTP id
 g205-20020a6252d60000b02901c0aed70c88mr383427pfb.76.1611487185651; Sun, 24
 Jan 2021 03:19:45 -0800 (PST)
MIME-Version: 1.0
References: <20210121002129.93754-1-xie.he.0141@gmail.com> <b42575d44fb7f5c1253635a19c3e21e2@dev.tdt.de>
 <20210123204507.35c895db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123204507.35c895db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 24 Jan 2021 03:19:35 -0800
Message-ID: <CAJht_ENQ2aN2vvWzLDGUUk-7Yv_=UUJmOrbC3M9J=j5uET-pAQ@mail.gmail.com>
Subject: Re: [PATCH net v5] net: lapb: Add locking to the lapb module
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 8:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> > > @@ -178,11 +182,23 @@ int lapb_unregister(struct net_device *dev)
> > >             goto out;
> > >     lapb_put(lapb);
> > >
> > > +   /* Wait for other refs to "lapb" to drop */
> > > +   while (refcount_read(&lapb->refcnt) > 2)
> > > +           ;
>
> Tight loop like this is a little scary, perhaps add a small
> usleep_range() here?

OK, sure. I'll add a usleep_range(1, 10) here.

> > > -int lapb_disconnect_request(struct net_device *dev)
> > > +static int __lapb_disconnect_request(struct lapb_cb *lapb)
> > >  {
> > > -   struct lapb_cb *lapb = lapb_devtostruct(dev);
> > > -   int rc = LAPB_BADTOKEN;
> > > -
> > > -   if (!lapb)
> > > -           goto out;
> > > -
> > >     switch (lapb->state) {
> > >     case LAPB_STATE_0:
> > > -           rc = LAPB_NOTCONNECTED;
> > > -           goto out_put;
> > > +           return LAPB_NOTCONNECTED;
> > >
> > >     case LAPB_STATE_1:
> > >             lapb_dbg(1, "(%p) S1 TX DISC(1)\n", lapb->dev);
> > > @@ -310,12 +328,10 @@ int lapb_disconnect_request(struct net_device
> > > *dev)
> > >             lapb_send_control(lapb, LAPB_DISC, LAPB_POLLON, LAPB_COMMAND);
> > >             lapb->state = LAPB_STATE_0;
> > >             lapb_start_t1timer(lapb);
> > > -           rc = LAPB_NOTCONNECTED;
> > > -           goto out_put;
> > > +           return LAPB_NOTCONNECTED;
> > >
> > >     case LAPB_STATE_2:
> > > -           rc = LAPB_OK;
> > > -           goto out_put;
> > > +           return LAPB_OK;
> > >     }
> > >
> > >     lapb_clear_queues(lapb);
> > > @@ -328,8 +344,22 @@ int lapb_disconnect_request(struct net_device
> > > *dev)
> > >     lapb_dbg(1, "(%p) S3 DISC(1)\n", lapb->dev);
> > >     lapb_dbg(0, "(%p) S3 -> S2\n", lapb->dev);
> > >
> > > -   rc = LAPB_OK;
> > > -out_put:
> > > +   return LAPB_OK;
> > > +}
>
> Since this is a fix for net, I'd advise against converting the goto
> into direct returns (as much as I generally like such conversion).

This part is actually splitting "lapb_disconnect_request" into two
functions - a "__lapb_disconnect_request" without locking, and a
"lapb_disconnect_request" which provides the locking and calls
"__lapb_disconnect_request". The splitting is necessary for
"lapb_device_event" to directly call "__lapb_disconnect_request" with
the lock already held. After the splitting, the "out_put" tag would
actually be in the caller function so there's nowhere we can "goto".
