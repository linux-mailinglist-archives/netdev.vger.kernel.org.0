Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3023654AF
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhDTJAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 05:00:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230395AbhDTJAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 05:00:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618909171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQNwhVkkaZObnFoWv4+nPG4vP7khiFdr6z5Ab4j9o/Q=;
        b=WkrEMTtTY1MS1OctgcGO2kx7/0OxfhxdNzpAsGRhoIPT3HskMEypuTnBFmFK100jNYxI3W
        QalNbGmgmeHMLc3Bh/gzeJTb/99Axeihhf64qhdkrRVKPC1VM7WnjaD/QpPinv42369yLC
        PUQreRabN0BtNsT9XPpNeNUazHau1OI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-L6n9_oQzPlSRqFnIZZEy0w-1; Tue, 20 Apr 2021 04:59:18 -0400
X-MC-Unique: L6n9_oQzPlSRqFnIZZEy0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA44B83DD26;
        Tue, 20 Apr 2021 08:59:16 +0000 (UTC)
Received: from [10.40.195.0] (unknown [10.40.195.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D23571280;
        Tue, 20 Apr 2021 08:59:14 +0000 (UTC)
Message-ID: <d16e3e5ade2a01ea4404c79abcc86b7d9868f611.camel@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: sch_frag: fix stack OOB read while
 fragmenting IPv4 packets
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
In-Reply-To: <CAM_iQpW3SPXJWeLf3Ck4QHZxetDuYcQJDFChUje3-4By8oGfnA@mail.gmail.com>
References: <cover.1618844973.git.dcaratti@redhat.com>
         <80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com>
         <CAM_iQpW3SPXJWeLf3Ck4QHZxetDuYcQJDFChUje3-4By8oGfnA@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Tue, 20 Apr 2021 10:59:13 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Cong, thanks for looking at this!

On Mon, 2021-04-19 at 11:46 -0700, Cong Wang wrote:
> On Mon, Apr 19, 2021 at 8:24 AM Davide Caratti <dcaratti@redhat.com> wrote:
> > diff --git a/net/sched/sch_frag.c b/net/sched/sch_frag.c
> > index e1e77d3fb6c0..8c06381391d6 100644
> > --- a/net/sched/sch_frag.c
> > +++ b/net/sched/sch_frag.c
> > @@ -90,16 +90,16 @@ static int sch_fragment(struct net *net, struct sk_buff *skb,
> >         }
> > 
> >         if (skb_protocol(skb, true) == htons(ETH_P_IP)) {
> > -               struct dst_entry sch_frag_dst;
> > +               struct rtable sch_frag_rt = { 0 };
> 
> Is setting these fields 0 sufficient here? Because normally a struct table
> is initialized by rt_dst_alloc() which sets several of them to non-zero,
> notably, rt->rt_type and rt->rt_uncached.
> 
> Similar for the IPv6 part, which is initialized by rt6_info_init().

for what we do now in openvswitch and sch_frag, that should be
sufficient: a similar thing is done by br_netfilter [1], apparently for
the same "refragmentation" purposes. On a fedora host (running 5.10, but
it shouldn't be much different than current Linux), I just dumped
'fake_rtable' from a bridge device:

# ip link add name test-br0 type bridge
# ip link set dev test-br0 up
# ip link add name test-port0 type dummy
# ip link set dev test-port0 master test-br0 up
# crash 
[...]
crash> net                                                             
   NET_DEVICE     NAME   IP ADDRESS(ES)
[...]
ffff89fb44ed8000  test-br0
ffff89fbfc45c000  test-port0
crash> p sizeof(struct net_device)
$12 = 3200
crash> p ((struct net_bridge*)(0xffff89fb44ed8000 + 3200))->fake_rtable
$13 = {
  dst = {
    dev = 0xffff89fb44ed8000, 
    ops = 0xffffffffc0afef40, 
    _metrics = 18446744072647256257, 
    expires = 0, 
    xfrm = 0x0, 
    input = 0x0, 
    output = 0x0, 
    flags = 18, <-- that should be DST_NOXFRM | DST_FAKE_RTABLE
    obsolete = 0, 
    header_len = 0, 
    trailer_len = 0, 
    __refcnt = {
      counter = 1
    }, 
    __use = 0, 
    lastuse = 0, 
    lwtstate = 0x0, 
    callback_head = {
      next = 0x0, 
      func = 0x0
    }, 
    error = 0, 
    __pad = 0, 
    tclassid = 0
  }, 
  rt_genid = 0, 
  rt_flags = 0, 
  rt_type = 0, 
  rt_is_input = 0 '\000', 
  rt_uses_gateway = 0 '\000', 
  rt_iif = 0, 
  rt_gw_family = 0 '\000', 
  {
    rt_gw4 = 0, 
    rt_gw6 = {
      in6_u = {
        u6_addr8 = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000", 
        u6_addr16 = {0, 0, 0, 0, 0, 0, 0, 0}, 
        u6_addr32 = {0, 0, 0, 0}
      }
    }
  }, 
  rt_mtu_locked = 0, 
  rt_pmtu = 0, 
  rt_uncached = {
    next = 0x0, 
    prev = 0x0
  }, 
  rt_uncached_list = 0x0                                               
}                 

only fake_rtable.dst members are set to something, the remaining are all zero-ed.

-- 
davide

[1] https://elixir.bootlin.com/linux/latest/source/net/bridge/br_nf_core.c#L62


