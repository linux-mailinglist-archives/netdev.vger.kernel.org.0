Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D7D55D12D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiF0Skn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbiF0Skn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:40:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D954B87;
        Mon, 27 Jun 2022 11:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2722B615BF;
        Mon, 27 Jun 2022 18:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF629C3411D;
        Mon, 27 Jun 2022 18:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656355241;
        bh=O8g6wcf1QPgEoRwydS1Km0FjoqvElRpx0Nu7vzP9UR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sBZK3ryOqz5TPWSBlfX9n5Vby5bHZfrSgipJnCcgzOE9VOGOY70NSMsFWGS36HFqg
         L5fHwjjgHjaIJGhpEZ9W+hiV0fiDWT6Aa485P6FapAaPdZ20LDXwMwFfHgKz44dzvH
         ycVRSlKGPLGj7h75EjMv+eTAEgZltda3NdGHVxcYRl8dvVVLsY+3Y/yN30crrhHOox
         ReBKd/YoyZuIPXYD6e1PgNqK20R53gUDKcd8AO+tQs7XscCpykqODHcMSJkwf2J1hN
         Oc8BTCe8lcXht5e7Yav8zcHUVfGkglc2I0YcBl6rBrmROJn5XnUKVb2ukCuQ93sP9u
         yMtEj3P/0J3fQ==
Date:   Mon, 27 Jun 2022 11:40:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/4] time64.h: define PSEC_PER_NSEC and use it
 in tc-taprio
Message-ID: <20220627114031.77c5a6e6@kernel.org>
In-Reply-To: <20220627100614.s2arerirkmcnd37z@skbuf>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
        <20220626120505.2369600-2-vladimir.oltean@nxp.com>
        <5db4e640-8165-d7bf-c6b6-192ea7edfafd@arm.com>
        <20220627085101.jw55y3fakqcw7zgi@skbuf>
        <4e4b9e1a-778e-9ca1-5c15-65e45a532790@arm.com>
        <20220627100614.s2arerirkmcnd37z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jun 2022 10:06:15 +0000 Vladimir Oltean wrote:
> > I do not have a strong opinion on where to put it. But I think that if you put a
> > section above TIME64_MAX should work.  
> 
> @networking people: do you mind if in v2 I move this patch to the end,
> hardcode 1000 in the current DSA patch 4/4, and then replace it afterwards
> with PSEC_PER_NSEC, together with tc-taprio? I'd like to leave the code
> in a clean state, but remember this is also a patch that fixes a
> functional issue, even if on net-next, so one dependency less can't
> hurt, for those who'll want to backport.

Makes sense.

