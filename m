Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CA6607DAD
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJURk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiJURkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8220843AE9;
        Fri, 21 Oct 2022 10:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6B7FB82CB6;
        Fri, 21 Oct 2022 17:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51182C433D6;
        Fri, 21 Oct 2022 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666374017;
        bh=1oenVn7qVDln5aafmQiPCgANd8wRAgIk+bXpPnLDZsc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TyiQM07qPB6Cv/z8nDgK0NOV1aJgSDEs1i937iZ1okeKYZ8y3iazAymLSoawO945+
         3XVLXxJMOkYFJ/Q/ZQyp5e2FBLkeW3xFzOn2oKZRC15VsN0rFEefXzaqYfwEPKiej1
         viz9uQhe67D8kMYoNTDZs9+hOu5aVyD77Dl4EAqQ2r72waZCyAyaW8jp/g9A7h/US+
         HpQ5FG096N6H5S8o3aXb3Vxe/BJNmwANKnpHZE6kIU6rwIsgThDgh7iEb/0kw8INzw
         PwaO0GfANQLt4JnlSo/+aH4rhHTtTa3N/wYuGQwgQMkHBkDtwRFzlSX9ao2QYsUKT4
         u27B6ZoIN7V7Q==
Date:   Fri, 21 Oct 2022 10:40:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, cgroups@vger.kernel.org,
        roman.gushchin@linux.dev, weiwan@google.com, ncardwell@google.com,
        ycheng@google.com
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
Message-ID: <20221021104016.407cbda9@kernel.org>
In-Reply-To: <CALvZod5di3saFdDJ1cwFDgvLPmnEJ7XB9P8YBTJ3uzfBKAFi3Q@mail.gmail.com>
References: <20221021160304.1362511-1-kuba@kernel.org>
        <CALvZod4eezAXpehT4jMiQry4JQ5igJs7Nwi1Q+YhVpDcQ8BMRA@mail.gmail.com>
        <CANn89iKTi5TYyFOOpgw3P0eTi1Gqn4k-eX+xRTX78Q4sAunm2Q@mail.gmail.com>
        <CALvZod5di3saFdDJ1cwFDgvLPmnEJ7XB9P8YBTJ3uzfBKAFi3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 09:34:20 -0700 Shakeel Butt wrote:
> > > How about just using gfp_any() and we can remove gfp_memcg_charge()?  
> >
> > How about keeping gfp_memcg_charge() and adding a comment on its intent ?
> >
> > gfp_any() is very generic :/  

That was my thinking, and I'm not sure what I could put in a comment.
Wouldn't it be some mix of words 'flags', 'memory', 'cgroup' and
'charge'... which is just spelling out the name of the function? 

I mean:

	/* Alloc flags for passing to cgroup socket memory charging */

does not add much value, right? 
