Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B1840BD98
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbhIOCSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbhIOCSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802F2C061574;
        Tue, 14 Sep 2021 19:16:43 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so3230277pjb.1;
        Tue, 14 Sep 2021 19:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+D5A14G2hXb76oWqzjkLZYFPjmPBH8kjDmRtrAsB1DE=;
        b=DmYGfEbCDoyZqqq0wNDta8dDG7Tq+ObFdfzDwih20rDzPF0g3w61ns1wrTGJoOOAbk
         GngPqnmGHZZoCS+CTcnxz5Uh6hl4CcVb9U9SnfrXFS/stUxRBKbZlhn+ragKdCz7Ysvn
         28Eq/FeBW1yh1uUxVQ0MWtWwAJH0LZbpaeJTMKT7iojpZiBMzKqq3Utl62wm/7nnwUKF
         Rh5wia60/9reVYyIzMdGQZURkXTV24s2Z7TmtmJuWEJEqk8sAuYd8GBx0Mcem74PZonU
         w1/z6xVxSS8zNmSjxU+fVv4q/qG8mfRBhe8AekC13SGQqTa5ldhEuSsN3T5r2MZ9azBQ
         q3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+D5A14G2hXb76oWqzjkLZYFPjmPBH8kjDmRtrAsB1DE=;
        b=NgC0vpjAnmwvYyXWbJie1QZN2RJQ8cJvGEDsOGYNmv5yiBAmfPlCqEMjWWuw6lnviD
         r0uMSY2ve5OZPGoXTAeyQkQcm3FOqDxDH97t0YWAwAnGkI7Ez5dlkagaCiJ2uQZscIxQ
         kiFcUnaWNO7pG9HRt2L7D1yN16POoLMxpOsifppXuuaGTq8eyD+A+U6sl0kiOYIqso6a
         +zd0fvY0cX+mUARTuJdSKCvP1LNDPsI+ON9IUwmI8GMZd/Ph3ScJmGNlqqY3UFhSMFg8
         cSD5c9txRKayr5MC63/sfEQdPiBU1J9jnWywM0QexSfqSK6jqZQ4Ys5FFq7+L+onj/6j
         qQTQ==
X-Gm-Message-State: AOAM5336rxwegSeH37d2W/w/ghBXD5dJcMcdUBMPExsiv9Pw2IOQtTzE
        GVgS7kNXlm4gSbUK1NkxiBn70j3kYEZFhUFbNA==
X-Google-Smtp-Source: ABdhPJx6iyPm7BgmjJuDklZ4hv6kH+sgS2bDlBpm/23orZxhMulxhdui1vSNCwTfAFAwB8L77uuwnmhPNymI7uwRWnI=
X-Received: by 2002:a17:902:7b84:b0:13b:90a7:e270 with SMTP id
 w4-20020a1709027b8400b0013b90a7e270mr13016935pll.21.1631672202995; Tue, 14
 Sep 2021 19:16:42 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 15 Sep 2021 10:16:32 +0800
Message-ID: <CACkBjsbqK6wuYH66izxaZj=Knzzn8eKeX4CzeCxQB2DsEufT0g@mail.gmail.com>
Subject: WARNING in sta_info_insert_rcu
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 6880fa6c5660 Linux 5.15-rc1
git tree: upstream
console output:
https://drive.google.com/file/d/1JAoHNesGqAqeOvuCFuKXI-F9pBTcwDNo/view?usp=sharing
kernel config: https://drive.google.com/file/d/1rUzyMbe5vcs6khA3tL9EHTLJvsUdWcgB/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

------------[ cut here ]------------
WARNING: CPU: 3 PID: 7312 at net/mac80211/sta_info.c:546
sta_info_insert_check net/mac80211/sta_info.c:545 [inline]
WARNING: CPU: 3 PID: 7312 at net/mac80211/sta_info.c:546
sta_info_insert_rcu+0xa3/0x1130 net/mac80211/sta_info.c:723
Modules linked in:
CPU: 3 PID: 7312 Comm: kworker/u8:4 Not tainted 5.15.0-rc1 #16
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: phy4 ieee80211_iface_work
RIP: 0010:sta_info_insert_check net/mac80211/sta_info.c:545 [inline]
RIP: 0010:sta_info_insert_rcu+0xa3/0x1130 net/mac80211/sta_info.c:723
Code: 16 00 00 8b 90 a8 16 00 00 44 31 f9 44 31 e2 0f b7 c1 09 c2 74
0f e8 dc c0 43 fd 41 f6 c4 01 0f 84 b2 00 00 00 e8 cd c0 43 fd <0f> 0b
41 bc ea ff ff ff e8 c0 c0 43 fd 48 89 de 4c 89 f7 e8 35 fe
RSP: 0018:ffffc90005b8bc98 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88810ce08000 RCX: 0000000000000000
RDX: ffff88810cdda240 RSI: ffffffff83f3d133 RDI: 0000000000000000
RBP: ffffc90005b8bd18 R08: ffffffff83f3d0d6 R09: 0000000000000000
R10: ffffc90005b8bc98 R11: 0000000000000003 R12: 00000000000ecf85
R13: ffff88810ce49708 R14: ffff88810ce48d60 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88813dd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001b52c48 CR3: 000000010c909000 CR4: 0000000000750ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 ieee80211_ibss_finish_sta+0xbc/0x170 net/mac80211/ibss.c:585
 ieee80211_ibss_work+0x13f/0x7d0 net/mac80211/ibss.c:1693
 ieee80211_iface_work+0x43a/0x5f0 net/mac80211/iface.c:1515
 process_one_work+0x359/0x850 kernel/workqueue.c:2297
 worker_thread+0x41/0x4d0 kernel/workqueue.c:2444
 kthread+0x178/0x1b0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
