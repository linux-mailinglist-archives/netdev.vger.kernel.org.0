Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F86C29677D
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 01:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373147AbgJVXES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 19:04:18 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:47630 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S373136AbgJVXES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 19:04:18 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 21AE51281E42;
        Thu, 22 Oct 2020 16:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1603407858;
        bh=YF9ZLRJ5Wmd29VMCSDUBdN9scxQBSKiZF6i1sPMZ4cs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Rp43OBNeRff7l6xXQQprJM/m/WMbF15ErMCUULCrOGIpWCNqppgte+USb5NryvBJ5
         War0Kohqc5idoDlXO+afQei1xfY//CINxzd3xmUM3zW/BrEbGtPgJCAUCtusJ41H2q
         ZqwBd/RzMW6JiIiE1aUEqb3gsIRU2wNiUMyhtghs=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Q3sVWPD8CWVy; Thu, 22 Oct 2020 16:04:18 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 759B41281E39;
        Thu, 22 Oct 2020 16:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1603407857;
        bh=YF9ZLRJ5Wmd29VMCSDUBdN9scxQBSKiZF6i1sPMZ4cs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mBMQkLZBj9y05L4DkBJ+6L7KVSJNkpwwj8Zle4lznjtwYUJu+0MqDsmQnbVz9vlA3
         IyiV2YPkSZ5LVBnyRQUiwij5DmcUrmGCVSXXsnKtc5qZmFrqYM2+08vIYtr35rd1oP
         aTqAKkb2akyYD7It4zMkcKI4NAiK2FUCp5LlcFdM=
Message-ID: <f1ff32ec2970f1ee808e2da946e6514e71694e71.camel@HansenPartnership.com>
Subject: Re: [PATCH/RFC net] net: dec: tulip: de2104x: Add shutdown handler
 to stop NIC
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Moritz Fischer <mdf@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lucyyan@google.com
Date:   Thu, 22 Oct 2020 16:04:16 -0700
In-Reply-To: <20201022220636.609956-1-mdf@kernel.org>
References: <20201022220636.609956-1-mdf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-22 at 15:06 -0700, Moritz Fischer wrote:
> The driver does not implement a shutdown handler which leads to
> issues
> when using kexec in certain scenarios. The NIC keeps on fetching
> descriptors which gets flagged by the IOMMU with errors like this:
> 
> DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> 
> Signed-off-by: Moritz Fischer <mdf@kernel.org>
> ---
> 
> Hi all,
> 
> I'm not sure if this is the proper way for a shutdown handler,
> I've tried to look at a bunch of examples and couldn't find a
> specific
> solution, in my tests on hardware this works, though.
> 
> Open to suggestions.
> 
> Thanks,
> Moritz
> 
> ---
>  drivers/net/ethernet/dec/tulip/de2104x.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c
> b/drivers/net/ethernet/dec/tulip/de2104x.c
> index f1a2da15dd0a..372c62c7e60f 100644
> --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> @@ -2185,6 +2185,7 @@ static struct pci_driver de_driver = {
>  	.id_table	= de_pci_tbl,
>  	.probe		= de_init_one,
>  	.remove		= de_remove_one,
> +	.shutdown	= de_remove_one,

This doesn't look right: shutdown is supposed to turn off the device
without disturbing the tree or causing any knock on effects (I think
that rule is mostly because you don't want anything in userspace
triggering since it's likely to be nearly dead).  Remove removes the
device from the tree and cleans up everything.  I think the function
you want that's closest to what shutdown needs is de_close().  That
basically just turns off the chip and frees the interrupt ... you'll
have to wrapper it to call it from the pci_driver, though.

James


