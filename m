Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA8A648B3B
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiLIXDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLIXDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:03:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02FA9655E;
        Fri,  9 Dec 2022 15:03:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C8286236E;
        Fri,  9 Dec 2022 23:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFD4C433D2;
        Fri,  9 Dec 2022 23:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670627014;
        bh=X20+rEzXX4vJaITSaB0VZ8/lv7GD334QlS1f0YhMrgQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aV3gyebBifBlO+/ivgJmIeWcGoyged7eKgF2sgv/BMsJk3fFYL6aIInfw1YHYnN1x
         V/P0zb+mUJ2CXAc1f8FZtvdiLdHd8FnXx0l1hjJDPCLbB5qGBRq1Lesa3YjWeTMbl7
         BxzEVq36MKPG1VBI2cBSx0TPDKl1tmq/oFbvQaAb+fiw312zPZdF94J0+VjD6ctWhg
         VcobJUa/yv81KP2kHadlzhArWLb7dTI0wVuDcbLcrvEQawvcDy1XTtw4pLxIO9BwjF
         YGHE5AnRLKRhZu8mNM3vucXpxLqmG/mYp2B3QLlGXzE4gy5vc+TasPPQgl1OB1LWzJ
         UAkfnhg6KTooA==
Date:   Fri, 9 Dec 2022 15:03:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, daniel.machon@microchip.com,
        davem@davemloft.net, edumazet@google.com,
        lars.povlsen@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221209150332.79a921fd@kernel.org>
In-Reply-To: <20221209152713.qmbnovdookrmzvkx@skbuf>
References: <20221209092904.asgka7zttvdtijub@soft-dev3-1>
        <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
        <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
        <20221209125611.m5cp3depjigs7452@skbuf>
        <a821d62e2ed2c6ec7b305f7d34abf0ba@walle.cc>
        <20221209142058.ww7aijhsr76y3h2t@soft-dev3-1>
        <20221209144328.m54ksmoeitmcjo5f@skbuf>
        <20221209145720.ahjmercylzqo5tla@soft-dev3-1>
        <20221209145637.nr6favnsofmwo45s@skbuf>
        <20221209153010.f4r577ilnlein77e@soft-dev3-1>
        <20221209152713.qmbnovdookrmzvkx@skbuf>
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

On Fri, 9 Dec 2022 17:27:13 +0200 Vladimir Oltean wrote:
> > So for example, on a fresh started lan966x the user will add the following
> > rule:
> > tc filter add dev eth0 ingress chain 8000000 prio 1 handle 1 protocol
> > all flower skip_sw dst_mac 00:11:22:33:44:55/ff:ff:ff:ff:ff:ff action
> > trap action goto chain 8100000
> > 
> > He expects this rule not to be hit as there is no rule in chain 0. Now if
> > PTP is started and it would enable vcap, then suddenly this rule may be
> > hit.  
> 
> Is it too restrictive to only allow adding offloaded filters to a chain
> that has a valid goto towards it, coming (perhaps indirectly) from chain 0?

Right, we fumbled the review and let the chain oddness in. 
Until recently the driver worked without any rules in chain 0 :(

Maybe adding and offload of the rules can be separated?
Only actually add the rules to the HW once the goto chain rule 
has been added? 
