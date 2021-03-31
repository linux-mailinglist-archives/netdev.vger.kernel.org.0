Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B0235015F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhCaNiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 09:38:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235701AbhCaNiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 09:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617197897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8YS4poPAZCHByMf0w+dOhsWCqsrYJ+hqPkfQ8CKmtvY=;
        b=JqRl9U2ZqrtNdHVLqFNjnbyO/6eYNKIZSSEQQv0cY0Fuvbzb0otY5e1/24eSryirrr4a6b
        Eexf9osgJF9UXzfSeK3Ky4X+QitpDMYG9Z3x4yHMUkzdTIgZFovk2ww+/UkyvO7JPF0I4w
        p3raOVRKaibxktvDHjgIesDq+snz9yc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-aBp1IZDWPqeqKr_xPiJwCw-1; Wed, 31 Mar 2021 09:38:13 -0400
X-MC-Unique: aBp1IZDWPqeqKr_xPiJwCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C21A84B9A2;
        Wed, 31 Mar 2021 13:38:11 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C59460C5A;
        Wed, 31 Mar 2021 13:38:04 +0000 (UTC)
Date:   Wed, 31 Mar 2021 15:38:03 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/1] xdp: fix xdp_return_frame() kernel BUG throw
 for page_pool memory model
Message-ID: <20210331153803.38fb83de@carbon>
In-Reply-To: <20210331132503.15926-1-boon.leong.ong@intel.com>
References: <20210331132503.15926-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Mar 2021 21:25:03 +0800
Ong Boon Leong <boon.leong.ong@intel.com> wrote:

> xdp_return_frame() may be called outside of NAPI context to return
> xdpf back to page_pool. xdp_return_frame() calls __xdp_return() with
> napi_direct = false. For page_pool memory model, __xdp_return() calls
> xdp_return_frame_no_direct() unconditionally and below false negative
> kernel BUG throw happened under preempt-rt build:
> 
> [  430.450355] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/3884
> [  430.451678] caller is __xdp_return+0x1ff/0x2e0
> [  430.452111] CPU: 0 PID: 3884 Comm: modprobe Tainted: G     U      E     5.12.0-rc2+ #45
> 
> Changes in v2:
>  - This patch fixes the issue by making xdp_return_frame_no_direct() is
>    only called if napi_direct = true, as recommended for better by
>    Jesper Dangaard Brouer. Thanks!
> 
> Fixes: 2539650fadbf ("xdp: Helpers for disabling napi_direct of xdp_return_frame")
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> ---
>  net/core/xdp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 05354976c1fc..858276e72c68 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -350,7 +350,8 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
>  		/* mem->id is valid, checked in xdp_rxq_info_reg_mem_model() */
>  		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
>  		page = virt_to_head_page(data);
> -		napi_direct &= !xdp_return_frame_no_direct();
> +		if (napi_direct && xdp_return_frame_no_direct())
> +			napi_direct = false;
>  		page_pool_put_full_page(xa->page_pool, page, napi_direct);
>  		rcu_read_unlock();
>  		break;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

