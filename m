Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615F63A5C87
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 07:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhFNFpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 01:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhFNFpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 01:45:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636D3C061574;
        Sun, 13 Jun 2021 22:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EJYWcnd06FzFmKwV1OWmbtOeXzo1YpL7VDEQ85a3gE4=; b=N9LE679DuuhFc8IDccHapMt6d2
        bTsYkUXFTxy6AC1rDfhgWz0EKgWNI7d9LOJWBAuvZpxEyE0PFVI4P/xp101d0KTX93H8v92+h4o50
        SzumODKLjceOAP6pB0p7nuxW5c3O9PiV1tuGc1fzeSHER93Aub3EwAEH3Yaw76+/OcyisdaMLLJAK
        IsyVeFOJWgFaBbOS1dLVN7c5UAMShjJlo/1h3fVNcA0DlclvUUfm2SZTpOdI7HeuphLLRJkUi9smO
        u3XfjpWe3Bu4M6ynRCdDcrVV5Je5qSeelb8ShRaBmKsF6mEzyHgf8DZ8VzhEPmkAyUBTTACJPqTFD
        Un9jFhiQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsfMn-0053o0-WF; Mon, 14 Jun 2021 05:42:36 +0000
Date:   Mon, 14 Jun 2021 06:42:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, kw@linux.com,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RESEND PATCH V3 1/6] PCI: Use cached Device Capabilities
 Register
Message-ID: <YMbsSfQR65TLkbiX@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-2-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623576555-40338-2-git-send-email-liudongdong3@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 05:29:10PM +0800, Dongdong Liu wrote:
> It will make sense to store the pcie_devcap value in the pci_dev
> structure instead of reading Device Capabilities Register multiple
> times. The fisrt place to use pcie_devcap is in set_pcie_port_type(),
> get the pcie_devcap value here, then use cached pcie_devcap in the
> needed place.
> 
> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> ---
>  drivers/media/pci/cobalt/cobalt-driver.c |  4 ++--
>  drivers/pci/pci.c                        |  5 +----
>  drivers/pci/pcie/aspm.c                  | 11 ++++-------
>  drivers/pci/probe.c                      | 11 +++--------
>  drivers/pci/quirks.c                     |  3 +--
>  include/linux/pci.h                      |  1 +
>  6 files changed, 12 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
> index 839503e..04e735f 100644
> --- a/drivers/media/pci/cobalt/cobalt-driver.c
> +++ b/drivers/media/pci/cobalt/cobalt-driver.c
> @@ -193,11 +193,11 @@ void cobalt_pcie_status_show(struct cobalt *cobalt)
>  		return;
>  
>  	/* Device */
> -	pcie_capability_read_dword(pci_dev, PCI_EXP_DEVCAP, &capa);
>  	pcie_capability_read_word(pci_dev, PCI_EXP_DEVCTL, &ctrl);
>  	pcie_capability_read_word(pci_dev, PCI_EXP_DEVSTA, &stat);
>  	cobalt_info("PCIe device capability 0x%08x: Max payload %d\n",
> -		    capa, get_payload_size(capa & PCI_EXP_DEVCAP_PAYLOAD));
> +		    capa,
> +		    get_payload_size(pci_dev->pcie_devcap & PCI_EXP_DEVCAP_PAYLOAD));

Overly long line.

> +		if (!(child->pcie_devcap & PCI_EXP_DEVCAP_RBER) && !aspm_force) {

Another one.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
