Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8398F641CC9
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 13:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiLDMA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 07:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiLDMA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 07:00:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07738167C4;
        Sun,  4 Dec 2022 04:00:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8644660E86;
        Sun,  4 Dec 2022 12:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FCEC433C1;
        Sun,  4 Dec 2022 12:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670155255;
        bh=7ZBhcByRZURXAJtuoohSKpSN7w7r+pDtXMuFv7/SXck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C2zy5GDvR5wgiCyuU6baPTJV+LaYMCeYKbXL8j8ras1i4cGscatkctQ94EiCBPEt9
         CfKWf5v2nWHXgVwjtRtp1ModbUlrlX1uVPcezXXOda3erhNk6WMIOkBMIXqz2Svlm/
         3y+Amk5rRoyynsoYgBzAAS5pcs2wapFNdgAmKdtNRn7uaiWxyEhocY1NEdHJhzmp6L
         vSu7gfauoWd7RswdpxMPCmN7YsP5aKGwfjFtdn5QCPY1rbWflCcDSBpbqcqSQxFz6D
         pu4iljpvLOpOelq8/4DzMnrM+AnT4tBHyxQ1UlmjnN78gJI0mMrFuhSyuLV+tzZmdi
         ZghmOJh3Z73/w==
Date:   Sun, 4 Dec 2022 14:00:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com
Subject: Re: [net-next PATCH v3 3/4] octeontx2-pf: ethtool: Implement
 get_fec_stats
Message-ID: <Y4yL8OxbsgWdmhD4@unreal>
References: <20221201180040.14147-1-hkelam@marvell.com>
 <20221201180040.14147-4-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201180040.14147-4-hkelam@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 11:30:39PM +0530, Hariprasad Kelam wrote:
> This patch registers a callback for get_fec_stats such that
> FEC stats can be queried from the below command
> 
> "ethtool -I --show-fec eth0"
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
> v3 * Dont remove existing FEC stats support over
>      ethtool statistics (ethtool -S)
> 
>  .../marvell/octeontx2/nic/otx2_ethtool.c      | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index 0eb74e8c553d..85f46e15ac03 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -1268,6 +1268,45 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
>  	return err;
>  }
> 
> +static void otx2_get_fec_stats(struct net_device *netdev,
> +			       struct ethtool_fec_stats *fec_stats)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	struct cgx_fw_data *rsp;
> +
> +	otx2_update_lmac_fec_stats(pfvf);
> +
> +	rsp = otx2_get_fwdata(pfvf);
> +	if (!IS_ERR(rsp) && rsp->fwdata.phy.misc.has_fec_stats &&

<...>

> +	} else {

I see that you copied this pattern of call to otx2_get_fwdata() and check
for error from another place. However, that function returns an error
while executing call to HW. I don't know if it is correct thing to
continue as nothing happened.

> +		/* Report MAC FEC stats */
> +		fec_stats->corrected_blocks.total     =
> +			pfvf->hw.cgx_fec_corr_blks;
> +		fec_stats->uncorrectable_blocks.total =
> +			pfvf->hw.cgx_fec_uncorr_blks;

Please don't do vertical alignment of new code. Please use clang formatter
to fix it.

> +	}
> +}
> +
>  static const struct ethtool_ops otx2_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
>  				     ETHTOOL_COALESCE_MAX_FRAMES |
> @@ -1298,6 +1337,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
>  	.get_pauseparam		= otx2_get_pauseparam,
>  	.set_pauseparam		= otx2_set_pauseparam,
>  	.get_ts_info		= otx2_get_ts_info,
> +	.get_fec_stats		= otx2_get_fec_stats,
>  	.get_fecparam		= otx2_get_fecparam,
>  	.set_fecparam		= otx2_set_fecparam,
>  	.get_link_ksettings     = otx2_get_link_ksettings,
> --
> 2.17.1
