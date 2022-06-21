Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C56553A82
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 21:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353545AbiFUT0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 15:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353814AbiFUT0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 15:26:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A041144
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 12:26:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68B3EB81A70
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 19:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E227DC341C4;
        Tue, 21 Jun 2022 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655839611;
        bh=+cKuuJupI2e3zPH+ImhJf1LTdLOCdaQ0VQG/OfxskyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BovcSjSNSm4hk5pZOXjMnfD+lbTuBpNomfAg5pMEZ4Luj+DOFnCFyK086VfNwBUtp
         cxmfxOsjzVwfStZQmZNsvz3bKXfeu6W9DvBSSmFCY5oyN5KPu+br4OILjZ/lTjLLQz
         +7OHPR141yL54T1kuD7nPaKs4gWHvEL+ZGTdBeETvfUrjD/0qweZpY5Im/QD8pBEhW
         pC/cCoHLKuKciBiyLl7weOjPgV9TxtH60eKazQTRiWdKxAn2XlUpb7aIh7gEdM9JEF
         C4WZiqwTPOpg3AoX8l6jHdz8M2c8AtsZfqUh6zEwlTYnZIushsxukoKnbiPS3qn7wB
         BWfHTFu8AqhUg==
Date:   Tue, 21 Jun 2022 12:26:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lior Nahmanson <liorna@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben Ishay <benishay@nvidia.com>
Subject: Re: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Message-ID: <20220621122641.3cba3d38@kernel.org>
In-Reply-To: <PH0PR12MB5449F670E890436B0C454D2ABFB39@PH0PR12MB5449.namprd12.prod.outlook.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
        <20220613111942.12726-3-liorna@nvidia.com>
        <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
        <20220614091438.3d0665d9@kernel.org>
        <PH0PR12MB5449F670E890436B0C454D2ABFB39@PH0PR12MB5449.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jun 2022 12:39:23 +0000 Lior Nahmanson wrote:
> > Shooting from the hip a little bit, but macsec being a tightly bound L2 upper
> > maybe metadata dst is a workable solution for carrying the sci and offload
> > status between upper and lower? The range of values should be well known
> > and limited.  
> 
> Under the assumption that by skb_metadata you meant metadata_dst,

Can you show me in my email where I said skb_metadata?

> I think there are few reasons why i think is better to use skb extensions:
> 
> 1. Unlike skb extension, the metadata_dst deallaction is handled directly by the allocator.
> Since the sci and offloaded fields are shared between the MACsec driver and the offload driver
> (in our case mlx5 driver), for Rx, the metadata_dst allocation is done in the mlx5 driver,
> while the dealloction should be done in the MACsec driver.
> This is undesired behavior.

You allocate metadata skb once and then attach it to the skbs.

> 2. medadata_dst is attached to the skb using skb_dst_set(), which set the slow_gro bit.
> So there is no gain regarding slow_gro flow.
> 
> 3. metadata_dst allocation require much more memory than needed for MACsec use case
> (mainly because struct dst_entry which seems redundant for this case).
