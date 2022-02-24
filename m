Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501804C30F8
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiBXQIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiBXQIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:08:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE243E0FB
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:08:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 983F4B826E6
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 16:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC1FC340E9;
        Thu, 24 Feb 2022 16:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645718773;
        bh=6WN+LQVBZezsAh7KVD4VaWoSKM/ZTRQU90sZ5yKY33s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SQYBEdvFu9oSHN+ebTqdV5/BHZdCpZA/fMR9ZcLuszdMt48Snk1hhPZZbJHaQoxav
         h7ATGC1X9EvXWBbgND4GOeXs7hWBJRFPiHZzuRSGRPS1SGhrgH5z49uM563aRkTf2a
         6Xb2NQXEaxnAl6sBwmGNajxiJLSZ5abyjQXmZk7dQ3ghYCVptcRdRV3zKzIZPFZXYD
         cyKYxgTEWuD7gMjsd8/A34tuARQToUZd0u6v2u3dVfvSR4liFNigMmOz64KFPBJY9K
         1wOFejqne3p3dR2MQIXTDxQ8uApTdkl4o5/xBlWuNKQB7a85kqFlKxOev6m+KOfPZV
         WXgvR0ptD9/Ww==
Date:   Thu, 24 Feb 2022 08:06:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Joachim Wiberg <troglobit@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1 net-next] net: bridge: add support for host l2 mdb
 entries
Message-ID: <20220224080611.4e32bac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <66dc205f-9f57-61c1-35d9-8712e8d9fe3a@blackwall.org>
References: <20220223172407.175865-1-troglobit@gmail.com>
        <66dc205f-9f57-61c1-35d9-8712e8d9fe3a@blackwall.org>
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

On Thu, 24 Feb 2022 13:26:22 +0200 Nikolay Aleksandrov wrote:
> On 23/02/2022 19:24, Joachim Wiberg wrote:
> > This patch expands on the earlier work on layer-2 mdb entries by adding
> > support for host entries.  Due to the fact that host joined entries do
> > not have any flag field, we infer the permanent flag when reporting the
> > entries to userspace, which otherwise would be listed as 'temp'.
> > 
> > Before patch:
> > 
> >     ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee permanent
> >     Error: bridge: Flags are not allowed for host groups.
> >     ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee
> >     Error: bridge: Only permanent L2 entries allowed.
> > 
> > After patch:
> > 
> >     ~# bridge mdb add dev br0 port br0 grp 01:00:00:c0:ff:ee permanent
> >     ~# bridge mdb show
> >     dev br0 port br0 grp 01:00:00:c0:ff:ee permanent vid 1
> > 
> > Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
>
> It would be nice to add a selftest for L2 entries. You can send it as a follow-up.

Let's wait for that, also checkpatch says you need to balance brackets
to hold kernel coding style.

> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
