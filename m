Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FD8211737
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgGBAbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgGBAbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:31:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A98CC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 17:31:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B321014DA8B7F;
        Wed,  1 Jul 2020 17:31:13 -0700 (PDT)
Date:   Wed, 01 Jul 2020 17:31:12 -0700 (PDT)
Message-Id: <20200701.173112.1978013933888714889.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com, herbert@gondor.apana.org.au,
        elver@google.com
Subject: Re: [PATCH v2 net] tcp: md5: refine
 tcp_md5_do_add()/tcp_md5_hash_key() barriers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701184304.3685065-1-edumazet@google.com>
References: <20200701184304.3685065-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 17:31:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  1 Jul 2020 11:43:04 -0700

> My prior fix went a bit too far, according to Herbert and Mathieu.
> 
> Since we accept that concurrent TCP MD5 lookups might see inconsistent
> keys, we can use READ_ONCE()/WRITE_ONCE() instead of smp_rmb()/smp_wmb()
> 
> Clearing all key->key[] is needed to avoid possible KMSAN reports,
> if key->keylen is increased. Since tcp_md5_do_add() is not fast path,
> using __GFP_ZERO to clear all struct tcp_md5sig_key is simpler.
> 
> data_race() was added in linux-5.8 and will prevent KCSAN reports,
> this can safely be removed in stable backports, if data_race() is
> not yet backported.
> 
> v2: use data_race() both in tcp_md5_hash_key() and tcp_md5_do_add()
> 
> Fixes: 6a2febec338d ("tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Eric.
