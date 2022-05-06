Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E707851D187
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 08:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242827AbiEFGm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 02:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbiEFGm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 02:42:57 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7A6C66221
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 23:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651819154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xb5hsCR6vYhEn6zB3BaM7s+6s3NgLuWsFQFQ8PP7p2o=;
        b=dxunkiyNi5YBtnYne6r2s9X3VJTLdMfBxqNU4lLH4Ogd7PXI4psEjDCPeG8h12xUO5x8OC
        OqWYum8jWqxvlr721J3zOFAtvL6zwsMoBulIhfi+a1x2ChiZjgWF9Spy7lr0FwdVdi9WSV
        lqXRRQ2oOUEMdPtfMBfYNRW8DABOrgs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-MMEcz8QbMauv4T_PH7qIZA-1; Fri, 06 May 2022 02:39:11 -0400
X-MC-Unique: MMEcz8QbMauv4T_PH7qIZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18123833961;
        Fri,  6 May 2022 06:39:11 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46E1E2166B2D;
        Fri,  6 May 2022 06:39:09 +0000 (UTC)
Received: by samus.usersys.redhat.com (Postfix, from userid 1000)
        id 30EE960A; Fri,  6 May 2022 08:39:08 +0200 (CEST)
Date:   Fri, 6 May 2022 08:39:08 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] net: make tcp keepalive timer upper bound
Message-ID: <YnTCjFE2+/JEgglV@samus.usersys.redhat.com>
Mail-Followup-To: Josh Poimboeuf <jpoimboe@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <87zgkwjtq2.ffs@tglx>
 <20220505131811.3744503-1-asavkov@redhat.com>
 <20220505131811.3744503-3-asavkov@redhat.com>
 <20220505175654.jhu3zldboxdcjifr@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220505175654.jhu3zldboxdcjifr@treble>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 10:56:54AM -0700, Josh Poimboeuf wrote:
> On Thu, May 05, 2022 at 03:18:11PM +0200, Artem Savkov wrote:
> > Make sure TCP keepalive timer does not expire late. Switching to upper
> > bound timers means it can fire off early but in case of keepalive
> > tcp_keepalive_timer() handler checks elapsed time and resets the timer
> > if it was triggered early. This results in timer "cascading" to a
> > higher precision and being just a couple of milliseconds off it's
> > original mark.
> > This adds minimal overhead as keepalive timers are never re-armed and
> > are usually quite long.
> > 
> > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > ---
> >  net/ipv4/inet_connection_sock.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index 1e5b53c2bb26..bb2dbfb6f5b5 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -589,7 +589,7 @@ EXPORT_SYMBOL(inet_csk_delete_keepalive_timer);
> >  
> >  void inet_csk_reset_keepalive_timer(struct sock *sk, unsigned long len)
> >  {
> > -	sk_reset_timer(sk, &sk->sk_timer, jiffies + len);
> > +	sk_reset_timer(sk, &sk->sk_timer, jiffies + upper_bound_timeout(len));
> >  }
> >  EXPORT_SYMBOL(inet_csk_reset_keepalive_timer);
> 
> As I mentioned before, there might be two sides to the same coin,
> depending on whether the keepalive is detecting vs preventing the
> disconnect.  So this might possibly fix one case, while breaking
> another.

But cascading is still there in the handler so it will fire off quite
close to original timer in any case.


-- 
 Artem

