Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618011DA0CF
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgESTQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgESTQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:16:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563F6C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 12:16:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF7ED128B5928;
        Tue, 19 May 2020 12:16:42 -0700 (PDT)
Date:   Tue, 19 May 2020 12:16:41 -0700 (PDT)
Message-Id: <20200519.121641.1552016505379076766.davem@davemloft.net>
To:     vinay.yadav@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, secdev@chelsio.com
Subject: Re: [PATCH net-next] net/tls: fix race condition causing kernel
 panic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519074327.32433-1-vinay.yadav@chelsio.com>
References: <20200519074327.32433-1-vinay.yadav@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 May 2020 12:16:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Date: Tue, 19 May 2020 13:13:27 +0530

> +		spin_lock_bh(&ctx->encrypt_compl_lock);
> +		pending = atomic_read(&ctx->encrypt_pending);
> +		spin_unlock_bh(&ctx->encrypt_compl_lock);

The sequence:

	lock();
	x = p->y;
	unlock();

Does not fix anything, and is superfluous locking.

The value of p->y can change right after the unlock() call, so you
aren't protecting the atomic'ness of the read and test sequence
because the test is outside of the lock.
