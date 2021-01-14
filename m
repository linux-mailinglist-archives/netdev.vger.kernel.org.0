Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3C22F6F23
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbhANXv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730755AbhANXvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:51:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBFDF23A3B;
        Thu, 14 Jan 2021 23:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610668245;
        bh=GfSqyoIaXH0Hx1dMjl6CwIqE70+el3w6HoDvUR40C0U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NG6BQ8K0as8Spr3wL3KVxke7FicQLVXIq4AzxZg0bt6+C75wBr1ZA5NAZpreZZTV+
         g4KdGKUtMasW8XlXb/A0cgUq0rlaA/eLDEHOuxpyLMgnKDJN8NjgzZeA5vtNF88qFV
         Y60TVnda8rrASqrek8g279Z2BMg0i2mGa+OOQdEI4XihwzhAQ2Z6SZK3EraqQjvMBZ
         Cm8B0Cc3vFiK+9ynOk1wGuq1BJVXpptfjv4qi9cZcFue820eiZ4vOC9DpzOOzL+U3t
         yfC5213ikW3DQ5Gi9Xk7SIlMi76YAryfB9p7ptd5BFp5EHiUCKDFqQpI2NRToKHLY3
         eOHhwAUFJ3jqg==
Message-ID: <3edb033746906618bc451aa8a634bc3e51c162b8.camel@kernel.org>
Subject: Re: [PATCH net-next,2/3] octeontx2-af: Add support for CPT1 in
 debugfs
From:   Saeed Mahameed <saeed@kernel.org>
To:     Srujana Challa <schalla@marvell.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, schandran@marvell.com,
        pathreya@marvell.com, jerinj@marvell.com,
        Mahipal Challa <mchalla@marvell.com>
Date:   Thu, 14 Jan 2021 15:50:43 -0800
In-Reply-To: <20210113152007.30293-3-schalla@marvell.com>
References: <20210113152007.30293-1-schalla@marvell.com>
         <20210113152007.30293-3-schalla@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-13 at 20:50 +0530, Srujana Challa wrote:
> Adds support to display block CPT1 stats at
> "/sys/kernel/debug/octeontx2/cpt1".
> 
> Signed-off-by: Mahipal Challa <mchalla@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  .../marvell/octeontx2/af/rvu_debugfs.c        | 45 +++++++++++----
> ----
>  1 file changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> index d27543c1a166..158876366dd3 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
> @@ -1904,6 +1904,18 @@ static void rvu_dbg_npc_init(struct rvu *rvu)
>  }
>  
>  /* CPT debugfs APIs */
> +static int cpt_get_blkaddr(struct seq_file *filp)
> +{
> +	struct dentry *current_dir;
> +	int blkaddr;
> +
> +	current_dir = filp->file->f_path.dentry->d_parent;
> +	blkaddr = (!strcmp(current_dir->d_name.name, "cpt1") ?
> +			   BLKADDR_CPT1 : BLKADDR_CPT0);
> +

This is very fragile piece of code! it assumes static debugfs directory
structure and naming, why don't you store the CPT context in the
sqe_file private ? as you already have in rvu_dbg_nix_init  for nix_hw
type 


