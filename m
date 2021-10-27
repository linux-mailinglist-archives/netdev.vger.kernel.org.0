Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885D043D753
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 01:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhJ0XOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 19:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhJ0XOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 19:14:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39EE261039;
        Wed, 27 Oct 2021 23:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635376296;
        bh=KupXla6YPxmj/KDqeXF6aCfkYzKjNPRj7wkgKckspAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=JP/IXa/AtHXZjOK8OOVkusbwcJ0+wmuhjsoZdzhuQzYvfbNTLj9cMuc5hbT+99OaQ
         CU4Tjg87Pe2GxOvGEqyS9v+df74g04Ls1UC1r+IXcaYKmn/nyqns4h0k0LUNmdSXZD
         YZRpC2Q36KRXevnEbf1U63vhL2iPilwZNkptidUX7vh4NlKdKY4zItXRhbXtH9evhH
         VPwzD9cTou0f5J6WhiM6ZAanZITObAc5kdTkJI/rfRPMcxO43q+tVmqvsARYU2tdbY
         A0zTWL0WNMrMYpfDFemz8SreLax956zfOHlyWQR9NkuT6BpXhejuxXifLa+5jXoHqv
         CTy8FoOa31rsw==
Date:   Wed, 27 Oct 2021 18:11:34 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V10 6/8] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
Message-ID: <20211027231134.GA258571@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211009104938.48225-7-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 06:49:36PM +0800, Dongdong Liu wrote:
> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
> 10-Bit Tag Requester doesn't interact with a device that does not
> support 10-Bit Tag Completer. Before that happens, the kernel should
> emit a warning.

> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

> @@ -532,6 +577,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>  		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>  	}
>  done:
> +	if (pci_10bit_tags_unsupported(client, provider, verbose))
> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;

I need to be convinced that this check is in the right spot to catch
all potential P2PDMA situations.  The pci_p2pmem_find() and
pci_p2pdma_distance() interfaces eventually call
calc_map_type_and_dist().  But those interfaces don't actually produce
DMA bus addresses, and I'm not convinced that all P2PDMA users use
them.

nvme *does* use them, but infiniband (rdma_rw_map_sg()) does not, and
it calls pci_p2pdma_map_sg().

amdgpu_dma_buf_attach() calls pci_p2pdma_distance_many() but I don't
know where it sets up P2PDMA transactions.

cxgb4 and qed mention "peer2peer", but I don't know whether they are
related; they don't seem to use any pci_p2p.* interfaces.

>  	rcu_read_lock();
>  	p2pdma = rcu_dereference(provider->p2pdma);
>  	if (p2pdma)
> -- 
> 2.22.0
> 
