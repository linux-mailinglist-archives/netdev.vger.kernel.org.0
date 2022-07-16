Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35517576B28
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 02:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiGPAzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 20:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiGPAzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 20:55:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E820793C16
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 17:55:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1EC03CE325F
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 00:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5858C34115;
        Sat, 16 Jul 2022 00:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657932917;
        bh=9fj4Mtz6w0+tscGpGEKEp4UkEN9DNsAfh5IGKm18V6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PYpP6Eie0VYnVt5mXN0eNF4uc7fV4VTsGO1iudHpbu7KlMfTcKSfERFzdQZCMv+QI
         4EARUhRoMT0rk2/0MRBqpDAeqloFB71QkJOtIQFZGa9objAJR6Z7luhKZFiDgvrQMz
         ZwmMg5VfEPK8Oy0BT2XHUwU5ghnh/ZobVdEznTZGl8LtXtZ3OirP1fH14egMVgdzMJ
         AO+kfqDrkgT1sqJJB05tP/0pc5TOiGUQpI5EzuH086J9gxo8oP0btq8Iz/qmWubrZ7
         qjlXpOKQ7R/E2ENMR0GmpzAeSuSFJdpTJVPvv36fFfVSrp3dVnngmIpAY7v4ZlRNVm
         vCn5hJCPTCQJQ==
Date:   Fri, 15 Jul 2022 17:55:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Brian Hutchinson <b.hutchman@gmail.com>
Subject: Re: [PATCH net] net: dsa: fix bonding with ARP monitoring by
 updating trans_start manually
Message-ID: <20220715175516.6770c863@kernel.org>
In-Reply-To: <20220716002612.rd6ir65njzc2g3cc@skbuf>
References: <20220715232641.952532-1-vladimir.oltean@nxp.com>
        <20220715170042.4e6e2a32@kernel.org>
        <20220716001443.aooyf5kpbpfjzqgn@skbuf>
        <20220715171959.22e118d7@kernel.org>
        <20220716002612.rd6ir65njzc2g3cc@skbuf>
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

On Sat, 16 Jul 2022 00:26:13 +0000 Vladimir Oltean wrote:
> > Make bonding not depend on a field which is only valid for HW devices
> > which use the Tx watchdog. Let me find the thread...
> > https://lore.kernel.org/all/20220621213823.51c51326@kernel.org/  
> 
> That won't work in the general case with dsa_slave_get_stats64(), which
> may take the stats from hardware (delayed) or from dev_get_tstats64().

Ah, that's annoying.

> Also, not to mention that ARP monitoring used to work before the commit
> I blamed, this is a punctual fix for a regression.

trans_start is for the watchdog. This is the third patch pointlessly 
messing with trans_start while the bug is in bonding. It's trying to
piggy back on semantics which are not universally true.

Fix bonding please.
