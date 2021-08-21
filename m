Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774923F38D0
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 07:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhHUFU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 01:20:57 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:46156 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhHUFU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 01:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1629523218; x=1661059218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hRjIA2N7XqbYT9/bYzG7LF9KmVpB8TKkOtmPXU0WOg8=;
  b=p7hKn6+vME6R58Vpi6gvRJdFXt88a0GhmCTZ/aLKoaa5vqgIbUq2nOy2
   h8xvb7aHqNxzUTKKFboVGADZJYz1kCMB8/INiAQk+NzIa+3rUmt4AMzxu
   n6cd3H6wnFLQSeYiyJXd/mCKdo4TkWi/nb5VA0t4nahpspP81hd/WrDRj
   g=;
X-IronPort-AV: E=Sophos;i="5.84,338,1620691200"; 
   d="scan'208";a="20872219"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-25e59222.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 21 Aug 2021 05:20:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-25e59222.us-east-1.amazon.com (Postfix) with ESMTPS id 20D13A2437;
        Sat, 21 Aug 2021 05:20:11 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 21 Aug 2021 05:20:11 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.229) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 21 Aug 2021 05:20:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <jiang.wang@bytedance.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <chaiwen.cc@bytedance.com>,
        <christian.brauner@ubuntu.com>, <cong.wang@bytedance.com>,
        <davem@davemloft.net>, <digetx@gmail.com>,
        <duanxiongchun@bytedance.com>, <kuba@kernel.org>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <rao.shoaib@oracle.com>,
        <viro@zeniv.linux.org.uk>, <xieyongji@bytedance.com>,
        <bpf@vger.kernel.org>
Subject: [PATCH v1] af_unix: fix NULL pointer bug in unix_shutdown
Date:   Sat, 21 Aug 2021 14:20:02 +0900
Message-ID: <20210821052002.37230-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210821035045.373991-1-jiang.wang@bytedance.com>
References: <20210821035045.373991-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.229]
X-ClientProxiedBy: EX13D29UWA004.ant.amazon.com (10.43.160.33) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jiang Wang <jiang.wang@bytedance.com>
Date:   Sat, 21 Aug 2021 03:50:44 +0000
> Commit 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap") 
> introduced a bug for af_unix SEQPACKET type. In unix_shutdown, the 
> unhash function will call prot->unhash(), which is NULL for SEQPACKET. 
> And kernel will panic. On ARM32, it will show following messages: (it 
> likely affects x86 too).
> 
> Fix the bug by checking the sk->type first.
> 
> Kernel log:
> <--- cut here ---
>  Unable to handle kernel NULL pointer dereference at virtual address
> 00000000
>  pgd = 2fba1ffb
>  *pgd=00000000
>  Internal error: Oops: 80000005 [#1] PREEMPT SMP THUMB2
>  Modules linked in:
>  CPU: 1 PID: 1999 Comm: falkon Tainted: G        W
> 5.14.0-rc5-01175-g94531cfcbe79-dirty #9240
>  Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
>  PC is at 0x0
>  LR is at unix_shutdown+0x81/0x1a8
>  pc : [<00000000>]    lr : [<c08f3311>]    psr: 600f0013
>  sp : e45aff70  ip : e463a3c0  fp : beb54f04
>  r10: 00000125  r9 : e45ae000  r8 : c4a56664
>  r7 : 00000001  r6 : c4a56464  r5 : 00000001  r4 : c4a56400
>  r3 : 00000000  r2 : c5a6b180  r1 : 00000000  r0 : c4a56400
>  Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
>  Control: 50c5387d  Table: 05aa804a  DAC: 00000051
>  Register r0 information: slab PING start c4a56400 pointer offset 0
>  Register r1 information: NULL pointer
>  Register r2 information: slab task_struct start c5a6b180 pointer offset 0
>  Register r3 information: NULL pointer
>  Register r4 information: slab PING start c4a56400 pointer offset 0
>  Register r5 information: non-paged memory
>  Register r6 information: slab PING start c4a56400 pointer offset 100
>  Register r7 information: non-paged memory
>  Register r8 information: slab PING start c4a56400 pointer offset 612
>  Register r9 information: non-slab/vmalloc memory
>  Register r10 information: non-paged memory
>  Register r11 information: non-paged memory
>  Register r12 information: slab filp start e463a3c0 pointer offset 0
>  Process falkon (pid: 1999, stack limit = 0x9ec48895)
>  Stack: (0xe45aff70 to 0xe45b0000)
>  ff60:                                     e45ae000 c5f26a00 00000000 00000125
>  ff80: c0100264 c07f7fa3 beb54f04 fffffff7 00000001 e6f3fc0e b5e5e9ec beb54ec4
>  ffa0: b5da0ccc c010024b b5e5e9ec beb54ec4 0000000f 00000000 00000000 beb54ebc
>  ffc0: b5e5e9ec beb54ec4 b5da0ccc 00000125 beb54f58 00785238 beb5529c beb54f04
>  ffe0: b5da1e24 beb54eac b301385c b62b6ee8 600f0030 0000000f 00000000 00000000
>  [<c08f3311>] (unix_shutdown) from [<c07f7fa3>] (__sys_shutdown+0x2f/0x50)
>  [<c07f7fa3>] (__sys_shutdown) from [<c010024b>]
> (__sys_trace_return+0x1/0x16)
>  Exception stack(0xe45affa8 to 0xe45afff0)
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> Reported-by: Dmitry Osipenko <digetx@gmail.com>
> Tested-by: Dmitry Osipenko <digetx@gmail.com>

Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")

And the commit is not in net-next yet, so is this patch for bpf-next?


> ---
>  net/unix/af_unix.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 443c49081636..6965bc578a80 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2847,7 +2847,8 @@ static int unix_shutdown(struct socket *sock, int mode)
>  		int peer_mode = 0;
>  		const struct proto *prot = READ_ONCE(other->sk_prot);
>  
> -		prot->unhash(other);
> +		if (sk->sk_type == SOCK_STREAM)

		if (prot->unhash)
is more straight?


> +			prot->unhash(other);
>  		if (mode&RCV_SHUTDOWN)
>  			peer_mode |= SEND_SHUTDOWN;
>  		if (mode&SEND_SHUTDOWN)
> -- 
> 2.20.1
