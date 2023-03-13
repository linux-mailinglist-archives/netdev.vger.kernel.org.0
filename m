Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12D06B8488
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCMWKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCMWKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:10:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE42D85A48
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 15:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90B1EB81183
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9019C433EF;
        Mon, 13 Mar 2023 22:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678745430;
        bh=h1VSGvYt2LiorC4Ao8jGfC6tVRPPdsUBUcHUF1b5N9s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O/B5LUBJlBLpv7SxiitdwzfbzYQmU2nrvi7+pF6esZGXhR4xhoG4P95x/sbfXqRS5
         sg8X5OaltFB3b7Bf1qEf0vXa0RTot58SrhJ8yy2x7ZfkcStfSNeOZ3Ne/YKvzU4hK0
         4aLWbbUFkIeHUOVWFQXgwa2SI5hnQsqbJ/Ud/1NrpAt6a13CPfFosQsib5wTGg/kI6
         4SCTgjrjBpl06LekGC87hJPSme54/FEr2i7ABGjLJajqz3HSjSUAYY20ZUSyQGAkEN
         ly2QbnuHRhRWLppRK3/2bEg+OQxkCif30zxKCgvTd37bwQ04lga8wxiSIK0NZ5ya5v
         FktoKkh8Niw2Q==
Date:   Mon, 13 Mar 2023 15:10:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 0/5] net: Extend address label support
Message-ID: <20230313151028.78fdfec6@kernel.org>
In-Reply-To: <87sfe8sniw.fsf@nvidia.com>
References: <cover.1678448186.git.petrm@nvidia.com>
        <20230310171257.0127e74c@kernel.org>
        <87sfe8sniw.fsf@nvidia.com>
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

On Mon, 13 Mar 2023 14:26:56 +0100 Petr Machata wrote:
> > Feels a bit like we're missing motivation for this change.
> > I thought address labels were legacy cruft.  
> 
> The immutability and lack of IPv6 support is seriously limiting, so the
> fact nobody is using this is not that surprising.
> 
> > Also the usual concern about allowing to change things is that some
> > user space will assume it's immutable. The label could until this 
> > set be used as part of a stable key, right?  
> 
> Maybe. But to change a label, you need to be an admin, so yeah, you can
> screw things up if you want to. You could e.g. delete the address
> outright. In the end it should be on me as an admin to run a stack that
> is not stumbling over itself.

I haven't seen that caveat under the "no uAPI-visible regressions"
rule book...  Have you done a github grep for uses of this attr?
I'm guessing that indeed nobody will notice.

> As for the motivation: the use case we are eying in particular is
> advertisement of MLAG anycast addresses. One label would be used to mark
> anycast addresses if they shouldn't be advertised by the routing stack
> yet, a different label for those that can be advertised. Which labels
> mean what would be a protocol between the two daemons involved.

Hm. I see.

> Other userspace stacks might use this to their own ends to annotate sets
> of addresses according to their needs. Like they can today, if the
> sets only involve IPv4 addresses that never migrate from set to set :)

I suspect we may have skipped the feature in v6 for two reasons 
(1) it had no modern use and (2) address label in IPv6 means
the precedence value in address selection, doesn't it?
