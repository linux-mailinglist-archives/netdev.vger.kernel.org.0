Return-Path: <netdev+bounces-738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E11F46F9775
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 10:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25A351C21C1D
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 08:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE2741C04;
	Sun,  7 May 2023 08:11:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A101FC1
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 08:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1E3C433D2;
	Sun,  7 May 2023 08:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683447058;
	bh=14gt07e2i3xEmFnLE+5SPgbvGJF6N9cFNjqQFSOAoWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f0fLK7L6ZqGuFLkVQVQMw5hbM4Yjj2QAgpv3mHx/kycnIyYy20xe/apIZLbRehQ+e
	 QJoi8a0X2LmQnJtWV568Hpj6cTGPEbIZKnSykR7YflPQaOlIazkQGx6wI0YIPNJYNv
	 Ppn3Wjyoh4b3RMNv8qD/0CAnkiRuJdpvwg8wrRF8qyde/M4BTMCjqSKV9kvuvu4pIM
	 +dnzHAM7bC1FlcbSGHMPbnn9D84iX4pelRrCg2F7+Qu30mTngWD5gp6Y58LzsNePFi
	 36GauoyVbhfRyhHejBWLYoPv9Jq6ZZEiLwqPNMdruDGC+SBLTs9Bw0N2IsG4BhTz8T
	 y5NPpUb8uei8Q==
Date: Sun, 7 May 2023 11:10:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: longli@microsoft.com
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Ajay Sharma <sharmaajay@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to
 enable RX coalescing
Message-ID: <20230507081053.GD525452@unreal>
References: <1683312708-24872-1-git-send-email-longli@linuxonhyperv.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683312708-24872-1-git-send-email-longli@linuxonhyperv.com>

On Fri, May 05, 2023 at 11:51:48AM -0700, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 
> With RX coalescing, one CQE entry can be used to indicate multiple packets
> on the receive queue. This saves processing time and PCI bandwidth over
> the CQ.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  drivers/infiniband/hw/mana/qp.c |  5 ++++-
>  include/net/mana/mana.h         | 17 +++++++++++++++++
>  2 files changed, 21 insertions(+), 1 deletion(-)

Why didn't you change mana_cfg_vport_steering() too?

> 
> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
> index 54b61930a7fd..83c768f96506 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -13,7 +13,7 @@ static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
>  				      u8 *rx_hash_key)
>  {
>  	struct mana_port_context *mpc = netdev_priv(ndev);
> -	struct mana_cfg_rx_steer_req *req = NULL;
> +	struct mana_cfg_rx_steer_req_v2 *req = NULL;

There is no need in NULL here, req is going to be overwritten almost
immediately.

Thanks

>  	struct mana_cfg_rx_steer_resp resp = {};
>  	mana_handle_t *req_indir_tab;
>  	struct gdma_context *gc;
> @@ -33,6 +33,8 @@ static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
>  	mana_gd_init_req_hdr(&req->hdr, MANA_CONFIG_VPORT_RX, req_buf_size,
>  			     sizeof(resp));
>  
> +	req->hdr.req.msg_version = GDMA_MESSAGE_V2;
> +
>  	req->vport = mpc->port_handle;
>  	req->rx_enable = 1;
>  	req->update_default_rxobj = 1;
> @@ -46,6 +48,7 @@ static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
>  	req->num_indir_entries = MANA_INDIRECT_TABLE_SIZE;
>  	req->indir_tab_offset = sizeof(*req);
>  	req->update_indir_tab = true;
> +	req->cqe_coalescing_enable = true;
>  
>  	req_indir_tab = (mana_handle_t *)(req + 1);
>  	/* The ind table passed to the hardware must have
> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index cd386aa7c7cc..f8314b7c386c 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -596,6 +596,23 @@ struct mana_cfg_rx_steer_req {
>  	u8 hashkey[MANA_HASH_KEY_SIZE];
>  }; /* HW DATA */
>  
> +struct mana_cfg_rx_steer_req_v2 {
> +	struct gdma_req_hdr hdr;
> +	mana_handle_t vport;
> +	u16 num_indir_entries;
> +	u16 indir_tab_offset;
> +	u32 rx_enable;
> +	u32 rss_enable;
> +	u8 update_default_rxobj;
> +	u8 update_hashkey;
> +	u8 update_indir_tab;
> +	u8 reserved;
> +	mana_handle_t default_rxobj;
> +	u8 hashkey[MANA_HASH_KEY_SIZE];
> +	u8 cqe_coalescing_enable;
> +	u8 reserved2[7];
> +}; /* HW DATA */
> +
>  struct mana_cfg_rx_steer_resp {
>  	struct gdma_resp_hdr hdr;
>  }; /* HW DATA */
> -- 
> 2.17.1
> 

