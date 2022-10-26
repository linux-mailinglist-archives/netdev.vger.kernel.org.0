Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB7860D959
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 04:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiJZCkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 22:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJZCkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 22:40:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9F25A8AB
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 19:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5521EB81FE5
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 02:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C707C433D6;
        Wed, 26 Oct 2022 02:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666752036;
        bh=Z39/gt4VlppdsRgt5+5s24dEs3pQbxrxcVSuNa7PFbM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gaPJRi2NBZ5YK24zh1X9s2p4G/g7aA23XaUIrnHCBR7Xe1TkDyJupaRKPhrkxmbHU
         HKvTn2ue1DZ9+KkOyK32I2rM16ifx9IpdlxmfVMhPrbCHlyQCUPpW9kbGmHNNGw3UB
         KUQkkZgqUidqChBdwywaYbNsbbe3RZiuD+fNGzBhakm78sWgMMGFRdcsOdXgmXuM6m
         vjSDgqdKemze3p1MMcuK/e8vvEUpvRsa0KuIqeoi+pURV2V3uVmk6seE0Xipakd9+m
         m7VjgsZbGOX5a+uVAR7TIMbZxJIWcPBryuMqhAmBx78RkujgxRekIyYWR3HJx8tTWT
         UbT0pE6tmbJHw==
Date:   Tue, 25 Oct 2022 19:40:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <habetsm.xilinx@gmail.com>, Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH net-next 1/5] sfc: check recirc_id match caps before MAE
 offload
Message-ID: <20221025194035.7eb96c0a@kernel.org>
In-Reply-To: <d3da32136ba31c553fa267381eb6a01903525814.1666603600.git.ecree.xilinx@gmail.com>
References: <cover.1666603600.git.ecree.xilinx@gmail.com>
        <d3da32136ba31c553fa267381eb6a01903525814.1666603600.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 10:29:21 +0100 edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Offloaded TC rules always match on recirc_id in the MAE, so we should
>  check that the MAE reported support for this match before attempting
>  to insert the rule.
> 
> Fixes: d902e1a737d4 ("sfc: bare bones TC offload on EF100")

This commit made it to net, needs to go separately there.

> +/* Validate field mask against hardware capabilities.  May return from caller */
> +#define CHECK(_mcdi, _field)	do {					       \
> +	enum mask_type typ = classify_mask((const u8 *)&mask->_field,	       \
> +					   sizeof(mask->_field));	       \
> +									       \
> +	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ ## _mcdi],\
> +					 typ);				       \
> +	if (rc) {							       \
> +		NL_SET_ERR_MSG_FMT_MOD(extack,				       \
> +				       "No support for %s mask in field %s",   \
> +				       mask_type_name(typ), #_field);	       \
> +		return rc;						       \

We still don't allow flow control to hide inside macros.

You add the checks next to each other (looking at the next patch) 
so you can return rc from the macro and easily combine the checks
into one large if statement. Result - close to ~1 line per check.

> +	}								       \
> +} while (0)
> +
>  int efx_mae_match_check_caps(struct efx_nic *efx,
>  			     const struct efx_tc_match_fields *mask,
>  			     struct netlink_ext_ack *extack)
> @@ -269,6 +284,7 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
>  				       mask_type_name(ingress_port_mask_type));
>  		return rc;
>  	}
> +	CHECK(RECIRC_ID, recirc_id);
>  	return 0;

I think the #undef leaked into the next patch.
