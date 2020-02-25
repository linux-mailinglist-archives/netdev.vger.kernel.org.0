Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE2816F0B8
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 21:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbgBYU55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 15:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgBYU55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 15:57:57 -0500
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB8AE22464;
        Tue, 25 Feb 2020 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582664277;
        bh=bUd27AwJqBzkc+a/YzHr6t7aDFALZiBJW37pwoR3XXw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=BxtqlrmxhXqEjmzPLOMEH4gAcfxztB1ZobBuZtd6KtV8zavbIcXdKhoIqzNceIFRd
         gsfa1PMXi0a4n6ESV2XY98VfAkGfLzpPbHT71/C2Vscc04pgwcqC2ZEcr4posnKKcq
         W0dQ7tn9goQRnaQIP8dPPAK5YNcA5EZ3DkXlE/bY=
Date:   Tue, 25 Feb 2020 14:57:55 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 0/8] PCI: add and use constant PCI_STATUS_ERROR_BITS
 and helper pci_status_get_and_clear_errors
Message-ID: <20200225205755.GA199380@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20ca7c1f-7530-2d89-40a6-d97a65aa25ef@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 03:03:05PM +0100, Heiner Kallweit wrote:
> Few drivers have own definitions for this constant, so move it to the
> PCI core. In addition there are several places where the following
> code sequence is used:
> 1. Read PCI_STATUS
> 2. Mask out non-error bits
> 3. Action based on set error bits
> 4. Write back set error bits to clear them
> 
> As this is a repeated pattern, add a helper to the PCI core.
> 
> Most affected drivers are network drivers. But as it's about core
> PCI functionality, I suppose the series should go through the PCI
> tree.

Makes good sense to me, thanks for doing this.

> v2:
> - fix formal issue with cover letter
> v3:
> - fix dumb typo in patch 7
> 
> Heiner Kallweit (8):
>   PCI: add constant PCI_STATUS_ERROR_BITS
>   PCI: add pci_status_get_and_clear_errors
>   r8169: use pci_status_get_and_clear_errors
>   net: cassini: use pci_status_get_and_clear_errors
>   net: sungem: use pci_status_get_and_clear_errors
>   net: skfp: use PCI_STATUS_ERROR_BITS
>   PCI: pci-bridge-emul: use PCI_STATUS_ERROR_BITS
>   sound: bt87x: use pci_status_get_and_clear_errors
> 
>  drivers/net/ethernet/marvell/skge.h       |  6 -----
>  drivers/net/ethernet/marvell/sky2.h       |  6 -----
>  drivers/net/ethernet/realtek/r8169_main.c | 15 +++++-------
>  drivers/net/ethernet/sun/cassini.c        | 28 ++++++++-------------
>  drivers/net/ethernet/sun/sungem.c         | 30 +++++++----------------
>  drivers/net/fddi/skfp/drvfbi.c            |  2 +-
>  drivers/net/fddi/skfp/h/skfbi.h           |  5 ----
>  drivers/pci/pci-bridge-emul.c             | 14 ++---------
>  drivers/pci/pci.c                         | 23 +++++++++++++++++
>  include/linux/pci.h                       |  1 +
>  include/uapi/linux/pci_regs.h             |  7 ++++++
>  sound/pci/bt87x.c                         |  7 +-----
>  12 files changed, 60 insertions(+), 84 deletions(-)
> 
> -- 
> 2.25.1
> 
> 
> 
