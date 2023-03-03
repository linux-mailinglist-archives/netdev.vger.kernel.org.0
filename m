Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1956A9C2A
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjCCQtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjCCQtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:49:04 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8A476A1
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 08:48:41 -0800 (PST)
Received: from [192.168.0.2] (ip5f5ae973.dynamic.kabel-deutschland.de [95.90.233.115])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id BEC3861CC457B;
        Fri,  3 Mar 2023 17:48:38 +0100 (CET)
Message-ID: <bd0a8066-9360-7440-9705-68118eb5e0ff@molgen.mpg.de>
Date:   Fri, 3 Mar 2023 17:48:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [Intel-wired-lan] [PATCH v1] netdevice: use ifmap isteand of
 plain fields
Content-Language: en-US
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        davem@davemloft.net, jesse.brandeburg@intel.com
References: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Vincenzo,


Thank you for your patch. There is a small typo in the commit message 
summary in *instead*.

Am 03.03.23 um 16:08 schrieb Vincenzo Palazzo:
> clean the code by using the ifmap instead of plain fields,
> and avoid code duplication.
> 
> P.S: I'm giving credit to the author of the FIXME commit.

No idea, what you mean exactly, but you can do that by adding From: in 
the first line of the commit message body.


Kind regards,

Paul


> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c |  4 ++--
>   include/linux/netdevice.h                  |  8 +-------
>   net/core/dev_ioctl.c                       | 12 ++++++------
>   net/core/rtnetlink.c                       |  6 +++---
>   4 files changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index e1eb1de88bf9..059ff8bcdbbc 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -7476,8 +7476,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	netif_napi_add(netdev, &adapter->napi, e1000e_poll);
>   	strscpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
>   
> -	netdev->mem_start = mmio_start;
> -	netdev->mem_end = mmio_start + mmio_len;
> +	netdev->dev_mapping.mem_start = mmio_start;
> +	netdev->dev_mapping.mem_end = mmio_start + mmio_len;
>   
>   	adapter->bd_number = cards_found++;
>   
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6a14b7b11766..c5987e90a078 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2031,13 +2031,7 @@ struct net_device {
>   	char			name[IFNAMSIZ];
>   	struct netdev_name_node	*name_node;
>   	struct dev_ifalias	__rcu *ifalias;
> -	/*
> -	 *	I/O specific fields
> -	 *	FIXME: Merge these and struct ifmap into one
> -	 */
> -	unsigned long		mem_end;
> -	unsigned long		mem_start;
> -	unsigned long		base_addr;
> +	struct ifmap dev_mapping;
>   
>   	/*
>   	 *	Some hardware also needs these fields (state,dev_list,
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 5cdbfbf9a7dc..89469cb97e35 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -88,9 +88,9 @@ static int dev_getifmap(struct net_device *dev, struct ifreq *ifr)
>   	if (in_compat_syscall()) {
>   		struct compat_ifmap *cifmap = (struct compat_ifmap *)ifmap;
>   
> -		cifmap->mem_start = dev->mem_start;
> -		cifmap->mem_end   = dev->mem_end;
> -		cifmap->base_addr = dev->base_addr;
> +		cifmap->mem_start = dev->dev_mapping.mem_start;
> +		cifmap->mem_end   = dev->dev_mapping.mem_end;
> +		cifmap->base_addr = dev->dev_mapping.base_addr;
>   		cifmap->irq       = dev->irq;
>   		cifmap->dma       = dev->dma;
>   		cifmap->port      = dev->if_port;
> @@ -98,9 +98,9 @@ static int dev_getifmap(struct net_device *dev, struct ifreq *ifr)
>   		return 0;
>   	}
>   
> -	ifmap->mem_start  = dev->mem_start;
> -	ifmap->mem_end    = dev->mem_end;
> -	ifmap->base_addr  = dev->base_addr;
> +	ifmap->mem_start  = dev->dev_mapping.mem_start;
> +	ifmap->mem_end    = dev->dev_mapping.mem_end;
> +	ifmap->base_addr  = dev->dev_mapping.base_addr;
>   	ifmap->irq        = dev->irq;
>   	ifmap->dma        = dev->dma;
>   	ifmap->port       = dev->if_port;
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 5d8eb57867a9..ff8fc1bbda31 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1445,9 +1445,9 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
>   	struct rtnl_link_ifmap map;
>   
>   	memset(&map, 0, sizeof(map));
> -	map.mem_start   = dev->mem_start;
> -	map.mem_end     = dev->mem_end;
> -	map.base_addr   = dev->base_addr;
> +	map.mem_start   = dev->dev_mapping.mem_start;
> +	map.mem_end     = dev->dev_mapping.mem_end;
> +	map.base_addr   = dev->dev_mapping.base_addr;
>   	map.irq         = dev->irq;
>   	map.dma         = dev->dma;
>   	map.port        = dev->if_port;
