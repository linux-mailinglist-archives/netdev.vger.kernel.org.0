Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FEE2313B1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgG1UO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgG1UOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:14:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 172B820656;
        Tue, 28 Jul 2020 20:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595967265;
        bh=oghM882DMjZDxEioymAmlnNFQOgo8v4qOv8PXLu1OKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U3aKrGZGWufHVYkrpzNh6xc5rFRVFf0j6FyhjHkkLW+e4GrK0Gmb+3PNYALHKNaR7
         4qq6Y6p4e78tj/WOtYmCJ67H+gS1Sl2PSbwi9/1MMew5bmQ6XnS99EDK0ML/z4jIOB
         +tL+dsOa9MwlfnJn0zPluWMhJWRHIuoS/Q+GZF20=
Date:   Tue, 28 Jul 2020 13:14:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Li RongQing <lirongqing@baidu.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 2/6] i40e: prefetch struct page of Rx buffer
 conditionally
Message-ID: <20200728131423.2430b3f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728190842.1284145-3-anthony.l.nguyen@intel.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
        <20200728190842.1284145-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 12:08:38 -0700 Tony Nguyen wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> page_address() accesses struct page only when WANT_PAGE_VIRTUAL
> or HASHED_PAGE_VIRTUAL is defined, otherwise it returns address
> based on offset, so we prefetch it conditionally
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index 3e5c566ceb01..5d408fe26063 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -1953,7 +1953,9 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
>  	struct i40e_rx_buffer *rx_buffer;
>  
>  	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
> +#if defined(WANT_PAGE_VIRTUAL) || defined(HASHED_PAGE_VIRTUAL)
>  	prefetchw(rx_buffer->page);
> +#endif

Looks like something that belongs in a common header not (potentially
multiple) C sources.
