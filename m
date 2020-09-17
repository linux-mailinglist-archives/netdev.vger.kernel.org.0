Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CCD26D368
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIQGHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgIQGHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 02:07:02 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D33C208E4;
        Thu, 17 Sep 2020 06:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600322821;
        bh=ZLbv09k/WindJliwiwRtim5+wmB7oRN4BCyv10ZkPQs=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=boUTmplWffbtQ1BEF8fUyVFSOvRFUi3jD137Oh0hLoMp/Mm0yYnDCOp9bt4UnImUN
         8L9JXlOJJumW4w0hN1QfG1VtvHzwTkPWw+93n9PuU/MjOiB+Kcasw1t0mk84a1KRKv
         5nptt7HE4tNGkBVSCuaoG5SMms7s3VLaQChuCh+w=
Message-ID: <0a335b1f7532fb6bd3d8e685a52d691760b1e226.camel@kernel.org>
Subject: Re: [PATCH net] ibmvnic: Fix returning uninitialized return code
From:   Saeed Mahameed <saeed@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org
Date:   Wed, 16 Sep 2020 23:07:00 -0700
In-Reply-To: <1600294357-19302-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1600294357-19302-1-git-send-email-tlfalcon@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-16 at 17:12 -0500, Thomas Falcon wrote:
> If successful, __ibmvnic_open and reset_sub_crq_queues,
> if no device queues exist, will return an uninitialized
> variable rc. Return zero on success instead.
> 
> Fixes: 57a49436f4e8 ("ibmvnic: Reset sub-crqs during driver reset")
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 1b702a4..1619311 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1178,7 +1178,7 @@ static int __ibmvnic_open(struct net_device
> *netdev)
>  	}
>  
>  	adapter->state = VNIC_OPEN;
> -	return rc;
> +	return 0;

rc here is unconditionally assigned a couple of lines earlier, 
but anyway i don't mind this change as it explicitly states that this
is a success path.

But maybe you want to split the patch and send this hunk to net-next.
I don't mind, up to you.

>  }
>  
>  static int ibmvnic_open(struct net_device *netdev)
> @@ -2862,7 +2862,7 @@ static int reset_sub_crq_queues(struct
> ibmvnic_adapter *adapter)
>  			return rc;
>  	}
>  
> -	return rc;
> +	return 0;

This one though is fine,

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


