Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EE9429766
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 21:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhJKTQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 15:16:34 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:26205 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbhJKTQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 15:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1633979485;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=grch5KYkzTXyGVux1SYPAnHZtd4ppQKlGwWMfNHYtu8=;
    b=oIhIAQ2L+yfPBN8Phjv2BejKLtennplUFwnp6n3NL/ocu58u+3T+ygYxlBOyYFZuHb
    YmwoClkVGJHR9kdD4igGJ5QegSztmu9QuOm5aMEEy66TA2Q3T3cjMTOwcbBA7qUSV6MV
    SjUoQzqUSfNC1uAkqVJh/+evq/lgbKPxriZzf+qW+4zidJ+I6ZF+py811L+w3frjl0MH
    O7EuzjVEw/39fjyTi8P8GaBXo0PzrMC6S+DBQK2a5Gaz9BWf39rluM56Y7ftH7HeVv6Y
    31Sd3su/mCxOujfsPKD6q/TdnodD8jPCYLJ3Cu9gHmDfpsXcjbfgkBSkEc3lenFJ0JE+
    O+3w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVvBOfXT2V6Q=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cfa:f904::b82]
    by smtp.strato.de (RZmta 47.33.8 AUTH)
    with ESMTPSA id 900f80x9BJBPwng
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 11 Oct 2021 21:11:25 +0200 (CEST)
Subject: Re: [PATCH net v2 2/2] can: isotp: fix tx buffer concurrent access in
 isotp_sendmsg()
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1633764159.git.william.xuanziyang@huawei.com>
 <c2517874fbdf4188585cf9ddf67a8fa74d5dbde5.1633764159.git.william.xuanziyang@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <37b50a76-db66-c043-9967-c1ae2787475f@hartkopp.net>
Date:   Mon, 11 Oct 2021 21:11:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c2517874fbdf4188585cf9ddf67a8fa74d5dbde5.1633764159.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.10.21 09:40, Ziyang Xuan wrote:
> When isotp_sendmsg() concurrent, tx.state of all tx processes can be
> ISOTP_IDLE. The conditions so->tx.state != ISOTP_IDLE and
> wq_has_sleeper(&so->wait) can not protect tx buffer from being accessed
> by multiple tx processes.
> 
> We can use cmpxchg() to try to modify tx.state to ISOTP_SENDING firstly.
> If the modification of the previous process succeed, the later process
> must wait tx.state to ISOTP_IDLE firstly. Thus, we can ensure tx buffer
> is accessed by only one process at the same time. And we should also
> restore the original tx.state at the subsequent error processes.
> 
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Many thanks!
Oliver

> ---
>   net/can/isotp.c | 46 +++++++++++++++++++++++++++++++---------------
>   1 file changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index 2ac29c2b2ca6..d1f54273c0bb 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -121,7 +121,7 @@ enum {
>   struct tpcon {
>   	int idx;
>   	int len;
> -	u8 state;
> +	u32 state;
>   	u8 bs;
>   	u8 sn;
>   	u8 ll_dl;
> @@ -848,6 +848,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   {
>   	struct sock *sk = sock->sk;
>   	struct isotp_sock *so = isotp_sk(sk);
> +	u32 old_state = so->tx.state;
>   	struct sk_buff *skb;
>   	struct net_device *dev;
>   	struct canfd_frame *cf;
> @@ -860,47 +861,55 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   		return -EADDRNOTAVAIL;
>   
>   	/* we do not support multiple buffers - for now */
> -	if (so->tx.state != ISOTP_IDLE || wq_has_sleeper(&so->wait)) {
> -		if (msg->msg_flags & MSG_DONTWAIT)
> -			return -EAGAIN;
> +	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE ||
> +	    wq_has_sleeper(&so->wait)) {
> +		if (msg->msg_flags & MSG_DONTWAIT) {
> +			err = -EAGAIN;
> +			goto err_out;
> +		}
>   
>   		/* wait for complete transmission of current pdu */
>   		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
>   		if (err)
> -			return err;
> +			goto err_out;
>   	}
>   
> -	if (!size || size > MAX_MSG_LENGTH)
> -		return -EINVAL;
> +	if (!size || size > MAX_MSG_LENGTH) {
> +		err = -EINVAL;
> +		goto err_out;
> +	}
>   
>   	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
>   	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
>   
>   	/* does the given data fit into a single frame for SF_BROADCAST? */
>   	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
> -	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off))
> -		return -EINVAL;
> +	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off)) {
> +		err = -EINVAL;
> +		goto err_out;
> +	}
>   
>   	err = memcpy_from_msg(so->tx.buf, msg, size);
>   	if (err < 0)
> -		return err;
> +		goto err_out;
>   
>   	dev = dev_get_by_index(sock_net(sk), so->ifindex);
> -	if (!dev)
> -		return -ENXIO;
> +	if (!dev) {
> +		err = -ENXIO;
> +		goto err_out;
> +	}
>   
>   	skb = sock_alloc_send_skb(sk, so->ll.mtu + sizeof(struct can_skb_priv),
>   				  msg->msg_flags & MSG_DONTWAIT, &err);
>   	if (!skb) {
>   		dev_put(dev);
> -		return err;
> +		goto err_out;
>   	}
>   
>   	can_skb_reserve(skb);
>   	can_skb_prv(skb)->ifindex = dev->ifindex;
>   	can_skb_prv(skb)->skbcnt = 0;
>   
> -	so->tx.state = ISOTP_SENDING;
>   	so->tx.len = size;
>   	so->tx.idx = 0;
>   
> @@ -956,7 +965,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   	if (err) {
>   		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
>   			       __func__, ERR_PTR(err));
> -		return err;
> +		goto err_out;
>   	}
>   
>   	if (wait_tx_done) {
> @@ -965,6 +974,13 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   	}
>   
>   	return size;
> +
> +err_out:
> +	so->tx.state = old_state;
> +	if (so->tx.state == ISOTP_IDLE)
> +		wake_up_interruptible(&so->wait);
> +
> +	return err;
>   }
>   
>   static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
> 
