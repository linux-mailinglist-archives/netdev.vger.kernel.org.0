Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364FD4E510A
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 12:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243746AbiCWLMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 07:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239920AbiCWLMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 07:12:02 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B474B75C36;
        Wed, 23 Mar 2022 04:10:33 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 22NBAXT8016483;
        Wed, 23 Mar 2022 06:10:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1648033833;
        bh=OS9xMWyKIYKYm4TKgL6sYf442Lhh1Gaf/7Umjj3Q/Jg=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=DPUGA0hiXiD1c0c4FqJzop7nM7zfHNlWj0SzzwABW4pAISydM1UNxZ0Ox+nmYmZJG
         Wp5oyX1jXO6oyG/xE2xED+n7RZ0HHuDgizWkp9lLy6oxk8xAf8ERiyP+PPQ/WC9+wc
         CHM/4JGErnzRHr1Ejyr3msiKWCvb3+IBBpfXMV9M=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 22NBAXQg062363
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Mar 2022 06:10:33 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 23
 Mar 2022 06:10:32 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 23 Mar 2022 06:10:32 -0500
Received: from [10.250.235.115] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 22NBAUBD015734;
        Wed, 23 Mar 2022 06:10:31 -0500
Message-ID: <1ecdd60a-8e77-a517-aafd-6b7aacb5e0ea@ti.com>
Date:   Wed, 23 Mar 2022 16:40:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] drivers: ethernet: cpsw: fix panic when intrrupt
 coaleceing is set via ethtool
Content-Language: en-US
To:     =?UTF-8?Q?Sondhau=c3=9f=2c_Jan?= <Jan.Sondhauss@wago.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <20220323084725.65864-1-jan.sondhauss@wago.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
In-Reply-To: <20220323084725.65864-1-jan.sondhauss@wago.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/03/22 2:17 pm, Sondhauß, Jan wrote:
> cpsw_ethtool_begin directly returns the result of pm_runtime_get_sync
> when successful.
> pm_runtime_get_sync returns -error code on failure and 0 on successful
> resume but also 1 when the device is already active. So the common case
> for cpsw_ethtool_begin is to return 1. That leads to inconsistent calls
> to pm_runtime_put in the call-chain so that pm_runtime_put is called
> one too many times and as result leaving the cpsw dev behind suspended.
> 
> The suspended cpsw dev leads to an access violation later on by
> different parts of the cpsw driver.
> 
> Fix this by calling the return-friendly pm_runtime_resume_and_get
> function.
> 
> Signed-off-by: Jan Sondhauss <jan.sondhauss@wago.com>
> ---
>  drivers/net/ethernet/ti/cpsw_ethtool.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
> index 158c8d3793f4..b5bae6324970 100644
> --- a/drivers/net/ethernet/ti/cpsw_ethtool.c
> +++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
> @@ -364,11 +364,9 @@ int cpsw_ethtool_op_begin(struct net_device *ndev)
>  	struct cpsw_common *cpsw = priv->cpsw;
>  	int ret;
>  
> -	ret = pm_runtime_get_sync(cpsw->dev);
> -	if (ret < 0) {
> +	ret = pm_runtime_resume_and_get(cpsw->dev);
> +	if (ret < 0)
>  		cpsw_err(priv, drv, "ethtool begin failed %d\n", ret);
> -		pm_runtime_put_noidle(cpsw->dev);
> -	}
>  
>  	return ret;
>  }

Thanks for the fix!

Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>

I am guessing this issue started with d43c65b05b84 (ethtool:
runtime-resume netdev parent in ethnl_ops_begin) ? If so, could you add
a Fixes tag so that patch gets backported to all affected stable kernels?

Regards
Vignesh
