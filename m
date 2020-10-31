Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7AB2A1350
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 04:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgJaDSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 23:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgJaDSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 23:18:48 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9F59206F9;
        Sat, 31 Oct 2020 03:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604114327;
        bh=wpuQWSfJhXhol5SUGt01Gk+7zqrqbeH2wDm9rYbeH1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2tZF0Iv50D1hJV9V5OqMc/fn8ElObmDf9ICKmlirhmtcfJg3z8N/k8Gtx3AzfIsUW
         ZXd7CKTxc3CUp6MkhLMr4NU1s5n7H221J1ENIW0IiDHJf6GYtEQc4f6Zfxiv3jPfNa
         r9oQhQy3sLXrS/DGheOykKazDsUG+0eKPRtp+02k=
Date:   Fri, 30 Oct 2020 20:18:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net-next] net/smc: improve return codes for SMC-Dv2
Message-ID: <20201030201845.6be9722e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028110039.33645-1-kgraul@linux.ibm.com>
References: <20201028110039.33645-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 12:00:39 +0100 Karsten Graul wrote:
> To allow better problem diagnosis the return codes for SMC-Dv2 are
> improved by this patch. A few more CLC DECLINE codes are defined and
> sent to the peer when an SMC connection cannot be established.
> There are now multiple SMC variations that are offered by the client and
> the server may encounter problems to initialize all of them.
> Because only one diagnosis code can be sent to the client the decision
> was made to send the first code that was encountered. Because the server
> tries the variations in the order of importance (SMC-Dv2, SMC-D, SMC-R)
> this makes sure that the diagnosis code of the most important variation
> is sent.
> 
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> ---
>  net/smc/af_smc.c   | 61 +++++++++++++++++++++++++++++++---------------
>  net/smc/smc_clc.h  |  5 ++++
>  net/smc/smc_core.h |  1 +
>  3 files changed, 47 insertions(+), 20 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 82be0bd0f6e8..5414704f4cac 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1346,6 +1346,7 @@ static int smc_listen_v2_check(struct smc_sock *new_smc,
>  {
>  	struct smc_clc_smcd_v2_extension *pclc_smcd_v2_ext;
>  	struct smc_clc_v2_extension *pclc_v2_ext;
> +	int rc;
>  
>  	ini->smc_type_v1 = pclc->hdr.typev1;
>  	ini->smc_type_v2 = pclc->hdr.typev2;
> @@ -1353,29 +1354,30 @@ static int smc_listen_v2_check(struct smc_sock *new_smc,
>  	if (pclc->hdr.version > SMC_V1)
>  		ini->smcd_version |=
>  				ini->smc_type_v2 != SMC_TYPE_N ? SMC_V2 : 0;
> +	if (!(ini->smcd_version & SMC_V2)) {
> +		rc = SMC_CLC_DECL_PEERNOSMC;
> +		goto out;
> +	}
>  	if (!smc_ism_v2_capable) {
>  		ini->smcd_version &= ~SMC_V2;
> +		rc = SMC_CLC_DECL_NOISM2SUPP;
>  		goto out;
>  	}
>  	pclc_v2_ext = smc_get_clc_v2_ext(pclc);
>  	if (!pclc_v2_ext) {
>  		ini->smcd_version &= ~SMC_V2;
> +		rc = SMC_CLC_DECL_NOV2EXT;
>  		goto out;
>  	}
>  	pclc_smcd_v2_ext = smc_get_clc_smcd_v2_ext(pclc_v2_ext);
> -	if (!pclc_smcd_v2_ext)
> +	if (!pclc_smcd_v2_ext) {
>  		ini->smcd_version &= ~SMC_V2;
> +		rc = SMC_CLC_DECL_NOV2DEXT;
> +	}
>  
>  out:
> -	if (!ini->smcd_version) {
> -		if (pclc->hdr.typev1 == SMC_TYPE_B ||
> -		    pclc->hdr.typev2 == SMC_TYPE_B)
> -			return SMC_CLC_DECL_NOSMCDEV;
> -		if (pclc->hdr.typev1 == SMC_TYPE_D ||
> -		    pclc->hdr.typev2 == SMC_TYPE_D)
> -			return SMC_CLC_DECL_NOSMCDDEV;
> -		return SMC_CLC_DECL_NOSMCRDEV;
> -	}
> +	if (!ini->smcd_version)
> +		return rc;

Is rc guaranteed to be initialized? Looks like ini->smcd_version could
possibly start out as 0, no?

>  
>  	return 0;
>  }
> @@ -1473,6 +1475,12 @@ static void smc_check_ism_v2_match(struct smc_init_info *ini,
>  	}
>  }

> @@ -1630,10 +1647,14 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
>  		return 0;
>  
>  	if (pclc->hdr.typev1 == SMC_TYPE_D)
> -		return SMC_CLC_DECL_NOSMCDDEV; /* skip RDMA and decline */
> +		/* skip RDMA and decline */
> +		return ini->rc ?: SMC_CLC_DECL_NOSMCDDEV;
>  
>  	/* check if RDMA is available */
> -	return smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
> +	rc = smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
> +	smc_find_ism_store_rc(rc, ini);
> +
> +	return (!rc) ? 0 : ini->rc;

Since I'm asking questions anyway - isn't this equivalent to 

	return ini->rc; 

since there's call to

	smc_find_ism_store_rc(rc, ini);

right above?
