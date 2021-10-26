Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE52B43A99F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbhJZBPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233612AbhJZBPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 21:15:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 076CD60E74;
        Tue, 26 Oct 2021 01:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635210765;
        bh=R1Cb80uSt4Bhak4u71eS+sP7GToGR8SToOhjkAzRg5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FAEZjsh8TgFiDgg6k41qSmt8mQfIkief5AgZpWdO688RM3wRNXLchDpsC7iqcWAhH
         MVUU6En74G2GU+JNw1uO/7LinvDwEi2rK7kTnrUz+oyV1FpWdmCgBbHFDESDqfv7NB
         as2Dvu0XMTU09anX8tcbaga+Dmut20g2s6+JAwocygFEifm9kcgLXsgv/ekAtxVRPr
         K4nPVEvdhPUQoWwFbJTiiPF4yGysVd4+d0et+Dhg3aOcUeYhY/kijUcr4t8Z1w+nIA
         PFyObw4OxHggsGR6T/+9K6YAGmFE3WQgvLzV4ijH5dAgVDHkXRi7ugdzVHZ9pKjdu8
         lxjLzepfGdGGQ==
Date:   Mon, 25 Oct 2021 18:12:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rakesh Babu <rsaladi2@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: Re: [net-next PATCH 1/3] octeontx2-af: debugfs: Minor changes.
Message-ID: <20211025181244.13acd58b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025191442.10084-2-rsaladi2@marvell.com>
References: <20211025191442.10084-1-rsaladi2@marvell.com>
        <20211025191442.10084-2-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 00:44:40 +0530 Rakesh Babu wrote:
>  	cmd_buf = memdup_user(buffer, count + 1);
> -	if (IS_ERR(cmd_buf))
> +	if (IS_ERR_OR_NULL(cmd_buf))
>  		return -ENOMEM;

memdup_user() returns NULL now?

>  	cmd_buf[count] = '\0';
> @@ -504,7 +504,7 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
>  	if (cmd_buf)
>  		ret = -EINVAL;
>  
> -	if (!strncmp(subtoken, "help", 4) || ret < 0) {
> +	if (ret < 0 || !strncmp(subtoken, "help", 4)) {

The commit message does not mention this change.

>  		dev_info(rvu->dev, "Use echo <%s-lf > qsize\n", blk_string);
>  		goto qsize_write_done;
>  	}

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index 7761dcf17b91..d8b1948aaa0a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -2583,6 +2583,9 @@ static void nix_free_tx_vtag_entries(struct rvu *rvu, u16 pcifunc)
>  		return;
>  
>  	nix_hw = get_nix_hw(rvu->hw, blkaddr);
> +	if (!nix_hw)
> +		return;

This does not fall under "remove unwanted characters, indenting 
the code" either.
