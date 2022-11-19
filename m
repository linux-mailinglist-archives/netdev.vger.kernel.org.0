Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD500630AE0
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiKSCxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbiKSCxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:53:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C8D184
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 18:52:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F06F62820
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 02:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400AEC433C1;
        Sat, 19 Nov 2022 02:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668826373;
        bh=M/dGd9OyCi2Qta4D4PIB0PTzu1wPl3hOJPfoaajQV/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nA+8lMdZH0Nh1EQwXybppsLRdEe6qQpbeIVgqCJaBhCqbwTAsdFN7rkxMT5Ve/wc5
         tD6MqvNITP8HG9dBVackJhUESC3dRsB6VIUY7JtSCvWGZHGENigPva/WSmdKpJZsze
         f60h0B93kf/iSvd8cSjqzilHqVdat1UHY7r9HvkGoVN4i1mxOJDpuzFzYWlAnvUcgD
         FSuBad5/9//vOeX3sh466PmSA1t9vO1NWBbauvPW0sem+v5guan1yhA6bEFdoU/tYs
         Ktg6f1WlbGQg3phxl10J+L6tMSlELN+Sdx0R6nPA+f0TZnofCz4GZ1dA0Wi6KLnGxa
         A8inaejdX4Ivg==
Date:   Fri, 18 Nov 2022 18:52:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <skalluru@marvell.com>, <manishc@marvell.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH net] bnx2x: fix pci device refcount leak in
 bnx2x_vf_is_pcie_pending()
Message-ID: <20221118185252.52f96466@kernel.org>
In-Reply-To: <20221117123301.42916-1-yangyingliang@huawei.com>
References: <20221117123301.42916-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Nov 2022 20:33:01 +0800 Yang Yingliang wrote:
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> index 11d15cd03600..cd5108b38542 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> @@ -802,8 +802,11 @@ static u8 bnx2x_vf_is_pcie_pending(struct bnx2x *bp, u8 abs_vfid)
>  		return false;
>  
>  	dev = pci_get_domain_bus_and_slot(vf->domain, vf->bus, vf->devfn);
> -	if (dev)
> -		return bnx2x_is_pcie_pending(dev);
> +	if (dev) {
> +		bool pending = bnx2x_is_pcie_pending(dev);
> +		pci_dev_put(dev);
> +		return pending;
> +	}
>  	return false;

Success path should be unindented:

	dev = pci_get..
	if (!dev)
		return false;
	pending = bnxt2x_is_...
	pci_dev_put(dev);

	return pending;

Please use get_maintainers on the formatted patch file to find all 
the people to CC.
