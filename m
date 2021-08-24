Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9673F6832
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242293AbhHXRlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242406AbhHXRjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A87A761414;
        Tue, 24 Aug 2021 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629825104;
        bh=bZuZ6k3Ah+MCPU4WLv2f9DnnGjoK5ojKRDaLTCr+WRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DkTm79YXtH4q2XoJLymKqRkdN+HLTCF1iBLdSK3da4l2U6Ik+06hXnalWr8c31TcV
         iV1fY1biWc/GopK9NhuMqkWygi1GtUrs/HtWfKBY6b06RAfJ/+JSE2fJA5Z5SpapY8
         O7yDsEyl7JrRlW0XruetiCDne6japqJIGMEF5QuMMkXPoUHf99bICYDiuM+Sj1yEbH
         vdIqdbygn/KqHLGdhri0F8xWLXAlTAktokmEqzMTCw7QL3FPQswqL/sLPRrs9hHNKS
         G0JdYAq3nD5G4EnFkRf6hyO6t4lTRVCz1DC/MBjOihf236TW/5XDIuC2QR94GnV+mX
         ISq+x58eLedDQ==
Date:   Tue, 24 Aug 2021 12:11:42 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 11/12] cxgb4: Search VPD with
 pci_vpd_find_ro_info_keyword()
Message-ID: <20210824171142.GA3478603@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db576a3e-e877-b37b-98ed-cfc03d225ab3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 03:59:21PM +0200, Heiner Kallweit wrote:
> Use pci_vpd_find_ro_info_keyword() to search for keywords in VPD to
> simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 67 +++++++++-------------
>  1 file changed, 27 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> index 2aeb2f80f..5e8ac42ac 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> @@ -2743,10 +2743,9 @@ int t4_seeprom_wp(struct adapter *adapter, bool enable)
>   */
>  int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
>  {
> -	int i, ret = 0, addr;
> -	int sn, pn, na;
> +	unsigned int id_len, pn_len, sn_len, na_len;
> +	int sn, pn, na, addr, ret = 0;
>  	u8 *vpd, base_val = 0;
> -	unsigned int vpdr_len, kw_offset, id_len;
>  
>  	vpd = vmalloc(VPD_LEN);
>  	if (!vpd)
> @@ -2772,60 +2771,48 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
>  	}
>  
>  	id_len = pci_vpd_lrdt_size(vpd);
> -	if (id_len > ID_LEN)
> -		id_len = ID_LEN;
>  
> -	i = pci_vpd_find_tag(vpd, VPD_LEN, PCI_VPD_LRDT_RO_DATA);
> -	if (i < 0) {
> -		dev_err(adapter->pdev_dev, "missing VPD-R section\n");
> +	ret = pci_vpd_check_csum(vpd, VPD_LEN);
> +	if (ret) {
> +		dev_err(adapter->pdev_dev, "VPD checksum incorrect or missing\n");
>  		ret = -EINVAL;
>  		goto out;
>  	}
>  
> -	vpdr_len = pci_vpd_lrdt_size(&vpd[i]);
> -	kw_offset = i + PCI_VPD_LRDT_TAG_SIZE;
> -	if (vpdr_len + kw_offset > VPD_LEN) {
> -		dev_err(adapter->pdev_dev, "bad VPD-R length %u\n", vpdr_len);
> -		ret = -EINVAL;
> +	ret = pci_vpd_find_ro_info_keyword(vpd, VPD_LEN,
> +					   PCI_VPD_RO_KEYWORD_SERIALNO, &sn_len);
> +	if (ret < 0)
>  		goto out;
> -	}
> +	sn = ret;
>  
> -#define FIND_VPD_KW(var, name) do { \
> -	var = pci_vpd_find_info_keyword(vpd, kw_offset, vpdr_len, name); \
> -	if (var < 0) { \
> -		dev_err(adapter->pdev_dev, "missing VPD keyword " name "\n"); \

Just for the record, I guess this patch gives up these error messages
that mention the specific keyword that's missing?  Not really an issue
for *me*, since the people generating the VPD content should be able to
easily validate this and figure out any errors.  Just pointing it out
in case the cxgb4 folks are attached to the messages.

> -		ret = -EINVAL; \
> -		goto out; \
> -	} \
> -	var += PCI_VPD_INFO_FLD_HDR_SIZE; \
> -} while (0)
> -
> -	ret = pci_vpd_check_csum(vpd, VPD_LEN);
> -	if (ret) {
> -		dev_err(adapter->pdev_dev, "VPD checksum incorrect or missing\n");
> -		ret = -EINVAL;
> +	ret = pci_vpd_find_ro_info_keyword(vpd, VPD_LEN,
> +					   PCI_VPD_RO_KEYWORD_PARTNO, &pn_len);
> +	if (ret < 0)
>  		goto out;
> -	}
> +	pn = ret;
>  
> -	FIND_VPD_KW(sn, "SN");
> -	FIND_VPD_KW(pn, "PN");
> -	FIND_VPD_KW(na, "NA");
> -#undef FIND_VPD_KW
> +	ret = pci_vpd_find_ro_info_keyword(vpd, VPD_LEN, "NA", &na_len);
> +	if (ret < 0)
> +		goto out;
> +	na = ret;
>  
> -	memcpy(p->id, vpd + PCI_VPD_LRDT_TAG_SIZE, id_len);
> +	memcpy(p->id, vpd + PCI_VPD_LRDT_TAG_SIZE, min_t(int, id_len, ID_LEN));
>  	strim(p->id);
> -	i = pci_vpd_info_field_size(vpd + sn - PCI_VPD_INFO_FLD_HDR_SIZE);
> -	memcpy(p->sn, vpd + sn, min(i, SERNUM_LEN));
> +	memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
>  	strim(p->sn);
> -	i = pci_vpd_info_field_size(vpd + pn - PCI_VPD_INFO_FLD_HDR_SIZE);
> -	memcpy(p->pn, vpd + pn, min(i, PN_LEN));
> +	memcpy(p->pn, vpd + pn, min_t(int, pn_len, PN_LEN));
>  	strim(p->pn);
> -	memcpy(p->na, vpd + na, min(i, MACADDR_LEN));
> +	memcpy(p->na, vpd + na, min_t(int, na_len, MACADDR_LEN));
>  	strim((char *)p->na);
>  
>  out:
>  	vfree(vpd);
> -	return ret < 0 ? ret : 0;
> +	if (ret < 0) {
> +		dev_err(adapter->pdev_dev, "error reading VPD\n");
> +		return ret;
> +	}
> +
> +	return 0;
>  }
>  
>  /**
> -- 
> 2.33.0
> 
> 
