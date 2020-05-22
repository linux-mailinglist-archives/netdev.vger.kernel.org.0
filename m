Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CC61DDF8A
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgEVFzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbgEVFzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:55:23 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496A9C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:55:23 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id r128so4055686ybc.6
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GdPtBZeZrdObbWqGEAlxB3HXs3EQW8gfEPKLjC1zUvI=;
        b=AwBxdyM/KigdelreQh3xgXtU1e9eNMAq1CvkDBdfrDp5uvNv//ZPCs7JiAwgMlwfJM
         EkjaYdwIny27WoArc7nmYd2PKtNGafmft728b9zY89MZhHz6NP2tLsYK2eIE3BgkyPE+
         dEhRYx82oHHTDq8vpOI5wfxIbzzp5SiJk7Dh5xvPy5tWV/RfL60Din+49fo0sJ2U1fvY
         vz6rraaQFGVDzEC9cUlbUEWL5z5uAc91/ew60ndncE/Mdgi4kJfAA5fRSkTSp2eWNObu
         +z4hBsjva7tjFxtEUeGFDDySq/2Xo2oD48RXwEJ7LamiU505tBke1Czhg51+uxpa1DU0
         P45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GdPtBZeZrdObbWqGEAlxB3HXs3EQW8gfEPKLjC1zUvI=;
        b=tPvzc/R7pw6QyBzodxxJsFWpscXjjiyaPoerMo8zDJZzZ5kfU75cG28MYikTBqElsC
         nro26CXOL4HzrCqCNgRDIp1GuxPhaCFK+Ox4y1cRQh4F0se6Wxv7b5HZURgD0SfhH22/
         CA9yPJmKEcebF8SHoloRylJHP3g8thF94tZwPPyEbeDo9vCB8rhb0LkGfpQlHZVhAhrq
         fgIzilkCjev9rX6WOdnbHqkgN05g6fKRSWG8u46b6e4gHQqgrWkDYj0c+wDIegc/NjoQ
         yl/MYnZ6KT2H9ersNumy+HgeFNpiWLHP23za0oZxJq6RwjwNOLx3Zw7++qgPjtUcPMCh
         V03Q==
X-Gm-Message-State: AOAM531WG0ingsKqeQTPHSCAzaiy879UVd3dkJYPTk51QgUhzVtmZIo1
        rfRnfLOAlM+1BQgs01wFOCroVP285jMDw4h6C8OULQ==
X-Google-Smtp-Source: ABdhPJx5mNPVHk0LqZF9JuGh/UfUBOV+Ey39KF3gp0Em4qzB2vOlDSwDIl/VZuvhI+rYabAaTfF9r/817c8zHvrQEOo=
X-Received: by 2002:a25:2504:: with SMTP id l4mr675625ybl.408.1590126922311;
 Thu, 21 May 2020 22:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200521182958.163436-1-edumazet@google.com> <CADvbK_cdSYZvTj6jFCXHEU0VhD8K7aQ3ky_fvUJ49N-5+ykJkg@mail.gmail.com>
 <CANn89i+x=xbXoKekC6bF_ZMBRMY_mkmuVbNSW3LcRncsiZGd_g@mail.gmail.com>
In-Reply-To: <CANn89i+x=xbXoKekC6bF_ZMBRMY_mkmuVbNSW3LcRncsiZGd_g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 May 2020 22:55:11 -0700
Message-ID: <CANn89iJVSb3BWO=VGRX0KkvrxZ7=ZYaK6HwsexK8y+4NJqXopA@mail.gmail.com>
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Xin Long <lucien.xin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resend to the list in non HTML form


On Thu, May 21, 2020 at 10:53 PM Eric Dumazet <edumazet@google.com> wrote:
>
>
>
> On Thu, May 21, 2020 at 10:50 PM Xin Long <lucien.xin@gmail.com> wrote:
>>
>> On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
>> >
>> > dst_cache_get() documents it must be used with BH disabled.
>> Interesting, I thought under rcu_read_lock() is enough, which calls
>> preempt_disable().
>
>
> rcu_read_lock() does not disable BH, never.
>
> And rcu_read_lock() does not necessarily disable preemption.
>
>
>>
>> have you checked other places where dst_cache_get() are used?
>
>
>
> Yes, other paths are fine.
>
>>
>>
>> >
>> > sysbot reported :
>> >
>> > BUG: using smp_processor_id() in preemptible [00000000] code: /21697
>> > caller is dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
>> > CPU: 0 PID: 21697 Comm:  Not tainted 5.7.0-rc6-syzkaller #0
>> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> > Call Trace:
>> >  __dump_stack lib/dump_stack.c:77 [inline]
>> >  dump_stack+0x188/0x20d lib/dump_stack.c:118
>> >  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
>> >  debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
>> >  dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
>> >  tipc_udp_xmit.isra.0+0xb9/0xad0 net/tipc/udp_media.c:164
>> >  tipc_udp_send_msg+0x3e6/0x490 net/tipc/udp_media.c:244
>> >  tipc_bearer_xmit_skb+0x1de/0x3f0 net/tipc/bearer.c:526
>> >  tipc_enable_bearer+0xb2f/0xd60 net/tipc/bearer.c:331
>> >  __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
>> >  tipc_nl_bearer_enable+0x1e/0x30 net/tipc/bearer.c:1003
>> >  genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
>> >  genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
>> >  genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
>> >  netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
>> >  genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
>> >  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>> >  netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
>> >  netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
>> >  sock_sendmsg_nosec net/socket.c:652 [inline]
>> >  sock_sendmsg+0xcf/0x120 net/socket.c:672
>> >  ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
>> >  ___sys_sendmsg+0x100/0x170 net/socket.c:2416
>> >  __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
>> >  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>> >  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>> > RIP: 0033:0x45ca29
>> >
>> > Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
>> > Cc: Xin Long <lucien.xin@gmail.com>
>> > Cc: Jon Maloy <jon.maloy@ericsson.com>
>> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>> > Reported-by: syzbot <syzkaller@googlegroups.com>
>> > ---
>> >  net/tipc/udp_media.c | 6 +++++-
>> >  1 file changed, 5 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
>> > index d6620ad535461a4d04ed5ba90569ce8b7df9f994..28a283f26a8dff24d613e6ed57e5e69d894dae66 100644
>> > --- a/net/tipc/udp_media.c
>> > +++ b/net/tipc/udp_media.c
>> > @@ -161,9 +161,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
>> >                          struct udp_bearer *ub, struct udp_media_addr *src,
>> >                          struct udp_media_addr *dst, struct dst_cache *cache)
>> >  {
>> > -       struct dst_entry *ndst = dst_cache_get(cache);
>> > +       struct dst_entry *ndst;
>> >         int ttl, err = 0;
>> >
>> > +       local_bh_disable();
>> > +       ndst = dst_cache_get(cache);
>> >         if (dst->proto == htons(ETH_P_IP)) {
>> >                 struct rtable *rt = (struct rtable *)ndst;
>> >
>> > @@ -210,9 +212,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
>> >                                            src->port, dst->port, false);
>> >  #endif
>> >         }
>> > +       local_bh_enable();
>> >         return err;
>> >
>> >  tx_error:
>> > +       local_bh_enable();
>> >         kfree_skb(skb);
>> >         return err;
>> >  }
>> > --
>> > 2.27.0.rc0.183.gde8f92d652-goog
>> >
