Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00C324B0B1
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgHTIC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:02:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbgHTICc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 04:02:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597910551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kSXsBQ5OEyJkpTqBToWWGkoAkU72idNnOKV54rgMr7Y=;
        b=ZducRmJG27cUNx/466pBAID52hVXacI1+Eg1J9aSILMRZcnYueYRhHGvOC/kIOWuvR9bI2
        Y9YamCT++jKYLpuQe4qR+y2Xj3S8xK8DZzn9QDdmjg3OwyXC11E70owvXjdsjtG3ekZm0C
        K3hzOCbb53UXd4BK2TD4TpROiTRbeGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-bK0Q6Aj_NkCkr_9QLdF8EQ-1; Thu, 20 Aug 2020 04:02:27 -0400
X-MC-Unique: bK0Q6Aj_NkCkr_9QLdF8EQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D3AE1885D82;
        Thu, 20 Aug 2020 08:02:25 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0A125C88B;
        Thu, 20 Aug 2020 08:02:16 +0000 (UTC)
Date:   Thu, 20 Aug 2020 10:02:15 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com,
        sameehj@amazon.com, kuba@kernel.org, brouer@redhat.com
Subject: Re: [PATCH net-next 3/6] net: mvneta: update mb bit before passing
 the xdp buffer to eBPF layer
Message-ID: <20200820100215.1b93464f@carbon>
In-Reply-To: <08f8656e906ff69bd30915a6a37a01d5f0422194.1597842004.git.lorenzo@kernel.org>
References: <cover.1597842004.git.lorenzo@kernel.org>
        <08f8656e906ff69bd30915a6a37a01d5f0422194.1597842004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 15:13:48 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> XDP remote drivers if this is a "non-linear" XDP buffer
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 832bbb8b05c8..36a3defa63fa 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2170,11 +2170,14 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  	       struct bpf_prog *prog, struct xdp_buff *xdp,
>  	       u32 frame_sz, struct mvneta_stats *stats)
>  {
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
>  	unsigned int len, data_len, sync;
>  	u32 ret, act;
>  
>  	len = xdp->data_end - xdp->data_hard_start - pp->rx_offset_correction;
>  	data_len = xdp->data_end - xdp->data;
> +
> +	xdp->mb = !!sinfo->nr_frags;
>  	act = bpf_prog_run_xdp(prog, xdp);

Reading the memory sinfo->nr_frags could be a performance issue for our
baseline case of no-multi-buffer.  As you are reading a cache-line that
you don't need to (and driver have not touch yet).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

