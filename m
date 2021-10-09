Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC674276B0
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 04:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244184AbhJIChL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 22:37:11 -0400
Received: from smtprelay0169.hostedemail.com ([216.40.44.169]:57260 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232289AbhJIChK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 22:37:10 -0400
Received: from omf01.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id EB69930C9E;
        Sat,  9 Oct 2021 02:35:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf01.hostedemail.com (Postfix) with ESMTPA id 42B2717274;
        Sat,  9 Oct 2021 02:35:13 +0000 (UTC)
Message-ID: <ad38b125c5a95d283ce8787c245a4c19f3aa3492.camel@perches.com>
Subject: Re: [PATCH net-next 3/5] ethernet: tulip: remove direct
 netdev->dev_addr writes
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Date:   Fri, 08 Oct 2021 19:35:11 -0700
In-Reply-To: <20211008175913.3754184-4-kuba@kernel.org>
References: <20211008175913.3754184-1-kuba@kernel.org>
         <20211008175913.3754184-4-kuba@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.10
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 42B2717274
X-Stat-Signature: z73mwngeniomo9ua7tn35sn4knasozpm
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19YcPgUMOEaQLBbbhZDzK7eTb+QBOWbZFM=
X-HE-Tag: 1633746913-642093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-10-08 at 10:59 -0700, Jakub Kicinski wrote:
> Consify the casts of netdev->dev_addr.
> 
> Convert pointless to eth_hw_addr_set() where possible.
> 
> Use local buffers in a number of places.
[]
> diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
[]
> @@ -666,8 +666,8 @@ static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
>  	struct de_private *de = netdev_priv(dev);
>  	u16 hash_table[32];
>  	struct netdev_hw_addr *ha;
> +	const u16 *eaddrs;
>  	int i;
> -	u16 *eaddrs;

Seems pointless to move the eaddrs location

> @@ -1821,8 +1823,7 @@ static void de21041_get_srom_info(struct de_private *de)
>  #endif
> 
>  	/* store MAC address */
> -	for (i = 0; i < 6; i ++)
> -		de->dev->dev_addr[i] = ee_data[i + sa_offset];
> +	eth_hw_addr_set(de->dev, &ee_data[i + sa_offset]);

what is the content of i here?

Perhaps you want

	eth_hw_addr_set(de->dev, &ee_data[sa_offset]);


> diff --git a/drivers/net/ethernet/dec/tulip/dmfe.c b/drivers/net/ethernet/dec/tulip/dmfe.c
[]
> @@ -476,8 +476,7 @@ static int dmfe_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	}
>  
> 
>  	/* Set Node address */
> -	for (i = 0; i < 6; i++)
> -		dev->dev_addr[i] = db->srom[20 + i];
> +	eth_hw_addr_set(dev, &db->srom[20 + i]);

here too


