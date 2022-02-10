Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B454B1529
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245663AbiBJSVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:21:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244068AbiBJSVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:21:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413A210EA
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:21:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF39E61E53
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 18:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BDCC004E1;
        Thu, 10 Feb 2022 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644517313;
        bh=EE3aCIX04KJ7mK/7iiGBkIYQntQ+RKHDxrcWGA2ZK6E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WEoaHX6+rvvjUPfu+xQOkeNRFhbg7xgsWZK01LIosizs0IZMxnPPUqEhQ+d7i4qYf
         S2mdcrUENHqGkXo/mP4cLHWutJNBgXb2OehGZ50ZxQzb+mInLsbWaDJxLrx/X87csf
         xrZcooHjwhTJNmcgxlHdRtgNQEl0bmrTYUHHPgBngZXwK7hx6LfJ2rFb6C8KPc5K1o
         2ETldaqJWH3V917y7OntjFVPcvOSQtiQYpIt5GktvZvPsoyRGt75RIef5ITWUwx7NN
         JQl50yS9yEGeVFj+97drOpMyEv4an7xtwwPm2r1Ku0f8fOvfeN3z717dSNnUmowC6s
         cucwnElnhup1Q==
Date:   Thu, 10 Feb 2022 10:21:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, "Vlad Buslov" <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [PATCH net 1/1] openvswitch: Fix setting ipv6 fields causing hw
 csum failure
Message-ID: <20220210102151.6df356ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5ee3304d-162a-e5b2-f8e9-5a4d52c71216@nvidia.com>
References: <20220207144101.17200-1-paulb@nvidia.com>
        <20220208201155.7cc582cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5ee3304d-162a-e5b2-f8e9-5a4d52c71216@nvidia.com>
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

On Thu, 10 Feb 2022 10:53:24 +0200 Paul Blakey wrote:
> > The calls seem a little heavy for single byte replacements.
> > Can you instead add a helper based on csum_replace4() maybe?
> > 
> > BTW doesn't pedit have the same problem?
> 
> I don't think they are heavier then csum_replace4,

csum_replace4 is a handful of instructions all of which will be inlined.
csum_partial() is a function call and handles variable lengths.

> but they are more bulletproof in my opinion, since they handle both
> the COMPLETE and PARTIAL csum cases (in __skb_postpull_rcsum())

Yes, that's why I said "add a helper based on", a skb helper which
checks the csum type of the packet but instead of calling csum_partial
for no reason does the adjustment directly.

> and resemble what editing of the packet should have done - pull the
> header, edit, and then push it back.

That's not what this code is doing, so the argument does not stand IMO.
