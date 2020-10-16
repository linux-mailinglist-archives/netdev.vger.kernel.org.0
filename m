Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB1D290C8B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 22:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392779AbgJPUDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 16:03:44 -0400
Received: from mailout09.rmx.de ([94.199.88.74]:34844 "EHLO mailout09.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392577AbgJPUDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 16:03:44 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout09.rmx.de (Postfix) with ESMTPS id 4CCcXr0FTBzbsT2;
        Fri, 16 Oct 2020 22:03:40 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CCcXY11sbz2xKS;
        Fri, 16 Oct 2020 22:03:25 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Oct
 2020 22:02:51 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
CC:     "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] net: dsa: move skb reallocation to dsa_slave_xmit
Date:   Fri, 16 Oct 2020 22:02:23 +0200
Message-ID: <20201016200226.23994-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201016-220331-4CCcXY11sbz2xKS-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series moves the reallocation of a skb which may be required due to
tail tagging or padding, from the tag_trailer and tag_ksz drivers to
dsa_slave_xmit. Additionally it prevents a skb_panic in a very special
corner case described here:
https://patchwork.ozlabs.org/project/netdev/patch/20201014161719.30289-1-ceggers@arri.de/#2554896

This series has been tested with KSZ9563 and my preliminary PTP patches.

On Friday, 16 October 2020, 17:56:45 CEST, Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 02:44:46PM +0200, Christian Eggers wrote:
> > Machine:
> > - ARMv7 (i.MX6ULL), SMP_CACHE_BYTES is 64
> > - DSA device: Microchip KSZ9563 (I am currently working on time stamping
> > support)
> I have a board very similar to this on which I am going to test.
hopefully you are not just developing on PTP support for KSZ9563 ;-)
Which hardware do you exactly own? The problem I described to (link
above) can only be reproduced with my (not yes published) PTP patches.

> > Last, CONFIG_SLOB must be selected.
> 
> Interesting, do you know why?
Yes. The other allocaters will actually allocate 512 byte instead of 320
if 64+256 bytes are requested. This will then be reported by ksize() and
let to more skb tailroom. The SLOB allocator will really allocate only
320 byte in this case, so that the skb will be run out of tail room when
tail tagging...

> > 3. "Manually" unsharing in dsa_slave_xmit(), reserving enough tailroom
> > for the tail tag (and ETH_ZLEN?). Would moving the "else" clause from
> > ksz_common_xmit()  to dsa_slave_xmit() do the job correctly?
> 
> I was thinking about something like that, indeed. DSA knows everything
> about the tagger: its overhead, whether it's a tail tag or not. The xmit
> callback of the tagger should only be there to populate the tag where it
> needs to be. But reallocation, padding, etc etc, should all be dealt
> with by the common DSA xmit procedure. We want the taggers to be simple
> and reuse as much logic as possible, not to be bloated.
This series is the first draft for it. Some additional changes my be
done later:
1. All xmit() function now return either the supplied skb or NULL. No
reallocation will be done anymore. Maybe the type of the return value may
be changed to reflect this (e.g. to bool).
2. There is no path left which calls __skb_put_padto()/skb_pad() with
free_on_error set to false. So the following commit may be reverted in
order to simply the code:

cd0a137acbb6 ("net: core: Specify skb_pad()/skb_put_padto() SKB freeing")

On Friday, 16 October 2020, 11:05:27 CEST, Vladimir Oltean wrote:
> Kurt is asking, and rightfully so, because his tag_hellcreek.c driver
> (for a 1588 switch with tail tags) is copied from tag_ksz.c.
@Kurt: If this series (or a later version) is accepted, please update
your tagging driver. Ensure that your dsa_device_ops::overhead contains
the "maximum" possible tail tag len for xmit and that
dsa_device_ops::tail_tag is set to true.

On Friday, 16 October 2020, 20:03:11 CEST, Jakub Kicinski wrote:
> FWIW if you want to avoid the reallocs you may want to set
> needed_tailroom on the netdev.
I haven't looked for this yet. If this can really solve the tagging AND
padding problem, I would like to do this in a follow up patch.

Wishing a nice weekend for netdev.
Christian




