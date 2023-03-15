Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEC26BBE37
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjCOU5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCOU5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:57:14 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC438C511;
        Wed, 15 Mar 2023 13:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678913832; x=1710449832;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GZB+pGFd4g4gVJhsEY3uj7hAnZkkO1wkG+yC1Ppemu8=;
  b=Y0tacMrA5aJ0MpKKpmoz06HGWv8RCsLK8xp8x8v2A0B6Svw6+rwV5MbI
   vnu1mJCDrQtBSpABAwhODXaCqebReO5z3rrzIH1/9lSPky3dF0fXberP9
   yF2HbC+4WV97ncEsin9b+TD6v5hziHDkZpgBJ5K9YMK6u7HYKOlfPiZL+
   I=;
X-IronPort-AV: E=Sophos;i="5.98,262,1673913600"; 
   d="scan'208";a="307652462"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 20:57:08 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com (Postfix) with ESMTPS id 460C044DCF;
        Wed, 15 Mar 2023 20:57:05 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 15 Mar 2023 20:56:51 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.20) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 15 Mar 2023 20:56:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <mirsad.todorovac@alu.unizg.hr>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <shuah@kernel.org>,
        <kuniyu@amazon.com>
Subject: Re: BUG: selftest/net/tun: Hang in unregister_netdevice
Date:   Wed, 15 Mar 2023 13:56:39 -0700
Message-ID: <20230315205639.38461-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <910f9616-fdcc-51bd-786d-8ecc9f4b5179@alu.unizg.hr>
References: <910f9616-fdcc-51bd-786d-8ecc9f4b5179@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.101.20]
X-ClientProxiedBy: EX19D042UWA002.ant.amazon.com (10.13.139.17) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Date:   Tue, 14 Mar 2023 21:10:55 +0100
> On 14. 03. 2023. 17:02, Eric Dumazet wrote:
> > On Tue, Mar 14, 2023 at 9:01 AM Mirsad Todorovac
> > <mirsad.todorovac@alu.unizg.hr> wrote:
> > 
> >> After a while, kernel message start looping:
> >>
> >>   kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> >>
> >> Message from syslogd@pc-mtodorov at Mar 14 16:57:15 ...
> >>   kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> >>
> >> Message from syslogd@pc-mtodorov at Mar 14 16:57:24 ...
> >>   kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> >>
> >> Message from syslogd@pc-mtodorov at Mar 14 16:57:26 ...
> >>   kernel:unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> >>
> >> This hangs processes until very late stage of shutdown.
> >>
> >> I can confirm that CONFIG_DEBUG_{KOBJECT,KOBJECT_RELEASE}=y were the only changes
> >> to .config in between builds.

KOBJECT_RELEASE delays freeing kobject with delayed_work.

In the failing tests, e.g. reattach_delete_close, we create
a tun dev and do

  1. detach (tun_detach())
  2. re-attach (tun_attach())
  3. close

.  We release kobjects (tun->dev->(_tx|_rx).kobj) in 1. and
recycle the same memory region in 2.

But the kobjects are not actually released due to the delay,
thus netdev_queue_add_kobject() and rx_queue_add_kobject()
fail.

---8<---
#  RUN           tun.reattach_delete_close ...
[  179.087589] kobject: 'tx-1' (00000000ee182e2f): kobject_release, parent 000000000643eb5f (delayed 3000)
[  179.088105] kobject: 'rx-1' (000000001c44852d): kobject_release, parent 000000000643eb5f (delayed 1000)
[  179.089097] kobject (00000000ee182e2f): tried to init an initialized object, something is seriously wrong.
---8<---

However, we don't assume the delay and also the failure in
tun_set_real_num_queues().

In this case, we have to re-initialise the queues without
touching kobjects.

Eric,
Are you working on this?
If not, let me try fixing this :)

Thanks,
Kuniyuki


> >>
> >> Best regards,
> >> Mirsad
> >>
> > 
> > Try adding in your config
> > 
> > CONFIG_NET_DEV_REFCNT_TRACKER=y
> > CONFIG_NET_NS_REFCNT_TRACKER=y
> > 
> > Thanks.
> 
> Not at all.
> 
> According to the info here: https://cateee.net/lkddb/web-lkddb/NET_DEV_REFCNT_TRACKER.html
> no kerenel param was needed.
> 
> I have got the same hang, and additional debug information appears to be this
> (in /var/log/messages):
> 
> Mar 14 20:58:20 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:58:20 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:20 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:58:20 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:58:20 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:58:20 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:20 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:20 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:20 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:20 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:20 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:20 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:58:20 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:58:20 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:58:20 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:20 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:20 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:20 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:20 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:20 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:58:20 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:20 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:58:20 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:58:20 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:58:20 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:20 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:20 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:20 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:20 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:20 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:20 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:58:20 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:58:20 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:58:20 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:20 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:20 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:20 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:20 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:30 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:58:30 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:30 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:58:30 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:58:30 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:58:30 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:30 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:30 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:30 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:30 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:30 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:30 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:58:30 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:58:30 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:58:30 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:30 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:30 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:30 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:30 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:30 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:58:30 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:30 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:58:30 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:58:30 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:58:30 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:30 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:30 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:30 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:30 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:30 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:30 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:58:30 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:58:30 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:58:30 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:30 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:30 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:30 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:30 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:40 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:58:40 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:40 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:58:40 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:58:40 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:58:40 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:40 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:40 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:40 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:40 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:40 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:40 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:58:40 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:58:40 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:58:40 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:40 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:40 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:40 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:40 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:40 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:58:40 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:40 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:58:40 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:58:40 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:58:40 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:40 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:40 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:40 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:40 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:40 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:40 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:58:40 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:58:40 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:58:40 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:40 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:40 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:40 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:40 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:50 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:58:50 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:50 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:58:50 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:58:50 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:58:50 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:50 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:50 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:50 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:50 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:50 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:50 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:58:50 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:58:50 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:58:50 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:50 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:50 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:50 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:50 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:50 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:58:50 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:50 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:58:50 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:58:50 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:58:50 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:50 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:50 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:50 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:50 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:50 pc-mtodorov kernel: leaked reference.
> Mar 14 20:58:50 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:58:50 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:58:50 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:58:50 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:58:50 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:58:50 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:58:50 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:58:50 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:58:57 pc-mtodorov kernel: kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> Mar 14 20:59:00 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:59:00 pc-mtodorov kernel: leaked reference.
> Mar 14 20:59:00 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:59:00 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:59:00 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:59:00 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:59:00 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:59:00 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:59:00 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:59:00 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:59:00 pc-mtodorov kernel: leaked reference.
> Mar 14 20:59:00 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:59:00 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:59:00 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:59:00 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:59:00 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:59:00 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:59:00 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:59:00 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:59:01 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:59:01 pc-mtodorov kernel: leaked reference.
> Mar 14 20:59:01 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:59:01 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:59:01 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:59:01 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:59:01 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:59:01 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:59:01 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:59:01 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:59:01 pc-mtodorov kernel: leaked reference.
> Mar 14 20:59:01 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:59:01 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:59:01 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:59:01 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:59:01 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:59:01 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:59:01 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:59:01 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:59:10 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:59:10 pc-mtodorov kernel: leaked reference.
> Mar 14 20:59:10 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:59:10 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:59:10 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:59:10 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:59:10 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:59:10 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:59:10 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:59:10 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:59:10 pc-mtodorov kernel: leaked reference.
> Mar 14 20:59:10 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:59:10 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:59:10 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:59:10 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:59:10 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:59:10 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:59:10 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:59:10 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:59:11 pc-mtodorov kernel: unregister_netdevice: waiting for tap0 to become free. Usage count = 3
> Mar 14 20:59:11 pc-mtodorov kernel: leaked reference.
> Mar 14 20:59:11 pc-mtodorov kernel: net_rx_queue_update_kobjects+0x75/0x1d0
> Mar 14 20:59:11 pc-mtodorov kernel: netif_set_real_num_rx_queues+0x5b/0xb0
> Mar 14 20:59:11 pc-mtodorov kernel: tun_attach+0x1ec/0x5a0
> Mar 14 20:59:11 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:59:11 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:59:11 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:59:11 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:59:11 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> Mar 14 20:59:11 pc-mtodorov kernel: leaked reference.
> Mar 14 20:59:11 pc-mtodorov kernel: netdev_queue_update_kobjects+0x86/0x190
> Mar 14 20:59:11 pc-mtodorov kernel: netif_set_real_num_tx_queues+0x86/0x250
> Mar 14 20:59:11 pc-mtodorov kernel: tun_attach+0x1d7/0x5a0
> Mar 14 20:59:11 pc-mtodorov kernel: __tun_chr_ioctl+0xa58/0x17d0
> Mar 14 20:59:11 pc-mtodorov kernel: tun_chr_ioctl+0x17/0x20
> Mar 14 20:59:11 pc-mtodorov kernel: __x64_sys_ioctl+0x97/0xd0
> Mar 14 20:59:11 pc-mtodorov kernel: do_syscall_64+0x5c/0x90
> Mar 14 20:59:11 pc-mtodorov kernel: entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [root@pc-mtodorov marvin]# 
> 
> I see those "leaked reference" lines are being printed here:
> https://elixir.bootlin.com/linux/v6.3-rc2/source/lib/ref_tracker.c#L55
> 
> However, it is beyond the scope of my knowledge to track the actual leak.
> 
> Hope this helps.
> 
> Best regards,
> Mirsad
> 
> -- 
> Mirsad Goran Todorovac
> Sistem inženjer
> Grafički fakultet | Akademija likovnih umjetnosti
> Sveučilište u Zagrebu
>  
> System engineer
> Faculty of Graphic Arts | Academy of Fine Arts
> University of Zagreb, Republic of Croatia
> The European Union
