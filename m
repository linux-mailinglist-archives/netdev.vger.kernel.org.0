Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDF96B6FA0
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjCMGwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCMGwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:52:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93BC4A1FE
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 23:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678690275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8rZhn0kP2E7Reox+paqNBQEwuGtaW8297S/0QcEovG8=;
        b=AXWIW9R5JKlMw5xwhN/BX01zkp2bCBuvXxDavWaPO1WpET7PcghMPG/5QE7s3BzufIBfsR
        t33Rv0ah/LTafLs0ESoGXPiRFoxtqh4fE8JzEUEPeEdDkkmmJvoDtcRozg8+ARmqD6jO8F
        d2ggKhI9O2VkQmYb8D86313FeeGuyME=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-ER6wWC0VOiadsAFRZkqO-w-1; Mon, 13 Mar 2023 02:51:13 -0400
X-MC-Unique: ER6wWC0VOiadsAFRZkqO-w-1
Received: by mail-wm1-f71.google.com with SMTP id j32-20020a05600c1c2000b003e9bdf02c9fso7329435wms.6
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 23:51:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678690272;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rZhn0kP2E7Reox+paqNBQEwuGtaW8297S/0QcEovG8=;
        b=6y2Eit+VbYk7Q0xVpLuWuqOn7Xo64IvRthI7uBR73nHHIXEDJGtBJKSoPjt0jGd5Rk
         vYw+O5M4fCp1BdcQLXMTtZqLOnlDztArZJ1XgQ9dFNZ/vxLRbliX9lB4sIMTPKHeUihe
         /oEoXFCbhsyDopHXQn59b0s50EdqreXqyKQH0VHsw/hjilgasotv9i8u3UjXt+DVgWjk
         4t4jlRjO86IRrD0edQmZODS3TXsk74OyM1LIIMl4Tr9vpqKvFEYJu+1zphVSSU6yZHSJ
         rBfkrgTdV97aOptOewtIHhXhZmsQm8IT7n4IQHTyeDcwqQer757rJeBAu39fjO8OiJ6F
         ZLGg==
X-Gm-Message-State: AO0yUKXzg5W1BkXx+p2aL2qUYXQT/bsbi43BZepzr4APzePhpxWOZFlp
        I7Gfo/o1Ks1J6f78O5D+ZQUH8S4xsyinNXvdHsJ9X+y0ENz1uH9ErzysqXdSemythdjbrjQq01v
        Sfmx1co0tDxxns0+b
X-Received: by 2002:a05:600c:4f02:b0:3eb:39c3:8844 with SMTP id l2-20020a05600c4f0200b003eb39c38844mr10198988wmq.12.1678690272039;
        Sun, 12 Mar 2023 23:51:12 -0700 (PDT)
X-Google-Smtp-Source: AK7set9oq341X6qvQwifhjWFLcWne0/xh7yQVBclbyEpinJYQN8RUnTxoUqi38SKpDyoKBJzqc4KwQ==
X-Received: by 2002:a05:600c:4f02:b0:3eb:39c3:8844 with SMTP id l2-20020a05600c4f0200b003eb39c38844mr10198974wmq.12.1678690271662;
        Sun, 12 Mar 2023 23:51:11 -0700 (PDT)
Received: from redhat.com ([2.52.26.7])
        by smtp.gmail.com with ESMTPSA id f18-20020a7bcc12000000b003dc47d458cdsm8104425wmh.15.2023.03.12.23.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 23:51:11 -0700 (PDT)
Date:   Mon, 13 Mar 2023 02:51:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     =?utf-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?utf-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Subject: Re: [PATCH v4] net/packet: support mergeable feature of virtio
Message-ID: <20230313024705-mutt-send-email-mst@kernel.org>
References: <1678689073-101893-1-git-send-email-amy.saq@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1678689073-101893-1-git-send-email-amy.saq@antgroup.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 02:31:13PM +0800, 沈安琪(凛玥) wrote:
> From: Jianfeng Tan <henry.tjf@antgroup.com>
> 
> Packet sockets, like tap, can be used as the backend for kernel vhost.
> In packet sockets, virtio net header size is currently hardcoded to be
> the size of struct virtio_net_hdr, which is 10 bytes; however, it is not
> always the case: some virtio features, such as mrg_rxbuf, need virtio
> net headers to be 12-byte long.
> 
> Mergeable buffers, as a virtio feature, is worthy of supporting: packets
> that are larger than one-mbuf size will be dropped in vhost worker's
> handle_rx if mrg_rxbuf feature is not used, but large packets
> cannot be avoided and increasing mbuf's size is not economical.
> 
> With this virtio feature enabled by virtio-user, packet sockets with
> hardcoded 10-byte virtio net header will parse mac head incorrectly in
> packet_snd by taking the last two bytes of virtio net header as part of
> mac header.
> This incorrect mac header parsing will cause packet to be dropped due to
> invalid ether head checking in later under-layer device packet receiving.
> 
> By adding extra field vnet_hdr_sz with utilizing holes in struct
> packet_sock to record currently used virtio net header size and supporting
> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
> sockets can know the exact length of virtio net header that virtio user
> gives.
> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
> hardcoded virtio net header size, it can get the exact vnet_hdr_sz from
> corresponding packet_sock, and parse mac header correctly based on this
> information to avoid the packets being mistakenly dropped.
> 
> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> ---
> 
> V3 -> V4:
> * read po->vnet_hdr_sz once during vnet_hdr_sz and use vnet_hdr_sz locally 
> to avoid race condition;

Wait a second. What kind of race condition? And what happens if
it does trigger? By once do you mean this:
	int vnet_hdr_sz = po->vnet_hdr_sz;
?  This is not guaranteed to read the value once, compiler is free
to read as many times as it likes.

See e.g. memory barriers doc:

 (*) It _must_not_ be assumed that the compiler will do what you want
     with memory references that are not protected by READ_ONCE() and
     WRITE_ONCE().  Without them, the compiler is within its rights to
     do all sorts of "creative" transformations, which are covered in
     the COMPILER BARRIER section.



> * modify how to check non-zero po->vnet_hdr_sz;
> * separate vnet_hdr_sz as a u8 field in struct packet_sock instead of 8-bit
> in an int field.
> 
>  include/uapi/linux/if_packet.h |  1 +
>  net/packet/af_packet.c         | 87 +++++++++++++++++++++++++++---------------
>  net/packet/diag.c              |  2 +-
>  net/packet/internal.h          |  2 +-
>  4 files changed, 59 insertions(+), 33 deletions(-)
> 
> diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
> index 78c981d..9efc423 100644
> --- a/include/uapi/linux/if_packet.h
> +++ b/include/uapi/linux/if_packet.h
> @@ -59,6 +59,7 @@ struct sockaddr_ll {
>  #define PACKET_ROLLOVER_STATS		21
>  #define PACKET_FANOUT_DATA		22
>  #define PACKET_IGNORE_OUTGOING		23
> +#define PACKET_VNET_HDR_SZ		24
>  
>  #define PACKET_FANOUT_HASH		0
>  #define PACKET_FANOUT_LB		1
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 8ffb19c..06b9893 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2092,18 +2092,18 @@ static unsigned int run_filter(struct sk_buff *skb,
>  }
>  
>  static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
> -			   size_t *len)
> +			   size_t *len, int vnet_hdr_sz)
>  {
> -	struct virtio_net_hdr vnet_hdr;
> +	struct virtio_net_hdr_mrg_rxbuf vnet_hdr = { .num_buffers = 0 };
>  
> -	if (*len < sizeof(vnet_hdr))
> +	if (*len < vnet_hdr_sz)
>  		return -EINVAL;
> -	*len -= sizeof(vnet_hdr);
> +	*len -= vnet_hdr_sz;
>  
> -	if (virtio_net_hdr_from_skb(skb, &vnet_hdr, vio_le(), true, 0))
> +	if (virtio_net_hdr_from_skb(skb, (struct virtio_net_hdr *)&vnet_hdr, vio_le(), true, 0))
>  		return -EINVAL;
>  
> -	return memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
> +	return memcpy_to_msg(msg, (void *)&vnet_hdr, vnet_hdr_sz);
>  }
>  
>  /*
> @@ -2253,6 +2253,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>  	bool is_drop_n_account = false;
>  	unsigned int slot_id = 0;
>  	bool do_vnet = false;
> +	int vnet_hdr_sz;
>  
>  	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNMENT.
>  	 * We may add members to them until current aligned size without forcing
> @@ -2310,8 +2311,9 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>  		netoff = TPACKET_ALIGN(po->tp_hdrlen +
>  				       (maclen < 16 ? 16 : maclen)) +
>  				       po->tp_reserve;
> -		if (po->has_vnet_hdr) {
> -			netoff += sizeof(struct virtio_net_hdr);
> +		vnet_hdr_sz = po->vnet_hdr_sz;
> +		if (vnet_hdr_sz) {
> +			netoff += vnet_hdr_sz;
>  			do_vnet = true;
>  		}
>  		macoff = netoff - maclen;
> @@ -2552,16 +2554,27 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
>  }
>  
>  static int packet_snd_vnet_parse(struct msghdr *msg, size_t *len,
> -				 struct virtio_net_hdr *vnet_hdr)
> +				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
>  {
> -	if (*len < sizeof(*vnet_hdr))
> +	int ret;
> +
> +	if (*len < vnet_hdr_sz)
>  		return -EINVAL;
> -	*len -= sizeof(*vnet_hdr);
> +	*len -= vnet_hdr_sz;
>  
>  	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->msg_iter))
>  		return -EFAULT;
>  
> -	return __packet_snd_vnet_parse(vnet_hdr, *len);
> +	ret = __packet_snd_vnet_parse(vnet_hdr, *len);
> +
> +	if (ret)
> +		return ret;
> +
> +	/* move iter to point to the start of mac header */
> +	if (vnet_hdr_sz != sizeof(struct virtio_net_hdr))
> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_net_hdr));
> +
> +	return 0;
>  }
>  
>  static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
> @@ -2730,6 +2743,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  	int status = TP_STATUS_AVAILABLE;
>  	int hlen, tlen, copylen = 0;
>  	long timeo = 0;
> +	int vnet_hdr_sz = po->vnet_hdr_sz;
>  
>  	mutex_lock(&po->pg_vec_lock);
>  
> @@ -2780,7 +2794,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  	size_max = po->tx_ring.frame_size
>  		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
>  
> -	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
> +	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !vnet_hdr_sz)
>  		size_max = dev->mtu + reserve + VLAN_HLEN;
>  
>  	reinit_completion(&po->skb_completion);
> @@ -2809,10 +2823,10 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  		status = TP_STATUS_SEND_REQUEST;
>  		hlen = LL_RESERVED_SPACE(dev);
>  		tlen = dev->needed_tailroom;
> -		if (po->has_vnet_hdr) {
> +		if (vnet_hdr_sz) {
>  			vnet_hdr = data;
> -			data += sizeof(*vnet_hdr);
> -			tp_len -= sizeof(*vnet_hdr);
> +			data += vnet_hdr_sz;
> +			tp_len -= vnet_hdr_sz;
>  			if (tp_len < 0 ||
>  			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
>  				tp_len = -EINVAL;
> @@ -2837,7 +2851,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  					  addr, hlen, copylen, &sockc);
>  		if (likely(tp_len >= 0) &&
>  		    tp_len > dev->mtu + reserve &&
> -		    !po->has_vnet_hdr &&
> +		    !vnet_hdr_sz &&
>  		    !packet_extra_vlan_len_allowed(dev, skb))
>  			tp_len = -EMSGSIZE;
>  
> @@ -2856,7 +2870,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  			}
>  		}
>  
> -		if (po->has_vnet_hdr) {
> +		if (vnet_hdr_sz) {
>  			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
>  				tp_len = -EINVAL;
>  				goto tpacket_error;
> @@ -2946,7 +2960,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  	struct virtio_net_hdr vnet_hdr = { 0 };
>  	int offset = 0;
>  	struct packet_sock *po = pkt_sk(sk);
> -	bool has_vnet_hdr = false;
> +	int vnet_hdr_sz = po->vnet_hdr_sz;
>  	int hlen, tlen, linear;
>  	int extra_len = 0;
>  
> @@ -2990,11 +3004,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  
>  	if (sock->type == SOCK_RAW)
>  		reserve = dev->hard_header_len;
> -	if (po->has_vnet_hdr) {
> -		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
> +
> +	if (vnet_hdr_sz) {
> +		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
>  		if (err)
>  			goto out_unlock;
> -		has_vnet_hdr = true;
>  	}
>  
>  	if (unlikely(sock_flag(sk, SOCK_NOFCS))) {
> @@ -3064,11 +3078,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  
>  	packet_parse_headers(skb, sock);
>  
> -	if (has_vnet_hdr) {
> +	if (vnet_hdr_sz) {
>  		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>  		if (err)
>  			goto out_free;
> -		len += sizeof(vnet_hdr);
> +		len += vnet_hdr_sz;
>  		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>  	}
>  
> @@ -3410,7 +3424,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  	struct sock *sk = sock->sk;
>  	struct sk_buff *skb;
>  	int copied, err;
> -	int vnet_hdr_len = 0;
> +	int vnet_hdr_len = pkt_sk(sk)->vnet_hdr_sz;
>  	unsigned int origlen = 0;
>  
>  	err = -EINVAL;
> @@ -3451,11 +3465,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  
>  	packet_rcv_try_clear_pressure(pkt_sk(sk));
>  
> -	if (pkt_sk(sk)->has_vnet_hdr) {
> -		err = packet_rcv_vnet(msg, skb, &len);
> +	if (vnet_hdr_len) {
> +		err = packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
>  		if (err)
>  			goto out_free;
> -		vnet_hdr_len = sizeof(struct virtio_net_hdr);
>  	}
>  
>  	/* You lose any data beyond the buffer you gave. If it worries
> @@ -3921,8 +3934,9 @@ static void packet_flush_mclist(struct sock *sk)
>  		return 0;
>  	}
>  	case PACKET_VNET_HDR:
> +	case PACKET_VNET_HDR_SZ:
>  	{
> -		int val;
> +		int val, hdr_len;
>  
>  		if (sock->type != SOCK_RAW)
>  			return -EINVAL;
> @@ -3931,11 +3945,19 @@ static void packet_flush_mclist(struct sock *sk)
>  		if (copy_from_sockptr(&val, optval, sizeof(val)))
>  			return -EFAULT;
>  
> +		hdr_len = val ? sizeof(struct virtio_net_hdr) : 0;
> +		if (optname == PACKET_VNET_HDR_SZ) {
> +			if (val && val != sizeof(struct virtio_net_hdr) &&
> +			    val != sizeof(struct virtio_net_hdr_mrg_rxbuf))
> +				return -EINVAL;
> +			hdr_len = val;
> +		}
> +
>  		lock_sock(sk);
>  		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>  			ret = -EBUSY;
>  		} else {
> -			po->has_vnet_hdr = !!val;
> +			po->vnet_hdr_sz = hdr_len;
>  			ret = 0;
>  		}
>  		release_sock(sk);
> @@ -4068,7 +4090,10 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
>  		val = po->origdev;
>  		break;
>  	case PACKET_VNET_HDR:
> -		val = po->has_vnet_hdr;
> +		val = !!po->vnet_hdr_sz;
> +		break;
> +	case PACKET_VNET_HDR_SZ:
> +		val = po->vnet_hdr_sz;
>  		break;
>  	case PACKET_VERSION:
>  		val = po->tp_version;
> diff --git a/net/packet/diag.c b/net/packet/diag.c
> index 07812ae..dfec603 100644
> --- a/net/packet/diag.c
> +++ b/net/packet/diag.c
> @@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
>  		pinfo.pdi_flags |= PDI_AUXDATA;
>  	if (po->origdev)
>  		pinfo.pdi_flags |= PDI_ORIGDEV;
> -	if (po->has_vnet_hdr)
> +	if (po->vnet_hdr_sz)
>  		pinfo.pdi_flags |= PDI_VNETHDR;
>  	if (po->tp_loss)
>  		pinfo.pdi_flags |= PDI_LOSS;
> diff --git a/net/packet/internal.h b/net/packet/internal.h
> index 48af35b..154c6bb 100644
> --- a/net/packet/internal.h
> +++ b/net/packet/internal.h
> @@ -119,9 +119,9 @@ struct packet_sock {
>  	unsigned int		running;	/* bind_lock must be held */
>  	unsigned int		auxdata:1,	/* writer must hold sock lock */
>  				origdev:1,
> -				has_vnet_hdr:1,
>  				tp_loss:1,
>  				tp_tx_has_off:1;
> +	u8			vnet_hdr_sz;
>  	int			pressure;
>  	int			ifindex;	/* bound device		*/
>  	__be16			num;
> -- 
> 1.8.3.1

