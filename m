Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBEA2CC783
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbgLBULM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:11:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbgLBULM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:11:12 -0500
Date:   Wed, 2 Dec 2020 14:10:29 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606939831;
        bh=i8Vnq+pvTHhHj/1IWA3etZDAb0TNeRlQer8PLomWRag=;
        h=From:To:Cc:Subject:In-Reply-To:From;
        b=XUGocHXmgEyD9+LeXma512Rxjr/oRoaZddwcMN6uut9D2vKacomoXW/lfh2/viOmc
         u7jzKI0DGX8iB/YimFhyu7rg+Eh4LsHFGtaqxqMqJ1kfRlQZzEMaTw2HdcXQgQp1vT
         4Ix+tZzvcKXO7ykBwZIa7QKEaGVtL0F6UrEQt27qinrTshhF1+ML3mu5rbvUFaiygG
         O4Bmn9WYojEL3cV4D/KXyjJQLB3XZol06a1FMbizfoIBOZmX4XhASkyK3Ba/hqcf0C
         9tHKfcUXM3cCobFeuY0y0EbY1weCqM+0K/MS08ttncCjSRJ7Lfydd4MnyGyQlv7UtX
         nAj1msYc+CJIA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mario Limonciello <mario.limonciello@dell.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        Vitaly Lifshits <vitaly.lifshits@intel.com>
Subject: Re: [PATCH v2 1/5] e1000e: fix S0ix flow to allow S0i3.2 subset entry
Message-ID: <20201202201029.GA1464938@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202161748.128938-2-mario.limonciello@dell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 10:17:44AM -0600, Mario Limonciello wrote:
> From: Vitaly Lifshits <vitaly.lifshits@intel.com>
> 
> Changed a configuration in the flows to align with
> architecture requirements to achieve S0i3.2 substate.

I guess this is really talking about requirements of a specific
CPU/SOC before it will enter S0i3.2?

> Also fixed a typo in the previous commit 632fbd5eb5b0
> ("e1000e: fix S0ix flows for cable connected case").

Not clear what the typo was, maybe these?

  > -	ew32(FEXTNVM12, mac_data);
  > +	ew32(FEXTNVM6, mac_data);

  > -	ew32(FEXTNVM12, mac_data);
  > +	ew32(FEXTNVM6, mac_data);

I would probably have put typo fixes in a separate patch, especially
since the cover letter mentions regressions related to 632fbd5eb5b0.
Maybe the commit log for the fix should mention that it's fixing a
regression, what the regression was, and include a Fixes: tag?  But
not my circus.

> Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index b30f00891c03..128ab6898070 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6475,13 +6475,13 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>  
>  	/* Ungate PGCB clock */
>  	mac_data = er32(FEXTNVM9);
> -	mac_data |= BIT(28);
> +	mac_data &= ~BIT(28);
>  	ew32(FEXTNVM9, mac_data);
>  
>  	/* Enable K1 off to enable mPHY Power Gating */
>  	mac_data = er32(FEXTNVM6);
>  	mac_data |= BIT(31);
> -	ew32(FEXTNVM12, mac_data);
> +	ew32(FEXTNVM6, mac_data);
>  
>  	/* Enable mPHY power gating for any link and speed */
>  	mac_data = er32(FEXTNVM8);
> @@ -6525,11 +6525,11 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>  	/* Disable K1 off */
>  	mac_data = er32(FEXTNVM6);
>  	mac_data &= ~BIT(31);
> -	ew32(FEXTNVM12, mac_data);
> +	ew32(FEXTNVM6, mac_data);
>  
>  	/* Disable Ungate PGCB clock */
>  	mac_data = er32(FEXTNVM9);
> -	mac_data &= ~BIT(28);
> +	mac_data |= BIT(28);
>  	ew32(FEXTNVM9, mac_data);
>  
>  	/* Cancel not waking from dynamic
> -- 
> 2.25.1
> 
