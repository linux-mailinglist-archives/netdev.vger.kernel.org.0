Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86734224348
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgGQSnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQSnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:43:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149AEC0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 11:43:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jwVK5-0004ih-IK; Fri, 17 Jul 2020 20:43:05 +0200
Date:   Fri, 17 Jul 2020 20:43:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200717184305.GV32005@breakpoint.cc>
References: <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
 <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
 <20200713140219.GM32005@breakpoint.cc>
 <20200714143327.2d5b8581@redhat.com>
 <20200715124258.GP32005@breakpoint.cc>
 <20200715153547.77dbaf82@elisabeth>
 <20200715143356.GQ32005@breakpoint.cc>
 <20200717142743.6d05d3ae@elisabeth>
 <89e5ec7b-845f-ab23-5043-73e797a29a14@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89e5ec7b-845f-ab23-5043-73e797a29a14@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:
> On 7/17/20 6:27 AM, Stefano Brivio wrote:
> >> Every type of bridge port that needs to add additional header on egress
> >> has this problem in the bridge scenario once the peer of the IP tunnel
> >> signals a PMTU event.
> > 
> > Yes :(
> > 
> 
> The vxlan/tunnel device knows it is a bridge port, and it knows it is
> going to push a udp and ip{v6} header. So why not use that information
> in setting / updating the MTU? That's what I was getting at on Monday
> with my comment about lwtunnel_headroom equivalent.

What action should be taken in the vxlan driver?  Say, here:

static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb,
	u32 mtu)
{
 struct dst_entry *dst = skb_dst(skb);

 if (dst && dst->ops->update_pmtu)
    dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
 else
    /* ??? HERE */
 }

We hit the (non-existent) else branch as skb has no dst entry.
