Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78577375499
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 15:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhEFNWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 09:22:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:10337 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233521AbhEFNWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 09:22:03 -0400
IronPort-SDR: 1qH6MEVIW1gAxtx2d4efHl5ILZSZecKMICOaXrlG5CLcfV9vIxRBERtUc2EO42hLTcYaNXltck
 bZ3HWG+CUAGw==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="185931916"
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="185931916"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 06:21:04 -0700
IronPort-SDR: HokasF0R6+a764meRX7gHb+y1YCkNe5C+nSQd3vLZ2pI0srsSryW5UKqcQmLznOs03p+jUaxGc
 gHxN7/83oYGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="434346838"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 06 May 2021 06:21:02 -0700
Date:   Thu, 6 May 2021 15:09:07 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf] samples/bpf: consider frame size in tx_only of
 xdpsock sample
Message-ID: <20210506130907.GA5728@ranger.igk.intel.com>
References: <20210506124349.6666-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506124349.6666-1-magnus.karlsson@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 02:43:49PM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix the tx_only micro-benchmark in xdpsock to take frame size into
> consideration. It was hardcoded to the default value of frame_size
> which is 4K. Changing this on the command line to 2K made half of the
> packets illegal as they were outside the umem and were therefore
> discarded by the kernel.
> 
> Fixes: 46738f73ea4f ("samples/bpf: add use of need_wakeup flag in xdpsock")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  samples/bpf/xdpsock_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index aa696854be78..53e300f860bb 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -1255,7 +1255,7 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
>  	for (i = 0; i < batch_size; i++) {
>  		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
>  								  idx + i);
> -		tx_desc->addr = (*frame_nb + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
> +		tx_desc->addr = (*frame_nb + i) * opt_xsk_frame_size;
>  		tx_desc->len = PKT_SIZE;
>  	}
>  
> 
> base-commit: 9683e5775c75097c46bd24e65411b16ac6c6cbb3
> -- 
> 2.29.0
> 
