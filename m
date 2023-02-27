Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4528D6A4886
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 18:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjB0Rrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 12:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjB0Rrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 12:47:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320F946B0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677520026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUTPKohYh39XQkWqq/QAD4rVTubtKhnsL/KMG+gfHz8=;
        b=aNf6ik+6lQcmb2t69BhMhrjPXhsF7jQks/7nHYYKYgY7WxQLMtRRZJ6IReMbh58iG/G9Y6
        NsA6dARKx2VH71Sg4UP8TEPFmZCNzetm0c9NwAd9zceBCHHDSUefPnaPGFfsvfQpQWbeoR
        Gbf949IO3HxfHhvSzqc18/GrQmRI5zU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-224-So_RwGb3OyK8M6C1tRdtWw-1; Mon, 27 Feb 2023 12:47:05 -0500
X-MC-Unique: So_RwGb3OyK8M6C1tRdtWw-1
Received: by mail-ed1-f70.google.com with SMTP id ec13-20020a0564020d4d00b004a621e993a8so9784900edb.13
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 09:47:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TUTPKohYh39XQkWqq/QAD4rVTubtKhnsL/KMG+gfHz8=;
        b=2vFBr8mHT6g+g7nnbxfsOhglIpLUqEyLjLkFKjwVqvs+51EgTVClVlPcYXzUmUhCDs
         IrLYW2vv3mm9YDRoj0CkLhk7xUiMpMbIRGiDtfyAD5lHU60HgxX3atd48D6hld7bIbzu
         X72LLOvYRCFPjLksBoIK4N/QqlRylawxNsNZuBgkRAJt06arjmzTVyn9HSKiUVzo8Gpa
         InFVr1sAEo+Iiu54kV3Sxq3rVgXi5uFIWg9uA+tCEAFolCEv9uwNvn7XL5rQjnOFOzTh
         JGzIQKtQyRT4Tlr0xJTAS6caEBgg47nfGLgENFU/LpWv7e1lkiVQAhs4w2653PRqBGbr
         ebOA==
X-Gm-Message-State: AO0yUKWHWmNhfo5rGN3K9pM8nLpaq+4Ywe2NR6T3PIrttx+oLL8x3hfG
        nPjibmQ+4E2pJ5QGN31Tt66fRu/0x3KDfBJidRxysftPVI/xdOCjx44GfU9sI43BU2ayAA4vjCf
        AjE2w9IGBoMbkxb4D0v4U+w==
X-Received: by 2002:a50:ef08:0:b0:4ac:b559:4730 with SMTP id m8-20020a50ef08000000b004acb5594730mr388100eds.25.1677520023511;
        Mon, 27 Feb 2023 09:47:03 -0800 (PST)
X-Google-Smtp-Source: AK7set8WzOLBRzIyTJbDWdyzOaUVUKqxYzzJ4RMP2QlEID77FeD11dpYYOTOH1ruwho5LhOU6Ug/vw==
X-Received: by 2002:a50:ef08:0:b0:4ac:b559:4730 with SMTP id m8-20020a50ef08000000b004acb5594730mr388084eds.25.1677520023217;
        Mon, 27 Feb 2023 09:47:03 -0800 (PST)
Received: from redhat.com ([2.52.141.194])
        by smtp.gmail.com with ESMTPSA id x2-20020a50d602000000b004acd14ab4dfsm3403200edi.41.2023.02.27.09.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 09:47:02 -0800 (PST)
Date:   Mon, 27 Feb 2023 12:46:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     =?utf-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jasowang@redhat.com,
        =?utf-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Subject: Re: [PATCH v2] net/packet: support mergeable feautre of virtio
Message-ID: <20230227124131-mutt-send-email-mst@kernel.org>
References: <1677497625-351024-1-git-send-email-amy.saq@antgroup.com>
 <63fcdaf7e3e9d_1684422084b@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63fcdaf7e3e9d_1684422084b@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

typo in $subj

On Mon, Feb 27, 2023 at 11:31:51AM -0500, Willem de Bruijn wrote:
> 沈安琪(凛玥) wrote:
> > From: Jianfeng Tan <henry.tjf@antgroup.com>
> > 
> > Packet sockets, like tap, can be used as the backend for kernel vhost.
> > In packet sockets, virtio net header size is currently hardcoded to be
> > the size of struct virtio_net_hdr, which is 10 bytes; however, it is not
> > always the case: some virtio features, such as mrg_rxbuf, need virtio
> > net header to be 12-byte long.
> > 
> > Mergeable buffers, as a virtio feature, is worthy to support: packets

worthy of

> > that larger than one-mbuf size will be dropped in vhost worker's

are larger

> > handle_rx if mrg_rxbuf feature is not used, but large packets
> > cannot be avoided and increasing mbuf's size is not economical.
> > 
> > With this virtio feature enabled, packet sockets with hardcoded 10-byte

you mean with this feature enabled in guest but without support in tap


> > virtio net header will parse mac head incorrectly in packet_snd by taking
> > the last two bytes of virtio net header as part of mac header as well.

as well as what?

> > This incorrect mac header parsing will cause packet be dropped due to

to be dropped

> > invalid ether head checking in later under-layer device packet receiving.
> > 
> > By adding extra field vnet_hdr_sz with utilizing holes in struct
> > packet_sock to record current using virtio net header size and supporting

currently used

> > extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
> > sockets can know the exact length of virtio net header that virtio user
> > gives.
> > In packet_snd, tpacket_snd and packet_recvmsg, instead of using hardcode

hardcoded

> > virtio net header size, it can get the exact vnet_hdr_sz from corresponding
> > packet_sock, and parse mac header correctly based on this information to
> > avoid the packets being mistakenly dropped.
> > 
> > Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> > Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> > Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> 
> net-next is closed


> > @@ -2311,7 +2312,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
> >  				       (maclen < 16 ? 16 : maclen)) +
> >  				       po->tp_reserve;
> >  		if (po->has_vnet_hdr) {
> > -			netoff += sizeof(struct virtio_net_hdr);
> > +			netoff += po->vnet_hdr_sz;
> >  			do_vnet = true;
> >  		}
> >  		macoff = netoff - maclen;
> > @@ -2552,16 +2553,23 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
> >  }
> >  
> >  static int packet_snd_vnet_parse(struct msghdr *msg, size_t *len,
> > -				 struct virtio_net_hdr *vnet_hdr)
> > +				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
> >  {
> > -	if (*len < sizeof(*vnet_hdr))
> > +	int ret;
> > +
> > +	if (*len < vnet_hdr_sz)
> >  		return -EINVAL;
> > -	*len -= sizeof(*vnet_hdr);
> > +	*len -= vnet_hdr_sz;
> >  
> >  	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->msg_iter))
> >  		return -EFAULT;
> >  
> > -	return __packet_snd_vnet_parse(vnet_hdr, *len);
> > +	ret = __packet_snd_vnet_parse(vnet_hdr, *len);
> > +
> > +	/* move iter to point to the start of mac header */
> > +	if (ret == 0)
> > +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_net_hdr));
> > +	return ret;
> 
> Let's make the error path the exception
> 
>         if (ret)
>                 return ret;
> 
> And maybe avoid calling iov_iter_advance if vnet_hdr_sz == sizeof(*vnet_hdr)
> 
> >  	case PACKET_VNET_HDR:
> > +	case PACKET_VNET_HDR_SZ:
> >  	{
> >  		int val;
> > +		int hdr_len = 0;
> >  
> >  		if (sock->type != SOCK_RAW)
> >  			return -EINVAL;
> > @@ -3931,11 +3945,23 @@ static void packet_flush_mclist(struct sock *sk)
> >  		if (copy_from_sockptr(&val, optval, sizeof(val)))
> >  			return -EFAULT;
> >  
> > +		if (optname == PACKET_VNET_HDR_SZ) {
> > +			if (val != sizeof(struct virtio_net_hdr) &&
> > +			    val != sizeof(struct virtio_net_hdr_mrg_rxbuf))
> > +				return -EINVAL;
> > +			hdr_len = val;
> > +		}
> > +
> 
>     } else {
>             hdr_len = sizeof(struct virtio_net_hdr);
>     }
> 
> >  		lock_sock(sk);
> >  		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
> >  			ret = -EBUSY;
> >  		} else {
> > -			po->has_vnet_hdr = !!val;
> > +			if (optname == PACKET_VNET_HDR) {
> > +				po->has_vnet_hdr = !!val;
> > +				if (po->has_vnet_hdr)
> > +					hdr_len = sizeof(struct virtio_net_hdr);
> > +			}
> > +			po->vnet_hdr_sz = hdr_len;
> 
> then this is not needed
> >  			ret = 0;
> >  		}
> >  		release_sock(sk);
> > @@ -4070,6 +4096,9 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
> >  	case PACKET_VNET_HDR:
> >  		val = po->has_vnet_hdr;
> >  		break;
> > +	case PACKET_VNET_HDR_SZ:
> > +		val = po->vnet_hdr_sz;
> > +		break;
> >  	case PACKET_VERSION:
> >  		val = po->tp_version;
> >  		break;
> > diff --git a/net/packet/internal.h b/net/packet/internal.h
> > index 48af35b..e27b47d 100644
> > --- a/net/packet/internal.h
> > +++ b/net/packet/internal.h
> > @@ -121,7 +121,8 @@ struct packet_sock {
> >  				origdev:1,
> >  				has_vnet_hdr:1,
> >  				tp_loss:1,
> > -				tp_tx_has_off:1;
> > +				tp_tx_has_off:1,
> > +				vnet_hdr_sz:8;	/* vnet header size should use */
> 
> has_vnet_hdr is no longer needed when adding vnet_hdr_sz. removing that simplifies the code
> 
> drop the comment. That is quite self explanatory from the variable name.

besides, it's agrammatical :)

> >  	int			pressure;
> >  	int			ifindex;	/* bound device		*/
> >  	__be16			num;
> > -- 
> > 1.8.3.1
> > 
> 

