Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444E2140181
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 02:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbgAQBjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 20:39:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729031AbgAQBjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 20:39:55 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C01262075B;
        Fri, 17 Jan 2020 01:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579225194;
        bh=j35MzC29GROVtcKbEjOdg1pjHP0lBU2yPwUOPi/zLRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qelqbKseVknUAKMFkJV3yT5y4ms7sBVbwtIUNt0+kggfie4o2iLAFiqzc4chwwW6P
         G1PmkzxkAWy+z/Tlh0PPlSmndFH8o6aZTK5Y2iC7VLfLBlcf1bYnEfJQ1eQAiGFlkL
         BmytOchngC5T3mkfyLRS68a8kmuGC74r57rRYKJA=
Date:   Thu, 16 Jan 2020 17:39:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v3 11/17] octeontx2-pf: Receive side scaling support
Message-ID: <20200116173952.58213098@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1579204053-28797-12-git-send-email-sunil.kovvuri@gmail.com>
References: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579204053-28797-12-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jan 2020 01:17:27 +0530, sunil.kovvuri@gmail.com wrote:
> +int otx2_rss_init(struct otx2_nic *pfvf)
> +{
> +	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
> +	int idx, ret = 0;
> +
> +	/* Enable RSS */
> +	rss->enable = true;
> +	rss->rss_size = sizeof(rss->ind_tbl);
> +
> +	/* Init RSS key here */
> +	netdev_rss_key_fill(rss->key, sizeof(rss->key));
> +	otx2_set_rss_key(pfvf);
> +
> +	/* Default indirection table */
> +	for (idx = 0; idx < rss->rss_size; idx++)
> +		rss->ind_tbl[idx] =
> +			ethtool_rxfh_indir_default(idx, pfvf->hw.rx_queues);
> +
> +	ret = otx2_set_rss_table(pfvf);
> +	if (ret)
> +		return ret;
> +
> +	/* Default flowkey or hash config to be used for generating flow tag */
> +	rss->flowkey_cfg = NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6 |
> +			   NIX_FLOW_KEY_TYPE_TCP | NIX_FLOW_KEY_TYPE_UDP |
> +			   NIX_FLOW_KEY_TYPE_SCTP;
> +
> +	return otx2_set_flowkey_cfg(pfvf);
> +}

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index 557f86b..fe5b3de 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> @@ -838,6 +838,11 @@ int otx2_open(struct net_device *netdev)
>  	if (err)
>  		goto err_disable_napi;
>  
> +	/* Initialize RSS */
> +	err = otx2_rss_init(pf);
> +	if (err)
> +		goto err_disable_napi;

Looks like you fully reset the RSS params on every close/open cycle? 
I don't think that's the expected behaviour/what most NICs do.
For example you should only reset the indir table if
netif_is_rxfh_configure() returns false.
