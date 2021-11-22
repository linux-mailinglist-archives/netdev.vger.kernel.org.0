Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DDE459626
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 21:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbhKVUiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 15:38:13 -0500
Received: from fgw20-4.mail.saunalahti.fi ([62.142.5.107]:35189 "EHLO
        fgw20-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240234AbhKVUhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 15:37:34 -0500
Received: from darkstar.musicnaut.iki.fi (85-76-75-23-nat.elisa-mobile.fi [85.76.75.23])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTP
        id 8e077284-4bd3-11ec-8d6d-005056bd6ce9;
        Mon, 22 Nov 2021 22:34:14 +0200 (EET)
Date:   Mon, 22 Nov 2021 22:34:13 +0200
From:   Aaro Koskinen <aaro.koskinen@iki.fi>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BISECTED REGRESSION] Wireless networking kernel crashes
Message-ID: <20211122203413.GA576751@darkstar.musicnaut.iki.fi>
References: <20211118132556.GD334428@darkstar.musicnaut.iki.fi>
 <31021122-d1c1-181b-0b95-2ef1c1592452@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31021122-d1c1-181b-0b95-2ef1c1592452@nbd.name>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Nov 21, 2021 at 08:37:54PM +0100, Felix Fietkau wrote:
> On 2021-11-18 14:25, Aaro Koskinen wrote:
> > I have tried to upgrade my wireless AP (Raspberry Pi with rt2x00usb)
> > from v5.9 to the current mainline, but now it keeps crashing every hour
> > or so, basically making my wireless network unusable.
> > 
> > I have bisected this to:
> > 
> > commit 03c3911d2d67a43ad4ffd15b534a5905d6ce5c59
> > Author: Ryder Lee <ryder.lee@mediatek.com>
> > Date:   Thu Jun 17 18:31:12 2021 +0200
> > 
> >      mac80211: call ieee80211_tx_h_rate_ctrl() when dequeue
> > 
> > With the previous commit the system stays up for weeks...
> > 
> > I just tried today's mainline, and it crashed after 10 minutes:
> Please test if this patch fixes the issue:

Thanks, that seems to help. I've been now running with this change
roughly 24 hours, and still going fine...

A.


> ---
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1822,15 +1822,15 @@ static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx)
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
>  	ieee80211_tx_result res = TX_CONTINUE;
> +	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
> +		CALL_TXH(ieee80211_tx_h_rate_ctrl);
> +
>  	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
>  		__skb_queue_tail(&tx->skbs, tx->skb);
>  		tx->skb = NULL;
>  		goto txh_done;
>  	}
> -	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
> -		CALL_TXH(ieee80211_tx_h_rate_ctrl);
> -
>  	CALL_TXH(ieee80211_tx_h_michael_mic_add);
>  	CALL_TXH(ieee80211_tx_h_sequence);
>  	CALL_TXH(ieee80211_tx_h_fragment);
