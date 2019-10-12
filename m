Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217ADD4E16
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 09:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfJLHoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 03:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfJLHoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 03:44:39 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DA73309C386;
        Sat, 12 Oct 2019 07:44:38 +0000 (UTC)
Received: from [10.72.12.150] (ovpn-12-150.pek2.redhat.com [10.72.12.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C44225D6C8;
        Sat, 12 Oct 2019 07:44:33 +0000 (UTC)
Subject: Re: [PATCH net-next 1/3] tuntap: reorganize tun_msg_ctl usage
To:     prashantbhole.linux@gmail.com,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
 <20191012015357.1775-2-prashantbhole.linux@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <739281a8-59fe-d898-0147-656d01fdfabc@redhat.com>
Date:   Sat, 12 Oct 2019 15:44:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012015357.1775-2-prashantbhole.linux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Sat, 12 Oct 2019 07:44:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/12 上午9:53, prashantbhole.linux@gmail.com wrote:
> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>
> In order to extend the usage of tun_msg_ctl structure, this patch
> changes the member name from type to cmd. Also following definitions
> are changed:
> TUN_MSG_PTR : TUN_CMD_BATCH
> TUN_MSG_UBUF: TUN_CMD_PACKET


Not a native English speaker, but the conversion here looks not as 
straightforward as it did.

For TUN_MSG_PTR, it means recvmsg() can do receiving from a pointer to 
either XDP or skb instead of ptr_ring. TUN_CMD_BATCH sounds not related.

For TUN_MSG_UBUF, it means the packet is a zercopy (buffer pointers to 
userspace). TUN_CMD_PACKET may bring confusion in this case.

Thanks


>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> ---
>   drivers/net/tap.c      | 9 ++++++---
>   drivers/net/tun.c      | 8 ++++++--
>   drivers/vhost/net.c    | 4 ++--
>   include/linux/if_tun.h | 6 +++---
>   4 files changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 3ae70c7e6860..01bd260ce60c 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -1213,9 +1213,10 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
>   	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
>   	struct tun_msg_ctl *ctl = m->msg_control;
>   	struct xdp_buff *xdp;
> +	void *ptr = NULL;
>   	int i;
>   
> -	if (ctl && (ctl->type == TUN_MSG_PTR)) {
> +	if (ctl && ctl->cmd == TUN_CMD_BATCH) {
>   		for (i = 0; i < ctl->num; i++) {
>   			xdp = &((struct xdp_buff *)ctl->ptr)[i];
>   			tap_get_user_xdp(q, xdp);
> @@ -1223,8 +1224,10 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
>   		return 0;
>   	}
>   
> -	return tap_get_user(q, ctl ? ctl->ptr : NULL, &m->msg_iter,
> -			    m->msg_flags & MSG_DONTWAIT);
> +	if (ctl && ctl->cmd == TUN_CMD_PACKET)
> +		ptr = ctl->ptr;
> +
> +	return tap_get_user(q, ptr, &m->msg_iter, m->msg_flags & MSG_DONTWAIT);
>   }
>   
>   static int tap_recvmsg(struct socket *sock, struct msghdr *m,
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 0413d182d782..29711671959b 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2529,11 +2529,12 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>   	struct tun_struct *tun = tun_get(tfile);
>   	struct tun_msg_ctl *ctl = m->msg_control;
>   	struct xdp_buff *xdp;
> +	void *ptr = NULL;
>   
>   	if (!tun)
>   		return -EBADFD;
>   
> -	if (ctl && (ctl->type == TUN_MSG_PTR)) {
> +	if (ctl && ctl->cmd == TUN_CMD_BATCH) {
>   		struct tun_page tpage;
>   		int n = ctl->num;
>   		int flush = 0;
> @@ -2560,7 +2561,10 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
>   		goto out;
>   	}
>   
> -	ret = tun_get_user(tun, tfile, ctl ? ctl->ptr : NULL, &m->msg_iter,
> +	if (ctl && ctl->cmd == TUN_CMD_PACKET)
> +		ptr = ctl->ptr;
> +
> +	ret = tun_get_user(tun, tfile, ptr, &m->msg_iter,
>   			   m->msg_flags & MSG_DONTWAIT,
>   			   m->msg_flags & MSG_MORE);
>   out:
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 1a2dd53caade..5946d2775bd0 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -462,7 +462,7 @@ static void vhost_tx_batch(struct vhost_net *net,
>   			   struct msghdr *msghdr)
>   {
>   	struct tun_msg_ctl ctl = {
> -		.type = TUN_MSG_PTR,
> +		.cmd = TUN_CMD_BATCH,
>   		.num = nvq->batched_xdp,
>   		.ptr = nvq->xdp,
>   	};
> @@ -902,7 +902,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   			ubuf->desc = nvq->upend_idx;
>   			refcount_set(&ubuf->refcnt, 1);
>   			msg.msg_control = &ctl;
> -			ctl.type = TUN_MSG_UBUF;
> +			ctl.cmd = TUN_CMD_PACKET;
>   			ctl.ptr = ubuf;
>   			msg.msg_controllen = sizeof(ctl);
>   			ubufs = nvq->ubufs;
> diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
> index 5bda8cf457b6..bdfa671612db 100644
> --- a/include/linux/if_tun.h
> +++ b/include/linux/if_tun.h
> @@ -11,10 +11,10 @@
>   
>   #define TUN_XDP_FLAG 0x1UL
>   
> -#define TUN_MSG_UBUF 1
> -#define TUN_MSG_PTR  2
> +#define TUN_CMD_PACKET 1
> +#define TUN_CMD_BATCH  2
>   struct tun_msg_ctl {
> -	unsigned short type;
> +	unsigned short cmd;
>   	unsigned short num;
>   	void *ptr;
>   };
