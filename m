Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447FCC30AB
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbfJAJxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:53:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58438 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJAJxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:53:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFEq2-0004UP-IC; Tue, 01 Oct 2019 11:52:58 +0200
Message-ID: <9b6f5c279e8aea8e6241d03b0b21de88ac49e8b2.camel@sipsolutions.net>
Subject: Re: [PATCH v5.1-rc] iwlwifi: make locking in iwl_mvm_tx_mpdu()
 BH-safe
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Date:   Tue, 01 Oct 2019 11:52:57 +0200
In-Reply-To: <46cce48de455acf073ad0582565d1fe34253f823.camel@sipsolutions.net>
References: <nycvar.YFH.7.76.1904151300160.9803@cbobk.fhfr.pm>
         <24e05607b902e811d1142e3bd345af021fd3d077.camel@sipsolutions.net>
         <nycvar.YFH.7.76.1904151328270.9803@cbobk.fhfr.pm>
         <01d55c5cf513554d9cbdee0b14f9360a8df859c8.camel@sipsolutions.net>
         <nycvar.YFH.7.76.1909111238470.473@cbobk.fhfr.pm>
         <46cce48de455acf073ad0582565d1fe34253f823.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-01 at 11:46 +0200, Johannes Berg wrote:
> 
> ieee80211_wake_queues_by_reason() does
> spin_lock_irqsave()/spin_unlock_irqrestore() - why is that "{SOFTIRQ-ON-
> W} usage"?

scratch that - _ieee80211_wake_txqs() unlocks that again...

It does hold RCU critical section, but that's not the same as disabling
BHs.

I think we should do this perhaps - I think it'd be better to ensure
that the drivers' wake_tx_queue op is always called with softirqs
disabled, since that happens in almost all cases already ...


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
 
Perhaps we could add some validation into drv_wake_tx_queue(), but I
didn't find the right thing to call right now ...


Toke, what do you think?

johannes

