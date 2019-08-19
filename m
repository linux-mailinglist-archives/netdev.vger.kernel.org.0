Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C9B94EB8
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfHSUIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:08:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35700 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbfHSUIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:08:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83E94145F526A;
        Mon, 19 Aug 2019 13:08:38 -0700 (PDT)
Date:   Mon, 19 Aug 2019 13:08:37 -0700 (PDT)
Message-Id: <20190819.130837.1772205052483949360.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, soheil@google.com, ncardwell@google.com,
        eric.dumazet@gmail.com, jbaron@akamai.com, rutsky@google.com
Subject: Re: [PATCH net] tcp: make sure EPOLLOUT wont be missed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190817042622.91497-1-edumazet@google.com>
References: <20190817042622.91497-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 13:08:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 16 Aug 2019 21:26:22 -0700

> As Jason Baron explained in commit 790ba4566c1a ("tcp: set SOCK_NOSPACE
> under memory pressure"), it is crucial we properly set SOCK_NOSPACE
> when needed.
> 
> However, Jason patch had a bug, because the 'nonblocking' status
> as far as sk_stream_wait_memory() is concerned is governed
> by MSG_DONTWAIT flag passed at sendmsg() time :
> 
>     long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
> 
> So it is very possible that tcp sendmsg() calls sk_stream_wait_memory(),
> and that sk_stream_wait_memory() returns -EAGAIN with SOCK_NOSPACE
> cleared, if sk->sk_sndtimeo has been set to a small (but not zero)
> value.
> 
> This patch removes the 'noblock' variable since we must always
> set SOCK_NOSPACE if -EAGAIN is returned.
> 
> It also renames the do_nonblock label since we might reach this
> code path even if we were in blocking mode.
> 
> Fixes: 790ba4566c1a ("tcp: set SOCK_NOSPACE under memory pressure")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Reported-by: Vladimir Rutsky  <rutsky@google.com>

Applied and queued up for -stable.
