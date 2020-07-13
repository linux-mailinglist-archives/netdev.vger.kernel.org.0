Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10EB721D7B8
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgGMOCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMOCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:02:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336B5C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 07:02:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1juz2B-0008E9-C5; Mon, 13 Jul 2020 16:02:19 +0200
Date:   Mon, 13 Jul 2020 16:02:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200713140219.GM32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de>
 <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
 <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:
> On 7/13/20 2:04 AM, Florian Westphal wrote:
> >> As PMTU discovery happens, we have a route exception on the lower
> >> layer for the given path, and we know that VXLAN will use that path,
> >> so we also know there's no point in having a higher MTU on the VXLAN
> >> device, it's really the maximum packet size we can use.
> > No, in the setup that prompted this series the route exception is wrong.
> 
> Why is the exception wrong and why can't the exception code be fixed to
> include tunnel headers?

I don't know.  This occurs in a 3rd party (read: "cloud") environment.
After some days, tcp connections on the overlay network hang.

Flushing the route exception in the namespace of the vxlan interface makes
the traffic flow again, i.e. if the vxlan tunnel would just use the
physical devices MTU things would be fine.

I don't know what you mean by 'fix exception code to include tunnel
headers'.  Can you elaborate?

AFAICS everyhing functions as designed, except:
1. The route exception should not exist in first place in this case
2. The route exception never times out (gets refreshed every time
   tunnel tries to send a mtu-sized packet).
3. The original sender never learns about the pmtu event

Regarding 3) I had cooked up patches to inject a new ICMP error
into the bridge input path from vxlan_err_lookup() to let the sender
know the path MTU reduction.

Unfortunately it only works with Linux bridge (openvswitch tosses the
packet).  Also, too many (internal) reviews told me they consider this
an ugly hack, so I am not too keen on continuing down that route:

https://git.breakpoint.cc/cgit/fw/net-next.git/commit/?h=udp_tun_pmtud_12&id=ca5b0af203b6f8010f1e585850620db4561baae7
