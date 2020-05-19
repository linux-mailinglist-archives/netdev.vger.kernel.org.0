Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140D51DA4A3
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgESWhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgESWhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:37:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6D0C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:37:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE405128EDAC1;
        Tue, 19 May 2020 15:37:06 -0700 (PDT)
Date:   Tue, 19 May 2020 15:37:06 -0700 (PDT)
Message-Id: <20200519.153706.1484434976528519598.davem@davemloft.net>
To:     kafai@fb.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jbacik@fb.com
Subject: Re: [PATCH net] net: inet_csk: Fix so_reuseport bind-address cache
 in tb->fast*
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519001334.1584343-1-kafai@fb.com>
References: <20200519001334.1584343-1-kafai@fb.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 15:37:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>
Date: Mon, 18 May 2020 17:13:34 -0700

> The commit 637bc8bbe6c0 ("inet: reset tb->fastreuseport when adding a reuseport sk")
> added a bind-address cache in tb->fast*.  The tb->fast* caches the address
> of a sk which has successfully been binded with SO_REUSEPORT ON.  The idea
> is to avoid the expensive conflict search in inet_csk_bind_conflict().
> 
> There is an issue with wildcard matching where sk_reuseport_match() should
> have returned false but it is currently returning true.  It ends up
> hiding bind conflict.  For example,
> 
> bind("[::1]:443"); /* without SO_REUSEPORT. Succeed. */
> bind("[::2]:443"); /* with    SO_REUSEPORT. Succeed. */
> bind("[::]:443");  /* with    SO_REUSEPORT. Still Succeed where it shouldn't */
> 
> The last bind("[::]:443") with SO_REUSEPORT on should have failed because
> it should have a conflict with the very first bind("[::1]:443") which
> has SO_REUSEPORT off.  However, the address "[::2]" is cached in
> tb->fast* in the second bind. In the last bind, the sk_reuseport_match()
> returns true because the binding sk's wildcard addr "[::]" matches with
> the "[::2]" cached in tb->fast*.
> 
> The correct bind conflict is reported by removing the second
> bind such that tb->fast* cache is not involved and forces the
> bind("[::]:443") to go through the inet_csk_bind_conflict():
> 
> bind("[::1]:443"); /* without SO_REUSEPORT. Succeed. */
> bind("[::]:443");  /* with    SO_REUSEPORT. -EADDRINUSE */
> 
> The expected behavior for sk_reuseport_match() is, it should only allow
> the "cached" tb->fast* address to be used as a wildcard match but not
> the address of the binding sk.  To do that, the current
> "bool match_wildcard" arg is split into
> "bool match_sk1_wildcard" and "bool match_sk2_wildcard".
> 
> This change only affects the sk_reuseport_match() which is only
> used by inet_csk (e.g. TCP).
> The other use cases are calling inet_rcv_saddr_equal() and
> this patch makes it pass the same "match_wildcard" arg twice to
> the "ipv[46]_rcv_saddr_equal(..., match_wildcard, match_wildcard)".
> 
> Cc: Josef Bacik <jbacik@fb.com>
> Fixes: 637bc8bbe6c0 ("inet: reset tb->fastreuseport when adding a reuseport sk")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied and queued up for -stable, thanks.
