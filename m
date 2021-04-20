Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B17365A8C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhDTNtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbhDTNs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 09:48:58 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83250C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 06:48:25 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso21755082otm.4
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 06:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MKjwqXBXni2CEyEMYVZvmZlfEgOUYvrDJiO/2mGbth8=;
        b=NUK7J+v9YEwXWDhONKp/lHgQ9+WlEGE7MRaC4GRqPKOVrg8LDLvk10+I92lBASjb5Z
         KXwNk8tFDlwvt/c4wtCXQRCCgJYTtpfkyyzTBusYZ/GS4XsqympSShg8eQFiuFtkH7Zs
         fMhngN/PKgVFG4c+KLFtntwTyB6qvkFKZNkRccwhVcRyP8vSoowvvaQ4V/huk8aNkVUq
         f71v/1lsHgyMWxqtwVx3NgrFymMIKX6UsdibzoTVJssSBUQ+WU64PRZpDK0iuZ0kDbP3
         PzcWFWkeYZnGpwtrqGifwmIawOIL3VJtncMoFLsjlf1wYx0FJ+aoyd3s+B2ug/Jn+/SZ
         043Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MKjwqXBXni2CEyEMYVZvmZlfEgOUYvrDJiO/2mGbth8=;
        b=pbMHtPJjg2QjW6wfwHB7IiwUBuGeEjKqOXKXXc95rwMQx3QA74RWPS1R0DVYkjYpdv
         0Rhe/PE1wa35u5ZvcALaNOBTWrEIWZzwm37gWfWF1O225JGVpSVAEngqVd9hkGUNay9r
         YXtY1tepZ9WU/+886Vj09GYxKBoyr7uJlF5cLxhxcGCnd08igxfncc0j/F70JZC1q68U
         bt4++w5LxoN4VBSLbnQ1mPBy5SFlINx7Ewxj5Dkgk/yfL/nbzmNEbvyGFqfdTHgwccpU
         w9HANoC59SKFdBaYdDIBC9llrpe2LAQfgERbmKPsOb7ZWuKdGQJp/0gGn4Av3uksAWzS
         DtzQ==
X-Gm-Message-State: AOAM530xbeG+1iI9614MYLv6/HjQO4L6zGEPx+hZLONt7NbX1GAY+f9z
        Z3ZCnA3ewI3gZYZDvfMNDD7vvxeiLX0=
X-Google-Smtp-Source: ABdhPJwbHztjq4PoXEEV+h1zKzJjSEIVpNpv1GExHTA6znCzg5NX+PbXjVIjEVFiaQUsDSiIeNC2YQ==
X-Received: by 2002:a9d:6d10:: with SMTP id o16mr19720352otp.370.1618926504455;
        Tue, 20 Apr 2021 06:48:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s26sm201018otd.75.2021.04.20.06.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 06:48:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH net-next] virtio-net: fix use-after-free in page_to_skb()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20210420094341.3259328-1-eric.dumazet@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAlVcphcFCRmg06EACgkQyx8mb86fmYFg0RAA
 nzXJzuPkLJaOmSIzPAqqnutACchT/meCOgMEpS5oLf6xn5ySZkl23OxuhpMZTVX+49c9pvBx
 hpvl5bCWFu5qC1jC2eWRYU+aZZE4sxMaAGeWenQJsiG9lP8wkfCJP3ockNu0ZXXAXwIbY1O1
 c+l11zQkZw89zNgWgKobKzrDMBFOYtAh0pAInZ9TSn7oA4Ctejouo5wUugmk8MrDtUVXmEA9
 7f9fgKYSwl/H7dfKKsS1bDOpyJlqhEAH94BHJdK/b1tzwJCFAXFhMlmlbYEk8kWjcxQgDWMu
 GAthQzSuAyhqyZwFcOlMCNbAcTSQawSo3B9yM9mHJne5RrAbVz4TWLnEaX8gA5xK3uCNCeyI
 sqYuzA4OzcMwnnTASvzsGZoYHTFP3DQwf2nzxD6yBGCfwNGIYfS0i8YN8XcBgEcDFMWpOQhT
 Pu3HeztMnF3HXrc0t7e5rDW9zCh3k2PA6D2NV4fews9KDFhLlTfCVzf0PS1dRVVWM+4jVl6l
 HRIAgWp+2/f8dx5vPc4Ycp4IsZN0l1h9uT7qm1KTwz+sSl1zOqKD/BpfGNZfLRRxrXthvvY8
 BltcuZ4+PGFTcRkMytUbMDFMF9Cjd2W9dXD35PEtvj8wnEyzIos8bbgtLrGTv/SYhmPpahJA
 l8hPhYvmAvpOmusUUyB30StsHIU2LLccUPPOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAlVcpi8FCRmg08MACgkQyx8mb86fmYHNRQ/+
 J0OZsBYP4leJvQF8lx9zif+v4ZY/6C9tTcUv/KNAE5leyrD4IKbnV4PnbrVhjq861it/zRQW
 cFpWQszZyWRwNPWUUz7ejmm9lAwPbr8xWT4qMSA43VKQ7ZCeTQJ4TC8kjqtcbw41SjkjrcTG
 wF52zFO4bOWyovVAPncvV9eGA/vtnd3xEZXQiSt91kBSqK28yjxAqK/c3G6i7IX2rg6pzgqh
 hiH3/1qM2M/LSuqAv0Rwrt/k+pZXE+B4Ud42hwmMr0TfhNxG+X7YKvjKC+SjPjqp0CaztQ0H
 nsDLSLElVROxCd9m8CAUuHplgmR3seYCOrT4jriMFBtKNPtj2EE4DNV4s7k0Zy+6iRQ8G8ng
 QjsSqYJx8iAR8JRB7Gm2rQOMv8lSRdjva++GT0VLXtHULdlzg8VjDnFZ3lfz5PWEOeIMk7Rj
 trjv82EZtrhLuLjHRCaG50OOm0hwPSk1J64R8O3HjSLdertmw7eyAYOo4RuWJguYMg5DRnBk
 WkRwrSuCn7UG+qVWZeKEsFKFOkynOs3pVbcbq1pxbhk3TRWCGRU5JolI4ohy/7JV1TVbjiDI
 HP/aVnm6NC8of26P40Pg8EdAhajZnHHjA7FrJXsy3cyIGqvg9os4rNkUWmrCfLLsZDHD8FnU
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <c5a8aeaf-0f41-9274-b9c5-ec385b34180a@roeck-us.net>
Date:   Tue, 20 Apr 2021 06:48:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210420094341.3259328-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/21 2:43 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> KASAN/syzbot had 4 reports, one of them being:
> 
> BUG: KASAN: slab-out-of-bounds in memcpy include/linux/fortify-string.h:191 [inline]
> BUG: KASAN: slab-out-of-bounds in page_to_skb+0x5cf/0xb70 drivers/net/virtio_net.c:480
> Read of size 12 at addr ffff888014a5f800 by task systemd-udevd/8445
> 
> CPU: 0 PID: 8445 Comm: systemd-udevd Not tainted 5.12.0-rc8-next-20210419-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
>  __kasan_report mm/kasan/report.c:419 [inline]
>  kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
>  check_region_inline mm/kasan/generic.c:180 [inline]
>  kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
>  memcpy+0x20/0x60 mm/kasan/shadow.c:65
>  memcpy include/linux/fortify-string.h:191 [inline]
>  page_to_skb+0x5cf/0xb70 drivers/net/virtio_net.c:480
>  receive_mergeable drivers/net/virtio_net.c:1009 [inline]
>  receive_buf+0x2bc0/0x6250 drivers/net/virtio_net.c:1119
>  virtnet_receive drivers/net/virtio_net.c:1411 [inline]
>  virtnet_poll+0x568/0x10b0 drivers/net/virtio_net.c:1516
>  __napi_poll+0xaf/0x440 net/core/dev.c:6962
>  napi_poll net/core/dev.c:7029 [inline]
>  net_rx_action+0x801/0xb40 net/core/dev.c:7116
>  __do_softirq+0x29b/0x9fe kernel/softirq.c:559
>  invoke_softirq kernel/softirq.c:433 [inline]
>  __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
>  irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
>  common_interrupt+0xa4/0xd0 arch/x86/kernel/irq.c:240
> 
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8cd76037c72481200ea3e8429e9fdfec005dad85..2e28c04aa6351d2b4016f7d277ce104c4970069d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -385,6 +385,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	struct sk_buff *skb;
>  	struct virtio_net_hdr_mrg_rxbuf *hdr;
>  	unsigned int copy, hdr_len, hdr_padded_len;
> +	struct page *page_to_free = NULL;
>  	int tailroom, shinfo_size;
>  	char *p, *hdr_p;
>  
> @@ -445,7 +446,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  		if (len)
>  			skb_add_rx_frag(skb, 0, page, offset, len, truesize);
>  		else
> -			put_page(page);
> +			page_to_free = page;
>  		goto ok;
>  	}
>  
> @@ -479,6 +480,8 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  		hdr = skb_vnet_hdr(skb);
>  		memcpy(hdr, hdr_p, hdr_len);
>  	}
> +	if (page_to_free)
> +		put_page(page_to_free);
>  
>  	if (metasize) {
>  		__skb_pull(skb, metasize);
> 

Unfortunately that doesn't fix the problem for me. With this patch applied
on top of next-20210419, I still get the same crash as before:

udhcpc: sending discover^M
Unable to handle kernel paging request at virtual address 0000000000000004^M
udhcpc(169): Oops -1^M
pc = [<0000000000000004>]  ra = [<fffffc0000b8c5b8>]  ps = 0000    Not tainted^M
pc is at 0x4^M
ra is at napi_gro_receive+0x68/0x150^M
v0 = 0000000000000000  t0 = 0000000000000008  t1 = 0000000000000000^M
t2 = 0000000000000000  t3 = 000000000000000e  t4 = 0000000000000038^M
t5 = 000000000000ffff  t6 = fffffc00002f298a  t7 = fffffc0002c78000^M
s0 = fffffc00010b3ca0  s1 = 0000000000000000  s2 = fffffc00011267e0^M
s3 = 0000000000000000  s4 = fffffc00025f2008  s5 = fffffc00002f2940^M
s6 = fffffc00025f2040^M
a0 = fffffc00025f2008  a1 = fffffc00002f2940  a2 = fffffc0002ca000c^M
a3 = fffffc00000250d0  a4 = 0000000effff0008  a5 = 0000000000000000^M
t8 = fffffc00010b3c80  t9 = fffffc0002ca04cc  t10= 0000000000000000^M
t11= 00000000000004c0  pv = fffffc0000b8bc40  at = 0000000000000000^M
gp = fffffc00010f9fb8  sp = 00000000df74db09^M
Disabling lock debugging due to kernel taint^M
Trace:^M
[<fffffc0000b8c5b8>] napi_gro_receive+0x68/0x150^M
[<fffffc00009b409c>] receive_buf+0x50c/0x1b80^M
[<fffffc00009b58b8>] virtnet_poll+0x1a8/0x5b0^M
[<fffffc00009b58ec>] virtnet_poll+0x1dc/0x5b0^M
[<fffffc0000b8d17c>] __napi_poll+0x4c/0x270^M
[<fffffc0000b8d670>] net_rx_action+0x130/0x2c0^M
[<fffffc0000bd6cb0>] sch_direct_xmit+0x170/0x360^M
[<fffffc0000bd7000>] __qdisc_run+0x160/0x6c0^M
[<fffffc0000337b64>] do_softirq+0xa4/0xd0^M
[<fffffc0000337ca4>] __local_bh_enable_ip+0x114/0x120^M
[<fffffc0000b89554>] __dev_queue_xmit+0x484/0xa60^M
[<fffffc0000cd072c>] packet_sendmsg+0xe7c/0x1ba0^M
[<fffffc0000b53338>] __sys_sendto+0xf8/0x170^M
[<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
[<fffffc0000a9bf7c>] ehci_irq+0x2cc/0x5c0^M
[<fffffc0000a71334>] usb_hcd_irq+0x34/0x50^M
[<fffffc0000b521bc>] move_addr_to_kernel+0x3c/0x60^M
[<fffffc0000b532e4>] __sys_sendto+0xa4/0x170^M
[<fffffc0000b533d4>] sys_sendto+0x24/0x40^M
[<fffffc0000cfea38>] _raw_spin_lock+0x18/0x30^M
[<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
[<fffffc0000325298>] clipper_enable_irq+0x98/0x100^M
[<fffffc0000cfec18>] _raw_spin_unlock+0x18/0x30^M
[<fffffc0000311514>] entSys+0xa4/0xc0^M
^M
Code:^M
 00000000 ^M
 00063301 ^M
 00000897 ^M
 00001111 ^M
 00001672 ^M
^M
Kernel panic - not syncing: Aiee, killing interrupt handler!^M

Guenter
