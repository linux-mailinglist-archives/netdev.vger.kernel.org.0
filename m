Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41E56EFB08
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbjDZTYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbjDZTYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:24:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480F18691
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A97661C58
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE47FC433EF;
        Wed, 26 Apr 2023 19:23:46 +0000 (UTC)
Date:   Wed, 26 Apr 2023 15:23:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <20230426152345.327a429d@gandalf.local.home>
In-Reply-To: <20230426191336.kucul56wa4p7topa@skbuf>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
        <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
        <20230412095534.dh2iitmi3j5i74sv@skbuf>
        <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
        <20230421124708.tznoutsymiirqja2@skbuf>
        <20230424182554.642bc0fc@rorschach.local.home>
        <20230426191336.kucul56wa4p7topa@skbuf>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Apr 2023 22:13:36 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> Ok, I did not plan for user space to treat these events as something
> stable to pick up on. The Linux bridge already notifies VLANs, FDBs,
> MDBs through the rtnetlink socket, and that's what I would consider to
> be the stable ABI. What can be seen here (DSA) is essentially a
> framework used by multiple hardware drivers, but ultimately still device
> driver-level code.
> 
> What would you recommend here? A revert?

There's lots of events in the kernel that no tools use. Do you expect
anyone to create a tool that uses these events?

We break user space API all the time. As long as nothing notices, it's OK.
We take the "tree in the forest" approach. If user space API breaks, but no
tool uses it, did it break? The answer according to Linus, is "no".

Al Viro refuses to have trace events in VFS, because there's lots of places
that could become useful for tooling, and he doesn't want to support it.
But if the events are not useful for user space tooling, they should be
generally safe to keep.

There's tons of events in the wifi code, because they are very useful for
debugging remote applications out in the world, that the wifi maintainers
have tooling for. But those are not considered "stable", because the only
tools are the ones that the maintainer of the trace events, created.

If you don't see anything using these events for useful tooling outside
your own use, then I'd just keep them. There's a thousand other events in
the kernel that are not used by tools, I doubt these will be any different.

If you think that a tool that will end up in a distribution will start
using them, then you need to take care.

-- Steve
