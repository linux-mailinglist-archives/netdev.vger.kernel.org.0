Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F8420B8E4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgFZTAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgFZTAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 15:00:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F4382053B;
        Fri, 26 Jun 2020 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593198010;
        bh=6vHSP1w6dFjwBOQAK5qD/4paXrcZVPDo1KYzjxCrMeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZPuuwk/sVR93b3PWXoMsF3HpnJSn8YzrI3SP2xiJKY+5NIq4b3jWdoxM79Jgod1A0
         KSyEi1jJWmIRxGZx4dKYKu6WzwLTYd+fAj4ppVrIFw4/71KX8Ea0PwAjetmwEfuepC
         zhsYtncCDF1YIcjBGv3HWuenauyultbk2XkXtbTI=
Date:   Fri, 26 Jun 2020 12:00:08 -0700
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
Subject: Re: [net-next v3 09/15] iecm: Init and allocate vport
Message-ID: <20200626120008.43fe087f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626020737.775377-10-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-10-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 19:07:31 -0700 Jeff Kirsher wrote:
> @@ -532,7 +540,12 @@ static void iecm_service_task(struct work_struct *work)
>   */
>  static void iecm_up_complete(struct iecm_vport *vport)
>  {
> -	/* stub */
> +	netif_set_real_num_rx_queues(vport->netdev, vport->num_txq);
> +	netif_set_real_num_tx_queues(vport->netdev, vport->num_rxq);

These can fail.

> +	netif_carrier_on(vport->netdev);
> +	netif_tx_start_all_queues(vport->netdev);
> +
> +	vport->adapter->state = __IECM_UP;
>  }
