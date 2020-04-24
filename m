Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2BE1B708E
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgDXJTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgDXJTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 05:19:16 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1DCC09B045;
        Fri, 24 Apr 2020 02:19:15 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jRuU9-00FRAm-SI; Fri, 24 Apr 2020 11:19:01 +0200
Message-ID: <89476ee074e782175d453038396543f193f8e5fd.camel@sipsolutions.net>
Subject: Re: [PATCH 1/4] net: mac80211: util.c: Fix RCU list usage warnings
From:   Johannes Berg <johannes@sipsolutions.net>
To:     madhuparnabhowmik10@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        joel@joelfernandes.org, paulmck@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Date:   Fri, 24 Apr 2020 11:18:59 +0200
In-Reply-To: <20200409082822.27314-1-madhuparnabhowmik10@gmail.com> (sfid-20200409_102851_270381_8F58A5E1)
References: <20200409082822.27314-1-madhuparnabhowmik10@gmail.com>
         (sfid-20200409_102851_270381_8F58A5E1)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> This patch fixes the following warning (CONIG_PROVE_RCU_LIST)
> in ieee80211_check_combinations().

Thanks, and sorry for the delay.


> +++ b/net/mac80211/util.c
> @@ -254,7 +254,7 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
>  
>  	sdata->vif.txqs_stopped[ac] = false;
>  
> -	list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +	list_for_each_entry(sta, &local->sta_list, list) {
>  		if (sdata != sta->sdata)
>  			continue;

In this case, for example, I don't even understand why the warning would
happen, because certainly the only caller of this (_ieee80211_wake_txqs)
does rcu_read_lock()?

I'm also not convinced that the necessary lock is actually held here,
this comes from a tasklet that doesn't hold any locks?
 
I'd appreciate if you could add comments/explain why you think the
changes were right, or ideally even add "lockdep_assert_held()"
annotations. That would make it much easier to check this patch.

> @@ -3931,7 +3932,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
>  		params.num_different_channels++;
>  	}
>  
> -	list_for_each_entry_rcu(sdata_iter, &local->interfaces, list) {
> +	list_for_each_entry(sdata_iter, &local->interfaces, list) {
>  		struct wireless_dev *wdev_iter;
>  
>  		wdev_iter = &sdata_iter->wdev;
> @@ -3982,7 +3983,7 @@ int ieee80211_max_num_channels(struct ieee80211_local *local)
>  			ieee80211_chanctx_radar_detect(local, ctx);
>  	}
>  
> -	list_for_each_entry_rcu(sdata, &local->interfaces, list)
> +	list_for_each_entry(sdata, &local->interfaces, list)
>  		params.iftype_num[sdata->wdev.iftype]++;

These changes correct, as far as I can tell, in that they rely on the
RTNL now - but can you perhaps document that as well?

There doesn't seem to be any multi-lock version of lockdep_assert_held()
or is there? That'd be _really_ useful here, because I want to get rid
of some RTNL reliance in the longer term, and having annotation here
saying "either RTNL or iflist_mtx is fine" would be good.

johannes

