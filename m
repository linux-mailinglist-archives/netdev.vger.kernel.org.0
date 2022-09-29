Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951BA5EF6C4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiI2Nkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiI2Nkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:40:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A6013F2B3
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:40:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBC15B823A5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 13:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E078FC433D6;
        Thu, 29 Sep 2022 13:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664458850;
        bh=mcAYMiblBwO44rmV4I/MCBfg/fEMrj87kmRGe0OFlEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GQjwNA4ETIYvEdhK5xEnxtV+5CiCZzN2osOWHbvLhFR9wNDo0nVxaxQQCzGD1mqzp
         0REK4CggnkRdWfUiLXV/ADsdD3JbcN2T05CKO/+xA6U4v8G/CuOW3XghvyyiAJj2z9
         2IeEqykVs0PA2Ph6u5eGdRJeXUzMbllezZfr/k4GRYToTlACZ8/V8/f98bHFo19iCj
         jtYzXaCXlzkEwfrTJZaRuquMq5/ZYPm+thRcpW0yvjbLXSq94nd54cPjoZ6r5+f1Lc
         0FzNszxAGWWpXIFQZXXp74QUyz/kFI7eVOmiCJRQEr4P/nUuQTKknaps4sa0OoJwsr
         3uXdp3WshauHA==
Date:   Thu, 29 Sep 2022 06:40:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Guillaume Nault <gnault@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv3 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <20220929064048.35e72a8f@kernel.org>
In-Reply-To: <YzUMrAgm5eieW1hS@Laptop-X1>
References: <20220927041303.152877-1-liuhangbin@gmail.com>
        <20220927072130.6d5204a3@kernel.org>
        <YzOz9ePdsIMGg0s+@Laptop-X1>
        <20220928094757.GA3081@localhost.localdomain>
        <YzUMrAgm5eieW1hS@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 11:10:36 +0800 Hangbin Liu wrote:
> > Now for device modification, I'm not sure there's a use case for
> > unicast notifications. The caller already knows which values it asked
> > to modify, so ECHO doesn't bring much value compared to a simple ACK.  
> 
> And the __dev_notify_flags() is only used when the dev flag changed.
> 
> It looks no much change if we call it when create new link:
> rtnl_newlink_create() -> rtnl_configure_link() -> __dev_notify_flags()
> 
> But when set link, it is only called when flag changed
> do_setlink() -> dev_change_flags() -> __dev_notify_flags().
> 
> Unless you want to omit the ECHO message when setting link.
> 
> At latest, when call rtnl_delete_link(), there is no way to call
> __dev_notify_flags(). So we still need to use the current way.
> 
> As a summarize, we need to change a lot of code if we use __dev_notify_flags()
> to notify user, while we can only use it in one place. This looks not worth.
> 
> WDYT?

There needs to be a clear use case if you want to add notifications.
Plumbing ECHO to existing notifications is just good hygiene, if you
want to add new notifications you'd need to provide a real use case.

I don't buy the "a lot code changed" BTW, you can make
dev_change_flags() a wrapper and add dev_change_flags_nlh() or whatnot
which will take the extra argument.
