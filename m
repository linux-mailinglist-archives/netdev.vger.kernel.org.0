Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9223F3E97B1
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhHKSdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKSdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:33:23 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1214AC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 11:32:59 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id s132so3421559qke.9
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 11:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1+aHnvoGRTrKP22JMDKXI7YpsPKqXbF8uHDlOtjNUBI=;
        b=M29OyYOwJZvY4h2WXdVFRRmjwjOGzalpspynVexXRLFM8sdzSUcl/OMOYyRudD8RRS
         LKPAsJDqy34iFdPhpVdMTjbS6/waTkCqpDTtdN0hEm4NTJXVS0/wOS2oN0fd1c6Qz3+v
         OirUnJ8sFzbf0/JmQcCM6LiVuSTF1WfNO2iBecZANgIfsqDVsMyoyKFCYKOG3fmLajy8
         I1gBnlROHPLDIaH/W7rEQklaJPTAH8R08wVmyQdelLOoLWnRqRd2MuRZs/xxc0pclyi/
         +HurMqf4q3VsJbPEImh5+DvRbT/Bwfl3saren756vTlWHskjv1LUAP4/764k17GLNVdI
         fllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1+aHnvoGRTrKP22JMDKXI7YpsPKqXbF8uHDlOtjNUBI=;
        b=EME2PSSirKVRKZ0r3Yd6xx1cQVLQ3Aox5HHGdmLThC88H7cuwn6U9noXsRTQjeb2FV
         fJCtlCbBXoxF2vjyRl2oZuKGbnWtkWTgc2h1c/njQ5vDrrDZ4L7hhgZVgLaM0l6AVVvv
         mIVdh4lx1OHU3ExnZ54iEcg9zT6sqwciUMN7AicY+TU+y9zjKFA1iJF1QDLpA9l/Evrm
         YMlzCTwEAfLk5J5GA0cq5SXNGjJClz122S+h4u4HCvCpwHG1569egq80QA9p5UIv1lVl
         Cl5LN9/5mAxCd7LoLgSrC1XKF2uT4XRyOqQ1PiYWkqc7gEXdIIFAwV2PUksbCFq0Xkel
         yClg==
X-Gm-Message-State: AOAM533bUqDZ+k1wJ4tuWHIpiiawZ5TR2b3oa3923QZU85bMjV6P9pe0
        0NpA3fGBIdy+maMlLQXKBSg=
X-Google-Smtp-Source: ABdhPJwv9vQZt0Quteneqon94l9mnr0ZgmFHNdY/p09gNa4OtTEtVyUL+cjXdi3YlUATaJHZm7wBJg==
X-Received: by 2002:a37:743:: with SMTP id 64mr396548qkh.290.1628706778170;
        Wed, 11 Aug 2021 11:32:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y67sm13102064qkd.58.2021.08.11.11.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:32:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 11 Aug 2021 11:32:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: igmp: fix data-race in igmp_ifc_timer_expire()
Message-ID: <20210811183256.GA4139434@roeck-us.net>
References: <20210810094547.1851947-1-eric.dumazet@gmail.com>
 <20210811182923.GA4027194@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811182923.GA4027194@roeck-us.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 11:29:25AM -0700, Guenter Roeck wrote:
> On Tue, Aug 10, 2021 at 02:45:47AM -0700, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > Fix the data-race reported by syzbot [1]
> > Issue here is that igmp_ifc_timer_expire() can update in_dev->mr_ifc_count
> > while another change just occured from another context.
> > 
> > in_dev->mr_ifc_count is only 8bit wide, so the race had little
> > consequences.
> > 
> > [1]
> > BUG: KCSAN: data-race in igmp_ifc_event / igmp_ifc_timer_expire
> > 
> > write to 0xffff8881051e3062 of 1 bytes by task 12547 on cpu 0:
> >  igmp_ifc_event+0x1d5/0x290 net/ipv4/igmp.c:821
> >  igmp_group_added+0x462/0x490 net/ipv4/igmp.c:1356
> >  ____ip_mc_inc_group+0x3ff/0x500 net/ipv4/igmp.c:1461
> >  __ip_mc_join_group+0x24d/0x2c0 net/ipv4/igmp.c:2199
> >  ip_mc_join_group_ssm+0x20/0x30 net/ipv4/igmp.c:2218
> >  do_ip_setsockopt net/ipv4/ip_sockglue.c:1285 [inline]
> >  ip_setsockopt+0x1827/0x2a80 net/ipv4/ip_sockglue.c:1423
> >  tcp_setsockopt+0x8c/0xa0 net/ipv4/tcp.c:3657
> >  sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3362
> >  __sys_setsockopt+0x18f/0x200 net/socket.c:2159
> >  __do_sys_setsockopt net/socket.c:2170 [inline]
> >  __se_sys_setsockopt net/socket.c:2167 [inline]
> >  __x64_sys_setsockopt+0x62/0x70 net/socket.c:2167
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > read to 0xffff8881051e3062 of 1 bytes by interrupt on cpu 1:
> >  igmp_ifc_timer_expire+0x706/0xa30 net/ipv4/igmp.c:808
> >  call_timer_fn+0x2e/0x1d0 kernel/time/timer.c:1419
> >  expire_timers+0x135/0x250 kernel/time/timer.c:1464
> >  __run_timers+0x358/0x420 kernel/time/timer.c:1732
> >  run_timer_softirq+0x19/0x30 kernel/time/timer.c:1745
> >  __do_softirq+0x12c/0x26e kernel/softirq.c:558
> >  invoke_softirq kernel/softirq.c:432 [inline]
> >  __irq_exit_rcu+0x9a/0xb0 kernel/softirq.c:636
> >  sysvec_apic_timer_interrupt+0x69/0x80 arch/x86/kernel/apic/apic.c:1100
> >  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
> >  console_unlock+0x8e8/0xb30 kernel/printk/printk.c:2646
> >  vprintk_emit+0x125/0x3d0 kernel/printk/printk.c:2174
> >  vprintk_default+0x22/0x30 kernel/printk/printk.c:2185
> >  vprintk+0x15a/0x170 kernel/printk/printk_safe.c:392
> >  printk+0x62/0x87 kernel/printk/printk.c:2216
> >  selinux_netlink_send+0x399/0x400 security/selinux/hooks.c:6041
> >  security_netlink_send+0x42/0x90 security/security.c:2070
> >  netlink_sendmsg+0x59e/0x7c0 net/netlink/af_netlink.c:1919
> >  sock_sendmsg_nosec net/socket.c:703 [inline]
> >  sock_sendmsg net/socket.c:723 [inline]
> >  ____sys_sendmsg+0x360/0x4d0 net/socket.c:2392
> >  ___sys_sendmsg net/socket.c:2446 [inline]
> >  __sys_sendmsg+0x1ed/0x270 net/socket.c:2475
> >  __do_sys_sendmsg net/socket.c:2484 [inline]
> >  __se_sys_sendmsg net/socket.c:2482 [inline]
> >  __x64_sys_sendmsg+0x42/0x50 net/socket.c:2482
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > value changed: 0x01 -> 0x02
> > 
> > Reported by Kernel Concurrency Sanitizer on:
> > CPU: 1 PID: 12539 Comm: syz-executor.1 Not tainted 5.14.0-rc4-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > ---
> >  net/ipv4/igmp.c | 21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> > 
> > diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> > index 6b3c558a4f232652b97a078d48f302864e60a866..a51360087b19845a28408c827032e08dabf99838 100644
> > --- a/net/ipv4/igmp.c
> > +++ b/net/ipv4/igmp.c
> > @@ -803,10 +803,17 @@ static void igmp_gq_timer_expire(struct timer_list *t)
> >  static void igmp_ifc_timer_expire(struct timer_list *t)
> >  {
> >  	struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
> > +	u8 mr_ifc_count;
> >  
> >  	igmpv3_send_cr(in_dev);
> > -	if (in_dev->mr_ifc_count) {
> > -		in_dev->mr_ifc_count--;
> > +restart:
> > +	mr_ifc_count = READ_ONCE(in_dev->mr_ifc_count);
> > +
> > +	if (mr_ifc_count) {
> > +		if (cmpxchg(&in_dev->mr_ifc_count,
> 
> Unfortunately riscv only supports 4-byte and 8-byte cmpxchg(),
> so this results in build errors.
> 
> Building riscv:defconfig ... failed
> --------------
> Error log:
> In file included from <command-line>:
> net/ipv4/igmp.c: In function 'igmp_ifc_timer_expire':
> include/linux/compiler_types.h:328:45: error: call to '__compiletime_assert_547' declared with attribute error: BUILD_BUG failed
> 

Also:

Building arm:allmodconfig ... failed
--------------
Error log:
arm-linux-gnueabi-ld: net/ipv4/igmp.o: in function `igmp_ifc_timer_expire':
igmp.c:(.text+0x9b44): undefined reference to `__bad_cmpxchg'
make[1]: *** [Makefile:1176: vmlinux] Error 1
make: *** [Makefile:220: __sub-make] Error 2

Building xtensa:allmodconfig ... failed
--------------
Error log:
xtensa-linux-ld: net/ipv4/igmp.o: in function `igmp_gq_timer_expire':
igmp.c:(.text+0x4d4c): undefined reference to `__cmpxchg_called_with_bad_pointer'
xtensa-linux-ld: net/ipv4/igmp.o: in function `igmp_ifc_timer_expire':
igmp.c:(.text+0x4dad): undefined reference to `__cmpxchg_called_with_bad_pointer'

Guenter
