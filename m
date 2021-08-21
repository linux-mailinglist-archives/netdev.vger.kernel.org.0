Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291E03F3A94
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbhHUMUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 08:20:23 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:37816 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhHUMUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 08:20:22 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 17LCJ0Nc000440;
        Sat, 21 Aug 2021 14:19:00 +0200
Date:   Sat, 21 Aug 2021 14:19:00 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: Divide error in minstrel_ht_get_tp_avg()
Message-ID: <20210821121900.GA32713@1wt.eu>
References: <20210529165728.bskaozwtmwxnvucx@spock.localdomain>
 <20210607145223.tlxo5ge42mef44m5@spock.localdomain>
 <2137329.lhgpPQ2jGW@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2137329.lhgpPQ2jGW@natalenko.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 01:14:34PM +0200, Oleksandr Natalenko wrote:
> > > So, it seems `minstrel_ht_avg_ampdu_len()` can return 0, which is not
> > > really legitimate.
> > > 
> > > Looking at `minstrel_ht_avg_ampdu_len()`, I see the following:
> > > 
> > > ```
> > > 16:#define MINSTREL_SCALE  12
> > > ...
> > > 18:#define MINSTREL_TRUNC(val) ((val) >> MINSTREL_SCALE)
> > > ```
> > > 
> > > ```
> > > 
> > >  401 static unsigned int
> > >  402 minstrel_ht_avg_ampdu_len(struct minstrel_ht_sta *mi)
> > >  403 {
> > > 
> > > ...
> > > 
> > >  406     if (mi->avg_ampdu_len)
> > >  407         return MINSTREL_TRUNC(mi->avg_ampdu_len);
> > > 
> > > ```
> > > 
> > > So, likely, `mi->avg_ampdu_len` is non-zero, but it's too small, hence
> > > right bitshift makes it zero.
(...)
> I've also found out that this happens exactly at midnight, IOW, at 00:00:00. 
> Not every midnight, though.
> 
> Does it have something to do with timekeeping? This is strange, I wouldn't 
> expect kernel to act like that. Probably, some client sends malformed frame? 
> How to find out?

Well, in minstrel_ht_update_stats() at line 1006 avg_ampdu_len is
explicitly set to zero. And this seems to be called based on timing
criteria from minstrel_ht_tx_status() so this could confirm your
experience.  Thus there is some inconsistency there.

Willy
