Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9918914D015
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 19:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgA2SEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 13:04:34 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40927 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgA2SEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 13:04:34 -0500
Received: by mail-pj1-f66.google.com with SMTP id 12so120398pjb.5
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 10:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6QNebILk02STEyIe5/0fAJxmh4v1Dv7+qDAzRC1FUDQ=;
        b=LowdrKlK0P6qecyQGM0hzYenViTrLksQTfxjJ9ni4gKyCCIp1FahM6Ho5TjGK9OAVj
         7oqM88GFtBs997v7Yh1XJCADc6MeqKnvobn1CGwvE1MPLZNH0uZswwf2Zu4yOPQi3Cdi
         0e9TIPoczxRInL3Xrd1lCEWURMROuKtqa8IP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6QNebILk02STEyIe5/0fAJxmh4v1Dv7+qDAzRC1FUDQ=;
        b=WOcJT82SBlslkoM5pXZn15+HkDHkPI1tb86lRBWFKHZ9halIauM8mCc1DJVRbkRM8H
         yBqM6tcEJPe93hJ/QqJWFtEmaiIl1nJoCD3YRMYPEQYLVXL5Uw93m0Bo3ReESutmXw7W
         LRbA4QMt+x/5LC8dERasBu9aenJyQ84WK+qbLQpsOcFw67V7ZnR9NqeHKXZVghFZ5Hwl
         LN9E+GL1LVNOB/tsHTh+fsDS/gBD3tkyn6cTSaRb23DVrOb7CImStHOYk9RIXrJIg94K
         6VQSMkzPvSQWTUqnk3rGCxJW0d2rou++kZ96ja/eEOUT0NBn60Ha8doB9ZuDcL+okLej
         zo5g==
X-Gm-Message-State: APjAAAX/UGTHEb1CySN8VRnxFU6ybji+wgChU+dCRSpecjnMnAaODJFa
        Rq4172FzaeLrNQn58MGHoP8MZg==
X-Google-Smtp-Source: APXvYqxVUyW4yrpYAV6X6fDHS+gRG2rAx1gwUyY8QSDnEvQsn0QmEVreNGiM5X7rKr6GWTnyLky0ug==
X-Received: by 2002:a17:902:bf41:: with SMTP id u1mr552856pls.207.1580321073273;
        Wed, 29 Jan 2020 10:04:33 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id q6sm3385291pgt.47.2020.01.29.10.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 10:04:32 -0800 (PST)
Date:   Wed, 29 Jan 2020 10:04:30 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Franky Lin <franky.lin@broadcom.com>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Doug Anderson <dianders@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] brcmfmac: abort and release host after error
Message-ID: <20200129180428.GA99393@google.com>
References: <20200128221457.12467-1-linux@roeck-us.net>
 <CAD=FV=Wg2MZ56fsCk+TvRSSeZVz5eM4cwugK=HN6imm5wfGgiw@mail.gmail.com>
 <20200129000551.GA17256@roeck-us.net>
 <CA+8PC_f=qCUjihwbjd3vtGaNkG-=R1qm83oS7AmgtLTy6EgjyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8PC_f=qCUjihwbjd3vtGaNkG-=R1qm83oS7AmgtLTy6EgjyQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Franky,

[I'm very unfamiliar with this driver, but I had the same questions as
Guenter, I think:]

On Tue, Jan 28, 2020 at 04:57:59PM -0800, Franky Lin wrote:
> On Tue, Jan 28, 2020 at 4:05 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > On Tue, Jan 28, 2020 at 03:14:45PM -0800, Doug Anderson wrote:
> > > On Tue, Jan 28, 2020 at 2:15 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > > > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > > > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > > > @@ -1938,6 +1938,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
> > > >                         if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
> > > >                                                BRCMF_SDIO_FT_NORMAL)) {
> > > >                                 rd->len = 0;
> > > > +                               brcmf_sdio_rxfail(bus, true, true);
> > > > +                               sdio_release_host(bus->sdiodev->func1);
> > >
> > > I don't know much about this driver so I don't personally know if
> > > "true, true" is the correct thing to pass to brcmf_sdio_rxfail(), but
> > > it seems plausible.  Definitely the fix to call sdio_release_host() is
> > > sane.
> > >
> > > Thus, unless someone knows for sure that brcmf_sdio_rxfail()'s
> > > parameters should be different:
> > >
> > Actually, looking at brcmf_sdio_hdparse() and its other callers,
> > I think it may not be needed at all - other callers don't do it, and
> > there already are some calls to brcmf_sdio_rxfail() in that function.
> > It would be nice though to get a confirmation before I submit v2.
> 
> I think invoking rxfail with both abort and NACK set to true is the
> right thing to do here so that the pipeline can be properly purged.

Thanks for looking here. I'm not sure I totally understand your answer:
brcmf_sdio_hdparse() already calls brcmf_sdio_rxfail() in several error
cases. Is it really OK to call it twice in a row?

Brian
