Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F304744EF
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhLNO2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:28:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:36725 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232759AbhLNO2C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:28:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639492081; x=1671028081;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZlC7Y4STCxgCOWqDwiqOXFzQ9KM8excQeu/76ntQS9g=;
  b=PIn6BP983V7YTBIdHWlRs0QDMCjqpxNZTzgyhxZaeki/mCiholmfRGxz
   6vRm+VIo2Z1z86Gjs6U37v6V1Hy/gVeVQ6yAOeU4/ch04EYaQNQCuwJPJ
   FIlNZlsy9cXcWeWSA38XhLQqaLAimS2XFeL3kIBmPz9UwApESoNcROhHR
   iiUOAPkCGgRCUO+FYNGEPIkyPnhoY93J6wc7j5CDcgcNNTf7GlN8IdxiN
   9d626wwS5MRn1qxD89RQDuNbSYaS28RCf2ND5F9DPfZlDiHnfTl5meo5n
   0daJbptvxU4k5qliV7SygGqiYyANZFT7oQd+CzZpm8qf9GIV7Fq+KoGXh
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="325263013"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="325263013"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 06:28:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="518265592"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 14 Dec 2021 06:27:59 -0800
Date:   Tue, 14 Dec 2021 15:27:58 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] xsk: add test for tx_writeable to batched path
Message-ID: <Ybip7mXZuCXYTlwn@boxer>
References: <20211214102647.7734-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214102647.7734-1-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:26:47AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Add a test for the tx_writeable condition to the batched Tx processing
> path. This test is in the skb and non-batched code paths but not in the
> batched code path. So add it there. This test makes sure that a
> process is not woken up until there are a sufficiently large number of
> free entries in the Tx ring. Currently, any driver using the batched
> interface will be woken up even if there is only one free entry,
> impacting performance negatively.

I gave this patch a shot on ice driver with the Tx batching patch that i'm
about to send which is using the xsk_tx_peek_release_desc_batch(). I ran
the 2 core setup with no busy poll and it turned out that this change has
a negative impact on performance - it degrades by 5%.

After a short chat with Magnus he said it's due to the touch to the global
state of a ring that xsk_tx_writeable() is doing.

So maintainers, please do not apply this yet, we'll come up with a
solution.

Also, should this be sent to bpf tree (not bpf-next) ?

Thanks!

> 
> Fixes: 3413f04141aa ("xsk: Change the tx writeable condition")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  net/xdp/xsk.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 28ef3f4465ae..3772fcaa76ed 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -392,7 +392,8 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
>  
>  	xskq_cons_release_n(xs->tx, nb_pkts);
>  	__xskq_cons_release(xs->tx);
> -	xs->sk.sk_write_space(&xs->sk);
> +	if (xsk_tx_writeable(xs))
> +		xs->sk.sk_write_space(&xs->sk);
>  
>  out:
>  	rcu_read_unlock();
> 
> base-commit: d27a662290963a1cde26cdfdbac71a546c06e94a
> -- 
> 2.29.0
> 
