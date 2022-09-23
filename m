Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754CE5E7108
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiIWBAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiIWBAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:00:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10826F9600
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 18:00:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B9E461774
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 01:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981C9C433D6;
        Fri, 23 Sep 2022 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663894841;
        bh=lVXRBmOH2izeNhiIDmXcShrZLcn1Y59JDjdreaQveP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ixvpQ9hNfbrWIJsNVoQhz2guhM7uUvbHYfA0CHTJ3yLm7Vk2qw8TjHRLvVr1YITbv
         EVRQyNPPyda9i/GdyutTNxbTBiq+c7JVN253Fb9jXeIhk6zP3vEiw1tlapFS13mze+
         PVvJ/0bX0X8v7cqlWl4uI4z1bNAKqDEI5ZecbLYLGKszEa6ru4Skw+QCifw8YpXaeg
         2LQgfo3yTG5dcB9iN6jJwhk2FjIWopeL+CfnMBd0PgKx3p/PPr1VaKLrPh20UhlXhl
         BMH0Sb93Ejj3rvY0XWWXkCiciZfG8A9uvKJhSAc9heKizSwfJnLmVpIp4XRLiGUITt
         sWJKDEIOSQE9g==
Date:   Thu, 22 Sep 2022 18:00:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Message-ID: <20220922180040.50dd1af0@kernel.org>
In-Reply-To: <20220921121235.169761-3-simon.horman@corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
        <20220921121235.169761-3-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 14:12:34 +0200 Simon Horman wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Report the auto negotiation capability if it's supported
> in management firmware, and advertise it if it's enabled.
> 
> Changing FEC to mode other than auto or changing port
> speed is not allowed when autoneg is enabled. And FEC mode
> is enforced into auto mode when enabling link autoneg.
> 
> The ethtool <intf> command displays the auto-neg capability:

>  	if (cmd->base.speed != SPEED_UNKNOWN) {
> -		u32 speed = cmd->base.speed / eth_port->lanes;
> +		if (req_aneg) {
> +			netdev_err(netdev, "Speed changing is not allowed when working on autoneg mode.\n");
> +			err = -EINVAL;
> +			goto err_bad_set;
> +		} else {
> +			u32 speed = cmd->base.speed / eth_port->lanes;
>  
> -		err = __nfp_eth_set_speed(nsp, speed);
> +			err = __nfp_eth_set_speed(nsp, speed);
> +			if (err)
> +				goto err_bad_set;
> +		}

Please refactor this to avoid the extra indentation

> +	}
> +
> +	if (req_aneg && nfp_eth_can_support_fec(eth_port) && eth_port->fec != NFP_FEC_AUTO_BIT) {
> +		err = __nfp_eth_set_fec(nsp, NFP_FEC_AUTO_BIT);
>  		if (err)
>  			goto err_bad_set;

> +	if (eth_port->supp_aneg && eth_port->aneg == NFP_ANEG_AUTO && fec != NFP_FEC_AUTO_BIT) {
> +		netdev_err(netdev, "Only auto mode is allowed when link autoneg is enabled.\n");
> +		return -EINVAL;
> +	}

Autoneg and AUTO fec are two completely different things.
There was a long thread on AUTO recently.. :(

>  	snprintf(hwinfo, sizeof(hwinfo), "sp_indiff=%d", sp_indiff);
>  	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
> -	if (err)
> +	if (err) {
> +		/* Not a fatal error, no need to return error to stop driver from loading */
>  		nfp_warn(pf->cpp, "HWinfo(sp_indiff=%d) set failed: %d\n", sp_indiff, err);
> +		err = 0;

This should be a separate commit, it seems

>  
>  	nfp_nsp_close(nsp);
>  	return err;
> @@ -331,7 +334,23 @@ static int nfp_net_pf_cfg_nsp(struct nfp_pf *pf, bool sp_indiff)
>  
>  static int nfp_net_pf_init_nsp(struct nfp_pf *pf)
>  {
> -	return nfp_net_pf_cfg_nsp(pf, pf->sp_indiff);
> +	int err;
> +
> +	err = nfp_net_pf_cfg_nsp(pf, pf->sp_indiff);
> +	if (!err) {
> +		struct nfp_port *port;
> +
> +		/* The eth ports need be refreshed after nsp is configured,
> +		 * since the eth table state may change, e.g. aneg_supp field.

No idea why, tho

> +		 * Only `CHANGED` bit is set here in case nsp needs some time
> +		 * to process the configuration.

I can't parse what this is saying but doesn't look good

> +		 */
> +		list_for_each_entry(port, &pf->ports, port_list)
> +			if (__nfp_port_get_eth_port(port))
> +				set_bit(NFP_PORT_CHANGED, &port->flags);
> +	}
> +
> +	return err;
>  }
