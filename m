Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F691B70B2
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgDXJVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgDXJVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 05:21:36 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B283AC09B045;
        Fri, 24 Apr 2020 02:21:36 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jRuWW-00FRFQ-N1; Fri, 24 Apr 2020 11:21:28 +0200
Message-ID: <8d6fd8bfa0fb66f8ee4bfd34738a349bb1b7ee59.camel@sipsolutions.net>
Subject: Re: [PATCH 2/4] net: mac80211: scan.c: Fix RCU list related
 warnings.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     madhuparnabhowmik10@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        joel@joelfernandes.org, paulmck@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Date:   Fri, 24 Apr 2020 11:21:27 +0200
In-Reply-To: <20200409082849.27372-1-madhuparnabhowmik10@gmail.com> (sfid-20200409_102909_206741_272D703E)
References: <20200409082849.27372-1-madhuparnabhowmik10@gmail.com>
         (sfid-20200409_102909_206741_272D703E)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-09 at 13:58 +0530, madhuparnabhowmik10@gmail.com wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> This patch fixes the following warning:
> 
> WARNING: suspicious RCU usage
> [   84.530619] 5.6.0+ #4 Not tainted
> [   84.530637] -----------------------------
> [   84.530658] net/mac80211/scan.c:454 RCU-list traversed in non-reader section!!
> 
> As local->mtx is held in __ieee80211_scan_completed()

Yeah, but is that really the right lock? I think it should be RTNL or
iflist_mtx for the interface list.

(Not that this is necessarily a good idea - we perhaps should clean up
and significantly reduce the number of locks used here.)

johannes

