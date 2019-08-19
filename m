Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D2F924D4
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 15:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfHSNXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 09:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbfHSNXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 09:23:33 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96A1E1089045;
        Mon, 19 Aug 2019 13:23:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38017871E7;
        Mon, 19 Aug 2019 13:23:32 +0000 (UTC)
Message-ID: <b6741af18dace7eac9e2b6985de6bf6e33a6b852.camel@redhat.com>
Subject: Re: [PATCH net-next 1/3] net/tls: use RCU protection on
 icsk->icsk_ulp_data
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Watson <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
In-Reply-To: <20190815143216.45f6da44@cakuba.netronome.com>
References: <cover.1565882584.git.dcaratti@redhat.com>
         <b7c351a5ad6c756129d036fd87db6b4edcd3cb6a.1565882584.git.dcaratti@redhat.com>
         <20190815143216.45f6da44@cakuba.netronome.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 19 Aug 2019 15:23:31 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Mon, 19 Aug 2019 13:23:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-15 at 14:32 -0700, Jakub Kicinski wrote:
> On Thu, 15 Aug 2019 18:00:42 +0200, Davide Caratti wrote:
> > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > 
> > We need to make sure context does not get freed while diag
> > code is interrogating it. Free struct tls_context with
> > kfree_rcu().
> > 
> > We add the __rcu annotation directly in icsk, and cast it
> > away in the datapath accessor. Presumably all ULPs will
> > do a similar thing.
> > 
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

hello Jakub,

> > @@ -251,14 +251,31 @@ static void tls_write_space(struct sock *sk)
> >  	ctx->sk_write_space(sk);
> >  }
> >  
> > -void tls_ctx_free(struct tls_context *ctx)
> > +/**
> > + * tls_ctx_free() - free TLS ULP context
> > + * @sk:  socket to with @ctx is attached
> > + * @ctx: TLS context structure
> > + *
> > + * Free TLS context. If @sk is %NULL caller guarantees that the socket
> > + * to which @ctx was attached has no outstanding references.
> > + */
> > +void tls_ctx_free(struct sock *sk, struct tls_context *ctx)
> >  {
> > +	struct inet_connection_sock *icsk;
> > +
> >  	if (!ctx)
> >  		return;
> >  
> >  	memzero_explicit(&ctx->crypto_send, sizeof(ctx->crypto_send));
> >  	memzero_explicit(&ctx->crypto_recv, sizeof(ctx->crypto_recv));
> > -	kfree(ctx);
> > +
> > +	if (sk) {
> > +		icsk = inet_csk(sk);
> > +		rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
> 
> Now that we kind of want to set the icsk_ulp_data to NULL under the
> callback_lock I think we should let the callers do it.

Ok, I will fix this in series v2.

> > 
> > @@ -649,8 +666,8 @@ static void tls_hw_sk_destruct(struct sock *sk)
> >  
> >  	ctx->sk_destruct(sk);
> >  	/* Free ctx */
> > -	tls_ctx_free(ctx);
> > -	icsk->icsk_ulp_data = NULL;
> > +	tls_ctx_free(sk, ctx);
> > +	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
> 
> Let's reorder the assignment before the free.

Ok, I will fix this in series v2.

thanks!
-- 
davide


