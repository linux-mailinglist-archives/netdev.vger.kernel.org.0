Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D39026F8A3
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 10:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgIRItO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 04:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgIRItM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 04:49:12 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E184BC06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 01:49:11 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so5970897iol.10
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 01:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zd1jhv/T3kcDC553A5pAypkXnK/ZBy2X+jzUifOaM48=;
        b=AyuvtH0RwjdMZ5Tl6te/gkgk6AO0aLBpflUi2nwFEzXkajFqLz7dtn7ATziE8T+xya
         BldPcMnBXe5OYziY0u90Uqf1Ut6w9IGmai7svZh8RUrgiTdF+XvehWVWXweFPa1iVpHq
         00R4yp8QfAjoLGjtFVNO2SDnhVHmtAQbGFQEJdyKMUGIZL0LW95dRIoHW/4QcejRyH8T
         30tLjHHSPV4XRH8/C+S+9R/jymO7kC2ME+jD4SKtB76272pacplDpQ4Z3Fg5R73zzg4t
         DvZp1Hjor1z32CgyJ5izRiFyGl41/jxx+G9fqJqN7YvSvoEYbft9pWzJgmpLn69JXS6K
         Kuhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zd1jhv/T3kcDC553A5pAypkXnK/ZBy2X+jzUifOaM48=;
        b=fP9Yzzr5T7mCxikgRKcy/Dq/mHrnJcGTPui1wQ0mH6zoz9qsra2HqQPbWBkMWK56Hw
         E44jdqEuNZWX729p9jUCx4bWddK6ncU1JxJ4Ml7GUmHzKANSGHL19VjQ1uDy8Q3fsAaS
         b302mivFxbhZ/4LhFA0O4LfLAi4txbSF3P0mzpH/34fyf8ljxUzH6GM9WIWy9mK6QsCb
         D5lMeWVYaQrNl4UIpCi8YUwg7AsTHVsmKzJoGORF4BVFZbrSMncP22JOzFW/JQ44yK5k
         QIqDFfSriyWhGN3309fx61xbxrgJjsbLdOevW+y/juGs3QtJ05IZl1+GSVigSgbiyaaQ
         HKnQ==
X-Gm-Message-State: AOAM533oms3FFOvdUxIprB4WMcu9+FCvi7850fZaUYoR5sEz0MVMK/Jk
        npxXb/gY5gXTE8s1jONHa4vLqO6nUQMxcoo+QK0JTw==
X-Google-Smtp-Source: ABdhPJxOCGq/PtoZytYf2+juQY2pZPQJv5wiBFxOJUlDdtxITb6spucxCaiOSdA4h7cxwfMvqVhNRfessxTzuWdhcNA=
X-Received: by 2002:a6b:b386:: with SMTP id c128mr26156023iof.157.1600418950960;
 Fri, 18 Sep 2020 01:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200917234953.CB1D295C0A69@us180.sjc.aristanetworks.com>
In-Reply-To: <20200917234953.CB1D295C0A69@us180.sjc.aristanetworks.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 18 Sep 2020 10:48:59 +0200
Message-ID: <CANn89iJCm9Rw2U1bK9hAQAzdwebggsWh0DFkHpJF=4OZ2JiSOw@mail.gmail.com>
Subject: Re: [PATCH v3] net: use exponential backoff in netdev_wait_allrefs
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 1:49 AM Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> The combination of aca_free_rcu, introduced in commit 2384d02520ff
> ("net/ipv6: Add anycast addresses to a global hashtable"), and
> fib6_info_destroy_rcu, introduced in commit 9b0a8da8c4c6 ("net/ipv6:
> respect rcu grace period before freeing fib6_info"), can result in
> an extra rcu grace period being needed when deleting an interface,
> with the result that netdev_wait_allrefs ends up hitting the msleep(250),
> which is considerably longer than the required grace period.
> This can result in long delays when deleting a large number of interfaces,
> and it can be observed with this script:
>
> ns=dummy-ns
> NIFS=100
>
> ip netns add $ns
> ip netns exec $ns ip link set lo up
> ip netns exec $ns sysctl net.ipv6.conf.default.disable_ipv6=0
> ip netns exec $ns sysctl net.ipv6.conf.default.forwarding=1
>
> for ((i=0; i<$NIFS; i++))
> do
>         if=eth$i
>         ip netns exec $ns ip link add $if type dummy
>         ip netns exec $ns ip link set $if up
>         ip netns exec $ns ip -6 addr add 2021:$i::1/120 dev $if
> done
>
> for ((i=0; i<$NIFS; i++))
> do
>         if=eth$i
>         ip netns exec $ns ip link del $if
> done
>
> ip netns del $ns
>
> This patch uses exponential backoff instead of the fixed msleep(250)
> to get out of the loop faster.
>
> Time with this patch on a 5.4 kernel:
>
> real    0m8.199s
> user    0m0.402s
> sys     0m1.213s
>
> Time without this patch:
>
> real    0m31.522s
> user    0m0.438s
> sys     0m1.156s
>
> v2: use exponential backoff instead of trying to wake up
>     netdev_wait_allrefs.
> v3: preserve reverse christmas tree ordering of local variables
>
> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
> ---
>  net/core/dev.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 4086d335978c..e5fa60cb8832 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9986,9 +9986,12 @@ EXPORT_SYMBOL(netdev_refcnt_read);
>   * We can get stuck here if buggy protocols don't correctly
>   * call dev_put.
>   */
> +#define MIN_MSLEEP     ((unsigned int)16)
> +#define MAX_MSLEEP     ((unsigned int)250)


No need for a cast, also I would use names less likely to collide with
include files, and I would start at 1 ms.

#define WAIT_REFS_MIN_MSECS 1
#define WAIT_REFS_MAX_MSECS 250

>
>  static void netdev_wait_allrefs(struct net_device *dev)
>  {
>         unsigned long rebroadcast_time, warning_time;
> +       unsigned int wait = MIN_MSLEEP;


int wait =  WAIT_REFS_MIN_MSECS;

>
>         int refcnt;
>
>         linkwatch_forget_dev(dev);
> @@ -10023,7 +10026,8 @@ static void netdev_wait_allrefs(struct net_device *dev)
>                         rebroadcast_time = jiffies;
>                 }
>
> -               msleep(250);
> +               msleep(wait);
> +               wait = min(wait << 1, MAX_MSLEEP);



wait = min(wait << 1,  WAIT_REFS_MAX_MSECS);

>
>
>                 refcnt = netdev_refcnt_read(dev);
>
> --
> 2.28.0



Also, I would try using synchronize_rcu() instead of the first
msleep(), this might avoid all msleep() calls in your case.

Patch without the macros to see the general idea :

diff --git a/net/core/dev.c b/net/core/dev.c
index 266073e300b5fc21440ea8f8ffc9306a1fc9f370..2d3b65034bc0dd99017dea846e6c0a966f1207ee
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9989,7 +9989,7 @@ EXPORT_SYMBOL(netdev_refcnt_read);
 static void netdev_wait_allrefs(struct net_device *dev)
 {
        unsigned long rebroadcast_time, warning_time;
-       int refcnt;
+       int wait = 0, refcnt;

        linkwatch_forget_dev(dev);

@@ -10023,8 +10023,13 @@ static void netdev_wait_allrefs(struct net_device *dev)
                        rebroadcast_time = jiffies;
                }

-               msleep(250);
-
+               if (!wait) {
+                       synchronize_rcu();
+                       wait = 1;
+               } else {
+                       msleep(wait);
+                       wait = min(wait << 1, 250);
+               }
                refcnt = netdev_refcnt_read(dev);

                if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
