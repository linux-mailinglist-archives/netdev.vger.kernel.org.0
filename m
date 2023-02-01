Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC74686A7C
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjBAPh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBAPh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:37:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D45A658A;
        Wed,  1 Feb 2023 07:37:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A86D5B821BC;
        Wed,  1 Feb 2023 15:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC20C4339C;
        Wed,  1 Feb 2023 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675265872;
        bh=0E8HbaF3vpnqBpfKGyxNNXEgUgOZzOGGOEERqBeFrCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=qxFUDIoS1SzTcq9P0wA0T66wxmQVLmBAPSjRdjRDikhFGW6VRhqokwLNLKfIfPydp
         LfcTHOy9cFMnmKTZB7LN5nEQqf0Lgu8yLPRv7RHWkRxxwvI2T92cL4MPSi5ce8C2Cw
         YFcVD9vITDHV4IbQnm+vu86Lf9Td5HYcFXDN8ExYyXw+zBSB3D6RyKfm0SBHGtPEPb
         XM2c/t2QGOLfNEULiA39ErYXexTsaPWDl6BELIKkHhlq0bmyXidD94vq6YFkU5kOjc
         +sTKoHQ3KtfMGsMuQo1iyUGpv48KgHJEDVBReClHobsT5E5+aVdLLCLWnDI0iGvF8y
         JHGukMK3cvK3Q==
Date:   Wed, 1 Feb 2023 09:37:50 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: Add ACS quirk for Wangxun NICs
Message-ID: <20230201153750.GA1864705@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201104703.82511-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 06:47:03PM +0800, Mengyuan Lou wrote:
> The Wangxun 1G/10G NICs may be multi-function devices. They do
> not advertise ACS capability.
> Add an ACS quirk for these devices so the functions can be in
> independent IOMMU groups.

Thanks for the patch!

The commit log and the code comment do not explicitly say that the
hardware implementation blocks transactions between functions.

Can you clarify this by verifying (a) you have direct knowledge that
the hardware *does* block those transactions, and (b) that the
following text is accurate:

  The Wangxun 1G/10G NICs may be multi-function devices. They do not
  advertise an ACS capability, but the hardware implementation always
  blocks peer-to-peer transactions between the functions.

  Add an ACS quirk for these devices so the functions can be in
  independent IOMMU groups.

> + * Wangxun 10G/1G nics have no ACS capability.
> + * But the implementation could block peer-to-peer transactions between them
> + * and provide ACS-like functionality.

Also, if the following comment is accurate, please incorporate it:

  Wangxun 10G/1G NICs have no ACS capability, but on multi-function
  devices, the hardware does block peer-to-peer transactions between
  the functions and provides ACS-like functionality.

"Implementation *could* block peer-to-peer transactions" doesn't say
whether it actually *does*.

If this all makes sense, please repost the patch with updated text.  I
don't want to update it myself because I don't know anything about the
NICs and I don't want to make assumptions.

Bjorn

> + */
> +static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
> +{
> +	switch (dev->device) {
> +	case 0x0100 ... 0x010F:
> +	case 0x1001:
> +	case 0x2001:
> +		return pci_acs_ctrl_enabled(acs_flags,
> +			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
> +	}
> +
> +	return false;
> +}
> +
>  static const struct pci_dev_acs_enabled {
>  	u16 vendor;
>  	u16 device;
> @@ -4980,6 +4998,8 @@ static const struct pci_dev_acs_enabled {
>  	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
>  	/* Zhaoxin Root/Downstream Ports */
>  	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
> +	/* Wangxun nics */
> +	{ PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
>  	{ 0 }
>  };
>  
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index b362d90eb9b0..bc8f484cdcf3 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -3012,6 +3012,8 @@
>  #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
>  #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
>  
> +#define PCI_VENDOR_ID_WANGXUN		0x8088
> +
>  #define PCI_VENDOR_ID_SCALEMP		0x8686
>  #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
>  
> -- 
> 2.39.1
> 
