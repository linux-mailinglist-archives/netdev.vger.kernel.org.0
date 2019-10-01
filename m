Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F287C3089
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfJAJqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:46:39 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58372 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbfJAJqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 05:46:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFEjb-0004K9-6w; Tue, 01 Oct 2019 11:46:19 +0200
Message-ID: <46cce48de455acf073ad0582565d1fe34253f823.camel@sipsolutions.net>
Subject: Re: [PATCH v5.1-rc] iwlwifi: make locking in iwl_mvm_tx_mpdu()
 BH-safe
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 01 Oct 2019 11:46:17 +0200
In-Reply-To: <nycvar.YFH.7.76.1909111238470.473@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1904151300160.9803@cbobk.fhfr.pm>
          <24e05607b902e811d1142e3bd345af021fd3d077.camel@sipsolutions.net>
          <nycvar.YFH.7.76.1904151328270.9803@cbobk.fhfr.pm>
         <01d55c5cf513554d9cbdee0b14f9360a8df859c8.camel@sipsolutions.net>
         <nycvar.YFH.7.76.1909111238470.473@cbobk.fhfr.pm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

Sorry for the long delay.

>  CPU: 1 PID: 28401 Comm: kworker/u8:2 Tainted: G        W         5.3.0-rc8 #3
>  Hardware name: LENOVO 20K5S22R00/20K5S22R00, BIOS R0IET38W (1.16 ) 05/31/2017
>  Workqueue: phy0 ieee80211_beacon_connection_loss_work [mac80211]
>  Call Trace:
>   dump_stack+0x78/0xb3
>   mark_lock+0x28a/0x2a0
>   __lock_acquire+0x568/0x1020
>   ? iwl_mvm_set_tx_cmd+0x1c5/0x400 [iwlmvm]
>   lock_acquire+0xbd/0x1e0
>   ? iwl_mvm_tx_mpdu+0xae/0x600 [iwlmvm]
>   _raw_spin_lock+0x35/0x50
>   ? iwl_mvm_tx_mpdu+0xae/0x600 [iwlmvm]
>   iwl_mvm_tx_mpdu+0xae/0x600 [iwlmvm]
>   ? ieee80211_tx_h_select_key+0xf1/0x4a0 [mac80211]
>   iwl_mvm_tx_skb+0x1f8/0x460 [iwlmvm]
>   iwl_mvm_mac_itxq_xmit+0xcc/0x200 [iwlmvm]
>   ? iwl_mvm_mac_itxq_xmit+0x55/0x200 [iwlmvm]
>   _ieee80211_wake_txqs+0x2cf/0x660 [mac80211]
>   ? _ieee80211_wake_txqs+0x5/0x660 [mac80211]
>   ? __ieee80211_wake_queue+0x219/0x340 [mac80211]
>   ieee80211_wake_queues_by_reason+0x64/0xa0 [mac80211]
> 

I'm a bit confused by this.

ieee80211_wake_queues_by_reason() does
spin_lock_irqsave()/spin_unlock_irqrestore() - why is that "{SOFTIRQ-ON-
W} usage"?

Or what did you snip?

johannes

