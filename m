Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55CE563D93
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 03:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiGBBm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 21:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBBm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 21:42:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4B033347
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 18:42:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81576610A2
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 01:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE836C3411E;
        Sat,  2 Jul 2022 01:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656726143;
        bh=RY4wYKGf+fpvJmloneZpVeecLdWGpw21gWT5fY9enFY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KS3gl3gseli+TSDxCOCwn763Jk4Znx9e9t1BJPMcOlfE1X0Zb2igUrRWv3O5mQs1x
         C72YyFkxiQdmS9/6VV5RFDTtki0Qi1q/h/we8DB6LZ8o/MY/BhgXsjSak6rsvBJ4+2
         IezzhJQDkBHAaA5RfAgHsxbgQviWOdJWDkr4EQXjPvFnISW/qVmVKv8EcHAbw+pNc3
         G5NXUA/JrzwuSkXYQVRavdxPo9ptWzn+3PTRU3JlB+j9ygOnVC3TwU5z3zXPEj8kKb
         9fBPLfxVfxGfVWqoN5Okzqk2jliCsEWi/Aw31lfKUJvExKjSY7m6XJ9UHgNPfthCoR
         5QWNq2CgFoQAg==
Date:   Fri, 1 Jul 2022 18:42:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksey Shumnik <ashumnik9@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
Message-ID: <20220701184222.34b75a77@kernel.org>
In-Reply-To: <20220701183151.1d623693@kernel.org>
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
        <20220622171929.77078c4d@kernel.org>
        <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
        <20220623202602.650ed2e6@kernel.org>
        <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
        <20220624101743.78d0ece7@kernel.org>
        <CAJGXZLhJd4xYQhvhb8r0QYhjSjNUCe6nmvi5TA_Ma6LO992KYw@mail.gmail.com>
        <20220701183151.1d623693@kernel.org>
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

On Fri, 1 Jul 2022 18:31:51 -0700 Jakub Kicinski wrote:
> On Tue, 28 Jun 2022 18:18:27 +0300 Aleksey Shumnik wrote:
> > pre-up ip tunnel add mgre0 mode ip6gre local 4444::1111 key 1 ttl 64 tos inherit  
> 
> I can't get GRE6 tunnels to work as NBMA net at all.
> AFAICT ip6gre_tunnel_xmit() takes the endpoint addresses straight 
> from the netdev, only ip6tnl seems to be doing a lookup.
> Am I doing it wrong?

If it's just v4 could perhaps be commit fdafed459998 ("ip_gre: set
dev->hard_header_len and dev->needed_headroom properly"). Would you 
be able to try some kernel older than 5.8?
