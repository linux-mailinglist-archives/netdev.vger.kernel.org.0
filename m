Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A3125E41A
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgIDXUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbgIDXUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 19:20:32 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E14C061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 16:20:31 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w8so7767918ilj.8
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 16:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bl3aVr6HGhRIN3C5gb4uogUVxZLl2xWVt6GT5QoggC0=;
        b=Qkos48OS/gPbebpaoxO5Zom/kEWK8e+uMlRcAXXvsAdggy1StnW0HDxW5uIHF+19YA
         L54NVeHRT0CAiZIh+myqExfte69Hqmap8QOQiba1EGIJGZoGnhbvK+j5zMYTvRU3Mq/r
         qv07+ZztP4jVv70wl74wbQ/cKyOTdfGsychnfPXZ9nNIgWssyWz05S2B85eDAyJodvo8
         oNII//LVsB330HGrRUlABm4Hja7yv9SRVB+woQB6yMSq07xea9deZCfGazadNb5jQnRV
         XPzsYu1UgH4cCSmf8Ew6FREN01ySuHk5H6nZQ10YVdudra+hLZ5JsT2Bui9dMJYt6rYV
         hUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bl3aVr6HGhRIN3C5gb4uogUVxZLl2xWVt6GT5QoggC0=;
        b=l5YdVwYbSu0DMwiUg1F3H76+mBx6POvGpPzH13BdzjoL1dVd0Hanng2Z1Ij2XINtR1
         QD7Z/ymc6WcVcnZQDmwktKqwJzn6Cl4ELbYx0QMoNcXhqPWs9BseL9XfzLzh3+jW8oKp
         nYGWmgUsF4DrGLClglt9HRoUmrnWt7XfSkcBHL/DPJEX0pygQ2f9TG3SYc4caSb4YGzJ
         MvbZHxq4hzcfFHSilWZV/BXCN2XSzFZ1/8cpkpmj0wplxaHTOZWP1GeqDOq6v7h9nwf3
         2cuV3ue3XM1dUNY6bNLIbMKIjxlMifhRQMbg1Y2uh2xx132Nou2KTbIv4LEabwIsb/1V
         JBGA==
X-Gm-Message-State: AOAM530Bn+MVmxaRc1NC8wgpa2pRtsRpF03zcfbwSvNZ30QRuFOZDiSK
        mmXdOKe5DWJMN7ZrCezmKznbPA8GFdG+3AOyeV+6il1sPKGBeQ==
X-Google-Smtp-Source: ABdhPJwArPL31Rh5UYgt4lQrc//FJsJYNHT7d1PHvInbw0f04tEskzRxlXopJHc61xEMBK3+8Fwi7hRNFZtrl1TzPlk=
X-Received: by 2002:a92:8b52:: with SMTP id i79mr10473354ild.177.1599261630969;
 Fri, 04 Sep 2020 16:20:30 -0700 (PDT)
MIME-Version: 1.0
References: <1599157734-16354-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1599157734-16354-1-git-send-email-michael.chan@broadcom.com>
From:   Baptiste Covolato <baptiste@arista.com>
Date:   Fri, 4 Sep 2020 16:20:20 -0700
Message-ID: <CABb8VeHA8yEmi-iDs3O-eRfOucWqGM+9p6gj87NLdjeQHfJROA@mail.gmail.com>
Subject: Re: [PATCH net] tg3: Fix soft lockup when tg3_reset_task() fails.
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, Netdev <netdev@vger.kernel.org>,
        kuba@kernel.org, David Christensen <drc@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Thu, Sep 3, 2020 at 11:29 AM Michael Chan <michael.chan@broadcom.com> wrote:
> If tg3_reset_task() fails, the device state is left in an inconsistent
> state with IFF_RUNNING still set but NAPI state not enabled.  A
> subsequent operation, such as ifdown or AER error can cause it to
> soft lock up when it tries to disable NAPI state.
>
> Fix it by bringing down the device to !IFF_RUNNING state when
> tg3_reset_task() fails.  tg3_reset_task() running from workqueue
> will now call tg3_close() when the reset fails.  We need to
> modify tg3_reset_task_cancel() slightly to avoid tg3_close()
> calling cancel_work_sync() to cancel tg3_reset_task().  Otherwise
> cancel_work_sync() will wait forever for tg3_reset_task() to
> finish.

Thank you for proposing this patch. Unfortunately, it appears to make
things worse on my test setup. The problem is a lot easier to
reproduce, and not related to transmit timeout anymore.

The manifestation of the problem with the new patch starts with a
CmpltTO error on the PCI root port of the CPU:
[11288.471126] tg3 0000:56:00.0: tg3_abort_hw timed out,
TX_MODE_ENABLE will not clear MAC_TX_MODE=ffffffff
[11290.258733] tg3 0000:56:00.0 lc4: No firmware running
[11302.336601] tg3 0000:56:00.0 lc4: Link is down
[11302.336616] pcieport 0000:00:03.0: AER: Uncorrected (Non-Fatal)
error received: 0000:00:03.0
[11302.336621] pcieport 0000:00:03.0: PCIe Bus Error:
severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester
ID)
[11302.470089] pcieport 0000:00:03.0:   device [8086:6f08] error
status/mask=00004000/00000000
[11302.570218] pcieport 0000:00:03.0:    [14] CmpltTO                (First)
[11302.651611] pcieport 0000:00:03.0: broadcast error_detected message
[11305.119349] br1: port 4(lc4) entered disabled state
[11305.119443] br1: port 1(lc4.42) entered disabled state
[11305.119696] device lc4 left promiscuous mode
[11305.119697] br1: port 4(lc4) entered disabled state
[11305.143622] device lc4.42 left promiscuous mode
[11305.143626] br1: port 1(lc4.42) entered disabled state
[11305.219623] iommu: Removing device 0000:56:00.0 from group 52
[11305.219672] tg3 0000:61:00.0 lc5: PCI I/O error detected
[11305.345904] tg3 0000:6c:00.0 lc6: PCI I/O error detected
[11305.472089] pcieport 0000:00:03.0: AER: Device recovery failed
[11305.472092] pcieport 0000:00:03.0: AER: Uncorrected (Non-Fatal)
error received: 0000:00:03.0
[11305.472096] pcieport 0000:00:03.0: PCIe Bus Error:
severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester
ID)
[11305.472142] pcielw 0000:52:0d.0:pcie204: link down processing complete
[11305.605566] pcieport 0000:00:03.0:   device [8086:6f08] error
status/mask=00004000/00000000
[11305.605568] pcieport 0000:00:03.0:    [14] CmpltTO                (First)
[11305.605578] pcieport 0000:00:03.0: broadcast error_detected message
[11305.787386] tg3 0000:61:00.0 lc5: PCI I/O error detected

Once these PCI errors happen, the kernel is dead locked for any
network operations. We shortly see stack traces of task blocked
doing network configuration operations after that:
[11481.166888] INFO: task ntpd:6107 blocked for more than 120 seconds.
[11481.242021]       Tainted: G           OE     4.19.0-9-2-amd64 #1
Debian 4.19.118-2+deb10u1
[11481.342126] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[11481.436018] ntpd            D    0  6107      1 0x00000004
[11481.436020] Call Trace:
[11481.436023]  ? __schedule+0x2a2/0x870
[11481.436025]  schedule+0x28/0x80
[11481.436043]  schedule_preempt_disabled+0xa/0x10
[11481.436045]  __mutex_lock.isra.8+0x2b5/0x4a0
[11481.436048]  ? __netlink_lookup+0xcd/0x130
[11481.436049]  __netlink_dump_start+0x56/0x1e0
[11481.436053]  ? rtnl_fill_ifinfo+0xe90/0xe90
[11481.436059]  rtnetlink_rcv_msg+0x22c/0x360
[11481.436065]  ? rtnl_fill_ifinfo+0xe90/0xe90
[11481.436071]  ? rtnl_calcit.isra.33+0x100/0x100
[11481.436076]  netlink_rcv_skb+0x4c/0x120
[11481.436083]  netlink_unicast+0x181/0x210
[11481.436089]  netlink_sendmsg+0x204/0x3d0
[11481.436095]  sock_sendmsg+0x36/0x40
[11481.436097]  __sys_sendto+0xee/0x160
[11481.436100]  ? __sys_socket+0x93/0xe0
[11481.436102]  __x64_sys_sendto+0x24/0x30
[11481.436105]  do_syscall_64+0x53/0x110
[11481.436107]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[11481.436109] RIP: 0033:0x7fe88125aa02
[11481.436113] Code: Bad RIP value.
[11481.436113] RSP: 002b:00007ffdbdcd8950 EFLAGS: 00000293 ORIG_RAX:
000000000000002c
[11481.436115] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fe88125aa02
[11481.436116] RDX: 0000000000000014 RSI: 00007ffdbdcd9a30 RDI: 0000000000000004
[11481.436116] RBP: 0000000000000000 R08: 00007ffdbdcd99f0 R09: 000000000000000c
[11481.436117] R10: 0000000000000000 R11: 0000000000000293 R12: 00007ffdbdcd9a30
[11481.436118] R13: 0000000000000014 R14: 0000000000000000 R15: 00007ffdbdcd99f0

Do you have any idea of where this could be coming from? Is it
possible that this patch introduced a new window where the deadlock
can happen?

Thanks,

--
Baptiste Covolato
