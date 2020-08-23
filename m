Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D20224ED74
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 16:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgHWOI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 10:08:56 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:15347 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgHWOIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 10:08:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598191734; x=1629727734;
  h=references:from:to:cc:subject:in-reply-to:message-id:
   date:mime-version;
  bh=ujoQyCDZXMHJyMkP35pzx/uR+5y4tdGRIdYgxPnMQj8=;
  b=muDBvW5WgOK3O7ikZ1psRqtw8hEgvTGjBVYfk+lsHt2PPLMhm01tq4Lq
   +FAQBlhLRP5zBDlooR5GB8Sh9uZu7fJooV1hiyq/UPaFdHjunfIyJ/K75
   owbR3Ha3lIaJNXVWaITHGnr1YeBtHutzxQ7p9ojqIA9PVgikfvtZoLswX
   8=;
X-IronPort-AV: E=Sophos;i="5.76,345,1592870400"; 
   d="scan'208";a="70126696"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 23 Aug 2020 14:08:50 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 22D8CA11E2;
        Sun, 23 Aug 2020 14:08:47 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.55) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 23 Aug 2020 14:08:43 +0000
References: <cover.1597842004.git.lorenzo@kernel.org> <c2665f369ede07328bbf7456def2e2025b9b320e.1597842004.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <lorenzo.bianconi@redhat.com>,
        <brouer@redhat.com>, <echaudro@redhat.com>, <sameehj@amazon.com>,
        <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/6] xdp: introduce mb in xdp_buff/xdp_frame
In-Reply-To: <c2665f369ede07328bbf7456def2e2025b9b320e.1597842004.git.lorenzo@kernel.org>
Message-ID: <pj41zlft8dsbdt.fsf@u68c7b5b1d2d758.ant.amazon.com>
Date:   Sun, 23 Aug 2020 17:08:30 +0300
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D30UWB003.ant.amazon.com (10.43.161.83) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to 
> specify
> if shared_info area has been properly initialized for non-linear
> xdp buffers
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h | 8 ++++++--
>  net/core/xdp.c    | 1 +
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 3814fb631d52..42f439f9fcda 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -72,7 +72,8 @@ struct xdp_buff {
>  	void *data_hard_start;
>  	struct xdp_rxq_info *rxq;
>  	struct xdp_txq_info *txq;
> -	u32 frame_sz; /* frame size to deduce 
> data_hard_end/reserved tailroom*/
> +	u32 frame_sz:31; /* frame size to deduce 
> data_hard_end/reserved tailroom*/
> +	u32 mb:1; /* xdp non-linear buffer */
>  };
>  
>  /* Reserve memory area at end-of data area.
> @@ -96,7 +97,8 @@ struct xdp_frame {
>  	u16 len;
>  	u16 headroom;
>  	u32 metasize:8;
> -	u32 frame_sz:24;
> +	u32 frame_sz:23;
> +	u32 mb:1; /* xdp non-linear frame */

Although this issue wasn't introduced with this patch, why not 
make frame_sz field to be the same size in xdp_buff and xdp_frame 
?

thanks,
Shay
>  	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue 
>  time,
>  	 * while mem info is valid on remote CPU.
>  	 */
> @@ -141,6 +143,7 @@ void xdp_convert_frame_to_buff(struct 
> xdp_frame *frame, struct xdp_buff *xdp)
>  	xdp->data_end = frame->data + frame->len;
>  	xdp->data_meta = frame->data - frame->metasize;
>  	xdp->frame_sz = frame->frame_sz;
> +	xdp->mb = frame->mb;
>  }
>  
>  static inline
> @@ -167,6 +170,7 @@ int xdp_update_frame_from_buff(struct 
> xdp_buff *xdp,
>  	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
>  	xdp_frame->metasize = metasize;
>  	xdp_frame->frame_sz = xdp->frame_sz;
> +	xdp_frame->mb = xdp->mb;
>  
>  	return 0;
>  }
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 48aba933a5a8..884f140fc3be 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -454,6 +454,7 @@ struct xdp_frame 
> *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
>  	xdpf->headroom = 0;
>  	xdpf->metasize = metasize;
>  	xdpf->frame_sz = PAGE_SIZE;
> +	xdpf->mb = xdp->mb;
>  	xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
>  
>  	xsk_buff_free(xdp);

