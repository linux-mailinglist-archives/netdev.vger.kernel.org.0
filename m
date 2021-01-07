Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBF72ED050
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 14:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbhAGM7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 07:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbhAGM7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 07:59:31 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FA1C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 04:58:51 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w17so6555234ilj.8
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 04:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xoWEphDA+teEz7BuakbZJOyxt6nkfAS+aAb4L2b6YI=;
        b=NR/fRL5ZB/dyA+Dbf7g77xmkeA0UPo/E6NdycefWs1aH8bJSg0tKhX/wqLb5mh+Car
         h0yUvgoIQ3iprnDzAonho+ygEgXWDwPz7WaWfZf5vzbyIfBdiSIuIxhkU0J1N4B/40N8
         1lcqS3ueOfuVdB8wqnBmwIhud7UPfWLtALufJeMUh/tMpaFbQhhR4dViusduEY0KLkk+
         vTsRUQeqUJytqs4JhjPFTRu67WCwznPhzh0ngc1tbl9/Dz4ByeSpPtfFlowSqTVCLPhe
         AWFeKth0yVGTcrz8gguF4g4eOJXiZvUbqU7OL2zyMSL7N4XZPUXXPz7sYtm2h3CqAzI2
         pWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xoWEphDA+teEz7BuakbZJOyxt6nkfAS+aAb4L2b6YI=;
        b=Xb5fcdPltnICl1ED4+JIRM+pJebn0VsPaetiFxdzlbfJ5WnHW5PNqKLO+MbB/yXu32
         5Fj9Rtq97UBnG7tcLX+zxU2jE5P2EGDzkoFERjfq8h22h488V7L3cuf9iyd0UysGVcpP
         mp2bOIG4TxyNqnAXg9fBI4SWPGfIYHzMUPB8Onzis2p9guHT35U5eAn1RLUJZTwWdutm
         x+g6vCy46PWxJ4dFYJ0MuJghz0UWFfPP92DP69Ce62kCjQb1rhis3MQE4I0BKI/6V6uR
         4l9FODuiTTpLdGeUdOw5ujKkf96077r+tn3Do8KJBvhyZ2qQHiyjqY4OTzUyDgsIsrUo
         cfGw==
X-Gm-Message-State: AOAM530ohiix5Xg9xMiBBVMTzDGWjI2vgN8W7P7pGtoBMzGWMCeHlVFL
        PqlOjGv6DwZmhsydPbojXmk4EdG53dknB96rdI/eWA==
X-Google-Smtp-Source: ABdhPJxROc8n8/oKJIjPbYPRUo1hy5rw7kjCoxvmO/0f6sWIGEzcQQSBENt1jX4/tn3bwB09yJQVUO14eHHQgAWgvaU=
X-Received: by 2002:a92:9f59:: with SMTP id u86mr8870875ili.205.1610024330229;
 Thu, 07 Jan 2021 04:58:50 -0800 (PST)
MIME-Version: 1.0
References: <20210107094951.1772183-1-olteanv@gmail.com> <20210107094951.1772183-11-olteanv@gmail.com>
 <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com> <20210107113313.q4e42cj6jigmdmbs@skbuf>
In-Reply-To: <20210107113313.q4e42cj6jigmdmbs@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Jan 2021 13:58:38 +0100
Message-ID: <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 7, 2021 at 12:33 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Jan 07, 2021 at 12:18:28PM +0100, Eric Dumazet wrote:
> > What a mess really.
>
> Thanks, that's at least _some_ feedback :)

Yeah, I was on PTO for the last two weeks.

>
> > You chose to keep the assumption that ndo_get_stats() would not fail,
> > since we were providing the needed storage from callers.
> >
> > If ndo_get_stats() are now allowed to sleep, and presumably allocate
> > memory, we need to make sure
> > we report potential errors back to the user.
> >
> > I think your patch series is mostly good, but I would prefer not
> > hiding errors and always report them to user space.
> > And no, netdev_err() is not appropriate, we do not want tools to look
> > at syslog to guess something went wrong.
>
> Well, there are only 22 dev_get_stats callers in the kernel, so I assume
> that after the conversion to return void, I can do another conversion to
> return int, and then I can convert the ndo_get_stats64 method to return
> int too. I will keep the plain ndo_get_stats still void (no reason not
> to).
>
> > Last point about drivers having to go to slow path, talking to
> > firmware : Make sure that malicious/innocent users
> > reading /proc/net/dev from many threads in parallel wont brick these devices.
> >
> > Maybe they implicitly _relied_ on the fact that firmware was gently
> > read every second and results were cached from a work queue or
> > something.
>
> How? I don't understand how I can make sure of that.

Your patches do not attempt to change these drivers, but I guess your
cover letter might send to driver maintainers incentive to get rid of their
logic, that is all.

We might simply warn maintainers and ask them to test their future changes
with tests using 1000 concurrent theads reading /proc/net/dev

>
> There is an effort initiated by Jakub to standardize the ethtool
> statistics. My objection was that you can't expect that to happen unless
> dev_get_stats is sleepable just like ethtool -S is. So I think the same
> reasoning should apply to ethtool -S too, really.

I think we all agree on the principles, once we make sure to not
add more pressure on RTNL. It seems you addressed our feedback, all is fine.

Thanks.
