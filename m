Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695896D53F0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbjDCVtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbjDCVsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C53B30D3
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC59A61FE9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 21:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC120C433EF;
        Mon,  3 Apr 2023 21:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680558520;
        bh=N+Z7EsWdXeDuksSwYjrxg60Ta9Hf1TODhSO+APicEP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NNIuFz0Wkru46vbAd1zgbmPVXTEoJ9+2+R4ciHakzNAurYA7k1ssC7ov3l/r9jGT2
         EibY8N0yHszJRvpfETztusjO8GSa7FNegC/Y1KaNuMPGjtgldYetnfUwK0F/cvzFHj
         nlBH+x0USeFZjr2vcPIDR48im5+dt0Mad6XH3GTetn5OUpTkCQ4I+JOtvv6KwQ8QWv
         hGVO5ld4qOB6v+Yw7YEDcySY7AB7rW7uBQyLsCt4niloX3pB7w3EGR3oVecLO3Zywt
         ntxEzXMoePKZ0hxlJVnfq9vq75HIAPpVgqils8R7ysbtoDKnS0LyH1lsiYEVDNYxsZ
         WguI65qpbOi/A==
Date:   Mon, 3 Apr 2023 14:48:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: Re: [RFC PATCH net-next 2/6] net: ethtool: record custom RSS
 contexts in the IDR
Message-ID: <20230403144839.1dc56d3c@kernel.org>
In-Reply-To: <57c0a5a7d41e1341e8a7b0256ca8ed6f3e3ea9c0.1680538846.git.ecree.xilinx@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
        <57c0a5a7d41e1341e8a7b0256ca8ed6f3e3ea9c0.1680538846.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 17:32:59 +0100 edward.cree@amd.com wrote:
> @@ -880,6 +896,7 @@ struct ethtool_ops {
>  			    u8 *hfunc);
>  	int	(*set_rxfh)(struct net_device *, const u32 *indir,
>  			    const u8 *key, const u8 hfunc);
> +	u16	(*get_rxfh_priv_size)(struct net_device *);
>  	int	(*get_rxfh_context)(struct net_device *, u32 *indir, u8 *key,
>  				    u8 *hfunc, u32 rss_context);
>  	int	(*set_rxfh_context)(struct net_device *, const u32 *indir,

Would a static value not do for most drivers?
We already have a handful of data fields in the "ops" structure.

> @@ -1331,6 +1335,31 @@ static noinline_for_stack int ethtool_set_rxfh(struct net_device *dev,
>  		}
>  	}
>  
> +	if (create) {
> +		if (delete) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		ctx = kzalloc(ethtool_rxfh_context_size(dev_indir_size,
> +							dev_key_size,
> +							dev_priv_size),
> +			      GFP_USER);

GFP_USER? Do you mean it for accounting? GFP_KERNEL_ACCOUNT?
