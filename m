Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DA95255FB
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 21:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353024AbiELTqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 15:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358204AbiELTqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 15:46:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DA132057;
        Thu, 12 May 2022 12:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F5361DA4;
        Thu, 12 May 2022 19:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C200FC385B8;
        Thu, 12 May 2022 19:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652384770;
        bh=FphpY5pj+S7AOQXAISwaEryRE2ZR8UaKb+vNvWxe4ZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BLS9DMOvOE5u60oBd0tsWixpD2hRuliwpVlP9Ha+TIeiKZ46qyIYOwK+ZGB03R3/P
         y530u/U9qU2ebqDIAwNkF5yt6bNxPI5We2n4TWcWi4nw7Fxcx+BdDll9qY77GErCHe
         y2a3Hs929xUMYAtnocKH4fb4JWOvv/ZReWJz9xqKqRfhj2anNivFeUkoUaV7gF3OL0
         kc0RO9owdX8lXCoBpYq8vPmezTOeApvnc57v3xnNp8IZUtiNzf2f40LpQdvVWkzyGB
         tpd0ZYyv4xMtXsximnZACUlvIh1PydRbp5+UajzWSg0reAWaQAUSgVcO0XKSQEgQTU
         qpG68auOSXpog==
Date:   Thu, 12 May 2022 12:46:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC,net-next,x86 0/6] Nontemporal copies in unix socket write
 path
Message-ID: <20220512124608.452d3300@kernel.org>
In-Reply-To: <20220512010153.GA74055@fastly.com>
References: <1652241268-46732-1-git-send-email-jdamato@fastly.com>
        <20220511162520.6174f487@kernel.org>
        <20220512010153.GA74055@fastly.com>
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

On Wed, 11 May 2022 18:01:54 -0700 Joe Damato wrote:
> > Is there a practical use case?  
> 
> Yes; for us there seems to be - especially with AMD Zen2. I'll try to
> describe such a setup and my synthetic HTTP benchmark results.
> 
> Imagine a program, call it storageD, which is responsible for storing and
> retrieving data from a data store. Other programs can request data from
> storageD via communicating with it on a Unix socket.
> 
> One such program that could request data via the Unix socket is an HTTP
> daemon. For some client connections that the HTTP daemon receives, the
> daemon may determine that responses can be sent in plain text.
> 
> In this case, the HTTP daemon can use splice to move data from the unix
> socket connection with storageD directly to the client TCP socket via a
> pipe. splice saves CPU cycles and avoids incurring any memory access
> latency since the data itself is not accessed.
> 
> Because we'll use splice (instead of accessing the data and potentially
> affecting the CPU cache) it is advantageous for storageD to use NT copies
> when it writes to the Unix socket to avoid evicting hot data from the CPU
> cache. After all, once the data is copied into the kernel on the unix
> socket write path, it won't be touched again; only spliced.
> 
> In my synthetic HTTP benchmarks for this setup, we've been able to increase
> network throughput of the the HTTP daemon by roughly 30% while reducing
> the system time of storageD. We're still collecting data on production
> workloads.
> 
> The motivation, IMHO, is very similar to the motivation for
> NETIF_F_NOCACHE_COPY, as far I understand.
> 
> In some cases, when an application writes to a network socket the data
> written to the socket won't be accessed again once it is copied into the
> kernel. In these cases, NETIF_F_NOCACHE_COPY can improve performance and
> helps to preserve the CPU cache and avoid evicting hot data.
> 
> We get a sizable benefit from this option, too, in situations where we
> can't use splice and have to call write to transmit data to client
> connections. We want to get the same benefit of NETIF_F_NOCACHE_COPY, but
> when writing to Unix sockets as well.
> 
> Let me know if that makes it more clear.

Makes sense, thanks for the explainer.

> > The patches look like a lot of extra indirect calls.  
> 
> Yup. As I mentioned in the cover letter this was mostly a PoC that seems to
> work and increases network throughput in a real world scenario.
> 
> If this general line of thinking (NT copies on write to a Unix socket) is
> acceptable, I'm happy to refactor the code however you (and others) would
> like to get it to an acceptable state.

My only concern is that in post-spectre world the indirect calls are
going to be more expensive than an branch would be. But I'm not really
a mirco-optimization expert :)
