Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16301D94E0
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgESLFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgESLFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 07:05:01 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68724C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 04:05:01 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id d21so13220417ljg.9
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 04:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B2OBklmuWSQBkUvmSFrcD+kUaBAH1tIVLaIDRE6iNOU=;
        b=NxxVRN21PerMhxUNfnyJTRJmatKVmpSZ1g99fCJjMeNP7S3WHoS7XDZdNNThpfiKKJ
         +GL2O6bk/Qh2FcZBCBet9hMqcWgyjcvBrBVHW6FOkyvkAFakltyQU+sjzssmUOt7Hr1i
         Q8YdQq/Radv4jpbwDhbd24n+dGUBE9mlQCXS0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B2OBklmuWSQBkUvmSFrcD+kUaBAH1tIVLaIDRE6iNOU=;
        b=Rq41owKY15dMZHcMrCYqWMEMvw+sY3MCxtMU9dhv0QCeif6cW3c2moTc1NouMdfWhB
         +bpA9SnmnCEB0ikUVuJWR1Fy+4ZmY5OviOANISAfbbCQWOiOMG4W7ZCZo9oenWrUDslL
         MsljnE7Ypo8gsP/uN1XsSOQbAINPZSCmaWd4dFHZGPMSz63Uk6Af65V5jClswl1sG8tX
         S/gwqgZ7r5fdcuV94jBVQKL4sUD51JC4SNVtGZRwRmhUxCXpgwP10eqyBtWPHnlzhpav
         lVKemUbSvfwHnYBWWjvcNcuqgVy2xjHwOrK+h2aSY/v868ogH6IwWJ1vcX4cvMe9gSu3
         EmRg==
X-Gm-Message-State: AOAM531InpTTJE4vvkM3wiKOb0xcdcuITIKU3QygD/GJRmVAQM0bkCrJ
        QqPEcf0KDKgBC1kdLkvcwCiR7s8NwLHEeA==
X-Google-Smtp-Source: ABdhPJyViA5HvjviTa7i19KUFYtOnoXVxv8ET/N1kyHyByd0h8XPK8Qspxza0g/gM2nF6QscBbNWLQ==
X-Received: by 2002:a2e:81c7:: with SMTP id s7mr13350238ljg.203.1589886299424;
        Tue, 19 May 2020 04:04:59 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t30sm7959443lfd.29.2020.05.19.04.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 04:04:58 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net 0/2] net: nexthop: multipath null ptr deref fixes
Date:   Tue, 19 May 2020 14:04:22 +0300
Message-Id: <20200519110424.2397623-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Recently I found that we can cause a null ptr dereference when using
nexthop groups due to .nh getting set to null or due to num_nh going to
0 while we're selecting a path and the nexthop multipath group is being
modified. The reason is that the .nh ptr is set and read without any sync
primitives so in theory it can become null at any point (being cleared on
nh group removal), and also the nh count in a group (num_nh), when it
becomes == 0 while destroying a nh group and we hit it then in
nexthop_select_path() rc would remain == NULL and we'll deref a null ptr.
So there are 2 separate issues, first is nexthop_select_path
dereferencing .nh without any checks and the second is nexthop_select_path
users dereferencing its return value without checking it first. This set
fixes both issues as they are closely related and caused by the same
actions: nexthop delete or replace.

The null ptr deref can be caused by running traffic to a route using a
multipath nexthop and in parallel doing replaces of one of the nexthop
members or while deleting the nexthop group (again in parallel).
I've run the above test for a few hours with these fixes in place.

Here's one such trace:
	[  322.517290] BUG: kernel NULL pointer dereference, address: 0000000000000070
	[  322.517670] #PF: supervisor read access in kernel mode
	[  322.517935] #PF: error_code(0x0000) - not-present page
	[  322.518213] PGD 0 P4D 0 
	[  322.518388] Oops: 0000 [#1] SMP PTI
	[  322.518601] CPU: 1 PID: 58185 Comm: ping Not tainted 5.7.0-rc5+ #190
	[  322.518911] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
	[  322.519490] RIP: 0010:fib_select_multipath+0x5a/0x2ac
	[  322.519776] Code: 85 db 48 89 44 24 08 40 0f 95 c6 31 c9 31 d2 e8 29 13 93 ff 48 85 db 74 58 48 8b 45 18 8b 74 24 04 48 8b 78 68 e8 81 b7 00 00 <48> 8b 58 70 e8 6c 04 8b ff 85 c0 74 31 80 3d cd 89 d4 00 00 75 28
	[  322.520536] RSP: 0018:ffff888228f6bac0 EFLAGS: 00010286
	[  322.520813] RAX: 0000000000000000 RBX: ffff888228cc3c00 RCX: 0000000000000000
	[  322.521152] RDX: ffff888222215080 RSI: ffff888222215930 RDI: ffff888222215080
	[  322.521478] RBP: ffff888228f6bbd8 R08: ffff888222215930 R09: 0000000000020377
	[  322.521815] R10: 0000000000000000 R11: 784deca9f66dea1e R12: 0000000000000000
	[  322.522143] R13: ffff88822a099000 R14: ffff888228f6bbd8 R15: ffffffff8258cc80
	[  322.522491] FS:  00007fc5ee6a8000(0000) GS:ffff88822bc80000(0000) knlGS:0000000000000000
	[  322.522862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[  322.523236] CR2: 0000000000000070 CR3: 0000000222954001 CR4: 0000000000360ee0
	[  322.523657] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	[  322.524060] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
	[  322.524461] Call Trace:
	[  322.524707]  fib_select_path+0x5a/0x2c8
	[  322.524998]  ip_route_output_key_hash_rcu+0x2d6/0x636
	[  322.525372]  ip_route_output_key_hash+0x9f/0xb6
	[  322.525697]  ip_route_output_flow+0x1c/0x58
	[  322.525990]  raw_sendmsg+0x5e9/0xca4
	[  322.526261]  ? mark_lock+0x68/0x24d
	[  322.526536]  ? lock_acquire+0x233/0x24f
	[  322.526823]  ? raw_abort+0x3f/0x3f
	[  322.527086]  ? inet_send_prepare+0x3b/0x3b
	[  322.527418]  ? sock_sendmsg_nosec+0x4f/0x9b
	[  322.527721]  ? raw_abort+0x3f/0x3f
	[  322.527984]  sock_sendmsg_nosec+0x4f/0x9b
	[  322.528274]  __sys_sendto+0xdd/0x100
	[  322.528551]  ? sockfd_lookup_light+0x72/0x96
	[  322.528851]  ? trace_hardirqs_on_thunk+0x1a/0x1c
	[  322.529159]  __x64_sys_sendto+0x25/0x28
	[  322.529442]  do_syscall_64+0xd1/0xe1
	[  322.529719]  entry_SYSCALL_64_after_hwframe+0x49/0xb3

Thanks,
 Nik

Nikolay Aleksandrov (2):
  net: nexthop: dereference nh only once in nexthop_select_path
  net: nexthop: check for null return by nexthop_select_path()

 include/net/nexthop.h |  5 ++++-
 net/ipv4/nexthop.c    | 13 +++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

-- 
2.25.2

