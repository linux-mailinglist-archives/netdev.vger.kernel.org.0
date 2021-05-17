Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E89382D1D
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 15:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhEQNRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 09:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235470AbhEQNRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 09:17:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CADC061573;
        Mon, 17 May 2021 06:16:27 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lid6Y-00ALU5-VK; Mon, 17 May 2021 15:16:19 +0200
Message-ID: <048c4fb6c91931e9fcd240df7a5586633893c31a.camel@sipsolutions.net>
Subject: Re: [syzbot] divide error in mac80211_hwsim_bss_info_changed
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+26727b5e00947e02242c@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Date:   Mon, 17 May 2021 15:16:17 +0200
In-Reply-To: <000000000000fb328005c2844acc@google.com> (sfid-20210517_124535_257596_E84F0A94)
References: <000000000000fb328005c2844acc@google.com>
         (sfid-20210517_124535_257596_E84F0A94)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-05-17 at 03:45 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    eebe426d Merge tag 'fixes-for-5.12-rc7' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15e73ceed00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9c3d8981d2bdb103
> dashboard link: https://syzkaller.appspot.com/bug?extid=26727b5e00947e02242c
> compiler:       Debian clang version 11.0.1-2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 

That's not very surprising ...

> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+26727b5e00947e02242c@syzkaller.appspotmail.com
> 
> divide error: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 13049 Comm: kworker/u4:16 Not tainted 5.12.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: phy10 ieee80211_roc_work
> RIP: 0010:mac80211_hwsim_bss_info_changed+0x514/0xf90 drivers/net/wireless/mac80211_hwsim.c:2024

The issue here is that we have the following code in offchannel.c:

        mutex_lock(&local->iflist_mtx);
        list_for_each_entry(sdata, &local->interfaces, list) {
...
                if (test_and_clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED,
                                       &sdata->state)) {
                        sdata->vif.bss_conf.enable_beacon = true;
                        ieee80211_bss_info_change_notify(
                                sdata, BSS_CHANGED_BEACON_ENABLED);
                }


However, we have the following code in ibss.c
ieee80211_ibss_disconnect():

        sdata->vif.bss_conf.ibss_joined = false;
        sdata->vif.bss_conf.ibss_creator = false;
        sdata->vif.bss_conf.enable_beacon = false;
        sdata->vif.bss_conf.ssid_len = 0;

        /* remove beacon */
        presp = rcu_dereference_protected(ifibss->presp,
                                          lockdep_is_held(&sdata->wdev.mtx));
        RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
        if (presp)
                kfree_rcu(presp, rcu_head);

        clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
        ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
                                                BSS_CHANGED_IBSS);


There's no common locking here, so it's simply racy.

Normally, all of the ieee80211_ibss_disconnect() happens together, but
if ieee80211_offchannel_return() happens to hit here before
SDATA_STATE_OFFCHANNEL_BEACON_STOPPED is cleared, we might inadvertently
enable beaconing while the interface is actually stopping.

I'm not really sure what happens next, but perhaps the interface is
going down and the beacon_int is reset to 0, or such, leading to the
problem at hand.


Off the top of my head, I don't really have a good idea about how to fix
this - we'd want to add some more consistent locking everywhere. I
assume that with the rtnl-weaning having happened, that might simply
consist in aligning mac80211 to the cfg80211 wiphy mutex everywhere.

johannes

