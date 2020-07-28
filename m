Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4E82313B2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgG1UPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgG1UPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:15:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A36A20656;
        Tue, 28 Jul 2020 20:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595967314;
        bh=+0/Tt/cgMByGA/5mXxjhj1YBVP87pnD13pT7Mmo6C3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UDbh++HfZQYN7VLYomAu7FJrQhRZqksHVltd4gfL+HeqqLenyBI4wxv+o+T5ZefDk
         gRapAY7Gnjo45rcUok3g6T2JZBvaNzx9NKMOSO8dqLkiVgB6Ey639lU3WtLvTUvdfM
         Q+0AwYcke5a2+EeFm2abvBS/mQ45IMNHcAsR85Wc=
Date:   Tue, 28 Jul 2020 13:15:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 5/6] i40e, xsk: increase budget for AF_XDP path
Message-ID: <20200728131512.17c41621@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728190842.1284145-6-anthony.l.nguyen@intel.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
        <20200728190842.1284145-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 12:08:41 -0700 Tony Nguyen wrote:
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index 1f2dd591dbf1..99f4afdc403d 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -265,6 +265,8 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
>  	rx_ring->next_to_clean = ntc;
>  }
>  
> +#define I40E_XSK_CLEAN_RX_BUDGET 256U
> +
>  /**
>   * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
>   * @rx_ring: Rx ring
> @@ -280,7 +282,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
>  	bool failure = false;
>  	struct sk_buff *skb;
>  
> -	while (likely(total_rx_packets < (unsigned int)budget)) {
> +	while (likely(total_rx_packets < I40E_XSK_CLEAN_RX_BUDGET)) {
>  		union i40e_rx_desc *rx_desc;
>  		struct xdp_buff **bi;
>  		unsigned int size;

Should this perhaps be a common things that drivers do?

Should we define a "XSK_NAPI_WEIGHT_MULT 4" instead of hard coding the
value in a driver?
