Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99572422A6
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 00:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHKWvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 18:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgHKWvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 18:51:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742E0C06174A;
        Tue, 11 Aug 2020 15:51:47 -0700 (PDT)
Received: from localhost (50-47-103-195.evrt.wa.frontiernet.net [50.47.103.195])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D08C2128B618E;
        Tue, 11 Aug 2020 15:35:00 -0700 (PDT)
Date:   Tue, 11 Aug 2020 15:51:45 -0700 (PDT)
Message-Id: <20200811.155145.1823736054077708967.davem@davemloft.net>
To:     tim.froidcoeur@tessares.net
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kaber@trash.net, hidden@balabit.hu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 0/2] net: initialize fastreuse on
 inet_inherit_port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200811183325.42748-1-tim.froidcoeur@tessares.net>
References: <20200811183325.42748-1-tim.froidcoeur@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 15:35:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Date: Tue, 11 Aug 2020 20:33:22 +0200

> In the case of TPROXY, bind_conflict optimizations for SO_REUSEADDR or
> SO_REUSEPORT are broken, possibly resulting in O(n) instead of O(1) bind
> behaviour or in the incorrect reuse of a bind.
> 
> the kernel keeps track for each bind_bucket if all sockets in the
> bind_bucket support SO_REUSEADDR or SO_REUSEPORT in two fastreuse flags.
> These flags allow skipping the costly bind_conflict check when possible
> (meaning when all sockets have the proper SO_REUSE option).
> 
> For every socket added to a bind_bucket, these flags need to be updated.
> As soon as a socket that does not support reuse is added, the flag is
> set to false and will never go back to true, unless the bind_bucket is
> deleted.
> 
> Note that there is no mechanism to re-evaluate these flags when a socket
> is removed (this might make sense when removing a socket that would not
> allow reuse; this leaves room for a future patch).
> 
> For this optimization to work, it is mandatory that these flags are
> properly initialized and updated.
> 
> When a child socket is created from a listen socket in
> __inet_inherit_port, the TPROXY case could create a new bind bucket
> without properly initializing these flags, thus preventing the
> optimization to work. Alternatively, a socket not allowing reuse could
> be added to an existing bind bucket without updating the flags, causing
> bind_conflict to never be called as it should.
> 
> Patch 1/2 refactors the fastreuse update code in inet_csk_get_port into a
> small helper function, making the actual fix tiny and easier to understand.
> 
> Patch 2/2 calls this new helper when __inet_inherit_port decides to create
> a new bind_bucket or use a different bind_bucket than the one of the listen
> socket.
> 
> v4: - rebase on latest linux/net master branch
> v3: - remove company disclaimer from automatic signature
> v2: - remove unnecessary cast

Series applied and queued up for -stable, thank you.
