Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202281B70C3
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgDXJYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726298AbgDXJYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 05:24:50 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F0BC09B045;
        Fri, 24 Apr 2020 02:24:50 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jRuZd-00FRKL-4g; Fri, 24 Apr 2020 11:24:41 +0200
Message-ID: <61c8c547b9148b8297aa946a93df23608f408d28.camel@sipsolutions.net>
Subject: Re: [PATCH 4/4] net: mac80211: mlme.c: Add lockdep condition for
 RCU list usage
From:   Johannes Berg <johannes@sipsolutions.net>
To:     madhuparnabhowmik10@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        joel@joelfernandes.org, paulmck@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Date:   Fri, 24 Apr 2020 11:24:40 +0200
In-Reply-To: <20200409082925.27481-1-madhuparnabhowmik10@gmail.com> (sfid-20200409_102943_941405_F4B3E85F)
References: <20200409082925.27481-1-madhuparnabhowmik10@gmail.com>
         (sfid-20200409_102943_941405_F4B3E85F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-09 at 13:59 +0530, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> ieee80211_add_vht_ie() is called with sdata->wdev.mtx held from
> ieee80211_send_assoc(). Add lockdep condition to avoid false positive
> warnings.

Again, wrong lock!

Over the course of the three patches, you've now claimed that any one of

 * RTNL,
 * local->iflist_mtx,
 * local->mtx, and
 * sdata->wdev.mtx

are sufficient to iterate the interface list, but only the first two are
really true.

johannes

