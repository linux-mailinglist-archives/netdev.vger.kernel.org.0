Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678D2262952
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 09:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgIIHyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 03:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgIIHyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 03:54:00 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3DBC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 00:54:00 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id n2so1505243oij.1
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 00:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=xmZb/sO1QZJFs4zQfZ8fQTKx2mWVcCOjsRMkmxe6t/U=;
        b=RNzkf2hKiF9y4jWU5wHY6fRvaC+n9bqX+FS/ZTMUcArEKgryQuGPFlcd+dVEgfZsgu
         vMdw350fL2aL9K/OlQ1TLIdWJ5BDGMhIuH+E3v2Pz3lWkOnbetiEtcFb3Lzy1jpfwepP
         JxEdeu1YleGC06ZzoLqX5kB733V6321yI9iDOc8OCt1qZXzD9NPwE40d5+1+kJmsG6RK
         g6y0NThVP+AM8w5cyCWZUgqliZ/8aplQmYyE2VCie207TCE27VCcybKF7XBDgBVK9i33
         WQodbN434yPmAyxWiR1QXtXL4/KWHKCbu12ypbA9Ok9p2uNVnlZJtErzL8bdbAONA0zp
         08fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xmZb/sO1QZJFs4zQfZ8fQTKx2mWVcCOjsRMkmxe6t/U=;
        b=ss5sjuaLfS3OuzQtA9nLGvNSbNU7LMhZlQwQh0VE32yg28Ld7i667GJFWTjqn7dZJ6
         IWY2DgrVTd2c/y9TGN1/1MYWacwzskxt9NifZDIc3BjfUkFOU3MTslIo4y5lCrYborku
         6rUM8LX5QULTzxut98BfwVUm4EG5FwYhh8NGVsOQgXubbDQ5xxg/FLVy+9QzG/1MXsZq
         W3Ga4JwhLDdmjX+ycirU8IR8oaCA1FNqP8WMqKZVJIKfmPa9rtp6LeE9dXnge72fM2qu
         zUQMEwoaFbIiz1NX1xUHZVvJqmDGt/42dx+ayr/OvevaczNsmx8TVpwEZIvquDQBLzQW
         CtZA==
X-Gm-Message-State: AOAM531UfD+PI+9U1VW+WfO683hHnJYUO5nDe+gKvSst81gVFnGPtfYC
        x3pIDpk3pFaBXZE90OaLHzQ42XJ5WWuIfEKy/aSj5CYTtEGm9w==
X-Google-Smtp-Source: ABdhPJziiEr1JIodezrUz0hLciSt1ja+9/eO3GAJo5RwLu8U3BrwQX1wrTv7rs3hhSP83bFTrpL0jcamzOlPdczwsSM=
X-Received: by 2002:aca:e045:: with SMTP id x66mr1891225oig.19.1599638039126;
 Wed, 09 Sep 2020 00:53:59 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Leeman <marc.leeman@gmail.com>
Date:   Wed, 9 Sep 2020 09:53:55 +0200
Message-ID: <CAH+fs=8Fq5_E4aooa+bJoWCgQn1-7g9Y9rpBdGAH7ssGMkZUnA@mail.gmail.com>
Subject: (pch_gbe): transmit queue 0 timed out
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi
I'd like to get some feedback on an issue that has popped up on newer
systems (with increased load).

The system uses an older CPU (Atom) that uses an integrated MAC. When
flooding the NIC with multicast traffic (and multiple listeners), we
get the following:

-----

Aug 16 01:21:55 dss kernel: [ 1357.210634] NETDEV WATCHDOG: eth0
(pch_gbe): transmit queue 0 timed out
Aug 16 01:21:55 dss kernel: [ 1357.210680] WARNING: CPU: 1 PID: 1187
at net/sched/sch_generic.c:466 dev_watchdog+0x1b6/0x1c0
Aug 16 01:21:55 dss kernel: [ 1357.210683] Modules linked in: 8021q
garp stp mrp llc rfkill nft_chain_nat_ipv4 nf_nat_ipv4 xt_REDIRECT
nf_nat nf_log_ipv4 nf_log_common nft_counter xt_LOG i2c_dev ie6xx_wdt
lpc_sch xt_multiport i2c_i801 xt_pkttype xt_recent xt_state
xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c
xt_tcpudp nft_compat nf_tables nfnetlink coretemp kvm irqbypass
serio_raw pcspkr gma500_gfx pch_can can_dev drm_kms_helper drm
pch_uart sg pch_dma pch_udc i2c_algo_bit udc_core fb_sys_fops
syscopyarea pch_phub sysfillrect evdev sysimgblt video pcc_cpufreq
button acpi_cpufreq ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2
crc32c_generic fscrypto ecb crypto_simd cryptd aes_i586 aufs(OE)
sd_mod i2c_isch psmouse mfd_core e1000e spi_topcliff_pch ahci ohci_pci
libahci ohci_hcd ehci_pci libata ehci_hcd sdhci_pci
Aug 16 01:21:55 dss kernel: [ 1357.210802]  usbcore cqhci pch_gbe
sdhci scsi_mod ptp_pch mmc_core mii ptp pps_core gpio_pch usb_common
[last unloaded: lpc_sch]
Aug 16 01:21:55 dss kernel: [ 1357.210831] CPU: 1 PID: 1187 Comm:
mysqld Tainted: G           OE     4.19.0-9-686 #1 Debian
4.19.118-2+deb10u1
Aug 16 01:21:55 dss kernel: [ 1357.210835] Hardware name: EKF
Elektronik GmbH PC2-LIMBO/PC2-LIMBO, BIOS 094 2017-02-01
Aug 16 01:21:55 dss kernel: [ 1357.210844] EIP: dev_watchdog+0x1b6/0x1c0
Aug 16 01:21:55 dss kernel: [ 1357.210853] Code: 8b 50 3c 89 f8 e8 ca
cd 10 00 8b 7e f0 eb a3 89 f8 c6 05 eb 4e 90 d7 01 e8 b7 dc fc ff 53
50 57 68 44 f7 82 d7 e8 4e ee ae ff <0f> 0b 83 c4 10 eb c9 8d 76 00 3e
8d 74 26 00 55 89 e5 57 56 89 d6
Aug 16 01:21:55 dss kernel: [ 1357.210859] EAX: 0000003b EBX: 00000000
ECX: f473ccac EDX: 00000007
Aug 16 01:21:55 dss kernel: [ 1357.210864] ESI: f41fc2e8 EDI: f41fc000
EBP: f417df68 ESP: f417df40
Aug 16 01:21:55 dss kernel: [ 1357.210871] DS: 007b ES: 007b FS: 00d8
GS: 00e0 SS: 0068 EFLAGS: 00010292
Aug 16 01:21:55 dss kernel: [ 1357.210876] CR0: 80050033 CR2: b78e1010
CR3: 1bbd7000 CR4: 000006d0
Aug 16 01:21:55 dss kernel: [ 1357.210880] Call Trace:
Aug 16 01:21:55 dss kernel: [ 1357.210887]  <SOFTIRQ>
Aug 16 01:21:55 dss kernel: [ 1357.210903]  ? pfifo_fast_enqueue+0xf0/0xf0
Aug 16 01:21:55 dss kernel: [ 1357.210913]  call_timer_fn+0x2f/0x130
Aug 16 01:21:55 dss kernel: [ 1357.210921]  ? pfifo_fast_enqueue+0xf0/0xf0
Aug 16 01:21:55 dss kernel: [ 1357.210930]  run_timer_softirq+0x1bd/0x3f0
Aug 16 01:21:55 dss kernel: [ 1357.210944]  __do_softirq+0xb2/0x275
Aug 16 01:21:55 dss kernel: [ 1357.210955]  ? __softirqentry_text_start+0x8/0x8
Aug 16 01:21:55 dss kernel: [ 1357.210964]  call_on_stack+0x12/0x50
Aug 16 01:21:55 dss kernel: [ 1357.210969]  </SOFTIRQ>
Aug 16 01:21:55 dss kernel: [ 1357.210977]  ? irq_exit+0xc5/0xd0
Aug 16 01:21:55 dss kernel: [ 1357.210986]  ?
smp_apic_timer_interrupt+0x6c/0x130
Aug 16 01:21:55 dss kernel: [ 1357.210996]  ? apic_timer_interrupt+0xd5/0xdc
Aug 16 01:21:55 dss kernel: [ 1357.211007]  ? nmi+0x8b/0x198
----

It looks eerily similar to the issue reported on this mailinglist 8 years ago:
https://www.spinics.net/lists/netdev/msg198234.html

where locking was tweaked to compensate.

When I compare the different kernels (4.19.132, 5.8.7), the code base
has changed little in
the driver, the locking was changed a bit (wrt patch where it was
confirmed to be a fix):

1. netif_tx_lock is used instead of
spin_lock(&tx_ring->tx_lock);

2. locking has been removed in  pch_gbe_xmit_frame

Is this again an issue with missing locks?

Since it has been quite some time since I did some kernel work, I
thought it better to
check first.


-- 
g. Marc
