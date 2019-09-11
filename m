Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46E0AFBA4
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbfIKLnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbfIKLnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 07:43:10 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BCAE20CC7;
        Wed, 11 Sep 2019 11:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568202189;
        bh=YzWZW7fIuQ/hMWEfEFuyifHV7xQrAuW9vHt/Tk5o2pY=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=aPfd+XVspS17VU4U2mkQl6Yc4E2z+1yRNW+uYs18CSe7JJAuk+1FzZu+3SE5KNTJT
         k1ikshr4Ua440fWfMYE/HvxdawoEX9KTNuM4Sq1etzk0GjHQRxqjT0XCQkuU8U7sBO
         LSiuf6tIZwox4urGzreZGw/V59EemNYHp4Q8+1xs=
Date:   Wed, 11 Sep 2019 12:42:38 +0100 (WEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5.1-rc] iwlwifi: make locking in iwl_mvm_tx_mpdu()
 BH-safe
In-Reply-To: <01d55c5cf513554d9cbdee0b14f9360a8df859c8.camel@sipsolutions.net>
Message-ID: <nycvar.YFH.7.76.1909111238470.473@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1904151300160.9803@cbobk.fhfr.pm>  <24e05607b902e811d1142e3bd345af021fd3d077.camel@sipsolutions.net>  <nycvar.YFH.7.76.1904151328270.9803@cbobk.fhfr.pm> <01d55c5cf513554d9cbdee0b14f9360a8df859c8.camel@sipsolutions.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Apr 2019, Johannes Berg wrote:

> > If there are other reasons why disable BH for the whole function (are 
> > there?), then this bigger hammer works as well of course.
> 
> I thought there are, but seeing the commit log here I'm not sure.
> 
> In any case, even if not, the function itself is part of the TX fast
> path, but the caller from the workqueue is very uncommon (basically only
> happens for a handful of packets on each new RA/TID), so I'd say that'd
> be a good reason to use the slightly bigger hammer (it's not that much
> different really, if you look at how much code is covered by the lock)
> and avoid doing it all the time when we know it to be not needed.

So this now popped up on me with current Linus' tree from a different 
codepath, see below. Therefore I'd like to propose bringing my previous 
patch back to life.

Thanks.




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] iwlwifi: make locking in iwl_mvm_tx_mpdu() BH-safe

iwl_mvm_sta->lock can be taken from BH, and therefore BH must be disabled if
taking it from other contexts.

This fixes the lockdep warning below.

 ================================
 WARNING: inconsistent lock state
 5.3.0-rc8 #3 Tainted: G        W
 --------------------------------
 inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
 kworker/u8:2/28401 [HC0[0]:SC0[0]:HE1:SE1] takes:
 000000009c020e13 (&(&mvm_sta->lock)->rlock){+.?.}, at: iwl_mvm_tx_mpdu+0xae/0x600 [iwlmvm]
 {IN-SOFTIRQ-W} state was registered at:
   lock_acquire+0xbd/0x1e0
   _raw_spin_lock+0x35/0x50
   iwl_mvm_tx_mpdu+0xae/0x600 [iwlmvm]
   iwl_mvm_tx_skb+0x1f8/0x460 [iwlmvm]
   iwl_mvm_mac_itxq_xmit+0xcc/0x200 [iwlmvm]
   ieee80211_queue_skb+0x290/0x4c0 [mac80211]
   ieee80211_xmit_fast+0x814/0xa70 [mac80211]
   __ieee80211_subif_start_xmit+0x132/0x380 [mac80211]
   ieee80211_subif_start_xmit+0x49/0x370 [mac80211]
   dev_hard_start_xmit+0xaf/0x340
   __dev_queue_xmit+0x98d/0xd20
   ip6_finish_output2+0x323/0x960
   ip6_output+0x19d/0x2d0
   mld_sendpack+0x361/0x3a0
   mld_ifc_timer_expire+0x19f/0x2e0
   call_timer_fn+0x97/0x300
   run_timer_softirq+0x233/0x590
   __do_softirq+0x12c/0x448
   irq_exit+0xa5/0xb0
   smp_apic_timer_interrupt+0xac/0x2a0
   apic_timer_interrupt+0xf/0x20
   cpuidle_enter_state+0xbf/0x450
   cpuidle_enter+0x29/0x40
   do_idle+0x1cc/0x290
   cpu_startup_entry+0x19/0x20
   start_secondary+0x15f/0x1a0
   secondary_startup_64+0xa4/0xb0
[ ... snip ... ]
               stack backtrace:
 CPU: 1 PID: 28401 Comm: kworker/u8:2 Tainted: G        W         5.3.0-rc8 #3
 Hardware name: LENOVO 20K5S22R00/20K5S22R00, BIOS R0IET38W (1.16 ) 05/31/2017
 Workqueue: phy0 ieee80211_beacon_connection_loss_work [mac80211]
 Call Trace:
  dump_stack+0x78/0xb3
  mark_lock+0x28a/0x2a0
  __lock_acquire+0x568/0x1020
  ? iwl_mvm_set_tx_cmd+0x1c5/0x400 [iwlmvm]
  lock_acquire+0xbd/0x1e0
  ? iwl_mvm_tx_mpdu+0xae/0x600 [iwlmvm]
  _raw_spin_lock+0x35/0x50
  ? iwl_mvm_tx_mpdu+0xae/0x600 [iwlmvm]
  iwl_mvm_tx_mpdu+0xae/0x600 [iwlmvm]
  ? ieee80211_tx_h_select_key+0xf1/0x4a0 [mac80211]
  iwl_mvm_tx_skb+0x1f8/0x460 [iwlmvm]
  iwl_mvm_mac_itxq_xmit+0xcc/0x200 [iwlmvm]
  ? iwl_mvm_mac_itxq_xmit+0x55/0x200 [iwlmvm]
  _ieee80211_wake_txqs+0x2cf/0x660 [mac80211]
  ? _ieee80211_wake_txqs+0x5/0x660 [mac80211]
  ? __ieee80211_wake_queue+0x219/0x340 [mac80211]
  ieee80211_wake_queues_by_reason+0x64/0xa0 [mac80211]
  ieee80211_set_disassoc+0x3b1/0x520 [mac80211]
  __ieee80211_disconnect+0x81/0x110 [mac80211]
  process_one_work+0x1f0/0x5b0
  ? process_one_work+0x16a/0x5b0
  worker_thread+0x4c/0x3f0
  kthread+0x103/0x140
  ? process_one_work+0x5b0/0x5b0
  ? kthread_bind+0x10/0x10
  ret_from_fork+0x3a/0x50

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 6ac114a393cc..bcfb290beaaf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1106,7 +1106,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 */
 	info->flags &= ~IEEE80211_TX_STATUS_EOSP;
 
-	spin_lock(&mvmsta->lock);
+	spin_lock_bh(&mvmsta->lock);
 
 	/* nullfunc frames should go to the MGMT queue regardless of QOS,
 	 * the condition of !ieee80211_is_qos_nullfunc(fc) keeps the default
@@ -1145,7 +1145,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 	if (WARN_ONCE(txq_id == IWL_MVM_INVALID_QUEUE, "Invalid TXQ id")) {
 		iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
-		spin_unlock(&mvmsta->lock);
+		spin_unlock_bh(&mvmsta->lock);
 		return 0;
 	}
 
@@ -1181,7 +1181,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (tid < IWL_MAX_TID_COUNT && !ieee80211_has_morefrags(fc))
 		mvmsta->tid_data[tid].seq_number = seq_number + 0x10;
 
-	spin_unlock(&mvmsta->lock);
+	spin_unlock_bh(&mvmsta->lock);
 
 	if (iwl_mvm_tx_pkt_queued(mvm, mvmsta,
 				  tid == IWL_MAX_TID_COUNT ? 0 : tid))
@@ -1191,7 +1191,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 
 drop_unlock_sta:
 	iwl_trans_free_tx_cmd(mvm->trans, dev_cmd);
-	spin_unlock(&mvmsta->lock);
+	spin_unlock_bh(&mvmsta->lock);
 drop:
 	IWL_DEBUG_TX(mvm, "TX to [%d|%d] dropped\n", mvmsta->sta_id, tid);
 	return -1;

-- 
Jiri Kosina
SUSE Labs

