Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B05690986
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjBINIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBINIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:08:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1532F93F0
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675948036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKSOsthx/MzCCjAsjBm2wIt25wNPRi9pMw7Cs7SkctM=;
        b=dp7ZkoQUjiolwxJECQc/KG4VICkIwRmc6Bj1pvakhfdTko4xUpmuZ+/K/5PeVrD3fXVGqy
        +wKqO+L1WMFeWsgEpv7saXJFh6F6KKQ5+z9IJP6fWncF/KtThRbTRsULc2J1jbWXqJkYF2
        NMFugOmagcCd6Hlux9Qwy46jvgr/ANU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-540-Dp5j28M7OVidZOE30K5cjw-1; Thu, 09 Feb 2023 08:07:14 -0500
X-MC-Unique: Dp5j28M7OVidZOE30K5cjw-1
Received: by mail-ej1-f69.google.com with SMTP id lf9-20020a170907174900b0087861282038so1467060ejc.6
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 05:07:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WKSOsthx/MzCCjAsjBm2wIt25wNPRi9pMw7Cs7SkctM=;
        b=lGWeI1efpzoq2ocyZFgeOS5cvjOhx8rt9PD2PzDgf3ozI/8V+peBieMwAHpkhLoImd
         agc/kzWlvwAIGsnfcPuopdOavs5Uu9vFIh5UXsh6qGbRJt5XsH4IQlcFcyxpIKk8ibUs
         nFiq1eO2kf1o3XfJW4KsSY0jAE+hYJ51VXqU6N7l800GTrx3d/oqH0ueSc0ZILQ2U4Su
         NtNhCLP/pa8khSQlegAGYUsIuz/3iQf/jvln3DLfGedLTxUrD4QEn5KJ92JB2ROT3rUd
         M3pCchnmIiPNsKYiMmpRSsqSy/TCXNf5p/1y6C4gUm/zh4wNiYPCZhyoWiWDUWU5sZKO
         SF5g==
X-Gm-Message-State: AO0yUKU1HmD884MsHz/51svRZj5UrzLzMcY5Vl8Bw28g8ayFr8nTJvvV
        h+r5IizxPdWu8ORdO5p03uy/TmEWfds8vAUu0Htha8bmg7i8zP5t/aSOnskvH5jS9wJ69FCUZt2
        o/AhUqZ1ab9qULP00
X-Received: by 2002:a17:907:1c18:b0:878:481c:c49b with SMTP id nc24-20020a1709071c1800b00878481cc49bmr16112775ejc.1.1675948033696;
        Thu, 09 Feb 2023 05:07:13 -0800 (PST)
X-Google-Smtp-Source: AK7set8QfdE97WqHPYFJ40f54rZ6fwRmT0zXDFlZdoFueiPxu6AY6u0fJ5VCHSszcsFCH5qttph6Rw==
X-Received: by 2002:a17:907:1c18:b0:878:481c:c49b with SMTP id nc24-20020a1709071c1800b00878481cc49bmr16112756ejc.1.1675948033513;
        Thu, 09 Feb 2023 05:07:13 -0800 (PST)
Received: from redhat.com ([2.52.132.212])
        by smtp.gmail.com with ESMTPSA id s8-20020a170906168800b00887a23bab85sm840749ejd.220.2023.02.09.05.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 05:07:12 -0800 (PST)
Date:   Thu, 9 Feb 2023 08:07:09 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     =?utf-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?utf-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Subject: Re: [PATCH 2/2] net/packet: send and receive pkt with given
 vnet_hdr_sz
Message-ID: <20230209080612-mutt-send-email-mst@kernel.org>
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
 <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 08:43:15PM +0800, 沈安琪(凛玥) wrote:
> From: "Jianfeng Tan" <henry.tjf@antgroup.com>
> 
> When raw socket is used as the backend for kernel vhost, currently it
> will regard the virtio net header as 10-byte, which is not always the
> case since some virtio features need virtio net header other than
> 10-byte, such as mrg_rxbuf and VERSION_1 that both need 12-byte virtio
> net header.
> 
> Instead of hardcoding virtio net header length to 10 bytes, tpacket_snd,
> tpacket_rcv, packet_snd and packet_recvmsg now get the virtio net header
> size that is recorded in packet_sock to indicate the exact virtio net
> header size that virtio user actually prepares in the packets. By doing
> so, it can fix the issue of incorrect mac header parsing when these
> virtio features that need virtio net header other than 10-byte are
> enable.
> 
> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>

Does it handle VERSION_1 though? That one is also LE.
Would it be better to pass a features bitmap instead?


> ---
>  net/packet/af_packet.c | 48 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 33 insertions(+), 15 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index ab37baf..4f49939 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2092,18 +2092,25 @@ static unsigned int run_filter(struct sk_buff *skb,
>  }
>  
>  static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
> -			   size_t *len)
> +			   size_t *len, int vnet_hdr_sz)
>  {
>  	struct virtio_net_hdr vnet_hdr;
> +	int ret;
>  
> -	if (*len < sizeof(vnet_hdr))
> +	if (*len < vnet_hdr_sz)
>  		return -EINVAL;
> -	*len -= sizeof(vnet_hdr);
> +	*len -= vnet_hdr_sz;
>  
>  	if (virtio_net_hdr_from_skb(skb, &vnet_hdr, vio_le(), true, 0))
>  		return -EINVAL;
>  
> -	return memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
> +	ret = memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
> +
> +	/* reserve space for extra info in vnet_hdr if needed */
> +	if (ret == 0)
> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(vnet_hdr));
> +
> +	return ret;
>  }
>  
>  /*
> @@ -2311,7 +2318,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>  				       (maclen < 16 ? 16 : maclen)) +
>  				       po->tp_reserve;
>  		if (po->has_vnet_hdr) {
> -			netoff += sizeof(struct virtio_net_hdr);
> +			netoff += po->vnet_hdr_sz;
>  			do_vnet = true;
>  		}
>  		macoff = netoff - maclen;
> @@ -2552,16 +2559,23 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
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
> +	/* move iter to point to the start of mac header */
> +	if (ret == 0)
> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_net_hdr));
> +	return ret;
>  }
>  
>  static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
> @@ -2730,6 +2744,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  	int status = TP_STATUS_AVAILABLE;
>  	int hlen, tlen, copylen = 0;
>  	long timeo = 0;
> +	int vnet_hdr_sz;
>  
>  	mutex_lock(&po->pg_vec_lock);
>  
> @@ -2811,8 +2826,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>  		tlen = dev->needed_tailroom;
>  		if (po->has_vnet_hdr) {
>  			vnet_hdr = data;
> -			data += sizeof(*vnet_hdr);
> -			tp_len -= sizeof(*vnet_hdr);
> +			vnet_hdr_sz = po->vnet_hdr_sz;
> +			data += vnet_hdr_sz;
> +			tp_len -= vnet_hdr_sz;
>  			if (tp_len < 0 ||
>  			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
>  				tp_len = -EINVAL;
> @@ -2947,6 +2963,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  	int offset = 0;
>  	struct packet_sock *po = pkt_sk(sk);
>  	bool has_vnet_hdr = false;
> +	int vnet_hdr_sz;
>  	int hlen, tlen, linear;
>  	int extra_len = 0;
>  
> @@ -2991,7 +3008,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  	if (sock->type == SOCK_RAW)
>  		reserve = dev->hard_header_len;
>  	if (po->has_vnet_hdr) {
> -		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
> +		vnet_hdr_sz = po->vnet_hdr_sz;
> +		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
>  		if (err)
>  			goto out_unlock;
>  		has_vnet_hdr = true;
> @@ -3068,7 +3086,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>  		if (err)
>  			goto out_free;
> -		len += sizeof(vnet_hdr);
> +		len += vnet_hdr_sz;
>  		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>  	}
>  
> @@ -3452,10 +3470,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  	packet_rcv_try_clear_pressure(pkt_sk(sk));
>  
>  	if (pkt_sk(sk)->has_vnet_hdr) {
> -		err = packet_rcv_vnet(msg, skb, &len);
> +		vnet_hdr_len = pkt_sk(sk)->vnet_hdr_sz;
> +		err = packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
>  		if (err)
>  			goto out_free;
> -		vnet_hdr_len = sizeof(struct virtio_net_hdr);
>  	}
>  
>  	/* You lose any data beyond the buffer you gave. If it worries
> -- 
> 1.8.3.1

