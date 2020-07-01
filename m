Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72B0210160
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgGABPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 21:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGABPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 21:15:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D68C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 18:15:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E92681280A769;
        Tue, 30 Jun 2020 18:15:46 -0700 (PDT)
Date:   Tue, 30 Jun 2020 18:15:46 -0700 (PDT)
Message-Id: <20200630.181546.1338897117800736873.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com
Subject: Re: [PATCH net] tcp: md5: add missing memory barriers in
 tcp_md5_do_add()/tcp_md5_hash_key()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630234101.3259179-1-edumazet@google.com>
References: <20200630234101.3259179-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 18:15:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 30 Jun 2020 16:41:01 -0700

> MD5 keys are read with RCU protection, and tcp_md5_do_add()
> might update in-place a prior key.
> 
> Normally, typical RCU updates would allocate a new piece
> of memory. In this case only key->key and key->keylen might
> be updated, and we do not care if an incoming packet could
> see the old key, the new one, or some intermediate value,
> since changing the key on a live flow is known to be problematic
> anyway.
> 
> We only want to make sure that in the case key->keylen
> is changed, cpus in tcp_md5_hash_key() wont try to use
> uninitialized data, or crash because key->keylen was
> read twice to feed sg_init_one() and ahash_request_set_crypt()
> 
> Fixes: 9ea88a153001 ("tcp: md5: check md5 signature without socket lock")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Applied and queued up for -stable, thanks Eric.
