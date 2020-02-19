Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0B1165195
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBSVaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:30:01 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:32818 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgBSVaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 16:30:00 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j4Wuf-00AJkC-UU; Wed, 19 Feb 2020 22:29:46 +0100
Message-ID: <855dec1f598d8b43400089cd0c5a7ac9b3533fc7.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Pass lockdep expression to RCU lists
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Amol Grover <frextrite@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Date:   Wed, 19 Feb 2020 22:29:43 +0100
In-Reply-To: <407d6295-6990-4ef6-7d36-e08a942607c8@broadcom.com> (sfid-20200219_222746_459969_817073EC)
References: <20200219091102.10709-1-frextrite@gmail.com>
         <ff8a005c68e512cb3f338b7381853e6b3a3ab293.camel@sipsolutions.net>
         <407d6295-6990-4ef6-7d36-e08a942607c8@broadcom.com>
         (sfid-20200219_222746_459969_817073EC)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-02-19 at 22:27 +0100, Arend Van Spriel wrote:
> On 2/19/2020 10:13 AM, Johannes Berg wrote:
> > On Wed, 2020-02-19 at 14:41 +0530, Amol Grover wrote:
> > >   
> > > -	WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held());
> > > -
> > > -	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list) {
> > > +	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list,
> > > +				lockdep_rtnl_is_held()) {
> > 
> > Huh, I didn't even know you _could_ do that :)
> 
> Me neither ;-). Above you are removing the WARN_ON_ONCE() entirely. 
> Would it not be good to keep the WARN_ON_ONCE() with only the 
> !rcu_read_lock_held() check.

Not needed, the macro expansion will already contain
rcu_read_lock_any_held() just like in all the other cases where you pass
a lockdep condition to RCU helpers.

johannes

