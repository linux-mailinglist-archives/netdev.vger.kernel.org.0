Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223E94C1F13
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiBWWsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiBWWsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:48:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5DA4F9E5
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:48:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBA81B821D8
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B85C340E7;
        Wed, 23 Feb 2022 22:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645656500;
        bh=snWor4LU4JWXGbtYLsMyZPGVYPB4xKDMcJlP/Trakgc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jJSyUW5xxoByRKSwALr6hgaLd7dbeg4UI66JtwFJYvB+XP8gcqhHvWkzDO3r2x2Vm
         kWO68rKtUCaXLdZNRB3pPN9/zPSPG54OF5hL/9nW6j/FuMpwPtXjIkpsD6rAbojvyP
         pTJ8eXsqwDiujylxBFgYDvhf4BZdnLGBb6ox81pvNvpqbozMJuGeqPziXtPqDT2e7C
         9zUDTU9cGZjJwWpcT8V9UcO3hzvFHhIgRTAtbT6QMHdN1Ui4PvQRKf6qMWTmNVlx9V
         mS5N8xxvATmMQ+RVOrE2bXNu5nIZjvRfQZVRJ9PhQVQ8RfMcysINRQ5vECfPzFQXMK
         nvjDWRyLOOYQw==
Date:   Wed, 23 Feb 2022 14:48:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Message-ID: <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
        <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
        <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
        <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
        <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
        <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
        <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
        <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 09:54:26 -0800 Florian Fainelli wrote:
> > I have no problems working with you to improve the driver, the problem
> > I have is this is currently a regression in 5.17 so I would like to
> > see something land, whether it's reverting the other patch, landing
> > thing one or another straight forward fix and then maybe revisit as
> > whole in 5.18.  
> 
> Understood and I won't require you or me to complete this investigating 
> before fixing the regression, this is just so we understand where it 
> stemmed from and possibly fix the IRQ layer if need be. Given what I 
> just wrote, do you think you can sprinkle debug prints throughout the 
> kernel to figure out whether enable_irq_wake() somehow messes up the 
> interrupt descriptor of interrupt and test that theory? We can do that 
> offline if you want.

Let me mark v2 as Deferred for now, then. I'm not really sure if that's
what's intended but we have 3 weeks or so until 5.17 is cut so we can
afford a few days of investigating.

I'm likely missing the point but sounds like the IRQ subsystem treats
IRQ numbers as unsigned so if we pass a negative value "fun" is sort 
of expected. Isn't the problem that device somehow comes with wakeup
capable being set already? Isn't it better to make sure device is not
wake capable if there's no WoL irq instead of adding second check?

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index cfe09117fe6c..7dea44803beb 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4020,12 +4020,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
-	if (priv->wol_irq > 0) {
+	if (priv->wol_irq > 0)
 		err = devm_request_irq(&pdev->dev, priv->wol_irq,
 				       bcmgenet_wol_isr, 0, dev->name, priv);
-		if (!err)
-			device_set_wakeup_capable(&pdev->dev, 1);
-	}
+	else
+		err = -ENOENT;
+	device_set_wakeup_capable(&pdev->dev, !err);
 
 	/* Set the needed headroom to account for any possible
 	 * features enabling/disabling at runtime

