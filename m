Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E31E553ACC
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 21:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245048AbiFUTwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 15:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiFUTwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 15:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8962DAA2
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 12:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9BF06179F
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 19:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC833C3411C;
        Tue, 21 Jun 2022 19:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655841169;
        bh=FMlapEJiq1g56gXJR+WVCOKa/JCBjNblRyCYan0URYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fRxGRXxAAujre7e0h4Nhbbt4i7mtoMDPPEQTHAreng1kC3mfayPJCiPkuVSr+UcAt
         YySWsCmK4/axknInpw6N73gt22KgMC04+7EJzr9e1Ak/uHIqklldckR9RWsuSl8V82
         CIq150PnRKj7NPdQDhODSAYWhobqCCq1UYZJJYLH33eO1CGdER52FiXpJqaZ7VOKKn
         5eswWRwV2HY9eT0ixwrTq6UvkNqlA5cbegWBauR87EYGGVEp6xJtFXojxUGzk36jB5
         en56uUy2zPQTUvzobxfZwDpDgEDx1E+u3IsF1vMVW0DDWykDOFec7Mt2RqvsIE35qM
         /LJVBKUaqHHVg==
Date:   Tue, 21 Jun 2022 12:52:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] veth: Add updating of trans_start
Message-ID: <20220621125233.1d36737b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220617175550.6a3602ab@kernel.org>
References: <9088.1655407590@famine>
        <20220617084535.6d687ed0@kernel.org>
        <5765.1655484175@famine>
        <20220617124413.6848c826@kernel.org>
        <28607.1655512063@famine>
        <20220617175550.6a3602ab@kernel.org>
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

On Fri, 17 Jun 2022 17:55:50 -0700 Jakub Kicinski wrote:
> > >I presume it needs it to check if the device has transmitted anything
> > >in the last unit of time, can we look at the device stats for LLTX for
> > >example?    
> > 
> > 	Yes, that's the use case.  
> > 
> > 	Hmm.  Polling the device stats would likely work for software
> > devices, although the unit of time varies (some checks are fixed at one
> > unit, but others can be N units depending on the missed_max option
> > setting).
> > 
> > 	Polling hardware devices might not work; as I recall, some
> > devices only update the statistics on timespans on the order of seconds,
> > e.g., bnx2 and tg3 appear to update once per second.  But those do
> > update trans_start.  
> 
> Right, unfortunately.
> 
> > 	The question then becomes how to distinguish a software LLTX
> > device from a hardware LLTX device.  
> 
> If my way of thinking about trans_start is correct then we can test 
> for presence of ndo_tx_timeout. Anything that has the tx_timeout NDO
> must be maintaining trans_start.

So what's your thinking Jay? Keep this as an immediate small fix 
for net but work on using a different approach in net-next?
