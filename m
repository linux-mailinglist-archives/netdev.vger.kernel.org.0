Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6303A16C29A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbgBYNml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:42:41 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:35620 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728981AbgBYNml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:42:41 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4B596700068;
        Tue, 25 Feb 2020 13:42:39 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 25 Feb
 2020 13:42:34 +0000
Subject: Re: [PATCH][next] sfc: Replace zero-length array with flexible-array
 member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "Edward Cree" <ecree@solarflare.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200225000647.GA17795@embeddedor>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <6a100eb2-4ba1-32ac-35de-d02c38503785@solarflare.com>
Date:   Tue, 25 Feb 2020 13:42:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225000647.GA17795@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25252.003
X-TM-AS-Result: No-10.655800-8.000000-10
X-TMASE-MatchedRID: X4bcv0S75KkTf5FwcC9U6CfCNCZngofd55N6T4jLy13k1kyQDpEj8MWl
        hj9iHeVpC75+d7CNAsqoHbfn8Xg6yNihbmNSwFRagFdEw7Z/6OS//2i/GlO8gJh4xM9oAcstY02
        UYybf3M4SFHd9tJycACiRKIoWVVPgaFlk0tAiKs4zvWHRIxWXwoBOBQVQ0d5DyyHzeHLBznhZ23
        5fWYWb/aWYbk3spbXPtpnViTLW7POQbsqx4XamQf9N7e3lwkwb+KgiyLtJrSAn+p552csI1SaCj
        kFKp/+etUtkYrqSb3dk1/zd/XzAp6H2g9syPs888Kg68su2wyHg4HeIMbqKSR1rVWTdGrE4cijM
        Zrr2iZ2t2gtuWr1LmnPL3KdKFhM8lwV2iaAfSWc5f9Xw/xqKXVkMvWAuahr8+gD2vYtOFhgqtq5
        d3cxkNXs+im8txHUAA5S87IkwgmwJdDuHsDctpRd+BlXlaEP9E9Xo+T/jy3I=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.655800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25252.003
X-MDID: 1582638160-aZk24vndFM_D
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/02/2020 00:06, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]

These padding fields are only used to enforce alignment of the struct.
But the patch is still ok.

> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Martin Habets <mhabets@solarflare.com>

> ---
>  drivers/net/ethernet/sfc/falcon/net_driver.h | 2 +-
>  drivers/net/ethernet/sfc/net_driver.h        | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
> index a49ea2e719b6..a529ff395ead 100644
> --- a/drivers/net/ethernet/sfc/falcon/net_driver.h
> +++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
> @@ -288,7 +288,7 @@ struct ef4_rx_buffer {
>  struct ef4_rx_page_state {
>  	dma_addr_t dma_addr;
>  
> -	unsigned int __pad[0] ____cacheline_aligned;
> +	unsigned int __pad[] ____cacheline_aligned;
>  };
>  
>  /**
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 9f9886f222c8..392bd5b7017e 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -336,7 +336,7 @@ struct efx_rx_buffer {
>  struct efx_rx_page_state {
>  	dma_addr_t dma_addr;
>  
> -	unsigned int __pad[0] ____cacheline_aligned;
> +	unsigned int __pad[] ____cacheline_aligned;
>  };
>  
>  /**
> 
