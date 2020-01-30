Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D4C14DFA9
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 18:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgA3RK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 12:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgA3RK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 12:10:56 -0500
Received: from cakuba (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4AB020707;
        Thu, 30 Jan 2020 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580404256;
        bh=Hxrsh7O/rjzAeL1uBZU4NMmuZq1J4Zw8jlVqpSJ/bR4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S3+Rs+Ad125yxd6jqyK1V6fCELrvcCmCaIoeJpZld0ZcfixK0JJDrONTnLfoa7w27
         oiiKZKJjwAhxUh3gMtGWF2xjVe3ofm0/vd8aTqCiRH8jE8zA79fG4bkhDFQf9UP1gW
         kyjzhAV/8gHxw4DJwQBnUgr2ogEgCLzhmPkbrEI8=
Date:   Thu, 30 Jan 2020 09:10:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Jones <rjones@gateworks.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net] net: thunderx: workaround BGX TX Underflow issue
Message-ID: <20200130091055.159d63ed@cakuba>
In-Reply-To: <20200129223609.9327-1-rjones@gateworks.com>
References: <20200129223609.9327-1-rjones@gateworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020 14:36:09 -0800, Robert Jones wrote:
> From: Tim Harvey <tharvey@gateworks.com>
> 
> While it is not yet understood why a TX underflow can easily occur
> for SGMII interfaces resulting in a TX wedge. It has been found that
> disabling/re-enabling the LMAC resolves the issue.
> 
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> Reviewed-by: Robert Jones <rjones@gateworks.com>

Sunil or Robert (i.e. one of the maintainers) will have to review this
patch (as indicated by Dave by marking it with "Needs Review / ACK" in
patchwork).

At a quick look there are some things which jump out at me:

> +static int bgx_register_intr(struct pci_dev *pdev)
> +{
> +	struct bgx *bgx = pci_get_drvdata(pdev);
> +	struct device *dev = &pdev->dev;
> +	int num_vec, ret;
> +
> +	/* Enable MSI-X */
> +	num_vec = pci_msix_vec_count(pdev);
> +	ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
> +	if (ret < 0) {
> +		dev_err(dev, "Req for #%d msix vectors failed\n", num_vec);
> +		return 1;

Please propagate real error codes, or make this function void as the
caller never actually checks the return value.

> +	}
> +	sprintf(bgx->irq_name, "BGX%d", bgx->bgx_id);
> +	ret = request_irq(pci_irq_vector(pdev, GMPX_GMI_TX_INT),

There is a alloc_irq and request_irq call added in this patch but there
is never any freeing. Are you sure this is fine? Devices can be
reprobed (unbound and bound to drivers via sysfs).

> +		bgx_intr_handler, 0, bgx->irq_name, bgx);

Please align the continuation line with the opening bracket (checkpatch
--strict should help catch this).

> +	if (ret)
> +		return 1;
> +
> +	return 0;
> +}
