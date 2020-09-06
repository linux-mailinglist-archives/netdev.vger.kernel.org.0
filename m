Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8A625EF2B
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 18:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgIFQpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 12:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIFQpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 12:45:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBCEF207BB;
        Sun,  6 Sep 2020 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599410718;
        bh=bbQaHGEB+MEO+DEaG2y/EKFYlV4kuJWL/RVT0ZCxmy8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M7BAIIrPt0kaFHrjAMIy/qMvYtWpUPCVAKAHPrdXVaJpl48Ivtwf5tq7UEgqqfyz6
         jEX7DLR3w8G0nq38bRwJjD+YY9WiPJKIBb65UaT7H9jJzTIyHeBgJLwPbEFXbUTkVw
         LUUoypBztbuwApjM5lMNExKWdT3LWLtDedJ0D4zI=
Date:   Sun, 6 Sep 2020 09:45:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Jubran, Samih" <sameehj@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: Re: [PATCH V2 net-next 1/4] net: ena: ethtool: use unsigned long
 for pointer arithmetics
Message-ID: <20200906094516.2f8ea69c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <pj41zlv9grp4ge.fsf@u68c7b5b1d2d758.ant.amazon.com>
References: <20200819134349.22129-1-sameehj@amazon.com>
        <20200819134349.22129-2-sameehj@amazon.com>
        <20200819141716.GE2403519@lunn.ch>
        <91c86d46b724411d9f788396816be30d@EX13D11EUB002.ant.amazon.com>
        <20200826153635.GA51212@ranger.igk.intel.com>
        <pj41zlv9grp4ge.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Sep 2020 13:47:13 +0300 Shay Agroskin wrote:
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> > I don't want to stir up the pot, but do you really need the 
> > offsetof() of
> > each member in the stats struct? Couldn't you piggyback on 
> > assumption that
> > these stats need to be u64 and just walk the struct with 
> > pointer?
> >
> > 	struct ena_ring *ring;
> > 	int offset;
> > 	int i, j;
> > 	u8 *ptr;
> >
> > 	for (i = 0; i < adapter->num_io_queues; i++) {
> > 		/* Tx stats */
> > 		ring = &adapter->tx_ring[i];
> > 		ptr = (u8 *)&ring->tx_stats;
> >
> > 		for (j = 0; j < ENA_STATS_ARRAY_TX; j++) {
> > 			ena_safe_update_stat((u64 *)ptr, 
> > (*data)++, &ring->syncp);
> > 			ptr += sizeof(u64);
> > 		}
> > 	}
> >
> > I find this as a simpler and lighter solution. There might be 
> > issues with
> > code typed in email client, but you get the idea.
> >  
> >> 
> >> of course we need to convert the stat_offset field to be in 8 
> >> bytes resolution instead.
> >> 
> >> This approach has a potential bug hidden in it. If in the 
> >> future
> >> someone decides to expand the "ena_stats_tx" struct and add a 
> >> field preceding cnt,
> >> cnt will no longer be the beginning of the struct, which will 
> >> cause a bug."
> >> 
> >> Therefore, if you have another way to do this, please share 
> >> it. Otherwise I'd
> >> rather leave this code as it is for the sake of robustness.
> >>   
> >> > 
> >> >      Andrew  
> 
> Hi all,
> 
> We tried to implement your suggestion, and found that removing the 
> stat_offset
> field causes problems that are challenging to solve.
> Removing stat_offset introduces a requirement that the statistics 
> in a stat
> strings array (check [1] for example) and stat variables struct 
> (check [2] for
> example) must be in the same order.
> This requirement is prone to future bugs that might be challenging 
> to locate.
> We also tried to unify the array and struct creation by
> using X macros. At the moment this change requires more time and 
> effort by us
> and our customers need this code merged asap.
> 
> [1] https://elixir.bootlin.com/linux/v5.9-
> rc3/source/drivers/net/ethernet/amazon/ena/ena_ethtool.c#L71
> [2] https://elixir.bootlin.com/linux/v5.9-
> rc3/source/drivers/net/ethernet/amazon/ena/ena_netdev.h#L232
> 
> (This message was sent before but didn't seem to get into the 
> mailing list. Apologies if you got it twice)

Divide the offset by 8, cast &ring->tx_stats to u64 * (without
referencing cnt). That should be fine.
