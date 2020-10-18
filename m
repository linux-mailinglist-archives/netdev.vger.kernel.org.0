Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63192916F7
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 12:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgJRKgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 06:36:33 -0400
Received: from mailout01.rmx.de ([94.199.90.91]:44635 "EHLO mailout01.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbgJRKgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 06:36:32 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout01.rmx.de (Postfix) with ESMTPS id 4CDbsR5QQGz2SX91
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 12:36:27 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CDbsP0Wpsz2TTKG
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 12:36:25 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.10) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Sun, 18 Oct
 2020 12:36:03 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation procedure
Date:   Sun, 18 Oct 2020 12:36:03 +0200
Message-ID: <2267996.Y80grUFxSa@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201018001326.auu4u7mgfnxk37nx@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com> <20201017223120.em6bp245oyfuzepk@skbuf> <20201018001326.auu4u7mgfnxk37nx@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.10]
X-RMX-ID: 20201018-123625-4CDbsP0Wpsz2TTKG-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

thank you very much for bringing some progress into this.

I tried to test on top of latest net-next, but I currently get a linker error (not  related to this):
arch/arm/vfp/vfphw.o: in function `vfp_support_entry':
arch/arm/vfp/vfphw.S:85:(.text+0xa): relocation truncated to fit: R_ARM_THM_JUMP19 against symbol `vfp_kmode_exception' defined in .text.unlikely section in arch/arm/vfp/vfpmodule.o

So continued testing of your series (with all updates) and my PTP work on top
of net-next from 2020-10-14.

On Sunday, 18 October 2020, 02:13:27 CEST, Vladimir Oltean wrote:
> Last one for today. This should actually be correct now, and not
> allocate double the needed headroom size.
> 
> static int dsa_realloc_skb(struct sk_buff *skb, struct net_device *dev)
> {
> 	struct dsa_slave_priv *p = netdev_priv(dev);
> 	struct dsa_slave_stats *e;
> 	int needed_headroom;
> 	int needed_tailroom;
> 	int padlen = 0, err;
> 
> 	needed_headroom = dev->needed_headroom;
> 	needed_tailroom = dev->needed_tailroom;
Debugging shows that these values are correct for my device (0/5).

> 	/* For tail taggers, we need to pad short frames ourselves, to ensure
> 	 * that the tail tag does not fail at its role of being at the end of
> 	 * the packet, once the master interface pads the frame.
> 	 */
> 	if (unlikely(needed_tailroom && skb->len < ETH_ZLEN))
Can "needed_tailroom" be used equivalently for dsa_device_ops::tail_tag?

> 		padlen = ETH_ZLEN - skb->len;
> 	needed_tailroom += padlen;
> 	needed_headroom -= skb_headroom(skb);
> 	needed_tailroom -= skb_tailroom(skb);
> 
> 	if (likely(needed_headroom <= 0 && needed_tailroom <= 0 &&
> 		   !skb_cloned(skb)))
> 		/* No reallocation needed, yay! */
> 		return 0;
> 
> 	e = this_cpu_ptr(p->extra_stats);
> 	u64_stats_update_begin(&e->syncp);
> 	e->tx_reallocs++;
> 	u64_stats_update_end(&e->syncp);
> 
> 	err = pskb_expand_head(skb, max(needed_headroom, 0),
> 			       max(needed_tailroom, 0), GFP_ATOMIC);
You may remove the second max() statement (around needed_tailroom). This would
size the reallocated skb more exactly to the size actually required an may save
some RAM (already tested too).

Alternatively I suggest moving the max() statements up in order to completely
avoid negative values for needed_headroom / needed_tailroom:

	needed_headroom = max(needed_headroom - skb_headroom(skb), 0);
	needed_tailroom = max(needed_tailroom - skb_tailroom(skb), 0);

	if (likely(needed_headroom == 0 && needed_tailroom == 0 &&
		   !skb_cloned(skb)))
		/* No reallocation needed, yay! */
		return 0;
	...
	err = pskb_expand_head(skb, needed_headroom, needed_tailroom, GFP_ATOMIC);

> 	if (err < 0 || !padlen)
> 		return err;
This is correct but looks misleading for me. What about...
	if (err < 0)
		return err;

	return padlen ? __skb_put_padto(skb, ETH_ZLEN, false) : 0;


FYI two dumps of a padded skb (before/after) dsa_realloc_skb():
[ 1983.621180] old:skb len=58 headroom=2 headlen=58 tailroom=68
[ 1983.621180] mac=(2,14) net=(16,-1) trans=-1
[ 1983.621180] shinfo(txflags=1 nr_frags=0 gso(size=0 type=0 segs=0))
[ 1983.621180] csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
[ 1983.621180] hash(0x0 sw=0 l4=0) proto=0x88f7 pkttype=0 iif=0
[ 1983.635575] old:dev name=lan0 feat=0x0x0002000000005220
[ 1983.638205] old:sk family=17 type=3 proto=0
[ 1983.640323] old:skb linear:   00000000: 01 1b 19 00 00 00 ee 97 1f aa 93 21 88 f7 01 02
[ 1983.644416] old:skb linear:   00000010: 00 2c 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1983.648656] old:skb linear:   00000020: 00 00 ee 97 1f ff fe aa 93 21 00 01 06 79 01 7f
[ 1983.652726] old:skb linear:   00000030: 00 00 00 00 00 00 00 00 00 00

[ 1983.656040] new:skb len=60 headroom=2 headlen=60 tailroom=66
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ok
[ 1983.656040] mac=(2,14) net=(16,-1) trans=-1
[ 1983.656040] shinfo(txflags=1 nr_frags=0 gso(size=0 type=0 segs=0))
[ 1983.656040] csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
[ 1983.656040] hash(0x0 sw=0 l4=0) proto=0x88f7 pkttype=0 iif=0
[ 1983.670427] new:dev name=lan0 feat=0x0x0002000000005220
[ 1983.673082] new:sk family=17 type=3 proto=0
[ 1983.675233] new:skb linear:   00000000: 01 1b 19 00 00 00 ee 97 1f aa 93 21 88 f7 01 02
[ 1983.679329] new:skb linear:   00000010: 00 2c 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1983.683411] new:skb linear:   00000020: 00 00 ee 97 1f ff fe aa 93 21 00 01 06 79 01 7f
[ 1983.687506] new:skb linear:   00000030: 00 00 00 00 00 00 00 00 00 00 00 00

Tested-by: Christian Eggers <ceggers@arri.de>  # For tail taggers only

Best regards
Christian Eggers



