Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A6B2913BD
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 20:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439101AbgJQSyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 14:54:13 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:58689 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439068AbgJQSyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 14:54:12 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CDBy83CvqzMstg;
        Sat, 17 Oct 2020 20:54:08 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CDBxs3nTgz2xDh;
        Sat, 17 Oct 2020 20:53:53 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Sat, 17 Oct
 2020 20:53:20 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: dsa: don't pass cloned skb's to drivers xmit function
Date:   Sat, 17 Oct 2020 20:53:19 +0200
Message-ID: <2130539.dlFve3NVyK@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201017004816.q4l6cypw4fd4vu5f@skbuf>
References: <20201016200226.23994-1-ceggers@arri.de> <20201016200226.23994-2-ceggers@arri.de> <20201017004816.q4l6cypw4fd4vu5f@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201017-205359-4CDBxs3nTgz2xDh-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Saturday, 17 October 2020, 02:48:16 CEST, Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 10:02:24PM +0200, Christian Eggers wrote:
> > Ensure that the skb is not cloned and has enough tail room for the tail
> > tag. This code will be removed from the drivers in the next commits.
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > ---
> 
> Does 1588 work for you using this change, or you haven't finished
> implementing it yet? If you haven't, I would suggest finishing that
> part first.
Yes it does. Just after finishing this topic, I would to sent the patches for
PTP. Maybe I'll do it in parallel, anything but the combination of L2/E2E/SLOB
seems to work.

> The post-reallocation skb looks nothing like the one before.
> 
> Before:
> skb len=68 headroom=2 headlen=68 tailroom=186
> mac=(2,14) net=(16,-1) trans=-1
> shinfo(txflags=1 nr_frags=0 gso(size=0 type=0 segs=0))
> csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
> hash(0x9d6927ec sw=1 l4=0) proto=0x88f7 pkttype=0 iif=0
> dev name=swp2 feat=0x0x0002000000005020
> sk family=17 type=3 proto=0
> 
> After:
> skb len=68 headroom=2 headlen=68 tailroom=186
> mac=(2,16) net=(18,-17) trans=1
> shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
> csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
> hash(0x0 sw=0 l4=0) proto=0x0000 pkttype=0 iif=0
> 
> Notice how you've changed shinfo(txflags), among other things.

I get a similar output when placing the two skb_dump() calls in the current
ksz_common_xmit() code:

[ 5052.662168] old:skb len=58 headroom=2 headlen=58 tailroom=68
[ 5052.662168] mac=(2,14) net=(16,-1) trans=-1
[ 5052.662168] shinfo(txflags=1 nr_frags=0 gso(size=0 type=0 segs=0))
[ 5052.662168] csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
[ 5052.662168] hash(0x0 sw=0 l4=0) proto=0x88f7 pkttype=0 iif=0
[ 5052.676360] old:dev name=lan0 feat=0x0x0002000000005220
[ 5052.679001] old:sk family=17 type=3 proto=0
[ 5052.681140] old:skb linear:   00000000: 01 1b 19 00 00 00 52 d9 a9 5d a1 40 88 f7 01 02
[ 5052.685236] old:skb linear:   00000010: 00 2c 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5052.689342] old:skb linear:   00000020: 00 00 52 d9 a9 ff fe 5d a1 40 00 01 00 00 01 7f
[ 5052.693418] old:skb linear:   00000030: 00 00 00 00 00 00 00 00 00 00
[ 5052.696843] new:skb len=65 headroom=2 headlen=65 tailroom=61
[ 5052.696843] mac=(2,16) net=(18,-17) trans=1
[ 5052.696843] shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
[ 5052.696843] csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
[ 5052.696843] hash(0x0 sw=0 l4=0) proto=0x0000 pkttype=0 iif=0
[ 5052.711215] new:skb linear:   00000000: 01 1b 19 00 00 00 52 d9 a9 5d a1 40 88 f7 01 02
[ 5052.715305] new:skb linear:   00000010: 00 2c 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5052.719407] new:skb linear:   00000020: 00 00 52 d9 a9 ff fe 5d a1 40 00 01 00 00 01 7f
[ 5052.723484] new:skb linear:   00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5052.727587] new:skb linear:   00000040: 00


Note that whilst some skb members differ, the two hexdumps look correct.

> Which proves that you can't just copy&paste whatever you found in
> tag_trailer.c.
I did. tag_trailer and tag_ksz are quite similar here, so I took a combination of them.

> I am not yet sure whether there is any helper that can be used instead
> of this crazy open-coding. Right now, not having tested anything yet, my
> candidates of choice would be pskb_expand_head or __pskb_pull_tail. You
> should probably also try to cater here for the potential reallocation
> done in the skb_cow_head() of non-tail taggers. Which would lean the
> balance towards pskb_expand_head(), I believe.
The "open coding" is from the existing code (which doesn't say that it is
correct). I will investigate why the copied skb is different and whether 
psk_expand_head can do better.

I don't like to touch the non-tail taggers, this is too much out of the scope
of my current work.

> Also, if the result is going to be longer than ~20 lines of code, I
> strongly suggest moving the reallocation to a separate function so you
> don't clutter dsa_slave_xmit.
As Florian requested I'll likely put the code into a separate function in
slave.c and call it from the individual tail-taggers in order not to put 
extra conditionals in dsa_slave_xmit.

regards
Christian



