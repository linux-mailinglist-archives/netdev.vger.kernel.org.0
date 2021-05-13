Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89AA83800B4
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhEMXIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 19:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhEMXIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 19:08:44 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4968DC061574;
        Thu, 13 May 2021 16:07:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a25so8588511edr.12;
        Thu, 13 May 2021 16:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vL7ETPWbViFTTrhJz2EQwiM7gIsfrAIWWuG3gVb7SgA=;
        b=AfkoTdohSfEyi1SM2vGzjZeV8Cmc2bHkLeEDYGAWg5/5cEACWO7OsN/dXvD3WCUD6L
         er0CSFCHhdpwqOb1Qu6CTDP0gvu6HajhmszqZCSUioD7Z2l1euouLI/vswcBuXcehX0K
         qQoU3hDOedTN0SicknfrfP/xWN23UOjcdLIeXPNkrieDFFsP9Yn7hzJrGU/9yaQgN+VH
         RB4vrDJv4HUnqhprVWjEuZ5fauLUbDklFx+9EStxUF+3LgUWbT6oGAwj1ZQ9R7VHWdoO
         sJW89JaZjFrUFzd7L1Zzi3LVyh7uzkLsaIvAWXSisndfa+xn0uICPr1VUMHTT+gVFaBJ
         F2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vL7ETPWbViFTTrhJz2EQwiM7gIsfrAIWWuG3gVb7SgA=;
        b=S1GqfUzLj88dkW2wLR9pSOiGsr708rSpWyv/KHh5Yf8d/+a0MKepFBBOM9SVl7IFKs
         i9bDgfKu4PmswbvHDMrOjqzGcy/ZwSQsmeDJCBK+cSZVNAbwvSMm1ChZs0VPzlDau8xd
         E9PAlRZPtBdafJSqt5tGIh8wsWaCJinxQVQhkelOb5vGgGw0cQ/xxU/0MHKMM+MEYRrZ
         Fz7o51j/W+ILCkp7CtuVC+vyQ6cdJ48B3GZAzCAAAPcITANCYQ9vkZdOe+rdfLya12AX
         eviilZhVxYsOudDXtuUWd2guaAPT3MryQG0mpFd5u+A4qse5OjzauPUO27+/ncwuBP4K
         nBBQ==
X-Gm-Message-State: AOAM53178ybjeYR3i87aZvkESn/dytNt/KwDbi6SU2CB4Dyg7VLd2mzU
        sbA9xGC/jVvMnC3ADeZawtLXIGOO6AE=
X-Google-Smtp-Source: ABdhPJwsPhtlwdOvD9R8VsYrMlU3dr002rKTyjXYDZWWQaNh2v7vezk57Dzzer7MW2uvGGHW4wBMVA==
X-Received: by 2002:aa7:cd50:: with SMTP id v16mr55389890edw.175.1620947251320;
        Thu, 13 May 2021 16:07:31 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a254.dip0.t-ipconnect.de. [217.229.162.84])
        by smtp.gmail.com with ESMTPSA id v12sm3290072edb.81.2021.05.13.16.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 16:07:30 -0700 (PDT)
To:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Subject: [BUG] Deadlock in _cfg80211_unregister_wdev()
Message-ID: <98392296-40ee-6300-369c-32e16cff3725@gmail.com>
Date:   Fri, 14 May 2021 01:07:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following commit a05829a7222e ("cfg80211: avoid holding the RTNL when
calling the driver"), the mwifiex_pcie module fails to unload. This also
prevents the device from rebooting / shutting down.

Attempting to unload the module produces the log pasted below. Upon
further investigation, this looks like a deadlock inside
_cfg80211_unregister_wdev():

- According to [1], this function expects the rdev->wiphy.mtx to be
   held.
- Down the line, this function (through some indirections, see third
   trace in log below) calls call_netdevice_notifiers(NETDEV_GOING_DOWN,
   ...) [2].
- One of the registered notifiers seems to be
   cfg80211_netdev_notifier_call(), which attempts to lock
   rdev->wiphy.mtx again [3], completing the deadlock.

Regards,
Max


[1]: https://elixir.bootlin.com/linux/v5.13-rc1/source/net/wireless/core.c#L1130
[2]: https://elixir.bootlin.com/linux/v5.13-rc1/source/net/core/dev.c#L1667
[3]: https://elixir.bootlin.com/linux/v5.13-rc1/source/net/wireless/core.c#L1428

[  245.504760] INFO: task kworker/u16:1:107 blocked for more than 122 seconds.
[  245.504764]       Tainted: G         C OE     5.11.0-1-surface-dev #2
[  245.504765] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  245.504766] task:kworker/u16:1   state:D stack:    0 pid:  107 ppid:     2 flags:0x00004000
[  245.504771] Workqueue: events_power_efficient reg_check_chans_work [cfg80211]
[  245.504817] Call Trace:
[  245.504820]  __schedule+0x2dd/0x8b0
[  245.504826]  schedule+0x5b/0xc0
[  245.504829]  schedule_preempt_disabled+0x11/0x20
[  245.504831]  __mutex_lock.constprop.0+0x317/0x500
[  245.504835]  reg_check_chans_work+0x2d/0x3c0 [cfg80211]
[  245.504867]  process_one_work+0x214/0x3e0
[  245.504870]  worker_thread+0x4d/0x3d0
[  245.504872]  ? rescuer_thread+0x410/0x410
[  245.504874]  kthread+0x133/0x150
[  245.504877]  ? __kthread_bind_mask+0x60/0x60
[  245.504880]  ret_from_fork+0x22/0x30
[  245.504900] INFO: task wpa_supplicant:903 blocked for more than 122 seconds.
[  245.504901]       Tainted: G         C OE     5.11.0-1-surface-dev #2
[  245.504902] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  245.504903] task:wpa_supplicant  state:D stack:    0 pid:  903 ppid:     1 flags:0x00000000
[  245.504906] Call Trace:
[  245.504907]  __schedule+0x2dd/0x8b0
[  245.504910]  schedule+0x5b/0xc0
[  245.504912]  schedule_preempt_disabled+0x11/0x20
[  245.504914]  __mutex_lock.constprop.0+0x317/0x500
[  245.504917]  nl80211_pre_doit+0x16/0x130 [cfg80211]
[  245.504951]  genl_family_rcv_msg_doit+0xe7/0x160
[  245.504956]  genl_rcv_msg+0xef/0x1e0
[  245.504959]  ? nl80211_send_scan_start+0x90/0x90 [cfg80211]
[  245.504993]  ? genl_get_cmd+0xd0/0xd0
[  245.504996]  netlink_rcv_skb+0x5b/0x100
[  245.504999]  genl_rcv+0x24/0x40
[  245.505002]  netlink_unicast+0x242/0x340
[  245.505004]  netlink_sendmsg+0x243/0x480
[  245.505007]  sock_sendmsg+0x5e/0x60
[  245.505011]  ____sys_sendmsg+0x25a/0x2a0
[  245.505013]  ? copy_msghdr_from_user+0x6e/0xa0
[  245.505017]  ___sys_sendmsg+0x97/0xe0
[  245.505022]  __sys_sendmsg+0x81/0xd0
[  245.505025]  do_syscall_64+0x33/0x40
[  245.505028]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  245.505032] RIP: 0033:0x7fa6606cd737
[  245.505034] RSP: 002b:00007ffddff52178 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  245.505036] RAX: ffffffffffffffda RBX: 0000559697c3e780 RCX: 00007fa6606cd737
[  245.505038] RDX: 0000000000000000 RSI: 00007ffddff521b0 RDI: 0000000000000006
[  245.505039] RBP: 0000559697c3e690 R08: 0000000000000004 R09: 00007fa66078ea60
[  245.505040] R10: 00007ffddff52284 R11: 0000000000000246 R12: 0000559697c7a9a0
[  245.505042] R13: 00007ffddff521b0 R14: 00007ffddff52284 R15: 0000559697c71100
[  245.505072] INFO: task modprobe:1930 blocked for more than 122 seconds.
[  245.505073]       Tainted: G         C OE     5.11.0-1-surface-dev #2
[  245.505074] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  245.505075] task:modprobe        state:D stack:    0 pid: 1930 ppid:  1879 flags:0x00004004
[  245.505078] Call Trace:
[  245.505079]  __schedule+0x2dd/0x8b0
[  245.505082]  schedule+0x5b/0xc0
[  245.505084]  schedule_preempt_disabled+0x11/0x20
[  245.505086]  __mutex_lock.constprop.0+0x317/0x500
[  245.505088]  ? vprintk_emit+0x13a/0x270
[  245.505093]  cfg80211_netdev_notifier_call+0x12a/0x4e0 [cfg80211]
[  245.505125]  raw_notifier_call_chain+0x44/0x60
[  245.505127]  __dev_close_many+0x6b/0x120
[  245.505130]  dev_close_many+0x92/0x140
[  245.505132]  unregister_netdevice_many+0x150/0x6f0
[  245.505135]  unregister_netdevice_queue+0x96/0xd0
[  245.505138]  _cfg80211_unregister_wdev+0x135/0x1d0 [cfg80211]
[  245.505167]  mwifiex_del_virtual_intf+0x178/0x1a0 [mwifiex]
[  245.505181]  mwifiex_uninit_sw+0x1cf/0x1f0 [mwifiex]
[  245.505188]  mwifiex_remove_card+0x7b/0x80 [mwifiex]
[  245.505196]  pci_device_remove+0x3b/0xa0
[  245.505200]  __device_release_driver+0x17a/0x230
[  245.505204]  driver_detach+0xc9/0x110
[  245.505206]  bus_remove_driver+0x58/0xd0
[  245.505208]  pci_unregister_driver+0x3b/0x90
[  245.505211]  __do_sys_delete_module+0x19e/0x2a0
[  245.505216]  do_syscall_64+0x33/0x40
[  245.505218]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  245.505221] RIP: 0033:0x7fd803e30cab
[  245.505223] RSP: 002b:00007fffa7589d58 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[  245.505224] RAX: ffffffffffffffda RBX: 0000559b9ae6ce80 RCX: 00007fd803e30cab
[  245.505226] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000559b9ae6cee8
[  245.505227] RBP: 0000559b9ae6ce80 R08: 0000000000000000 R09: 0000000000000000
[  245.505228] R10: 00007fd803ea4ac0 R11: 0000000000000206 R12: 0000559b9ae6cee8
[  245.505229] R13: 0000000000000000 R14: 0000000000000000 R15: 0000559b9ae6c5d0

