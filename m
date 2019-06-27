Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E0D57F86
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 11:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfF0JpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 05:45:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38147 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfF0JpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 05:45:07 -0400
Received: by mail-pl1-f194.google.com with SMTP id 9so213257ple.5
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 02:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o85DtuAz6vSx6yFaE334J1wzUYYj6hZsrPSLAKXtHB8=;
        b=B3dztp3FcbA+7gNRlLkK7oLFjcDbh9ysjKzlVhmeiWvFSCRRgzOu3jhWlItI82K2on
         NoC9lJxElbHVs2s4IX94GlGQFoe1E0/xUG3B1tEb26/oerqwu8DlL0WRHuDNY+XVtyjZ
         ySDfC6lB1mxaE7gUkEMaYm0rh/Uq32hvFs6nMoY+ZKJ8xiY+0oxcxlAi8ilEZJc6mQgg
         DHYglcFS0zRsnJALqhaPYuy4d0ttc50Jl8Fid2xdJEpCVcZHrvRFBSmPl2+9s2Z2DNIp
         1kUTYczvCKliX8609aQRmOG8qt9jUfIUmunjcEOkHde/YAWL8CvWvRYaQYgCKKjI+duU
         CcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o85DtuAz6vSx6yFaE334J1wzUYYj6hZsrPSLAKXtHB8=;
        b=qyALshrV6lYwJUd5tfpC5S6G32U0W34ccj8aVC8qg/n/UFEGvA4NDFDVJMZ46yUQTB
         lbQIhg+in2GpRQtbGdITTGGnuohlW5FD/otk53+pWyHcd8AXI/UkyVAPwHlvHy/4zgkE
         Al373ICFdqLuygEHRwtd0l9gJ7M5PYwBxobfQQzbE016RHEJI9Ev35vl113TZ6T37n6M
         ITmbP7ucBHXbUps///N3F34P1o0zmm53r15Y0yvGWTLpEodT9GQj/teTMX3gtDV+n+Rp
         KOgyZkrmP1IHXLZnuQaHc90lw93Oif35q3NBw/wGlrzs5yQzamMorTul9khzW8CxIDG6
         seRw==
X-Gm-Message-State: APjAAAXk185vxUzWMjKCALoNe0HypGkuR5yHfldwXhkM7aNGxyOWrcSa
        Lr4V7N2QyNJ1q/iOBOEXQBI=
X-Google-Smtp-Source: APXvYqzVL9c51KzJLbk0NTFGs9xwSuuG5UZU1OMSwSvUjoxGJzxAsHQW0lQbTG3CsLFbLiyWGpXW9Q==
X-Received: by 2002:a17:902:8546:: with SMTP id d6mr3497964plo.207.1561628707099;
        Thu, 27 Jun 2019 02:45:07 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d123sm2323124pfc.144.2019.06.27.02.45.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 02:45:06 -0700 (PDT)
Date:   Thu, 27 Jun 2019 17:44:57 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] igmp: fix memory leak in igmpv3_del_delrec()
Message-ID: <20190627094457.GL18865@dhcp-12-139.nay.redhat.com>
References: <20190627082701.226711-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627082701.226711-1-edumazet@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 01:27:01AM -0700, Eric Dumazet wrote:
> im->tomb and/or im->sources might not be NULL, but we
> currently overwrite their values blindly.
> 
> Using swap() will make sure the following call to kfree_pmc(pmc)
> will properly free the psf structures.
> 
> Tested with the C repro provided by syzbot, which basically does :
> 
>  socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
>  setsockopt(3, SOL_IP, IP_ADD_MEMBERSHIP, "\340\0\0\2\177\0\0\1\0\0\0\0", 12) = 0
>  ioctl(3, SIOCSIFFLAGS, {ifr_name="lo", ifr_flags=0}) = 0
>  setsockopt(3, SOL_IP, IP_MSFILTER, "\340\0\0\2\177\0\0\1\1\0\0\0\1\0\0\0\377\377\377\377", 20) = 0
>  ioctl(3, SIOCSIFFLAGS, {ifr_name="lo", ifr_flags=IFF_UP}) = 0
>  exit_group(0)                    = ?
> 
> BUG: memory leak
> unreferenced object 0xffff88811450f140 (size 64):
>   comm "softirq", pid 0, jiffies 4294942448 (age 32.070s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000c7bad083>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
>     [<00000000c7bad083>] slab_post_alloc_hook mm/slab.h:439 [inline]
>     [<00000000c7bad083>] slab_alloc mm/slab.c:3326 [inline]
>     [<00000000c7bad083>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
>     [<000000009acc4151>] kmalloc include/linux/slab.h:547 [inline]
>     [<000000009acc4151>] kzalloc include/linux/slab.h:742 [inline]
>     [<000000009acc4151>] ip_mc_add1_src net/ipv4/igmp.c:1976 [inline]
>     [<000000009acc4151>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2100
>     [<000000004ac14566>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2484
>     [<0000000052d8f995>] do_ip_setsockopt.isra.0+0x1795/0x1930 net/ipv4/ip_sockglue.c:959
>     [<000000004ee1e21f>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1248
>     [<0000000066cdfe74>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2618
>     [<000000009383a786>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3126
>     [<00000000d8ac0c94>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
>     [<000000001b1e9666>] __do_sys_setsockopt net/socket.c:2083 [inline]
>     [<000000001b1e9666>] __se_sys_setsockopt net/socket.c:2080 [inline]
>     [<000000001b1e9666>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
>     [<00000000420d395e>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
>     [<000000007fd83a4b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fixes: 24803f38a5c0 ("igmp: do not remove igmp souce list info when set link down")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Reported-by: syzbot+6ca1abd0db68b5173a4f@syzkaller.appspotmail.com
> ---

Hi Eric,

Thanks for the fixup.

Cheers
Hangbin
