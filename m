Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAEB648B82
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiLIX7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLIX7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:59:12 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F97AB07B2
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 15:59:11 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3b10392c064so72647807b3.0
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 15:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2UupccmiQ8izgiUvLjsZYz/7brYZNdAlH7Jmj1KGeU0=;
        b=SJ0aO158dbxyl5JW6JY58Oc8c8GMnxNRra3UT2wSbTZGbzcfW/MI/Uj0qyxjyRZFDp
         wLnxpNI+Zswi3y7+pDxZQi+CIgIJqRwNzWv0T0T4p/9MqTw+Elr8EBhLZRlX0+p+3IZ6
         oiXdHwhp1ULCPgkBewSmU80m36yEqKCZUc12CXjQkX0CLB3njFyQizKxiTN2BsHBjCxE
         dkPUfb04MkvNF4PUh8f7PC4hbG5ZHJIn9IbJXzDOQawO1fpuNQf0rnE2YxYPQfJ8QfUv
         v9yHkqB71DPgmrsKng1H/IRsyEYSs5i1GBL5ZW2j89kgNqxBCU0aoFiyj4CvrLJ7cvx8
         agGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2UupccmiQ8izgiUvLjsZYz/7brYZNdAlH7Jmj1KGeU0=;
        b=1C/JjeDS4knW0x3ThKHV9TliiWfrNfky8uHf6uuEd0NT3lwFPfTC8aLv3E1IOWS5FW
         zxTQERwbkqFGf59ziG3M6Izol7uVESh0YTP607ohrxWLEnqF9hS/R1542EK7CY8nffSx
         vLtfhLaZi2tlNqDnmG3Cuj4IBdRSuCnmidMTzkLNkQNOIJv0ItkwnUpyrHnia9nQqxbA
         gYbPLeeR/20yAgfDi/1SRVZKx6ygP4fA+QNNYGED0WAAFNgg4ycPdJPbM/JT1ixEIZ/o
         UbqaYs2an4Rra+79DKrwKw4kb/aWu7w+0sIn5iEmItEfIJi/uXIPqy9u8bjvX3VJ4bhI
         mENg==
X-Gm-Message-State: ANoB5pm+s/8qMWElrCPtf8a+dsukC4m1EW9PoRU0gKGgGBr3Uvcv6AO5
        DyTSKugaQvBOJ31s7FXakUTESWs5xK80fDSmekdMH/a3xx54I9XJ
X-Google-Smtp-Source: AA0mqf4ZUh23l3/Oz+Wfl9fJjoxgPUPMka6nVw70gU8tUdn2mknwFyY0HXqZtL+AGa0yZf+LQIaNCcK1yTTjk7bUlSU=
X-Received: by 2002:a81:1e44:0:b0:370:7a9a:564 with SMTP id
 e65-20020a811e44000000b003707a9a0564mr25482093ywe.278.1670630350351; Fri, 09
 Dec 2022 15:59:10 -0800 (PST)
MIME-Version: 1.0
References: <20221209101305.713073-1-liuhangbin@gmail.com> <20221209101305.713073-2-liuhangbin@gmail.com>
In-Reply-To: <20221209101305.713073-2-liuhangbin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 10 Dec 2022 00:58:59 +0100
Message-ID: <CANn89iK8TEtpZa67-FfR6KFKAj_HCdtn3573Z9Cd7PG26WP3iA@mail.gmail.com>
Subject: Re: [PATCH net 1/3] bonding: access curr_active_slave with rtnl_dereference
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, liali <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 9, 2022 at 11:13 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Looks commit 4740d6382790 ("bonding: add proper __rcu annotation for
> curr_active_slave") missed rtnl_dereference for curr_active_slave
> in bond_miimon_commit().
>
> Fixes: 4740d6382790 ("bonding: add proper __rcu annotation for curr_active_slave")


> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  drivers/net/bonding/bond_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index b9a882f182d2..2b6cc4dbb70e 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -2689,7 +2689,7 @@ static void bond_miimon_commit(struct bonding *bond)
>
>                         bond_miimon_link_change(bond, slave, BOND_LINK_UP);
>
> -                       if (!bond->curr_active_slave || slave == primary)
> +                       if (!rtnl_dereference(bond->curr_active_slave) || slave == primary)

We do not dereference the pointer here.

If this is fixing a sparse issue, then use the correct RCU helper for this.

( rcu_access_pointer())
