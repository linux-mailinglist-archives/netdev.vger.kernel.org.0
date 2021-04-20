Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09CD365AA6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhDTOA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhDTOAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 10:00:52 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A712BC06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 07:00:19 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id o10so43074298ybb.10
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 07:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CSzfteh2sFoBf+bSCj0LWyr7f8ZdKMJYmlWhAs3OR9o=;
        b=qJt7ym1D1UWdc2HjncPaIRm04+GbyyoTnzjhmJzHF+eV8585J7Av+1o9zvgXnNIcAp
         Lt2vkq1SYGDztBwQNXAxZLyYgcsZq/n33bLmunsqLoOBjJuvQ8/UBfNsjAf/PVDpUpyJ
         VUznTrAA3V0k61zKDmMtXLPfwvQg8RWpjmzGTFtWzG8k90pI/g0NCuVQajncWnhh5Hl/
         qYxbOwVF2U3CdE+pyqV42LZSLMsJ2w3P68/l2z8MHYz+bOy5WyHdT7XloHAAiXm3AHHV
         zUay5mQFXbd9Mwjv1+TiLjDtt+Myr1+/9WjuCbH9tKQHrIMUKfCCR2C/TUoplVKOhZrC
         KECQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CSzfteh2sFoBf+bSCj0LWyr7f8ZdKMJYmlWhAs3OR9o=;
        b=oBPfjj6xsoqo9DMTISdvHkHi8PbN3BhBbe2TsT+TOYMqniK7GGW+XFPMQ68ZppCadJ
         qDISpVB73dKuV+d2JSNJFX/yQRoxuN5rPvKCF/ZY1U64lWei2M9+lCdK2lgoIJRi6DNF
         5JfmyDM74lM71hYKzislIa1FUqOqdYRVJkiiFhPZFl4siVaFGkz6V835fy3pg2yD+n6M
         lvkAmqcT+N+I+RPHYN09zCNyO1yMEd3DR7srb39yPC+5XcIpFQBmbDIWWlByoGQGvf4G
         z15QfhMEABRo0AoiyJQYrHa9uXE/BuH5djB79qVBFrv2s7dBuZHqyY5wc41VdOMyRk/u
         whmA==
X-Gm-Message-State: AOAM530dMWOzObZIk3bztcwhjZdRAY3JOfGIu/+NsmfyTTwgIfhoKf36
        4owbBbKkpcZcWaWe+7EC8wIwKUhWT3m1anghsbQOIA==
X-Google-Smtp-Source: ABdhPJx3GOFLmmAuaLTJsFDWsT9R93JjbXIV4DppE/PBR5N34/rqXI40elc6SxbgHx+HWXt18K+D0PYgZqAOG5UqRV4=
X-Received: by 2002:a25:4244:: with SMTP id p65mr24770854yba.452.1618927218716;
 Tue, 20 Apr 2021 07:00:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210420094341.3259328-1-eric.dumazet@gmail.com> <c5a8aeaf-0f41-9274-b9c5-ec385b34180a@roeck-us.net>
In-Reply-To: <c5a8aeaf-0f41-9274-b9c5-ec385b34180a@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 20 Apr 2021 16:00:07 +0200
Message-ID: <CANn89iKMbUtDhU+B5dFJDABUSJJ3rnN0PWO0TDY=mRYEbNpHZw@mail.gmail.com>
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in page_to_skb()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 3:48 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 4/20/21 2:43 AM, Eric Dumazet wrote:

> >
>
> Unfortunately that doesn't fix the problem for me. With this patch applied
> on top of next-20210419, I still get the same crash as before:
>
> udhcpc: sending discover^M
> Unable to handle kernel paging request at virtual address 0000000000000004^M
> udhcpc(169): Oops -1^M
> pc = [<0000000000000004>]  ra = [<fffffc0000b8c5b8>]  ps = 0000    Not tainted^M
> pc is at 0x4^M
> ra is at napi_gro_receive+0x68/0x150^M
> v0 = 0000000000000000  t0 = 0000000000000008  t1 = 0000000000000000^M
> t2 = 0000000000000000  t3 = 000000000000000e  t4 = 0000000000000038^M
> t5 = 000000000000ffff  t6 = fffffc00002f298a  t7 = fffffc0002c78000^M
> s0 = fffffc00010b3ca0  s1 = 0000000000000000  s2 = fffffc00011267e0^M
> s3 = 0000000000000000  s4 = fffffc00025f2008  s5 = fffffc00002f2940^M
> s6 = fffffc00025f2040^M
> a0 = fffffc00025f2008  a1 = fffffc00002f2940  a2 = fffffc0002ca000c^M
> a3 = fffffc00000250d0  a4 = 0000000effff0008  a5 = 0000000000000000^M
> t8 = fffffc00010b3c80  t9 = fffffc0002ca04cc  t10= 0000000000000000^M
> t11= 00000000000004c0  pv = fffffc0000b8bc40  at = 0000000000000000^M
> gp = fffffc00010f9fb8  sp = 00000000df74db09^M
> Disabling lock debugging due to kernel taint^M
> Trace:^M
> [<fffffc0000b8c5b8>] napi_gro_receive+0x68/0x150^M
> [<fffffc00009b409c>] receive_buf+0x50c/0x1b80^M
> [<fffffc00009b58b8>] virtnet_poll+0x1a8/0x5b0^M
> [<fffffc00009b58ec>] virtnet_poll+0x1dc/0x5b0^M
> [<fffffc0000b8d17c>] __napi_poll+0x4c/0x270^M
> [<fffffc0000b8d670>] net_rx_action+0x130/0x2c0^M
> [<fffffc0000bd6cb0>] sch_direct_xmit+0x170/0x360^M
> [<fffffc0000bd7000>] __qdisc_run+0x160/0x6c0^M
> [<fffffc0000337b64>] do_softirq+0xa4/0xd0^M
> [<fffffc0000337ca4>] __local_bh_enable_ip+0x114/0x120^M
> [<fffffc0000b89554>] __dev_queue_xmit+0x484/0xa60^M
> [<fffffc0000cd072c>] packet_sendmsg+0xe7c/0x1ba0^M
> [<fffffc0000b53338>] __sys_sendto+0xf8/0x170^M
> [<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
> [<fffffc0000a9bf7c>] ehci_irq+0x2cc/0x5c0^M
> [<fffffc0000a71334>] usb_hcd_irq+0x34/0x50^M
> [<fffffc0000b521bc>] move_addr_to_kernel+0x3c/0x60^M
> [<fffffc0000b532e4>] __sys_sendto+0xa4/0x170^M
> [<fffffc0000b533d4>] sys_sendto+0x24/0x40^M
> [<fffffc0000cfea38>] _raw_spin_lock+0x18/0x30^M
> [<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
> [<fffffc0000325298>] clipper_enable_irq+0x98/0x100^M
> [<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
> [<fffffc0000311514>] entSys+0xa4/0xc0^M

OK, it would be nice if you could get line number from this stack trace.

(scripts/decode_stacktrace.sh is your friend)
