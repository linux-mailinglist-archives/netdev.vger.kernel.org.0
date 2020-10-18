Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E85B291742
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 14:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgJRMAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 08:00:12 -0400
Received: from mailout05.rmx.de ([94.199.90.90]:37079 "EHLO mailout05.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgJRMAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 08:00:11 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout05.rmx.de (Postfix) with ESMTPS id 4CDdk03przz9yDb
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 14:00:08 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CDdjx6B68z2TTMQ
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 14:00:05 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.10) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Sun, 18 Oct
 2020 13:59:44 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation procedure
Date:   Sun, 18 Oct 2020 13:59:43 +0200
Message-ID: <9012784.ALUgdZc4HQ@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201018114205.dk5mcr7mcnqgo65w@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com> <2267996.Y80grUFxSa@n95hx1g2> <20201018114205.dk5mcr7mcnqgo65w@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.10]
X-RMX-ID: 20201018-140005-4CDdjx6B68z2TTMQ-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, 18 October 2020, 13:42:06 CEST, Vladimir Oltean wrote:
> On Sun, Oct 18, 2020 at 12:36:03PM +0200, Christian Eggers wrote:
> > >       err = pskb_expand_head(skb, max(needed_headroom, 0),
> > >       
> > >                              max(needed_tailroom, 0), GFP_ATOMIC);
> > 
> > You may remove the second max() statement (around needed_tailroom). This
> > would size the reallocated skb more exactly to the size actually required
> > an may save some RAM (already tested too).
> 
> Please explain more. needed_tailroom can be negative, why should I
> shrink the tailroom?
Because it will not be required anymore. This may lead to smaller memory 
allocations or the excess tailroom can be reused for headroom if needed. If 
none of both applies, the tailroom will not be changed.

regards
Christian



