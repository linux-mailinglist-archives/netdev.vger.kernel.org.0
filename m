Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC63168EF4
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 13:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBVMxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 07:53:42 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:58060 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgBVMxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 07:53:41 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j5UHe-000fEg-Jf; Sat, 22 Feb 2020 13:53:26 +0100
Message-ID: <f1913847671d0b7e19aaa9bef1e1eb89febfa942.camel@sipsolutions.net>
Subject: Re: [PATCH] net: mac80211: rx.c: Use built-in RCU list checking
From:   Johannes Berg <johannes@sipsolutions.net>
To:     madhuparnabhowmik10@gmail.com, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Date:   Sat, 22 Feb 2020 13:53:25 +0100
In-Reply-To: <20200222101831.8001-1-madhuparnabhowmik10@gmail.com> (sfid-20200222_112140_052707_ACC75C29)
References: <20200222101831.8001-1-madhuparnabhowmik10@gmail.com>
         (sfid-20200222_112140_052707_ACC75C29)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-02-22 at 15:48 +0530, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> list_for_each_entry_rcu() has built-in RCU and lock checking.
> 
> Pass cond argument to list_for_each_entry_rcu() to silence
> false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
> by default.

Umm. What warning?

> +++ b/net/mac80211/rx.c
> @@ -3547,7 +3547,8 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
>  	skb->pkt_type = PACKET_OTHERHOST;
>  	skb->protocol = htons(ETH_P_802_2);
>  
> -	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +	list_for_each_entry_rcu(sdata, &local->interfaces, list,
> +				lockdep_is_held(&rx->local->rx_path_lock)) {
>  		if (!ieee80211_sdata_running(sdata))
>  			continue;

This is not related at all.
 
> @@ -4114,7 +4115,8 @@ void __ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata)
>  
>  	lockdep_assert_held(&local->sta_mtx);
>  
> -	list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +	list_for_each_entry_rcu(sta, &local->sta_list, list,
> +				lockdep_is_held(&local->sta_mtx)) {

And this isn't even a real RCU iteration, since we _must_ hold the mutex
here.

johannes

