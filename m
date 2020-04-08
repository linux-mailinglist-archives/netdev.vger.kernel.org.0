Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28DD01A281F
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 19:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgDHRxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 13:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbgDHRxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 13:53:42 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14CC820768;
        Wed,  8 Apr 2020 17:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586368421;
        bh=cLjn5vfTDDKKNYOL3rSqAKNDWVQxrE1njhLS4MKX36c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rEuMmp2uyNXvVIxtkHfjW/+sJABw3h8g+RDv1Z+nFpWRL3gegrH9nKTb8HkW1ERrI
         cdeO91dq0BFRUiZ7+uKvuGCvh66/9dzO2I11qS1HhU+ci4xCOjSOZNih8Qlz4oxG/7
         hkolgU1ytVVaHUphvzQLtPwQR5sX1/Yu7STHcjH8=
Date:   Wed, 8 Apr 2020 10:53:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Message-ID: <20200408105339.7d8d4e59@kicinski-fedora-PC1C0HJN>
In-Reply-To: <158634663936.707275.3156718045905620430.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634663936.707275.3156718045905620430.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Apr 2020 13:50:39 +0200 Jesper Dangaard Brouer wrote:
> XDP have evolved to support several frame sizes, but xdp_buff was not
> updated with this information. The frame size (frame_sz) member of
> xdp_buff is introduced to know the real size of the memory the frame is
> delivered in.
> 
> When introducing this also make it clear that some tailroom is
> reserved/required when creating SKBs using build_skb().
> 
> It would also have been an option to introduce a pointer to
> data_hard_end (with reserved offset). The advantage with frame_sz is
> that (like rxq) drivers only need to setup/assign this value once per
> NAPI cycle. Due to XDP-generic (and some drivers) it's not possible to
> store frame_sz inside xdp_rxq_info, because it's varies per packet as it
> can be based/depend on packet length.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/net/xdp.h |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 40c6d3398458..99f4374f6214 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -6,6 +6,8 @@
>  #ifndef __LINUX_NET_XDP_H__
>  #define __LINUX_NET_XDP_H__
>  
> +#include <linux/skbuff.h> /* skb_shared_info */
> +
>  /**
>   * DOC: XDP RX-queue information
>   *
> @@ -70,8 +72,23 @@ struct xdp_buff {
>  	void *data_hard_start;
>  	unsigned long handle;
>  	struct xdp_rxq_info *rxq;
> +	u32 frame_sz; /* frame size to deduct data_hard_end/reserved tailroom*/

Perhaps

/* length of packet buffer, starting at data_hard_start */

?

>  };
>  
> +/* Reserve memory area at end-of data area.

I wouldn't say this reserves anything. It just computes the end
pointer, no?

> + *
> + * This macro reserves tailroom in the XDP buffer by limiting the
> + * XDP/BPF data access to data_hard_end.  Notice same area (and size)
> + * is used for XDP_PASS, when constructing the SKB via build_skb().
> + */
> +#define xdp_data_hard_end(xdp)				\
> +	((xdp)->data_hard_start + (xdp)->frame_sz -	\
> +	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))

I think it should be said somewhere that the drivers are expected to
DMA map memory up to xdp_data_hard_end(xdp).

> +
> +/* Like skb_shinfo */
> +#define xdp_shinfo(xdp)	((struct skb_shared_info *)(xdp_data_hard_end(xdp)))
> +// XXX: Above likely belongs in later patch
> +
>  struct xdp_frame {
>  	void *data;
>  	u16 len;
> 
> 

