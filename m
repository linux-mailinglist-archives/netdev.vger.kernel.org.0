Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCF011AC61
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfLKNqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:46:02 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:54366 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbfLKNqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:46:00 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1if2JP-0048cr-P6; Wed, 11 Dec 2019 14:45:55 +0100
Message-ID: <d4a48cbdc4b0db7b07b8776a1ee70b140e8a9bbf.camel@sipsolutions.net>
Subject: Re: iwlwifi warnings in 5.5-rc1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Steve French <smfrench@gmail.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Date:   Wed, 11 Dec 2019 14:45:54 +0100
In-Reply-To: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> (sfid-20191210_214627_221076_8C5C32D1)
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
         (sfid-20191210_214627_221076_8C5C32D1)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

++ others who reported this

On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:

> ------------[ cut here ]------------
> STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 208

We think this is due to TSO, the change below will disable the AQL again
for now until we can figure out how to really fix it. I think I'll do
the equivalent for 5.5 and maybe leave it enabled only for ath10k, or
something like that ...

johannes


diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6cca0853f183..4c2b5ba3ac09 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -672,9 +672,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			IEEE80211_DEFAULT_AQL_TXQ_LIMIT_H;
 	}
 
-	local->airtime_flags = AIRTIME_USE_TX |
-			       AIRTIME_USE_RX |
-			       AIRTIME_USE_AQL;
+	local->airtime_flags = AIRTIME_USE_TX | AIRTIME_USE_RX;
 	local->aql_threshold = IEEE80211_AQL_THRESHOLD;
 	atomic_set(&local->aql_total_pending_airtime, 0);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8eafd81e97b4..a14d0dac52e8 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1916,6 +1916,9 @@ void ieee80211_sta_update_pending_airtime(struct ieee80211_local *local,
 {
 	int tx_pending;
 
+	if (!(local->airtime_flags & AIRTIME_USE_AQL))
+		return;
+
 	if (!tx_completed) {
 		if (sta)
 			atomic_add(tx_airtime,


