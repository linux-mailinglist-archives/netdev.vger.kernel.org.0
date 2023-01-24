Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627ED679821
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbjAXMcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbjAXMct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:32:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1D8526C
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:32:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9068B81158
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 12:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE506C433EF;
        Tue, 24 Jan 2023 12:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674563565;
        bh=a82WVnb/c+tfAAJe1gDxSxG2MhO5SJPrhHupPdmxy+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JNSHvm/bzDZCMuSRc4Z3QhslHlctc+4QY3g51dNEKxi/2dVxM1mjdD8E2firCGBsz
         cvLOzFcK/cMNLC8ZddXPbwLoQ+g3RUKgf6HGoPEQzIBKcRy6ab0BQnII2jWWEW/yZU
         MhMI/VIV65YN4/L8MV90cnIZspzbcES+YQW5KRQiXpAXKXBnUM5JlOJ+mPg05Rt+Pb
         o1ajagQepdiZlY+3SMlS+n60gBCPkiNpMI/OHvuEMmVt72EFmPcXzOnzx8ydb8DzWN
         2dsAMwCclxC4NH09rcYnFO1x22y6U+cp6HFvDuLI0kGo06Z3e9iWjbYDnLbaqJeojh
         UJkmwmuuEv1zg==
Date:   Tue, 24 Jan 2023 14:28:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] net: ethtool: fix NULL pointer dereference in
 stats_prepare_data()
Message-ID: <Y8/O4tf53ZemTABX@unreal>
References: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124110801.3628545-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 01:08:01PM +0200, Vladimir Oltean wrote:
> In the following call path:
> 
> ethnl_default_dumpit
> -> ethnl_default_dump_one
>    -> ctx->ops->prepare_data
>       -> stats_prepare_data
> 
> struct genl_info *info will be passed as NULL, and stats_prepare_data()
> dereferences it while getting the extended ack pointer.
> 
> To avoid that, just set the extack to NULL if "info" is NULL, since the
> netlink extack handling messages know how to deal with that.
> 
> The pattern "info ? info->extack : NULL" is present in quite a few other
> "prepare_data" implementations, so it's clear that it's a more general
> problem to be dealt with at a higher level, but the code should have at
> least adhered to the current conventions to avoid the NULL dereference.
> 
> Fixes: 04692c9020b7 ("net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/ethtool/stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
