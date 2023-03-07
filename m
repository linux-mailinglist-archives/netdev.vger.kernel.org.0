Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5956AFA01
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 00:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbjCGXDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 18:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCGXCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 18:02:43 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723157A91E
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 15:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678230068; x=1709766068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q0ZaZyxtNZdQdDNv9vKi6OV/UKGncGpZ+n1uGgM4zhQ=;
  b=pSSMrLA7DH5iisN7rXIkcAstRFMeGlx5SLWA0QlnQHzxjRFN3f0e+2ii
   cQr8yIdopOP3iMBWcEsXhGIrUAomWMvqT45XJlZRjGw/kle4CiVpFqO9/
   V8zvothu43DpQjxBHgNNj8URfMdhI8oR67M+PYKhU0Rljs2T3f7Bqabci
   g=;
X-IronPort-AV: E=Sophos;i="5.98,242,1673913600"; 
   d="scan'208";a="190780708"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 23:01:06 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com (Postfix) with ESMTPS id 740AF60D97;
        Tue,  7 Mar 2023 23:01:05 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Mar 2023 23:01:04 +0000
Received: from 88665a182662.ant.amazon.com (10.135.222.163) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Tue, 7 Mar 2023 23:01:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <rao.shoaib@oracle.com>,
        <syzbot+7699d9e5635c10253a27@syzkaller.appspotmail.com>
Subject: Re: [PATCH net] af_unix: fix struct pid leaks in OOB support
Date:   Tue, 7 Mar 2023 15:00:52 -0800
Message-ID: <20230307230052.96807-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230307164530.771896-1-edumazet@google.com>
References: <20230307164530.771896-1-edumazet@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.135.222.163]
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue,  7 Mar 2023 16:45:30 +0000
> syzbot reported struct pid leak [1].
> 
> Issue is that queue_oob() calls maybe_add_creds() which potentially
> holds a reference on a pid.
> 
> But skb->destructor is not set (either directly or by calling
> unix_scm_to_skb())
> 
> This means that subsequent kfree_skb() or consume_skb() would leak
> this reference.
> 
> In this fix, I chose to fully support scm even for the OOB message.
> 
> [1]
> BUG: memory leak
> unreferenced object 0xffff8881053e7f80 (size 128):
> comm "syz-executor242", pid 5066, jiffies 4294946079 (age 13.220s)
> hex dump (first 32 bytes):
> 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> backtrace:
> [<ffffffff812ae26a>] alloc_pid+0x6a/0x560 kernel/pid.c:180
> [<ffffffff812718df>] copy_process+0x169f/0x26c0 kernel/fork.c:2285
> [<ffffffff81272b37>] kernel_clone+0xf7/0x610 kernel/fork.c:2684
> [<ffffffff812730cc>] __do_sys_clone+0x7c/0xb0 kernel/fork.c:2825
> [<ffffffff849ad699>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> [<ffffffff849ad699>] do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> [<ffffffff84a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
> Reported-by: syzbot+7699d9e5635c10253a27@syzkaller.appspotmail.com
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks!


> Cc: Rao Shoaib <rao.shoaib@oracle.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/unix/af_unix.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 347122c3575eaae597405369e2e9d8324d6ad240..0b0f18ecce4470d6fd21c084a3ea49e04dcbb9bd 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2105,7 +2105,8 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>  #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
>  
>  #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
> -static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
> +static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other,
> +		     struct scm_cookie *scm, bool fds_sent)
>  {
>  	struct unix_sock *ousk = unix_sk(other);
>  	struct sk_buff *skb;
> @@ -2116,6 +2117,11 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
>  	if (!skb)
>  		return err;
>  
> +	err = unix_scm_to_skb(scm, skb, !fds_sent);
> +	if (err < 0) {
> +		kfree_skb(skb);
> +		return err;
> +	}
>  	skb_put(skb, 1);
>  	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
>  
> @@ -2243,7 +2249,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  
>  #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
>  	if (msg->msg_flags & MSG_OOB) {
> -		err = queue_oob(sock, msg, other);
> +		err = queue_oob(sock, msg, other, &scm, fds_sent);
>  		if (err)
>  			goto out_err;
>  		sent++;
> -- 
> 2.40.0.rc0.216.gc4246ad0f0-goog
