Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A3647A628
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237933AbhLTInX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:43:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58382 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhLTInV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 03:43:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B54C5B80E18;
        Mon, 20 Dec 2021 08:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7E8C36AE8;
        Mon, 20 Dec 2021 08:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639989799;
        bh=Z56E0YLDJYfUOEbIoQ3dZsDFxNDXVpWns/OnVxMD5ls=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JtgVt0xqu3Rl1M436E6YfK0mYOhHCffwMV9EvGazdC61Nqcb5i9UnrPIQdBVGvFCi
         5M88YAytMwj5Fnja5g/mNFl0f0DTlIvDvPPZCm53up+yqk7XXzCB+lpmrKw5/QbeEV
         YJr9HT87Kw0M+cn0w0LauvZTbq4Y/B6cseAVevDpkCabJueyw/ZvpnFO+KMgm/9vQv
         aKoicz0w8NAfYNCqtu+BmTAHt2WLPVItndWcRDtQM6pn5YjC9FH66oApmcbsyE0n8b
         JvuD/z69PM63060pPMxMAncpO+up1UV6ZVD7mwPbyLP/UKUmc6ggokz1KXR45W1Mr0
         XRvVwmAL3vvwA==
From:   Kalle Valo <kvalo@kernel.org>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: RFC: wilc1000: refactor TX path to use sk_buff queue
References: <e3502ecffe0c4c01b263ada8deed814d5135c24c.camel@egauge.net>
        <8735mvhyvk.fsf@codeaurora.org>
        <57d8cdfe5c22bf3df2727a18a6096026c59729da.camel@egauge.net>
Date:   Mon, 20 Dec 2021 10:43:13 +0200
In-Reply-To: <57d8cdfe5c22bf3df2727a18a6096026c59729da.camel@egauge.net>
        (David Mosberger-Tang's message of "Tue, 14 Dec 2021 10:43:35 -0700")
Message-ID: <87fsqnmztq.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> writes:

> On Tue, 2021-12-14 at 19:36 +0200, Kalle Valo wrote:
>> David Mosberger-Tang <davidm@egauge.net> writes:
>> 
>> > I'd like to propose to restructure the wilc1000 TX path to take
>> > advantage of the existing sk_buff queuing and buffer operations rather
>> > than using a driver-specific solution.  To me, the resulting code looks
>> > simpler and the diffstat shows a fair amount of code-reduction:
>> > 
>> >  cfg80211.c |   35 ----
>> >  mon.c      |   36 ----
>> >  netdev.c   |   28 ---
>> >  netdev.h   |   10 -
>> >  wlan.c     |  499 ++++++++++++++++++++++++++-----------------------------------
>> >  wlan.h     |   51 ++----
>> >  6 files changed, 255 insertions(+), 404 deletions(-)
>> 
>> Looks like a very good cleanup.
>
> Thanks!
>
>> > +static void wilc_wlan_txq_drop_net_pkt(struct sk_buff *skb)
>> > +{
>> > +	struct wilc_vif *vif = netdev_priv(skb->dev);
>> > +	struct wilc *wilc = vif->wilc;
>> > +	struct wilc_skb_tx_cb *tx_cb = WILC_SKB_TX_CB(skb);
>> > +
>> > +	if ((u8)tx_cb->q_num >= NQUEUES) {
>> > +		netdev_err(vif->ndev, "Invalid AC queue number %d",
>> > +			   tx_cb->q_num);
>> > +		return;
>> > +	}
>> 
>> But why the cast here? Casting should be avoided as much as possible,
>> they just create so many problems if used badly.
>
> tx_cb->q_num is declared as:
>
>        enum ip_pkt_priority q_num;     /* AC queue number */
>
> so the cast to (u8) is to protect against negative values (which, of
> course, should never really be the case).  Would you rather have the
> code check explicitly for negative numbers, i.e.:
>
>     if (tx_cb->q_num < 0 || tx_cb->q_num >= NQUEUES)
>
> ?

I don't have a good answer. IIRC I have never seen anyone doing anything
like this either, so I'm not sure if it's even worth it? In general
casting is a much bigger problem in upstream and I tend to check those
carefully.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
