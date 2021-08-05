Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1393E160C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241767AbhHENui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233033AbhHENuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 09:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 632FD6113B;
        Thu,  5 Aug 2021 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628171423;
        bh=nT1UWnENjBDcl40entDFb9eLWswm/nuKc503srol/vs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gIchlBOMqTDeBdHZTHenHuInKv3KPHn8Meym0knKTakBQy70DvHmNpoau1xhq17Xb
         pVr0TkUEe7oHjFXzveRVMD/lrUVnV2SY22MjBTTUjRd9NiG6I6nPZvZ8CcvZbKRgQD
         Kp1ouuwH8pn8IU3cE4EbO3Nqz6Ia9VHuPURg5TY6DfB+UEmvgpVCtPvUWZvqA3RQ2B
         ff7YfkJdPXdl059bjZ9uRUZvZm5lnCrIeowDDdL5tObHk6zgrlRxCNhT559wRqy0fa
         aV+4AZmbuUNlRYLEagzocbq32FRkU9dUZwVqTSi5bsWpeZyag7n5GMSJ1nWq2qEH0D
         BWQRarPdpMPPw==
Date:   Thu, 5 Aug 2021 06:50:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Takeshi Misawa <jeliantsurux@gmail.com>
Cc:     David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Subject: Re: [PATCH net] net: Fix memory leak in ieee802154_raw_deliver
Message-ID: <20210805065022.574e0691@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210805075414.GA15796@DESKTOP>
References: <20210805075414.GA15796@DESKTOP>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Aug 2021 16:54:14 +0900 Takeshi Misawa wrote:
> If IEEE-802.15.4-RAW is closed before receive skb, skb is leaked.
> Fix this, by freeing sk_receive_queue in sk->sk_destruct().
> 
> syzbot report:
> BUG: memory leak
> unreferenced object 0xffff88810f644600 (size 232):
>   comm "softirq", pid 0, jiffies 4294967032 (age 81.270s)
>   hex dump (first 32 bytes):
>     10 7d 4b 12 81 88 ff ff 10 7d 4b 12 81 88 ff ff  .}K......}K.....
>     00 00 00 00 00 00 00 00 40 7c 4b 12 81 88 ff ff  ........@|K.....
>   backtrace:
>     [<ffffffff83651d4a>] skb_clone+0xaa/0x2b0 net/core/skbuff.c:1496
>     [<ffffffff83fe1b80>] ieee802154_raw_deliver net/ieee802154/socket.c:369 [inline]
>     [<ffffffff83fe1b80>] ieee802154_rcv+0x100/0x340 net/ieee802154/socket.c:1070
>     [<ffffffff8367cc7a>] __netif_receive_skb_one_core+0x6a/0xa0 net/core/dev.c:5384
>     [<ffffffff8367cd07>] __netif_receive_skb+0x27/0xa0 net/core/dev.c:5498
>     [<ffffffff8367cdd9>] netif_receive_skb_internal net/core/dev.c:5603 [inline]
>     [<ffffffff8367cdd9>] netif_receive_skb+0x59/0x260 net/core/dev.c:5662
>     [<ffffffff83fe6302>] ieee802154_deliver_skb net/mac802154/rx.c:29 [inline]
>     [<ffffffff83fe6302>] ieee802154_subif_frame net/mac802154/rx.c:102 [inline]
>     [<ffffffff83fe6302>] __ieee802154_rx_handle_packet net/mac802154/rx.c:212 [inline]
>     [<ffffffff83fe6302>] ieee802154_rx+0x612/0x620 net/mac802154/rx.c:284
>     [<ffffffff83fe59a6>] ieee802154_tasklet_handler+0x86/0xa0 net/mac802154/main.c:35
>     [<ffffffff81232aab>] tasklet_action_common.constprop.0+0x5b/0x100 kernel/softirq.c:557
>     [<ffffffff846000bf>] __do_softirq+0xbf/0x2ab kernel/softirq.c:345
>     [<ffffffff81232f4c>] do_softirq kernel/softirq.c:248 [inline]
>     [<ffffffff81232f4c>] do_softirq+0x5c/0x80 kernel/softirq.c:235
>     [<ffffffff81232fc1>] __local_bh_enable_ip+0x51/0x60 kernel/softirq.c:198
>     [<ffffffff8367a9a4>] local_bh_enable include/linux/bottom_half.h:32 [inline]
>     [<ffffffff8367a9a4>] rcu_read_unlock_bh include/linux/rcupdate.h:745 [inline]
>     [<ffffffff8367a9a4>] __dev_queue_xmit+0x7f4/0xf60 net/core/dev.c:4221
>     [<ffffffff83fe2db4>] raw_sendmsg+0x1f4/0x2b0 net/ieee802154/socket.c:295
>     [<ffffffff8363af16>] sock_sendmsg_nosec net/socket.c:654 [inline]
>     [<ffffffff8363af16>] sock_sendmsg+0x56/0x80 net/socket.c:674
>     [<ffffffff8363deec>] __sys_sendto+0x15c/0x200 net/socket.c:1977
>     [<ffffffff8363dfb6>] __do_sys_sendto net/socket.c:1989 [inline]
>     [<ffffffff8363dfb6>] __se_sys_sendto net/socket.c:1985 [inline]
>     [<ffffffff8363dfb6>] __x64_sys_sendto+0x26/0x30 net/socket.c:1985
> 
> Fixes: 9ec767160357 ("net: add IEEE 802.15.4 socket family implementation")
> Reported-and-tested-by: syzbot+1f68113fa907bf0695a8@syzkaller.appspotmail.com
> Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
> ---
> Dear David Howells, Jakub Kicinski

Please use scripts/get_maintainer.pl to find the people you should CC.
Adding Alexander and Stefan.

> syzbot reported memory leak in ieee802154_raw_deliver.
> 
> I send a patch that passed syzbot reproducer test.
> Please consider this memory leak and patch.
> 
> syzbot link:
> https://syzkaller.appspot.com/bug?id=8dd3bcb1dc757587adfb4dbb810fd24dd990283f
> 
> Regards.
> ---
>  net/ieee802154/socket.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index a45a0401adc5..c25f7617770c 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -984,6 +984,11 @@ static const struct proto_ops ieee802154_dgram_ops = {
>  	.sendpage	   = sock_no_sendpage,
>  };
>  
> +static void ieee802154_sock_destruct(struct sock *sk)
> +{
> +	skb_queue_purge(&sk->sk_receive_queue);
> +}
> +
>  /* Create a socket. Initialise the socket, blank the addresses
>   * set the state.
>   */
> @@ -1024,7 +1029,7 @@ static int ieee802154_create(struct net *net, struct socket *sock,
>  	sock->ops = ops;
>  
>  	sock_init_data(sock, sk);
> -	/* FIXME: sk->sk_destruct */
> +	sk->sk_destruct = ieee802154_sock_destruct;
>  	sk->sk_family = PF_IEEE802154;
>  
>  	/* Checksums on by default */

