Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57081C2294
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 05:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgEBDcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 23:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgEBDcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 23:32:21 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057C3C061A0C;
        Fri,  1 May 2020 20:32:20 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s10so4374862plr.1;
        Fri, 01 May 2020 20:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yV1LN+kLbdpblxKhEvUsAbJTbcY59R1FfIgCptwc4yI=;
        b=Q7xoWyHdvlWxGWAUQ/FRWezQRMLm6Gje7/kH0cHcb9WMQ4ua1XCCZgQz428oXmt5Mp
         OkrMGbyEQ1w951kwWemCD9+EsRY2FZzi6IfEupZzBtILyBPRBUMfghf7/ulxJ2BoavV4
         T81xyW+XfMpobaNanj27EtHtET3jG2DGdp16Xyiazxz6O917o0sU513xpQYYkTVxQr7c
         FLrduCheLljTonUC55XHt3JxVRAq26tlkEbQJth+VSuuLEZ30UHHFa6Yf4AUSCg+ov1v
         kRVBdVxQ99xYWYblRZ0jKyWyYvQXM446WU5Zt0b7Orpi9Lc6kawkpGHJaXwfW5HEpmd4
         da/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yV1LN+kLbdpblxKhEvUsAbJTbcY59R1FfIgCptwc4yI=;
        b=Y8DZMt9a3p62Zdkt+poI31KB6yHQFog2k+IKMawO3Q4RmqN1UeEDRvGn1zrHLh1j1e
         i3gCwKvcE7vcJ1JWvLSUdVpa2uJ6aV/vmeYp1FckP6eU91PZYM0h5hVBVrkDSYRATyi4
         Pw209rGMr+tK9crQtDwPBlejNpDL4PxsLYVFk8IkKLZSF24j72gAYbdr+1mXl+Grn2XS
         Uk6QeEUd8qBLdUWcqygjlmeNAPBnfMQC9hMdvR1SyJVDXQWeWNGqVuftxmen2Cd/DxpL
         GyERqeya9Hnc6KoqJtZkJ5z4EJ39a4yQkyjVfpQjuRtpT8cncJpmYZPN8S4/+hpxBENf
         Fb7Q==
X-Gm-Message-State: AGi0PuaTPLCnzBQZrJ2Um2k+BYSZ04TKKmkmBCW9WXTROaFXz30soKwm
        pnUo54cY4QoWpi98qMbVdgwxstZH
X-Google-Smtp-Source: APiQypJp4cMVtSQMv87mOi4iDfZyLc0RYBNqgou8cGBL5tVqvH19KhOSk9St3hA5pgCGUkQiAXH6tw==
X-Received: by 2002:a17:90a:2e82:: with SMTP id r2mr3430146pjd.128.1588390340075;
        Fri, 01 May 2020 20:32:20 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k6sm873368pju.44.2020.05.01.20.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 20:32:19 -0700 (PDT)
Subject: Re: [PATCH] net: fix memory leaks in flush_backlog() with RPS
To:     Qian Cai <cai@lca.pw>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200502031516.2825-1-cai@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8a012879-825f-596d-9866-0dd3a095dfbb@gmail.com>
Date:   Fri, 1 May 2020 20:32:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200502031516.2825-1-cai@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/1/20 8:15 PM, Qian Cai wrote:
> netif_receive_skb_list_internal() could call enqueue_to_backlog() to put
> some skb to softnet_data.input_pkt_queue and then in
> ip_route_input_slow(), it allocates a dst_entry to be used in
> skb_dst_set(). Later,
> 
> cleanup_net
>   default_device_exit_batch
>     unregister_netdevice_many
>       rollback_registered_many
>         flush_all_backlogs
> 
> will call flush_backlog() for all CPUs which would call kfree_skb() for
> each skb on the input_pkt_queue without calling skb_dst_drop() first.
> 
> unreferenced object 0xffff97008e4c4040 (size 176):
>  comm "softirq", pid 0, jiffies 4295173845 (age 32012.550s)
>  hex dump (first 32 bytes):
>    00 d0 a5 74 04 97 ff ff 40 72 1a 96 ff ff ff ff  ...t....@r......
>    c1 a3 c5 95 ff ff ff ff 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<0000000030483fae>] kmem_cache_alloc+0x184/0x430
>    [<000000007ae17545>] dst_alloc+0x8e/0x128
>    [<000000001efe9a1f>] rt_dst_alloc+0x6f/0x1e0
>    rt_dst_alloc at net/ipv4/route.c:1628
>    [<00000000e67d4dac>] ip_route_input_rcu+0xdfe/0x1640
>    ip_route_input_slow at net/ipv4/route.c:2218
>    (inlined by) ip_route_input_rcu at net/ipv4/route.c:2348
>    [<000000009f30cbc0>] ip_route_input_noref+0xab/0x1a0
>    [<000000004f53bd04>] arp_process+0x83a/0xf50
>    arp_process at net/ipv4/arp.c:813 (discriminator 1)
>    [<0000000061fd547d>] arp_rcv+0x276/0x330
>    [<0000000007dbfa7a>] __netif_receive_skb_list_core+0x4d2/0x500
>    [<0000000062d5f6d2>] netif_receive_skb_list_internal+0x4cb/0x7d0
>    [<000000002baa2b74>] gro_normal_list+0x55/0xc0
>    [<0000000093d04885>] napi_complete_done+0xea/0x350
>    [<00000000467dd088>] tg3_poll_msix+0x174/0x310 [tg3]
>    [<00000000498af7d9>] net_rx_action+0x278/0x890
>    [<000000001e81d7e6>] __do_softirq+0xd9/0x589
>    [<00000000087ee354>] irq_exit+0xa2/0xc0
>    [<000000001c4db0cd>] do_IRQ+0x87/0x180
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  net/core/dev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 522288177bbd..b898cd3036da 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5496,6 +5496,7 @@ static void flush_backlog(struct work_struct *work)
>  	skb_queue_walk_safe(&sd->input_pkt_queue, skb, tmp) {
>  		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
>  			__skb_unlink(skb, &sd->input_pkt_queue);
> +			skb_dst_drop(skb);
>  			kfree_skb(skb);
>  			input_queue_head_incr(sd);
>  		}
> 


kfree_skb() is supposed to call skb_dst_drop() (look in skb_release_head_state())

If you think about it, we would have hundreds of similar bugs if this was not the case.
