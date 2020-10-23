Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E19B297812
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755839AbgJWUIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373801AbgJWUIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 16:08:19 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EBB52074B;
        Fri, 23 Oct 2020 20:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603483698;
        bh=PBxDsNa9eupj497fDh0fJdE39YKr8dT/TwIlRRt4n6E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PqADASWMcA8kWsb62wYmFIYJCEWyAAoVlkXNLtKXxvzB1CdxBadLa6r03CGShshpw
         3PRVW+/C5TSzvIbPBNVaCARohCkGY702I7zLN/OPFlkKXv6p6rC+31NRCKf+tIA3RT
         aH9BgDioWNpROO1UqK34wDAeTsB7ouQKkcl0SFJ0=
Date:   Fri, 23 Oct 2020 13:08:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moritz Fischer <mdf@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lucyyan@google.com, moritzf@google.com,
        James.Bottomley@hansenpartnership.com
Subject: Re: [PATCH/RFC net v2] net: dec: tulip: de2104x: Add shutdown
 handler to stop NIC
Message-ID: <20201023130816.7abd450d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023024520.626132-1-mdf@kernel.org>
References: <20201023024520.626132-1-mdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 19:45:20 -0700 Moritz Fischer wrote:
> The driver does not implement a shutdown handler which leads to issues
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

Change looks good.

Philosophically speaking I wonder if this is a fix or a feature.
If missing .shutdown callback was a bug we shouldn't accept drivers
which don't specify it :S

If you don't have a strong preference I'd rather apply this to net-next.

In any case - you need to respin, 'cause this does not apply to net
either :)

> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
> index f1a2da15dd0a..6de0cd6cf4ca 100644
> --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> @@ -2180,11 +2180,19 @@ static int de_resume (struct pci_dev *pdev)
>  
>  #endif /* CONFIG_PM */
>  
> +static void de_shutdown(struct pci_dev *pdev)
> +{
> +	struct net_device *dev = pci_get_drvdata (pdev);

No space needed before parens

> +
> +	de_close(dev);
> +}
> +
>  static struct pci_driver de_driver = {
>  	.name		= DRV_NAME,
>  	.id_table	= de_pci_tbl,
>  	.probe		= de_init_one,
>  	.remove		= de_remove_one,
> +	.shutdown	= de_shutdown,
>  #ifdef CONFIG_PM
>  	.suspend	= de_suspend,
>  	.resume		= de_resume,

