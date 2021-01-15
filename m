Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D212F6F38
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbhAOAAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731160AbhAOAAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 19:00:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C50123A7C;
        Fri, 15 Jan 2021 00:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610668802;
        bh=WuhrfX7YPbGlO+MwNU+aXiP0keQPR1b7gI4SFBd7kiU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DK5QnSCx4UmfGrr2wiz8HeoitlZakONz0jePI9LIL6Tt0N3BBtSHTgG0xkj68bl50
         bGEeOvkmpL++Z3Y10ZSAw6pVPeH2uBgXghMOCtHDBM9F4FHCYrLUOz2LZLPB0jTjbx
         X5gaWCfWNTi/Zj4UfkEPQKugf3I9KAQ769OCE2YjM02/3RGI6J9XrZR5CuttRPHq6P
         7v6UzF3Pq9OIUlnyrMuyU/ATddUSuw/54YLmHxHuxTf+spFG32ceVPsltygh9QmpyZ
         cszFI0eK+Vb5mMCOy+ybuqJrHhbdCz4Ic39lIKGb4xsIM2FCjRYg4Hp4T3sNId/4jo
         mB5eh2EbGijEg==
Message-ID: <824e37786b7004a50b8a348ab4f2bfb26be3605d.camel@kernel.org>
Subject: Re: [PATCH net-next,3/3] octeontx2-af: Handle CPT function level
 reset
From:   Saeed Mahameed <saeed@kernel.org>
To:     Srujana Challa <schalla@marvell.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, schandran@marvell.com,
        pathreya@marvell.com, jerinj@marvell.com
Date:   Thu, 14 Jan 2021 16:00:01 -0800
In-Reply-To: <20210113152007.30293-4-schalla@marvell.com>
References: <20210113152007.30293-1-schalla@marvell.com>
         <20210113152007.30293-4-schalla@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-13 at 20:50 +0530, Srujana Challa wrote:
> When FLR is initiated for a VF (PCI function level reset),
> the parent PF gets a interrupt. PF then sends a message to
> admin function (AF), which then cleans up all resources
> attached to that VF. This patch adds support to handle
> CPT FLR.
> 
> Signed-off-by: Narayana Prasad Raju Atherya <pathreya@marvell.com>
> Signed-off-by: Suheil Chandran <schandran@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/rvu.c   |  3 +
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |  2 +
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 74
> +++++++++++++++++++
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  8 ++
>  4 files changed, 87 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> index e8fd712860a1..0d538b39462d 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
> @@ -2150,6 +2150,9 @@ static void rvu_blklf_teardown(struct rvu *rvu,
> u16 pcifunc, u8 blkaddr)
>  			rvu_nix_lf_teardown(rvu, pcifunc, block->addr,
> lf);
>  		else if (block->addr == BLKADDR_NPA)
>  			rvu_npa_lf_teardown(rvu, pcifunc, lf);
> +		else if ((block->addr == BLKADDR_CPT0) ||
> +			 (block->addr == BLKADDR_CPT1))
> +			rvu_cpt_lf_teardown(rvu, pcifunc, lf, slot);
>  
>  		err = rvu_lf_reset(rvu, block, lf);
>  		if (err) {
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> index b1a6ecfd563e..6f64a13e752a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> @@ -601,6 +601,8 @@ void npc_enable_mcam_entry(struct rvu *rvu,
> struct npc_mcam *mcam,
>  void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
>  			 int blkaddr, u16 src, struct mcam_entry
> *entry,
>  			 u8 *intf, u8 *ena);
> +/* CPT APIs */
> +int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int
> slot);
>  
>  #ifdef CONFIG_DEBUG_FS
>  void rvu_dbg_init(struct rvu *rvu);
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
> b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
> index b6de4b95a72a..ea435d7da975 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
> @@ -240,3 +240,77 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct
> rvu *rvu,
>  
>  	return 0;
>  }
> +
> +static void cpt_lf_disable_iqueue(struct rvu *rvu, int blkaddr, int
> slot)
> +{
> +	u64 inprog, grp_ptr;
> +	int i = 0;
> +
> +	/* Disable instructions enqueuing */
> +	rvu_write64(rvu, blkaddr, CPT_AF_BAR2_ALIASX(slot, CPT_LF_CTL),
> 0x0);
> +
> +	/* Disable executions in the LF's queue */
> +	inprog = rvu_read64(rvu, blkaddr,
> +			    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG));
> +	inprog &= ~BIT_ULL(16);
> +	rvu_write64(rvu, blkaddr,
> +		    CPT_AF_BAR2_ALIASX(slot, CPT_LF_INPROG), inprog);
> +
> +	/* Wait for CPT queue to become execution-quiescent */
> +	do {
> +		inprog = rvu_read64(rvu, blkaddr,
> +				    CPT_AF_BAR2_ALIASX(slot,
> CPT_LF_INPROG));
> +		/* Check for partial entries (GRB_PARTIAL) */
> +		if (inprog & BIT_ULL(31))
> +			i = 0;
> +		else
> +			i++;
> +
> +		grp_ptr = rvu_read64(rvu, blkaddr,
> +				     CPT_AF_BAR2_ALIASX(slot,
> +							CPT_LF_Q_GRP_PT
> R));
> +	} while ((i < 10) && (((grp_ptr >> 32) & 0x7FFF) !=
> +				(grp_ptr & 0x7FFF)));
> 

What prevents an infinite loop if the HW locks up and you get stuck on
a partial entry ? 

Also it would be nice if you'd wrap this in a nice macro with an
informative name:
(grp_ptr >> 32) & 0x7FFF) != (grp_ptr & 0x7FFF))

> +	i = 0;
> +	do {
> +		inprog = rvu_read64(rvu, blkaddr,
> +				    CPT_AF_BAR2_ALIASX(slot,
> CPT_LF_INPROG));
> +		/* GWB writes groups of 40. So below formula is used
> for
> +		 * knowing that no more instructions will be scheduled
> +		 * (INFLIGHT == 0) && (GWB < 40) && (GRB == 0 OR 40)
> +		 */

So why not replace the comment with macros that wrap the below
conditions and the code will become self explanatory..

> +		if (((inprog & 0x1FF) == 0) &&
> +		    (((inprog >> 40) & 0xFF) < 40) &&
> +		    ((((inprog >> 32) & 0xFF) == 0) ||
> +		    (((inprog >> 32) & 0xFF) == 40)))
> +			i++;
> +		else
> +			i = 0;
> +	} while (i < 10);
> +}
> +
> 

