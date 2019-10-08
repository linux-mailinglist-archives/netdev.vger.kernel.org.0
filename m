Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC7BCF305
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbfJHGyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:54:03 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38046 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730131AbfJHGyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 02:54:02 -0400
Received: by mail-lj1-f196.google.com with SMTP id b20so16285098ljj.5;
        Mon, 07 Oct 2019 23:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zM3giIosfgoQWz0D3Ztxbeg2hJtXoytSuhU/8Ui29xY=;
        b=hrClwW6bQURhdQAdtLH3QQvaHEvRbRkhg/qVRZhJh4zfePeHy9qhIaDOwd48ZsdZAG
         OdzX5lGqK1+vkMZdPI/NPo+MLzxYopsGe+8KJztWeTMuD5Dm2ufz1qo0Nt4EXbNOBnrR
         mMADUBLd6FehdtNLMI3wX3FE0VfrHSmBI/8u76wT07nA+oZAllRMu3slGtsk+hbQhLSW
         FwgMhp+XGfJ+K4gy7ePFm5LifD/5L1lrujfsOV7MMQERj+jIdDmmzPOWwZu+iyNnqrF/
         roTHdTdQ3lWR1dPvzsBr4gDd3dkzuV9yNDuCHhIiH7kMmGiMhkl0UqRB/5ZjRTDoenJY
         GVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zM3giIosfgoQWz0D3Ztxbeg2hJtXoytSuhU/8Ui29xY=;
        b=b9KyKpFiH6S1VcRUGLEkYW8gHwBoAI8Uk1KVCf+F++NBBHslGwYHU1KmAwPSoU4qib
         ow3erWZCgFgnttNSPRzTIuoGqpdO1NNQJ/cQlzrUF+XW5oE/VQyTmsgoluYBpxz9ga2D
         LqGk5C979BY0KcC+5fRhQZreI3yZ5sVy8xMRxhus0FZHfypMHZ4okg+CilZd6cdJmRj+
         Cc6s4k0Xnga2mECnDNWuZU/iqqTScbzqo9c0cw/dxWT4kTdGH9UIxaqR39JeD4Zggy0x
         ABgKd8WMm7eoOXL4zphU1GeGSeaq/hGQpamQ4J7b+TJKnepMXURanHTCdXdyeHeKNK43
         mf6w==
X-Gm-Message-State: APjAAAWR1rsh/Ia5XLtRR2YiGKSS8KivpXX3YlNwZG2rsku+kze3ghh1
        d/yDRVt7yvtMExyofqQE4TT0r3mt5/HzzFmyBEA=
X-Google-Smtp-Source: APXvYqzKag52UHXcZOOg2ekztLjB8OVrAesRcb6IMb3ooihDvDOMfFX6OLSwkuzUnAyTsJeTmfIlYWrW+1uZXLuxNkY=
X-Received: by 2002:a2e:1504:: with SMTP id s4mr12753917ljd.80.1570517639723;
 Mon, 07 Oct 2019 23:53:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-13-ap420073@gmail.com>
 <20191007112215.GA1288400@bistromath.localdomain>
In-Reply-To: <20191007112215.GA1288400@bistromath.localdomain>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 8 Oct 2019 15:53:48 +0900
Message-ID: <CAMArcTXi5kamtSO28SX4NdjOvHYiEYRCMARUXhdKM9UUhk78rQ@mail.gmail.com>
Subject: Re: [PATCH net v4 12/12] virt_wifi: fix refcnt leak in module exit routine
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

On Mon, 7 Oct 2019 at 20:22, Sabrina Dubroca <sd@queasysnail.net> wrote:
>

Hi Sabrina,
Thank you for the review!

> 2019-09-28, 16:48:43 +0000, Taehee Yoo wrote:
> > virt_wifi_newlink() calls netdev_upper_dev_link() and it internally
> > holds reference count of lower interface.
> >
> > Current code does not release a reference count of the lower interface
> > when the lower interface is being deleted.
> > So, reference count leaks occur.
> >
> > Test commands:
> >     ip link add dummy0 type dummy
> >     ip link add vw1 link dummy0 type virt_wifi
>
> There should also be "ip link del dummy0" in this reproducer, right?
>
> [...]
>
> > @@ -598,14 +634,24 @@ static int __init virt_wifi_init_module(void)
> >       /* Guaranteed to be locallly-administered and not multicast. */
> >       eth_random_addr(fake_router_bssid);
> >
> > +     err = register_netdevice_notifier(&virt_wifi_notifier);
> > +     if (err)
> > +             return err;
> > +
>
> Here err is 0.
>
> >       common_wiphy = virt_wifi_make_wiphy();
> >       if (!common_wiphy)
> > -             return -ENOMEM;
> > +             goto notifier;
>
> err is still 0 when we jump...
>
> >       err = rtnl_link_register(&virt_wifi_link_ops);
> >       if (err)
> > -             virt_wifi_destroy_wiphy(common_wiphy);
> > +             goto destroy_wiphy;
> >
> > +     return 0;
> > +
> > +destroy_wiphy:
> > +     virt_wifi_destroy_wiphy(common_wiphy);
> > +notifier:
> > +     unregister_netdevice_notifier(&virt_wifi_notifier);
> >       return err;
> >  }
>
> ... so now we return 0 on failure. Can you add an "err = -ENOMEM"
> before "common_wiphy = ..."?
>

You're right, I will fix this in a v5 patch!

Thanks!

> Thanks.
>
> --
> Sabrina
