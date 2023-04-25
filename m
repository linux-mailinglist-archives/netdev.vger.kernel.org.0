Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6700B6ED9C2
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjDYBVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDYBVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:21:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5926E5276
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C21F362A72
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4171C433D2;
        Tue, 25 Apr 2023 01:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682385681;
        bh=yZQINqXSnnozRBXkKQwIwOpE1OmucFA2E5tB1x3xC4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jJeKA1xKqtXndVsPukIakBUEw1DG71h//4NHZtDvFG3UZxpNKkG0wWbfyLTVoAKO7
         eqqyGocB45uOuD4XykbKlRRdIl9kmst4ZIdEnU2HWRrlrUV+BG2VamMRbYJwgYF7JJ
         l/sq3T/1uGNwXKL5FzeVQ/a/j4VV5GcTzUVhuFqoPa2Bwqo1oNFx2m3J2Jp2ytPJ0p
         i8Qtem+zHD2evpTfhJ3U4hdgTgcG2YZ6XCX6Tz28eClZwoUB73PH53KVHyWySo+qmy
         Cw/8CnuOyMpRo+LkKIkUI1vMCNlWmzDmYWu26stbFEyfmSP4yexBu4DyIT2GLb2ThA
         tBztGgo2AQtVQ==
Date:   Mon, 24 Apr 2023 18:21:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
Cc:     patrick@stwcx.xyz, Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 1/1] net/ncsi: Fix the multi thread manner of NCSI
 driver
Message-ID: <20230424182119.0c34624c@kernel.org>
In-Reply-To: <20230424114742.32933-2-Delphine_CC_Chiu@wiwynn.com>
References: <20230424114742.32933-1-Delphine_CC_Chiu@wiwynn.com>
        <20230424114742.32933-2-Delphine_CC_Chiu@wiwynn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 19:47:42 +0800 Delphine CC Chiu wrote:
> From: Delphine CC Chiu <Delphine_CC_Chiu@Wiwynn.com>
> 
> Currently NCSI driver will send several NCSI commands back
> to back without waiting the response of previous NCSI command
> or timeout in some state when NIC have multi channel. This
> operation against the single thread manner defined by NCSI
> SPEC(section 6.3.2.3 in DSP0222_1.1.1).
> 
> 1. Fix the problem of NCSI driver that sending command back
> to back without waiting the response of previos NCSI command
> or timeout to meet the single thread manner.
> 2. According to NCSI SPEC(section 6.2.13.1 in DSP0222_1.1.1),
> we should probe one channel at a time by sending NCSI commands
> (Clear initial state, Get version ID, Get capabilities...), than
> repeat this steps until the max number of channels which we got
> from NCSI command (Get capabilities) has been probed.

Sounds like this is a fix? Could you add a Fixes tag to point to
the commit where the problem was first present?

> diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
> index 03757e76bb6b..6701ac7d4249 100644
> --- a/net/ncsi/internal.h
> +++ b/net/ncsi/internal.h
> @@ -337,6 +337,7 @@ struct ncsi_dev_priv {
>  #define NCSI_MAX_VLAN_VIDS	15
>  	struct list_head    vlan_vids;       /* List of active VLAN IDs */
>  
> +	unsigned char       max_channel;     /* Num of channels to probe   */

"max" usually equals "count - 1", so let's stick to count naming.
Standard calls this "Channel count", correct?

>  	bool                multi_package;   /* Enable multiple packages   */
>  	bool                mlx_multi_host;  /* Enable multi host Mellanox */
>  	u32                 package_whitelist; /* Packages to configure    */
> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
> index d9da942ad53d..c31b9bf7d099 100644
> --- a/net/ncsi/ncsi-manage.c
> +++ b/net/ncsi/ncsi-manage.c
> @@ -471,6 +471,7 @@ static void ncsi_suspend_channel(struct ncsi_dev_priv *ndp)
>  	struct ncsi_channel *nc, *tmp;
>  	struct ncsi_cmd_arg nca;
>  	unsigned long flags;
> +	static unsigned char channel_index;

Why static? We can't have function state in the kernel, there maybe
multiple NC-SI devices present. Should it be stored in ndp?

>  	int ret;
>  
>  	np = ndp->active_package;
> @@ -510,17 +511,21 @@ static void ncsi_suspend_channel(struct ncsi_dev_priv *ndp)
>  
>  		break;
>  	case ncsi_dev_state_suspend_gls:
> -		ndp->pending_req_num = np->channel_num;
> +		ndp->pending_req_num = 1;
>  
>  		nca.type = NCSI_PKT_CMD_GLS;
>  		nca.package = np->id;
>  
>  		nd->state = ncsi_dev_state_suspend_dcnt;
> -		NCSI_FOR_EACH_CHANNEL(np, nc) {
> -			nca.channel = nc->id;
> -			ret = ncsi_xmit_cmd(&nca);
> -			if (ret)
> -				goto error;
> +		nca.channel = channel_index;
> +		ret = ncsi_xmit_cmd(&nca);
> +		if (ret)
> +			goto error;
> +		channel_index++;
> +
> +		if (channel_index == ndp->max_channel) {
> +			channel_index = 0;
> +			nd->state = ncsi_dev_state_suspend_dcnt;
>  		}
>  
>  		break;
> @@ -1350,9 +1355,9 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
>  {
>  	struct ncsi_dev *nd = &ndp->ndev;
>  	struct ncsi_package *np;
> -	struct ncsi_channel *nc;
>  	struct ncsi_cmd_arg nca;
> -	unsigned char index;
> +	unsigned char package_index;
> +	static unsigned char channel_index;
>  	int ret;
>  
>  	nca.ndp = ndp;
> @@ -1367,8 +1372,8 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
>  		/* Deselect all possible packages */
>  		nca.type = NCSI_PKT_CMD_DP;
>  		nca.channel = NCSI_RESERVED_CHANNEL;
> -		for (index = 0; index < 8; index++) {
> -			nca.package = index;
> +		for (package_index = 0; package_index < 8; package_index++) {
> +			nca.package = package_index;
>  			ret = ncsi_xmit_cmd(&nca);
>  			if (ret)
>  				goto error;
> @@ -1431,21 +1436,46 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
>  		break;
>  #endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
>  	case ncsi_dev_state_probe_cis:
> -		ndp->pending_req_num = NCSI_RESERVED_CHANNEL;
> +	case ncsi_dev_state_probe_gvi:
> +	case ncsi_dev_state_probe_gc:
> +	case ncsi_dev_state_probe_gls:
> +		np = ndp->active_package;
> +		ndp->pending_req_num = 1;
>  
>  		/* Clear initial state */
> -		nca.type = NCSI_PKT_CMD_CIS;
> -		nca.package = ndp->active_package->id;
> -		for (index = 0; index < NCSI_RESERVED_CHANNEL; index++) {
> -			nca.channel = index;
> -			ret = ncsi_xmit_cmd(&nca);
> -			if (ret)
> -				goto error;
> +		if (nd->state == ncsi_dev_state_probe_cis)
> +			nca.type = NCSI_PKT_CMD_CIS;
> +		/* Retrieve version, capability or link status */
> +		else if (nd->state == ncsi_dev_state_probe_gvi)
> +			nca.type = NCSI_PKT_CMD_GVI;
> +		else if (nd->state == ncsi_dev_state_probe_gc)
> +			nca.type = NCSI_PKT_CMD_GC;
> +		else
> +			nca.type = NCSI_PKT_CMD_GLS;
> +
> +		nca.package = np->id;
> +		nca.channel = channel_index;
> +		ret = ncsi_xmit_cmd(&nca);
> +		if (ret)
> +			goto error;
> +
> +		if (nd->state == ncsi_dev_state_probe_cis) {
> +			nd->state = ncsi_dev_state_probe_gvi;
> +		} else if (nd->state == ncsi_dev_state_probe_gvi) {
> +			nd->state = ncsi_dev_state_probe_gc;
> +		} else if (nd->state == ncsi_dev_state_probe_gc) {
> +			nd->state = ncsi_dev_state_probe_gls;
> +		} else {
> +			nd->state = ncsi_dev_state_probe_cis;
> +			channel_index++;
>  		}
>  
> -		nd->state = ncsi_dev_state_probe_gvi;
> -		if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
> -			nd->state = ncsi_dev_state_probe_keep_phy;
> +		if (channel_index == ndp->max_channel) {
> +			channel_index = 0;
> +			nd->state = ncsi_dev_state_probe_dp;
> +			if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
> +				nd->state = ncsi_dev_state_probe_keep_phy;
> +		}
>  		break;
>  #if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
>  	case ncsi_dev_state_probe_keep_phy:
> @@ -1461,35 +1491,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
>  		nd->state = ncsi_dev_state_probe_gvi;
>  		break;
>  #endif /* CONFIG_NCSI_OEM_CMD_KEEP_PHY */
> -	case ncsi_dev_state_probe_gvi:
> -	case ncsi_dev_state_probe_gc:
> -	case ncsi_dev_state_probe_gls:
> -		np = ndp->active_package;
> -		ndp->pending_req_num = np->channel_num;
> -
> -		/* Retrieve version, capability or link status */
> -		if (nd->state == ncsi_dev_state_probe_gvi)
> -			nca.type = NCSI_PKT_CMD_GVI;
> -		else if (nd->state == ncsi_dev_state_probe_gc)
> -			nca.type = NCSI_PKT_CMD_GC;
> -		else
> -			nca.type = NCSI_PKT_CMD_GLS;
> -
> -		nca.package = np->id;
> -		NCSI_FOR_EACH_CHANNEL(np, nc) {
> -			nca.channel = nc->id;
> -			ret = ncsi_xmit_cmd(&nca);
> -			if (ret)
> -				goto error;
> -		}
> -
> -		if (nd->state == ncsi_dev_state_probe_gvi)
> -			nd->state = ncsi_dev_state_probe_gc;
> -		else if (nd->state == ncsi_dev_state_probe_gc)
> -			nd->state = ncsi_dev_state_probe_gls;
> -		else
> -			nd->state = ncsi_dev_state_probe_dp;
> -		break;

Could you make the code move a separate patch (making the submission 
a 2 patch series) for ease of review? Otherwise it's tricky to see what
actually changed here.
