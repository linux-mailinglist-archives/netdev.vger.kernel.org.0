Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378FF692DDE
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBKDas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBKDar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:30:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D656C38E88;
        Fri, 10 Feb 2023 19:30:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61BE961EA0;
        Sat, 11 Feb 2023 03:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DDCC4339C;
        Sat, 11 Feb 2023 03:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676086240;
        bh=NgvXgdk8dEcDcwMcv63aLqrc8IlNWN6JykhctPD4tDQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dty5zILnapqv49CeerzwH5eMGIn7HwuSotK4o3kBivUB4RmXc0Lx4xrLhttLEGa8Y
         ONgzXNgXHLY96VRxZgyZv3EKMBtZS4HQfh2plaXrgyo1SvXHPlNOyTUpcFcSiT8nJ4
         4QIpR4YkAxif8QR0Q6DGEZ3myKPOnS4ZiEIyKOLdFuEsKFOA1AyjM/ShJAnkEEJBNB
         PJA+qvm2touXgqYBO4RP8i3Oa3CI44GHM9rhGoUyzwAQIIPcDYgQD/4E4veujuPZuU
         IVEyoyv73UYl8GRa7CWzPKHYzSPWDZBGiibemFuL9rlDgSM7lMpAwypu5XsLLq7NM2
         /3kSla7UN5bvw==
Date:   Fri, 10 Feb 2023 19:30:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] sctp: sctp_sock_filter(): avoid
 list_entry() on possibly empty list
Message-ID: <20230210193039.12accfa5@kernel.org>
In-Reply-To: <20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it>
References: <20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it>
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

On Thu, 09 Feb 2023 12:13:05 +0000 Pietro Borrello wrote:
> The list_entry on an empty list creates a type confused pointer.
> While using it is undefined behavior, in this case it seems there
> is no big risk, as the `tsp->asoc != assoc` check will almost
> certainly fail on the type confused pointer.
> We report this bug also since it may hide further problems since
> the code seems to assume a non-empty `ep->asocs`.
> 
> We were able to trigger sctp_sock_filter() using syzkaller, and
> cause a panic inserting `BUG_ON(list_empty(&ep->asocs))`, so the
> list may actually be empty.
> But we were not able to minimize our testcase and understand how
> sctp_sock_filter may end up with an empty asocs list.
> We suspect a race condition between a connecting sctp socket
> and the diag query.
> 
> We attach the stacktrace when triggering the injected
> `BUG_ON(list_empty(&ep->asocs))`:

Thanks for the analysis, but I'll put this in for 6.2 anyway.
The patch looks fairly straightforward / provably correct, and
with the Fixes tag present chances are it will end up in stable either
way. With a difference of maybe a week, since the merge window is just
a week away..
