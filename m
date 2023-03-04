Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE4E6AA752
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 02:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCDBfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 20:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjCDBfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 20:35:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A1F64A91
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 17:35:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EC3361997
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 01:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89D6C433EF;
        Sat,  4 Mar 2023 01:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677893721;
        bh=1bi4llHOwlPPb86qFs2pmB2pX17hbLNqmRX20t+Ttuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jg84SrzVXVEC0srdtbf8JuWDM5L1QmGBgeYnWwsdW5pv05tbvF+hFy/u46Rg7/iQ6
         55jHyYePpvCN06cAEGVgjj5wRupS74YgRo/1ZCW+4/aquxjGIiq93EMZGIG6HTV+fF
         znljY9NfrLfsNuVHhIjDazeQePdce4SJfk7mZj2rx5v7VMQscC56k7mUpgYuQTcpZ9
         SGUfWpczSE/EQXhBZ3bJ6hZVnKVSxZgZ61Pn2DXrE/Lx75GxWUwVmmQIBegvNlWI4l
         pX5wuZSzKkIf22rksFSlcsRSAy6bOQC8uB402cTM+ag4volLpTeL1UQth1nYatjMcp
         Vi8OyhOJT4RRw==
Date:   Fri, 3 Mar 2023 17:35:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com
Subject: Re: [PATCH v2] netdevice: use ifmap instead of plain fields
Message-ID: <20230303173519.72c2d236@kernel.org>
In-Reply-To: <20230303180926.142107-1-vincenzopalazzodev@gmail.com>
References: <20230303180926.142107-1-vincenzopalazzodev@gmail.com>
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

On Fri,  3 Mar 2023 19:09:26 +0100 Vincenzo Palazzo wrote:
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index e1eb1de88bf9..059ff8bcdbbc 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -7476,8 +7476,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	netif_napi_add(netdev, &adapter->napi, e1000e_poll);
>  	strscpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
>  
> -	netdev->mem_start = mmio_start;
> -	netdev->mem_end = mmio_start + mmio_len;
> +	netdev->dev_mapping.mem_start = mmio_start;
> +	netdev->dev_mapping.mem_end = mmio_start + mmio_len;
>  
>  	adapter->bd_number = cards_found++;

That's not the only driver that'd need to be changed.
Try building the kernel with allmodconfig.

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6a14b7b11766..c5987e90a078 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2031,13 +2031,7 @@ struct net_device {
>  	char			name[IFNAMSIZ];
>  	struct netdev_name_node	*name_node;
>  	struct dev_ifalias	__rcu *ifalias;
> -	/*
> -	 *	I/O specific fields
> -	 *	FIXME: Merge these and struct ifmap into one
> -	 */
> -	unsigned long		mem_end;
> -	unsigned long		mem_start;
> -	unsigned long		base_addr;
> +	struct ifmap dev_mapping;

base_addr was unsigned long now its unsigned short.
IDK if that matters.

I'd rather we didn't mess with this code - it's only used by ancient
drivers. We can wait until those drivers are no longer used and delete
this instead.
