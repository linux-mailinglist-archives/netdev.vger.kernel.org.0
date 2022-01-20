Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3D949495B
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 09:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359174AbiATIZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 03:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiATIZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 03:25:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EE1C061574;
        Thu, 20 Jan 2022 00:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 719B2B81D0A;
        Thu, 20 Jan 2022 08:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94134C340E0;
        Thu, 20 Jan 2022 08:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642667102;
        bh=J7fp2W6HYZjVZNGtMZQ54GtqC/k7L5nnzFcph+ZWpc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j8W96MgPfh/LY4xQc9Dh4CPmsBLaKLSMhwZbLNuqQiEgJUXnJsWV+J1AhWYoaLmRS
         LcIBmoP3+JXxcdETcAJ7WVNjEMr2ZTu5P7iTNUQy/1ziJTwpXu6m1jGck2YXOAO0yk
         P3Y/SvTgXWddaeL3FmWNV3CjtPhHCbjVXrfiVjNkF+ocktvEYZjQaSwB7P3kCieZHa
         ke0BNGPTvEYwJv8KYoaRXNugxjRRF6Com5ul52+qOz64LHDamv/sK6NB7HDG4TGL4n
         mM5BlpbCITRn+Lg5h/78sG2BAMY/2iS3WLzXb9GmKQeRB+aHLbCOAYLVg/bgE0nSSy
         38XpkYvBsW+eQ==
Date:   Thu, 20 Jan 2022 10:24:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net/smc: Introduce receive queue flow
 control support
Message-ID: <YekcWYwg399vR18R@unreal>
References: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120065140.5385-1-guangguan.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 02:51:40PM +0800, Guangguan Wang wrote:
> This implement rq flow control in smc-r link layer. QPs
> communicating without rq flow control, in the previous
> version, may result in RNR (reveive not ready) error, which
> means when sq sends a message to the remote qp, but the
> remote qp's rq has no valid rq entities to receive the message.
> In RNR condition, the rdma transport layer may retransmit
> the messages again and again until the rq has any entities,
> which may lower the performance, especially in heavy traffic.
> Using credits to do rq flow control can avoid the occurrence
> of RNR.
> 
> Test environment:
> - CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4.
> - redis benchmark 6.2.3 and redis server 6.2.3.
> - redis server: redis-server --save "" --appendonly no
>   --protected-mode no --io-threads 7 --io-threads-do-reads yes
> - redis client: redis-benchmark -h 192.168.26.36 -q -t set,get
>   -P 1 --threads 7 -n 2000000 -c 200 -d 10
> 
>  Before:
>  SET: 205229.23 requests per second, p50=0.799 msec
>  GET: 212278.16 requests per second, p50=0.751 msec
> 
>  After:
>  SET: 623674.69 requests per second, p50=0.303 msec
>  GET: 688326.00 requests per second, p50=0.271 msec
> 
> The test of redis-benchmark shows that more than 3X rps
> improvement after the implementation of rq flow control.
> 
> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> ---
>  net/smc/af_smc.c   | 12 ++++++
>  net/smc/smc_cdc.c  | 10 ++++-
>  net/smc/smc_cdc.h  |  3 +-
>  net/smc/smc_clc.c  |  3 ++
>  net/smc/smc_clc.h  |  3 +-
>  net/smc/smc_core.h | 17 ++++++++-
>  net/smc/smc_ib.c   |  6 ++-
>  net/smc/smc_llc.c  | 92 +++++++++++++++++++++++++++++++++++++++++++++-
>  net/smc/smc_llc.h  |  5 +++
>  net/smc/smc_wr.c   | 30 ++++++++++++---
>  net/smc/smc_wr.h   | 54 ++++++++++++++++++++++++++-
>  11 files changed, 222 insertions(+), 13 deletions(-)

<...>

> +		// set peer rq credits watermark, if less than init_credits * 2/3,
> +		// then credit announcement is needed.

<...>

> +		// set peer rq credits watermark, if less than init_credits * 2/3,
> +		// then credit announcement is needed.

<...>

> +	// credits have already been announced to peer

<...>

> +	// set local rq credits high watermark to lnk->wr_rx_cnt / 3,
> +	// if local rq credits more than high watermark, announcement is needed.

<...>

> +// get one tx credit, and peer rq credits dec

<...>

> +// put tx credits, when some failures occurred after tx credits got
> +// or receive announce credits msgs
> +static inline void smc_wr_tx_put_credits(struct smc_link *link, int credits, bool wakeup)

<...>

> +// to check whether peer rq credits is lower than watermark.
> +static inline int smc_wr_tx_credits_need_announce(struct smc_link *link)

<...>

> +// get local rq credits and set credits to zero.
> +// may called when announcing credits
> +static inline int smc_wr_rx_get_credits(struct smc_link *link)

Please try to use C-style comments.

Thanks
