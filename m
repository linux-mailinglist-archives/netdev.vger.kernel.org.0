Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB4C3D398D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhGWKw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234255AbhGWKw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 06:52:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9F8E608FE;
        Fri, 23 Jul 2021 11:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627039980;
        bh=E12Fd6tOLIFaPm0JI7r7SizcNQfxlTR9E3+Kw2yKqlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ffd9dTE9bW+IqGdXzw4oAaC3o2Tmzmp2Djhlph+vr15VQgZeCFyAOW6lBaC4OJfMp
         aq/Y9YjO79OjzJgMzA4S7MJUSP+LeABQZvGeOIiGTAsjRoqos8NWsaxo1a0XpJjzql
         0hlxZ41tqIjX5a7EC8uMlZmvSWe6FzVmsGmtsa2DqGqYNsPAmlOpGPgo+3C21GE3zp
         wTBJre4ZjwHIbTao930P8JF3kDxrZfVG+hSxj1B8hKb8QTZeYzQy6jpTZDCk4nMZ+9
         3a6bQ0A4sdRCgq0JO1CNJAH9iJssPdugMN0EKjhisiOfVY+8746XXW/H3TrYGvYYIX
         Kobd5U/hrqhPQ==
Date:   Fri, 23 Jul 2021 14:32:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, kw@linux.com,
        logang@deltatee.com, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V6 7/8] PCI: Add "pci=disable_10bit_tag=" parameter for
 peer-to-peer support
Message-ID: <YPqo6M0AKWLupvNU@unreal>
References: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
 <1627038402-114183-8-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627038402-114183-8-git-send-email-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 07:06:41PM +0800, Dongdong Liu wrote:
> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
> sending Requests to other Endpoints (as opposed to host memory), the
> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
> unless an implementation-specific mechanism determines that the Endpoint
> supports 10-Bit Tag Completer capability. Add "pci=disable_10bit_tag="
> parameter to disable 10-Bit Tag Requester if the peer device does not
> support the 10-Bit Tag Completer. This will make P2P traffic safe.
> 
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  7 ++++
>  drivers/pci/pci.c                               | 56 +++++++++++++++++++++++++
>  drivers/pci/pci.h                               |  1 +
>  drivers/pci/pcie/portdrv_pci.c                  | 13 +++---
>  drivers/pci/probe.c                             |  9 ++--
>  5 files changed, 78 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index bdb2200..c2c4585 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4019,6 +4019,13 @@
>  				bridges without forcing it upstream. Note:
>  				this removes isolation between devices and
>  				may put more devices in an IOMMU group.
> +		disable_10bit_tag=<pci_dev>[; ...]
> +				  Specify one or more PCI devices (in the format
> +				  specified above) separated by semicolons.
> +				  Disable 10-Bit Tag Requester if the peer
> +				  device does not support the 10-Bit Tag
> +				  Completer.This will make P2P traffic safe.

I can't imagine more awkward user experience than such kernel parameter.

As a user, I will need to boot the system, hope for the best that system
works, write down all PCI device numbers, guess which one doesn't work
properly, update grub with new command line argument and reboot the
system. Any HW change and this dance should be repeated.

Thanks
