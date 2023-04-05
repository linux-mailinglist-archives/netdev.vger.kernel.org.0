Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA426D710D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbjDEAAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbjDEAAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:00:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA88A44AB
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 17:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6542262207
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 00:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0BAC433EF;
        Wed,  5 Apr 2023 00:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680652836;
        bh=z7kA6bTqZPgSzVu/sj3hV5kZCpknDoOjDo2Ykt/fEao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ntS/TWnB7x7Jw+DAfc6Vv2qntXssGtYBKVnQD3ksc6Y/TWxhFOjdtbKZMsJVTvL7S
         vam4X/jmGk7OuDHkYORDseY+RKJAZj8q+QvosSOK/xd/G9e32K0oLmx0EmGnxObZ6s
         BZ/hgVmmhksc2R/ne7RllTw+NmnteToG/W4WwwLz6EL1fE3jVQgDGzaMOcHLaXV9nR
         TThAYMdT07NNlpyGrPmhmdAtSGqCwLTbeWiJ/S9ydNUq858B76j26xN5RLFbc6Uywl
         Qke8/Z6qjn7aNGCF1CsxymiBQHNhhojZidI6C3KpMEzt4SMKaz0deYeB7vSmAoratS
         BHYJrH6CkaZag==
Date:   Tue, 4 Apr 2023 17:00:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230404170035.6650027d@kernel.org>
In-Reply-To: <4dde688e-21db-6cc6-080e-c451eac2a9ca@suse.de>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
        <168054756211.2138.1880630504843421368.stgit@klimt.1015granger.net>
        <63A1FBC9-8970-4A36-80B1-9C7713FF1132@oracle.com>
        <4dde688e-21db-6cc6-080e-c451eac2a9ca@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 17:44:19 +0200 Hannes Reinecke wrote:
> > We're still seeing NULL pointer dereferences here.
> > Typically this happens after the remote closes the
> > connection early.
> > 
> > I guess I cannot rely on sock_hold(sk); from preventing
> > someone from doing a "sock->sk = NULL;"
> > 
> > Would it make more sense for req_submit and req_cancel to
> > operate on "struct sock *" rather than "struct socket *" ?
> >   
> Stumbled across that one, too; that's why my initial submission
> was sprinkled with 'if (!sock->sk)' statements.
> So I think it's a good idea.
> 
> But waiting for Jakub to enlighten us.

Ah, I'm probably the weakest of the netdev maintainers when it comes 
to the socket layer :)

I thought sock->sk is only cleared if the "user" of the socket closes
it. But yes, both sock->sk == NULL and sk->sk_socket == NULL are
entirely possible, and the networking stack usually operates on 
struct sock. Why exactly those two are separate beings is one of 
the mysteries of Linux networking which causes guaranteed confusion 
to all the newcomers. I wish I knew the details so I could at least
document it :S
