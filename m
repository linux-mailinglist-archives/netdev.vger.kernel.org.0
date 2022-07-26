Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A5B580995
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbiGZCpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiGZCpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:45:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBD595B6
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 19:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BE92B811BF
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 02:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45B4C341C6;
        Tue, 26 Jul 2022 02:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658803549;
        bh=P9NSdc3VJQnDysR+V/yvbPIa3n3mELNccuX5mwxDxjQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZWkRw5tfFGrIjGgRdtm5tm+cJTHZyGT+egp0qMUXRcE70KC9XSVViK34sB3IIuWVK
         OCbuVY3a5Y3EQhccEsynMTDXLbJJvvwUTxPAQylOEEHOE/JEqnR0mYR09MTx3/WJp/
         09k7o/W5mH6koPTRXGn5sIm3iDZis0j8gSklq15SVyjY7TNYSDgu8JWBD3qLUTR35J
         uTK0EwHR95nZW8nB3glSx5rvUaI3YDfHp+n6rznGC45dAB/NqpoHYxy+zvDiC54Lu6
         WrCFOR0VwakajSNYlyTH4kQpLLp69dR95xJ5WZwSSbOXpzyvRdDWfyOFpuTw3HIv2b
         3+rW5RVHoCSTg==
Date:   Mon, 25 Jul 2022 19:45:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, Jun Zhang <xuejun.zhang@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net 3/3] iavf: enable tc filter configuration only if
 hw-tc-offload is on
Message-ID: <20220725194547.0702bd73@kernel.org>
In-Reply-To: <20220725170452.920964-4-anthony.l.nguyen@intel.com>
References: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
        <20220725170452.920964-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 10:04:52 -0700 Tony Nguyen wrote:
> From: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
> 
> Allow configuration of tc filter only if NETIF_F_HW_TC is set for the
> device.
> 
> Fixes: 0075fa0fadd0 ("i40evf: Add support to apply cloud filters")
> Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
> Signed-off-by: Jun Zhang <xuejun.zhang@intel.com>
> Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 3dbfaead2ac7..9279bb37e4aa 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -3802,6 +3802,12 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
>  		return -EINVAL;
>  	}
>  
> +	if (!(adapter->netdev->features & NETIF_F_HW_TC)) {
> +		dev_err(&adapter->pdev->dev,
> +			"Can't apply TC flower filters, turn ON hw-tc-offload and try again");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
>  	if (!filter)
>  		return -ENOMEM;

tc_can_offload() checks this in the core already, no?
