Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF732B5C5A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgKQJz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgKQJz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:55:56 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F3FC0613CF;
        Tue, 17 Nov 2020 01:55:56 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id w24so2635049wmi.0;
        Tue, 17 Nov 2020 01:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OkcHvoC9h7XnzKKVDJ1PQHmwjVn7AwnuwH67E4ZJXKg=;
        b=GCbgEIdlb48DiO/AChdy8hwFfHHbhQ0BVWCpt2kPmfWWha3y1aE7XF8XTWT4DAIo6B
         Brm9GABSbiaQFoRRG7K7x0V4AxFyYosXLaDSqw/1fGO6bhU0963iesiy0YGG/QvvGKbM
         fW31Q/XFEBybJMGtVVezISrkBNn55MJj0RB2VXJT4GHlJKHGqXeffxQPrj6pxRAAhxm5
         KTOQ7vM77++oAJZIhW4pnQpMvb8r6bbYOFzdurd7NRug7PAxx3KOJtNUxMCJSPgqKTNa
         FvnPFM3s8uDt78fIZWR7nRqUINakYxeFg4tvehcGeEVGD7lLOb5/L1haBlK793qtWZDZ
         yFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OkcHvoC9h7XnzKKVDJ1PQHmwjVn7AwnuwH67E4ZJXKg=;
        b=skZgZQ7+myd5Hu2FtOCWfFiGxGKHlFHvz41a5ywUoZG6vMuGXIboe4aV1ZyvvRHV84
         GkKRkcihhPDX0Yi8L6lpbSGOLDwmoPL9mL+YSaVTHgdTg/4okE4mZM0615PNa1bydQDR
         XgbIw5+BXEf1yT4DB8FdB7eNTGRU14R9tnRXrTYhDTIScPvhXQNPGph9lHee5lp2j3Fc
         Sw/uf7N7bqlZNBuWHSZ/dutI7egtYrbMxCVzNlI4aSlzQv91r/aCRGVhqCPm8+2RHqMy
         qGJYo6+vPTDN8e3POXKClKXGQBxhrIjAWflCxekRbxnMI7gFc/3kKvB0qd1CMU9/AR79
         Q2bQ==
X-Gm-Message-State: AOAM531jQ2A4dmBTSc10Uj9WwaQ0M058F6z18OrpLFqg+MAawxYj+eQ0
        xWfvZWe5uNcOdWdORCOmln8960uj+NM=
X-Google-Smtp-Source: ABdhPJx9i49JfIzqbWnR8bDQWe4GMj8kNh83/pphhmGfBiSgttCjeyecQ50WyltC4OTZaVjq4TsirQ==
X-Received: by 2002:a1c:2643:: with SMTP id m64mr3523353wmm.28.1605606954393;
        Tue, 17 Nov 2020 01:55:54 -0800 (PST)
Received: from [192.168.8.114] ([37.172.222.211])
        by smtp.gmail.com with ESMTPSA id m21sm5979264wmi.3.2020.11.17.01.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 01:55:53 -0800 (PST)
Subject: Re: [PATCH v6] tcp: fix race condition when creating child sockets
 from syncookies
To:     Ricardo Dias <rdias@singlestore.com>, davem@davemloft.net,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201117072955.GA1611867@rdias-suse-pc.lan>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <305d00e2-c3db-3621-33a6-c1377b1aca63@gmail.com>
Date:   Tue, 17 Nov 2020 10:55:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201117072955.GA1611867@rdias-suse-pc.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/20 8:29 AM, Ricardo Dias wrote:
> When the TCP stack is in SYN flood mode, the server child socket is
> created from the SYN cookie received in a TCP packet with the ACK flag
> set.
> 

...

>  
> @@ -1374,6 +1381,13 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
>  				skb_set_owner_r(newnp->pktoptions, newsk);
>  			}
>  		}
> +	} else {
> +		if (!req_unhash && esk) {
> +			/* This code path should only be executed in the
> +			 * syncookie case only
> +			 */
> +			newsk = esk;

What happens to the socket we just created and was stored in @newsk ?

We are going to leak kernel memory quite fast, if we just forget about it.

> +		}
>  	}
>  
>  	return newsk;
> 

Anyway, I have tested your patch (see below) and had many errors in 

[  669.578597] cleanup rbuf bug: copied 1A5AD52D seq 1A5AD52D rcvnxt 1A5AD52D
[  669.578604] WARNING: CPU: 30 PID: 13267 at net/ipv4/tcp.c:1553 tcp_cleanup_rbuf+0x48/0x100
[  669.578604] Modules linked in: vfat fat w1_therm wire i2c_mux_pca954x i2c_mux cdc_acm ehci_pci ehci_hcd mlx4_en mlx4_ib ib_uverbs ib_core mlx4_core
[  669.578610] CPU: 30 PID: 13267 Comm: ld-2.15.so.orig Tainted: G S      W         5.10.0-smp-DEV #394
[  669.578611] Hardware name: Intel RML,PCH/Iota_QC_19, BIOS 2.60.0 10/02/2019
[  669.578612] RIP: 0010:tcp_cleanup_rbuf+0x48/0x100
[  669.578612] Code: f3 48 39 d0 74 26 48 85 c0 74 21 8b 50 2c 8b b7 7c 05 00 00 39 d6 78 14 8b 8f 78 05 00 00 48 c7 c7 08 8a 57 a5 e8 1d b6 10 00 <0f> 0b 41 0f b6 84 24 c8 04 00 00 a8 01 74 2a 41 0f b7 8c 24 de 04
[  669.578613] RSP: 0018:ffff893bd898fca8 EFLAGS: 00010286
[  669.578614] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffff7fff
[  669.578615] RDX: 00000000ffff7fff RSI: 00000000ffffffea RDI: 0000000000000000
[  669.578615] RBP: ffff893bd898fcb8 R08: ffffffffa5bed108 R09: 0000000000027ffb
[  669.578616] R10: 00000000ffff8000 R11: 3fffffffffffffff R12: ffff891cd3530140
[  669.578617] R13: ffff891cd3530140 R14: 0000000000000000 R15: 0000000000000000
[  669.578618] FS:  00007fb7908ea700(0000) GS:ffff893affc80000(0000) knlGS:0000000000000000
[  669.578619] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  669.578620] CR2: 000034fedd58981c CR3: 00000020d87b2001 CR4: 00000000001706e0
[  669.578620] Call Trace:
[  669.578621]  tcp_recvmsg+0x21f/0xac0
[  669.578624]  inet6_recvmsg+0x5f/0x120
[  669.578625]  ? add_wait_queue_exclusive+0x80/0x80
[  669.578627]  sock_recvmsg+0x54/0x80
[  669.578628]  __sys_recvfrom+0x19e/0x1d0
[  669.578630]  ? __fput+0x11c/0x240
[  669.578632]  __x64_sys_recvfrom+0x29/0x30
[  669.578634]  do_syscall_64+0x38/0x50
[  669.578635]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

I have used following method on DUT host, and patch [1] in get_rps_cpus()

DUT has 48 hyper threads, I force RPS to spread packets on all of them.

for q in {0..15}; do echo ffff,ffffffff >/sys/class/net/eth0/queues/rx-$q/rps_cpus; done
echo 2 >/proc/sys/net/ipv4/tcp_syncookies
netserver

Then from another host : 

for i in {1..20}
do
 super_netperf 200 -H DUT -t TCP_CRR -l2 -- -p0
done

After the test, I had more than 100,000 TCPv6 sockets that were mem leaked.


[1]
diff --git a/net/core/dev.c b/net/core/dev.c
index 60d325bda0d7b4a1ecb7bf7b3352d58bed8b96a2..ae99206bd05126eef8cf4490bb197a3c781012ed 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4344,7 +4344,7 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
                goto done;
 
        skb_reset_network_header(skb);
-       hash = skb_get_hash(skb);
+       hash = prandom_u32();
        if (!hash)
                goto done;
 

