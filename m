Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E4E20B927
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgFZTOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFZTOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 15:14:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCCCF2075A;
        Fri, 26 Jun 2020 19:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593198882;
        bh=lnrt8GUCJ8h0o7ci83qpCvOyBW+tLSLOaKoJm0olDpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HGSziOFD3sBnndury0+IegOH+4Y36b4sEIF41/A1zQlyES8jcds88n5goUkFoq8p0
         YRXsG42ZRSt5IV6TOwmN8oYm9LjdwLNhNWbEZexbii8869TEm9/2mE0RTxx5oX0epF
         DfnQ+70v1JeSiCflUoN1Kw44a/R0k0pXCCrgNsiE=
Date:   Fri, 26 Jun 2020 12:14:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v3 13/15] iecm: Add ethtool
Message-ID: <20200626121440.179db33c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 19:07:35 -0700 Jeff Kirsher wrote:
> diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c b/drivers/net/ethernet/intel/iecm/iecm_lib.c
> index d34834422049..a55151495e18 100644
> --- a/drivers/net/ethernet/intel/iecm/iecm_lib.c
> +++ b/drivers/net/ethernet/intel/iecm/iecm_lib.c
> @@ -765,7 +765,37 @@ static void iecm_deinit_task(struct iecm_adapter *adapter)
>  static enum iecm_status
>  iecm_init_hard_reset(struct iecm_adapter *adapter)
>  {
> -	/* stub */
> +	enum iecm_status err;
> +
> +	/* Prepare for reset */
> +	if (test_bit(__IECM_HR_FUNC_RESET, adapter->flags)) {
> +		iecm_deinit_task(adapter);
> +		adapter->dev_ops.reg_ops.trigger_reset(adapter,
> +						       __IECM_HR_FUNC_RESET);
> +		set_bit(__IECM_UP_REQUESTED, adapter->flags);
> +		clear_bit(__IECM_HR_FUNC_RESET, adapter->flags);
> +	} else if (test_bit(__IECM_HR_CORE_RESET, adapter->flags)) {
> +		if (adapter->state == __IECM_UP)
> +			set_bit(__IECM_UP_REQUESTED, adapter->flags);
> +		iecm_deinit_task(adapter);
> +		clear_bit(__IECM_HR_CORE_RESET, adapter->flags);
> +	} else if (test_and_clear_bit(__IECM_HR_DRV_LOAD, adapter->flags)) {
> +	/* Trigger reset */
> +	} else {
> +		dev_err(&adapter->pdev->dev, "Unhandled hard reset cause\n");
> +		err = IECM_ERR_PARAM;
> +		goto handle_err;
> +	}
> +
> +	/* Reset is complete and so start building the driver resources again */
> +	err = iecm_init_dflt_mbx(adapter);
> +	if (err) {
> +		dev_err(&adapter->pdev->dev, "Failed to initialize default mailbox: %d\n",
> +			err);
> +	}
> +handle_err:
> +	mutex_unlock(&adapter->reset_lock);
> +	return err;
>  }

Please limit the use of iecm_status to the absolute necessary minimum.

If FW reports those back, they should be converted to normal Linux
errors in the handler of FW communication and not leak all over the
driver like that.

Having had to modify i40e recently - I find it very frustrating to not 
be able to propagate normal errors throughout the driver. The driver-
-specific codes are a real PITA for people doing re-factoring work.
