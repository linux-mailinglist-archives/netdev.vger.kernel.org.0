Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D54A556F52
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbiFWATe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiFWATc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:19:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EB741612
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 17:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4105F61BD9
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E29C34114;
        Thu, 23 Jun 2022 00:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655943570;
        bh=56uf5hhy4IJUI6zIFVaQrnUyrP9UkMLOj9+QhxodRMk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V4wWaB1mwwfQlXRiKJMxJ4XVnpUspN6BRm/Ryi4+q/sr8WWKydI4XVCifpYP+Ckk+
         rKODlJIh8eZ5eXLXk/HY1DRVSg3MH2upTsF2jVAkEYqMmOFdbyRm0Ac2nd8Kgz3twy
         hTIp4NMeh/6vftXJaFujsBHvA1dpLhAio00So2XBv3lm6qfbf6o9J6hIqMhm/G31vD
         y8Rgf1NHm2TW01SKbZiU8sT+qJaugZt2KYOUOEIWSDL7s2s9Ann4/aeRtpOYm3oXbL
         xPP/9HzwbAbC9lOlqKsWR5/TmfD++Bjxv8/BRM4M/uOISD8qiSX/DK30xII3h5UEwl
         l+juS1Bf5YdIA==
Date:   Wed, 22 Jun 2022 17:19:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksey Shumnik <ashumnik9@gmail.com>
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, xeb@mail.ru
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
Message-ID: <20220622171929.77078c4d@kernel.org>
In-Reply-To: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
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

On Tue, 21 Jun 2022 16:48:09 +0300 Aleksey Shumnik wrote:
> Subject: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header are  recorded twice
> Date: Tue, 21 Jun 2022 16:48:09 +0300
> 
> Dear Maintainers,
> 
> I tried to ping IPv6 hub address on the mGRE interface from the spok
> and found some problem:
> I caught packets and saw that there are 2 identical IP and GRE headers
> (when use IPv4 there is no duplication)
> Below is the package structure:
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> | eth | iph (1) | greh (1) | iph (1) | greh (1) | iph (2) | greh (2) |  icmp  |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

What socket type is the ping you have using?

> I found cause of the problem, in ip_gre.c and ip6_gre.c IP and GRE
> headers created twice, first time in ip gre_header() and
> ip6gre_header() and second time in __gre_xmit(), so I deleted
> unnecessary creation of headers and everything started working as it
> should.
> Below is a patch to eliminate the problem of duplicate headers:
> 
> diff -c a/net/inv6/ip6_gre.c b/net/inv6/ip6_gre.c

The patch looks strangely mangled, it's white space damaged and refers
to a net/inv6 which does not exist.

Could you regenerate your changes using git? git commit / format-patch
/ send-email ? 
