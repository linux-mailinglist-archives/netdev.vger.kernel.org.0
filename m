Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2A56308C2
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiKSBvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbiKSBvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:51:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C22C4C37
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:26:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB4B2B8265A
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 01:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3A2C433C1;
        Sat, 19 Nov 2022 01:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668821179;
        bh=KzgL1PT932ZDhVn0+deyY04DQQYhkD/Q7PW78jxqj8s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KmguuMcx96cPH/Bi2ulhWD5+XK8OrWl05Mi35urEMupYxhal5qvfrYwc5QPD3dQXx
         /zie0jffRmOMbn8V/tPpGK6Z5pSooaP/WDj3gNPE4JcqLQP5GFytUot2TC9y+IR761
         rPp1tb+RDtIMGR36Ao1YnUo4KMVp0CGeBQTDnM/7uIvWSzX6zdAW15V/QDhZaqvLMh
         NgmnuZEtZEkvO9MEyTdL2OgNSJtojhMTWzy5owg3XBWyZTdHvgLSemwSYB5/LDXGGw
         rppcWXqkqX2DvGoiEB+iigSIVSL0I23Fbh8jFJfwC6qRON0aMR+4kmo8makBWhp4yX
         S01/nYpUYDhPg==
Date:   Fri, 18 Nov 2022 17:26:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 2/4] tsnep: Fix rotten packets
Message-ID: <20221118172618.34c7097e@kernel.org>
In-Reply-To: <20221117201440.21183-3-gerhard@engleder-embedded.com>
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
        <20221117201440.21183-3-gerhard@engleder-embedded.com>
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

On Thu, 17 Nov 2022 21:14:38 +0100 Gerhard Engleder wrote:
> If PTP synchronisation is done every second, then sporadic the interval
> is higher than one second:
> 
> ptp4l[696.582]: master offset        -17 s2 freq   -1891 path delay 573
> ptp4l[697.582]: master offset        -22 s2 freq   -1901 path delay 573
> ptp4l[699.368]: master offset         -1 s2 freq   -1887 path delay 573
>       ^^^^^^^ Should be 698.582!
> 
> This problem is caused by rotten packets, which are received after
> polling but before interrupts are enabled again. This can be fixed by
> checking for pending work and rescheduling if necessary after interrupts
> has been enabled again.
> 
> Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

This patch needs to go to net separately :(
Packets getting stuck in a queue can cause real issues to users.
