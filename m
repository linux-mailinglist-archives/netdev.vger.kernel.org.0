Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B62BF26F
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 14:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfIZME7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 08:04:59 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51726 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfIZME7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 08:04:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iDSVx-0000lJ-AK; Thu, 26 Sep 2019 14:04:53 +0200
Message-ID: <8b36a751a3498415a6474940ed904dbd40e1f26b.camel@sipsolutions.net>
Subject: Re: [PATCH RFC] cfg80211: add new command for reporting wiphy
 crashes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Jouni Malinen <j@w1.fi>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hostap@lists.infradead.org,
        openwrt-devel@lists.openwrt.org
Date:   Thu, 26 Sep 2019 14:04:52 +0200
In-Reply-To: <09503390-91f0-3789-496a-6e9891156c5e@gmail.com> (sfid-20190926_140042_451511_E87E7FE4)
References: <20190920133708.15313-1-zajec5@gmail.com>
         <20190920140143.GA30514@w1.fi>
         <4f6f37e5-802c-4504-3dcb-c4a640d138bd@milecki.pl>
         <9ece533700be8237699881312a99cc91c6a71d36.camel@sipsolutions.net>
         <09503390-91f0-3789-496a-6e9891156c5e@gmail.com>
         (sfid-20190926_140042_451511_E87E7FE4)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-26 at 14:00 +0200, Rafał Miłecki wrote:

> > You can't seriously be suggesting that the driver doesn't *have* enough
> > information - everything passed through it :)
> 
> Precisely: it doesn't store (cache) enough info.

But nothing stops it (the driver) from doing so!

> In brcmfmac on .add_virtual_intf() we:
> 1) Send request to the FullMAC firmware
> 2) Wait for a reply
> 3) On success we create interface
> 4) We wake up .add_virtual_intf() handler
> 
> I'll need to find a way to skip step 3 in recovery path since interface
> on host side already exists.

Sure, we skip lots of things in all drivers, look at iwlwifi for example
with IWL_MVM_STATUS_IN_HW_RESTART.

> OK, so basically I need to work on caching setup data. Should I try
> doing that at my selected driver level (brcmfmac)? Or should I focus on
> generic solution (cfg80211) and consider offloading mac80211 if
> possible?

I think doing it generically will not work well, you have different code
paths and different formats, different data that you need etc.

Sometimes there's information cfg80211 doesn't even *have*, because the
driver is responsible for things (e.g. elements). I guess you can try,
but my gut feeling is that it'd simpler in the driver.

Now you can argue that everything passes through cfg80211 so it must
have enough data too (just like I'm arguing the driver certainly has
enough data), but ... it seems to me the cfg80211 is usually more
action-based, where the restore flow needs to keep the *state*, not
replay the series of actions that happened.

johannes

