Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56D6648B84
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLJADk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLJADj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:03:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70626747D6
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 16:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A849623BF
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 00:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A40C433EF;
        Sat, 10 Dec 2022 00:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670630617;
        bh=GzAas7eEJZyXm2Z+bTg1UL9TsogMgSNhrKR8fNESggk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WjRZthdgT2U1JAfRVhWDaBMy6EfWZZGQc2aUFL4UNynQrsEnAm4KVxoTNSDTeP5K0
         1Uc1NVXEyt2XgEWG3bF77bi0Eep7myMK/MjTrarU8fbGISqJI6i+V0jRKvx0z3MsG3
         g3dFiw5c6kLErivjB/tJxqu+/Zj8RAu2oaU/zXBUj829lEqhze3Fcx4OSNJ/yQfejJ
         O3b2ZqB+qtuZfKzDpc7Y5iiSg0JaNsZAE9NPJDY6jyLXC2NOs8w3XlVmQwb7gRsC8V
         qBfbITusT9nu2P298jqC33TgYw+YDQSUOjlodmKj6gNoMc5HJTh8ksPOCJL3XNuVTk
         3Z9b/5t+Bpy4Q==
Date:   Fri, 9 Dec 2022 16:03:35 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>
Subject: Re: [PATCH net 2/3] bonding: do failover when high prio link up
Message-ID: <Y5PM1z1SEdWFgkui@x130>
References: <20221209101305.713073-1-liuhangbin@gmail.com>
 <20221209101305.713073-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221209101305.713073-3-liuhangbin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09 Dec 18:13, Hangbin Liu wrote:
>Currently, when a high prio link enslaved, or when current link down,
>the high prio port could be selected. But when high prio link up, the
>new active slave reselection is not triggered. Fix it by checking link's
>prio when getting up.
>
>Reported-by: Liang Li <liali@redhat.com>
>Fixes: 0a2ff7cc8ad4 ("Bonding: add per-port priority for failover re-selection")
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>---
> drivers/net/bonding/bond_main.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 2b6cc4dbb70e..dc6af790ff1e 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2689,7 +2689,8 @@ static void bond_miimon_commit(struct bonding *bond)
>
> 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
>
>-			if (!rtnl_dereference(bond->curr_active_slave) || slave == primary)
>+			if (!rtnl_dereference(bond->curr_active_slave) || slave == primary ||
>+			    slave->prio > rtnl_dereference(bond->curr_active_slave)->prio)
> 				goto do_failover;

I am not really familiar with this prio logic, seems to be new. 
Anyway, what if one of the next slaves has higher prio than this slave and the
current active ? 
I see that the loop over all the slaves continues even after the failover,
but why would you do all these failovers until you settle on the highest
prio one ? 

shouldn't you do something similar to bond_choose_primary_or_current()
outside the loop, once you've updated all the slaves link states 

Please let me know if I am wandering in the wrong directions
Anyway, LGTM:

Reviewed-by: Saeed Mahameed <saeed@kernel.org>







