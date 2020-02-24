Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2716B09D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgBXTxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:53:02 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:8003 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgBXTxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:53:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1582573977;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=lbWurZnzzNth4SeMxuDrLA9JAv8a5qeXa3rM4ZKqP60=;
        b=K0AFH8n2OgVSpSccUthv729W8lrDwn/KYrtDAQWik9MRA24jMgJsZ+bKRa9VGkl7X9
        qTc7kTiS57w3Es1kxyN7r3mjI+wgMoRNDsJvK9MqGFetIYleZllDu5my1YduAhnCLki0
        VXN694UF/HYnrgZI9NxKaTaqNxGkA1hWdKGPI/ooPuf+jbKYSPBhRTwbu+bKB6fykpOQ
        Zqg2VjLF4LjoejlKd1xbmm7iwLjGfJl6In+M5NqKYAAvN7l5e7I2dniTKNOiOwzNUcIn
        /BBE9yGrcAqIt9IMKmM3X03moO1DwkRsh3PqSg/20J7ijjUk2GuQ3VKVABezNXYU4kSQ
        9rcQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJV8h5kUu4"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id g084e8w1OJqpA4n
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 24 Feb 2020 20:52:51 +0100 (CET)
Subject: Re: [RFC] can: af_can: can_rcv() canfd_rcv(): Fix access of
 uninitialized memory or out of bounds
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can @ vger . kernel . org" <linux-can@vger.kernel.org>
Cc:     kernel@pengutronix.de, glider@google.com, kuba@kernel.org,
        netdev@vger.kernel.org,
        syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
References: <20200224094100.2431262-1-mkl@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <b3ef9c62-2436-749a-4cf2-1faf55d8b542@hartkopp.net>
Date:   Mon, 24 Feb 2020 20:52:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224094100.2431262-1-mkl@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/02/2020 10.41, Marc Kleine-Budde wrote:
> Syzbot found the use of uninitialzied memory when injecting non conformant
> CANFD frames via a tun device into the kernel:
> 
> | BUG: KMSAN: uninit-value in number+0x9f8/0x2000 lib/vsprintf.c:459
> | CPU: 1 PID: 11897 Comm: syz-executor136 Not tainted 5.6.0-rc2-syzkaller #0
> | Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> | Call Trace:
> |  __dump_stack lib/dump_stack.c:77 [inline]
> |  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
> |  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
> |  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
> |  number+0x9f8/0x2000 lib/vsprintf.c:459
> |  vsnprintf+0x1d85/0x31b0 lib/vsprintf.c:2640
> |  vscnprintf+0xc2/0x180 lib/vsprintf.c:2677
> |  vprintk_store+0xef/0x11d0 kernel/printk/printk.c:1917
> |  vprintk_emit+0x2c0/0x860 kernel/printk/printk.c:1984
> |  vprintk_default+0x90/0xa0 kernel/printk/printk.c:2029
> |  vprintk_func+0x636/0x820 kernel/printk/printk_safe.c:386
> |  printk+0x18b/0x1d3 kernel/printk/printk.c:2062
> |  canfd_rcv+0x370/0x3a0 net/can/af_can.c:697
> |  __netif_receive_skb_one_core net/core/dev.c:5198 [inline]
> |  __netif_receive_skb net/core/dev.c:5312 [inline]
> |  netif_receive_skb_internal net/core/dev.c:5402 [inline]
> |  netif_receive_skb+0xe77/0xf20 net/core/dev.c:5461
> |  tun_rx_batched include/linux/skbuff.h:4321 [inline]
> |  tun_get_user+0x6aef/0x6f60 drivers/net/tun.c:1997
> |  tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
> |  call_write_iter include/linux/fs.h:1901 [inline]
> |  new_sync_write fs/read_write.c:483 [inline]
> |  __vfs_write+0xa5a/0xca0 fs/read_write.c:496
> |  vfs_write+0x44a/0x8f0 fs/read_write.c:558
> |  ksys_write+0x267/0x450 fs/read_write.c:611
> |  __do_sys_write fs/read_write.c:623 [inline]
> |  __se_sys_write+0x92/0xb0 fs/read_write.c:620
> |  __x64_sys_write+0x4a/0x70 fs/read_write.c:620
> |  do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
> |  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> In canfd_rcv() the non conformant CANFD frame (i.e. skb too short) is detected,
> but the pr_warn_once() accesses uninitialized memory or the skb->data out of
> bounds to print the warning message.
> 
> This problem exists in both can_rcv() and canfd_rcv(). This patch removes the
> access to the skb->data from the pr_warn_once() in both functions.
> 
> Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

IMO the cfd->len is a relevant information for this warning message.

Won't it make sense, to check the skb->len inside pr_warn_once() whether 
the skb contains at least the cfd->len information before accessing it?

Btw. do you take this patch via your tree too?
https://marc.info/?l=linux-can&m=158039108004683

Regards,
Oliver

> ---
>   net/can/af_can.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 7511bfae2e0d..bd37922b0c9e 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -677,8 +677,8 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
>   
>   	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU ||
>   		     cfd->len > CAN_MAX_DLEN)) {
> -		pr_warn_once("PF_CAN: dropped non conform CAN skbuf: dev type %d, len %d, datalen %d\n",
> -			     dev->type, skb->len, cfd->len);
> +		pr_warn_once("PF_CAN: dropped non conform CAN skbuf: dev type %d, len %d\n",
> +			     dev->type, skb->len);
>   		kfree_skb(skb);
>   		return NET_RX_DROP;
>   	}
> @@ -694,8 +694,8 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
>   
>   	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU ||
>   		     cfd->len > CANFD_MAX_DLEN)) {
> -		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuf: dev type %d, len %d, datalen %d\n",
> -			     dev->type, skb->len, cfd->len);
> +		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuf: dev type %d, len %d\n",
> +			     dev->type, skb->len);
>   		kfree_skb(skb);
>   		return NET_RX_DROP;
>   	}
> 
