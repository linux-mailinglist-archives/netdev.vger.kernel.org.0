Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F57E7141
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 13:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389059AbfJ1MVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 08:21:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40652 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389047AbfJ1MVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 08:21:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iP41N-0003VP-51; Mon, 28 Oct 2019 13:21:17 +0100
Message-ID: <e5b07b4ce51f806ce79b1ae06ff3cbabbaa4873d.camel@sipsolutions.net>
Subject: Re: [PATCH v2] 802.11n IBSS: wlan0 stops receiving packets due to
 aggregation after sender reboot
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 28 Oct 2019 13:21:15 +0100
In-Reply-To: <m37e4tjfbu.fsf@t19.piap.pl>
References: <m34l02mh71.fsf@t19.piap.pl> <m37e4tjfbu.fsf@t19.piap.pl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-10-25 at 12:21 +0200, Krzysztof Hałasa wrote:
> Fix a bug where the mac80211 RX aggregation code sets a new aggregation
> "session" at the remote station's request, but the head_seq_num
> (the sequence number the receiver expects to receive) isn't reset.
> 
> Spotted on a pair of AR9580 in IBSS mode.
> 
> Signed-off-by: Krzysztof Halasa <khalasa@piap.pl>
> 
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index 4d1c335e06e5..67733bd61297 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -354,10 +354,13 @@ void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
>  			 */
>  			rcu_read_lock();
>  			tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
> -			if (tid_rx && tid_rx->timeout == timeout)
> +			if (tid_rx && tid_rx->timeout == timeout) {
> +				tid_rx->ssn = start_seq_num;
> +				tid_rx->head_seq_num = start_seq_num;
>  				status = WLAN_STATUS_SUCCESS;

This is wrong, this is the case of *updating an existing session*, we
must not reset the head SN then.

I think you just got very lucky (or unlucky) to have the same dialog
token, because we start from 0 - maybe we should initialize it to a
random value to flush out such issues.

Really what I think probably happened is that one of your stations lost
the connection to the other, and didn't tell it about it in any way - so
the other kept all the status alive.

I suspect to make all this work well we need to not only have the fixes
I made recently to actually send and parse deauth frames, but also to
even send an auth and reset the state when we receive that, so if we
move out of range and even the deauth frame is lost, we can still reset
properly.

In any case, this is not the right approach - we need to handle the
"lost connection" case better I suspect, but since you don't say what
really happened I don't really know that that's what you're seeing.

johannes

