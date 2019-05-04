Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D53E13C0D
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 22:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfEDUOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 16:14:35 -0400
Received: from ja.ssi.bg ([178.16.129.10]:60612 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727037AbfEDUOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 16:14:34 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x44KDjGe008868;
        Sat, 4 May 2019 23:13:48 +0300
Date:   Sat, 4 May 2019 23:13:45 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ipv4: Delete uncached routes upon unregistration of
 loopback device.
In-Reply-To: <519ea12b-4c24-9e8e-c5eb-ca02c9c7d264@i-love.sakura.ne.jp>
Message-ID: <alpine.LFD.2.21.1905042115250.6546@ja.home.ssi.bg>
References: <0000000000007d22100573d66078@google.com> <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg> <4684eef5-ea50-2965-86a0-492b8b1e4f52@I-love.SAKURA.ne.jp> <9d430543-33c3-0d9b-dc77-3a179a8e3919@I-love.SAKURA.ne.jp> <920ebaf1-ee87-0dbb-6805-660c1cbce3d0@I-love.SAKURA.ne.jp>
 <cc054b5c-4e95-8d30-d4bf-9c85f7e20092@gmail.com> <15b353e9-49a2-f08b-dc45-2e9bad3abfe2@i-love.sakura.ne.jp> <057735f0-4475-7a7b-815f-034b1095fa6c@gmail.com> <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp> <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
 <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com> <117fcc49-d389-c389-918f-86ccaef82e51@i-love.sakura.ne.jp> <70be7d61-a6fe-e703-978a-d17f544efb44@gmail.com> <40199494-8eb7-d861-2e3b-6e20fcebc0dc@i-love.sakura.ne.jp>
 <519ea12b-4c24-9e8e-c5eb-ca02c9c7d264@i-love.sakura.ne.jp>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Sat, 4 May 2019, Tetsuo Handa wrote:

> syzbot is hitting infinite loop when a loopback device in a namespace is
> unregistered [1]. This is because rt_flush_dev() is moving the refcount of
> "any device to unregister" to "a loopback device in that namespace" but
> nobody can drop the refcount moved from non loopback devices when the
> loopback device in that namespace is unregistered.
> 
> This behavior was introduced by commit caacf05e5ad1abf0 ("ipv4: Properly
> purge netdev references on uncached routes.") but there is no description
> why we have to temporarily move the refcount to "a loopback device in that
> namespace" and why it is safe to do so, for rt_flush_dev() becomes a no-op
> when "a loopback device in that namespace" is about to be unregistered.
> 
> Since I don't know the reason, this patch breaks the infinite loop by
> deleting the uncached route (which eventually drops the refcount via
> dst_destroy()) when "a loopback device in that namespace" is unregistered
> rather than when "non-loopback devices in that namespace" is unregistered.

	There is one simple rule: code that holds device references should
catch device events and to put the references. This should happen
not after the NETDEV_UNREGISTER event.

	But there are users such as dsts that have longer life because
there are other objects that can hold dsts - sockets, for example.
Sockets can hold dst as result of route resolving (sk_dst_cache) and to 
reuse it as long as it is valid. And many sockets can point to same dst.
Obviously, socket can be idle while device disappears. We do not
propagate device events to every socket. What we do is to mark the dst
entry as invalid and to drop its dev reference. So, the problem can be
noticed on next sending when the cached dst is revalidated. As the dst 
entry is marked as obsolete, it will be dropped.

	What you see in rt_flush_dev() is that the IPv4 route subsystem
drops its dev references at the right time. Why net->loopback_dev ?
Because we prefer the leaked dsts to prevent netns to be released, so
that we have more info where is the problem. If we account the leaks
to init netns, nobody will notice them. These are leaks that missed
many cleanup steps: device events and even net-exit events. If you
see "lo" in error messages, it is more likely a dst leak, i.e.
we got a dst reference but dst_release() was not called before netns
cleanup. In such case you need to track not the dev references but the
dst references. If another device is shown, it is not a dst leak
but some dev leak (dev_put not called).

> [1] https://syzkaller.appspot.com/bug?id=bae9a2236bfede42cf3d219e6bf6740c583568a4
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Reported-by: syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>
> ---
>  net/ipv4/route.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 6fdf1c195d8e..7e865c11d4f3 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1522,15 +1522,21 @@ void rt_flush_dev(struct net_device *dev)
>  {
>  	struct net *net = dev_net(dev);
>  	struct rtable *rt;
> +	struct rtable *tmp;
>  	int cpu;
>  
>  	for_each_possible_cpu(cpu) {
>  		struct uncached_list *ul = &per_cpu(rt_uncached_list, cpu);
>  
>  		spin_lock_bh(&ul->lock);
> -		list_for_each_entry(rt, &ul->head, rt_uncached) {
> +		list_for_each_entry_safe(rt, tmp, &ul->head, rt_uncached) {
>  			if (rt->dst.dev != dev)
>  				continue;
> +			if (dev == net->loopback_dev) {
> +				list_del_init(&rt->rt_uncached);
> +				ip_rt_put(rt);
> +				continue;
> +			}
>  			rt->dst.dev = net->loopback_dev;
>  			dev_hold(rt->dst.dev);
>  			dev_put(dev);
> -- 
> 2.17.1

Regards

--
Julian Anastasov <ja@ssi.bg>
