Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690E258FE7E
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiHKOqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiHKOqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:46:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FCE6EF39;
        Thu, 11 Aug 2022 07:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 717CAB8210E;
        Thu, 11 Aug 2022 14:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C3CC433D6;
        Thu, 11 Aug 2022 14:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660229192;
        bh=AsI6zcbSLhhGdTSybNlvc2ja5Xa+Qc9qTl3jnHqHkGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XPdPUlRciMcmIZ8xXmWClaQRCNzxRJfNjdkgOX2xHplGbkSzo7pZGgT6JjaNhIE9X
         2NWi4frOBT9Wi4SOOKOC9zmSWEo7dhEuenORoIEiEnYPtO+rx/1GbYSxN+rm8DuFux
         hcipvfeVVi61AwdTXHFIhJ+XCTNi+tyhRD0iLzuNQez9GsDAPQFExHiPlNCApA+pFV
         RB4L/F1tJHaiFjwHPzgJIAed4A1LzBEavpvAJzqioyX1YsTQO/igcmvPf4zM086rM4
         NTOaIdXWN9iBmYzdjH2aAPzRHtEdn7YsqpqS4dFjQ+zYhK6sBysRonFR/LMaNp3ECU
         hoeGXfkP3gMKQ==
Date:   Thu, 11 Aug 2022 07:46:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, "Denis V . Lunev" <den@openvz.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        kernel@openvz.org, devel@openvz.org
Subject: Re: [PATCH v2 0/2] neighbour: fix possible DoS due to net iface
 start/stop loop
Message-ID: <20220811074630.4784fe6e@kernel.org>
In-Reply-To: <20220810160840.311628-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
        <20220810160840.311628-1-alexander.mikhalitsyn@virtuozzo.com>
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

On Wed, 10 Aug 2022 19:08:38 +0300 Alexander Mikhalitsyn wrote:
>  include/net/neighbour.h |  1 +
>  net/core/neighbour.c    | 46 +++++++++++++++++++++++++++++++++--------
>  2 files changed, 38 insertions(+), 9 deletions(-)

Which tree are these based on? They don't seem to apply cleanly
