Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD0F6B3E60
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjCJLuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCJLua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:50:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4732DD2931;
        Fri, 10 Mar 2023 03:50:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F35A0B8227D;
        Fri, 10 Mar 2023 11:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2575FC433EF;
        Fri, 10 Mar 2023 11:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678449026;
        bh=ShH9wDesH9cSa0+T/1FM84u8M0DlMaUCnHiJVbgwCxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RVNQukfhdzZ+DIfAu93gX4IdJuNmQ9kkAUWvW750qXADAj1E+Fs6k6t84tS9zRSz7
         iF8k8c5PI5Vmka4MkufRf3XoIa8OXEy9dbyQSl6QZlnKHuuqTdZlpEV2CieCB6050I
         9oiukxnIT629hs68aRsiIxEwvjYPKJ1YHL9p9wf8=
Date:   Fri, 10 Mar 2023 12:50:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Nguyen Dinh Phi <phind.uet@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
Subject: Re: [PATCH 4.14/4.19/5.4/5.10/5.15 1/1] Bluetooth: hci_sock: purge
 socket queues in the destruct() callback
Message-ID: <ZAsZf4BvErezNB7Z@kroah.com>
References: <20230309181251.479447-1-pchelkin@ispras.ru>
 <20230309181251.479447-2-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309181251.479447-2-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 09:12:51PM +0300, Fedor Pchelkin wrote:
> From: Nguyen Dinh Phi <phind.uet@gmail.com>
> 
> commit 709fca500067524381e28a5f481882930eebac88 upstream.
> 
> The receive path may take the socket right before hci_sock_release(),
> but it may enqueue the packets to the socket queues after the call to
> skb_queue_purge(), therefore the socket can be destroyed without clear
> its queues completely.
> 
> Moving these skb_queue_purge() to the hci_sock_destruct() will fix this
> issue, because nothing is referencing the socket at this point.
> 
> Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
> Reported-by: syzbot+4c4ffd1e1094dae61035@syzkaller.appspotmail.com
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  net/bluetooth/hci_sock.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index f1128c2134f0..3f92a21cabe8 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -888,10 +888,6 @@ static int hci_sock_release(struct socket *sock)
>  	}
>  
>  	sock_orphan(sk);
> -
> -	skb_queue_purge(&sk->sk_receive_queue);
> -	skb_queue_purge(&sk->sk_write_queue);
> -
>  	release_sock(sk);
>  	sock_put(sk);
>  	return 0;
> @@ -2012,6 +2008,12 @@ static int hci_sock_getsockopt(struct socket *sock, int level, int optname,
>  	return err;
>  }
>  
> +static void hci_sock_destruct(struct sock *sk)
> +{
> +	skb_queue_purge(&sk->sk_receive_queue);
> +	skb_queue_purge(&sk->sk_write_queue);
> +}
> +
>  static const struct proto_ops hci_sock_ops = {
>  	.family		= PF_BLUETOOTH,
>  	.owner		= THIS_MODULE,
> @@ -2065,6 +2067,7 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
>  
>  	sock->state = SS_UNCONNECTED;
>  	sk->sk_state = BT_OPEN;
> +	sk->sk_destruct = hci_sock_destruct;
>  
>  	bt_sock_link(&hci_sk_list, sk);
>  	return 0;
> -- 
> 2.34.1
> 

Now queued up, thanks.

greg k-h
