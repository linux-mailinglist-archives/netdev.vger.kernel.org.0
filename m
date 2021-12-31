Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C414822F5
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 10:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhLaJNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 04:13:13 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:48393 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229475AbhLaJNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 04:13:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V0Q87DI_1640941988;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V0Q87DI_1640941988)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 31 Dec 2021 17:13:09 +0800
Date:   Fri, 31 Dec 2021 17:13:08 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: Introduce TCP ULP support
Message-ID: <Yc7JpBuI718bVzW3@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211228134435.41774-1-tonylu@linux.alibaba.com>
 <97ea52de-5419-22ee-7f55-b92887dcaada@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97ea52de-5419-22ee-7f55-b92887dcaada@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 04:03:19PM +0100, Karsten Graul wrote:
> On 28/12/2021 14:44, Tony Lu wrote:
> > This implements TCP ULP for SMC, helps applications to replace TCP with
> > SMC protocol in place. And we use it to implement transparent
> > replacement.
> > 
> > This replaces original TCP sockets with SMC, reuse TCP as clcsock when
> > calling setsockopt with TCP_ULP option, and without any overhead.
> 
> This looks very interesting. Can you provide a simple userspace example about 
> how to use ULP with smc?

Here is a userspace C/S application:

	fd = socket(AF_INET, SOCK_STREAM, 0);

	addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY);      /* for server */
	addr.sin_addr.s_addr = inet_addr("127.0.0.1"); /* for client */
    addr.sin_port = htons(PORT);

	/* kernel will find and load smc module, init smc socket and replace
	 * tcp with smc, use the "clean" tcp as clcsock.
	 */
	ret = setsockopt(fd, SOL_TCP, TCP_ULP, "smc", sizeof("smc"));
	if (ret) /* if ulp init failed, TCP progress can be continued */
		printf("replace tcp with smc failed, use tcp");
	
	/* After this, this tcp socket will behave as smc socket. If error
	 * happened, this socket is still a normal tcp socket.
	 *
	 * We check tcp socket's state, so after bind(), connect() or listen(),
	 * ulp setup will be failed.
	 */
	bind(fd, (struct sockaddr *)&addr, sizeof(addr)); /* calls smc_bind() */
	connect(...); /* for client, smc_connect() */
	listen(...);  /* for server, smc_listen() */
	accept(...);  /* for server, smc_accept() */

This approach is not convenient to use, it is a possible usage in
userspace. The more important scene is to work with BPF.

Transparent replacement with BPF:
	
	BPF provides a series of attach points, like:
	- BPF_CGROUP_INET_SOCK_CREATE, /* calls in the end of inet_create() */
	- BPF_CGROUP_INET4_BIND,       /* calls in the end of inet_bind() */
	- BPF_CGROUP_INET6_BIND,

	So that we can inject BPF programs into these points in userspace:

	SEC("cgroup/connect4")
	int replace_to_smc(struct bpf_sock_addr *addr)
	{
		int pid = bpf_get_current_pid_tgid() >> 32;
		long ret;

		/* use-defined rules/filters, such as pid, tcp src/dst address, etc...*/
		if (pid != DESIRED_PID)
			return 0;

		<...>
	
		ret = bpf_setsockopt(addr, SOL_TCP, TCP_ULP, "smc", sizeof("smc"));
		if (ret) {
			bpf_printk("replace TCP with SMC error: %ld\n", ret);
			return 0;
		}
		return 0;
	}

	Then use libbpf to load it with attach type BPF_CGROUP_INET4_CONNECT.
	Everytime userspace appliations try to bind socket, it will run this
	BPF prog, check user-defined rule and determine to replace with
	SMC. Because this BPF is injected outside of user applications, so
	we can use BPF to implement flexible and non-intrusive transparent
	replacement.

	BPF helper bpf_setsockopt() limits the options to call, so TCP_ULP
	is not allowed now. I will send patches out to allow TCP_ULP option
	after this approach is merged, which is suggested by BPF's developer.
	Here is the link about BPF patch:

	https://lore.kernel.org/netdev/20211209090250.73927-1-tonylu@linux.alibaba.com/

> And how do you make sure that the in-band CLC handshake doesn't interfere with the
> previous TCP traffic, is the idea to put some kind of protocol around it so both
> sides 'know' when the protocol ended and the CLC handshake starts?

Yes, we need a "clean" TCP socket to replace with SMC. To archive it,
smc_ulp_init will check the state of TCP socket.

First, we make sure that socket is a REALLY TCP sockets.

	if (tcp->type != SOCK_STREAM || sk->sk_protocol != IPPROTO_TCP ||
		(sk->sk_family != AF_INET && sk->sk_family != AF_INET6))

Then check the state of socket, and makes sure this socket is a newly
created userspace socket, not connects to others, no data transferred
ever.

	if (tcp->state != SS_UNCONNECTED || !tcp->file || tcp->wq.fasync_list)

Consider this, we don't need to multiplex this socket, clcsock
handshaking is the first "user". This behaves likes LD_PRELOAD (smc_run),
the difference is the location to replace, user-space or kernel-space.

Setting this in an old socket (has traffic already) is more general than
current state, and we need more methods to handle this like a protocol
wrap it. I would improve this ability in the future. Currently,
transparent replace it in create and bind stage can coverage most
scenes.

Thank you.
Tony Lu
