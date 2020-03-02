Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920AA1766DD
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgCBWZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:25:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgCBWZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 17:25:44 -0500
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16E0621775;
        Mon,  2 Mar 2020 22:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583187943;
        bh=uB1NegH9tSOx3g9424qvE4f/Wv64BMGPzCt2unDpAcg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=CmQdWxwDaYWsRjXMYnYV9wCjiD9jEwknMtL2h03PA5n2IAszgS3OdtQriSXABozdH
         8kfMfgcGbFKqlxxJeLP1qfJeu/4dy7IwDUdepoVBlsyojuHav2MlzoNaR1SaBV5uGw
         BalN++/3ouY/pqBbhZuHAl7PN655mY7p6vsyIdUc=
Date:   Mon, 2 Mar 2020 16:25:41 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH 2/5] bnxt_en: use pci_get_dsn
Message-ID: <20200302222541.GA171636@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227223635.1021197-4-jacob.e.keller@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 02:36:32PM -0800, Jacob Keller wrote:
> Replace the open-coded implementation for reading the PCIe DSN with
> pci_get_dsn.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 597e6fd5bfea..55f078fc067e 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -11755,20 +11755,14 @@ static int bnxt_init_mac_addr(struct bnxt *bp)
>  static int bnxt_pcie_dsn_get(struct bnxt *bp, u8 dsn[])
>  {
>  	struct pci_dev *pdev = bp->pdev;
> -	int pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
> -	u32 dw;
> +	int err;
>  
> -	if (!pos) {
> +	err = pci_get_dsn(pdev, dsn);
> +	if (err) {
>  		netdev_info(bp->dev, "Unable do read adapter's DSN");

"Unable *to* read..."

Not your fault, I guess :)

> -		return -EOPNOTSUPP;
> +		return err;
>  	}
>  
> -	/* DSN (two dw) is at an offset of 4 from the cap pos */
> -	pos += 4;
> -	pci_read_config_dword(pdev, pos, &dw);
> -	put_unaligned_le32(dw, &dsn[0]);
> -	pci_read_config_dword(pdev, pos + 4, &dw);
> -	put_unaligned_le32(dw, &dsn[4]);
>  	bp->flags |= BNXT_FLAG_DSN_VALID;
>  	return 0;
>  }
> -- 
> 2.25.0.368.g28a2d05eebfb
> 
