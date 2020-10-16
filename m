Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3197290067
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 11:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394864AbgJPJBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 05:01:18 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:37589 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394365AbgJPJBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 05:01:17 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CCKrT4CTvzMyvB;
        Fri, 16 Oct 2020 11:01:13 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CCKrG6TMrz2TTNX;
        Fri, 16 Oct 2020 11:01:02 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 16 Oct
 2020 11:00:21 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Date:   Fri, 16 Oct 2020 11:00:20 +0200
Message-ID: <4467366.g9nP7YU7d8@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <875z7asjfd.fsf@kurt>
References: <20201014161719.30289-1-ceggers@arri.de> <1647199.FWNDY5eN7L@n95hx1g2> <875z7asjfd.fsf@kurt>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20201016-110110-4CCKrG6TMrz2TTNX-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, 16 October 2020, 09:45:42 CEST, Kurt Kanzenbach wrote:
> On Thu Oct 15 2020, Christian Eggers wrote:
> > On Wednesday, 14 October 2020, 19:31:03 CEST, Vladimir Oltean wrote:
> >> What problem are you actually trying to solve?
> > 
> > After (hopefully) understanding the important bits, I would like to solve
> > the problem that after calling __skb_put_padto() there may be no tailroom
> > for the tail tag.
> > 
> > The conditions where this can happen are quite special. You need a
> > skb->len < ETH_ZLEN and the skb must be marked as cloned. One condition
> > where this happens in practice is when the skb has been selected for TX
> > time stamping in dsa_skb_tx_timestamp() [cloned] and L2 is used as
> > transport for PTP [size < ETH_ZLEN]. But maybe cloned sk_buffs can also
> > happen for other reasons.
> Hmm. I've never observed any problems using DSA with L2 PTP time
> stamping with this tail tag code. What's the impact exactly? Memory
> corruption?
It looks like skb_put_padto() is only used by the tag_ksz driver. So it's 
unlikely that other drivers are affected by the same problem.

If I remember correctly, I got a skb_panic in skb_put() when adding the tail 
tag. But with the current kernel I didn't manage to create packets where the 
skb allocated by __skb_put_padto has not enough spare room for the tag tag. 
Either I am trying with wrong packets, or something else has been changed in 
between.

I just sent a new patch which should solve the problem correctly here:
https://patchwork.ozlabs.org/project/netdev/list/?series=208269

Best regards
Christian




