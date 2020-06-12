Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FB01F7D6C
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 21:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgFLTOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 15:14:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:37737 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgFLTOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 15:14:40 -0400
IronPort-SDR: I1LJNZw0fq7yK45w9W1bcIv+TfJTlG0DJOD3p2sRbwAD2qoMkPKOOf3GyNX9mrjSVCyg401WTK
 YoTYQL77ac2w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2020 12:14:39 -0700
IronPort-SDR: 2ucxtBPrseF6KSxLzGLcHfslxsW93c0Y+e4f+c6qPq2bwMZ+lzClyXJFuIXTt4xfEzAOOSUafa
 ZL0ABPfh/2tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,504,1583222400"; 
   d="scan'208";a="474341619"
Received: from unknown (HELO [10.255.231.235]) ([10.255.231.235])
  by fmsmga005.fm.intel.com with ESMTP; 12 Jun 2020 12:14:39 -0700
Date:   Fri, 12 Jun 2020 12:14:38 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mjmartin-mac01.local
To:     Wei Yongjun <weiyongjun1@huawei.com>
cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.01.org
Subject: Re: [PATCH] mptcp: fix memory leak in
 mptcp_subflow_create_socket()
In-Reply-To: <20200612084938.52083-1-weiyongjun1@huawei.com>
Message-ID: <alpine.OSX.2.22.394.2006121151020.74555@mjmartin-mac01.local>
References: <20200612084938.52083-1-weiyongjun1@huawei.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Wei,

On Fri, 12 Jun 2020, Wei Yongjun wrote:

> socket malloced  by sock_create_kern() should be release before return
> in the error handling, otherwise it cause memory leak.
>
> unreferenced object 0xffff88810910c000 (size 1216):
>  comm "00000003_test_m", pid 12238, jiffies 4295050289 (age 54.237s)
>  hex dump (first 32 bytes):
>    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>    00 00 00 00 00 00 00 00 00 2f 30 0a 81 88 ff ff  ........./0.....
>  backtrace:
>    [<00000000e877f89f>] sock_alloc_inode+0x18/0x1c0
>    [<0000000093d1dd51>] alloc_inode+0x63/0x1d0
>    [<000000005673fec6>] new_inode_pseudo+0x14/0xe0
>    [<00000000b5db6be8>] sock_alloc+0x3c/0x260
>    [<00000000e7e3cbb2>] __sock_create+0x89/0x620
>    [<0000000023e48593>] mptcp_subflow_create_socket+0xc0/0x5e0
>    [<00000000419795e4>] __mptcp_socket_create+0x1ad/0x3f0
>    [<00000000b2f942e8>] mptcp_stream_connect+0x281/0x4f0
>    [<00000000c80cd5cc>] __sys_connect_file+0x14d/0x190
>    [<00000000dc761f11>] __sys_connect+0x128/0x160
>    [<000000008b14e764>] __x64_sys_connect+0x6f/0xb0
>    [<000000007b4f93bd>] do_syscall_64+0xa1/0x530
>    [<00000000d3e770b6>] entry_SYSCALL_64_after_hwframe+0x49/0xb3
>
> Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index bf132575040d..bbdb74b8bc3c 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -1053,8 +1053,10 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
> 	err = tcp_set_ulp(sf->sk, "mptcp");
> 	release_sock(sf->sk);
>
> -	if (err)
> +	if (err) {
> +		sock_release(sf);
> 		return err;
> +	}
>
> 	/* the newly created socket really belongs to the owning MPTCP master
> 	 * socket, even if for additional subflows the allocation is performed
> -- 
> 2.25.1

Thanks for catching this leak. Be sure to specify which git tree this 
should be applied to in the subject line, I'm assuming in this case you'd 
want [PATCH net].

--
Mat Martineau
Intel
