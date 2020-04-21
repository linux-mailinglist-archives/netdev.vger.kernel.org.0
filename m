Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F6E1B2EA9
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgDUR7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgDUR7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 13:59:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2808206D5;
        Tue, 21 Apr 2020 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587491979;
        bh=sLOSxNI1GEgsMyFACt6uHinTA75l4f85Z5eh3FNgds4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T5nrjXdY03Du2hdCtMMPup3A0cpiKWjIpkKNIMBpr8nPnSO+81sq9sIZfCm8XjshJ
         3+invsmFu1Tq3K9wYh0DuxHr4Fm7gHkVe5Wo+bYT8D+8q1ZgFV8NvCAQELEaGOzC1h
         82zwh6CZNVYNL+mN5TfI6FrzCCilEirBnU02/o+I=
Date:   Tue, 21 Apr 2020 10:59:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Todd Fujinaka <todd.fujinaka@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 4/4] i40e: Add a check to see if MFS is set
Message-ID: <20200421105935.4a92485f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200421014932.2743607-5-jeffrey.t.kirsher@intel.com>
References: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
        <20200421014932.2743607-5-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Apr 2020 18:49:32 -0700 Jeff Kirsher wrote:
> From: Todd Fujinaka <todd.fujinaka@intel.com>
> 
> A customer was chain-booting to provision his systems and one of the
> steps was setting MFS. MFS isn't cleared by normal warm reboots
> (clearing requires a GLOBR) and there was no indication of why Jumbo
> Frame receives were failing.
> 
> Add a warning if MFS is set to anything lower than the default.
> 
> Signed-off-by: Todd Fujinaka <todd.fujinaka@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 4c414208a22a..3fdbfede0b87 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -15347,6 +15347,15 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  			i40e_stat_str(&pf->hw, err),
>  			i40e_aq_str(&pf->hw, pf->hw.aq.asq_last_status));
>  
> +	/* make sure the MFS hasn't been set lower than the default */
> +#define MAX_FRAME_SIZE_DEFAULT 0x2600
> +	for (i = 0; i < 4; i++) {

Why is this a loop? AFAICS @i is only used in the warning message

> +		val = ((rd32(&pf->hw, I40E_PRTGL_SAH) & I40E_PRTGL_SAH_MFS_MASK)
> +			>> I40E_PRTGL_SAH_MFS_SHIFT);

outer parens unnecessary

> +		if (val < MAX_FRAME_SIZE_DEFAULT)
> +			dev_warn(&pdev->dev, "MFS for port %x has been set below the default: %x\n", i, val);

Shouldn't you just reset it to default at this point? If the value is
not reset on warm boot this is not really a surprise.

> +	}
> +
>  	/* Add a filter to drop all Flow control frames from any VSI from being
>  	 * transmitted. By doing so we stop a malicious VF from sending out
>  	 * PAUSE or PFC frames and potentially controlling traffic for other

