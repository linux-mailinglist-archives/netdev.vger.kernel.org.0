Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61F94273F4
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 00:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243725AbhJHWzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 18:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231876AbhJHWzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 18:55:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5681E60E9C;
        Fri,  8 Oct 2021 22:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633733621;
        bh=fAFnZrcP9V2PJb2yr/KOB0SnKV7yRbBFGwGzEq+JY4M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=g8mHcvii8fnRQgud/hlKghG7LYdxj8/nC03GrwwnwxrOjwjPanguauimd7XmbsM4c
         NvYyw17YrajQtZ4YOs8xnDOLARc0QBv3wT2emwpuUsY+TDiJ/MSGP+ucngi3d0McEf
         Fy6poYDfDrYpDVyRdpRh25h5OqihZsV9FSUNigxBFBdk4Ws4Fxh0RYDZaiIQM5/KEo
         bt5DIV7H+GjHmiLt3GsFGdGEAx+0E05Ck4WCSQdpBFk6fvNRYmm6KCAMdk/pg9NRs9
         ksw9y9rE8Zb6EZ+WBKRxCL/HSOV/R/IhmxUQkHmCVd/0THappl1M1XRkyvM9E0sR3x
         0f3GG//MPJ2Kw==
Date:   Fri, 8 Oct 2021 17:53:40 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/5] PCI/VPD: Add and use pci_read/write_vpd_any()
Message-ID: <20211008225340.GA1388382@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 08:20:23AM +0200, Heiner Kallweit wrote:
> In certain cases we need a variant of pci_read_vpd()/pci_write_vpd() that
> does not check against dev->vpd.len. Such cases are:
> - reading VPD if dev->vpd.len isn't set yet (in pci_vpd_size())
> - devices that map non-VPD information to arbitrary places in VPD address
>   space (example: Chelsio T3 EEPROM write-protect flag)
> Therefore add function variants that check against PCI_VPD_MAX_SIZE only.
> 
> Make the cxgb3 driver the first user of the new functions.
> 
> Preferably this series should go through the PCI tree.
> 
> Heiner Kallweit (5):
>   PCI/VPD: Add pci_read/write_vpd_any()
>   PCI/VPD: Use pci_read_vpd_any() in pci_vpd_size()
>   cxgb3: Remove t3_seeprom_read and use VPD API
>   cxgb3: Use VPD API in t3_seeprom_wp()
>   cxgb3: Remove seeprom_write and user VPD API

Tentatively applied to pci/vpd for v5.16.

Ideally would like reviewed-by and ack for the cxgb3 parts from Raju,
Jakub, David.

>  drivers/net/ethernet/chelsio/cxgb3/common.h   |  2 -
>  .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 38 +++----
>  drivers/net/ethernet/chelsio/cxgb3/t3_hw.c    | 98 +++----------------
>  drivers/pci/vpd.c                             | 79 ++++++++++-----
>  include/linux/pci.h                           |  2 +
>  5 files changed, 83 insertions(+), 136 deletions(-)
> 
> -- 
> 2.33.0
> 
