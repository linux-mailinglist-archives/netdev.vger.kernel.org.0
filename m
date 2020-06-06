Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A261F05A2
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 09:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgFFH41 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 6 Jun 2020 03:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgFFH41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 03:56:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160A3C08C5C2;
        Sat,  6 Jun 2020 00:56:27 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jhTgZ-00BZ4i-T7; Sat, 06 Jun 2020 09:56:11 +0200
Date:   Sat, 06 Jun 2020 09:56:09 +0200
In-Reply-To: <CAHk-=wj0QUaYcLHKG=_fw65NqhGbqvnU958SkHak9mg9qNwR+A@mail.gmail.com> (sfid-20200606_004147_502343_4CEEBC12)
References: <CAHk-=wj0QUaYcLHKG=_fw65NqhGbqvnU958SkHak9mg9qNwR+A@mail.gmail.com> (sfid-20200606_004147_502343_4CEEBC12)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: Hang on wireless removal..
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From:   Johannes Berg <johannes@sipsolutions.net>
Message-ID: <5DD82C75-5868-4F2D-B90F-F6205CA85C66@sipsolutions.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, sorry for the top post, on my phone. 

Yes, your analysis is spot on I think. I've got a fix for this in my jberg/mac80211 tree, there's a deadlock with a work struct and the rtnl.

Sorry about that. My testing should've caught it, but that exact scenario didn't happen, and lockdep for disabled due to some unrelated issues at early boot,so this didn't show up... (I also sent fixes for the other issue in user mode Linux) 

Johannes

On 6 June 2020 00:41:27 CEST, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>So I think there's something wrong with wireless networking, and
>(likely) in particular turning off wireless. And I think the problem
>came in this merge window, because now my machine hangs on shutdown.
>
>My new desktop is otherwise working fine, but it has some unnecessary
>wireless capability on the motherboard, in the form of a Intel Wi-Fi 6
>AX200 module that I don't use (since I end up using wired gig ethernet
>instead).
>
>And while debugging the shutdown hang (symptom: systemd waits forever
>for NetworkManager and WPA supplicant), I turned off the WiFi.
>
>And what do you know, things went all sideways.
>
>They went sideways because everything that wants the rtnl lock seems
>to just hang.
>
>Example:
>
>  kworker/57:2    D    0  1592      2 0x80004080
>  Workqueue: events_power_efficient reg_check_chans_work [cfg80211]
>  Call Trace:
>   __schedule+0x30b/0x4b0
>   ? schedule+0x77/0xa0
>   ? schedule_preempt_disabled+0xa/0x10
>   ? __mutex_lock+0x264/0x410
>   ? psi_group_change+0x44/0x260
>   ? reg_check_chans_work+0x1d/0x300 [cfg80211]
>   ? __switch_to_asm+0x42/0x70
>   ? process_one_work+0x1fa/0x3f0
>   ? worker_thread+0x25d/0x480
>   ? kthread+0x121/0x130
>   ? process_one_work+0x3f0/0x3f0
>   ? kthread_blkcg+0x30/0x30
>   ? ret_from_fork+0x22/0x30
>  kworker/60:2    D    0  1926      2 0x80004000
>  Workqueue: ipv6_addrconf addrconf_verify_work
>  Call Trace:
>   __schedule+0x30b/0x4b0
>   ? schedule+0x77/0xa0
>   ? schedule_preempt_disabled+0xa/0x10
>   ? __mutex_lock+0x264/0x410
>   ? addrconf_verify_work+0xa/0x20
>   ? process_one_work+0x1fa/0x3f0
>   ? worker_thread+0x25d/0x480
>   ? kthread+0x121/0x130
>   ? process_one_work+0x3f0/0x3f0
>   ? kthread_blkcg+0x30/0x30
>   ? ret_from_fork+0x22/0x30
>  NetworkManager  D    0  4329      1 0x00004000
>  Call Trace:
>   __schedule+0x30b/0x4b0
>   ? schedule+0x77/0xa0
>   ? schedule_preempt_disabled+0xa/0x10
>   ? __mutex_lock+0x264/0x410
>   ? __netlink_dump_start+0xa7/0x300
>   ? rtnl_dellink+0x3c0/0x3c0
>   ? rtnetlink_rcv_msg+0x375/0x3d0
>   ? poll_freewait+0x35/0xa0
>   ? do_sys_poll+0x58f/0x5f0
>   ? rtnl_dellink+0x3c0/0x3c0
>   ? __ia32_compat_sys_ppoll_time64+0x120/0x120
>   ? ip_output+0x6a/0xd0
>   ? ip_mc_finish_output+0x120/0x120
>   ? avc_has_perm+0x34/0xa0
>   ? rtnetlink_bind+0x30/0x30
>   ? netlink_rcv_skb+0xfb/0x130
>   ? netlink_unicast+0x1bf/0x2e0
>   ? netlink_sendmsg+0x385/0x410
>   ? __sys_sendto+0x21f/0x230
>   ? move_addr_to_user+0x97/0xc0
>   ? alloc_file_pseudo+0x9b/0xd0
>   ? sock_alloc_file+0xc4/0x100
>   ? __x64_sys_sendto+0x22/0x30
>   ? do_syscall_64+0x5e/0xd0
>   ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
>and perhaps most interestingly, wpa_supplicant is waiting for some of
>those workqueues that are waiting for the lock:
>
>  wpa_supplicant  D    0  2162      1 0x00004000
>  Call Trace:
>   __schedule+0x30b/0x4b0
>   ? schedule+0x77/0xa0
>   ? schedule_timeout+0x22/0x150
>   ? ttwu_queue+0xf4/0x120
>   ? wait_for_common+0xac/0x110
>   ? __flush_work+0x200/0x230
>   ? put_pwq+0x70/0x70
>   ? __cfg80211_unregister_wdev+0x95/0x130 [cfg80211]
>   ? ieee80211_if_remove+0xa3/0xe0 [mac80211]
>   ? ieee80211_del_iface+0xe/0x20 [mac80211]
>   ? rdev_del_virtual_intf+0x2b/0xc0 [cfg80211]
>   ? genl_rcv_msg+0x451/0x570
>   ? genl_unbind+0xb0/0xb0
>   ? netlink_rcv_skb+0xfb/0x130
>   ? genl_rcv+0x24/0x40
>   ? netlink_unicast+0x1bf/0x2e0
>   ? netlink_sendmsg+0x385/0x410
>   ? ____sys_sendmsg+0x26b/0x290
>   ? __sys_sendmsg+0x128/0x180
>   ? selinux_socket_setsockopt+0xc3/0xd0
>   ? __cgroup_bpf_run_filter_setsockopt+0x99/0x290
>   ? netlink_setsockopt+0x38/0x4d0
>   ? __sys_setsockopt+0x11b/0x1b0
>   ? do_syscall_64+0x5e/0xd0
>   ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
>which explains why systemd waits for that one too.
>
>So something seems to have never released the rtnl lock.
>
>In fact, I suspect it's exactly that wpa_supplicant itself that
>deadlocks on it and holds the rntl lock while it does that
>"flush_work()". Which in turn waits for things to go away, but they'll
>never go away because they need the rtnl lock. That wpa_supplicant is
>holding.
>
>If I were a betting man, I'd suspect it's due to commit 6cd536fe62ef
>("cfg80211: change internal management frame registration API"), which
>seems to move that
>
>        flush_work(&wdev->mgmt_registrations_update_wk);
>
>into __cfg80211_unregister_wdev(). But honestly, that's just a guess.
>
>I'd bisect this and verify things, but I'm really hoping I don't have
>to.
>
>I still have a number of pull requests for the merge window, so
>instead I'm sending this email out with my current guesses, and I hope
>someody will say "Yeah, you're right, the fix is already pending", or
>"No Linus, you're barking up completely the wrong tree, but I think I
>know what the problem is".
>
>Btw, I'm not a networking person, but I have to say, I've seen rtnl
>lock problems enough over time even as an outsider to have grown to
>really hate that thing. Am I wrong? It really seems to get involved
>much too much, and held in really awkward places.
>
>Am I wrong?
>
>             Linus

-- 
Sent from my phone. 
