Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F0959EE4E
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 23:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiHWVig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 17:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiHWVig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 17:38:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629B413F09
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 14:38:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27A54B8218F
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 21:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E125C433D6;
        Tue, 23 Aug 2022 21:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661290712;
        bh=cdX/t5FrNewup+vOqRq3Jd4movq26vPXoqSGqjwQTF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RwS6cGvRzKjSxoYvXmzKE2lokVGOb8BKqeVHgqopB2J+UbOk8Z5c0nWaj5lbZu5oF
         RYm6HRg6sJXEom/uGLzBPmZw1apaHAnPda/6oOoIQRxEa18lx1bK2f5foWJTSRJktU
         icDv1SCQ/Me3HfrTSnT952weAk/Kmhz4jpVv3xURQ72W3PCJ+pJLAMgHy4dbbFBPEd
         gGAjvALMRG0UVOV4HuOTdKXLP/jXMaRbW2VX8ZXC75MDKR7btavrcumNRsEJnPDObC
         5kdBkTUmNdPGhYc3SpI7yBY2aimMD2FBaFW2w4kU0JDva5ZjNOhv9A2WXOii8w5778
         fTnguuYGb8Wsg==
Date:   Tue, 23 Aug 2022 14:38:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH v2 net] net: dsa: microchip: make learning configurable
 and keep it off while standalone
Message-ID: <20220823143831.2b98886b@kernel.org>
In-Reply-To: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
References: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
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

On Thu, 18 Aug 2022 19:48:09 +0300 Vladimir Oltean wrote:
> Address learning should initially be turned off by the driver for port
> operation in standalone mode, then the DSA core handles changes to it
> via ds->ops->port_bridge_flags().
> 
> Leaving address learning enabled while ports are standalone breaks any
> kind of communication which involves port B receiving what port A has
> sent. Notably it breaks the ksz9477 driver used with a (non offloaded,
> ports act as if standalone) bonding interface in active-backup mode,
> when the ports are connected together through external switches, for
> redundancy purposes.
> 
> This fixes a major design flaw in the ksz9477 and ksz8795 drivers, which
> unconditionally leave address learning enabled even while ports operate
> as standalone.
> 
> Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
> Link: https://lore.kernel.org/netdev/CAFZh4h-JVWt80CrQWkFji7tZJahMfOToUJQgKS5s0_=9zzpvYQ@mail.gmail.com/
> Reported-by: Brian Hutchinson <b.hutchman@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: targeting the 6.0 release candidates as opposed to the 5.19 rc's
>         from v1.
> 
> Again, this is compile-tested only, but the equivalent change was
> confirmed by Brian as working on a 5.10 kernel.
> 
> @maintainers: when should I submit the backports to "stable", for older
> trees?

"when" as is how long after Thu PR or "when" as in under what
conditions?
