Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721B061ECAC
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKGINV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiKGINT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:13:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EE613F6C;
        Mon,  7 Nov 2022 00:13:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 560A260F21;
        Mon,  7 Nov 2022 08:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE83C433D6;
        Mon,  7 Nov 2022 08:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667808797;
        bh=PgkJbB0Q2L004m5Eq4WQ/HjRyqRrRI5aNjpGlRwfFPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UO0hUPED2IJjsi58QdQxsI+BSoPrMWWRz357N4uhPHkZG0/sO99MGzhE15O4CkFEE
         YpLAB+7/gicgEAU25bAFidFVSS/WmcSyQjU3yhoRCKDgUctvAsm1Vk2SB1mv2SZJkQ
         5m7WYpe1lc1H00N7/bLs/DxkJk1CbltA4gBPzf51ZW4eBq7YtXX0u5FPjFpw4n8gnP
         6ocS9pRckeAC62WoIX3bvx9CYJ9x4xSKQbxDqMkeQgkjdKcIR2CeTlsxPuc+zgItRq
         G3TBwddEgoYBxJaVJKytW67mziwLVY/20H8QKtWGNrvGBR+6IGRrveTMDILRx4o+O2
         Wq37xmvTYb4/Q==
Date:   Mon, 7 Nov 2022 10:13:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lironh@marvell.com, aayarekar@marvell.com, sedara@marvell.com,
        sburla@marvell.com, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 7/9] octeon_ep: add SRIOV VF creation
Message-ID: <Y2i+GWX0l8lwZ/+q@unreal>
References: <20221107072524.9485-1-vburru@marvell.com>
 <20221107072524.9485-8-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107072524.9485-8-vburru@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 11:25:21PM -0800, Veerasenareddy Burru wrote:
> Add support to create SRIOV VFs.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Sathesh Edara <sedara@marvell.com>
> ---
>  .../ethernet/marvell/octeon_ep/octep_main.c   | 50 +++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index ad5553854467..fa0f3d597eb1 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -1236,11 +1236,61 @@ static void octep_remove(struct pci_dev *pdev)
>  	pci_disable_device(pdev);
>  }
>  
> +static int octep_sriov_disable(struct octep_device *oct)
> +{
> +	struct pci_dev *pdev = oct->pdev;
> +
> +	if (pci_vfs_assigned(oct->pdev)) {
> +		dev_warn(&pdev->dev, "Can't disable SRIOV while VFs are assigned\n");
> +		return -EPERM;
> +	}

I think that PCI core should prevent this.

Thanks
