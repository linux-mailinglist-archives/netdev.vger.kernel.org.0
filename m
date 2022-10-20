Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E04606329
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJTOd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiJTOdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:33:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6B832A85
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 07:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666276426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+x8rK65W1ez4jAcOPHngQTQQopdMXuxkGBnKu6LB1us=;
        b=Qtzm49yiJbnvJD0XgvKWk/5UdmhgmzPUsqFtcta6dHMQsgY/4gUKKp2MFd4Uk1Gi4ZC3EE
        j1c4yRsft5UKpfDejQ3aeBRYMgQT1LfRmhfG1QGK1JSScKhMddmmH+tOXWvdAOZ3v3lbLO
        za8xkHtnorN5eckgeCif9nk7djG7oAU=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-222-n-Rf2yuNMmOj8HtR0e8g-Q-1; Thu, 20 Oct 2022 10:33:43 -0400
X-MC-Unique: n-Rf2yuNMmOj8HtR0e8g-Q-1
Received: by mail-qk1-f199.google.com with SMTP id i11-20020a05620a404b00b006eeb0791c1aso17595748qko.10
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 07:33:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+x8rK65W1ez4jAcOPHngQTQQopdMXuxkGBnKu6LB1us=;
        b=5HYn1oYSte6ObD05BJ6z5+85P6lUMUUixYBsjE9acT3vp5lm923xQhMPAam2oBHN7H
         kQdM1AOGcIwJ5wj27izBwg5trOcYks2hnxriZffcMgO27f8yNNiOe9Lb+/oV7MI4UOQw
         Sis1EvagyUeVpN8k6BqoZO+hDLp5v1HLVs00N0kqk6QO54gSVNOlJfRgFSxVON6GexmD
         nFcjjUelzCz+31DdVyy4dy2DQS5URbRStd7E/pSjkH5yOcbtACbia8gKNEdmThHbxWQs
         0M7eF7Q9vrJYB/YzdF2uGPcJ+AStZ4TamRBrvs2w1nYRQmIhHKgvrhKI7jMycvmq9Qlu
         wOBg==
X-Gm-Message-State: ACrzQf15mm8R8fWybkzjU2j6MDsMQyRzBCgjCdrK3cT4OagMkB2n/c5T
        V8JzVFEx92JPQ5bcmW7FZNopnTZHdQjJBYpPL4bByAppj9AjodowbHaZodTRvbi4wRhgTQju13n
        G51BKQRPAaRPMJi76
X-Received: by 2002:a05:620a:4626:b0:6ee:b43:d2bc with SMTP id br38-20020a05620a462600b006ee0b43d2bcmr9156484qkb.764.1666276422958;
        Thu, 20 Oct 2022 07:33:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7rnl1MY4IaRNWroVHz/zCKchyC83sUPnsr+F4F+ILebXHtwc8G6pxBk+mbkkLPjonF/IHz3Q==
X-Received: by 2002:a05:620a:4626:b0:6ee:b43:d2bc with SMTP id br38-20020a05620a462600b006ee0b43d2bcmr9156456qkb.764.1666276422676;
        Thu, 20 Oct 2022 07:33:42 -0700 (PDT)
Received: from [10.0.0.96] ([24.225.241.171])
        by smtp.gmail.com with ESMTPSA id bw15-20020a05622a098f00b0035d08c1da35sm6211061qtb.45.2022.10.20.07.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 07:33:41 -0700 (PDT)
Message-ID: <9c71f2f1-b3d0-cc82-3d62-afd72a92d94d@redhat.com>
Date:   Thu, 20 Oct 2022 10:33:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] tipc: fix a null-ptr-deref in tipc_topsrv_accept
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
References: <4eee264380c409c61c6451af1059b7fb271a7e7b.1666120790.git.lucien.xin@gmail.com>
From:   Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <4eee264380c409c61c6451af1059b7fb271a7e7b.1666120790.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/18/22 15:19, Xin Long wrote:
> syzbot found a crash in tipc_topsrv_accept:
>
>    KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>    Workqueue: tipc_rcv tipc_topsrv_accept
>    RIP: 0010:kernel_accept+0x22d/0x350 net/socket.c:3487
>    Call Trace:
>     <TASK>
>     tipc_topsrv_accept+0x197/0x280 net/tipc/topsrv.c:460
>     process_one_work+0x991/0x1610 kernel/workqueue.c:2289
>     worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>     kthread+0x2e4/0x3a0 kernel/kthread.c:376
>     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>
> It was caused by srv->listener that might be set to null by
> tipc_topsrv_stop() in net .exit whereas it's still used in
> tipc_topsrv_accept() worker.
>
> srv->listener is protected by srv->idr_lock in tipc_topsrv_stop(), so add
> a check for srv->listener under srv->idr_lock in tipc_topsrv_accept() to
> avoid the null-ptr-deref. To ensure the lsock is not released during the
> tipc_topsrv_accept(), move sock_release() after tipc_topsrv_work_stop()
> where it's waiting until the tipc_topsrv_accept worker to be done.
>
> Note that sk_callback_lock is used to protect sk->sk_user_data instead of
> srv->listener, and it should check srv in tipc_topsrv_listener_data_ready()
> instead. This also ensures that no more tipc_topsrv_accept worker will be
> started after tipc_conn_close() is called in tipc_topsrv_stop() where it
> sets sk->sk_user_data to null.
>
> Fixes: 0ef897be12b8 ("tipc: separate topology server listener socket from subcsriber sockets")
> Reported-by: syzbot+c5ce866a8d30f4be0651@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>   net/tipc/topsrv.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
> index 14fd05fd6107..d92ec92f0b71 100644
> --- a/net/tipc/topsrv.c
> +++ b/net/tipc/topsrv.c
> @@ -450,12 +450,19 @@ static void tipc_conn_data_ready(struct sock *sk)
>   static void tipc_topsrv_accept(struct work_struct *work)
>   {
>   	struct tipc_topsrv *srv = container_of(work, struct tipc_topsrv, awork);
> -	struct socket *lsock = srv->listener;
> -	struct socket *newsock;
> +	struct socket *newsock, *lsock;
>   	struct tipc_conn *con;
>   	struct sock *newsk;
>   	int ret;
>   
> +	spin_lock_bh(&srv->idr_lock);
> +	if (!srv->listener) {
> +		spin_unlock_bh(&srv->idr_lock);
> +		return;
> +	}
> +	lsock = srv->listener;
> +	spin_unlock_bh(&srv->idr_lock);
> +
>   	while (1) {
>   		ret = kernel_accept(lsock, &newsock, O_NONBLOCK);
>   		if (ret < 0)
> @@ -489,7 +496,7 @@ static void tipc_topsrv_listener_data_ready(struct sock *sk)
>   
>   	read_lock_bh(&sk->sk_callback_lock);
>   	srv = sk->sk_user_data;
> -	if (srv->listener)
> +	if (srv)
>   		queue_work(srv->rcv_wq, &srv->awork);
>   	read_unlock_bh(&sk->sk_callback_lock);
>   }
> @@ -699,8 +706,9 @@ static void tipc_topsrv_stop(struct net *net)
>   	__module_get(lsock->sk->sk_prot_creator->owner);
>   	srv->listener = NULL;
>   	spin_unlock_bh(&srv->idr_lock);
> -	sock_release(lsock);
> +
>   	tipc_topsrv_work_stop(srv);
> +	sock_release(lsock);
>   	idr_destroy(&srv->conn_idr);
>   	kfree(srv);
>   }
Acked-by: Jon Maloy <jmaloy@redhat.com>

