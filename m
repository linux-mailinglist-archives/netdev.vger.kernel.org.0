Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864E85AA1B7
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 23:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiIAVtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 17:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiIAVtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 17:49:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F485792DB
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 14:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B25561F89
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 21:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A63EC433D6;
        Thu,  1 Sep 2022 21:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662068977;
        bh=QDLWveZH3HN2QV/AmuaSDpwSPXqopku2DDfCfhfJkIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PJ+eEgD1sYuYCPcfjhTKNW840QnLh31r08CibbYrNsjkEnRfqxPJZ7T5sMDuVpX+9
         55hTfmM0beUz1jqzgemD5r6RE5FY1fV1yGNqlCd5RwYpZaLxIau3M7LL6xBgH3lx7n
         ut5O8DLOx8Ozd1Htk7A67+LgbBa3e+WSWe6YjDRGmcFOISp0cONb4YIiPvbI44YV6i
         DOe6qvs4KQkifVh2B384fLFauiIE8uKS9d7+0VFEGbRH5bM19RPXYb/NhumC6J90UW
         /ILknlcbHjrBIITnW6YtASNMh+hGVh10BKE2O++ElCk1uAZ7HdKAZtVQ9deOIYOcPy
         DkQ1Olgcn5pLw==
Date:   Thu, 1 Sep 2022 14:49:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     <pabeni@redhat.com>, <edumazet@google.com>, <davem@davemloft.net>,
        <kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
Message-ID: <20220901144936.4aaef04b@kernel.org>
In-Reply-To: <20220901212520.11421-1-kuniyu@amazon.com>
References: <f154fcd1d7e9c856c46dbf00ef4998773574a5cc.camel@redhat.com>
        <20220901212520.11421-1-kuniyu@amazon.com>
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

On Thu, 1 Sep 2022 14:25:20 -0700 Kuniyuki Iwashima wrote:
> > I looks to me that the above chunks are functionally a no-op and I
> > think that omitting the 2 drivers from the v2:
> > 
> > https://lore.kernel.org/netdev/20220829161920.99409-4-kuniyu@amazon.com/
> > 
> > should break mlx5/nfp inside a netns. I don't understand why including
> > the above and skipping the latters?!? I guess is a question mostly for
> > Eric :)  
> 
> My best guess is that it's ok unless it does not touch TCP stack deeply
> and if it does, the driver developer must catch up with the core changes
> not to burden maintainers...?
> 
> If so, I understand that take.  OTOH, I also don't want to break anything
> when we know the change would do.
> 
> So, I'm fine to either stay as is or add the change in v4 again.

FWIW I share Paolo's concern. If we don't want the drivers to be
twiddling with the hash tables we should factor out that code to
a common helper in net/tls/
