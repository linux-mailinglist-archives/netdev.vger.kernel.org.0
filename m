Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3833F91DE
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243923AbhH0BQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243862AbhH0BP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 21:15:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6213F60ED3;
        Fri, 27 Aug 2021 01:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630026911;
        bh=5V3N2iRhRdBhh/AWiibSHvpnZuZb9GjIIiEMPznnPIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cvr+ejjpjuDxs++5KGKo70jXE6jeLJwQomRQpQ2r8MlQN4pbjjvWwJ8I56mBKE9NG
         4k9O5PztzotcICDvjXEIDHNYzuBZHT4aX1MJirYx63XkuKaG8ox5tfwdNrC+q8/I0n
         +6LyRVsxuahkrkdUJqY7lRct6+rAUSt0qdJmpliXdHC6GB83BdjTENTVOqigZ/VyIz
         gzT7j30D292TuIlviQjptYBe+qwUFQEO70uW6zEiNP00+HpUEh4LTqw6kdtrbAt711
         dgJ3S4Rp5lWaPWuncBxDBuQYRbf8L/j6P5k4hrUm90/s0EFpWhpYl2/UzeS0j8522G
         B/xZcJa93K4jw==
Date:   Thu, 26 Aug 2021 18:15:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, olteanv@gmail.com
Subject: Re: [PATCH net-next v3 2/3] bnxt: count packets discarded because
 of netpoll
Message-ID: <20210826181510.3f71e103@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLimgBca1mFLp05uLQ3-8N8m12=hVOGU7rk8WJFeYnfK13w@mail.gmail.com>
References: <20210826131224.2770403-1-kuba@kernel.org>
        <20210826131224.2770403-3-kuba@kernel.org>
        <CACKFLimh-oLG7zNBgSCYqS1aJh5ivBJJK+5kkL1kqJU5NOHctA@mail.gmail.com>
        <20210826121821.2c926745@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLimgBca1mFLp05uLQ3-8N8m12=hVOGU7rk8WJFeYnfK13w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 14:17:45 -0700 Michael Chan wrote:
> On Thu, Aug 26, 2021 at 12:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 26 Aug 2021 11:43:58 -0700 Michael Chan wrote:  
> > > Can we just add these rx_netpoll_discards counters directly to
> > > stats->rx_dropped?  It looks simpler if we do it that way, right?  
> >
> > To make sure - are you saying that instead of adding
> >
> >         struct bnxt_sw_stats    sw_stats_prev;
> >
> > we should accumulate in net_stats_prev->rx_dropped, and have
> > the ethtool counter only report the discards since last down/up?
> >
> > Or to use the atomic counter on the netdev and never report
> > in ethtool (since after patch 3 rx_dropped is a mix of reasons)?  
> 
> OK.  I've reviewed the patch again and you need to keep the previous
> netpoll discard counter so that you can report the total current and
> previous netpoll discard counter under ethtool -S.
> 
> My suggestion would lump the previous netpoll discard counter into the
> previous rx_dropped counter and you can only report the current
> netpoll discard counter under ethtool -S.  But note that all the ring
> related counters we currently report are current counters and do not
> include old counters before the last reset.

Oh, [rt]x_total_discard_pkts are also just a sum of current counters?
I missed that. In that case if netpoll discards reset it's not a big
deal, I'll respin the patch tomorrow. Let me also rename from
rx_netpoll_discards to rx_total_netpoll_discards, adding the "total_"
will hopefully signal the similarity of semantics?
