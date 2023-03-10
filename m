Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4946B5484
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjCJWdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjCJWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:33:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386981241FD
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 14:31:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB65461D71
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 22:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5693C433D2;
        Fri, 10 Mar 2023 22:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678487485;
        bh=p+vzn/Bvr/83YsW8AQsFH3Z5X+oUGzjYGxM0BD3/94k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mPptvtystWTJZKr9d3LaREBO++dxlHBMOozPFtl0EM5Io8n4Xr5AOPaGd9GVAH2VG
         Pr/3RLr9JBV1s3j+eq8uK1WsuwXCmpKO8tl/D/l5EdEw8NJ3TeXrzGc5t6ZreD3Kme
         mvomQzSQMCjz60/bqCP3q5/wATgqQWccRSCiQxqtXoy6eSKvkMjjfQlTulzSpaUyrj
         BjubeUFas0UvyOUy//+rH+KbSBCEgO/+TxXymNvvFvyveIpu5QzlvgslX+jBXUkUSc
         BxERr5/i6POdYmhIZKVUpdxVwjFvbNovkOx2N7E1bVFWVaGp1W4Lxl7pcd1EKXn0Zz
         yr6Nt/cAtiesg==
Date:   Fri, 10 Mar 2023 14:31:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v6 2/2] net/tls: Add kernel APIs for requesting a
 TLSv1.3 handshake
Message-ID: <20230310143124.36607bb3@kernel.org>
In-Reply-To: <BD185601-F6B7-4BD1-B98A-4BEEBAD738D2@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
        <167786949822.7199.14892713296931249747.stgit@91.116.238.104.host.secureserver.net>
        <BD185601-F6B7-4BD1-B98A-4BEEBAD738D2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 15:25:49 +0000 Chuck Lever III wrote:
> When TLS handshake consumers are built-in but TLS is built
> as a module, these API calls become undefined references:
> 
> ld: net/sunrpc/xprtsock.o: in function `xs_tls_handshake_sync':
> /home/cel/src/linux/linux/net/sunrpc/xprtsock.c:2560: undefined reference to `tls_client_hello_x509'
> ld: /home/cel/src/linux/linux/net/sunrpc/xprtsock.c:2552: undefined reference to `tls_client_hello_anon'
> ld: /home/cel/src/linux/linux/net/sunrpc/xprtsock.c:2572: undefined reference to `tls_handshake_cancel'
> ld: net/sunrpc/xprtsock.o: in function `xs_reset_transport':
> /home/cel/src/linux/linux/net/sunrpc/xprtsock.c:1257: undefined reference to `tls_handshake_cancel'
> ld: net/sunrpc/svcsock.o: in function `svc_tcp_handshake':
> /home/cel/src/linux/linux/net/sunrpc/svcsock.c:449: undefined reference to `tls_server_hello_x509'
> ld: /home/cel/src/linux/linux/net/sunrpc/svcsock.c:458: undefined reference to `tls_handshake_cancel'
> 
> This was fine for our prototype: we just don't build it that
> way. But it won't work long-term.
> 
> What is the approach that would be most acceptable to address
> this?

Best to stick to kconfig dependencies enforcing handshake is also built
in if consumers are. If there's a good reason to support loose
dependencies we usually do a built in stub implementation (function
pointer to a set of ops is built in, the module sets it when it loads).
