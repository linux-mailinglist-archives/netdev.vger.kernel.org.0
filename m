Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF1D549B7C
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244997AbiFMS30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241854AbiFMS1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:27:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8C41FE4DF;
        Mon, 13 Jun 2022 07:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1162B8105B;
        Mon, 13 Jun 2022 14:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9FFC3411B;
        Mon, 13 Jun 2022 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655131895;
        bh=TLxFZAPhXdD/lskt5ABL7Yyvc76typsZSU+wq7k76S8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=nC33P0zIEEDZN6u3S/HZm0+GRAnfXvOGbb7rQDH01pkLftaiZTdzsxZu7Xyebbpin
         7iZJl7IWnGkRJAfwOIqc8K+j8IwSTaK3F0MHmyUTMc7CgLJgR4VJD+UGpyJJkhrqLX
         pWeZakRI7cH0l9gg+YPdjnVNTfJ5uxNC/QoxSM1Q4+DGXBNKSm7+Cr0t5ee2RguLg7
         uVqQjAJeEaO0Ka+V0HlIZAym1GivjWVzSNmIneaDGM/5HviE+hY2yp+gPqKFauvgmz
         O4OH3HWNBRR1vFg6SRwbt3uLYW5nw58tlPFvpBRcH5bh9uz1ym1TUrI00o4VTDPc5K
         zXFrxSWwbIgGA==
Date:   Mon, 13 Jun 2022 09:51:33 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, bhelgaas@google.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH 5.10 1/2] commit 1d71eb53e451 ("Revert "PCI: Make
 pci_enable_ptm() private"")
Message-ID: <20220613145133.GA701092@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613111907.25490-1-tangmeng@uniontech.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 07:19:06PM +0800, Meng Tang wrote:
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> 
> Make pci_enable_ptm() accessible from the drivers.
> 
> Exposing this to the driver enables the driver to use the
> 'ptm_enabled' field of 'pci_dev' to check if PTM is enabled or not.
> 
> This reverts commit ac6c26da29c1 ("PCI: Make pci_enable_ptm() private").
> 
> In the 5.10 kernel version, even to the latest confirmed version,
> the following error will still be reported when I225-V network card
> is used.
> 
> kernel: [    1.031581] igc: probe of 0000:01:00.0 failed with error -2
> kernel: [    1.066574] igc: probe of 0000:02:00.0 failed with error -2
> kernel: [    1.096152] igc: probe of 0000:03:00.0 failed with error -2
> kernel: [    1.127251] igc: probe of 0000:04:00.0 failed with error -2
> 
> Even though I confirmed that 7c496de538eebd8212dc2a3c9a468386b2640d4
> and 47bca7de6a4fb8dcb564c7ca4d885c91ed19e03 have been merged into the
> kernel 5.10, the bug is still occurred, and the
> "commit 1b5d73fb8624 ("igc: Enable PCIe PTM")" can fixes it.
> 
> And this patch is the pre-patch of
> 1b5d73fb862414106cf270a1a7300ce8ae77de83.

I guess the point of this is to backport 1d71eb53e451 ("Revert "PCI:
Make pci_enable_ptm() private"") to a v5.10 stable kernel?

If so, I would think you'd want to send this to
stable@vger.kernel.org.

> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> ---
>  drivers/pci/pci.h   | 3 ---
>  include/linux/pci.h | 7 +++++++
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index a96dc6f53076..4084764bf0b1 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -585,11 +585,8 @@ static inline void pcie_ecrc_get_policy(char *str) { }
>  
>  #ifdef CONFIG_PCIE_PTM
>  void pci_ptm_init(struct pci_dev *dev);
> -int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
>  #else
>  static inline void pci_ptm_init(struct pci_dev *dev) { }
> -static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
> -{ return -EINVAL; }
>  #endif
>  
>  struct pci_dev_reset_methods {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index bc5a1150f072..692ce678c5f1 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1599,6 +1599,13 @@ static inline bool pci_aer_available(void) { return false; }
>  
>  bool pci_ats_disabled(void);
>  
> +#ifdef CONFIG_PCIE_PTM
> +int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
> +#else
> +static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
> +{ return -EINVAL; }
> +#endif
> +
>  void pci_cfg_access_lock(struct pci_dev *dev);
>  bool pci_cfg_access_trylock(struct pci_dev *dev);
>  void pci_cfg_access_unlock(struct pci_dev *dev);
> -- 
> 2.20.1
> 
> 
> 
