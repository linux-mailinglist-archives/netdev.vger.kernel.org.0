Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F20B168F3D
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 14:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgBVNzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 08:55:03 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:59284 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgBVNzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 08:55:03 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j5VF2-000nAx-QM; Sat, 22 Feb 2020 14:54:48 +0100
Message-ID: <229913c0b0481c3572032b2f64ce0202f5c66c23.camel@sipsolutions.net>
Subject: Re: [PATCH] net: mac80211: rx.c: Use built-in RCU list checking
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Date:   Sat, 22 Feb 2020 14:54:47 +0100
In-Reply-To: <20200222133928.GA10397@madhuparna-HP-Notebook> (sfid-20200222_143938_994762_F2980624)
References: <20200222101831.8001-1-madhuparnabhowmik10@gmail.com>
         <f1913847671d0b7e19aaa9bef1e1eb89febfa942.camel@sipsolutions.net>
         <20200222133928.GA10397@madhuparna-HP-Notebook>
         (sfid-20200222_143938_994762_F2980624)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> If list_for_each_entry_rcu() is called from non rcu protection
> i.e without holding rcu_read_lock, but under the protection of
> a different lock then we can pass that as the condition for lockdep checking
> because otherwise lockdep will complain if list_for_each_entry_rcu()
> is used without rcu protection. So, if we do not pass this argument
> (cond) it may lead to false lockdep warnings.

Sure. But what's the specific warning you see?

> > > -	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > +	list_for_each_entry_rcu(sdata, &local->interfaces, list,
> > > +				lockdep_is_held(&rx->local->rx_path_lock)) {
> > >  		if (!ieee80211_sdata_running(sdata))
> > >  			continue;
> > 
> > This is not related at all.
> 
> I analysed the following traces:
> ieee80211_rx_handlers() -> ieee80211_rx_handlers_result() -> ieee80211_rx_cooked_monitor()
> 
> here ieee80211_rx_handlers() is holding the rx->local->rx_path_lock and
> therefore I used this for the cond argument.
> 
>  If this is not right, can you help me in figuring out that which other
>  lock is held?

It's _clearly_ not right, that's the RX spinlock, it has nothing to do
with the interface list.

But I'd have to see the warning. Perhaps the driver you're using is
wrongly calling something in the stack.

> > >  	lockdep_assert_held(&local->sta_mtx);
> > >  
> > > -	list_for_each_entry_rcu(sta, &local->sta_list, list) {
> > > +	list_for_each_entry_rcu(sta, &local->sta_list, list,
> > > +				lockdep_is_held(&local->sta_mtx)) {
> > 
> > And this isn't even a real RCU iteration, since we _must_ hold the mutex
> > here.
> > 
> Yeah exactly, dropping _rcu (use list_for_each_entry()) would be a good option in this case.
> Let me know if that is alright and I will send a new patch with all the
> changes required.

Seems fine, also better to split the patches anyway.

johannes

