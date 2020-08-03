Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8BA23B0E6
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgHCX2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgHCX2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:28:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B5EC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 16:28:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k2jsS-00073E-00; Tue, 04 Aug 2020 01:28:20 +0200
Date:   Tue, 4 Aug 2020 01:28:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@gmail.com>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] Support PMTU discovery with bridged UDP
 tunnels
Message-ID: <20200803232819.GA26394@breakpoint.cc>
References: <cover.1596487323.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1596487323.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> Currently, PMTU discovery for UDP tunnels only works if packets are
> routed to the encapsulating interfaces, not bridged.
> 
> This results from the fact that we generally don't have valid routes
> to the senders we can use to relay ICMP and ICMPv6 errors, and makes
> PMTU discovery completely non-functional for VXLAN and GENEVE ports of
> both regular bridges and Open vSwitch instances.
> 
> If the sender is local, and packets are forwarded to the port by a
> regular bridge, all it takes is to generate a corresponding route
> exception on the encapsulating device. The bridge then finds the route
> exception carrying the PMTU value estimate as it forwards frames, and
> relays ICMP messages back to the socket of the local sender. Patch 1/6
> fixes this case.
> 
> If the sender resides on another node, we actually need to reply to
> IP and IPv6 packets ourselves and send these ICMP or ICMPv6 errors
> back, using the same encapsulating device. Patch 2/6, based on an
> original idea by Florian Westphal, adds the needed functionality,
> while patches 3/6 and 4/6 add matching support for VXLAN and GENEVE.
> 
> Finally, 5/6 and 6/6 introduce selftests for all combinations of
> inner and outer IP versions, covering both VXLAN and GENEVE, with
> both regular bridges and Open vSwitch instances.

Thanks for taking over and brining this into shape, this looks good to
me.

Given such setups will become easily get stuck on first pmtu update
it would be good to get this applied now, even tough merge window is
already open.
