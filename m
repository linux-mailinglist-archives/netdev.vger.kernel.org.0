Return-Path: <netdev+bounces-1061-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A07F6FC0A1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:45:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03A211C20AD8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3E911CA2;
	Tue,  9 May 2023 07:45:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7DA391;
	Tue,  9 May 2023 07:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B502C433EF;
	Tue,  9 May 2023 07:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683618306;
	bh=hQf9pNjF7zwQYcyl32iKf1KLzffA/L5NTPvBZwMUTgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V5LB7U1w8G4yNHH3tkFYJG0rDXq46KYsBP33UJPdV3muH7IJ0NBQ+GLscVF4mH3Fl
	 l/UG0wo3OZFH1I1zVYup3sEMAaSEytVom8vPwn+MQdBrkcJzyrfxPq3AHzWBnwexvJ
	 qmsMzYkIRIdc1bs00SywKw5YmU1oRhyMMFAbHZGJ5QsWExGoolS97YzimyCLwMhDKJ
	 YLHtjtHuVm7YMkq7e3o836Cbwi2EABhQivy3SAfag6PeYF/ZHy2uk+fLoKS+d5AbGL
	 h6Q9m+bZST3sf8Oj27QIrlw0VDTx4pHpm+DEU9EQct67JkatYU+MwuSvDCPh0NABnz
	 ss+U6ERs6r7Mg==
Date: Tue, 9 May 2023 10:45:02 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Shenwei Wang <shenwei.wang@nxp.com>
Cc: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	imx@lists.linux.dev, Gagandeep Singh <g.singh@nxp.com>
Subject: Re: [PATCH v4 1/1] net: fec: correct the counting of XDP sent frames
Message-ID: <20230509074502.GB38143@unreal>
References: <20230508142931.980196-1-shenwei.wang@nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508142931.980196-1-shenwei.wang@nxp.com>

On Mon, May 08, 2023 at 09:29:31AM -0500, Shenwei Wang wrote:
> In the current xdp_xmit implementation, if any single frame fails to
> transmit due to insufficient buffer descriptors, the function nevertheless
> reports success in sending all frames. This results in erroneously
> indicating that frames were transmitted when in fact they were dropped.
> 
> This patch fixes the issue by ensureing the return value properly
> indicates the actual number of frames successfully transmitted, rather than
> potentially reporting success for all frames when some could not transmit.
> 
> Fixes: 6d6b39f180b8 ("net: fec: add initial XDP support")
> Signed-off-by: Gagandeep Singh <g.singh@nxp.com>
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>  v4:
>   - the tx frame shouldn't be returned when error occurs.
>   - changed the function return values by using the standard errno.
> 
>  v3:
>   - resend the v2 fix for "net" as the standalone patch.
> 
>  v2:
>   - only keep the bug fix part of codes according to Horatiu's comments.
>   - restructure the functions to avoid the forward declaration.
> 
>  drivers/net/ethernet/freescale/fec_main.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)

<...>

> -	for (i = 0; i < num_frames; i++)
> -		fec_enet_txq_xmit_frame(fep, txq, frames[i]);
> +	for (i = 0; i < num_frames; i++) {
> +		if (fec_enet_txq_xmit_frame(fep, txq, frames[i]) != 0)
> +			break;
> +		sent_frames++;
> +	}

net-next has commit 6312c685ae0 ("net: fec: correct the counting of XDP sent frames")
which has exactly these lines.

Plus the patch is missing target tree in its subject line.
For example: [PATCH net-next] ...

Thanks

