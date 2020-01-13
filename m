Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 190FD1392BF
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgAMN5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:57:44 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38321 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbgAMN5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:57:35 -0500
Received: by mail-lj1-f193.google.com with SMTP id w1so10164676ljh.5
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 05:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8SGr0zQ5ehkxniLY1zX07VmmH9jNBbezrx5x/iOW1v8=;
        b=hj9e1160X6E1oF1UWwYlZNcqU1HsHWPVeqDZWwG0T2QllW3HVlhDdakFOoIWNMwPAi
         wuNvgZQk5XtQ6qVTWYm/P8DIh3BACAQZEigS+GVAuN8NcpXsCgTNS/kZiLOQ0oqTww5m
         96dj541GgrBiZXVpXCps+RXc4XSXTGfsaGf5ZLzGiQJGmKYvARholqoHz9YltHqMsofT
         l8S2Zp6Zyl1UL3h9Gn8IIYnhDQ8qCLk+i2sMpiPOozojtbRYD5cJQjwix0pCys7vQgrg
         XXTPvluZEKHIzmFfLbPvp/ooWm5ltd2czSBoTwdgHAiPC1foPSez95k3Sez3zALAlXt/
         rZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8SGr0zQ5ehkxniLY1zX07VmmH9jNBbezrx5x/iOW1v8=;
        b=aB1aMfESuk7/41K0dvcllrs6h167dmssYFO6Mr+YZA/DwQ6bwOoyUx7AvAOeTpFbPH
         ECkUmg8WjpQ4OgGYtHwN3wr0HGJrliFNI+0Z94AEukOnrY5FEM1rtzDa8/vb9tRFGPDM
         9FRqO7jVWEjT8cIjC1e16iYt8pqUZhLf16EXfESHWnsVflrnBm7btd5gPhP3hd2WY65/
         RJrIPrjVYdsEG5LLBrEZgf5DKlpzfudmDL2vMBTQ5EX88a+WFFmz95ajaCcUqavlWv9R
         MXqylKaA5tYVXD7tcjBrSUHKkKI36Y1DLosyvVuct077fLUb2da1tWHhoqi9ifMEkgKz
         JqRg==
X-Gm-Message-State: APjAAAVTroJW39pYzMT0KS3pH2x8A41DOOJx4wE7nQ/UKDjhzxzCWhg1
        nTkBkqln0BRBQcRSm9naL8ndEFYVqcWUxHbGSAsm4lAI
X-Google-Smtp-Source: APXvYqwrDW1FsgONcVKX71ErLCnWm7saPoZZ/ujOcMLR0nDg4FlHHt0tARkeLTdN8ajaYldxgynan+BfBQw2vaL7exw=
X-Received: by 2002:a2e:b0db:: with SMTP id g27mr10129599ljl.74.1578923854106;
 Mon, 13 Jan 2020 05:57:34 -0800 (PST)
MIME-Version: 1.0
References: <20200111163709.4181-1-ap420073@gmail.com> <20200112054725.7a8e6074@cakuba>
In-Reply-To: <20200112054725.7a8e6074@cakuba>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 13 Jan 2020 22:57:22 +0900
Message-ID: <CAMArcTUVwu+ofDy9D5TEfAcHkdvsZ6uxsKzH-19qLxBJo7d2QA@mail.gmail.com>
Subject: Re: [PATCH net 2/5] netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jan 2020 at 22:47, Jakub Kicinski <kubakici@wp.pl> wrote:
>

Hi Jakub,
Thank you for your review!

> On Sat, 11 Jan 2020 16:37:09 +0000, Taehee Yoo wrote:
> > When netdevsim dev is being created, a debugfs directory is created.
> > The variable "dev_ddir_name" is 16bytes device name pointer and device
> > name is "netdevsim<dev id>".
> > The maximum dev id length is 10.
> > So, 16bytes for device name isn't enough.
> >
> > Test commands:
> >     modprobe netdevsim
> >     echo "1000000000 0" > /sys/bus/netdevsim/new_device
> >
> > Splat looks like:
> > [   90.624922][ T1000] BUG: KASAN: stack-out-of-bounds in number+0x824/0x880
> > [   90.626999][ T1000] Write of size 1 at addr ffff8880b7f47988 by task bash/1000
> > [   90.627798][ T1000]
> > [   90.628076][ T1000] CPU: 0 PID: 1000 Comm: bash Not tainted 5.5.0-rc5+ #270
> > [   90.628806][ T1000] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> > [   90.629752][ T1000] Call Trace:
> > [   90.630080][ T1000]  dump_stack+0x96/0xdb
> > [   90.630512][ T1000]  ? number+0x824/0x880
> > [   90.630939][ T1000]  print_address_description.constprop.5+0x1be/0x360
> > [   90.631610][ T1000]  ? number+0x824/0x880
> > [   90.632038][ T1000]  ? number+0x824/0x880
> > [   90.632469][ T1000]  __kasan_report+0x12a/0x16f
> > [   90.632939][ T1000]  ? number+0x824/0x880
> > [   90.633397][ T1000]  kasan_report+0xe/0x20
> > [   90.633954][ T1000]  number+0x824/0x880
> > [   90.634513][ T1000]  ? put_dec+0xa0/0xa0
> > [   90.635047][ T1000]  ? rcu_read_lock_sched_held+0x90/0xc0
> > [   90.636469][ T1000]  vsnprintf+0x63c/0x10b0
> > [   90.637187][ T1000]  ? pointer+0x5b0/0x5b0
> > [   90.637871][ T1000]  ? mark_lock+0x11d/0xc40
> > [   90.638591][ T1000]  sprintf+0x9b/0xd0
> > [   90.639164][ T1000]  ? scnprintf+0xe0/0xe0
> > [   90.639802][ T1000]  nsim_dev_probe+0x63c/0xbf0 [netdevsim]
> > [ ... ]
> >
> > Fixes: 83c9e13aa39a ("netdevsim: add software driver for testing offloads")
>
> The correct Fixes tag is:
>
> Fixes: ab1d0cc004d7 ("netdevsim: change debugfs tree topology")
>

Thank you! I will fix the Fixes tag.

> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  drivers/net/netdevsim/dev.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > index 634eb5cdcbbe..a0c80a70bb23 100644
> > --- a/drivers/net/netdevsim/dev.c
> > +++ b/drivers/net/netdevsim/dev.c
> > @@ -88,7 +88,7 @@ static const struct file_operations nsim_dev_take_snapshot_fops = {
> >
> >  static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
> >  {
> > -     char dev_ddir_name[16];
> > +     char dev_ddir_name[32];
>
> nit: it'd be tempting to size this to the correct value
>      (20? or sizeof(DRV_NAME) + 10) rather than the arbitrary 32,
>      perhaps?
>

I agree with this. This is more correct.
I will fix this too.

Thank you
Taehee Yoo.
