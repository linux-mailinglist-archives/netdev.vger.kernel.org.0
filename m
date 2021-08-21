Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726C03F3CBD
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 01:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhHUXZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 19:25:00 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:49327 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhHUXY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 19:24:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1629588257; x=1661124257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lBHSnulRC9B4JbrRzUQUZvXAAgq+SXBRzTXzXMvAd24=;
  b=p6p0Sef6pExy9ZhGcnlfy8UmwhnPMAqQi0f6BCEDCuIVXkxdp/382coR
   jpIpVDIMAE/dHQG5L0yFJz+Asj8O7gpPmJ9ndeuTnCYMq+IkTLJ7cQkoH
   WQkj9k1EPmcmqdUCGct5DcqJTEsLTWgX05fah9bEX/W5SwXuMCq3T9XBT
   s=;
X-IronPort-AV: E=Sophos;i="5.84,341,1620691200"; 
   d="scan'208";a="20945902"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 21 Aug 2021 23:24:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id C5F0D1A065F;
        Sat, 21 Aug 2021 23:24:16 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 21 Aug 2021 23:24:15 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.137) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 21 Aug 2021 23:24:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <jiang.wang@bytedance.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <chaiwen.cc@bytedance.com>, <christian.brauner@ubuntu.com>,
        <cong.wang@bytedance.com>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <digetx@gmail.com>,
        <duanxiongchun@bytedance.com>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <kpsingh@kernel.org>, <kuba@kernel.org>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <rao.shoaib@oracle.com>,
        <songliubraving@fb.com>, <viro@zeniv.linux.org.uk>,
        <xieyongji@bytedance.com>, <yhs@fb.com>
Subject: [PATCH bpf-next v2] af_unix: fix NULL pointer bug in unix_shutdown
Date:   Sun, 22 Aug 2021 08:23:25 +0900
Message-ID: <20210821232325.29727-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210821180738.1151155-1-jiang.wang@bytedance.com>
References: <20210821180738.1151155-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D24UWA003.ant.amazon.com (10.43.160.195) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jiang Wang <jiang.wang@bytedance.com>
Date:   Sat, 21 Aug 2021 18:07:36 +0000
> Commit 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap") 
> introduced a bug for af_unix SEQPACKET type. In unix_shutdown, the
> unhash function will call prot->unhash(), which is NULL for SEQPACKET.
> And kernel will panic. On ARM32, it will show following messages: (it 
> likely affects x86 too).
> 
> Fix the bug by checking the prot->unhash is NULL or not first.
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
Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

LGTM, thank you.


> ---
> v1 -> v2: check prot->unhash directly.
> 
>  net/unix/af_unix.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 443c49081636..15c1e4e4012d 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2847,7 +2847,8 @@ static int unix_shutdown(struct socket *sock, int mode)
>  		int peer_mode = 0;
>  		const struct proto *prot = READ_ONCE(other->sk_prot);
>  
> -		prot->unhash(other);
> +		if (prot->unhash)
> +			prot->unhash(other);
>  		if (mode&RCV_SHUTDOWN)
>  			peer_mode |= SEND_SHUTDOWN;
>  		if (mode&SEND_SHUTDOWN)
> -- 
> 2.20.1
