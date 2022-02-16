Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB824B7FC6
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 05:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbiBPE5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 23:57:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiBPE5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 23:57:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F593FC5
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 20:57:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0411CE24B2
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 04:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4570C004E1;
        Wed, 16 Feb 2022 04:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644987419;
        bh=rKdzjmMnyPFTKBzrSCyfwDSYuz42ShQnJeXkzN7NEeg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KN6Xmnvuinvitqo9JYhAGBUXVkBH9XAscgLU0YgpS3GgCB6eeLNhe6Hydh6fiaX7H
         JK5jhziSs/FsyTWKsWEg+VwdToU+xEmMdH+bTvBxXmrPcCq5qcomSYuA8ZpoZOPTCY
         zOEH81NzkIyBlxcxF1jeP95toNAUt8Vr53CfyiekyI03P06Zt9ptQIxTkvPQ6aNI3k
         1sqWeEY8/hX9Gpk+f47EPiqKfhnk0CmmXB/2WWr8cY7PdbOke9IvYNbgYIv/hM3EVX
         TjGOPk2GwQ+31zdFN5IJGz0HS69AKHOi4qM782Ggnl74CO0dp9+f5c/jucTxaPnIZK
         2NnRDARUoog9g==
Date:   Tue, 15 Feb 2022 20:56:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Radu Bulie <radu-andrei.bulie@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ioana.ciornei@nxp.com,
        yangbo.lu@nxp.com
Subject: Re: [PATCH net-next 2/2] dpaa2-eth: Update SINGLE_STEP register
 access
Message-ID: <20220215205657.26c2f964@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220214160348.25124-3-radu-andrei.bulie@nxp.com>
References: <20220214160348.25124-1-radu-andrei.bulie@nxp.com>
        <20220214160348.25124-3-radu-andrei.bulie@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Feb 2022 18:03:48 +0200 Radu Bulie wrote:
> DPAA2 MAC supports 1588 one step timestamping.
> If this option is enabled then for each transmitted PTP event packet,
> the 1588 SINGLE_STEP register is accessed to modify the following fields:
> 
> -offset of the correction field inside the PTP packet
> -UDP checksum update bit,  in case the PTP event packet has
>  UDP encapsulation
> 
> These values can change any time, because there may be multiple
> PTP clients connected, that receive various 1588 frame types:
> - L2 only frame
> - UDP / Ipv4
> - UDP / Ipv6
> - other
> 
> The current implementation uses dpni_set_single_step_cfg to update the
> SINLGE_STEP register.
> Using an MC command  on the Tx datapath for each transmitted 1588 message
> introduces high delays, leading to low throughput and consequently to a
> small number of supported PTP clients. Besides these, the nanosecond
> correction field from the PTP packet will contain the high delay from the
> driver which together with the originTimestamp will render timestamp
> values that are unacceptable in a GM clock implementation.
> 
> This patch updates the Tx datapath for 1588 messages when single step
> timestamp is enabled and provides direct access to SINGLE_STEP register,
> eliminating the  overhead caused by the dpni_set_single_step_cfg
> MC command. MC version >= 10.32 implements this functionality.
> If the MC version does not have support for returning the
> single step register base address, the driver will use
> dpni_set_single_step_cfg command for updates operations.
> 
> All the delay introduced by dpni_set_single_step_cfg
> function will be eliminated (if MC version has support for returning the
> base address of the single step register), improving the egress driver
> performance for PTP packets when single step timestamping is enabled.
> 
> Before these changes the maximum throughput for 1588 messages with
> single step hardware timestamp enabled was around 2000pps.
> After the updates the throughput increased up to 32.82 Mbps / 46631.02 pps.
> 
> Signed-off-by: Radu Bulie <radu-andrei.bulie@nxp.com>

You need to CC Richard on PTP patches. Please do so when posting v2.

> +static void (*dpaa2_set_onestep_params_cb)(struct dpaa2_eth_priv *priv,
> +					   u32 offset, u8 udp);

Global variables are generally unacceptable in drivers.

Put the callback in the right structure, or just record that 
a capability is enabled and use an if. The indirect call seems
like an overkill.

> +static void dpaa2_eth_detect_features(struct dpaa2_eth_priv *priv)
> +{
> +	priv->features = 0;
> +
> +	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_PTP_ONESTEP_VER_MAJOR,
> +				   DPNI_PTP_ONESTEP_VER_MINOR) >= 0)
> +		priv->features |= DPAA2_ETH_FEATURE_ONESTEP_CFG_DIRECT;
> +}
> +
> +static void dpaa2_update_ptp_onestep_indirect(struct dpaa2_eth_priv *priv,
> +					      u32 offset, u8 udp)
> +{
> +	struct dpni_single_step_cfg cfg;
> +
> +	if (priv->ptp_correction_off == offset)
> +		return;

You can avoid repeating this condition in both handlers.

> +	cfg.en = 1;
> +	cfg.ch_update = udp;
> +	cfg.offset = offset;
> +	cfg.peer_delay = 0;
> +
> +	if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token, &cfg))
> +		WARN_ONCE(1, "Failed to set single step register");
> +
> +	priv->ptp_correction_off = offset;

And this.

> +}
> +
> +static void dpaa2_update_ptp_onestep_direct(struct dpaa2_eth_priv *priv,
> +					    u32 offset, u8 udp)
> +{
> +	u32 val = 0;
> +
> +	if (priv->ptp_correction_off == offset)
> +		return;
> +
> +	val =  DPAA2_PTP_SINGLE_STEP_ENABLE |

double space after =

> +	       DPAA2_PTP_SINGLE_CORRECTION_OFF(offset);
> +
> +	if (udp)
> +		val |= DPAA2_PTP_SINGLE_STEP_CH;
> +
> +	if (priv->onestep_reg_base)
> +		writel(val, priv->onestep_reg_base);
> +
> +	priv->ptp_correction_off = offset;
> +}
> +
> +static void dpaa2_ptp_onestep_reg_update_method(struct dpaa2_eth_priv *priv)
> +{
> +	struct device *dev = priv->net_dev->dev.parent;
> +	struct dpni_single_step_cfg ptp_cfg = {0};

no need for the 0

> +
> +	dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_indirect;
> +
> +	if (!(priv->features & DPAA2_ETH_FEATURE_ONESTEP_CFG_DIRECT))
> +		return;
> +
> +	if (dpni_get_single_step_cfg(priv->mc_io, 0, priv->mc_token, &ptp_cfg))
> +		goto fallback;
> +
> +	if (!ptp_cfg.ptp_onestep_reg_base)
> +		goto fallback;
> +
> +	priv->onestep_reg_base = ioremap(ptp_cfg.ptp_onestep_reg_base, sizeof(u32));
> +	if (!priv->onestep_reg_base)
> +		goto fallback;

goto is acceptable in the kernel for multi-step error handling,
which this is not. Please rewrite this without the goto.

> +	dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_direct;
> +
> +	return;
> +
> +fallback:
> +	dev_err(dev, "1588 onestep reg not available, falling back to indirect update\n");
> +}
