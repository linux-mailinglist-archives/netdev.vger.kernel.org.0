Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9001C5D10C
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfGBNyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:54:38 -0400
Received: from linuxlounge.net ([88.198.164.195]:33810 "EHLO linuxlounge.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfGBNyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 09:54:38 -0400
Subject: Re: Memory leaks in IPv6 ndisc on v4.19.56
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxlounge.net;
        s=mail; t=1562075675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:in-reply-to:in-reply-to:
         references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=1ps3BfyNYtnNXFITdK3jKB3E7rUi31D/7+QM2jPVyo8=;
        b=jfLHCRbB2K6WV4CVNC3knfdhtdTBzDAwWGqk6me5Vp9mZVjYSP2HDOQgYVpEGIpfQmJ0mu
        Vo2NFZQJgW3DoBsBvDbj7137BmNXVVLEbvSp6fqnKF4KBFfVDuwUObjXAQ28lNgPgSXoQz
        +5lxt9AWIMxIc/p5z7BWCnftwdSDncM=
From:   Martin Weinelt <martin@linuxlounge.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
References: <8fadeb22-2a9b-6038-01f9-bf32b5055965@linuxlounge.net>
Openpgp: preference=signencrypt
Autocrypt: addr=martin@linuxlounge.net; prefer-encrypt=mutual; keydata=
 mQENBEv1rfkBCADFlzzmynjVg8L5ok/ef2Jxz8D96PtEAP//3U612b4QbHXzHC6+C2qmFEL6
 5kG1U1a7PPsEaS/A6K9AUpDhT7y6tX1IxAkSkdIEmIgWC5Pu2df4+xyWXarJfqlBeJ82biot
 /qETntfo01wm0AtqfJzDh/BkUpQw0dbWBSnAF6LytoNEggIGnUGmzvCidrEEsTCO6YlHfKIH
 cpz7iwgVZi4Ajtsky8v8P8P7sX0se/ce1L+qX/qN7TnXpcdVSfZpMnArTPkrmlJT4inBLhKx
 UeDMQmHe+BQvATa21fhcqi3BPIMwIalzLqVSIvRmKY6oYdCbKLM2TZ5HmyJepusl2Gi3ABEB
 AAG0J01hcnRpbiBXZWluZWx0IDxtYXJ0aW5AbGludXhsb3VuZ2UubmV0PokBWAQTAQoAQgIb
 IwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUC
 W/RuFQUJEd/znAAKCRC9SqBSj2PxfpfDCACDx6BYz6cGMiweQ96lXi+ihx7RBaXsfPp2KxUo
 eHilrDPqknq62XJibCyNCJiYGNb+RUS5WfDUAqxdl4HuNxQMC/sYlbP4b7p9Y1Q9QiTP4f6M
 8+Uvpicin+9H/lye5hS/Gp2KUiVI/gzqW68WqMhARUYw00lVSlJHy+xHEGVuQ0vmeopjU81R
 0si4+HhMX2HtILTxoUcvm67AFKidTHYMJKwNyMHiLLvSK6wwiy+MXaiqrMVTwSIOQhLgLVcJ
 33GNJ2Emkgkhs6xcaiN8xTjxDmiU7b5lXW4JiAsd1rbKINajcA7DVlZ/evGfpN9FczyZ4W6F
 Rf21CxSwtqv2SQHBuQENBEv1rfkBCADJX6bbb5LsXjdxDeFgqo+XRUvW0bzuS3SYNo0fuktM
 5WYMCX7TzoF556QU8A7C7bDUkT4THBUzfaA8ZKIuneYW2WN1OI0zRMpmWVeZcUQpXncWWKCg
 LBNYtk9CCukPE0OpDFnbR+GhGd1KF/YyemYnzwW2f1NOtHjwT3iuYnzzZNlWoZAR2CRSD02B
 YU87Mr2CMXrgG/pdRiaD+yBUG9RxCUkIWJQ5dcvgrsg81vOTj6OCp/47Xk/457O0pUFtySKS
 jZkZN6S7YXl/t+8C9g7o3N58y/X95VVEw/G3KegUR2SwcLdok4HaxgOy5YHiC+qtGNZmDiQn
 NXN7WIN/oof7ABEBAAGJATwEGAEKACYCGwwWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUCW/Ru
 GAUJEd/znwAKCRC9SqBSj2PxfpzMCACH55MVYTVykq+CWj1WMKHex9iFg7M9DkWQCF/Zl+0v
 QmyRMEMZnFW8GdX/Qgd4QbZMUTOGevGxFPTe4p0PPKqKEDXXXxTTHQETE/Hl0jJvyu+MgTxG
 E9/KrWmsmQC7ogTFCHf0vvVY3UjWChOqRE19Buk4eYpMbuU1dYefLNcD15o4hGDhohYn3SJr
 q9eaoO6rpnNIrNodeG+1vZYG1B2jpEdU4v354ziGcibt5835IONuVdvuZMFQJ4Pn2yyC+qJe
 ekXwZ5f4JEt0lWD9YUxB2cU+xM9sbDcQ2b6+ypVFzMyfU0Q6LzYugAqajZ10gWKmeyjisgyq
 sv5UJTKaOB/t
Message-ID: <e430b2cd-e358-f328-5445-b5f681118ce3@linuxlounge.net>
Date:   Tue, 2 Jul 2019 15:54:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
In-Reply-To: <8fadeb22-2a9b-6038-01f9-bf32b5055965@linuxlounge.net>
Content-Type: multipart/mixed;
 boundary="------------38895851984841390EF7846D"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------38895851984841390EF7846D
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi again,

another backtrace just came up.

Best,
  Martin


$ ./scripts/faddr2line /usr/lib/debug/lib/modules/4.19.56/vmlinux build_skb+0x11/0x80
build_skb+0x11/0x80:
build_skb at net/core/skbuff.c:314

$ ./scripts/faddr2line /usr/lib/debug/lib/modules/4.19.56/kernel/drivers/net/tun.ko tun_build_skb.isra.56+0x191/0x4d0
tun_build_skb.isra.56+0x191/0x4d0:
tun_build_skb at /home/hexa/git/linux-stable/drivers/net/tun.c:1687


On 7/2/19 3:05 PM, Martin Weinelt wrote:
> Hi everyone,
> 
> I've been experiencing memory leaks on the v4.19 series. I've started
> seeing them on Debian with v4.19.16 and I can reproduce them on v4.19.56
> using Debians kernel config. I was unable to reproduce this on 
> v5.2.0-rc6/rc7.
> 
>   [ 1899.380321] kmemleak: 1138 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> 
> On the machines in question we're running routers for a mesh networking
> setup based on the batman-adv kmod. Our setup consists of KVM guests 
> running Debian, with each router having 18 bridges with the following
> master/slave relationship:
> 
>   bridge -> batman-adv -> {L2 tunnel, virtio net device}
> 
> I've attached the output of kmemleak and I've looked up the top-most
> function offsets below:
> 
> Best,
>   Martin
> 
> 
> $ ./faddr2line /usr/lib/debug/lib/modules/4.19.56/vmlinux ndisc_recv_ns+0x356/0x5f0
> ndisc_recv_ns+0x356/0x5f0:
> __neigh_lookup at include/net/neighbour.h:513
> (inlined by) ndisc_recv_ns at net/ipv6/ndisc.c:916
> 
> $ ./faddr2line /usr/lib/debug/lib/modules/4.19.56/vmlinux ndisc_router_discovery+0x4ab/0xae0
> ndisc_router_discovery+0x4ab/0xae0:
> __neigh_lookup at include/net/neighbour.h:513
> (inlined by) ndisc_router_discovery at net/ipv6/ndisc.c:1387
> 
> $ ./faddr2line /usr/lib/debug/lib/modules/4.19.56/vmlinux ndisc_recv_rs+0x173/0x1b0
> ndisc_recv_rs+0x173/0x1b0:
> ndisc_recv_rs at net/ipv6/ndisc.c:1095
> 
> $ ./faddr2line /usr/lib/debug/lib/modules/4.19.56/vmlinux ip6_finish_output2+0x211/0x570
> ip6_finish_output2+0x211/0x570:
> ip6_finish_output2 at net/ipv6/ip6_output.c:117
> 


--------------38895851984841390EF7846D
Content-Type: text/x-log;
 name="kmemleak2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kmemleak2.log"

unreferenced object 0xffff98372c4c7900 (size 232):
  comm "softirq", pid 0, jiffies 4296767615 (age 1191.500s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 10 f7 54 37 98 ff ff 00 00 00 00 00 00 00 00  ...T7...........
  backtrace:
    [<00000000857c2a4c>] build_skb+0x11/0x80
    [<0000000076f6d169>] tun_build_skb.isra.56+0x191/0x4d0 [tun]
    [<00000000c88dc3b6>] tun_get_user+0x9d4/0x1290 [tun]
    [<000000000656b60d>] tun_chr_write_iter+0x4d/0x70 [tun]
    [<00000000a0791a09>] __vfs_write+0x114/0x1a0
    [<0000000043af9738>] vfs_write+0xb0/0x190
    [<0000000093a5d2f3>] ksys_write+0x5a/0xd0
    [<00000000ca8283f7>] do_syscall_64+0x55/0x100
    [<00000000ea7ed8f5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<0000000005a897b6>] 0xffffffffffffffff
unreferenced object 0xffff98372c4c7800 (size 232):
  comm "softirq", pid 0, jiffies 4296768010 (age 1189.920s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 10 f7 54 37 98 ff ff 00 00 00 00 00 00 00 00  ...T7...........
  backtrace:
    [<00000000857c2a4c>] build_skb+0x11/0x80
    [<0000000076f6d169>] tun_build_skb.isra.56+0x191/0x4d0 [tun]
    [<00000000c88dc3b6>] tun_get_user+0x9d4/0x1290 [tun]
    [<000000000656b60d>] tun_chr_write_iter+0x4d/0x70 [tun]
    [<00000000a0791a09>] __vfs_write+0x114/0x1a0
    [<0000000043af9738>] vfs_write+0xb0/0x190
    [<0000000093a5d2f3>] ksys_write+0x5a/0xd0
    [<00000000ca8283f7>] do_syscall_64+0x55/0x100
    [<00000000ea7ed8f5>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<0000000005a897b6>] 0xffffffffffffffff


--------------38895851984841390EF7846D--
