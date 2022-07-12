Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06F05717D2
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiGLLA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiGLLA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:00:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8FC7AE57F
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657623654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hBE7zQEjvdn3qPyggSpJx5iq7ng7SN8wbfn9xtyZRvg=;
        b=hxqu56Ph3dVVpQafOfKJDmvinN6eBiEseQmW2GJl7tI39ifYGCnwPVaHyHohpWmqoUr3ug
        Ba2iQfmG1AfxMahl3kA7mlXoylM/VdkZUa0/G8gws7kG9t324HFjEci8182H8196/lJqmn
        gsc/TdHy6B+66GkhFOvyL6hGhc7Idm8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-pDxqFPjVNaGLT-FQIp28Ww-1; Tue, 12 Jul 2022 07:00:53 -0400
X-MC-Unique: pDxqFPjVNaGLT-FQIp28Ww-1
Received: by mail-wr1-f69.google.com with SMTP id k26-20020adfb35a000000b0021d6c3b9363so1292626wrd.1
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hBE7zQEjvdn3qPyggSpJx5iq7ng7SN8wbfn9xtyZRvg=;
        b=6mKKAQJkQvlaQlgK7KG0e93ceyqzvhB8Zu7HArV5nxeJOoZMhF2nXqG+exljrA75Fc
         nMoJIgK17Sz3NascurqTq4zHptllHlbEo5FwN8gVFouK7SLGo8YRm5wwbF3wsrPD0Cah
         gvmgHMqC1Li39F/HYzo/ig40bsOwGeckHYKTTzzee6IcEQkzzXxTIoLv+q1VxtF4WNwF
         SOSuRfSAT/D51lSqTFUJnXqludQ1M+qhxksbrIyceQioJ0tuV1JAP2o8pcQXKik2SkoL
         /0oHI3glHQzjfLFFbTraZRMI5n6aZXlgvBgMtW1w5alRCq/kFSf80HOSkVp7yjT/O6+f
         mAEg==
X-Gm-Message-State: AJIora9+XCKaDNmKLdcxoWbSF4mpQvsN1M8zq4B0AtK3Mml30bdrZCdN
        AXxqA1RgYjtu+vZlGklGuqYCXvB1mdkR7UNPzek10cgSsgmZO7gaJu+Uu5KIXLG52woWz8Ln26V
        JINYWvxubfDOz9oqt
X-Received: by 2002:a05:6000:14b:b0:21d:6bcd:2cd4 with SMTP id r11-20020a056000014b00b0021d6bcd2cd4mr20882725wrx.262.1657623652351;
        Tue, 12 Jul 2022 04:00:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v9CwRSejlK7pmk/Ru8P1RDJpeBig2EnQHB3YhgAGd3Ote2X4pQGq5k5Hn1r/ke6rbjzD+Mbw==
X-Received: by 2002:a05:6000:14b:b0:21d:6bcd:2cd4 with SMTP id r11-20020a056000014b00b0021d6bcd2cd4mr20882695wrx.262.1657623652034;
        Tue, 12 Jul 2022 04:00:52 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id g10-20020a5d46ca000000b0021badf3cb26sm9591640wrs.63.2022.07.12.04.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:00:51 -0700 (PDT)
Message-ID: <daa2b799956c286b2cce898bee22fb2a043f5177.camel@redhat.com>
Subject: Re: [PATCH net v6] net: rose: fix null-ptr-deref caused by
 rose_kill_by_neigh
From:   Paolo Abeni <pabeni@redhat.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-hams@vger.kernel.org
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 13:00:49 +0200
In-Reply-To: <20220711013111.33183-1-duoming@zju.edu.cn>
References: <20220711013111.33183-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-07-11 at 09:31 +0800, Duoming Zhou wrote:
> When the link layer connection is broken, the rose->neighbour is
> set to null. But rose->neighbour could be used by rose_connection()
> and rose_release() later, because there is no synchronization among
> them. As a result, the null-ptr-deref bugs will happen.
> 
> One of the null-ptr-deref bugs is shown below:
> 
>     (thread 1)                  |        (thread 2)
>                                 |  rose_connect
> rose_kill_by_neigh              |    lock_sock(sk)
>   spin_lock_bh(&rose_list_lock) |    if (!rose->neighbour)
>   rose->neighbour = NULL;//(1)  |
>                                 |    rose->neighbour->use++;//(2)
> 
> The rose->neighbour is set to null in position (1) and dereferenced
> in position (2).
> 
> The KASAN report triggered by POC is shown below:
> 
> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> ...
> RIP: 0010:rose_connect+0x6c2/0xf30
> RSP: 0018:ffff88800ab47d60 EFLAGS: 00000206
> RAX: 0000000000000005 RBX: 000000000000002a RCX: 0000000000000000
> RDX: ffff88800ab38000 RSI: ffff88800ab47e48 RDI: ffff88800ab38309
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffed1001567062
> R10: dfffe91001567063 R11: 1ffff11001567061 R12: 1ffff11000d17cd0
> R13: ffff8880068be680 R14: 0000000000000002 R15: 1ffff11000d17cd0
> ...
> Call Trace:
>   <TASK>
>   ? __local_bh_enable_ip+0x54/0x80
>   ? selinux_netlbl_socket_connect+0x26/0x30
>   ? rose_bind+0x5b0/0x5b0
>   __sys_connect+0x216/0x280
>   __x64_sys_connect+0x71/0x80
>   do_syscall_64+0x43/0x90
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> This patch adds lock_sock() in rose_kill_by_neigh() in order to
> synchronize with rose_connect() and rose_release(). Then, changing
> type of 'neighbour->use' from unsigned short to atomic_t in order to
> mitigate race conditions caused by holding different socket lock while
> updating 'neighbour->use'.
> 
> Meanwhile, this patch adds sock_hold() protected by rose_list_lock
> that could synchronize with rose_remove_socket() in order to mitigate
> UAF bug caused by lock_sock() we add.
> 
> What's more, there is no need using rose_neigh_list_lock to protect
> rose_kill_by_neigh(). Because we have already used rose_neigh_list_lock
> to protect the state change of rose_neigh in rose_link_failed(), which
> is well synchronized.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v6:
>   - Change sk_for_each() to sk_for_each_safe().
>   - Change type of 'neighbour->use' from unsigned short to atomic_t.
> 
>  include/net/rose.h    |  2 +-
>  net/rose/af_rose.c    | 19 +++++++++++++------
>  net/rose/rose_in.c    | 12 ++++++------
>  net/rose/rose_route.c | 24 ++++++++++++------------
>  net/rose/rose_timer.c |  2 +-
>  5 files changed, 33 insertions(+), 26 deletions(-)
> 
> diff --git a/include/net/rose.h b/include/net/rose.h
> index 0f0a4ce0fee..d5ddebc556d 100644
> --- a/include/net/rose.h
> +++ b/include/net/rose.h
> @@ -95,7 +95,7 @@ struct rose_neigh {
>  	ax25_cb			*ax25;
>  	struct net_device		*dev;
>  	unsigned short		count;
> -	unsigned short		use;
> +	atomic_t		use;
>  	unsigned int		number;
>  	char			restarted;
>  	char			dce_mode;
> diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
> index bf2d986a6bc..54e7b76c4f3 100644
> --- a/net/rose/af_rose.c
> +++ b/net/rose/af_rose.c
> @@ -163,16 +163,23 @@ static void rose_remove_socket(struct sock *sk)
>  void rose_kill_by_neigh(struct rose_neigh *neigh)
>  {
>  	struct sock *s;
> +	struct hlist_node *tmp;
>  
>  	spin_lock_bh(&rose_list_lock);
> -	sk_for_each(s, &rose_list) {
> +	sk_for_each_safe(s, tmp, &rose_list) {
>  		struct rose_sock *rose = rose_sk(s);
>  
> +		sock_hold(s);
> +		spin_unlock_bh(&rose_list_lock);
> +		lock_sock(s);
>  		if (rose->neighbour == neigh) {
>  			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
> -			rose->neighbour->use--;
> +			atomic_dec(&rose->neighbour->use);
>  			rose->neighbour = NULL;
>  		}
> +		release_sock(s);
> +		sock_put(s);

I'm sorry, this does not work. At this point both 's' and 'tmp' sockets
can be freed and reused. Both iterators are not valid anymore when you
acquire the 'rose_list_lock' later.

I really think you should resort to something similar to the following
(completelly untested, just to give an idea). In any case it would be
better to split this change in 2 separate patches: the first patch
replaces 'int use;' with an antomic_t and the 2nd one addresses the
race you describe above.

---
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index bf2d986a6bc3..27b1027aaedf 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -156,25 +156,45 @@ static void rose_remove_socket(struct sock *sk)
 	spin_unlock_bh(&rose_list_lock);
 }
 
+static DEFINE_MUTEX(kill_lock);
+
 /*
  *	Kill all bound sockets on a broken link layer connection to a
  *	particular neighbour.
  */
 void rose_kill_by_neigh(struct rose_neigh *neigh)
 {
-	struct sock *s;
+	HLIST_HEAD(rose_list_copy);
+	struct sock *s, *tmp;
+
+	mutex_lock(&kill_lock);
 
 	spin_lock_bh(&rose_list_lock);
 	sk_for_each(s, &rose_list) {
+		sock_hold(s);
+		/* sk_bind_node is apparently unused by rose. Alternatively
+		 * you can add another hlist_node to rose_sock and use it here
+		 */
+		sk_add_bind_node(s, &rose_list_copy);
+	}
+	spin_unlock_bh(&rose_list_lock);
+
+	hlist_for_each_entry_safe(s, tmp, &rose_list_copy, sk_bind_node) {
 		struct rose_sock *rose = rose_sk(s);
 
+		__sk_del_bind_node(s);
+		lock_sock(s);
 		if (rose->neighbour == neigh) {
 			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
-			rose->neighbour->use--;
+			atomic_dec(&rose->neighbour->use);
 			rose->neighbour = NULL;
 		}
+		release_sock(s);
+
+		sock_put(s);
 	}
-	spin_unlock_bh(&rose_list_lock);
+
+	mutex_unlock(&kill_lock);
 }
 
 /*
---
/P

