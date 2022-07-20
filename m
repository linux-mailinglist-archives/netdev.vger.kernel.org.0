Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA9457BBDC
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiGTQuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbiGTQuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:50:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B94B47
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4295061DD7
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D59C3411E;
        Wed, 20 Jul 2022 16:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658335803;
        bh=7KCknlPec0+JAbGS2IGZ8hiGg//cpTF7TYHy42IromU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OZ3C45dqRx571Hhf2JapLCqsWWJqEXOOxNz6qAyPJwMnVPx9hFVEjxGPB6kSZdIFS
         ioJhA1mw+j7hH5kaA3HNHZpWmXcuDKZkjWl6oyyQJ0f77jJygr9qmwl2KD1u5860Nv
         gyaLKn7rfoQGSCGjIpxsiFwBJdGjQ+LlapuzdpOi9YLNCylIsXoynesf1yUw9Zn1h+
         FBegFIPZdiCAFC4lC/DV8oI8X1Ta/KabYYP/3+N36BMAfPDEqn3YTc+Oyg6ySPq6h5
         rsjZ+lePOulRYGy6vv5cGPIXjaZGYJA5LN3vzUIuukSMvoAIBBnX4D0ZlVestZgIMd
         xe+ONAm8dLjoA==
Date:   Wed, 20 Jul 2022 09:50:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthias May <matthias.may@westermo.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <nicolas.dichtel@6wind.com>, Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated
 IP frames
Message-ID: <20220720095002.094986df@kernel.org>
In-Reply-To: <ba54b498-5388-44c2-9554-953a3cf1b8eb@westermo.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
        <20220705182512.309f205e@kernel.org>
        <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
        <20220706131735.4d9f4562@kernel.org>
        <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
        <20220707170145.0666cd4c@kernel.org>
        <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
        <20220711112911.6e387608@kernel.org>
        <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
        <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>
        <88cbeaff-4300-b2c4-3d00-79918ec88042@westermo.com>
        <f8eb52c3-40a7-6de2-9496-7a118c4af077@6wind.com>
        <ba54b498-5388-44c2-9554-953a3cf1b8eb@westermo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jul 2022 17:24:17 +0200 Matthias May wrote:
> I finally got around to do the previously mentioned selftest for gretap, vxlan and geneve.
> See the bash-script below.
>
> Many of the vxlan/geneve tests are currently failing, with gretap working on net-next
> because of the fixes i sent.
> What is the policy on sending selftests that are failing?
> Are fixes for the failures required in advance?
> 
> I'm not sure i can fix them.
> Geneve seems to ignore the 3 upper bits of the DSCP completely.
> 
> My other concern is:
> The whole test is... slow.
> I tried to figure out what takes so long, and the culprit seem to be tcpdump.
> It just takes ages to start capturing, more so when it is capturing IPv6.
> Does anyone know of a better way to capture traffic and analyze it afterwards?
> I used tcpdump because other tests seem to use it, and i guess this is a tool
> that most everyone has installed (that works with networks).

Yeah, tcpdump is not great, there's a bunch of flags that make it a
little less bad (--immediate-mode?) 

Looking at the last test I wrote I ended up with:

tcpdump --immediate-mode -p -ni dummy0 -w $TMPF -c 4
sleep 0.05 # wait for tcpdump to start
