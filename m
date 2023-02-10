Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE8C6919D7
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjBJIOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjBJIOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:14:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C6181871
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 00:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676016801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mmD+/x0I+KucuUr8ukhVrW2uoWn8y09m7hDiZ6lHrcA=;
        b=ZqZMEJZBG4vUYLaUxhsf5MH6NpFYzbxcVZXZqDvwuJL/2yBoiChkP+BR84qmZCMBa8usV7
        /exDouNadiwSp2NdkCBFRDfOECDp5bM8Il6vRE4tezdmrQZ0zCaeiohRc+jcXZQzy7qyWA
        DvEL0manpXBwvvRyPGyRX5faC7rKfCg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-208-deXiOZvrNDinhlMRCEoBmw-1; Fri, 10 Feb 2023 03:10:10 -0500
X-MC-Unique: deXiOZvrNDinhlMRCEoBmw-1
Received: by mail-ej1-f70.google.com with SMTP id d14-20020a170906c20e00b00889f989d8deso3164892ejz.15
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 00:10:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mmD+/x0I+KucuUr8ukhVrW2uoWn8y09m7hDiZ6lHrcA=;
        b=nOtI50MdojjXZytwwXMgL1iHqgY+IRaw22jY0PzStJpZAFSrQ37cT2uGH01acbkgZf
         TLkgSAWzHfkJYkseeJ1uU+7itXv9DnQb+srFATgoTOpT5CvaHnoadAiE2JJ9DcV5DAA8
         ymKpQYBtVHtFJvcXPte+6Ax2nBnvq9E0+SZW76xyAFl3E5/rCmWMiq67XvgdNOzU3p0W
         By4ya3z7ZN1CPz2XUb91Eq5o/8rdIUmqZ+BuRRCTFDaVFQqDVfs9FCRkk7TC+SExiG74
         dJSFbrGr1X45sx/kB/N3Edhvxwo4naNoeGj8qGtktaJdDKDl89fkZzqhps8DllCVG1Fy
         GEMA==
X-Gm-Message-State: AO0yUKWDLMApO8N5N7GSZCARRJvDIQIrN7ddBBj3EJqGtAe8HnfG4ZC0
        uAchszlO5VPRGvC6Fk+ZqX4mgT6h/sXqQK5cpdmBvgrs91VqtqhL7vHC/+h73zuMussfAGGF5Ya
        tzSgki0H5Htyg/rvp
X-Received: by 2002:a17:906:1f56:b0:87b:d2b3:67ca with SMTP id d22-20020a1709061f5600b0087bd2b367camr15062619ejk.75.1676016609384;
        Fri, 10 Feb 2023 00:10:09 -0800 (PST)
X-Google-Smtp-Source: AK7set+s4ZfcCbOGMZCG4SLN9KV58h/92oauNwe/AY9NlHgijMrvjhcEaQJldOHl5jmV4wysB4+Idw==
X-Received: by 2002:a17:906:1f56:b0:87b:d2b3:67ca with SMTP id d22-20020a1709061f5600b0087bd2b367camr15062609ejk.75.1676016609153;
        Fri, 10 Feb 2023 00:10:09 -0800 (PST)
Received: from redhat.com ([2.52.132.212])
        by smtp.gmail.com with ESMTPSA id uj28-20020a170907c99c00b00878a8937009sm2013357ejc.199.2023.02.10.00.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 00:10:08 -0800 (PST)
Date:   Fri, 10 Feb 2023 03:10:04 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     =?utf-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?utf-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Subject: Re: [PATCH 2/2] net/packet: send and receive pkt with given
 vnet_hdr_sz
Message-ID: <20230210030710-mutt-send-email-mst@kernel.org>
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
 <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
 <20230209080612-mutt-send-email-mst@kernel.org>
 <858f8db1-c107-1ac5-bcbc-84e0d36c981d@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <858f8db1-c107-1ac5-bcbc-84e0d36c981d@antgroup.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 12:01:03PM +0800, 沈安琪(凛玥) wrote:
> 
> 在 2023/2/9 下午9:07, Michael S. Tsirkin 写道:
> > On Thu, Feb 09, 2023 at 08:43:15PM +0800, 沈安琪(凛玥) wrote:
> > > From: "Jianfeng Tan" <henry.tjf@antgroup.com>
> > > 
> > > When raw socket is used as the backend for kernel vhost, currently it
> > > will regard the virtio net header as 10-byte, which is not always the
> > > case since some virtio features need virtio net header other than
> > > 10-byte, such as mrg_rxbuf and VERSION_1 that both need 12-byte virtio
> > > net header.
> > > 
> > > Instead of hardcoding virtio net header length to 10 bytes, tpacket_snd,
> > > tpacket_rcv, packet_snd and packet_recvmsg now get the virtio net header
> > > size that is recorded in packet_sock to indicate the exact virtio net
> > > header size that virtio user actually prepares in the packets. By doing
> > > so, it can fix the issue of incorrect mac header parsing when these
> > > virtio features that need virtio net header other than 10-byte are
> > > enable.
> > > 
> > > Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> > > Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> > > Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> > Does it handle VERSION_1 though? That one is also LE.
> > Would it be better to pass a features bitmap instead?
> 
> 
> Thanks for quick reply!
> 
> I am a little confused abot what "LE" presents here?

LE == little_endian.
Little endian format.

> For passing a features bitmap to af_packet here, our consideration is
> whether it will be too complicated for af_packet to understand the virtio
> features bitmap in order to get the vnet header size. For now, all the
> virtio features stuff is handled by vhost worker and af_packet actually does
> not need to know much about virtio features. Would it be better if we keep
> the virtio feature stuff in user-level and let user-level tell af_packet how
> much space it should reserve?

Presumably, we'd add an API in include/linux/virtio_net.h ?

> > 
> > 
> > > ---
> > >   net/packet/af_packet.c | 48 +++++++++++++++++++++++++++++++++---------------
> > >   1 file changed, 33 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > > index ab37baf..4f49939 100644
> > > --- a/net/packet/af_packet.c
> > > +++ b/net/packet/af_packet.c
> > > @@ -2092,18 +2092,25 @@ static unsigned int run_filter(struct sk_buff *skb,
> > >   }
> > >   static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
> > > -			   size_t *len)
> > > +			   size_t *len, int vnet_hdr_sz)
> > >   {
> > >   	struct virtio_net_hdr vnet_hdr;
> > > +	int ret;
> > > -	if (*len < sizeof(vnet_hdr))
> > > +	if (*len < vnet_hdr_sz)
> > >   		return -EINVAL;
> > > -	*len -= sizeof(vnet_hdr);
> > > +	*len -= vnet_hdr_sz;
> > >   	if (virtio_net_hdr_from_skb(skb, &vnet_hdr, vio_le(), true, 0))
> > >   		return -EINVAL;
> > > -	return memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
> > > +	ret = memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
> > > +
> > > +	/* reserve space for extra info in vnet_hdr if needed */
> > > +	if (ret == 0)
> > > +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(vnet_hdr));
> > > +
> > > +	return ret;
> > >   }
> > >   /*
> > > @@ -2311,7 +2318,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
> > >   				       (maclen < 16 ? 16 : maclen)) +
> > >   				       po->tp_reserve;
> > >   		if (po->has_vnet_hdr) {
> > > -			netoff += sizeof(struct virtio_net_hdr);
> > > +			netoff += po->vnet_hdr_sz;
> > >   			do_vnet = true;
> > >   		}
> > >   		macoff = netoff - maclen;
> > > @@ -2552,16 +2559,23 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
> > >   }
> > >   static int packet_snd_vnet_parse(struct msghdr *msg, size_t *len,
> > > -				 struct virtio_net_hdr *vnet_hdr)
> > > +				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
> > >   {
> > > -	if (*len < sizeof(*vnet_hdr))
> > > +	int ret;
> > > +
> > > +	if (*len < vnet_hdr_sz)
> > >   		return -EINVAL;
> > > -	*len -= sizeof(*vnet_hdr);
> > > +	*len -= vnet_hdr_sz;
> > >   	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->msg_iter))
> > >   		return -EFAULT;
> > > -	return __packet_snd_vnet_parse(vnet_hdr, *len);
> > > +	ret = __packet_snd_vnet_parse(vnet_hdr, *len);
> > > +
> > > +	/* move iter to point to the start of mac header */
> > > +	if (ret == 0)
> > > +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_net_hdr));
> > > +	return ret;
> > >   }
> > >   static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
> > > @@ -2730,6 +2744,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > >   	int status = TP_STATUS_AVAILABLE;
> > >   	int hlen, tlen, copylen = 0;
> > >   	long timeo = 0;
> > > +	int vnet_hdr_sz;
> > >   	mutex_lock(&po->pg_vec_lock);
> > > @@ -2811,8 +2826,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > >   		tlen = dev->needed_tailroom;
> > >   		if (po->has_vnet_hdr) {
> > >   			vnet_hdr = data;
> > > -			data += sizeof(*vnet_hdr);
> > > -			tp_len -= sizeof(*vnet_hdr);
> > > +			vnet_hdr_sz = po->vnet_hdr_sz;
> > > +			data += vnet_hdr_sz;
> > > +			tp_len -= vnet_hdr_sz;
> > >   			if (tp_len < 0 ||
> > >   			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
> > >   				tp_len = -EINVAL;
> > > @@ -2947,6 +2963,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
> > >   	int offset = 0;
> > >   	struct packet_sock *po = pkt_sk(sk);
> > >   	bool has_vnet_hdr = false;
> > > +	int vnet_hdr_sz;
> > >   	int hlen, tlen, linear;
> > >   	int extra_len = 0;
> > > @@ -2991,7 +3008,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
> > >   	if (sock->type == SOCK_RAW)
> > >   		reserve = dev->hard_header_len;
> > >   	if (po->has_vnet_hdr) {
> > > -		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
> > > +		vnet_hdr_sz = po->vnet_hdr_sz;
> > > +		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
> > >   		if (err)
> > >   			goto out_unlock;
> > >   		has_vnet_hdr = true;
> > > @@ -3068,7 +3086,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
> > >   		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
> > >   		if (err)
> > >   			goto out_free;
> > > -		len += sizeof(vnet_hdr);
> > > +		len += vnet_hdr_sz;
> > >   		virtio_net_hdr_set_proto(skb, &vnet_hdr);
> > >   	}
> > > @@ -3452,10 +3470,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> > >   	packet_rcv_try_clear_pressure(pkt_sk(sk));
> > >   	if (pkt_sk(sk)->has_vnet_hdr) {
> > > -		err = packet_rcv_vnet(msg, skb, &len);
> > > +		vnet_hdr_len = pkt_sk(sk)->vnet_hdr_sz;
> > > +		err = packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
> > >   		if (err)
> > >   			goto out_free;
> > > -		vnet_hdr_len = sizeof(struct virtio_net_hdr);
> > >   	}
> > >   	/* You lose any data beyond the buffer you gave. If it worries
> > > -- 
> > > 1.8.3.1

