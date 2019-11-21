Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82BF104E57
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfKUIuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:50:32 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:44052 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfKUIub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:50:31 -0500
Received: by mail-qv1-f67.google.com with SMTP id d3so1055370qvs.11
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 00:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hc77Rrreej/Kleox7IBwBWnSZr0kHeYXfxaBWFodRc0=;
        b=R+sAcDVdoK3ile8J8qABorYsfs8RCCM6c+YEXkbbDLsjuqjKqBvhdutQgQwqoiew5O
         7LcnLZED7pz1rkYwIlygVb/BhU41h47y0CImeuOsueiEyT/4vZTu2GsJQlJlzu2uVtHp
         Dcizmxyb2AB1mltBQP3I+CO7Tw4pyzOTqqkrg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hc77Rrreej/Kleox7IBwBWnSZr0kHeYXfxaBWFodRc0=;
        b=t22+nG+sBj5huAVtr+lwp8fmO8MT9EZgv4npcXlZXaWrd08kgyAuKtAgUpKZ/H8017
         Wyz1FonWj/CwkGSUHDL+Ay7oWUnHaaiHZoRLDUWljrU9r5QJWQ+mIx8GJf4TC/jZBDUU
         DbJ4dDnJSqVIIi5wdycMIH6yEXFwrignrgpuv1uIhzVi2z+wsFviouwXEgicldKfFeEO
         ErnDop6JSj3bTG5uWFGwhvHgFwk7u+G1QDFaCK7pxjs7e6JoiBxq/Izi+V0zFQJchVjh
         ebS+Wp4XwoF/VnF7WkVyAstavaEwfoBuysXmUXz46I/Mmy216Dz1qBqMSwQkFB8WzOXm
         uQyA==
X-Gm-Message-State: APjAAAXtwmcu7k3L58WyOylp/6poURU4L/mBEdRqfeC3drm/kruF7BYt
        WvuGQHJvFy8g9SeELaNQuUWFPf+gCvrNFPguO5xWCA==
X-Google-Smtp-Source: APXvYqyWPE8YWfdM61RSPhrmqayUrmDc/nwAdDvWyuAddgekp0DWyboXm+zCVqMhesD0XncaVMd0ib6qjqCPa0SRRE8=
X-Received: by 2002:a05:6214:86:: with SMTP id n6mr7247685qvr.219.1574326230660;
 Thu, 21 Nov 2019 00:50:30 -0800 (PST)
MIME-Version: 1.0
References: <20191120194020.8796-1-pmalani@chromium.org> <2b96129da21d412f8780325e6be95c9d@realtek.com>
In-Reply-To: <2b96129da21d412f8780325e6be95c9d@realtek.com>
From:   Prashant Malani <pmalani@chromium.org>
Date:   Thu, 21 Nov 2019 00:50:18 -0800
Message-ID: <CACeCKacWVFUPGhXaVJsS+CR+SNCa-9u3KfNK7QzH_bFPczC6uQ@mail.gmail.com>
Subject: Re: [PATCH net] r8152: Re-order napi_disable in rtl8152_close
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 7:00 PM Hayes Wang <hayeswang@realtek.com> wrote:
>
> Prashant Malani [mailto:pmalani@chromium.org]
> > Sent: Thursday, November 21, 2019 3:40 AM
> [...]
> > @@ -4283,10 +4283,10 @@ static int rtl8152_close(struct net_device
> > *netdev)
> >       unregister_pm_notifier(&tp->pm_notifier);
> >  #endif
> >       tasklet_disable(&tp->tx_tl);
>
> Should tasklet_disable() be moved, too?
Perhaps; I'm not too familiar with what the tasklet bottom half does
to be able to conclusively say. Probably best to leave it as is
(somewhat symmetrical to rtl8152_open()) if it is not causing any
races in its current location?
Moving if after cancel_delayed_work_sync() would effectively not do
much IIUC since WORK_ENABLE is already cleared by then and that is one
of the guard clauses inside bottom_half(see :
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/usb/r8152.c#n2423),
so effectively, it's disabled as soon as WORK_ENABLE is cleared. I
might be mistaken here though.
>
> > -     napi_disable(&tp->napi);
> >       clear_bit(WORK_ENABLE, &tp->flags);
> >       usb_kill_urb(tp->intr_urb);
> >       cancel_delayed_work_sync(&tp->schedule);
> > +     napi_disable(&tp->napi);
> >       netif_stop_queue(netdev);
>
> Best Regards,
> Hayes
>
>
