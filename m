Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40B129D4C8
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgJ1Vyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:54:41 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59072 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgJ1Vyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:54:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kXr41-00EKXJ-FE; Wed, 28 Oct 2020 20:24:53 +0100
Message-ID: <5d1e166e32cd8263787764b7c7fe64b24cacb2a6.camel@sipsolutions.net>
Subject: Re: [PATCH v4 3/3] mac80211: add KCOV remote annotations to
 incoming frame processing
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Date:   Wed, 28 Oct 2020 20:24:36 +0100
In-Reply-To: <20201028182018.1780842-4-aleksandrnogikh@gmail.com> (sfid-20201028_192108_906083_C36F9C75)
References: <20201028182018.1780842-1-aleksandrnogikh@gmail.com>
         <20201028182018.1780842-4-aleksandrnogikh@gmail.com>
         (sfid-20201028_192108_906083_C36F9C75)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-28 at 18:20 +0000, Aleksandr Nogikh wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> Add KCOV remote annotations to ieee80211_iface_work and
> ieee80211_rx. This will enable coverage-guided fuzzing of
> mac80211 code that processes incoming 802.11 frames.
> 
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> ---
> v1 -> v2:
> * The commit now affects ieee80211_rx instead of
>   ieee80211_tasklet_handler.
> ---
>  include/net/mac80211.h | 2 ++
>  net/mac80211/iface.c   | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index e8e295dae744..f4c37a1b381e 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -4499,7 +4499,9 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
>   */
>  static inline void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  {
> +	kcov_remote_start_common(skb_get_kcov_handle(skb));
>  	ieee80211_rx_napi(hw, NULL, skb, NULL);
> +	kcov_remote_stop();
>  }

Wouldn't it make more sense to push that a layer down
into ieee80211_rx_napi(), or actually now perhaps even
better ieee80211_rx_list(), so we get it even if the driver called that
API in the first place?

You might only care about hwsim at this point, but perhaps hwsim would
get optimised ..


johannes

