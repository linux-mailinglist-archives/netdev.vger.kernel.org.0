Return-Path: <netdev+bounces-4054-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF6DF70A555
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 06:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E51AB281B28
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45882363;
	Sat, 20 May 2023 04:41:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5305B64D
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 04:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5021C433EF;
	Sat, 20 May 2023 04:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684557663;
	bh=rtTebeLGsv0yIyelLE41xOQ/ZzcYgzBq+BaGRYiMoV0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WZixTMeIKSRikvryL16klZP3tZVSmvP4Cc4BCBOFTMAMeCThXC2dR/X6Lx1ASHKvn
	 3ymu+6BcJZLY43BfOq0t5M3qPeFVJXtueijBxrhTD1XlxGpK5GOiw+Ui+1iZ/s83ns
	 deXg3aNxjkMqerTbqKL8l4e1JFfQ8GTGUFvHl8deEC3SPhFFA8piCOO2T/Ek8MFUU3
	 WmRiuDecUn3l1k3hxapXbyIoo2tQATxKQoRDacg36IVVR7VoAh0IvnpRbt+WehVZBg
	 vmPGxjANy0377nFUp/Uk1yyxRvpbxoUHGuxmqlWe6VKN6RhLeb1bdB8+pHhBSuA94v
	 Tg+iSBjn5eqSA==
Date: Fri, 19 May 2023 21:41:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Saeed Mahameed <saeed@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Paolo Abeni
 <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Saeed Mahameed
 <saeedm@nvidia.com>, netdev@vger.kernel.org, Tariq Toukan
 <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>, Moshe Shemesh
 <moshe@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: Introduce SF direction
Message-ID: <20230519214101.2452af83@kernel.org>
In-Reply-To: <20230519183044.19065-1-saeed@kernel.org>
References: <20230519183044.19065-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 11:30:44 -0700 Saeed Mahameed wrote:
> Whenever multiple Virtual Network functions (VNFs) are used by Service
> Function Chaining (SFC), each packet is passing through all the VNFs,
> and each VNF is performing hairpin in order to pass the packet to the
> next function in the chain.
> 
> In case one mlx5 NIC is servicing multiple VNFs of the SFC, mlx5 need
> user input in order to optimize this hairpin to a simple forward rule.
> 
> The optimization is performed by binding two PCI SFs to each VNF, as
> can be seen bellow:
> 
>              -----------          -----------
>              |   VNF1  |          |   VNF2  |
>              -----------          -----------
>                 |  |                 |  |
>        (Net) SF1|  |SF2     (Net) SF3|  |SF4
>                 |  |                 |  |
>              -------------------------------
>              | /   \________________/    \ |
>     uplink---|/                           \|----host
>              |                NIC(SFC)     |
>              |                             |
>              -------------------------------
> 
> Define SF1 and SF3 as SFs with network direction tell the driver to
> configure the E-switch in a way that the packet arriving from SF1 will
> do forward to SF2 instead of hairpin.
> 
> This marking is done via sfnum command line argument, where bit 16
> marks the SF as facing the Network, and bit 17 marks the SF as
> facing the Host.

What does it mean that an SF is "facing" the network?
Why can't the device automatically "optimize" the hairpin?
Or SF1 / SF2 will be uni-directional after this patch?
-- 
pw-bot: cr

