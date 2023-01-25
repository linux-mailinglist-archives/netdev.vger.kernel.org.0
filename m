Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EAC67A874
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 02:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjAYBjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 20:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYBjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 20:39:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1734A1DB
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 17:39:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFBD4B80932
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 01:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A23C433D2;
        Wed, 25 Jan 2023 01:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674610786;
        bh=1mTtfBlknVkrA3E0LQu0M9SuNHatCVzQeUrs4Suqa4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EpBsXks/Hf4mK5CNM2RK0ZZXnTW8xqd/H6PXIMVna7bz0F5CEZc3nuZ0LB7QR87r5
         pMy+Gr8gumrpW1Zdt8zLyjrdesahH7aGUUQg4PhMt1Y0Go/Ydenr1l5bx6sjWAsBqy
         Z7mhxIx+DY9GUu3aJkYPESUuco/uzYqtqjToQ4N98705KQ1uEmut3s4qNQIGDnXVdA
         zUhO9s1jil9EQAyFppJepapBtrHjZsy18lsLXg3ldyNIbg7kpa2Pi9iwknjNvv4obD
         6NhZSFwx865upj8S25sGPmjSOdHARfvkhoNl2z4+gcmocC79N443oBnLGobaCJlvMT
         MrYXa3dKX4iFQ==
Date:   Tue, 24 Jan 2023 17:39:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] net: ethtool: fix NULL pointer dereference in
 pause_prepare_data()
Message-ID: <20230124173945.064f64e3@kernel.org>
In-Reply-To: <20230124111328.3630437-1-vladimir.oltean@nxp.com>
References: <20230124111328.3630437-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan 2023 13:13:28 +0200 Vladimir Oltean wrote:
> In the following call path:
> 
> ethnl_default_dumpit
> -> ethnl_default_dump_one
>    -> ctx->ops->prepare_data
>       -> pause_prepare_data  
> 
> struct genl_info *info will be passed as NULL, and pause_prepare_data()
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

Reported-by: syzbot+9d44aae2720fc40b8474@syzkaller.appspotmail.com
