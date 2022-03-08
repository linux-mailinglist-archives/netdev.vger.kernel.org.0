Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FB74D1036
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344416AbiCHGZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344436AbiCHGZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:25:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B033CA5F;
        Mon,  7 Mar 2022 22:24:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49F00B81737;
        Tue,  8 Mar 2022 06:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AD7C340EB;
        Tue,  8 Mar 2022 06:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646720652;
        bh=Ofliel9YomlgWZWMQ9ro1PAV0p7ilJ4RJ5K2eDsgY0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hYg95hDkwyxfD5HhUf7SIUj87w3SPzhl6HL9atrhOQSS6M6aVv5RsSUeuY/i7YA0v
         KvD3dQnA2XpMCzhAJDCCLBLNlbJN9iBA/TY6+cVSk6UF2A7Gu0Bj8w76CYr8xgVhzl
         N09a2q3z23gqM0sjjS6cir1IcqCw79PUSBHkJwqYOpiyDYvePYrwXFFMVcPPbDKRaC
         Uo9GuS9ZahMYJAVQO9ht48NZPt7hAJfA6/fH1nzvSBxJ6jIfvapliJQBdsaW1bfboj
         tfO1T1RNYXcmOHHmXqJZCaK7p1GdjHcKwpumdf0xCETT+9ZE8PZKVDkXiYGDO4UA30
         7tcg8+c4mvHgA==
Date:   Mon, 7 Mar 2022 22:24:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ethernet: sun: Fix an error handling path in
 happy_meal_pci_probe()
Message-ID: <20220307222411.34bde8e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <242ebc5e7dedc6b0d7f47cbf7768326c127f955b.1646584729.git.christophe.jaillet@wanadoo.fr>
References: <242ebc5e7dedc6b0d7f47cbf7768326c127f955b.1646584729.git.christophe.jaillet@wanadoo.fr>
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

On Sun,  6 Mar 2022 17:39:10 +0100 Christophe JAILLET wrote:
> A dma_free_coherent() call is missing in the error handling path of the
> probe, as already done in the remove function.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> dma_alloc_coherent() uses '&pdev->dev' and the remove function
> 'hp->dma_dev'.
> This change is a copy&paste from the remove function, so I've left the
> latter. It is not important because on line 3017 we have
> "hp->dma_dev = &pdev->dev;" so both expression are the same.
> 
> 
> I've not been able to find a Fixes tag because of the renaming of
> function and files.
> However, it looks old (before 2008)

Looks like we got an identical fix from someone else a day earlier:

https://lore.kernel.org/all/1646492104-23040-1-git-send-email-zheyuma97@gmail.com/

> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index ad9029ae6848..348ed5412544 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -3146,7 +3146,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>  	if (err) {
>  		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
>  		       "aborting.\n");
> -		goto err_out_iounmap;
> +		goto err_out_free_dma;
>  	}
>  
>  	pci_set_drvdata(pdev, hp);
> @@ -3179,6 +3179,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>  
>  	return 0;
>  
> +err_out_free_dma:
> +	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
> +			  hp->happy_block, hp->hblock_dvma);
> +
>  err_out_iounmap:
>  	iounmap(hp->gregs);
>  

