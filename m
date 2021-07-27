Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EC53D7A76
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhG0QFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhG0QFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:05:19 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57848C061757;
        Tue, 27 Jul 2021 09:05:18 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id 185so16538477iou.10;
        Tue, 27 Jul 2021 09:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vl+kvNKnVi/c+Ok9NrSB7OAur5tCesOOO+EVtWkoC3Y=;
        b=HWVYpxFs1JBl4MQFul5NW6Y0Qnp3PVz8r+mv5A7U4bbDalvOks92gxihrk8L2HoVm1
         FCKgINLP15QXOpayaVX8pPqf2hFyYmECq3Tv/Iig/cBXX0JwJRDPXQERWU8eo6guTbB8
         lfYbz5uTbLffbDlVnRpzfZKSRthOnBgUFMcjuzJTTunKb8m9vtawTjky8BPVjA4iq34+
         i4+7EXTP9ZY4ExC/uZe1IQA0scx0h/6n9HL4L2np8BPDk8/grLajUs7ChECHf4r1XXFm
         fNxnS3C1+sPq+w/HQpygNhxpnuxKnOxYzOaQ4z6VpoeacSjJw3Kr2K407M+tsWuLGXKy
         fVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vl+kvNKnVi/c+Ok9NrSB7OAur5tCesOOO+EVtWkoC3Y=;
        b=FVzIpn4XjKA1ojtFTBeiIW1bLsW9mP4NUL5mjLVZDn7AuaymyaHfbrQmAG7rmstOQh
         Dy5N/RhKyEoTze1rJSAEGRxQ+b9I+ndhskdpGlyH0YbMuBXZfPkZg09ggBirI8ddZoE9
         gGBriOrR87N9gCvF+Ckem2jKJy6oH1zXMpP3YIOQQ7n31DX/++a9t5HnxhW/RGwKEpOj
         aPsAmuB2XwshzTo1W0s/Nayk7yY+g6X+IYSofhR1zDqXgThWgCUKEVzsNgZvwmGndHoX
         hpXReM9esZdaqsdeckJt8VaSJacwGIlk1QLaKy1JmI++S2kAJvzSfxcjtlULchw4cvwb
         2mvw==
X-Gm-Message-State: AOAM533HhBBhWf3vAQOgKZOVux8NThreDT5j+np5llpXcivGprfdi16N
        SrRSzfkNZP0XR604OeQc39A=
X-Google-Smtp-Source: ABdhPJwjbGo0qaOzFcPxmX7fqsYXekOserDXvOscvrHUo+N6nl5A72Y5AWpReNtmosI+7cRdtHU/CA==
X-Received: by 2002:a6b:f416:: with SMTP id i22mr10790758iog.162.1627401917861;
        Tue, 27 Jul 2021 09:05:17 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id p9sm2028689ilj.65.2021.07.27.09.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:05:17 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net,
        xiyou.wangcong@gmail.com, kafai@fb.com,
        alexei.starovoitov@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf v3 0/3] sockmap fixes picked up by stress tests
Date:   Tue, 27 Jul 2021 09:04:57 -0700
Message-Id: <20210727160500.1713554-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running stress tests with recent patch to remove an extra lock in sockmap
resulted in a couple new issues popping up. It seems only one of them
is actually related to the patch:

799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")

The other two issues had existed long before, but I guess the timing
with the serialization we had before was too tight to get any of
our tests or deployments to hit it.

With attached series stress testing sockmap+TCP with workloads that
create lots of short-lived connections no more splats like below were
seen on upstream bpf branch.

[224913.935822] WARNING: CPU: 3 PID: 32100 at net/core/stream.c:208 sk_stream_kill_queues+0x212/0x220
[224913.935841] Modules linked in: fuse overlay bpf_preload x86_pkg_temp_thermal intel_uncore wmi_bmof squashfs sch_fq_codel efivarfs ip_tables x_tables uas xhci_pci ixgbe mdio xfrm_algo xhci_hcd wmi
[224913.935897] CPU: 3 PID: 32100 Comm: fgs-bench Tainted: G          I       5.14.0-rc1alu+ #181
[224913.935908] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
[224913.935914] RIP: 0010:sk_stream_kill_queues+0x212/0x220
[224913.935923] Code: 8b 83 20 02 00 00 85 c0 75 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 89 df e8 2b 11 fe ff eb c3 0f 0b e9 7c ff ff ff 0f 0b eb ce <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 90 0f 1f 44 00 00 41 57 41
[224913.935932] RSP: 0018:ffff88816271fd38 EFLAGS: 00010206
[224913.935941] RAX: 0000000000000ae8 RBX: ffff88815acd5240 RCX: dffffc0000000000
[224913.935948] RDX: 0000000000000003 RSI: 0000000000000ae8 RDI: ffff88815acd5460
[224913.935954] RBP: ffff88815acd5460 R08: ffffffff955c0ae8 R09: fffffbfff2e6f543
[224913.935961] R10: ffffffff9737aa17 R11: fffffbfff2e6f542 R12: ffff88815acd5390
[224913.935967] R13: ffff88815acd5480 R14: ffffffff98d0c080 R15: ffffffff96267500
[224913.935974] FS:  00007f86e6bd1700(0000) GS:ffff888451cc0000(0000) knlGS:0000000000000000
[224913.935981] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[224913.935988] CR2: 000000c0008eb000 CR3: 00000001020e0005 CR4: 00000000003706e0
[224913.935994] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[224913.936000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[224913.936007] Call Trace:
[224913.936016]  inet_csk_destroy_sock+0xba/0x1f0
[224913.936033]  __tcp_close+0x620/0x790
[224913.936047]  tcp_close+0x20/0x80
[224913.936056]  inet_release+0x8f/0xf0
[224913.936070]  __sock_release+0x72/0x120

v3: make sock_drop inline in skmsg.h
v2: init skb to null and fix a space/tab issue. Added Jakub's acks.

John Fastabend (3):
  bpf, sockmap: zap ingress queues after stopping strparser
  bpf, sockmap: on cleanup we additionally need to remove cached skb
  bpf, sockmap: fix memleak on ingress msg enqueue

 include/linux/skmsg.h | 54 ++++++++++++++++++++++++++++---------------
 net/core/skmsg.c      | 39 ++++++++++++++++++++++---------
 2 files changed, 63 insertions(+), 30 deletions(-)

-- 
2.25.1

