Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2713D86D9
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 06:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhG1Emt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 00:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhG1Ems (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 00:42:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E2760F41;
        Wed, 28 Jul 2021 04:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627447367;
        bh=dOk+2tFiWObmw55S1h9slR4A4T3f+tlYA4VqWOD2eAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=asPRK8N64wo9bRcUDj3+v7oCKxySBOZvt/v7+Ul8CUaSzKyZPUVlLsBPnm9NGj8aL
         t5IuM3IQXPrHb8Yz9D1mratdKG9R7S2c6Yh0zwS5GpHg29+SDGojG4OjVqAnE7tBpM
         jAYxTK0V3onNdQN5uaDwZHNbxeDz3CHlU72GMmyDdw3HGwL6DH9eW9xA1/Dl42zjDN
         Mx5AQotOjd6cHYwVOYCdo1B2deACWPfuxLWKtXpFn4h3EM2Sw91Cq07kOjltlEe6ME
         9G2X5bnCZTkzA9pUjeaTaMt7xOmJ0XcdN+dMfePsl7645X7vk6VmD2uTl+suSMo30h
         OeKWby67B9Y7A==
Date:   Tue, 27 Jul 2021 23:45:17 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 06/64] bnxt_en: Use struct_group_attr() for memcpy()
 region
Message-ID: <20210728044517.GE35706@embeddedor>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-7-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-7-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:57:57PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Use struct_group() around members queue_id, min_bw, max_bw, tsa, pri_lvl,
> and bw_weight so they can be referenced together. This will allow memcpy()
> and sizeof() to more easily reason about sizes, improve readability,
> and avoid future warnings about writing beyond the end of queue_id.
> 
> "pahole" shows no size nor member offset changes to struct bnxt_cos2bw_cfg.
> "objdump -d" shows no meaningful object code changes (i.e. only source
> line number induced differences and optimizations).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c |  4 ++--
>  drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h | 14 ++++++++------
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
> index 8a68df4d9e59..95c636f89329 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
> @@ -148,10 +148,10 @@ static int bnxt_hwrm_queue_cos2bw_qcfg(struct bnxt *bp, struct ieee_ets *ets)
>  	}
>  
>  	data = &resp->queue_id0 + offsetof(struct bnxt_cos2bw_cfg, queue_id);
> -	for (i = 0; i < bp->max_tc; i++, data += sizeof(cos2bw) - 4) {
> +	for (i = 0; i < bp->max_tc; i++, data += sizeof(cos2bw.cfg)) {
>  		int tc;
>  
> -		memcpy(&cos2bw.queue_id, data, sizeof(cos2bw) - 4);
> +		memcpy(&cos2bw.cfg, data, sizeof(cos2bw.cfg));
>  		if (i == 0)
>  			cos2bw.queue_id = resp->queue_id0;
>  
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h
> index 6eed231de565..716742522161 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h
> @@ -23,13 +23,15 @@ struct bnxt_dcb {
>  
>  struct bnxt_cos2bw_cfg {
>  	u8			pad[3];
> -	u8			queue_id;
> -	__le32			min_bw;
> -	__le32			max_bw;
> +	struct_group_attr(cfg, __packed,
> +		u8		queue_id;
> +		__le32		min_bw;
> +		__le32		max_bw;
>  #define BW_VALUE_UNIT_PERCENT1_100		(0x1UL << 29)
> -	u8			tsa;
> -	u8			pri_lvl;
> -	u8			bw_weight;
> +		u8		tsa;
> +		u8		pri_lvl;
> +		u8		bw_weight;
> +	);
>  	u8			unused;
>  };
>  
> -- 
> 2.30.2
> 
