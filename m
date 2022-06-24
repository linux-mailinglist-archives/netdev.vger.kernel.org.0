Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99526559F8C
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 19:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiFXRR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 13:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiFXRR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 13:17:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF97B80
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 10:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5498B82AC8
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 17:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E79C34114;
        Fri, 24 Jun 2022 17:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656091072;
        bh=KhHu6RjvU6nUOfug66RM/DBmrS6LdvU77ltvI9ZXcMw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=muWwRQt34LiXgVi8Xu2nEOEVGZTFxqTSVpabClmaiKmX2mp4NXv6gXcJ0AxlNRpZW
         kA/APyGkRW4phreY2GsgF0sVDAbXWU3pWMan7PN1NUM6mf0Hg+MJy+YJlgtfrgverR
         HsTfrOKaS9COugjGQnpf3oQXrjsCs7ws711FTo5akIHsNqUvvQnG05Blk01WrrIs/I
         1LxhMxfKrbI52RHwc5eanT1Sl5lm4KGpMkJ9GnNpm7iXSJnlJuQDh2P7BaBzc58cXq
         z8pXe8LvpNKxI4l88UazZK9PhqaQzqxszUsiNG/OW2fV867WfIBZX14a7q4oqe+r/r
         3x4PgXgZk46qQ==
Date:   Fri, 24 Jun 2022 10:17:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksey Shumnik <ashumnik9@gmail.com>
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, xeb@mail.ru
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
Message-ID: <20220624101743.78d0ece7@kernel.org>
In-Reply-To: <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
        <20220622171929.77078c4d@kernel.org>
        <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
        <20220623202602.650ed2e6@kernel.org>
        <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
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

On Fri, 24 Jun 2022 16:51:41 +0300 Aleksey Shumnik wrote:
> On Fri, Jun 24, 2022 at 6:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > I use SOCK_DGRAM  
> >
> > Strange.  
> 
> Why is it strange?

I meant surprising, I'd have thought we could miss something like that
for RAW sockets maybe but DGRAM/ICMP should work.

> > > I want to find out, the creation of gre and ip header twice, is it a
> > > feature or a bug?  
> >
> > I can't think why that'd be a feature. Could add this case to selftests
> > to show how to repro and catch regressions?  
> 
> I don't really know how to do it, but I'll try
> If we just talk about selftests/net, then everything has passed

What I'm looking for is a bash(?) script which sets up the tunnel sends
a packet and checks if the headers are valid.

> > > I did everything according to the instructions, hope everything is
> > > correct this time.  
> >
> > Nope, still mangled.  
> 
> Strangely, everything works fine for me

Depends on definition of "works", are you saying you can download this:

https://lore.kernel.org/all/CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com/raw

which is your email in text form and `git am` will accept that as a
patch?
