Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B217DEA3DD
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfJ3TMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:12:48 -0400
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:37330 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726259AbfJ3TMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 15:12:48 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 732FD4C0096;
        Wed, 30 Oct 2019 19:12:46 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 30 Oct
 2019 19:12:39 +0000
Subject: Re: [PATCH] sfc: should check the return value after allocating
 memory
To:     zhong jiang <zhongjiang@huawei.com>, <davem@davemloft.net>
CC:     <mhabets@solarflare.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1572426765-43211-1-git-send-email-zhongjiang@huawei.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <337f8acc-63d0-4a0b-f112-0e7be1a7e51f@solarflare.com>
Date:   Wed, 30 Oct 2019 19:12:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1572426765-43211-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25010.003
X-TM-AS-Result: No-10.147300-8.000000-10
X-TMASE-MatchedRID: csPTYAMX1+G8rRvefcjeTUPdsiR0fGlp69aS+7/zbj+qvcIF1TcLYJGW
        qGxfG/4gr/8sDK1kxPZTvVffeIwvQwUcfW/oedmqPwKTD1v8YV5MkOX0UoduuQ26c11hS9dDhYb
        DU23Mt3nfzLo6YdZ9oal+qkmFWiM7TIunQAI8qaIsIMJqMNlanczzMs2dyeyVnvO/7zfSaU/QDj
        kgBdHEzeAtk5EGzSDBkZOl7WKIImrvXOvQVlExsFZ0V5tYhzdWxEHRux+uk8h+ICquNi0WJHtBE
        lp7ch+v0yUsncabz9G5BWEde06qE1QLrVa0g2b3ftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.147300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25010.003
X-MDID: 1572462767-cdwbMBp8yqAx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/10/2019 09:12, zhong jiang wrote:
> kcalloc may fails to allocate memory, hence if it is in that case,
> We should drop out in time.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/net/ethernet/sfc/efx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 2fef740..712380a 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -3040,6 +3040,8 @@ static int efx_init_struct(struct efx_nic *efx,
>  	/* Failure to allocate is not fatal, but may degrade ARFS performance */
>  	efx->rps_hash_table = kcalloc(EFX_ARFS_HASH_TABLE_SIZE,
>  				      sizeof(*efx->rps_hash_table), GFP_KERNEL);
> +	if (!efx->rps_hash_table)
> +		goto fail;
NAK.
As per the comment just above the allocation, if this allocation fails we are
 able to continue (albeit with possibly reduced performance), since the code
 paths that use efx->rps_hash_table all NULL-check it.

-Ed
>  #endif
>  	efx->phy_op = &efx_dummy_phy_operations;
>  	efx->mdio.dev = net_dev;
> 
