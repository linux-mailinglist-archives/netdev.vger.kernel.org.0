Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E0EE83D6
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbfJ2JHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:07:40 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60514 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfJ2JHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 05:07:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iPNTP-0004OR-Op; Tue, 29 Oct 2019 10:07:31 +0100
Message-ID: <4725dcbd6297c74bf949671e7ad48eeeb0ceb0d0.camel@sipsolutions.net>
Subject: Re: [PATCH v2] 802.11n IBSS: wlan0 stops receiving packets due to
 aggregation after sender reboot
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 29 Oct 2019 10:07:30 +0100
In-Reply-To: <m37e4orkxr.fsf@t19.piap.pl>
References: <m34l02mh71.fsf@t19.piap.pl> <m37e4tjfbu.fsf@t19.piap.pl>
         <e5b07b4ce51f806ce79b1ae06ff3cbabbaa4873d.camel@sipsolutions.net>
         <m37e4orkxr.fsf@t19.piap.pl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-29 at 09:54 +0100, Krzysztof Hałasa wrote:

> The problem I can see is that the dialog_tokens are 8-bit, way too small
> to eliminate conflicts.

Well, they're also per station, we could just randomize the start and
then we'd delete the old session and start a new one, on the receiver.

So that would improve robustness somewhat (down to a 1/256 chance to hit
this problem).

> > Really what I think probably happened is that one of your stations lost
> > the connection to the other, and didn't tell it about it in any way - so
> > the other kept all the status alive.
> 
> You must have missed my previous mail - I simply rebooted that station,
> and alternatively rmmoded/modprobed ath9k. But the problem originated in
> a station going out of and back in range, in fact.

I was on vacation, so yeah, quite possible I missed it.

Sounds like we need not just
4b08d1b6a994 ("mac80211: IBSS: send deauth when expiring inactive STAs")

but also send a deauth when we disconnect. Surprising we don't do that,
actually.

> > I suspect to make all this work well we need to not only have the fixes
> > I made recently to actually send and parse deauth frames, but also to
> > even send an auth and reset the state when we receive that, so if we
> > move out of range and even the deauth frame is lost, we can still reset
> > properly.
> 
> That's one thing. The other is a station trying ADDBA for the first time
> after boot (while the local station has seen it before that reboot).

That's the situation though - the local station needs to know that it
has in fact *not* seen the same instance of the station, but that the
station has reset and needs to be removed & re-added.

> I guess we need to identify "new connection" reliably. Otherwise,
> the new connections are treated as old ones and it doesn't work.

Right. But we can implement the (optional) authentication (which you
actually already get when you implement [encrypted] IBSS with wpa_s),
and reset the station state when we get an authentication frame.

johannes

