Return-Path: <netdev+bounces-475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 827CF6F78FC
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 00:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A2BC280F0D
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E239471;
	Thu,  4 May 2023 22:21:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1F97C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 22:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B66C433D2;
	Thu,  4 May 2023 22:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683238879;
	bh=7Kc7algCg+cDCqRGalh3mPTfejXb43b0Kt7DmPlsmNs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=PZOW2bNn4l29ABtndoECuRWDwRVU15U6MlOGyRGHkLJFNRUBA0DjqzWqIrCjXcvXe
	 sP1vLOQyBwkGH6JLWecMhq2/73LoIv5xyN/WGJTfjbwV+IkGCtZ9Kjt/2HfIoabsX3
	 RktSxjG3VNcQKlkOdqMCDy0KkUESuh32ZVhFdw9WQBfgA+mBEF/83jlKYKv3yHVUed
	 Djg0sAc1HN1Dbn3cQEAZy3QsuktR+dBohlPAgC45944tdJQ1Ufat4XzKJeJ8A0b/b0
	 7OPGPIvasflG4X1V0McP+wlK+Ufy3jOOjbQ8jDp9onLzMszNbi5SJBDSftFsqglaiw
	 els535Ug6WLsQ==
Date: Thu, 4 May 2023 17:21:16 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Oliver O'Halloran <oohall@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
	David Abdurachmanov <david.abdurachmanov@gmail.com>,
	linux-rdma@vger.kernel.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Alex Williamson <alex.williamson@redhat.com>,
	Lukas Wunner <lukas@wunner.de>, linux-pci@vger.kernel.org,
	Stefan Roese <sr@denx.de>, Jim Wilson <wilson@tuliptree.org>,
	netdev@vger.kernel.org
Subject: Re: [PATCH v8 2/7] PCI: Export PCI link retrain timeout
Message-ID: <20230504222116.GA886747@bhelgaas>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2304060110230.13659@angie.orcam.me.uk>

On Thu, Apr 06, 2023 at 01:21:09AM +0100, Maciej W. Rozycki wrote:
> Rename LINK_RETRAIN_TIMEOUT to PCIE_LINK_RETRAIN_TIMEOUT and make it
> available via "pci.h" for PCI drivers to use.

> +#define PCIE_LINK_RETRAIN_TIMEOUT HZ

This is basically just a rename and move, but since we're touching it
anyway, can we make it "PCIE_LINK_RETRAIN_TIMEOUT_MS 1000" here and
use msecs_to_jiffies() below?

I know jiffies and HZ are probably idiomatic elsewhere in the kernel,
and this particular timeout is arbitrary and not based on anything in
the spec, but many of the delays in PCI *are* straight from a spec, so
I'd like to make the units more explicit.

>  extern const unsigned char pcie_link_speed[];
>  extern bool pci_early_dump;
>  
> Index: linux-macro/drivers/pci/pcie/aspm.c
> ===================================================================
> --- linux-macro.orig/drivers/pci/pcie/aspm.c
> +++ linux-macro/drivers/pci/pcie/aspm.c
> @@ -90,8 +90,6 @@ static const char *policy_str[] = {
>  	[POLICY_POWER_SUPERSAVE] = "powersupersave"
>  };
>  
> -#define LINK_RETRAIN_TIMEOUT HZ
> -
>  /*
>   * The L1 PM substate capability is only implemented in function 0 in a
>   * multi function device.
> @@ -213,7 +211,7 @@ static bool pcie_retrain_link(struct pci
>  	}
>  
>  	/* Wait for link training end. Break out after waiting for timeout */
> -	end_jiffies = jiffies + LINK_RETRAIN_TIMEOUT;
> +	end_jiffies = jiffies + PCIE_LINK_RETRAIN_TIMEOUT;
>  	do {
>  		pcie_capability_read_word(parent, PCI_EXP_LNKSTA, &reg16);
>  		if (!(reg16 & PCI_EXP_LNKSTA_LT))

