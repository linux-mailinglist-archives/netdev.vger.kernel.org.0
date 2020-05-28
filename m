Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EEA1E6B1F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406653AbgE1TfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406647AbgE1TfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 15:35:08 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6936A2078C;
        Thu, 28 May 2020 19:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590694507;
        bh=OWLKCU7KQGNacnB15hHj6riNDAs958qPxB6r1+7vpiA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zNztFQPNPfdwkX38qiOCaeviJApt7/pupinol4AlwxiOHdYbDQzgoX/mP7c96myzf
         W3nNb1HHGaBFCIuubWJFACKdwwD2uXJJz/WW7tyFgSzUxRSwbqn/4VufQAxYLf7eON
         8nhTXLmBDCD0rWHCXMRL81JAZFgyA+0YfGDi4gao=
Date:   Thu, 28 May 2020 12:35:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     <netdev@vger.kernel.org>, "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 3/4] vmxnet3: add geneve and vxlan tunnel
 offload support
Message-ID: <20200528123505.25baf888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200528183615.27212-4-doshir@vmware.com>
References: <20200528183615.27212-1-doshir@vmware.com>
        <20200528183615.27212-4-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 11:36:14 -0700 Ronak Doshi wrote:
> @@ -1168,13 +1220,21 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
>  		    (le32_to_cpu(gdesc->dword[3]) &
>  		     VMXNET3_RCD_CSUM_OK) == VMXNET3_RCD_CSUM_OK) {
>  			skb->ip_summed = CHECKSUM_UNNECESSARY;
> -			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp));
> -			BUG_ON(gdesc->rcd.frg);
> +			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
> +			       !(le32_to_cpu(gdesc->dword[0]) &
> +				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
> +			BUG_ON(gdesc->rcd.frg &&
> +			       !(le32_to_cpu(gdesc->dword[0]) &
> +				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
>  		} else if (gdesc->rcd.v6 && (le32_to_cpu(gdesc->dword[3]) &
>  					     (1 << VMXNET3_RCD_TUC_SHIFT))) {
>  			skb->ip_summed = CHECKSUM_UNNECESSARY;
> -			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp));
> -			BUG_ON(gdesc->rcd.frg);
> +			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
> +			       !(le32_to_cpu(gdesc->dword[0]) &
> +				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
> +			BUG_ON(gdesc->rcd.frg &&
> +			       !(le32_to_cpu(gdesc->dword[0]) &
> +				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
>  		} else {
>  			if (gdesc->rcd.csum) {
>  				skb->csum = htons(gdesc->rcd.csum);

Seems fairly extreme to trigger BUG_ONs if rx descriptor doesn't
contain valid checksum offload flags :S WARN_ON_ONCE() and ignore 
checsum or drop packet would be more than sufficient.
