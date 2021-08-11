Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D487D3E97A9
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhHKS3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhHKS3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:29:49 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AB8C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 11:29:25 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id y130so3429893qkb.6
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 11:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FPO/n4gCYbQjkOSWSHCrqiUk28+HyItmcb0KOBEOVLs=;
        b=LbFzVYPiMiGerN+W4l7/wfAbJDpv8AI1AhT36Rd0PvyepLaWVnopaxywZmDlmrnAN2
         pi6KuB/UZRMBhSckBQIo2WneyLgUDw7HIcXCElCiG2r65wfHsD6eIJaIqQhNDil0M0se
         ypGUuofqok4JWApgybwrIQzirHlSkia6qYikfz6+0ur9N0Vf2musM/R7DD86le0g/fwW
         PsfFKK76QTIRPfk0hQOAFe/QXXrxmK/VQhxuEJNecKQD0/duNfYI3QKi9DpETCVVLc78
         O6Rw0xqqKPn9eovLQka2XVnnZGgI8IcTV8mMMQ/e8Mj1SHDJxiXsNIMyXyIcPliBL7k7
         XKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FPO/n4gCYbQjkOSWSHCrqiUk28+HyItmcb0KOBEOVLs=;
        b=YOYtupBJP8jgh+6pLhvZHZgtIthEUY8oKlAg/zIaLHlUK+SLNwuSvayUaKSIexxsFq
         vU2CTBmAVOWB+HE/Ud+PMOwwr9aqaWZMMy3ADuf5sT+yDRfpMghpB+7IJgKnxqLPpeGd
         QS71wXZoGogAF8Mf7rqjRVM8B2IjIC/8p2jZiAggHHp83qpmjB9Kbis7WRQN/AkxaQG/
         vPI0/HMltxvtN9CK2m+RaL/faKK2S0rKOZQIldXTGtjhEcqD2QZZTRFT9+mTTSVJmYE5
         MF/RNGk3BBumdua3VM/2L1JKEpjoENtVN/7r0VHfgRchzbKlE9h6c0yCt6XUzwWxfzj/
         kAvw==
X-Gm-Message-State: AOAM5327iIzhbGxOwirwCtKYBGAfebjeIdFYkn77PPaSyppHsGIcAf0L
        UuCQi6wOK5rPt8OSBC1ziVg=
X-Google-Smtp-Source: ABdhPJwtc9aBo1MQdKNd3j0f9EsnCBv/kvAEfzw3LLraHuUvojXFOSQTGHec81/rlguAlzMrWonkFA==
X-Received: by 2002:a05:620a:88d:: with SMTP id b13mr361721qka.125.1628706564932;
        Wed, 11 Aug 2021 11:29:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 37sm31839qtf.33.2021.08.11.11.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:29:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Aug 2021 11:29:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: igmp: fix data-race in igmp_ifc_timer_expire()
Message-ID: <20210811182923.GA4027194@roeck-us.net>
References: <20210810094547.1851947-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810094547.1851947-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:45:47AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Fix the data-race reported by syzbot [1]
> Issue here is that igmp_ifc_timer_expire() can update in_dev->mr_ifc_count
> while another change just occured from another context.
> 
> in_dev->mr_ifc_count is only 8bit wide, so the race had little
> consequences.
> 
> [1]
> BUG: KCSAN: data-race in igmp_ifc_event / igmp_ifc_timer_expire
> 
> write to 0xffff8881051e3062 of 1 bytes by task 12547 on cpu 0:
>  igmp_ifc_event+0x1d5/0x290 net/ipv4/igmp.c:821
>  igmp_group_added+0x462/0x490 net/ipv4/igmp.c:1356
>  ____ip_mc_inc_group+0x3ff/0x500 net/ipv4/igmp.c:1461
>  __ip_mc_join_group+0x24d/0x2c0 net/ipv4/igmp.c:2199
>  ip_mc_join_group_ssm+0x20/0x30 net/ipv4/igmp.c:2218
>  do_ip_setsockopt net/ipv4/ip_sockglue.c:1285 [inline]
>  ip_setsockopt+0x1827/0x2a80 net/ipv4/ip_sockglue.c:1423
>  tcp_setsockopt+0x8c/0xa0 net/ipv4/tcp.c:3657
>  sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3362
>  __sys_setsockopt+0x18f/0x200 net/socket.c:2159
>  __do_sys_setsockopt net/socket.c:2170 [inline]
>  __se_sys_setsockopt net/socket.c:2167 [inline]
>  __x64_sys_setsockopt+0x62/0x70 net/socket.c:2167
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> read to 0xffff8881051e3062 of 1 bytes by interrupt on cpu 1:
>  igmp_ifc_timer_expire+0x706/0xa30 net/ipv4/igmp.c:808
>  call_timer_fn+0x2e/0x1d0 kernel/time/timer.c:1419
>  expire_timers+0x135/0x250 kernel/time/timer.c:1464
>  __run_timers+0x358/0x420 kernel/time/timer.c:1732
>  run_timer_softirq+0x19/0x30 kernel/time/timer.c:1745
>  __do_softirq+0x12c/0x26e kernel/softirq.c:558
>  invoke_softirq kernel/softirq.c:432 [inline]
>  __irq_exit_rcu+0x9a/0xb0 kernel/softirq.c:636
>  sysvec_apic_timer_interrupt+0x69/0x80 arch/x86/kernel/apic/apic.c:1100
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
>  console_unlock+0x8e8/0xb30 kernel/printk/printk.c:2646
>  vprintk_emit+0x125/0x3d0 kernel/printk/printk.c:2174
>  vprintk_default+0x22/0x30 kernel/printk/printk.c:2185
>  vprintk+0x15a/0x170 kernel/printk/printk_safe.c:392
>  printk+0x62/0x87 kernel/printk/printk.c:2216
>  selinux_netlink_send+0x399/0x400 security/selinux/hooks.c:6041
>  security_netlink_send+0x42/0x90 security/security.c:2070
>  netlink_sendmsg+0x59e/0x7c0 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:703 [inline]
>  sock_sendmsg net/socket.c:723 [inline]
>  ____sys_sendmsg+0x360/0x4d0 net/socket.c:2392
>  ___sys_sendmsg net/socket.c:2446 [inline]
>  __sys_sendmsg+0x1ed/0x270 net/socket.c:2475
>  __do_sys_sendmsg net/socket.c:2484 [inline]
>  __se_sys_sendmsg net/socket.c:2482 [inline]
>  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2482
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> value changed: 0x01 -> 0x02
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 12539 Comm: syz-executor.1 Not tainted 5.14.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  net/ipv4/igmp.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 6b3c558a4f232652b97a078d48f302864e60a866..a51360087b19845a28408c827032e08dabf99838 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -803,10 +803,17 @@ static void igmp_gq_timer_expire(struct timer_list *t)
>  static void igmp_ifc_timer_expire(struct timer_list *t)
>  {
>  	struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
> +	u8 mr_ifc_count;
>  
>  	igmpv3_send_cr(in_dev);
> -	if (in_dev->mr_ifc_count) {
> -		in_dev->mr_ifc_count--;
> +restart:
> +	mr_ifc_count = READ_ONCE(in_dev->mr_ifc_count);
> +
> +	if (mr_ifc_count) {
> +		if (cmpxchg(&in_dev->mr_ifc_count,

Unfortunately riscv only supports 4-byte and 8-byte cmpxchg(),
so this results in build errors.

Building riscv:defconfig ... failed
--------------
Error log:
In file included from <command-line>:
net/ipv4/igmp.c: In function 'igmp_ifc_timer_expire':
include/linux/compiler_types.h:328:45: error: call to '__compiletime_assert_547' declared with attribute error: BUILD_BUG failed

Guenter

> +			    mr_ifc_count,
> +			    mr_ifc_count - 1) != mr_ifc_count)
> +			goto restart;
>  		igmp_ifc_start_timer(in_dev,
>  				     unsolicited_report_interval(in_dev));
>  	}
> @@ -818,7 +825,7 @@ static void igmp_ifc_event(struct in_device *in_dev)
>  	struct net *net = dev_net(in_dev->dev);
>  	if (IGMP_V1_SEEN(in_dev) || IGMP_V2_SEEN(in_dev))
>  		return;
> -	in_dev->mr_ifc_count = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
> +	WRITE_ONCE(in_dev->mr_ifc_count, in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv);
>  	igmp_ifc_start_timer(in_dev, 1);
>  }
>  
> @@ -957,7 +964,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
>  				in_dev->mr_qri;
>  		}
>  		/* cancel the interface change timer */
> -		in_dev->mr_ifc_count = 0;
> +		WRITE_ONCE(in_dev->mr_ifc_count, 0);
>  		if (del_timer(&in_dev->mr_ifc_timer))
>  			__in_dev_put(in_dev);
>  		/* clear deleted report items */
> @@ -1724,7 +1731,7 @@ void ip_mc_down(struct in_device *in_dev)
>  		igmp_group_dropped(pmc);
>  
>  #ifdef CONFIG_IP_MULTICAST
> -	in_dev->mr_ifc_count = 0;
> +	WRITE_ONCE(in_dev->mr_ifc_count, 0);
>  	if (del_timer(&in_dev->mr_ifc_timer))
>  		__in_dev_put(in_dev);
>  	in_dev->mr_gq_running = 0;
> @@ -1941,7 +1948,7 @@ static int ip_mc_del_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
>  		pmc->sfmode = MCAST_INCLUDE;
>  #ifdef CONFIG_IP_MULTICAST
>  		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
> -		in_dev->mr_ifc_count = pmc->crcount;
> +		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
>  		for (psf = pmc->sources; psf; psf = psf->sf_next)
>  			psf->sf_crcount = 0;
>  		igmp_ifc_event(pmc->interface);
> @@ -2120,7 +2127,7 @@ static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
>  		/* else no filters; keep old mode for reports */
>  
>  		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
> -		in_dev->mr_ifc_count = pmc->crcount;
> +		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
>  		for (psf = pmc->sources; psf; psf = psf->sf_next)
>  			psf->sf_crcount = 0;
>  		igmp_ifc_event(in_dev);
> -- 
> 2.32.0.605.g8dce9f2422-goog
> 
