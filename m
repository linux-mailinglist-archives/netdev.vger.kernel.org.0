Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C37211A8A3
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfLKKLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:11:12 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48630 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbfLKKLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:11:12 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ieyxW-003hWD-Tn; Wed, 11 Dec 2019 11:11:07 +0100
Message-ID: <3420d73e667b01ec64bf0cc9da6232b41e862860.camel@sipsolutions.net>
Subject: Re: iwlwifi warnings in 5.5-rc1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Date:   Wed, 11 Dec 2019 11:11:04 +0100
In-Reply-To: <878snjgs5l.fsf@toke.dk>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
         <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
         <878snjgs5l.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-12-11 at 09:53 +0100, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:
> > > Hi,
> > > 
> > > Since the GRO issue got fixed, iwlwifi has worked fine for me.
> > > However, on every boot, I get some warnings:
> > > 
> > > ------------[ cut here ]------------
> > > STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 208
> > 
> > Yeah, we've seen a few reports of this.
> 
> FWIW I've tried reproducing but I don't get the error with the 8265 /
> 8275 chip in my laptop. I've thought about sending a patch for mac80211
> to just clear the tx_time_est field after calling
> ieee80211_sta_update_pending_airtime() - that should prevent any errors
> from double-reporting of skbs (which is what I'm guessing is going on
> here).

It does feel like it, but I'm not sure how that'd be possible?

OK, I talked with Emmanuel and I think it's the GSO path - it'll end up
with skb_clone() and then report both of them back.

Regardless, I think I'll probably have to disable AQL and make it more
opt-in for the driver - I found a bunch of other issues ...

johannes

