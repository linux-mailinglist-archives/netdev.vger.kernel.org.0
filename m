Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF44211308
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgGASsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:48:04 -0400
Received: from mail.efficios.com ([167.114.26.124]:49214 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgGASsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 14:48:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id C92982D081E;
        Wed,  1 Jul 2020 14:48:02 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id WE28IPmKqPVb; Wed,  1 Jul 2020 14:48:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 91E542D063C;
        Wed,  1 Jul 2020 14:48:02 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 91E542D063C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593629282;
        bh=jPJf1t11tMCjLzzbHUSYa57pLxkdYR8V0YYimbQsobA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=hjxXQ9liGnG5eblHUiGCKYg1iC7Lkk4nP96pFmiqPNui6pfhLhQxfct+LsDlI0/o1
         SDy2w7RU0rq8oi6ndd7AAM2RNAe3VAm+zTy2os0+MYADAwiiz38fb5YFgIHuvUjcb9
         2tUlAfWLUxIAdPtKHRPp5sSjD2We3koQH1Al87okennJ1FjXb9p7jzJPoBvrKfClVB
         +DOTkT1EDuSxNTeaMQY5A1lg6kBI1SFeEaSA/BB11wxPYzBaOJ5sKaCXVUgrxhn8Fe
         uzyNel0PRHNDKgLWLX2u5+bABKL9PAwnMjwOXF8kDwVponcSoQ+vCJ6EXOblXcoQsW
         V2Q9U2FWuQUag==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qFHZfI0J3C4G; Wed,  1 Jul 2020 14:48:02 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 7F47D2D081D;
        Wed,  1 Jul 2020 14:48:02 -0400 (EDT)
Date:   Wed, 1 Jul 2020 14:48:02 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marco Elver <elver@google.com>
Message-ID: <1217308675.19634.1593629282429.JavaMail.zimbra@efficios.com>
In-Reply-To: <20200701184304.3685065-1-edumazet@google.com>
References: <20200701184304.3685065-1-edumazet@google.com>
Subject: Re: [PATCH v2 net] tcp: md5: refine
 tcp_md5_do_add()/tcp_md5_hash_key() barriers
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers
Thread-Index: MAFzPZ1D6yNcSEGENEFCP+r8MMkfZQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jul 1, 2020, at 2:43 PM, Eric Dumazet edumazet@google.com wrote:

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
> Fixes: 6a2febec338d ("tcp: md5: add missing memory barriers in
> tcp_md5_do_add()/tcp_md5_hash_key()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks !

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
