Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FFB2625B4
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgIIDMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIIDMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:12:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC68C061573;
        Tue,  8 Sep 2020 20:12:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B94F911E3E4C3;
        Tue,  8 Sep 2020 19:55:54 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:12:40 -0700 (PDT)
Message-Id: <20200908.201240.821919587285621499.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, paulmck@kernel.org, joel@joelfernandes.org,
        josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikolay@cumulusnetworks.com,
        sfr@canb.auug.org.au, roopa@nvidia.com
Subject: Re: [PATCH net-next] rcu: prevent RCU_LOCKDEP_WARN() from
 swallowing the condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908173624.160024-1-kuba@kernel.org>
References: <20200908090049.7e528e7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200908173624.160024-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:55:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue,  8 Sep 2020 10:36:24 -0700

> We run into a unused variable warning in bridge code when
> variable is only used inside the condition of
> rcu_dereference_protected().
> 
>  #define mlock_dereference(X, br) \
> 	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
> 
> Since on builds with CONFIG_PROVE_RCU=n rcu_dereference_protected()
> compiles to nothing the compiler doesn't see the variable use.
> 
> Prevent the warning by adding the condition as dead code.
> We need to un-hide the declaration of lockdep_tasklist_lock_is_held()
> and fix a bug the crept into a net/sched header.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I ended up applying Nikolay's fix, but this situation with the rcu macros
needs to be addressed.
