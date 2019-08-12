Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273A889851
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfHLHyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:54:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46822 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfHLHyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 03:54:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so103718567wru.13
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 00:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tDWPgrRNhc9u7+ncHeamVeLoYEnYHXbBQClYQwCraM8=;
        b=mV5C9jn5D2t1jgVNNOF3bc+IyxISXPqUYULFuUwB7b0b5GC+qLjEuIDY2CCVOi9ok2
         VG+Fce3vynrqXL/fWIOOE813eU+BYKKvtvhjRIYZeeg0bNwyKN01JW+NCdyfxLchhbKD
         T1sFdA6QGPcZHU8HXvefdUwgZOd7qciee9AAwNZn1uxtxrYYqkUaFmmmJkrrnP8hsw5Y
         gGkL1D3dSe91C4i/AKEqhEqagKyEF/e6dAed5RhsqdB61W0a1WZ/PYZleUzfHWzf36SE
         VJkkdE/qt+w0D5QMzWZKLKcgS6FdrVKJP2lCcaIMZlkx9A/tHW1YxOmUm9R3kv536ElF
         0VVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tDWPgrRNhc9u7+ncHeamVeLoYEnYHXbBQClYQwCraM8=;
        b=GRbIM2xEaO16MWMZDSoMbv9RBd93M1Me8xA7nXOfrQRyTZzrcEJOPnWqkvS/oEZIrH
         6nAeNW4wcPK9LglOestobUsDUWEG8MksN5d74L9OK2GDIfFJG1XSvWANGc8d7MT940q1
         PRREPWvb9YwQ1lI9USyWthj4tCDi4iwSbruaM4/UApDYQlp5/kXn3l22erFeou40G7hY
         7vf88zCHGo6zijoTRyFOy3c9q7AVLrmy42QQFsYruwjle1wNHnNUQUT3pACi4By6rmU8
         MMI2XJsmmeELl7Y6tG+YiiUfIpDl1Dp0ks5cHHOM1szvpDYHwwS9WfJqapcmLJNCX5Pb
         6ibg==
X-Gm-Message-State: APjAAAW9sBS2eSQh+3e8rUVUnQ4cgmbJX46CSWNNaZcS1p/uMNxhLUIN
        fsZgRdAVIeiYqm/CC00Y26k=
X-Google-Smtp-Source: APXvYqz4L7E8p4h61JA53S2sxaeJz4K8AJ/fv0zMPVsF6cRaKmCb3/EGfO6JHKKgqTbnRUe175mZOw==
X-Received: by 2002:a5d:4b83:: with SMTP id b3mr34128416wrt.104.1565596455642;
        Mon, 12 Aug 2019 00:54:15 -0700 (PDT)
Received: from [192.168.8.147] (239.169.185.81.rev.sfr.net. [81.185.169.239])
        by smtp.gmail.com with ESMTPSA id b136sm22616091wme.18.2019.08.12.00.54.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 00:54:14 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] tipc: fix memory leak issue
To:     Ying Xue <ying.xue@windriver.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     jon.maloy@ericsson.com, hdanton@sina.com,
        tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, jakub.kicinski@netronome.com
References: <1565595162-1383-1-git-send-email-ying.xue@windriver.com>
 <1565595162-1383-2-git-send-email-ying.xue@windriver.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <989d5353-bf8c-be31-e692-81efe2d1acac@gmail.com>
Date:   Mon, 12 Aug 2019 09:54:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1565595162-1383-2-git-send-email-ying.xue@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/19 9:32 AM, Ying Xue wrote:
> syzbot found the following memory leak:
> 
> [   68.602482][ T7130] kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> BUG: memory leak
> unreferenced object 0xffff88810df83c00 (size 512):
>   comm "softirq", pid 0, jiffies 4294942354 (age 19.830s)
>   hex dump (first 32 bytes):
>     38 1a 0d 0f 81 88 ff ff 38 1a 0d 0f 81 88 ff ff  8.......8.......
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000009375ee42>] kmem_cache_alloc_node+0x153/0x2a0
>     [<000000004c563922>] __alloc_skb+0x6e/0x210
>     [<00000000ec87bfa1>] tipc_buf_acquire+0x2f/0x80
>     [<00000000d151ef84>] tipc_msg_create+0x37/0xe0
>     [<000000008bb437b0>] tipc_group_create_event+0xb3/0x1b0
>     [<00000000947b1d0f>] tipc_group_proto_rcv+0x569/0x640
>     [<00000000b75ab039>] tipc_sk_filter_rcv+0x9ac/0xf20
>     [<000000000dab7a6c>] tipc_sk_rcv+0x494/0x8a0
>     [<00000000023a7ddd>] tipc_node_xmit+0x196/0x1f0
>     [<00000000337dd9eb>] tipc_node_distr_xmit+0x7d/0x120
>     [<00000000b6375182>] tipc_group_delete+0xe6/0x130
>     [<000000000361ba2b>] tipc_sk_leave+0x57/0xb0
>     [<000000009df90505>] tipc_release+0x7b/0x5e0
>     [<000000009f3189da>] __sock_release+0x4b/0xe0
>     [<00000000d3568ee0>] sock_close+0x1b/0x30
>     [<00000000266a6215>] __fput+0xed/0x300
> 
> Reported-by: syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com
> Signed-off-by: Hillf Danton <hdanton@sina.com>
> Signed-off-by: Ying Xue <ying.xue@windriver.com>
> ---
>  net/tipc/node.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index 7ca0190..d1852fc 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -1469,10 +1469,13 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
>  	spin_unlock_bh(&le->lock);
>  	tipc_node_read_unlock(n);
>  
> -	if (unlikely(rc == -ENOBUFS))
> +	if (unlikely(rc == -ENOBUFS)) {
>  		tipc_node_link_down(n, bearer_id, false);
> -	else
> +		skb_queue_purge(list);
> +		skb_queue_purge(&xmitq);

This will crash if you enable LOCKDEP

> +	} else {
>  		tipc_bearer_xmit(net, bearer_id, &xmitq, &le->maddr);
> +	}
>  
>  	tipc_node_put(n);
>  
> 
