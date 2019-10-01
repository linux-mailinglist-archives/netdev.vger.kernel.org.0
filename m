Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23FCC30D0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfJAKBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:01:04 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58558 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbfJAKBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 06:01:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFExh-0004h9-V7; Tue, 01 Oct 2019 12:00:54 +0200
Message-ID: <457e2714b0cdf05eb404b8efcf5b8c6c0c47aeaa.camel@sipsolutions.net>
Subject: Re: [PATCH] net: mac80211: Disable preeemption when updating stat
 counters
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aaron Hill <aa1ronham@gmail.com>, linux-wireless@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Date:   Tue, 01 Oct 2019 12:00:52 +0200
In-Reply-To: <20190927154102.GA117350@ArchLaptop> (sfid-20190927_174105_775365_206EE7BA)
References: <20190927154102.GA117350@ArchLaptop>
         (sfid-20190927_174105_775365_206EE7BA)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-09-27 at 11:41 -0400, Aaron Hill wrote:
> The mac80211 subsystem maintains per-cpu stat counters for receive and
> transmit operations. Previously, preemption was not disabled when
> updating these counters. This creates a race condition where two cpus
> could attempt to update the same counters using non-atomic operations.
> 
> This was causing a
> 'BUG: using smp_processor_id() in preemptible [00000000] code'
> message to be printed, along with a stacktrace. This was reported
> in a few different places:
> 
> * https://www.spinics.net/lists/linux-wireless/msg189992.html
> * https://bugzilla.kernel.org/show_bug.cgi?id=204127
> 
> This patch adds calls to preempt_disable() and preempt_enable()
> surrounding the updating of the stat counters.

That seems like basically the same as what Jiri reported, but now I'm
even more confused...

Ah. CONFIG_PREEMPT_RCU...

But if we keep BHs disabled, it should still be OK, so what I suggested
to Jiri will also address this I think?

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 051a02ddcb85..ad1e88958da2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -273,9 +273,9 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 						&txqi->flags))
 				continue;
 
-			spin_unlock_bh(&fq->lock);
+			spin_unlock(&fq->lock);
 			drv_wake_tx_queue(local, txqi);
-			spin_lock_bh(&fq->lock);
+			spin_lock(&fq->lock);
 		}
 	}
 

johannes

