Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26573F660C
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbhHXRUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239968AbhHXRSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68D6D6140B;
        Tue, 24 Aug 2021 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824560;
        bh=MdJJa0Q/hFLCTbRIO/pYfO7Fg1Ens19ug6IpZWK/RWY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=XiNNMp8S3doi8po/ByyIMlZgiajZY0EzaLCWA93tThbR6taP07Z3hiexnl7DAVov7
         MonYnODaKpKU9CoWy/MTR46xUUvmQ+JWvbVeS5oPMgHpPFQEkPKW1VHXsr9iOceJM/
         6vp7Z/we7KIFY3sCIMhbgdjPIXF03LmlbyMRDbLfsG/0XTIckGwp53Bncpy1cGrMQk
         CJjXycNkd+CMCHpLEQ+ELXi3JogoUsfK5OCHZS6+7Nx/3OlKuz3OG2JHOcmwOO0e7y
         GCTkkmovrGX7zK0zC4RGB3gcTZfgld58WmNXuWk49R/Mux0LsrIG2KPxNRt5AuYoDs
         iUv4EkTOCOK2A==
Date:   Tue, 24 Aug 2021 12:02:39 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 06/12] bnx2x: Search VPD with
 pci_vpd_find_ro_info_keyword()
Message-ID: <20210824170239.GA3477243@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9f730cf-e31e-902b-7b39-0ff2e99636e0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 03:54:23PM +0200, Heiner Kallweit wrote:
> Use pci_vpd_find_ro_info_keyword() to search for keywords in VPD to
> simplify the code.
> 
> str_id_reg and str_id_cap hold the same string and are used in the same
> comparison. This doesn't make sense, use one string str_id instead.

str_id_reg is printed with "%04x" (lower-case hex letters) and
str_id_cap with "%04X" (upper-case hex letters), so the previous code
would match either 0xabcd or 0xABCD.  After this patch, we'd match
only the latter.

PCI_VENDOR_ID_DELL is 0x1028, so it shouldn't make any difference,
which makes me wonder why somebody bothered with both.

But it does seem like a potential landmine to change the case
sensitivity.  Maybe strncasecmp() instead?

> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 57 +++++--------------
>  1 file changed, 15 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index 0466adf8d..2c7bfc416 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -12189,11 +12189,10 @@ static int bnx2x_get_hwinfo(struct bnx2x *bp)
>  
>  static void bnx2x_read_fwinfo(struct bnx2x *bp)
>  {
> -	int i, block_end, rodi;
> -	char str_id_reg[VENDOR_ID_LEN+1];
> -	char str_id_cap[VENDOR_ID_LEN+1];
> -	unsigned int vpd_len;
> -	u8 *vpd_data, len;
> +	char str_id[VENDOR_ID_LEN + 1];
> +	unsigned int vpd_len, kw_len;
> +	u8 *vpd_data;
> +	int rodi;
>  
>  	memset(bp->fw_ver, 0, sizeof(bp->fw_ver));
>  
> @@ -12201,46 +12200,20 @@ static void bnx2x_read_fwinfo(struct bnx2x *bp)
>  	if (IS_ERR(vpd_data))
>  		return;
>  
> -	/* VPD RO tag should be first tag after identifier string, hence
> -	 * we should be able to find it in first BNX2X_VPD_LEN chars
> -	 */
> -	i = pci_vpd_find_tag(vpd_data, vpd_len, PCI_VPD_LRDT_RO_DATA);
> -	if (i < 0)
> -		goto out_not_found;
> -
> -	block_end = i + PCI_VPD_LRDT_TAG_SIZE +
> -		    pci_vpd_lrdt_size(&vpd_data[i]);
> -	i += PCI_VPD_LRDT_TAG_SIZE;
> -
> -	rodi = pci_vpd_find_info_keyword(vpd_data, i, block_end,
> -				   PCI_VPD_RO_KEYWORD_MFR_ID);
> -	if (rodi < 0)
> -		goto out_not_found;
> -
> -	len = pci_vpd_info_field_size(&vpd_data[rodi]);
> -
> -	if (len != VENDOR_ID_LEN)
> +	rodi = pci_vpd_find_ro_info_keyword(vpd_data, vpd_len,
> +					    PCI_VPD_RO_KEYWORD_MFR_ID, &kw_len);
> +	if (rodi < 0 || kw_len != VENDOR_ID_LEN)
>  		goto out_not_found;
>  
> -	rodi += PCI_VPD_INFO_FLD_HDR_SIZE;
> -
>  	/* vendor specific info */
> -	snprintf(str_id_reg, VENDOR_ID_LEN + 1, "%04x", PCI_VENDOR_ID_DELL);
> -	snprintf(str_id_cap, VENDOR_ID_LEN + 1, "%04X", PCI_VENDOR_ID_DELL);
> -	if (!strncmp(str_id_reg, &vpd_data[rodi], VENDOR_ID_LEN) ||
> -	    !strncmp(str_id_cap, &vpd_data[rodi], VENDOR_ID_LEN)) {
> -
> -		rodi = pci_vpd_find_info_keyword(vpd_data, i, block_end,
> -						PCI_VPD_RO_KEYWORD_VENDOR0);
> -		if (rodi >= 0) {
> -			len = pci_vpd_info_field_size(&vpd_data[rodi]);
> -
> -			rodi += PCI_VPD_INFO_FLD_HDR_SIZE;
> -
> -			if (len < 32 && (len + rodi) <= vpd_len) {
> -				memcpy(bp->fw_ver, &vpd_data[rodi], len);
> -				bp->fw_ver[len] = ' ';
> -			}
> +	snprintf(str_id, VENDOR_ID_LEN + 1, "%04X", PCI_VENDOR_ID_DELL);
> +	if (!strncmp(str_id, &vpd_data[rodi], VENDOR_ID_LEN)) {
> +		rodi = pci_vpd_find_ro_info_keyword(vpd_data, vpd_len,
> +						    PCI_VPD_RO_KEYWORD_VENDOR0,
> +						    &kw_len);
> +		if (rodi >= 0 && kw_len < sizeof(bp->fw_ver)) {
> +			memcpy(bp->fw_ver, &vpd_data[rodi], kw_len);
> +			bp->fw_ver[kw_len] = ' ';
>  		}
>  	}
>  out_not_found:
> -- 
> 2.33.0
> 
> 
