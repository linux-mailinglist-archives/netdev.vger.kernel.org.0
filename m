Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9320D58824D
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 21:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiHBTLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 15:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiHBTKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 15:10:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CAC959A
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 12:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16542CE214B
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 19:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D0EC433C1;
        Tue,  2 Aug 2022 19:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659467431;
        bh=wyUzEALP4WH8+lMOlXgteuDuygTRuPjpa5dJmeBuKo0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HY2HmrRVZRCiE2vI4AGiy2b4pfE1Fu+zXzmXLKhn5ZRBr/ubu9bAzM7UpozdqzMo5
         reSmLOjZrZgBFN5gDDt3YnXYWo1I28JBuay9MROzvNV6+JaA0pD7Bm4hQJ+ePV3fF8
         F/0y5HMY6YFzQZLtAYNts5e7fO1ExUTeiF2TZTVkclIgid5eEoXLrU+854yJYwWqQy
         lDDMQ4qVgG4MCIoYgXWqEqi6YzT4AfAIHXjsfElPl6B7fKfAkphPJqujDyt3/vZREe
         NZgdwt1F6ux+j6KRUd52EmSnkKfMfoXNl7vJee7I0hq/7nkJ9eHnyAAMhBp0zunreG
         4PTd5WXe4uspg==
Date:   Tue, 2 Aug 2022 12:10:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with
 the jiffies of the last ARP/NS
Message-ID: <20220802121029.13b9020b@kernel.org>
In-Reply-To: <16274.1659463241@famine>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
        <20220731124108.2810233-2-vladimir.oltean@nxp.com>
        <1547.1659293635@famine>
        <20220731191327.cey4ziiez5tvcxpy@skbuf>
        <5679.1659402295@famine>
        <20220802014553.rtyzpkdvwnqje44l@skbuf>
        <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com>
        <20220802091110.036d40dd@kernel.org>
        <20220802163027.z4hjr5en2vcjaek5@skbuf>
        <e11a02756a3253362a1ef17c8b43478b68cc15ba.camel@redhat.com>
        <16274.1659463241@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 02 Aug 2022 11:00:41 -0700 Jay Vosburgh wrote:
> >> Alternatively, would it be more comfortable to just put this
> >> patch (1/4) to stable and not backport the others?   
> >
> >The above works for me - I thought it was not ok for Jay, but since he
> >is proposing such sulution, I guess I was wrong.  
> 
> 	My original reluctance was that I hadn't had an opportunity to
> sufficiently review the patch set to think through the potential
> regressions.  There might be something I haven't thought of, but I think
> would only manifest in very unusual configurations.
> 
> 	I'm ok with applying the series to net-next when it's available,
> and backporting 1/4 for stable (and 4/4 with it, since that's the
> documentation update).
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

One more time, sorry :) If I'm reading things right Vladimir and 
I would like this to be part of 5.20, Paolo is okay with that,
Jay would prefer to delay it until 5.21.

Is that right?

My preference for 5.20 is because we do have active users reporting
problems in stable, and by moving to 5.21 we're delaying things by
2 weeks. At the same time, 5.20 vs 5.21 doesn't matter as we intend 
to hit stable users with these change before either of those is out.
