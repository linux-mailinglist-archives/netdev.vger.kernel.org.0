Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C2411D036
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 15:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbfLLOuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 09:50:22 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:42610 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbfLLOuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 09:50:22 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ifPnH-007Ghk-QV; Thu, 12 Dec 2019 15:50:19 +0100
Message-ID: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
Subject: debugging TCP stalls on high-speed wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 12 Dec 2019 15:50:18 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric, all,

I've been debugging (much thanks to bpftrace) TCP stalls on wifi, in
particular on iwlwifi.

What happens, essentially, is that we transmit large aggregates (63
packets of 7.5k A-MSDU size each, for something on the order of 500kB
per PPDU). Theoretically we can have ~240 A-MSDUs on our hardware
queues, and the hardware aggregates them into up to 63 to send as a
single PPDU.

At HE rates (160 MHz, high rates) such a large PPDU takes less than 2ms
to transmit.

I'm seeing around 1400 Mbps TCP throughput (a bit more than 1800 UDP),
but I'm expecting more. A bit more than 1800 for UDP is about the max I
can expect on this AP (it only does 8k A-MSDU size), but I'd think TCP
then shouldn't be so much less (and our Windows drivers gets >1600).


What I see is that occasionally - and this doesn't happen all the time
but probably enough to matter - we reclaim a few of those large
aggregates and free the transmit SKBs, and then we try to pull from
mac80211's TXQs but they're empty.

At this point - we've just freed 400+k of data, I'd expect TCP to
immediately push more, but it doesn't happen. I sometimes see another
set of reclaims emptying the queue entirely (literally down to 0 packets
on the queue) and it then takes another millisecond or two for TCP to
start pushing packets again.

Once that happens, I also observe that TCP stops pushing large TSO
packets and goes down to sometimes less than a single A-MSDU (i.e.
~7.5k) in a TSO, perhaps even an MTU-sized frame - didn't check this,
only the # of frames we make out of this.


If you have any thoughts on this, I'd appreciate it.


Something I've been wondering is if our TSO implementation causes
issues, but apart from higher CPU usage I see no real difference if I
turned it off. I thought so because it splits up the SKBs into those A-
MSDU sized chunks using skb_gso_segment() and then splits them down into
MTU-sized all packed together into an A-MSDU using the hardware engine.
But that means we release a bunch of A-MSDU-sized SKBs back to the TCP
stack when they transmitted.

Another thought I had was our broken NAPI, but this is TX traffic so the
only RX thing is sync, and I'm currently still using kernel 5.4 anyway.

Thanks,
johannes

