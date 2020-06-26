Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D00620B8DB
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgFZS5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgFZS5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 14:57:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61B4A2053B;
        Fri, 26 Jun 2020 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593197826;
        bh=ga9QcAFBEb/ZaVBLq07Or6LWyuGCp8WUM+IUjs4NkPw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h4CwIFFYKtIHPlq1qWa2Cz1pvozhKOikliG4LBTz3JZDRxJX4525msu3Bl83hOTtB
         NWsy0M+IeNLA3s5L1uzorm1Go2GLX8TCMJ3RgupZ1RXxQQPgAvgJINyPvDf4X6yoME
         ySIOt+Z7Nwoqltc3O2zaSiwCU2aKMkP+SUe0EHGQ=
Date:   Fri, 26 Jun 2020 11:57:04 -0700
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
Message-ID: <20200626115704.1439eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
> @@ -978,7 +1059,20 @@ static int iecm_open(struct net_device *netdev)
>   */
>  static int iecm_change_mtu(struct net_device *netdev, int new_mtu)
>  {
> -	/* stub */
> +	struct iecm_vport *vport =  iecm_netdev_to_vport(netdev);
> +
> +	if (new_mtu < netdev->min_mtu) {
> +		netdev_err(netdev, "new MTU invalid. min_mtu is %d\n",
> +			   netdev->min_mtu);
> +		return -EINVAL;
> +	} else if (new_mtu > netdev->max_mtu) {
> +		netdev_err(netdev, "new MTU invalid. max_mtu is %d\n",
> +			   netdev->max_mtu);
> +		return -EINVAL;
> +	}

Core already checks this. Please remove all checks which core already
does.

> +	netdev->mtu = new_mtu;
> +
> +	return iecm_initiate_soft_reset(vport, __IECM_SR_MTU_CHANGE);
>  }
