Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62DCFD4F66
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 13:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfJLLo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 07:44:26 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39580 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfJLLmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 07:42:25 -0400
Received: by mail-lj1-f193.google.com with SMTP id y3so12261395ljj.6;
        Sat, 12 Oct 2019 04:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y11pBCe1CKAjsPMn1sqz/oYdoQIUENwcNyPETlfS7fU=;
        b=ITLTft8A4VLVxPboRseeDV2uqnjEVCF9cadQ+LcoeaUZcDpo3zF2O9AINuaIkyND6L
         /1/lA/sScUZblZRjpvdoky/Bc0HYMr8YCUQGgpgqnrRY65N1GZVfSSQ78f+qAElw2Dcw
         DpuohN20RNKfrIsPyxBYk7hT79xOqI9tvYT1+X+BNOTbTfNkBjP6b6G0kdC0ssvHjX6B
         IA5f5o8aDKnxfsB3SI8fQrvnwyu1xEhuhtjWrELnT7hja3YhnG82AkmLuU8p6RHYDhBV
         Qi+I8f0icJ5AmGNR2cMB66fu4D6Xg1X3oTfLzFSpI28qfPjZjYhC5vwmGxKPO0mpL+Y5
         kp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y11pBCe1CKAjsPMn1sqz/oYdoQIUENwcNyPETlfS7fU=;
        b=tyLUG+bF+c4MBlPxkP0ILpiTFZiualTP+VmkX7Fb/pxzusKjZLt7wZTHx9OROHK5Os
         Sdg9jZ+yZDIXjx32FEWBtIU6rz+vDexVs0/QxYgS7HChRYb2OfnZYtB4tvC/2s51ZRLC
         PgPQSeIP+yBsGihs669dUCPFWqSb5cytKKPlqxFi3Vdb8NYywT20o1e2luQ6o9fcVNUf
         uL6OqAFNlUgqT0qmDpPJEzUEYXHDYikpnoiRSLdvFIqqAY89F2N/GSpzNF91bfDLyYI7
         zoOOgLS7ctxTpGVo9MvGscyWu7lsS611G7XUfpCHrZ7fqi+kYkcFKypKdH6zbFrvMaTu
         5LlA==
X-Gm-Message-State: APjAAAWIgTpXjpZ/KU/uTan6J+ILQX7J24jzwWAp/NEENV0rTXOpeQ/p
        ld57swf8RVrRXSIRzaWw6Yr3rrEIq279Jumq8wE=
X-Google-Smtp-Source: APXvYqy/gnffCmgt2jJTKy6Gr8N+EK2KyGkJCilmqHqxTdAB2DDpDC2Yx3nJC/JcHfFIUJw68YBSZGH85FgG/jF7Qw4=
X-Received: by 2002:a2e:9695:: with SMTP id q21mr12014562lji.105.1570880540837;
 Sat, 12 Oct 2019 04:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-2-ap420073@gmail.com>
 <20191010101925.GA93190@bistromath.localdomain>
In-Reply-To: <20191010101925.GA93190@bistromath.localdomain>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sat, 12 Oct 2019 20:42:09 +0900
Message-ID: <CAMArcTWEbH5=UKRSrw0-QR+dyT2GCJf3sjUA=eKVOEUJ3Wj8gQ@mail.gmail.com>
Subject: Re: [PATCH net v4 01/12] net: core: limit nested device depth
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 at 19:19, Sabrina Dubroca <sd@queasysnail.net> wrote:
>

Hi Sabrina,

Thank you for review and testing!

> 2019-09-28, 16:48:32 +0000, Taehee Yoo wrote:
> > @@ -6790,23 +6878,45 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
> >                                       void *data),
> >                             void *data)
> >  {
> > -     struct net_device *ldev;
> > -     struct list_head *iter;
> > -     int ret;
> > +     struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
> > +     struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
> > +     int ret, cur = 0;
> >
> > -     for (iter = &dev->adj_list.lower,
> > -          ldev = netdev_next_lower_dev(dev, &iter);
> > -          ldev;
> > -          ldev = netdev_next_lower_dev(dev, &iter)) {
> > -             /* first is the lower device itself */
> > -             ret = fn(ldev, data);
> > -             if (ret)
> > -                     return ret;
> > +     now = dev;
> > +     iter = &dev->adj_list.lower;
> >
> > -             /* then look at all of its lower devices */
> > -             ret = netdev_walk_all_lower_dev(ldev, fn, data);
> > -             if (ret)
> > -                     return ret;
> > +     while (1) {
> > +             if (now != dev) {
> > +                     ret = fn(now, data);
> > +                     if (ret)
> > +                             return ret;
> > +             }
> > +
> > +             next = NULL;
> > +             while (1) {
> > +                     ldev = netdev_next_lower_dev(now, &iter);
> > +                     if (!ldev)
> > +                             break;
> > +
> > +                     if (!next) {
> > +                             next = ldev;
> > +                             niter = &ldev->adj_list.lower;
> > +                     } else {
> > +                             dev_stack[cur] = ldev;
> > +                             iter_stack[cur++] = &ldev->adj_list.lower;
> > +                             break;
> > +                     }
> > +             }
> > +
> > +             if (!next) {
> > +                     if (!cur)
> > +                             return 0;
>
> Hmm, I don't think this condition is correct.
>
> If we have this topology:
>
>
>                 bridge0
>                 /  |  \
>                /   |   \
>               /    |    \
>         dummy0   vlan1   vlan2
>                    |       \
>                  dummy1    dummy2
>
> We end up with the expected lower/upper levels for all devices:
>
>     | device  | upper | lower |
>     |---------+-------+-------|
>     | dummy0  |     2 |     1 |
>     | dummy1  |     3 |     1 |
>     | dummy2  |     3 |     1 |
>     | vlan1   |     2 |     2 |
>     | vlan2   |     2 |     2 |
>     | bridge0 |     1 |     3 |
>
>
> If we then add macvlan0 on top of bridge0:
>
>
>                 macvlan0
>                    |
>                    |
>                 bridge0
>                 /  |  \
>                /   |   \
>               /    |    \
>         dummy0   vlan1   vlan2
>                    |       \
>                  dummy1    dummy2
>
>
> we can observe that __netdev_update_upper_level is only called for
> some of the devices under bridge0. I added a perf probe:
>
>  # perf probe -a '__netdev_update_upper_level dev->name:string'
>
> which gets hit for bridge0 (called directly by
> __netdev_upper_dev_link) and then dummy0, vlan1, dummy1. It is never
> called for vlan2 and dummy2.
>
> After this, we have the following levels (*):
>
>     | device   | upper | lower |
>     |----------+-------+-------|
>     | dummy0   |     3 |     1 |
>     | dummy1   |     4 |     1 |
>     | dummy2   |     3 |     1 |
>     | vlan1    |     3 |     2 |
>     | vlan2    |     2 |     2 |
>     | bridge0  |     2 |     3 |
>     | macvlan0 |     1 |     4 |
>
> For dummy0, dummy1, vlan1, the upper level has increased by 1, as
> expected. For dummy2 and vlan2, it's still the same, which is wrong.
>
>
> (*) observed easily by adding another probe:
>
>  # perf probe -a 'dev_get_stats dev->name:string dev->upper_level dev->lower_level'
>
> and running "ip link"
>
> Or you can just add prints and recompile, of course :)
>

Thank you so much, I found a bug very easily with your test config.
I will fix this bug in a v5 patch.

> > +                     next = dev_stack[--cur];
> > +                     niter = iter_stack[cur];
> > +             }
> > +
> > +             now = next;
> > +             iter = niter;
> >       }
> >
> >       return 0;
>
> --
> Sabrina

Thank you,
Taehee Yoo
