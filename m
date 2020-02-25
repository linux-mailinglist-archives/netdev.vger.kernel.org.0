Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE4716C347
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 15:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgBYOGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 09:06:41 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:31368 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYOGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 09:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1582639596;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=s100eV+VEIEN6ta0oy2r60GESsYdW7Z5SeipPHRt6YM=;
        b=Fz2xA3P8MmQlISD7Zb4hksHOpS7uKb+JjJ/me5+BEUORftdUSB6huTgxzKR4wWpsd6
        tvEEZmh4entjG7prVragkXQnRPlT0ydlhxZ1/1pCdkdWtVFlFlspuGQyfnMPyPq8j+d8
        6vY72o2Mj1nhH82KOQ5cQ7TY6tE9usQzjuFI4nX7dLU5jPwlhA8vErwUq7p7VYlkO/vq
        apDfrrU+35RnYIm+Qo9hTnwqYjmzgXdRUO5eZ+RCtSyfGXRXQEokSJgJPZG8c7ZvXVUQ
        +ukPO5ot/GYqn5Hh3bHnN8h2NCosXp+Srms0ywx/Rr46x6KwgpQbgtDOfg4yLbn9Lr0p
        IERQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVsh5lE2J"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id g084e8w1PE6QCWk
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 25 Feb 2020 15:06:26 +0100 (CET)
Subject: Re: [PATCH v2] can: af_can: can_rcv() canfd_rcv(): Fix access of
 uninitialized memory or out of bounds
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can @ vger . kernel . org" <linux-can@vger.kernel.org>
Cc:     kernel@pengutronix.de, glider@google.com, kuba@kernel.org,
        netdev@vger.kernel.org,
        syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
References: <20200225083950.2542543-1-mkl@pengutronix.de>
 <bde858ee-f4d8-4f3c-8b50-95f1a917c869@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <a77d525e-e174-e732-1f36-c4dace4fa532@hartkopp.net>
Date:   Tue, 25 Feb 2020 15:06:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <bde858ee-f4d8-4f3c-8b50-95f1a917c869@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/02/2020 09.40, Marc Kleine-Budde wrote:
> On 2/25/20 9:39 AM, Marc Kleine-Budde wrote:
>> Syzbot found the use of uninitialzied memory when injecting non conformant
>> CANFD frames via a tun device into the kernel:
>>
>> | BUG: KMSAN: uninit-value in number+0x9f8/0x2000 lib/vsprintf.c:459
>> | CPU: 1 PID: 11897 Comm: syz-executor136 Not tainted 5.6.0-rc2-syzkaller #0
>> | Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> | Call Trace:
>> |  __dump_stack lib/dump_stack.c:77 [inline]
>> |  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
>> |  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
>> |  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
>> |  number+0x9f8/0x2000 lib/vsprintf.c:459
>> |  vsnprintf+0x1d85/0x31b0 lib/vsprintf.c:2640
>> |  vscnprintf+0xc2/0x180 lib/vsprintf.c:2677
>> |  vprintk_store+0xef/0x11d0 kernel/printk/printk.c:1917
>> |  vprintk_emit+0x2c0/0x860 kernel/printk/printk.c:1984
>> |  vprintk_default+0x90/0xa0 kernel/printk/printk.c:2029
>> |  vprintk_func+0x636/0x820 kernel/printk/printk_safe.c:386
>> |  printk+0x18b/0x1d3 kernel/printk/printk.c:2062
>> |  canfd_rcv+0x370/0x3a0 net/can/af_can.c:697
>> |  __netif_receive_skb_one_core net/core/dev.c:5198 [inline]
>> |  __netif_receive_skb net/core/dev.c:5312 [inline]
>> |  netif_receive_skb_internal net/core/dev.c:5402 [inline]
>> |  netif_receive_skb+0xe77/0xf20 net/core/dev.c:5461
>> |  tun_rx_batched include/linux/skbuff.h:4321 [inline]
>> |  tun_get_user+0x6aef/0x6f60 drivers/net/tun.c:1997
>> |  tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
>> |  call_write_iter include/linux/fs.h:1901 [inline]
>> |  new_sync_write fs/read_write.c:483 [inline]
>> |  __vfs_write+0xa5a/0xca0 fs/read_write.c:496
>> |  vfs_write+0x44a/0x8f0 fs/read_write.c:558
>> |  ksys_write+0x267/0x450 fs/read_write.c:611
>> |  __do_sys_write fs/read_write.c:623 [inline]
>> |  __se_sys_write+0x92/0xb0 fs/read_write.c:620
>> |  __x64_sys_write+0x4a/0x70 fs/read_write.c:620
>> |  do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
>> |  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> In canfd_rcv() the non conformant CANFD frame (i.e. skb too short) is detected,
>> but the pr_warn_once() accesses uninitialized memory or the skb->data out of
>> bounds to print the warning message.
>>
>> This problem exists in both can_rcv() and canfd_rcv(). This patch removes the
>> access to the skb->data from the pr_warn_once() in both functions.
>>
>> Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> ---
>> Hello,
>>
>> changes since RFC:
>> - print cfd->len if backed by skb, -1 otherwise
>>    (Requested by Oliver)
> 
> Doh! I have to adjust the patch description. Will do in next iteration.

Thanks Marc!

So for the next iteration:
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Best,
Oliver
