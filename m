Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49393E9F3B
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhHLHJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbhHLHJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 03:09:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E3CC061765;
        Thu, 12 Aug 2021 00:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B2gGP1VQRHCk6MX5le6+GSdI6v6K4Z0HHWZKFL10rE0=; b=KWqNs2MzE3TrEoFEQpnBVNyN0g
        3jwYoTV2xVF97Q4jfnPDewLohje/W5KP+UVtzf70pRbNyVa0L9JR/HRVX++AjDpqrnODvsCq3iI6s
        s5hWoJJ7ZlojfvWMh/XXqY102KCc4s+2CULMGqM9r9FaqMI/S9tVa1ufKTY3vmbMdC+GxCI/13mMB
        m5AdxVnPALV6Jdrsa+eStgqDvqaVf+z0JdxyAI+Vm+PhT8v18Xohd1mTScUog28GAzhZYHaRa8eH8
        1bRc8324eOnZjmhS5fyzGdF12l4kFva4VJYN6JiZH4nOA3O5IbcKjh1RosqC6FmXil2UqOXUOVEK3
        /vMn+JfQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE4oC-00EGqD-Lh; Thu, 12 Aug 2021 07:07:34 +0000
Date:   Thu, 12 Aug 2021 08:07:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, kernel@pengutronix.de,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Rafa?? Mi??ecki <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Michael Buesch <m@bues.ch>,
        Oliver O'Halloran <oohall@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH v3 4/8] PCI: replace pci_dev::driver usage that gets the
 driver name
Message-ID: <YRTIqGm5Dr8du7a7@infradead.org>
References: <20210811080637.2596434-1-u.kleine-koenig@pengutronix.de>
 <20210811080637.2596434-5-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811080637.2596434-5-u.kleine-koenig@pengutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 10:06:33AM +0200, Uwe Kleine-K??nig wrote:
>  static inline const char *eeh_driver_name(struct pci_dev *pdev)
>  {
> -	return (pdev && pdev->driver) ? pdev->driver->name : "<null>";
> +	const char *drvstr = pdev ? dev_driver_string(&pdev->dev) : "";
> +
> +	if (*drvstr == '\0')
> +		return "<null>";
> +
> +	return drvstr;

This looks rather obsfucated due to the fact that dev_driver_string
never returns '\0', and due to the strange mix of a tenary operation
and the if on a related condition.


>  }
>  
>  #endif /* CONFIG_EEH */
> diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> index 69c10a7b7c61..dc2ffa686964 100644
> --- a/drivers/bcma/host_pci.c
> +++ b/drivers/bcma/host_pci.c
> @@ -175,9 +175,10 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
>  	if (err)
>  		goto err_kfree_bus;
>  
> -	name = dev_name(&dev->dev);
> -	if (dev->driver && dev->driver->name)
> -		name = dev->driver->name;
> +	name = dev_driver_string(&dev->dev);
> +	if (*name == '\0')
> +		name = dev_name(&dev->dev);

Where does this '\0' check come from?

> +
> +	name = dev_driver_string(&dev->dev);
> +	if (*name == '\0')
> +		name = dev_name(&dev->dev);
> +

More of this weirdness.
