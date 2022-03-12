Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83A94D6D2E
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiCLHFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCLHFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:05:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0EC27E8B7;
        Fri, 11 Mar 2022 23:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7CDC60C05;
        Sat, 12 Mar 2022 07:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4BCC340EB;
        Sat, 12 Mar 2022 07:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647068680;
        bh=QsMSTvT3trLHBPifeW4bppOk5xaZrWGBQUCtUaxLjZ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=scHx8tWrPFD3R9n/GjVuObRg3JrCMY/IkvHNMkfBJWD9Th13Q5nsQ4B13yERyvy/L
         QmS235IdpsJ9pfTg5yKAeCxk3dfq15fHwjmXfuM9YZogNhDALTpF3KAyAamne05S/v
         ddMLf+EQqeUkv+WsVLQLVjx5+k3W2qQEAjy5S471f8Lf9ldKnE4LkEe6bOfUcuBmCO
         FzdD4ibAjznjrIpfasjpGGUdR1cDuaTooqdbsAmyiAg1vHZ00gq46j2uJFBoDuQfUR
         mqijmVkLYfmM66xyBjG/zmoUmJb1J6+uZzpFRz6yIAoZCPuFwdEIYKcD4Ph8Bw4yK7
         xu2Kx0gA8N2iw==
Date:   Fri, 11 Mar 2022 23:04:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: eni: Add check for dma_map_single
Message-ID: <20220311230438.2caa4673@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220311071656.2062663-1-jiasheng@iscas.ac.cn>
References: <20220311071656.2062663-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 15:16:56 +0800 Jiasheng Jiang wrote:
> As the potential failure of the dma_map_single(),
> it should be better to check it and return error
> if fails.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  drivers/atm/eni.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
> index 422753d52244..96c2d8f5646b 100644
> --- a/drivers/atm/eni.c
> +++ b/drivers/atm/eni.c
> @@ -1112,6 +1112,8 @@ DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
>  	skb_data3 = skb->data[3];
>  	paddr = dma_map_single(&eni_dev->pci_dev->dev,skb->data,skb->len,
>  			       DMA_TO_DEVICE);
> +	if (dma_mapping_error(&eni_dev->pci_dev->dev, paddr))
> +		return enq_jam;

Probably better to drop the packet if mapping fails.

>  	ENI_PRV_PADDR(skb) = paddr;
>  	/* prepare DMA queue entries */
>  	j = 0;

