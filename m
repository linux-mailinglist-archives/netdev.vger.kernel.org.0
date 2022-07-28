Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45855842D5
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiG1PRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiG1PRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:17:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8359754AEC
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30B22B82492
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FADC433D6;
        Thu, 28 Jul 2022 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659021422;
        bh=bhRj2zBcMHGtfaaEffYWQs/H46WyPjGwUKHa91FvTpw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a/LWAy2q+AVN1LqMO2JhHzg+nNj72s+U/g4PkqOHTNHDnijweQ3lZbbaM14OiHacx
         mZOv0yGYpGwL3eMy1fTsosmOROG2Y4GgRp1OSASZJAVocmwTGXHKbPdvYAS/wuCTC9
         qBen4GX6Xcr8SWLOv6840U2nUfqnTCRzBwUmqYAIYVNsIwHwY0jHU4nBzlyoGLAqpc
         v+kydYmGJglQE2H1uyp/rc5Sxx2t3wh8+7XttZpOf1r1PcUGYhsL5GM9gdRlro8ovS
         OZmRpCc44SISN1yX+nvXwQcjf3WiDr2u8h1HDOviR5CNmYRiYY9YXfnDhuDBZEZ/yc
         Z9TewSP39EYGw==
Date:   Thu, 28 Jul 2022 08:17:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksey Shumnik <ashumnik9@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, kuznet@ms2.inr.ac.ru,
        xeb@mail.ru
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
Message-ID: <20220728081701.191a405b@kernel.org>
In-Reply-To: <CAJGXZLgtLLMGsgn4EXO1VNiO0KvVah_jPHCmYU_zNM-_XnEOOA@mail.gmail.com>
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
        <20220622171929.77078c4d@kernel.org>
        <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
        <20220623202602.650ed2e6@kernel.org>
        <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
        <20220624101743.78d0ece7@kernel.org>
        <CAJGXZLhJd4xYQhvhb8r0QYhjSjNUCe6nmvi5TA_Ma6LO992KYw@mail.gmail.com>
        <20220701183151.1d623693@kernel.org>
        <20220701184222.34b75a77@kernel.org>
        <CAJGXZLj2pMki+88OO_fDf-KO1jehEKWg2m5yKTeB0K4yKuMmmg@mail.gmail.com>
        <20220707162319.49c25e90@kernel.org>
        <CAJGXZLgtLLMGsgn4EXO1VNiO0KvVah_jPHCmYU_zNM-_XnEOOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 16:54:01 +0300 Aleksey Shumnik wrote:
> On Fri, Jul 8, 2022 at 2:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 7 Jul 2022 19:41:23 +0300 Aleksey Shumnik wrote:
> >
> > Yeah, I've added the neigh entries (although the v6 addresses had to
> > be massaged a little for ip neigh to take them, the commands from the
> > email don't work cause iproute2 doesn't support :: in lladdr, AFAICT).
> >
> > What I've seen in tracing was that I hit:
> >
> > ip6gre_tunnel_xmit() -> ip6_tnl_xmit_ctl() -> ip6_tnl_get_cap()
> >
> > that returns IP6_TNL_F_CAP_PER_PACKET
> >
> > so back to ip6gre_tunnel_xmit() -> goto tx_err -> error, drop
> >
> > packet never leaves the interface.  
> 
> I skipped this check so that the packets wouldn't drop.
> I compared the implementations of ip_gre.c and ip6_gre.c and I
> concluded that in ip6_tnl_xmit_ctl() instead of tunnel params
> (&ip6_tnl->parms.laddr and &ip6_tnl->parms.raddr) it is better to use
> skb network header (ipv6_hdr(skb)->saddr and ipv6_hdr(skb)->daddr).
> It is illogical to use the tunnel parameters, because if we have an
> NBMA connection, the addresses will not be set in the tunnel
> parameters and packets will always drop on ip6_tnl_xmit_ctl().
> 
> > Hm, so you did get v6 to repro? Not sure what I'm doing wrong, I'm
> > trying to repro with a net namespace over veth but that can't be it...  
> 
> Yes, just skip ip6_tnl_xmit_ctl().

Mm. Having to remove checks for packets to pass thru makes it seem like 
a lot less of a bug.
