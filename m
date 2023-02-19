Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E364269BF5E
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjBSJWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 04:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjBSJVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:21:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2388011148
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 01:21:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B34ED60C0A
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 09:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFB0C433D2;
        Sun, 19 Feb 2023 09:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676798496;
        bh=+PtzBrlflqKSEpp9FRVU3xZ9yvFCvDD+mwAsarARqf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uZ4gttnkshuExxorHoWDV4RPD4jhpJBzsDr0yKCZrc+N+8Ll0ZLLFGw1vB6bp36vz
         y36hAV7oALvKgt7ottMZNo96PHDT87SbFdO7nlSLIPbb+CyIrss7eWc8dVm3MN2C94
         81ZpZrBok6toBLKHZdBCERJ5wo9ykeywwXybiOJUy2o9puhZ/PBc4THX0cuEOdqsDY
         6lWtkEjdHHHPJLyUlcszQVE6kt54I2fbQXm3zrYdEECpQxMCywKuASs7V88rg4ZRlW
         9lDV401Ro1bkX9NIgmIsSCSm3Bg4CwAqqJqciQJAMJGWFWAd721M09mNV8X2yNEGFU
         3h5AUxERqIkBw==
Date:   Sun, 19 Feb 2023 11:21:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next] sfc: support offloading TC VLAN push/pop
 actions to the MAE
Message-ID: <Y/HqGyFiIMFZRT7r@unreal>
References: <20230216160442.48394-1-edward.cree@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216160442.48394-1-edward.cree@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 04:04:42PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> EF100 can pop and/or push up to two VLAN tags.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/mae.c  | 43 ++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/mcdi.h |  5 ++++
>  drivers/net/ethernet/sfc/tc.c   | 53 +++++++++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/tc.h   |  4 +++
>  4 files changed, 105 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
> index 6321fd393fc3..7ae5b22af624 100644
> --- a/drivers/net/ethernet/sfc/mae.c
> +++ b/drivers/net/ethernet/sfc/mae.c
> @@ -679,9 +679,40 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
>  {
>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_ALLOC_OUT_LEN);
>  	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ACTION_SET_ALLOC_IN_LEN);
> +	unsigned char vlan_push, vlan_pop;
>  	size_t outlen;
>  	int rc;
>  
> +	/* Translate vlan actions from bitmask to count */
> +	switch (act->vlan_push) {
> +	case 0:
> +	case 1:
> +		vlan_push = act->vlan_push;
> +		break;
> +	case 2: /* can't happen */

There is no need in case here as "default" will catch.

> +	default:
> +		return -EINVAL;
> +	case 3:
> +		vlan_push = 2;
> +		break;
> +	}
> +	switch (act->vlan_pop) {
> +	case 0:
> +	case 1:
> +		vlan_pop = act->vlan_pop;
> +		break;
> +	case 2: /* can't happen */
> +	default:
> +		return -EINVAL;

Please rely switch-case semantics and don't put default in the middle.


> +	case 3:
> +		vlan_pop = 2;
> +		break;
> +	}

Thanks
