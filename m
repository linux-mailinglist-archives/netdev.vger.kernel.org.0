Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B903E3A5CA8
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 07:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhFNGAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 02:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhFNGAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 02:00:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E261DC061574;
        Sun, 13 Jun 2021 22:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rUu+qFDot8hQHtf4FhxEOy4uPBeisgSjqsgw/gq3pTw=; b=MmXSpV1qTF9D+jdt3BP3Wcc3mr
        X4hZ1T+tVjQSHtjXlHQntyV5xGYNkpNsey8Q7KNb3u2+felb5qWeYXTznyrHDRrR1uTAGQlLRAEi4
        HMFbMaAGNYO/84p3z/Mc9z2UCqEuNcTi7uhX4L+s9M0qJGjtDuA1dgb6gmbvyX/UMUYGx036MKC/L
        ekWawu+m1tOVMFmF7ngg6+IHoYTRcdYYSgKjygWus0dMKBRWapLXncYL5LL61OGR6p3+gcuyKBqLX
        AD2dtIDqp4Lbk2cKJHdHQyT3OWV4gBbEAg0wKds4eW4absMkVjPxwBdIQK1KwL8QNI6DolQvWTXP+
        +mqdWCAQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsfbN-0054Jy-03; Mon, 14 Jun 2021 05:57:39 +0000
Date:   Mon, 14 Jun 2021 06:57:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, kw@linux.com,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RESEND PATCH V3 6/6] PCI: Enable 10-Bit tag support for PCIe RP
 devices
Message-ID: <YMbv0FVV9J53M0L7@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-7-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623576555-40338-7-git-send-email-liudongdong3@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 05:29:15PM +0800, Dongdong Liu wrote:
> PCIe spec 5.0r1.0 section 2.2.6.2 implementation note, In configurations
> where a Requester with 10-Bit Tag Requester capability needs to target
> multiple Completers, one needs to ensure that the Requester sends 10-Bit
> Tag Requests only to Completers that have 10-Bit Tag Completer capability.
> So we enable 10-Bit Tag Requester for root port only when the devices
> under the root port support 10-Bit Tag Completer.
> 
> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> ---
>  drivers/pci/pcie/portdrv_pci.c | 75 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index c7ff1ee..baf413f 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -90,6 +90,78 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>  #define PCIE_PORTDRV_PM_OPS	NULL
>  #endif /* !PM */
>  
> +static int pci_10bit_tag_comp_support(struct pci_dev *dev, void *data)
> +{
> +	u8 *support = data;
> +
> +	if (*support == 0)
> +		return 0;
> +
> +	if (!pci_is_pcie(dev)) {
> +		*support = 0;
> +		return 0;
> +	}
> +
> +	/*
> +	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
> +	 * For configurations where a Requester with 10-Bit Tag Requester
> +	 * capability targets Completers where some do and some do not have
> +	 * 10-Bit Tag Completer capability, how the Requester determines which
> +	 * NPRs include 10-Bit Tags is outside the scope of this specification.
> +	 * So we do not consider hotplug scenario.
> +	 */
> +	if (dev->is_hotplug_bridge) {
> +		*support = 0;
> +		return 0;
> +	}
> +
> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP)) {
> +		*support = 0;
> +		return 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static void pci_configure_rp_10bit_tag(struct pci_dev *dev)
> +{
> +	u8 support = 1;
> +	struct pci_dev *pchild;
> +
> +	if (dev->subordinate == NULL)
> +		return;
> +
> +	/* If no devices under the root port, no need to enable 10-Bit Tag. */
> +	pchild = list_first_entry_or_null(&dev->subordinate->devices,
> +					  struct pci_dev, bus_list);
> +	if (pchild == NULL)
> +		return;

pchild is never used after this check, so this could be simplified to
a list_empty(&dev->subordinate->devices).
