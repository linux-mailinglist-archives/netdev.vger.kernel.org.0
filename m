Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0602FC2F1
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbhASWE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbhASWDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 17:03:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25BD322E01;
        Tue, 19 Jan 2021 22:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611093749;
        bh=7Rk0PFh/5HZvbzLnLFR/dkR1egA2UTGSFBA8EhntEfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=on3iu4M7VJq7F/A9CT2wA7C5T4LpQa/fTlaV7jGY8B256SXGhUul8jgb/Uy/YQ19t
         DZNqZqAFkNvdOJzE8nvkM5o6NW1JxMNLOisugjVPMUQg099LyYuMMkJU9KMepE/xKU
         CNc1yljhwmOqPLsVlxHI9MoYRzOzfQQhlGWjBmq5HC7jubOCRP8OpOUfIP8wab+Xxg
         6Bo7fw6vxdUN4BbiIxSg6dFMTvKH4kk/CxwoYcQdXqm0mwMaZvocFZ/DKxR4obpxPS
         A9JhDYG8i5VvmNPd3UvLV2HYxff0vsW2OwJ587/D9nIx7zhcFbmYdinPoExZuJb1fb
         TxMW43zqsevuA==
Date:   Tue, 19 Jan 2021 14:02:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] cxgb4: remove bogus CHELSIO_VPD_UNIQUE_ID
 constant
Message-ID: <20210119140228.1f210886@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <25339251-513a-75c6-e96e-c284d23eed0f@gmail.com>
References: <25339251-513a-75c6-e96e-c284d23eed0f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jan 2021 14:45:25 +0100 Heiner Kallweit wrote:
> The comment is quite weird, there is no such thing as a vendor-specific
> VPD id. 0x82 is the value of PCI_VPD_LRDT_ID_STRING. So what we are
> doing here is simply checking whether the byte at VPD address VPD_BASE
> is a valid string LRDT, same as what is done a few lines later in
> the code.
> LRDT = Large Resource Data Tag, see PCI 2.2 spec, VPD chapter
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Did you find this by code inspection?

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> index 2c80371f9..48f20a6a0 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> @@ -2689,7 +2689,6 @@ void t4_get_regs(struct adapter *adap, void *buf, size_t buf_size)
>  #define VPD_BASE           0x400
>  #define VPD_BASE_OLD       0
>  #define VPD_LEN            1024
> -#define CHELSIO_VPD_UNIQUE_ID 0x82
>  
>  /**
>   * t4_eeprom_ptov - translate a physical EEPROM address to virtual
> @@ -2743,9 +2742,9 @@ int t4_seeprom_wp(struct adapter *adapter, bool enable)
>   */
>  int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
>  {
> -	int i, ret = 0, addr;
> +	int i, ret = 0, addr = VPD_BASE;

IMHO it's more readable if the addr is set to BASE or BASE_OLD in one
place rather than having a default value at variable init which may be
overwritten.

>  	int ec, sn, pn, na;
> -	u8 *vpd, csum;
> +	u8 *vpd, csum, base_val = 0;
>  	unsigned int vpdr_len, kw_offset, id_len;
>  
>  	vpd = vmalloc(VPD_LEN);
> @@ -2755,17 +2754,12 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
>  	/* Card information normally starts at VPD_BASE but early cards had
>  	 * it at 0.
>  	 */
> -	ret = pci_read_vpd(adapter->pdev, VPD_BASE, sizeof(u32), vpd);
> +	ret = pci_read_vpd(adapter->pdev, VPD_BASE, 1, &base_val);

Are we sure this works? I've seen silicon out there which has problems
with small PCI accesses (granted those were not VPD accesses).

>  	if (ret < 0)
>  		goto out;
>  
> -	/* The VPD shall have a unique identifier specified by the PCI SIG.
> -	 * For chelsio adapters, the identifier is 0x82. The first byte of a VPD
> -	 * shall be CHELSIO_VPD_UNIQUE_ID (0x82). The VPD programming software
> -	 * is expected to automatically put this entry at the
> -	 * beginning of the VPD.
> -	 */
> -	addr = *vpd == CHELSIO_VPD_UNIQUE_ID ? VPD_BASE : VPD_BASE_OLD;
> +	if (base_val != PCI_VPD_LRDT_ID_STRING)
> +		addr = VPD_BASE_OLD;
>  
>  	ret = pci_read_vpd(adapter->pdev, addr, VPD_LEN, vpd);
>  	if (ret < 0)

