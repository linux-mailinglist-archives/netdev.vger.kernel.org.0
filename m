Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F94263611
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIISdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgIISdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:33:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84D4C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:33:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AE501295AA17;
        Wed,  9 Sep 2020 11:16:25 -0700 (PDT)
Date:   Wed, 09 Sep 2020 11:33:11 -0700 (PDT)
Message-Id: <20200909.113311.839581620512182853.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net 0/2] wireguard fixes for 5.9-rc5
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909115815.522168-1-Jason@zx2c4.com>
References: <20200909115815.522168-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 11:16:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed,  9 Sep 2020 13:58:13 +0200

> Yesterday, Eric reported a race condition found by syzbot. This series
> contains two commits, one that fixes the direct issue, and another that
> addresses the more general issue, as a defense in depth.
> 
> 1) The basic problem syzbot unearthed was that one particular mutation
>    of handshake->entry was not protected by the handshake mutex like the
>    other cases, so this patch basically just reorders a line to make
>    sure the mutex is actually taken at the right point. Most of the work
>    here went into making sure the race was fully understood and making a
>    reproducer (which syzbot was unable to do itself, due to the rarity
>    of the race).
> 
> 2) Eric's initial suggestion for fixing this was taking a spinlock
>    around the hash table replace function where the null ptr deref was
>    happening. This doesn't address the main problem in the most precise
>    possible way like (1) does, but it is a good suggestion for
>    defense-in-depth, in case related issues come up in the future, and
>    basically costs nothing from a performance perspective. I thought it
>    aided in implementing a good general rule: all mutators of that hash
>    table take the table lock. So that's part of this series as a
>    companion.
> 
> Both of these contain Fixes: tags and are good candidates for stable.

Series applied and queued up for -stable, thanks.
