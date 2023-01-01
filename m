Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CCA65A945
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 09:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjAAIc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 03:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAAIcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 03:32:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EECA273E;
        Sun,  1 Jan 2023 00:32:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0571560CBA;
        Sun,  1 Jan 2023 08:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F767C433EF;
        Sun,  1 Jan 2023 08:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672561942;
        bh=bbsHjJ0JkS3AgnKxQQCuXwAIuU+mqpDxReBTV+i0EVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lb1Jda9Ch4NFf6oW/o+yKMtS22KQjDd8sIZglOIIeHjAHBSoRgjIQieOngfEWoBt1
         tYXKlNCB/+LIGPIZeF9lFVrh0gdnQhkWkEQT9Z3ZdpnsoNmPbFaFJ4IZmWc+MTEl9t
         Nd05ILknaYXnn9PIdn1tp5AgkhHWja478AIMlaxxCN2NHm6MP7TjVd5So0WUFvOKQG
         onh/YU2m+4Fhym24POumGF9ch6bGGmOCL7RA/8t75FgHV3lx3dAjnmLnmhLSuyRFgY
         AijLTnoC1Xv4HDhPX9IUo+PIaciN6XhbGyc102mkTnNebiubrLzwPf4AOrCWAAxJo6
         jLdVw5YKdBMHQ==
Date:   Sun, 1 Jan 2023 10:32:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rajat.khandelwal@intel.com
Subject: Re: [PATCH] igc: Mask replay rollover/timeout errors in I225_LMVP
Message-ID: <Y7FFESJONJqGJUkb@unreal>
References: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 29, 2022 at 05:56:40PM +0530, Rajat Khandelwal wrote:
> The CPU logs get flooded with replay rollover/timeout AER errors in
> the system with i225_lmvp connected, usually inside thunderbolt devices.
> 
> One of the prominent TBT4 docks we use is HP G4 Hook2, which incorporates
> an Intel Foxville chipset, which uses the igc driver.
> On connecting ethernet, CPU logs get inundated with these errors. The point
> is we shouldn't be spamming the logs with such correctible errors as it
> confuses other kernel developers less familiar with PCI errors, support
> staff, and users who happen to look at the logs.
> 
> Signed-off-by: Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 28 +++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index ebff0e04045d..a3a6e8086c8d 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6201,6 +6201,26 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>  	return value;
>  }
>  
> +#ifdef CONFIG_PCIEAER
> +static void igc_mask_aer_replay_correctible(struct igc_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	u32 aer_pos, corr_mask;
> +
> +	if (pdev->device != IGC_DEV_ID_I225_LMVP)
> +		return;
> +
> +	aer_pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
> +	if (!aer_pos)
> +		return;
> +
> +	pci_read_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, &corr_mask);
> +
> +	corr_mask |= PCI_ERR_COR_REP_ROLL | PCI_ERR_COR_REP_TIMER;
> +	pci_write_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, corr_mask);

Shouldn't this igc_mask_aer_replay_correctible function be implemented
in drivers/pci/quirks.c and not in igc_probe()?

Thanks
