Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7908A41AF69
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240793AbhI1Mwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:52:42 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:40560 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240721AbhI1Mwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 08:52:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1632833462; x=1664369462;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6EteUsOCbGfpbmeenPLiWohHZbH3XZ6q38xd0Kt6rwM=;
  b=hqWeO8GlBCuPcTswFv4gZRfwEtmrRDsUgdH54TJJbrPIaBeMnp6zbdKp
   iTgjB58tg5BiK5VbfesCmo0m/JuiccpMXV4Dwf9XXiIq46/Yow690Kgr+
   b+4ba75Nid6VmiZ77Qi63nrYsoyEVyAZNznGx5LCU1hO2mWeyR81HfXJq
   U=;
X-IronPort-AV: E=Sophos;i="5.85,329,1624320000"; 
   d="scan'208";a="960924016"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-1box-2b-eee1d651.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 28 Sep 2021 12:51:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2b-eee1d651.us-west-2.amazon.com (Postfix) with ESMTPS id 7732D84063;
        Tue, 28 Sep 2021 12:51:01 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 28 Sep 2021 12:51:00 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.107) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 28 Sep 2021 12:50:51 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <wanghai38@huawei.com>
CC:     <Rao.Shoaib@oracle.com>, <anna.schumaker@netapp.com>,
        <ast@kernel.org>, <bfields@fieldses.org>,
        <christian.brauner@ubuntu.com>, <chuck.lever@oracle.com>,
        <cong.wang@bytedance.com>, <davem@davemloft.net>,
        <dsahern@gmail.com>, <edumazet@google.com>,
        <jakub.kicinski@netronome.com>, <jiang.wang@bytedance.com>,
        <jlayton@kernel.org>, <kolga@netapp.com>, <kuba@kernel.org>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <linux-nfs@vger.kernel.org>, <neilb@suse.com>,
        <netdev@vger.kernel.org>, <nicolas.dichtel@6wind.com>,
        <timo@rothenpieler.org>, <tom@talpey.com>,
        <trond.myklebust@hammerspace.com>, <tyhicks@canonical.com>,
        <viro@zeniv.linux.org.uk>, <wenbin.zeng@gmail.com>,
        <willy@infradead.org>
Subject: Re: [PATCH net 1/2] net: Modify unix_stream_connect to not reference count the netns of kernel sockets
Date:   Tue, 28 Sep 2021 21:50:47 +0900
Message-ID: <20210928125047.40359-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928031440.2222303-2-wanghai38@huawei.com>
References: <20210928031440.2222303-2-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.107]
X-ClientProxiedBy: EX13D06UWA002.ant.amazon.com (10.43.160.143) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Wang Hai <wanghai38@huawei.com>
Date:   Tue, 28 Sep 2021 11:14:39 +0800
> When use-gss-proxy is set to 1, write_gssp() creates a rpc client in
> gssp_rpc_create(), this increases netns refcount by 2, these refcounts
> are supposed to be released in rpcsec_gss_exit_net(), but it will never
> happen because rpcsec_gss_exit_net() is triggered only when netns
> refcount gets to 0, specifically:
>     refcount=0 -> cleanup_net() -> ops_exit_list -> rpcsec_gss_exit_net
> It is a deadlock situation here, refcount will never get to 0 unless
> rpcsec_gss_exit_net() is called. So, in this case, the netns refcount
> should not be increased.
> 
> In this case, kernel_connect()->unix_stream_connect() will take a netns
> refcount. According to commit 26abe14379f8 ("net: Modify sk_alloc to not
> reference count the netns of kernel sockets."), kernel sockets should not
> take the netns refcount, so unix_stream_connect() should not take
> the netns refcount when the sock is a kernel socket either.
> 
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/unix/af_unix.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 92345c9bb60c..af6ba67779c8 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1317,7 +1317,8 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
>  	err = -ENOMEM;
>  
>  	/* create new sock for complete connection */
> -	newsk = unix_create1(sock_net(sk), NULL, 0, sock->type);
> +	newsk = unix_create1(sock_net(sk), NULL,
> +			     !sk->sk_net_refcnt, sock->type);

This patch conflicts with the commit f4bd73b5a950 for now.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=f4bd73b5a950

Could you please rebase and resend the patch set?


>  	if (newsk == NULL)
>  		goto out;
>  
> -- 
> 2.17.1
