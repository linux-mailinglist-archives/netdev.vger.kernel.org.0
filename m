Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9267E63CD59
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 03:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbiK3C2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 21:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiK3C2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 21:28:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AE73122D;
        Tue, 29 Nov 2022 18:28:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31391619B2;
        Wed, 30 Nov 2022 02:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D449C433C1;
        Wed, 30 Nov 2022 02:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669775283;
        bh=z1ceRsw0LGYg7P8Qs/EXJia9wlfAImMjepZt6gI/Eu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kCoI84qXbTQAsCFmXCnPiEJDAT6YQ/BNru5kBqUhC8RH/JntcjD/+312R28W7+Bim
         WK8PqLi+/bFtC/HQkvVUtrROr1OIDrtSEETdKPYD4TRFIeGqh6Md3XbvvwjMN9TNTF
         SI+OVvLyQFHC4yZTqaYNFu9738ZlxZijXBAkDaMFv1xzZ20gQTi8H50aBoyjQlYG57
         ZT6NNAElxbumiMJkz67/uDSK58SoH2JBhlo4YdWDYokgxvr6YtqURdu1LPGji5nbQ/
         EEFucvF7PIa+dBn8wvRRAgm+6Vr5IKOOJva4xuJPL9ewSmy8sqYZXvFA3pdhQG26a3
         30FIMmw1tQYdg==
Date:   Tue, 29 Nov 2022 18:28:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Breno Leitao <leitao@debian.org>, edumazet@google.com,
        davem@davemloft.net, netdev@vger.kernel.org, leit@fb.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next] tcp: socket-specific version of
 WARN_ON_ONCE()
Message-ID: <20221129182802.51de0774@kernel.org>
In-Reply-To: <a8b0508520f0dbafd3a191aa2907996fac58af62.camel@redhat.com>
References: <20221124112229.789975-1-leitao@debian.org>
        <a8b0508520f0dbafd3a191aa2907996fac58af62.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2022 11:18:27 +0100 Paolo Abeni wrote:
> On Thu, 2022-11-24 at 03:22 -0800, Breno Leitao wrote:
> > There are cases where we need information about the socket during a
> > warning, so, it could help us to find bugs that happens and do not have
> > an easy repro.
> > 
> > This diff creates a TCP socket-specific version of WARN_ON_ONCE(), which
> > dumps more information about the TCP socket.
> > 
> > This new warning is not only useful to give more insight about kernel bugs, but,
> > it is also helpful to expose information that might be coming from buggy
> > BPF applications, such as BPF applications that sets invalid
> > tcp_sock->snd_cwnd values.  
> 
> I personally find this use-case a little too tight, you could likelly
> fetch the same information with a perf probe or something similar.

It's just the initial case, to keep the patch small.
The intent is to convert all TCP warnings to this helper.

As Breno says in the first sentence this is about having enough
relevant information to zero in on the cause of the rare crashes /
warnings (which are hit quite a lot on our "millions of machines").
