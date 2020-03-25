Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E161B192E95
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgCYQq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:46:27 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42366 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgCYQq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:46:27 -0400
Received: by mail-yb1-f195.google.com with SMTP id s17so1516364ybk.9
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 09:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I+akRU2VhueJNYQXNmWSll18d9xFQZl/cvCmxHcTQ5I=;
        b=OSXwpd7SUNBnIvikawwt5vl4J3TeBpg39716tTK39tz7EAjA1IXzJJt2Bq0zAXQr7n
         Iz834FKEuD1HRfJ8EJXTETG3QLwP5Qe+w+neVdMFFCaCk4Hyw/AERyzvLVtgX0YQWUou
         uZ1dJ9Lsm3Y+fxyvMbMCw4K30DMH0QsOXFtGGq6cGDtwSOUACz4q0YZtMQdwSScV3p1K
         /w8hH8uAIaZyU1rXR5FpLDJdowNZDDbvOl3kKFerwM0clzr/4H9wsxMcOvy7D7ftnEOs
         6szDKRZYS0sTERYF7VNh+KLukMBUkYBTCof1iLzxC4tsmeozRqioTTulEmGAyG6dFns9
         GFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I+akRU2VhueJNYQXNmWSll18d9xFQZl/cvCmxHcTQ5I=;
        b=pJh/gCJFPl9z2aXqnc4tNnGYtcxaIfzZ9sU1zW6GxBHQZ21hsLUW8cCMzCGVyfXA6C
         Dwe+IzWyLhy/+Z/gUnZKTJ4P2mt+JQlBevBtDI2gPkZ9uRQUopBUc/qqg3T4dY68Ps78
         7WWysDXEfxuAQ87ATKiQ5e5kp6gUMHdxtmkjmX8c588/Nvsp5zCttrV6R0aZcXmcYy51
         4LqPikOjXrvfFS3cFqS88OGTEO/hlMKgBRJy/VKiOtAhHbVH/7XzXhUohtQHFCC5Kt4Z
         QE7yf1WYQAA1Kv/rwvccpokhSQKkfFvmsKOOAkuu99h4XGDbh8S+19sOGztEE7CAW77C
         9BjA==
X-Gm-Message-State: ANhLgQ3CFLJBUGNb01FgNrv24acE4GlcaZYkEFpwTsVPfJZo5i7j3Y4V
        SnpENytk0r1fpZ6lZ2Zi4sgRxaUK+neln7LcmWzLUA==
X-Google-Smtp-Source: ADFU+vt9Hn21TGPD2XPBw+Pj1xuDjDNq1RwSnwwuxMx+B5jh6oBtwG+IXAWKltmFtjW8Foo8fiZI1cTE+KI3nunZqB8=
X-Received: by 2002:a25:b7c7:: with SMTP id u7mr7159189ybj.173.1585154784685;
 Wed, 25 Mar 2020 09:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200325022321.21944-1-edumazet@google.com> <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
 <CA+FuTSdO_WBhrRj5PNdXppywDNkMKJ4hLry+3oSvy8mavnxw0g@mail.gmail.com>
 <2b5f096a143f4dea9c9a2896913d8ca79688b00f.camel@redhat.com>
 <0f5c5e35-fc51-19c3-2ce3-c8ac17887c6c@gmail.com> <7e385f0c1edca94a882bdadf46f4ddb97d59a64a.camel@redhat.com>
 <CANn89iKotU9Tkd6KBgyicHFV72K9gZ+eeKwkPU097=gZZYCjrA@mail.gmail.com>
In-Reply-To: <CANn89iKotU9Tkd6KBgyicHFV72K9gZ+eeKwkPU097=gZZYCjrA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 Mar 2020 09:46:13 -0700
Message-ID: <CANn89i+pQQe1tvZ70jyzi-6+FFDuhBpGx_D0Ni89LhbyjH+4Vg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: use indirect call wrappers for skb_copy_datagram_iter()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resend without HTML encoding


On Wed, Mar 25, 2020 at 9:41 AM Eric Dumazet <edumazet@google.com> wrote:
>
>
>
> On Wed, Mar 25, 2020 at 9:24 AM Paolo Abeni <pabeni@redhat.com> wrote:
>>
>>
>> Just out of sheer curiosity, why don't you set NET_SCH_DEFAULT?
>>
>
> Because we have boot-time scripts setting optimal configs, and since we need
> to set XPS properly to get correct NUMA allocations, we have to perform the qdisc
> allocations after some other stuff.
>
> (Look for netdev_queue_numa_node_read() calls)
>
> Also, some users still expect pfifo_fast to be used when a tun device is created :)
>
>
