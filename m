Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE31A36EB67
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 15:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbhD2NiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 09:38:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233602AbhD2Nh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 09:37:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619703433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oDboRQkOzoCD9h6z3QO2oVzBnaw62Fl9cTjPsbU5PWo=;
        b=Fdo34O9QXSHI4/QtS3ACSJDIdsoiscQgU4MOLbkm9Q26BQhrbGpmZf2eqCv/wA3gS9qAvG
        GQBUbimQI3ckWpCad6X8yDx/VmvR/1Cyf3gXTYn3E44oDlXb3NStdVCaIz+/gYpftNT6WF
        oTk6y7+MUwVIXSp35DsoXSp9y7pZ6l4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-thv4uJWtNTeCgLW6A6SJmA-1; Thu, 29 Apr 2021 09:37:10 -0400
X-MC-Unique: thv4uJWtNTeCgLW6A6SJmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 856F9102C803;
        Thu, 29 Apr 2021 13:37:08 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B1E660C17;
        Thu, 29 Apr 2021 13:36:30 +0000 (UTC)
Date:   Thu, 29 Apr 2021 15:36:29 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, brouer@redhat.com
Subject: Re: [PATCH v8 bpf-next 01/14] xdp: introduce mb in
 xdp_buff/xdp_frame
Message-ID: <20210429153629.1fef2386@carbon>
In-Reply-To: <eef58418ab78408f4a5fbd3d3b0071f30ece2ccd.1617885385.git.lorenzo@kernel.org>
References: <cover.1617885385.git.lorenzo@kernel.org>
        <eef58418ab78408f4a5fbd3d3b0071f30ece2ccd.1617885385.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Apr 2021 14:50:53 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer data structure
> in order to specify if this is a linear buffer (mb = 0) or a multi-buffer
> frame (mb = 1). In the latter case the shared_info area at the end of the
> first buffer will be properly initialized to link together subsequent
> buffers.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index a5bc214a49d9..842580a61563 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -73,7 +73,10 @@ struct xdp_buff {
>  	void *data_hard_start;
>  	struct xdp_rxq_info *rxq;
>  	struct xdp_txq_info *txq;
> -	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> +	u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved
> +			  * tailroom
> +			  */
> +	u32 mb:1; /* xdp non-linear buffer */
>  };
>  
>  static __always_inline void
> @@ -81,6 +84,7 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
>  {
>  	xdp->frame_sz = frame_sz;
>  	xdp->rxq = rxq;
> +	xdp->mb = 0;
>  }
>  
>  static __always_inline void
> @@ -116,7 +120,8 @@ struct xdp_frame {
>  	u16 len;
>  	u16 headroom;
>  	u32 metasize:8;
> -	u32 frame_sz:24;
> +	u32 frame_sz:23;
> +	u32 mb:1; /* xdp non-linear frame */
>  	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
>  	 * while mem info is valid on remote CPU.
>  	 */

So, it seems that these bitfield's are the root-cause of the
performance regression.  Credit to Alexei whom wisely already point
this out[1] in V2 ;-)

[1] https://lore.kernel.org/netdev/20200904010705.jm6dnuyj3oq4cpjd@ast-mbp.dhcp.thefacebook.com/


> @@ -179,6 +184,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
>  	xdp->data_end = frame->data + frame->len;
>  	xdp->data_meta = frame->data - frame->metasize;
>  	xdp->frame_sz = frame->frame_sz;
> +	xdp->mb = frame->mb;
>  }
>  
>  static inline
> @@ -205,6 +211,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
>  	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
>  	xdp_frame->metasize = metasize;
>  	xdp_frame->frame_sz = xdp->frame_sz;
> +	xdp_frame->mb = xdp->mb;
>  
>  	return 0;
>  }

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

