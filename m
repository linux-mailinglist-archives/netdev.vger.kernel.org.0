Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9116761E57A
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiKFTO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKFTO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:14:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0009B866
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 11:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BDC160D24
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 19:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6195DC433D6;
        Sun,  6 Nov 2022 19:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667762095;
        bh=ZOdNk6qtyfdbx8g/LSFBhMuCcRoHrvydNvhbi0HQhaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mGrtrB4IxYyjsuL2pyVFSw8Vvd91xXPcMBdgVgqfv8yp5xUT1gk9o+DUkjBPqM9ir
         2wd+mTgRxzSg/wG8vPnYbS2qg0rt3quIAtomUzSlYSxnucZnWEDHUi3kHILx4NBULZ
         QdkF97wdNY8mPETHAFJI2+qYWRKW/wtWD+hGu3/3ffMc66J1VW5CiJpVEzmGSgot5l
         nnzhznb1CyKNSwPHYN9AgAA5NeYs5yMF+SdadBQ6QL9wpxWye8I0gnFNxK0RAJo0G9
         Y9bhetuZaRdIC7aG4BeKNXJptqnxBCeZraxilV8Rv5zjv2r7utR/7JhtxJVhws2Q3X
         KNsujmShwO6gw==
Date:   Sun, 6 Nov 2022 21:14:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Stefan Assmann <sassmann@kpanic.de>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, patryk.piotrowski@intel.com
Subject: Re: [PATCH net-next] iavf: check that state transitions happen under
 lock
Message-ID: <Y2gHqj18Tz66k4ZN@unreal>
References: <20221028134515.253022-1-sassmann@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028134515.253022-1-sassmann@kpanic.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 03:45:15PM +0200, Stefan Assmann wrote:
> Add a check to make sure crit_lock is being held during every state
> transition and print a warning if that's not the case. For convenience
> a wrapper is added that helps pointing out where the locking is missing.
> 
> Make an exception for iavf_probe() as that is too early in the init
> process and generates a false positive report.
> 
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/iavf/iavf.h      | 23 +++++++++++++++------
>  drivers/net/ethernet/intel/iavf/iavf_main.c |  2 +-
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
> index 3f6187c16424..28f41bbc9c86 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf.h
> @@ -498,19 +498,30 @@ static inline const char *iavf_state_str(enum iavf_state_t state)
>  	}
>  }
>  
> -static inline void iavf_change_state(struct iavf_adapter *adapter,
> -				     enum iavf_state_t state)
> +static inline void __iavf_change_state(struct iavf_adapter *adapter,
> +				       enum iavf_state_t state,
> +				       const char *func,
> +				       int line)
>  {
>  	if (adapter->state != state) {
>  		adapter->last_state = adapter->state;
>  		adapter->state = state;
>  	}
> -	dev_dbg(&adapter->pdev->dev,
> -		"state transition from:%s to:%s\n",
> -		iavf_state_str(adapter->last_state),
> -		iavf_state_str(adapter->state));
> +	if (mutex_is_locked(&adapter->crit_lock))

Please use lockdep for that, and not reinvent it.
In you case lockdep_assert_held(&adapter->crit_lock).

In addition, mutex_is_locked() doesn't check that this specific function
is locked. It checks that this lock is used now.

> +		dev_dbg(&adapter->pdev->dev, "%s:%d state transition %s to %s\n",
> +			func, line,
> +			iavf_state_str(adapter->last_state),
> +			iavf_state_str(adapter->state));
> +	else
> +		dev_warn(&adapter->pdev->dev, "%s:%d state transition %s to %s without locking!\n",
> +			 func, line,
> +			 iavf_state_str(adapter->last_state),
> +			 iavf_state_str(adapter->state));
>  }
>  
> +#define iavf_change_state(adapter, state) \
> +	__iavf_change_state(adapter, state, __func__, __LINE__)
> +
>  int iavf_up(struct iavf_adapter *adapter);
>  void iavf_down(struct iavf_adapter *adapter);
>  int iavf_process_config(struct iavf_adapter *adapter);
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 3fc572341781..bbc0c9f347a7 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -4892,7 +4892,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	hw->back = adapter;
>  
>  	adapter->msg_enable = BIT(DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
> -	iavf_change_state(adapter, __IAVF_STARTUP);
> +	adapter->state = __IAVF_STARTUP;
>  
>  	/* Call save state here because it relies on the adapter struct. */
>  	pci_save_state(pdev);
> -- 
> 2.37.3
> 
