Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF7C6C7E53
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 13:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbjCXM56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 08:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjCXM55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 08:57:57 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933091E5DE;
        Fri, 24 Mar 2023 05:57:55 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id E09CA5FD72;
        Fri, 24 Mar 2023 15:57:52 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679662672;
        bh=TYAU8R6v5hMibdRbWUhIb7/NXDFhS4JxFF4SG4AWgoM=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=k0IU/icPvaHmJZilzJVvsdIu2VJ8MIGXfsbfsxAHGrlG+yOSETJmXRLd65i/WA9mQ
         /yczMu+peeDKpxk37VsivgItxQ6wl2VTCO3FTZoOps5rEVi4oDlLuKMgCcsB+LN+T4
         CXUHgzo7kEGTkG8pYTrpaMvlhykLUS3DtRqtyU11g+0s0usbe5fzSuVb8WTBwpbjin
         CQbJ8q/plYY2br0H+QcGNqvWMMWP0QsOjoI1aiXKV7UaeGM0HjHfpHTBa09ZhEkHiP
         v/+ZEQ4c36oHFaFpKsJpAMFiKsX26Q4aVEN8S+Us2y/u+3GQ6HSzJWfz4j/3IfjLru
         CcLd6Wa3PL5lw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 24 Mar 2023 15:57:46 +0300 (MSK)
Message-ID: <94b58c20-9111-8ada-79fd-eced6a1ba2cc@sberdevices.ru>
Date:   Fri, 24 Mar 2023 15:54:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] vsock/loopback: use only sk_buff_head.lock to protect
 the packet queue
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>, <netdev@vger.kernel.org>
CC:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        <linux-kernel@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>
References: <20230324115450.11268-1-sgarzare@redhat.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230324115450.11268-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/24 06:52:00 #21002836
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.03.2023 14:54, Stefano Garzarella wrote:
> pkt_list_lock was used before commit 71dc9ec9ac7d ("virtio/vsock:
> replace virtio_vsock_pkt with sk_buff") to protect the packet queue.
> After that commit we switched to sk_buff and we are using
> sk_buff_head.lock in almost every place to protect the packet queue
> except in vsock_loopback_work() when we call skb_queue_splice_init().
> 
> As reported by syzbot, this caused unlocked concurrent access to the
> packet queue between vsock_loopback_work() and
> vsock_loopback_cancel_pkt() since it is not holding pkt_list_lock.
> 
> With the introduction of sk_buff_head, pkt_list_lock is redundant and
> can cause confusion, so let's remove it and use sk_buff_head.lock
> everywhere to protect the packet queue access.
> 
> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
> Cc: bobby.eshleman@bytedance.com
> Reported-and-tested-by: syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/vsock_loopback.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

Reviewed-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>

> 
> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> index 671e03240fc5..89905c092645 100644
> --- a/net/vmw_vsock/vsock_loopback.c
> +++ b/net/vmw_vsock/vsock_loopback.c
> @@ -15,7 +15,6 @@
>  struct vsock_loopback {
>  	struct workqueue_struct *workqueue;
>  
> -	spinlock_t pkt_list_lock; /* protects pkt_list */
>  	struct sk_buff_head pkt_queue;
>  	struct work_struct pkt_work;
>  };
> @@ -32,9 +31,7 @@ static int vsock_loopback_send_pkt(struct sk_buff *skb)
>  	struct vsock_loopback *vsock = &the_vsock_loopback;
>  	int len = skb->len;
>  
> -	spin_lock_bh(&vsock->pkt_list_lock);
>  	skb_queue_tail(&vsock->pkt_queue, skb);
> -	spin_unlock_bh(&vsock->pkt_list_lock);
>  
>  	queue_work(vsock->workqueue, &vsock->pkt_work);
>  
> @@ -113,9 +110,9 @@ static void vsock_loopback_work(struct work_struct *work)
>  
>  	skb_queue_head_init(&pkts);
>  
> -	spin_lock_bh(&vsock->pkt_list_lock);
> +	spin_lock_bh(&vsock->pkt_queue.lock);
>  	skb_queue_splice_init(&vsock->pkt_queue, &pkts);
> -	spin_unlock_bh(&vsock->pkt_list_lock);
> +	spin_unlock_bh(&vsock->pkt_queue.lock);
>  
>  	while ((skb = __skb_dequeue(&pkts))) {
>  		virtio_transport_deliver_tap_pkt(skb);
> @@ -132,7 +129,6 @@ static int __init vsock_loopback_init(void)
>  	if (!vsock->workqueue)
>  		return -ENOMEM;
>  
> -	spin_lock_init(&vsock->pkt_list_lock);
>  	skb_queue_head_init(&vsock->pkt_queue);
>  	INIT_WORK(&vsock->pkt_work, vsock_loopback_work);
>  
> @@ -156,9 +152,7 @@ static void __exit vsock_loopback_exit(void)
>  
>  	flush_work(&vsock->pkt_work);
>  
> -	spin_lock_bh(&vsock->pkt_list_lock);
>  	virtio_vsock_skb_queue_purge(&vsock->pkt_queue);
> -	spin_unlock_bh(&vsock->pkt_list_lock);
>  
>  	destroy_workqueue(vsock->workqueue);
>  }
