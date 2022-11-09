Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E54623646
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiKIWE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiKIWEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:04:25 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA312ED60
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 14:04:24 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2A9M3bOl713399;
        Wed, 9 Nov 2022 23:03:37 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2A9M3bOl713399
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1668031417;
        bh=aedIwYUnZRx+EQAU+TLVmfiE2mayNaz2JtEtTeeaU1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YDTOJBZ9loB+dZC+ybSH2ls9Wm1NJMNE4RssL6ss3ziGEedCFpj6DeseCHMGXEcpa
         oD1zA8XVBGD+pTcY5J2PjEc4eH4VE0chKXCxGA1gbdySNOSNKKwt810x2qk4XB6orz
         KjCqp3ue7dOmgAIwOJofEgIsJcQBTtmuMIGdBe8Y=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2A9M3avv713396;
        Wed, 9 Nov 2022 23:03:36 +0100
Date:   Wed, 9 Nov 2022 23:03:36 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Wei Yongjun <weiyongjun@huaweicloud.com>,
        Wells Lu <wellslutw@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] eth: sp7021: drop free_netdev() from
 spl2sw_init_netdev()
Message-ID: <Y2wjuPAww2tZLbIx@electric-eye.fr.zoreil.com>
References: <20221109150116.2988194-1-weiyongjun@huaweicloud.com>
 <CANn89iJZWTVfNDDkpwPOqjj5_fVXzGRrkeEv1EedRipL-oBYbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJZWTVfNDDkpwPOqjj5_fVXzGRrkeEv1EedRipL-oBYbQ@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> :
[...]
> > diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> > index 9be585237277..c499a14314f1 100644
> > --- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
> > +++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> > @@ -287,7 +287,6 @@ static u32 spl2sw_init_netdev(struct platform_device *pdev, u8 *mac_addr,
> >         if (ret) {
> >                 dev_err(&pdev->dev, "Failed to register net device \"%s\"!\n",
> >                         ndev->name);
> 
> If the following leads to a double free, how the previous use of
> ndev->name would actually work ?

The second free_netdev happens when device managed resources are released.
ndev->name above is used before the first free_netdev.

-- 
Ueimor
