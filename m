Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF2091711DB
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgB0IBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:01:08 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32800 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726999AbgB0IBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 03:01:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582790467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Snk15xKUMrdySmfwWraoLwyhXgJAGndOaWgXe+ZNgXE=;
        b=cKFcdvUCoEAXcqcc80cnWoWSJIxytzQCak0jV2iRTquhTeyO8RkO+XEWsGti072LkNTqqx
        jzwMK/XC6kje8gN7zYse4de8WTgRqM8TCgQna9RFHpe6ahSI/3GdeRXpZtSFD7Mf3Hi6TV
        jFwHgGKozmp6fVBQWuiPOCEYPmm/ARk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-AyHGgI8uOsCl6T5oLf35YA-1; Thu, 27 Feb 2020 03:01:03 -0500
X-MC-Unique: AyHGgI8uOsCl6T5oLf35YA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3254C801E6D;
        Thu, 27 Feb 2020 08:01:01 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB28490F5B;
        Thu, 27 Feb 2020 08:00:47 +0000 (UTC)
Date:   Thu, 27 Feb 2020 09:00:46 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>,
        brouer@redhat.com
Subject: Re: [PATCH RFC v4 bpf-next 03/11] xdp: Add xdp_txq_info to xdp_buff
Message-ID: <20200227090046.3e3177b3@carbon>
In-Reply-To: <20200227032013.12385-4-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
        <20200227032013.12385-4-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020 20:20:05 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dahern@digitalocean.com>
> 
> Add xdp_txq_info as the Tx counterpart to xdp_rxq_info. At the
> moment only the device is added. Other fields (queue_index)
> can be added as use cases arise.
> 
> From a UAPI perspective, egress_ifindex is a union with ingress_ifindex
> since only one applies based on where the program is attached.
> 
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  include/net/xdp.h        |  5 +++++
>  include/uapi/linux/bpf.h |  6 ++++--
>  net/core/filter.c        | 27 +++++++++++++++++++--------
>  3 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 40c6d3398458..5584b9db86fe 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -63,6 +63,10 @@ struct xdp_rxq_info {
>  	struct xdp_mem_info mem;
>  } ____cacheline_aligned; /* perf critical, avoid false-sharing */
>  
> +struct xdp_txq_info {
> +	struct net_device *dev;
> +};
> +
>  struct xdp_buff {
>  	void *data;
>  	void *data_end;
> @@ -70,6 +74,7 @@ struct xdp_buff {
>  	void *data_hard_start;
>  	unsigned long handle;
>  	struct xdp_rxq_info *rxq;
> +	struct xdp_txq_info *txq;
>  };
>  
>  struct xdp_frame {
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7850f8683b81..5e3f8aefad41 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3334,8 +3334,10 @@ struct xdp_md {
>  	__u32 data;
>  	__u32 data_end;
>  	__u32 data_meta;
> -	/* Below access go through struct xdp_rxq_info */
> -	__u32 ingress_ifindex; /* rxq->dev->ifindex */
> +	union {
> +		__u32 ingress_ifindex; /* rxq->dev->ifindex */
> +		__u32 egress_ifindex;  /* txq->dev->ifindex */
> +	};

Are we sure it is wise to "union share" (struct) xdp_md as the
XDP-context in the XDP programs, with different expected_attach_type?
As this allows the XDP-programmer to code an EGRESS program that access
ctx->ingress_ifindex, this will under the hood be translated to
ctx->egress_ifindex, because from the compilers-PoV this will just be an
offset.

We are setting up the XDP-programmer for a long debugging session, as
she will be expecting to read 'ingress_ifindex', but will be getting
'egress_ifindex'.  (As the compiler cannot warn her, and it is also
correct seen from the verifier).


>  	__u32 rx_queue_index;  /* rxq->queue_index  */

So, the TX program can still read 'rx_queue_index', is this wise?
(It should be easy to catch below and reject).


>  };
>  
> diff --git a/net/core/filter.c b/net/core/filter.c
> index c7cc98c55621..d1c65dccd671 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7716,14 +7716,25 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>  				      offsetof(struct xdp_buff, data_end));
>  		break;
>  	case offsetof(struct xdp_md, ingress_ifindex):
> -		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
> -				      si->dst_reg, si->src_reg,
> -				      offsetof(struct xdp_buff, rxq));
> -		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_rxq_info, dev),
> -				      si->dst_reg, si->dst_reg,
> -				      offsetof(struct xdp_rxq_info, dev));
> -		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
> -				      offsetof(struct net_device, ifindex));
> +		if (prog->expected_attach_type == BPF_XDP_EGRESS) {
> +			*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, txq),
> +					      si->dst_reg, si->src_reg,
> +					      offsetof(struct xdp_buff, txq));
> +			*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_txq_info, dev),
> +					      si->dst_reg, si->dst_reg,
> +					      offsetof(struct xdp_txq_info, dev));
> +			*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
> +					      offsetof(struct net_device, ifindex));
> +		} else {
> +			*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
> +					      si->dst_reg, si->src_reg,
> +					      offsetof(struct xdp_buff, rxq));
> +			*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_rxq_info, dev),
> +					      si->dst_reg, si->dst_reg,
> +					      offsetof(struct xdp_rxq_info, dev));
> +			*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
> +					      offsetof(struct net_device, ifindex));
> +		}
>  		break;
>  	case offsetof(struct xdp_md, rx_queue_index):
>  		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),

We can catch and disallow access to rx_queue_index from expected_attach_type
BPF_XDP_EGRESS, here.  But then we are adding more code to handle/separate
egress from normal RX/ingress.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

