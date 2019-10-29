Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8F2E862E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731512AbfJ2K5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:57:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33916 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfJ2K5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 06:57:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iPPBm-00079g-HF; Tue, 29 Oct 2019 11:57:26 +0100
Message-ID: <9086eeae04476adbd957b8d4df0e1a3ba0e7af93.camel@sipsolutions.net>
Subject: Re: [PATCH v2] 802.11n IBSS: wlan0 stops receiving packets due to
 aggregation after sender reboot
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 29 Oct 2019 11:57:24 +0100
In-Reply-To: <m336fbsu2r.fsf@t19.piap.pl>
References: <m34l02mh71.fsf@t19.piap.pl> <m37e4tjfbu.fsf@t19.piap.pl>
         <e5b07b4ce51f806ce79b1ae06ff3cbabbaa4873d.camel@sipsolutions.net>
         <m37e4orkxr.fsf@t19.piap.pl>
         <4725dcbd6297c74bf949671e7ad48eeeb0ceb0d0.camel@sipsolutions.net>
         <m336fbsu2r.fsf@t19.piap.pl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-29 at 11:51 +0100, Krzysztof Hałasa wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > > The problem I can see is that the dialog_tokens are 8-bit, way too small
> > > to eliminate conflicts.
> > 
> > Well, they're also per station, we could just randomize the start and
> > then we'd delete the old session and start a new one, on the receiver.
> > 
> > So that would improve robustness somewhat (down to a 1/256 chance to hit
> > this problem).
> 
> That was what I meant. Still, 1/256 seems hardly acceptable to me -
> unless there is some work around (a short timeout or something similar).
> Remember that when it doesn't work, it doesn't work - it won't recover
> until the sequence catches up, which may mean basically forever.

Agree, it just helps in "most" cases to do this. Perhaps we shouldn't do
this then so that we find the problem more easily...

> Or, maybe the remote station can request de-aggregation first, so the
> subsequent aggregation request is always treated as new?

> Alternatively, perhaps the remote can signal that it's a new request and
> not merely an existing session?

I think we should just implement authentication and reset of the station
properly, instead of fudging around with aggregation. This is just one
possible problematic scenario ... what if the station was reconfigured
with a different number of antennas in the meantime, for example, or
whatnot. There's a lot of state we keep for each station.

> > That's the situation though - the local station needs to know that it
> > has in fact *not* seen the same instance of the station, but that the
> > station has reset and needs to be removed & re-added.
> 
> Precisely. And it seems to me that the first time the local station
> learns of this is when a new, regular, non-aggregated packet arrives.
> Or, when a new aggregation request arrives.

Well, it should learn about the station when there's a beacon from it,
or if not ... we have a patch to force a probe request/response cycle so
we have all the capabilities properly. We should upstream that patch,
but need to do something to avoid being able to use this for traffic
amplification attacks.

johannes

