Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA55D51B18D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378945AbiEDWEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378943AbiEDWEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:04:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09EF4ECF4;
        Wed,  4 May 2022 15:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651701667; x=1683237667;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=85T/HK3Ljm2OuJ86i6TaZqpi0qkXHVTYq3nEoDDs7nc=;
  b=i3u25cL6o2Y65CwElAv9tAq+Ef5nXiJdQOyQTinHD9DsLWNLEGPiKUcm
   KQbBoNzLYnd7lE3f0xcOJxDR/+K+q0k6sHdNVdPueXdOS5gXhr89flbxl
   5BCAJyTmW/CPESasalL7FLBIhJ5+XPKOJa79hb6RACgnYL6hke/8gwNwB
   T/BAaTY+H1SY0hIVISh3qP2li8Y+KKEoFJwOGqRbWP/qbbRCuF/wMOqHo
   Y4vsX1T9PqlINa5BjzJNrxihZYFPEPDowHXvyattXhrdYYCjSI1AkqCob
   1smoDJmbDmXTMK1Z4sTAiqNyGkclC2XjS9ivd3IAypDm+doEb2uGaKo6K
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="266754783"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="266754783"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:01:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="621003539"
Received: from jsbradle-mobl1.amr.corp.intel.com ([10.212.185.245])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:01:03 -0700
Date:   Wed, 4 May 2022 15:01:01 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, rafal@milecki.pl, f.fainelli@gmail.com,
        opendmb@gmail.com, dmichail@fungible.com, hauke@hauke-m.de,
        tariqt@nvidia.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        shshaikh@marvell.com, manishc@marvell.com, jiri@resnulli.us,
        hayashi.kunihiko@socionext.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, grygorii.strashko@ti.com,
        elder@kernel.org, wintera@linux.ibm.com, wenjia@linux.ibm.com,
        svens@linux.ibm.com, matthieu.baerts@tessares.net,
        s-vadapalli@ti.com, chi.minghao@zte.com.cn,
        linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 1/2] net: switch to netif_napi_add_tx()
In-Reply-To: <20220504163725.550782-1-kuba@kernel.org>
Message-ID: <eb4dc61f-59a-794-d915-cfabbe469369@linux.intel.com>
References: <20220504163725.550782-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 May 2022, Jakub Kicinski wrote:

> Switch net callers to the new API not requiring
> the NAPI_POLL_WEIGHT argument.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

...

> net/mptcp/protocol.c                               | 4 ++--
> 19 files changed, 29 insertions(+), 40 deletions(-)
>

For the MPTCP content:

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index 52ed2c0ac901..7a9e2545884f 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -3786,8 +3786,8 @@ void __init mptcp_proto_init(void)
> 	for_each_possible_cpu(cpu) {
> 		delegated = per_cpu_ptr(&mptcp_delegated_actions, cpu);
> 		INIT_LIST_HEAD(&delegated->head);
> -		netif_tx_napi_add(&mptcp_napi_dev, &delegated->napi, mptcp_napi_poll,
> -				  NAPI_POLL_WEIGHT);
> +		netif_napi_add_tx(&mptcp_napi_dev, &delegated->napi,
> +				  mptcp_napi_poll);
> 		napi_enable(&delegated->napi);
> 	}
>
> -- 
> 2.34.1
>
>

--
Mat Martineau
Intel
