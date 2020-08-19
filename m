Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BAE24A346
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgHSPi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:38:27 -0400
Received: from mga05.intel.com ([192.55.52.43]:11019 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgHSPiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 11:38:19 -0400
IronPort-SDR: fBECkWiCtFO2kGA1tNk8/1oEMNR46Ky0IfhP3rsdnegAe3fVaBOoDsJOIe/ZKv8TQnJiAS2n7Z
 3p+S5A/kF4Lw==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="239964669"
X-IronPort-AV: E=Sophos;i="5.76,331,1592895600"; 
   d="scan'208";a="239964669"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 08:38:19 -0700
IronPort-SDR: wOttGFTaatylm7EMtjEUcGsnuxjnbc6O+xrPCaM+Lvp8lsKhzfmf34i7DBOuJhRzxBCx2QLbTc
 4swzCGz6qYqw==
X-IronPort-AV: E=Sophos;i="5.76,331,1592895600"; 
   d="scan'208";a="497788009"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.220.26])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 08:38:18 -0700
Date:   Wed, 19 Aug 2020 08:38:17 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     <sundeep.lkml@gmail.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <sgoutham@marvell.com>, Zyta Szpak <zyta@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [PATCH v6 net-next 1/3] octeontx2-af: Support to enable/disable
 HW timestamping
Message-ID: <20200819083817.00000a02@intel.com>
In-Reply-To: <1597770557-26617-2-git-send-email-sundeep.lkml@gmail.com>
References: <1597770557-26617-1-git-send-email-sundeep.lkml@gmail.com>
        <1597770557-26617-2-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sundeep.lkml@gmail.com wrote:

> From: Zyta Szpak <zyta@marvell.com>
> 
> Four new mbox messages ids and handler are added in order to
> enable or disable timestamping procedure on tx and rx side.
> Additionally when PTP is enabled, the packet parser must skip
> over 8 bytes and start analyzing packet data there. To make NPC
> profiles work seemlesly PTR_ADVANCE of IKPU is set so that
> parsing can be done as before when all data pointers
> are shifted by 8 bytes automatically.
> 
> Signed-off-by: Zyta Szpak <zyta@marvell.com>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>


I know these patches are already acked by a couple of people in v4, but
I have a few more minor concerns that I'd like you to consider listed
below. Up to DaveM whether he wants to apply without the fixes I
mention.


> ---
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 29 ++++++++++++
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  4 ++
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  4 ++
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
>  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 54 ++++++++++++++++++++++
>  .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 52 +++++++++++++++++++++
>  .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 27 +++++++++++
>  7 files changed, 171 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> index a4e65da..8f17e26 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> @@ -468,6 +468,35 @@ static void cgx_lmac_pause_frm_config(struct cgx *cgx, int lmac_id, bool enable)
>  	}
>  }
>  

Generally what I'd like to see is that you have a comment here in
kernel doc format, I suppose your driver probably doesn't have any of
these, but it is particularly important to describe what each function
is meant to do especially when it is a symbol callable from other
files/modules. Something like:

/**
 * cgx_lmac_ptp_config - enable or disable timestamping
 * @cgxd: driver context
 * @lmac_id: ID used to get register offset
 * @enable: true if timestamping should be enabled, false if not
 *
 * Here would be a multi-line description of what this function does
 * and if it has a return value, what it's for.
 */

> +void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
> +{
> +	struct cgx *cgx = cgxd;
> +	u64 cfg;
> +
> +	if (!cgx)
> +		return;
> +
<snip>

> +int rvu_mbox_handler_nix_lf_ptp_tx_enable(struct rvu *rvu, struct msg_req *req,
> +					  struct msg_rsp *rsp)
> +{
> +	struct rvu_hwinfo *hw = rvu->hw;
> +	u16 pcifunc = req->hdr.pcifunc;
> +	struct rvu_block *block;
> +	int blkaddr;
> +	int nixlf;
> +	u64 cfg;
> +
> +	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
> +	if (blkaddr < 0)
> +		return NIX_AF_ERR_AF_LF_INVALID;
> +
> +	block = &hw->block[blkaddr];
> +	nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
> +	if (nixlf < 0)
> +		return NIX_AF_ERR_AF_LF_INVALID;
> +
> +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf));
> +	cfg |= BIT_ULL(32);

I'm not super excited by the magic numbers here, without even a
comment, you should make a define for bit 32, and not leave me guessing
if this is the "enable" bit or is for something else.

> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf), cfg);
> +
> +	return 0;
> +}
> +
> +int rvu_mbox_handler_nix_lf_ptp_tx_disable(struct rvu *rvu, struct msg_req *req,
> +					   struct msg_rsp *rsp)
> +{
> +	struct rvu_hwinfo *hw = rvu->hw;
> +	u16 pcifunc = req->hdr.pcifunc;
> +	struct rvu_block *block;
> +	int blkaddr;
> +	int nixlf;
> +	u64 cfg;
> +
> +	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
> +	if (blkaddr < 0)
> +		return NIX_AF_ERR_AF_LF_INVALID;
> +
> +	block = &hw->block[blkaddr];
> +	nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
> +	if (nixlf < 0)
> +		return NIX_AF_ERR_AF_LF_INVALID;
> +
> +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf));
> +	cfg &= ~BIT_ULL(32);
> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf), cfg);
> +
> +	return 0;
> +}
> +

Is this and the function above exactly the same 20+ lines of code
with a one line difference? Before you passed an "enable" bool to
another function, why the difference here?

>  int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
>  					struct nix_lso_format_cfg *req,
>  					struct nix_lso_format_cfg_rsp *rsp)
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> index 0a21408..8179bbe 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
> @@ -27,6 +27,7 @@
>  #define NIXLF_PROMISC_ENTRY	2
>  
>  #define NPC_PARSE_RESULT_DMAC_OFFSET	8
> +#define NPC_HW_TSTAMP_OFFSET		8
>  
>  static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
>  				      int blkaddr, u16 pcifunc);
> @@ -61,6 +62,32 @@ int rvu_npc_get_pkind(struct rvu *rvu, u16 pf)
>  	return -1;
>  }
>  
> +int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool en)
> +{
> +	int pkind, blkaddr;
> +	u64 val;
> +
> +	pkind = rvu_npc_get_pkind(rvu, pf);
> +	if (pkind < 0) {
> +		dev_err(rvu->dev, "%s: pkind not mapped\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, pcifunc);
> +	if (blkaddr < 0) {
> +		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
> +		return -EINVAL;
> +	}
> +	val = rvu_read64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind));
> +	val &= ~0xff00000ULL; /* Zero ptr advance field */

Please don't use trailing comments *ever* in a code section, the only
place it is marginally ok, is in structure definitions.

Also, What's up with the magic number? At least you had a comment.


