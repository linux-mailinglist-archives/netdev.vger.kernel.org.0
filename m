Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514DA3D1FE3
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 10:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhGVHyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230048AbhGVHyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:54:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23E486120C;
        Thu, 22 Jul 2021 08:34:26 +0000 (UTC)
Date:   Thu, 22 Jul 2021 14:04:18 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Richard Laing <richard.laing@alliedtelesis.co.nz>
Subject: Re: linux-next: manual merge of the mhi tree with the net-next tree
Message-ID: <20210722083418.GA4446@workstation>
References: <20210716133738.0d163701@canb.auug.org.au>
 <20210722143306.305aed6f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722143306.305aed6f@canb.auug.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 02:33:06PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Fri, 16 Jul 2021 13:37:38 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the mhi tree got a conflict in:
> > 
> >   drivers/bus/mhi/pci_generic.c
> > 
> > between commit:
> > 
> >   5c2c85315948 ("bus: mhi: pci-generic: configurable network interface MRU")
> > 
> > from the net-next tree and commit:
> > 
> >   156ffb7fb7eb ("bus: mhi: pci_generic: Apply no-op for wake using sideband wake boolean")
> > 
> > from the mhi tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> > 
> > 
> > diff --cc drivers/bus/mhi/pci_generic.c
> > index 19413daa0917,8bc6149249e3..000000000000
> > --- a/drivers/bus/mhi/pci_generic.c
> > +++ b/drivers/bus/mhi/pci_generic.c
> > @@@ -32,7 -32,8 +32,9 @@@
> >    * @edl: emergency download mode firmware path (if any)
> >    * @bar_num: PCI base address register to use for MHI MMIO register space
> >    * @dma_data_width: DMA transfer word size (32 or 64 bits)
> >  + * @mru_default: default MRU size for MBIM network packets
> > +  * @sideband_wake: Devices using dedicated sideband GPIO for wakeup instead
> > +  *		   of inband wake support (such as sdx24)
> >    */
> >   struct mhi_pci_dev_info {
> >   	const struct mhi_controller_config *config;
> > @@@ -41,7 -42,7 +43,8 @@@
> >   	const char *edl;
> >   	unsigned int bar_num;
> >   	unsigned int dma_data_width;
> >  +	unsigned int mru_default;
> > + 	bool sideband_wake;
> >   };
> >   
> >   #define MHI_CHANNEL_CONFIG_UL(ch_num, ch_name, el_count, ev_ring) \
> > @@@ -254,7 -256,7 +258,8 @@@ static const struct mhi_pci_dev_info mh
> >   	.config = &modem_qcom_v1_mhiv_config,
> >   	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
> >   	.dma_data_width = 32,
> >  +	.mru_default = 32768
> > + 	.sideband_wake = false,
> >   };
> >   
> >   static const struct mhi_pci_dev_info mhi_qcom_sdx24_info = {
> > @@@ -643,11 -686,13 +689,14 @@@ static int mhi_pci_probe(struct pci_de
> >   	mhi_cntrl->status_cb = mhi_pci_status_cb;
> >   	mhi_cntrl->runtime_get = mhi_pci_runtime_get;
> >   	mhi_cntrl->runtime_put = mhi_pci_runtime_put;
> > - 	mhi_cntrl->wake_get = mhi_pci_wake_get_nop;
> > - 	mhi_cntrl->wake_put = mhi_pci_wake_put_nop;
> > - 	mhi_cntrl->wake_toggle = mhi_pci_wake_toggle_nop;
> >  +	mhi_cntrl->mru = info->mru_default;
> >   
> > + 	if (info->sideband_wake) {
> > + 		mhi_cntrl->wake_get = mhi_pci_wake_get_nop;
> > + 		mhi_cntrl->wake_put = mhi_pci_wake_put_nop;
> > + 		mhi_cntrl->wake_toggle = mhi_pci_wake_toggle_nop;
> > + 	}
> > + 
> >   	err = mhi_pci_claim(mhi_cntrl, info->bar_num, DMA_BIT_MASK(info->dma_data_width));
> >   	if (err)
> >   		return err;
> 
> This is now a conflict between the char-misc.current tree (where commit
> 156ffb7fb7eb is now 56f6f4c4eb2a) and the net-next tree.

Yes, this is expected as I said before.

Dave, please consider dropping/reverting the patch. The MHI patch should
go through char-misc tree.

Thanks,
Mani
> 
> -- 
> Cheers,
> Stephen Rothwell


