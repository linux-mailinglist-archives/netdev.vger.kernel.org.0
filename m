Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C80588326
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 22:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbiHBUdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 16:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiHBUdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 16:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D695517E08
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 13:33:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73099614F7
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 20:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4983EC433C1;
        Tue,  2 Aug 2022 20:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659472423;
        bh=E1ZlKgad8T5CbJbCpOTsTRynPRjgo0nW9RVlfaJdyHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Liov484c2b5LxjmXKGaxu02VOo9BdoAjWuwqDfWUjAVTdSWG8Tej89nUself9seTw
         thtAgzCPmV5CKjC6Bj5uIgqNlqUxR+NwOzdCXK3UT2GR4tI16lUK7onTMhaDXz7Edd
         4yXZo+qhFc903zEeqeeI2bFlVBiPutiS3QDkqRTIOwwfaAOdIlslafnro9pN0/Ap1z
         tXWcyO64ddvtMEqMQ4unAXrj41KsQ5d1hnhfh6OwN01sKfZNNUmlplbfluO/IwSzxq
         pyGaUISFbhapn22SaQK2Km4Ya2SRbly7ivIy0rUGbfrVs8GfljXE77mpV4SXlfasGF
         2WpIoFs+vHQpQ==
Date:   Tue, 2 Aug 2022 13:33:42 -0700
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
Message-ID: <20220802133342.1ac7531a@kernel.org>
In-Reply-To: <23020.1659471874@famine>
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
        <20220802121029.13b9020b@kernel.org>
        <23020.1659471874@famine>
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

On Tue, 02 Aug 2022 13:24:34 -0700 Jay Vosburgh wrote:
> >One more time, sorry :) If I'm reading things right Vladimir and 
> >I would like this to be part of 5.20, Paolo is okay with that,
> >Jay would prefer to delay it until 5.21.
> >
> >Is that right?  
> 
> 	I'm sure there's an Abbott & Costello joke in here somewhere,
> but I thought Paolo preferred net-next, and I said I was ok with that.

:D

> >My preference for 5.20 is because we do have active users reporting
> >problems in stable, and by moving to 5.21 we're delaying things by
> >2 weeks. At the same time, 5.20 vs 5.21 doesn't matter as we intend 
> >to hit stable users with these change before either of those is out.  
> 
> 	I have no objection to 5.20 if you & Paolo don't object.
> 
> 	For stable, I believe that 1/4 (and 4/4 for docs) is the minimum
> set to resolve the functional issues; is the plan to send all 4 patches
> to stable, or just 1 and 4?

1 & 4 for stable SGTM.

> 	I do think this patch does widen the scope of failures that may
> go undetected on the TX side, but most of the time the failure to
> receive the ARP on the RX side should cover for that.  Regardless,
> that's a concern for later that doesn't need to be hashed out right now.
