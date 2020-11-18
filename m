Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF672B8878
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgKRXjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:39:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgKRXjd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 18:39:33 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F33AD246BB;
        Wed, 18 Nov 2020 23:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605742772;
        bh=a+kt9IopjboXHFsUhtGXzcDMMw8eVRylqBoztLZF+58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Twnhn99mCWR/0i67/eFOt8s0B63RiadpcF1ACIt20l7LyuoknbSvFy3GLw+5F8Nbi
         T+9M6ZRwVTWrS3liVoQC9SUX2CgZgt383KhHmYumAT4jCJ+kHy+cBcqaTz8z4CSsxk
         v2N1Vdjmy5hk1sAGmd4JIwQwqUrzUW6yaGHiT0u4=
Date:   Wed, 18 Nov 2020 15:39:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net] net/tls: missing received data after fast remote close
Message-ID: <20201118153931.43898a9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <3c3f9b9d-0fef-fb62-25f8-c9f17ec43a69@novek.ru>
References: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
        <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <71f25f4d-a92c-8c56-da34-9d6f7f808c18@novek.ru>
        <20201117175344.2a29859a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <33ede124-583b-4bdd-621b-638bbca1a6c8@novek.ru>
        <20201118082336.6513c6c0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3c3f9b9d-0fef-fb62-25f8-c9f17ec43a69@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 20:51:30 +0000 Vadim Fedorenko wrote:
> >> The async nature of parser is OK for classic HTTPS server/client case
> >> because it's very good to have parsed record before actual call to recvmsg
> >> or splice_read is done. The code inside the loop in tls_wait_data is slow
> >> path - maybe just move the check and the __unpause in this slow path?  
> > Yeah, looking closer this problem can arise after we start as well :/
> >
> > How about we move the __unparse code into the loop tho? Seems like this
> > could help with latency. Right now AFAICT we get a TCP socket ready
> > notification, which wakes the waiter for no good reason and makes
> > strparser queue its work, the work then will call tls_queue() ->
> > data_ready waking the waiting thread second time this time with the
> > record actually parsed.
> >
> > Did I get that right? Should the waiter not cancel the work on the
> > first wake up and just kick of the parsing itself?  
> I was thinking of the same solution too, but simple check of emptyness of
> socket's receive queue is not working in case when we have partial record
> in queue - __unpause will return without changing ctx->skb and still having
> positive value in socket queue and we will have blocked loop until new data
> is received or strp_abort_strp is fired because of timeout. If you could
> suggest proper condition to break the loop it would be great.
> 
> Or probably I misunderstood what loop did you mean exactly?

Damn, you may be seeing some problem I'm missing again ;) Running
__unparse can be opportunistic, if it doesn't parse anything that's
fine. I was thinking:

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 95ab5545a931..6478bd968506 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1295,6 +1295,10 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
                        return NULL;
                }
 
+               __strp_unpause(&ctx->strp);
+               if (ctx->recv_pkt)
+                       return ctx->recv_pkt;
+
                if (sk->sk_shutdown & RCV_SHUTDOWN)
                        return NULL;
 
Optionally it would be nice if unparse cancelled the work if it managed
to parse the record out.
