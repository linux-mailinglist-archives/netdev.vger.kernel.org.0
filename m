Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE82B306955
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhA1BEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:04:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231195AbhA1BBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:01:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D98A261492;
        Thu, 28 Jan 2021 01:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611795667;
        bh=pt/Pn7kT9yfvr3cFL5ULzyqJnP5IMgGvj2ng4j6FLRY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WJrnyw5hla/iFK73V2ZIP37NUDVr45OdY+K9mNjvVDrPFFeosSR9p6unK++j2iWTA
         FSh0GFIwYahRXxnjmUmwmX2kOOTPyclxOtI5O8Xldgn9qVxopuNezKpq1El8yrn3kx
         l4Emlku6XyZcudSMRPI83RmT9ICv0zCoUxcdFkQbnYJAJcKEPYohpRsDs/NpYcbB/r
         7MT80q1eA4HNetMmDDD0u+ynsAq0l+OedRD57asJocjaBb94c1LxQtF3oYP9UxuDCM
         HMjyxEysWbKNlovMyRaSnT071L0e73yA1YO4/w9wRbWf3BJzd5P6LoYAvEyo/SurdD
         hmScMrNw26RGA==
Date:   Wed, 27 Jan 2021 17:01:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net v2] ibmvnic: Ensure that CRQ entry read are
 correctly ordered
Message-ID: <20210127170105.011ebb9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125232023.78649-1-ljp@linux.ibm.com>
References: <20210125232023.78649-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 17:20:23 -0600 Lijun Pan wrote:
> Ensure that received Command-Response Queue (CRQ) entries are
> properly read in order by the driver. dma_rmb barrier has
> been added before accessing the CRQ descriptor to ensure
> the entire descriptor is read before processing.
> 
> Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
> v2: drop dma_wmb according to Jakub's opinion
> 
>  drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 9778c83150f1..d84369bd5fc9 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -5084,6 +5084,14 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
>  	while (!done) {
>  		/* Pull all the valid messages off the CRQ */
>  		while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
> +			/* Ensure that the entire CRQ descriptor queue->msgs
> +			 * has been loaded before reading its contents.

I still find this sentence confusing, maybe you mean to say stored
instead of loaded?

> +			 * This barrier makes sure ibmvnic_next_crq()'s
> +			 * crq->generic.first & IBMVNIC_CRQ_CMD_RSP is loaded
> +			 * before ibmvnic_handle_crq()'s
> +			 * switch(gen_crq->first) and switch(gen_crq->cmd).

Yup, that makes perfect sense. It's about ordering of the loads. 

> +			 */
> +			dma_rmb();
>  			ibmvnic_handle_crq(crq, adapter);
>  			crq->generic.first = 0;
>  		}

