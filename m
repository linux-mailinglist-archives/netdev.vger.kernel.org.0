Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778BF8A7BC
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 22:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfHLUCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 16:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfHLUCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 16:02:12 -0400
Received: from localhost (c-73-15-1-175.hsd1.ca.comcast.net [73.15.1.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CED420673;
        Mon, 12 Aug 2019 20:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565640131;
        bh=XdvvIJYUJVlgDyxok5KQg2gpuRjBgQIzCYbzQVDSk1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hU/H0VqTISpoUi0UEbQFGewVtTYazzFkRLBMe64dJ74DquAX2LzVUQXdZSb8tq/fU
         +cpK4SJUz812RLvtIRXUzE1wEmVQLrj6RsuSLf+roVo1U8+ZIIWSpzOSCure3945LC
         c5jzdT5KQeEjhEYIz6aSMYiuy592sCRhf0DpZS+4=
Date:   Mon, 12 Aug 2019 15:02:08 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] PCI/net: Use PCI_STD_NUM_BARS in loops instead of
 PCI_STD_RESOURCE_END
Message-ID: <20190812200208.GD11785@google.com>
References: <20190811150802.2418-1-efremov@linux.com>
 <20190811150802.2418-5-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811150802.2418-5-efremov@linux.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subject can be simply:

  <prefix>: Loop using PCI_STD_NUM_BARS

to keep them a little shorter so "git log --online" doesn't wrap.

On Sun, Aug 11, 2019 at 06:08:00PM +0300, Denis Efremov wrote:
> This patch refactors the loop condition scheme from
> 'i <= PCI_STD_RESOURCE_END' to 'i < PCI_STD_NUM_BARS'.

  Refactor loops to use 'i < PCI_STD_NUM_BARS' instead of 'i <=
  PCI_STD_RESOURCE_END'.

See https://chris.beams.io/posts/git-commit/

> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 4 ++--
>  drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c   | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

This patch touches two unrelated drivers and should be split up.
When you do that, pay attention to the convention for commit log
prefixes, e.g.,

  $ git log --oneline drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
  37e9c087c814 stmmac: pci: Fix typo in IOT2000 comment
  d4a62ea411f9 stmmac: pci: Use pci_dev_id() helper
  e0c1d14a1a32 stmmac: pci: Adjust IOT2000 matching

  $ git log --oneline drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
  ea8c1c642ea5 net: dwc-xlgmac: declaration of dual license in headers
  65e0ace2c5cd net: dwc-xlgmac: Initial driver for DesignWare Enterprise Ethernet

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> index 86f9c07a38cf..cfe496cdd78b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> @@ -258,7 +258,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
>  	}
>  
>  	/* Get the base address of device */
> -	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
>  		if (pci_resource_len(pdev, i) == 0)
>  			continue;
>  		ret = pcim_iomap_regions(pdev, BIT(i), pci_name(pdev));
> @@ -296,7 +296,7 @@ static void stmmac_pci_remove(struct pci_dev *pdev)
>  
>  	stmmac_dvr_remove(&pdev->dev);
>  
> -	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
>  		if (pci_resource_len(pdev, i) == 0)
>  			continue;
>  		pcim_iounmap_regions(pdev, BIT(i));
> diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
> index 386bafe74c3f..fa8604d7b797 100644
> --- a/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
> +++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
> @@ -34,7 +34,7 @@ static int xlgmac_probe(struct pci_dev *pcidev, const struct pci_device_id *id)
>  		return ret;
>  	}
>  
> -	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
> +	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
>  		if (pci_resource_len(pcidev, i) == 0)
>  			continue;
>  		ret = pcim_iomap_regions(pcidev, BIT(i), XLGMAC_DRV_NAME);
> -- 
> 2.21.0
> 
