Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A973F8EA2
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243455AbhHZTTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243360AbhHZTTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 15:19:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 057F760F14;
        Thu, 26 Aug 2021 19:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630005502;
        bh=B835QYr8s3iNkwUIsABnoQUsWxamk2ZRljJXvabRXZs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Itcukwh7QIH0WuB1WXgjYdfyLMvlOJBZPIRx64AkNQbutn9RXtgssQxFi9JryJwJY
         rhCB9WJ4aPQ4nHm+ImiwYZeMZmZHczgm2eixD7/P8kBVZkmcKIMoysonCOYK1LFVUA
         B+Ve/H+Y27w2e9ba/4Ea9PLgTaswLPtBoN3ZIKNHCChluNPXwyiDxR02yYibS/+jsa
         uk0+DnjotjpSOaRdreVQS+D/qT4mzhWoxnv+K+KJwdLT0w6SBNFdFAY7s2rOnAmRrJ
         +jZkfV8vbTdWQ+PI18GMKJJFjf27KGwZZmxSVsqWjhYsgmwn6PAenhWtRQod4xMqDG
         UKCdYwPMCyoNg==
Date:   Thu, 26 Aug 2021 12:18:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, olteanv@gmail.com
Subject: Re: [PATCH net-next v3 2/3] bnxt: count packets discarded because
 of netpoll
Message-ID: <20210826121821.2c926745@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLimh-oLG7zNBgSCYqS1aJh5ivBJJK+5kkL1kqJU5NOHctA@mail.gmail.com>
References: <20210826131224.2770403-1-kuba@kernel.org>
        <20210826131224.2770403-3-kuba@kernel.org>
        <CACKFLimh-oLG7zNBgSCYqS1aJh5ivBJJK+5kkL1kqJU5NOHctA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 11:43:58 -0700 Michael Chan wrote:
> On Thu, Aug 26, 2021 at 6:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > @@ -10646,11 +10653,15 @@ static void bnxt_get_ring_stats(struct bnxt *bp,
> >                 stats->multicast += BNXT_GET_RING_STATS64(sw, rx_mcast_pkts);
> >
> >                 stats->tx_dropped += BNXT_GET_RING_STATS64(sw, tx_error_pkts);
> > +
> > +               bsw_stats->rx.rx_netpoll_discards +=
> > +                       cpr->sw_stats.rx.rx_netpoll_discards;  
> 
> Can we just add these rx_netpoll_discards counters directly to
> stats->rx_dropped?  It looks simpler if we do it that way, right?

To make sure - are you saying that instead of adding

	struct bnxt_sw_stats	sw_stats_prev;

we should accumulate in net_stats_prev->rx_dropped, and have 
the ethtool counter only report the discards since last down/up?

Or to use the atomic counter on the netdev and never report 
in ethtool (since after patch 3 rx_dropped is a mix of reasons)?
