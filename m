Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A256C6DF9
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjCWQn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjCWQnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:43:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3977EE1;
        Thu, 23 Mar 2023 09:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4580B821C8;
        Thu, 23 Mar 2023 16:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4FFC433EF;
        Thu, 23 Mar 2023 16:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679589635;
        bh=C6zbcam0xUhqGIfoAQN43u6ixgPQPCK5MXt51f5tQ+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pRfB86HvPG+N1+COI+X5YsHdDxWA2NjhUDXInRcRJDCMba2LlCyhLjVaF0jVk/zkD
         yjbWGIIxAM/Lv1tdKJFynZe8SHo5Q4x9uaQPvgAoSaag4h+CDmOmlf2cs9NYIovc9v
         j+12A01A1Aeg/bIx2UfQF7K6Rygyl2FVqWaI/xLnut4vsO1ZPEi6940r0Ndb9H1Ulp
         g0uHfKKw06LEgY66EB3oERVvEPjRKk6MVV7XWPTOvJoEpePJfzAHOOvMPC/dkpSuln
         6D7vLgrquuoqrbwMBXzD7KO+hMl2XTRJILL1DimurM04P+5LWyzTO5NYHoz/S278hs
         AMUzVxrBl6lsg==
Date:   Thu, 23 Mar 2023 09:40:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] sh_eth: remove open coded netif_running()
Message-ID: <20230323094034.5b021c65@kernel.org>
In-Reply-To: <CAMuHMdUt_kTH3tnrdF=oKBLyjrstei8PLsyr+dFXVoPEyxTLAA@mail.gmail.com>
References: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
        <79d945a4-e105-4bc4-3e73-64971731660e@omp.ru>
        <CAMuHMdUt_kTH3tnrdF=oKBLyjrstei8PLsyr+dFXVoPEyxTLAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 09:32:27 +0100 Geert Uytterhoeven wrote:
> Is there some protection against parallel execution of ndo_open()
> and get_stats()?

Nope - one is under rtnl_lock, the other under just RCU, IIRC.
So this patch just makes the race worse, but it was already
racy before.
