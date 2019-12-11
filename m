Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F70811BEF9
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 22:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfLKVS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 16:18:28 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41136 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLKVS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 16:18:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1if9NG-0055Qg-Vw; Wed, 11 Dec 2019 22:18:23 +0100
Message-ID: <aa22bfce34e5a938e439b0507296a8b6a23f5c61.camel@sipsolutions.net>
Subject: Re: iwlwifi warnings in 5.5-rc1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Date:   Wed, 11 Dec 2019 22:18:21 +0100
In-Reply-To: <87k172gbrn.fsf@toke.dk>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
         <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
         <878snjgs5l.fsf@toke.dk>
         <3420d73e667b01ec64bf0cc9da6232b41e862860.camel@sipsolutions.net>
         <875zingnzt.fsf@toke.dk>
         <bfab4987668990ea8d86a98f3e87c3fa31403745.camel@sipsolutions.net>
         <14bbfcc8408500704c46701251546e7ff65c6fd0.camel@sipsolutions.net>
         <87r21bez5g.fsf@toke.dk>
         <b14519e81b6d2335bd0cb7dcf074f0d1a4eec707.camel@sipsolutions.net>
         <87k172gbrn.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-12-11 at 15:47 +0100, Toke Høiland-Jørgensen wrote:

> > Say you have some queues - some (Q1-Qn) got a LOT of traffic, and
> > another (Q0) just has some interactive traffic.
> > 
> > You could then end up in a situation where you have 24ms queued up on
> > Q1-Qn (with n high enough to not have hit the per-queue AQL limit),
> > right?
> > 
> > Say also the last frame on Q0 was dequeued by the hardware, but the
> > tx_dequeue() got NULL because of the AQL limit having been eaten up by
> > all the packets on Q1-Qn.
> > 
> > Now you'll no longer get a new dequeue attempt on Q0 (it was already
> > empty last time, so no hardware reclaim to trigger new dequeues), and a
> > new dequeue on the *other* queues will not do anything for this queue.
> 
> Oh, right, I see; yeah, that could probably happen. I guess we could
> either kick all available queues whenever the global limit goes from
> "above" to "below"; or we could remove the "return NULL" logic from
> tx_dequeue() and rely on next_txq() to throttle. I think the latter is
> probably simpler, but I'm a little worried that the throttling will
> become too lax (because the driver can keep dequeueing in the same
> scheduling round)...

I honestly have no idea what's better ... :) You're the expert, I'm just
poking holes into it ;-)

johannes

