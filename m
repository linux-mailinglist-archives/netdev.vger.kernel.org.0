Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B582F6874F6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjBBFSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjBBFSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:18:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2EC4DBF0
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 21:18:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6118B82497
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF53C433D2;
        Thu,  2 Feb 2023 05:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675315121;
        bh=g19NhV0fJ0JCDHQaFz2T9hGmqO++hlk0VVp27F4Orqo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eCi6476b2BUImvuWZGpHqcETGykCP+z+IXosf4gHU7Fy3HTLil5gVQTl06wbCmvra
         3dK9mmTrdfXBOTyORhI8GZIaNVVoAWDf0NbYMvjpmmfGwq1J7N2m2SBE/Yqqdx2oNG
         +S4W9MSQj6acJSd+vh9dIIteYhXpwINpCSC58t0pJhvvaYrsnx/qHcEWmzwCCyZJU8
         j68WqNa49azRGoWXvcH1OHBiKuOGm6hVSlNdppsO+BiHRKfdyzjzxq/KlQNgaDkZ4v
         mPh1rTcOPSSgdoBJE0gR2YY84PXp1yd2T3izoVYzb7D8kQn/p3J140Ab5IVQe1sTD6
         k6piXy/+yN9mw==
Date:   Wed, 1 Feb 2023 21:18:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Praveen Kaligineedi <pkaligineedi@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Jeroen de Borst <jeroendb@google.com>
Subject: Re: [PATCH net-next 1/1] gve: Fix gve interrupt names
Message-ID: <20230201211840.4648f8af@kernel.org>
In-Reply-To: <20230131213714.588281-1-pkaligineedi@google.com>
References: <20230131213714.588281-1-pkaligineedi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Jan 2023 13:37:14 -0800 Praveen Kaligineedi wrote:
> IRQs are currently requested before the netdevice is registered
> and a proper name is assigned to the device. Changing interrupt
> name to avoid using the format string in the name.

Please provide an example of what the name used to look like and what
it looks like now.

> Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")

If it carries a Fixes tag it should go to net, not net-next, 
and describe what the user-visible issue is going to be.
I'd suggest to drop the Fixes tag. It doesn't look like a fix,
it never worked.

> @@ -371,8 +370,8 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
>  	active_cpus = min_t(int, priv->num_ntfy_blks / 2, num_online_cpus());
>  
>  	/* Setup Management Vector  - the last vector */
> -	snprintf(priv->mgmt_msix_name, sizeof(priv->mgmt_msix_name), "%s-mgmnt",
> -		 name);
> +	snprintf(priv->mgmt_msix_name, sizeof(priv->mgmt_msix_name), "gve%d-mgmnt",
> +		 PCI_SLOT(priv->pdev->devfn));

Why slot? 
Please use the more common "$whatever@pci:%s", pci_name() format.
