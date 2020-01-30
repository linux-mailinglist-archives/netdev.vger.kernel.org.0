Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 240CC14E2FA
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 20:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgA3TQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 14:16:36 -0500
Received: from mga04.intel.com ([192.55.52.120]:9436 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgA3TQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 14:16:36 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 11:16:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,382,1574150400"; 
   d="scan'208";a="262281101"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2020 11:16:33 -0800
Date:   Thu, 30 Jan 2020 13:07:30 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Robert Jones <rjones@gateworks.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net] net: thunderx: workaround BGX TX Underflow issue
Message-ID: <20200130120730.GA60572@ranger.igk.intel.com>
References: <20200129223609.9327-1-rjones@gateworks.com>
 <20200130091055.159d63ed@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130091055.159d63ed@cakuba>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 09:10:55AM -0800, Jakub Kicinski wrote:
> On Wed, 29 Jan 2020 14:36:09 -0800, Robert Jones wrote:
> > From: Tim Harvey <tharvey@gateworks.com>
> > 
> > While it is not yet understood why a TX underflow can easily occur
> > for SGMII interfaces resulting in a TX wedge. It has been found that
> > disabling/re-enabling the LMAC resolves the issue.
> > 
> > Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> > Reviewed-by: Robert Jones <rjones@gateworks.com>
> 
> Sunil or Robert (i.e. one of the maintainers) will have to review this
> patch (as indicated by Dave by marking it with "Needs Review / ACK" in
> patchwork).
> 
> At a quick look there are some things which jump out at me:
> 
> > +static int bgx_register_intr(struct pci_dev *pdev)
> > +{
> > +	struct bgx *bgx = pci_get_drvdata(pdev);
> > +	struct device *dev = &pdev->dev;
> > +	int num_vec, ret;
> > +
> > +	/* Enable MSI-X */
> > +	num_vec = pci_msix_vec_count(pdev);
> > +	ret = pci_alloc_irq_vectors(pdev, num_vec, num_vec, PCI_IRQ_MSIX);
> > +	if (ret < 0) {
> > +		dev_err(dev, "Req for #%d msix vectors failed\n", num_vec);
> > +		return 1;
> 
> Please propagate real error codes, or make this function void as the
> caller never actually checks the return value.
> 
> > +	}
> > +	sprintf(bgx->irq_name, "BGX%d", bgx->bgx_id);

Another quick look: use snprintf so that you won't overflow the
bgx->irq_name in case bgx->bgx_id has some weird big number.

> > +	ret = request_irq(pci_irq_vector(pdev, GMPX_GMI_TX_INT),
> 
> There is a alloc_irq and request_irq call added in this patch but there
> is never any freeing. Are you sure this is fine? Devices can be
> reprobed (unbound and bound to drivers via sysfs).
> 
> > +		bgx_intr_handler, 0, bgx->irq_name, bgx);
> 
> Please align the continuation line with the opening bracket (checkpatch
> --strict should help catch this).
> 
> > +	if (ret)
> > +		return 1;
> > +
> > +	return 0;
> > +}
