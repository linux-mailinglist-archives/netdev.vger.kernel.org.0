Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C075A64E192
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiLOTGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiLOTGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:06:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2D0FD1F;
        Thu, 15 Dec 2022 11:05:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6895361E19;
        Thu, 15 Dec 2022 19:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE27C433EF;
        Thu, 15 Dec 2022 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671131145;
        bh=TaHHwY1ARYaNL2Cdz/MrisJvKrtH05ORVveDZYFPvpw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TKm/LI0/ks3ugJyN3sD8LLRskHUy3lCxhPppBOE0FNW8hg4oJEyJf5Xy86wAWjHz8
         0cvDYvQ1Lf6oynyh5eKfr2PLd3pkVTbRcS6bucPJsN0jZTkZ0CkUKjix5ShRSR7sh1
         stZfFui76enBZA8DVQLieLCN7tIfoefkxCqhrX0SleqCx/LiQPVwywEA3XLqp4IEXl
         9f9RKmETQwkeTyj6BXtdWNXUYdb+VUfM+JppLXuhNsd37F9cn2Dedh/pANK9/yDr08
         eP5tVGa0d4pk8tQWYKiixy+GvIyLFc4ig/WPjhW2PJoSHHn+5ExgZvkpEyuJEAMS9n
         m0UngUI9yCIwg==
Date:   Thu, 15 Dec 2022 11:05:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Decotigny <ddecotig@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "Mahesh Bandewar (=?UTF-8?B?4KSu4KS54KWH4KS2IOCkrOCkguCkoeClh+CktQ==?=
        =?UTF-8?B?4KS+4KSw?=)" <maheshb@google.com>,
        David Decotigny <decot+git@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Subject: Re: [PATCH v1 1/1] net: neigh: persist proxy config across link
 flaps
Message-ID: <20221215110544.7e832e41@kernel.org>
In-Reply-To: <CAG88wWbZ3eXCFJBZ8mrfvddKiVihF-GfEOYAOmT_7VX_AeOoqQ@mail.gmail.com>
References: <20221213073801.361500-1-decot+git@google.com>
        <20221214204851.2102ba31@kernel.org>
        <CAF2d9jh_O0-uceNq=AP5rqPm9xcn=9y8bVxMD-2EiJ3bD_mZsQ@mail.gmail.com>
        <CAG88wWbZ3eXCFJBZ8mrfvddKiVihF-GfEOYAOmT_7VX_AeOoqQ@mail.gmail.com>
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

On Wed, 14 Dec 2022 22:18:04 -0800 David Decotigny wrote:
> I don't think this patch is changing that part of the behavior: we still
> flush the cached nd entries when the link flaps. What we don't remove are
> the pneigh_entry-es (ip neigh add proxy ...) attached to the device where
> the link flaps: those are configured once and this patch ensures that they
> survive the link flaps as long as the netdev stays admin-up. When
> the netdev is brought admin-down, we keep the behavior we had before the
> patch.

Makes sense. This is not urgent, tho, right?

David A, do you agree and should we treat this as a fix with

Fixes: 859bd2ef1fc1 ("net: Evict neighbor entries on carrier down")

added?

Reminder: please bottom post on the list
