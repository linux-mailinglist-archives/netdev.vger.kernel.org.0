Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04DD176D9C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 04:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCCDkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 22:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgCCDkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 22:40:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7303220848;
        Tue,  3 Mar 2020 03:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583206846;
        bh=Emh45AKiBNS724hebeoI21buaPmJhcQjoomhSfqsWM4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n1wjmuMYnzYAvfTbZEVI9jLVep9eomZoISgXS3rNs1Bs1ZxVQUk8wEaV4mQImWBuL
         1cIU5ZR8BNyIcGa75ofPdS5yOo2on8DNQnwQteoYYPkd0ntmk+Aywcu4q+JKqyWw8z
         NKZLkgbFkfKUVzcepD0WNDN7O7kuOKGiHZ4Wcc7o=
Date:   Mon, 2 Mar 2020 19:40:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 6/6] nfp: Use pci_get_dsn()
Message-ID: <20200302194044.27eb9e5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200303022506.1792776-7-jacob.e.keller@intel.com>
References: <CABhMZUXJ_Omt-+fwa4Oz-Ly=J+NM8+8Ryv-Ad1u_bgEpDRH7RQ@mail.gmail.com>
        <20200303022506.1792776-1-jacob.e.keller@intel.com>
        <20200303022506.1792776-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Mar 2020 18:25:05 -0800 Jacob Keller wrote:
> Use the newly added pci_get_dsn() function for obtaining the 64-bit
> Device Serial Number in the nfp6000_read_serial and
> nfp_6000_get_interface functions.
> 
> pci_get_dsn() reports the Device Serial number as a u64 value created by
> combining two pci_read_config_dword functions. The lower 16 bits
> represent the device interface value, and the next 48 bits represent the
> serial value. Use put_unaligned_be32 and put_unaligned_be16 to convert
> the serial value portion into a Big Endian formatted serial u8 array.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!

> -	pci_read_config_dword(pdev, pos + 4, &reg);
> -	put_unaligned_be16(reg >> 16, serial + 4);
> -	pci_read_config_dword(pdev, pos + 8, &reg);
> -	put_unaligned_be32(reg, serial);
> +	put_unaligned_be32((u32)(dsn >> 32), serial);
> +	put_unaligned_be16((u16)(dsn >> 16), serial + 4);

nit: the casts and extra brackets should be unnecessary, in case
     you're respinning..
