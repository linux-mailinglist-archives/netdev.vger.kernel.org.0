Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9A814C447
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 01:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgA2A60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 19:58:26 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38921 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgA2A60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 19:58:26 -0500
Received: by mail-io1-f67.google.com with SMTP id c16so16685602ioh.6
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 16:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfPnwCqzCAhNK/qRWkWU3pxM5PERG8Ehj+A9uu9jn7s=;
        b=PV5nGiReMA0sAjLADHB6cjIFeP0lOuZ2izL3OeGoiIvgFCUiygVFxPpzwLVE5KY48/
         fNV7VLkyKdLRhdw6lXTdtjxDSp1Kfm98KBAR0mc8RBQRe6pToRC6dObO8PA0tI98u+En
         ahQO0LZozEg2pDBtBjOaZHpxcaSgzRJcywL2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfPnwCqzCAhNK/qRWkWU3pxM5PERG8Ehj+A9uu9jn7s=;
        b=GLOdV7v1C/Si6PLEBGeoz1TBR2W62UeBhfOosmGmSbEMzZdWJgOrXaGlznPR9R0Ff5
         6l0lTGNKHOaK+p3fEngft31phWLd/AgS7JGSacVCS/HMRnfmstomPXkWcQ0nOsPlrWRT
         lpE0w9xNxeEk5pex1CVU5Al4+AiRPUmO98DeC9Ff1JFIDa8YQvz0wryVgLkBBjfEwlKB
         9M04ed+n7wfUCRcrSiR8vqixFjct6bPRxRv6epYNClqm+xogu/vxMsNZ3muQ+BQFskpM
         SLkdg7/qBNHRJIhAJT3bXNgkzDU+9CAgnB9lj2+ccoBTkgquByQVhPriOCwi2oYi2qdP
         Poiw==
X-Gm-Message-State: APjAAAXhDNuBeqhv1OUgXd+1hmYjOK2En7hLPY2LR1PgpzKlxQnzWlae
        1IT1kVXCpajjb/8yrN62GsM83u+fZccRc2tT0AhGyg==
X-Google-Smtp-Source: APXvYqymqB5TqQR1jEIKQdvhU6+g/gQUeuhg7Wx4i4yDpD6JXZCAkkKsc3l6eWETvdrvN+KyCLd1363joP/UoRND9Pw=
X-Received: by 2002:a05:6602:22cd:: with SMTP id e13mr15272247ioe.251.1580259505025;
 Tue, 28 Jan 2020 16:58:25 -0800 (PST)
MIME-Version: 1.0
References: <20200128221457.12467-1-linux@roeck-us.net> <CAD=FV=Wg2MZ56fsCk+TvRSSeZVz5eM4cwugK=HN6imm5wfGgiw@mail.gmail.com>
 <20200129000551.GA17256@roeck-us.net>
In-Reply-To: <20200129000551.GA17256@roeck-us.net>
From:   Franky Lin <franky.lin@broadcom.com>
Date:   Tue, 28 Jan 2020 16:57:59 -0800
Message-ID: <CA+8PC_f=qCUjihwbjd3vtGaNkG-=R1qm83oS7AmgtLTy6EgjyQ@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: abort and release host after error
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Doug Anderson <dianders@chromium.org>,
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
        Matthias Kaehlcke <mka@chromium.org>,
        Brian Norris <briannorris@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 4:05 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Tue, Jan 28, 2020 at 03:14:45PM -0800, Doug Anderson wrote:
> > Hi,
> >
> > On Tue, Jan 28, 2020 at 2:15 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > With commit 216b44000ada ("brcmfmac: Fix use after free in
> > > brcmf_sdio_readframes()") applied, we see locking timeouts in
> > > brcmf_sdio_watchdog_thread().
> > >
> > > brcmfmac: brcmf_escan_timeout: timer expired
> > > INFO: task brcmf_wdog/mmc1:621 blocked for more than 120 seconds.
> > > Not tainted 4.19.94-07984-g24ff99a0f713 #1
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > brcmf_wdog/mmc1 D    0   621      2 0x00000000 last_sleep: 2440793077.  last_runnable: 2440766827
> > > [<c0aa1e60>] (__schedule) from [<c0aa2100>] (schedule+0x98/0xc4)
> > > [<c0aa2100>] (schedule) from [<c0853830>] (__mmc_claim_host+0x154/0x274)
> > > [<c0853830>] (__mmc_claim_host) from [<bf10c5b8>] (brcmf_sdio_watchdog_thread+0x1b0/0x1f8 [brcmfmac])
> > > [<bf10c5b8>] (brcmf_sdio_watchdog_thread [brcmfmac]) from [<c02570b8>] (kthread+0x178/0x180)
> > >
> > > In addition to restarting or exiting the loop, it is also necessary to
> > > abort the command and to release the host.
> > >
> > > Fixes: 216b44000ada ("brcmfmac: Fix use after free in brcmf_sdio_readframes()")
> > > Cc: Dan Carpenter <dan.carpenter@oracle.com>
> > > Cc: Matthias Kaehlcke <mka@chromium.org>
> > > Cc: Brian Norris <briannorris@chromium.org>
> > > Cc: Douglas Anderson <dianders@chromium.org>
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > >  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > > index f9df95bc7fa1..2e1c23c7269d 100644
> > > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> > > @@ -1938,6 +1938,8 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
> > >                         if (brcmf_sdio_hdparse(bus, bus->rxhdr, &rd_new,
> > >                                                BRCMF_SDIO_FT_NORMAL)) {
> > >                                 rd->len = 0;
> > > +                               brcmf_sdio_rxfail(bus, true, true);
> > > +                               sdio_release_host(bus->sdiodev->func1);
> >
> > I don't know much about this driver so I don't personally know if
> > "true, true" is the correct thing to pass to brcmf_sdio_rxfail(), but
> > it seems plausible.  Definitely the fix to call sdio_release_host() is
> > sane.
> >
> > Thus, unless someone knows for sure that brcmf_sdio_rxfail()'s
> > parameters should be different:
> >
> Actually, looking at brcmf_sdio_hdparse() and its other callers,
> I think it may not be needed at all - other callers don't do it, and
> there already are some calls to brcmf_sdio_rxfail() in that function.
> It would be nice though to get a confirmation before I submit v2.

I think invoking rxfail with both abort and NACK set to true is the
right thing to do here so that the pipeline can be properly purged.

Thanks!

Acked-by: franky.lin@broadcom.com
