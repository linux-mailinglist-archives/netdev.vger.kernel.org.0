Return-Path: <netdev+bounces-1181-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 674836FC82B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:43:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3773528130D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510F8182D8;
	Tue,  9 May 2023 13:43:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B10E182D1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318EDC433EF;
	Tue,  9 May 2023 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683639796;
	bh=wAyj0pfH0D6dPu3vwviP23w1K4Snew4vfueLBpD7evU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JmNfpXc/WQwNWK/wVWSUGvBKFC26Vy9UCPyWwLVeIKyJ6pHVhP1myzdS6dQuy/wV0
	 lY7mLWdJIT0PFT1v5jnKEHxM5VhtFyGsErpEbIUDmPPg5bD8p6FKaLg3KVUR/Tohcf
	 QjEuEWZZ+kHpYki6pmTX7lQv4RJGE7T0SFSc/Q3OiLsZ9yKax99/f1qQEhfDggxgMU
	 DJE9PlEeEXdyhZywtR/t2KFyjo7ApljYcHkPNtZPQ89DOq8VxOwIaaKyAaCRYB9QIv
	 XWGELz913XJ5yDJV9hRQ+pZdlSnbImHVsWNaPAi+YGA1qVLcncIPTBK+Ld4QjyeGWL
	 TfM9B+el0ruEA==
Date: Tue, 9 May 2023 16:43:11 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/2] net: introduce and use
 skb_frag_fill_page_desc()
Message-ID: <20230509134311.GN38143@unreal>
References: <20230509114337.21005-1-linyunsheng@huawei.com>
 <20230509114337.21005-2-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509114337.21005-2-linyunsheng@huawei.com>

On Tue, May 09, 2023 at 07:43:36PM +0800, Yunsheng Lin wrote:
> Most users use __skb_frag_set_page()/skb_frag_off_set()/
> skb_frag_size_set() to fill the page desc for a skb frag.
> 
> Introduce skb_frag_fill_page_desc() to do that.
> 
> net/bpf/test_run.c does not call skb_frag_off_set() to
> set the offset, "copy_from_user(page_address(page), ...)"
> suggest that it is assuming offset to be initialized as
> zero, so call skb_frag_fill_page_desc() with offset being
> zero for this case.
> 
> Also, skb_frag_set_page() is not used anymore, so remove
> it.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  .../net/ethernet/aquantia/atlantic/aq_ring.c  |  6 ++--
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 ++-
>  drivers/net/ethernet/chelsio/cxgb3/sge.c      |  5 ++-
>  drivers/net/ethernet/emulex/benet/be_main.c   | 32 ++++++++++---------
>  drivers/net/ethernet/freescale/enetc/enetc.c  |  5 ++-
>  .../net/ethernet/fungible/funeth/funeth_rx.c  |  5 ++-
>  drivers/net/ethernet/marvell/mvneta.c         |  5 ++-
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  4 +--
>  drivers/net/ethernet/sun/cassini.c            |  8 ++---
>  drivers/net/virtio_net.c                      |  4 +--
>  drivers/net/vmxnet3/vmxnet3_drv.c             |  4 +--
>  drivers/net/xen-netback/netback.c             |  4 +--
>  include/linux/skbuff.h                        | 27 ++++++----------
>  net/bpf/test_run.c                            |  3 +-
>  net/core/gro.c                                |  4 +--
>  net/core/pktgen.c                             | 13 +++++---
>  net/core/skbuff.c                             |  7 ++--
>  net/tls/tls_device.c                          | 10 +++---
>  net/xfrm/xfrm_ipcomp.c                        |  5 +--
>  19 files changed, 64 insertions(+), 92 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

