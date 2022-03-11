Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F574D5BB7
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 07:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346791AbiCKGo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 01:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiCKGo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 01:44:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EE319CCCA;
        Thu, 10 Mar 2022 22:43:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3534FB8299A;
        Fri, 11 Mar 2022 06:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8722C340EC;
        Fri, 11 Mar 2022 06:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646981032;
        bh=TAmKSWfM8MT8+nWEF/VhEG/ZJrPdgq10gXaV9KWbhGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o+LTthpBiwXFgN2AXoXR3dkBllQINaKMB1MVLJ9fNYGsc33egvUleMos9C/Ers5Xy
         0aEsi7MyMo1LTO9pReh2ngHcWv3tBkSMJs7arcNj5FfwvhZHpBeAcF2ucLoONOjTwm
         lzB2WbNkenxYx1bvG4vVTVW8w6wx1VAlmaBnFX58=
Date:   Fri, 11 Mar 2022 07:43:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     stephen@networkplumber.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] hv_netvsc: Add check for kvmalloc_array
Message-ID: <YirvpH4+KTyH2xTe@kroah.com>
References: <20220311032035.2037962-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311032035.2037962-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 11:20:35AM +0800, Jiasheng Jiang wrote:
> As the potential failure of the kvmalloc_array(),
> it should be better to check and restore the 'data'
> if fails in order to avoid the dereference of the
> NULL pointer.
> 
> Fixes: 6ae746711263 ("hv_netvsc: Add per-cpu ethtool stats for netvsc")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 3646469433b1..018c4a5f6f44 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -1587,6 +1587,12 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
>  	pcpu_sum = kvmalloc_array(num_possible_cpus(),
>  				  sizeof(struct netvsc_ethtool_pcpu_stats),
>  				  GFP_KERNEL);
> +	if (!pcpu_sum) {
> +		for (j = 0; j < i; j++)
> +			data[j] = 0;
> +		return;
> +	}

How did you test this to verify it is correct?

thanks,

greg k-h
