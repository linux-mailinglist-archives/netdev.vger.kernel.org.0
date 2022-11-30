Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEEA63E563
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 00:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiK3XZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 18:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiK3XZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 18:25:22 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEFCA9CC2
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 15:17:08 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id a7-20020a056830008700b0066c82848060so12247482oto.4
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 15:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HInS/N+iYT5Xyv/3OtkTBTcUMud6010V70HXD5PLrgQ=;
        b=UoueS2pcPxayLxQFXEIfTPHDfYTQ5o6kSdnvOHBEZNmSr0iPL47pGi3D5VEsq4ZZWK
         NXpkr2RVsUvlg2ueuKu//R0ddEFwoNKwUI8JocQc/BjhTxilDcWD2QOmZbXikPVjP1Gc
         O0TejO0856WRouyOsoV2XWLCP+fzOhZubAwFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HInS/N+iYT5Xyv/3OtkTBTcUMud6010V70HXD5PLrgQ=;
        b=zdoHzS0OIMK/58rZUbyn+A0VakcbDihFVQgIUtP0rfSO9sgBxtXkhGJmekcVfJhMai
         vTlF2YLTbMBpEO43Add28+ZnXSJqsv/cVOPYMWE15waP7M+JCMlFOx2c3sCfQyXLp+GQ
         HQiOH39fuBfCc2Kt0T/HftzNn85/6ulljmZfsGt9YWin6VncnGhk8+OpT+8HQ3/gXm27
         GDRcdzglo7pyZBrpf4BdwUXPtCG5yOgaAiRxrjTxh9tg1s5jJSJW+9Y7ENCyQGa/yf0M
         6k6h+R/tJ3xo6sw1wQi6rq+s6HrL/sXRiVoIS2zfqpMnjbZaVipOtuBajNPdUfhWH6l4
         bKZQ==
X-Gm-Message-State: ANoB5pnfsZbr4WFDcArwDfJfTmcueo3QJyEXp6bfFelYUSiaPyilB8FS
        LWcdLtSeisMXUFxd7DiMqcafAf7lqWibrAplQ+TFDQ==
X-Google-Smtp-Source: AA0mqf4PNohW9IoqD0HMyO5sUTIU8Ax9vPiAxn89y1QKO6rMLaUTbF9NDjCpCqbB3gn4d7O6p1M8/iZkYZUpu08wCRI=
X-Received: by 2002:a05:6830:1f4a:b0:661:b04c:41d9 with SMTP id
 u10-20020a0568301f4a00b00661b04c41d9mr22511809oth.92.1669850168015; Wed, 30
 Nov 2022 15:16:08 -0800 (PST)
MIME-Version: 1.0
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
 <20221130181325.1012760-14-paulmck@kernel.org> <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com>
 <639433.1669835344@warthog.procyon.org.uk> <CAEXW_YSd3dyxHxnU1EuER+xyBGGatONzPovphFX5K9seSbkdkg@mail.gmail.com>
 <658624.1669849522@warthog.procyon.org.uk>
In-Reply-To: <658624.1669849522@warthog.procyon.org.uk>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Wed, 30 Nov 2022 23:15:51 +0000
Message-ID: <CAEXW_YSKdkxYNompUK1orGcAHfqCjWg-twiASdBM9i2Sv=9Kuw@mail.gmail.com>
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of call_rcu()
To:     David Howells <dhowells@redhat.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 11:05 PM David Howells <dhowells@redhat.com> wrote:
>
> Joel Fernandes <joel@joelfernandes.org> wrote:
>
> > > Note that this conflicts with my patch:
> > >
> > >         rxrpc: Don't hold a ref for connection workqueue
> > >         https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=rxrpc-next&id=450b00011290660127c2d76f5c5ed264126eb229
> > >
> > > which should render it unnecessary.  It's a little ahead of yours in the
> > > net-next queue, if that means anything.
> >
> > Could you clarify why it is unnecessary?
>
> Rather than tearing down parts of the connection it only logs a trace line,
> frees the memory and decrements the counter on the namespace.  This it used to
> account that all the pieces of memory allocated in that namespace are gone
> before the namespace is removed to check for leaks.  The RCU cleanup used to
> use some other stuff (such as the peer hash) in the rxrpc_net struct but no
> longer will after the patches I submitted.
>
> > After your patch, you are still doing a wake up in your call_rcu() callback:
> >
> > - ASSERTCMP(refcount_read(&conn->ref), ==, 0);
> > + if (atomic_dec_and_test(&rxnet->nr_conns))
> > +    wake_up_var(&rxnet->nr_conns);
> > +}
> >
> > Are you saying the code can now tolerate delays? What if the RCU
> > callback is invoked after arbitrarily long delays making the sleeping
> > process to wait?
>
> True.  But that now only holds up the destruction of a net namespace and the
> removal of the rxrpc module.
>
> > If you agree, you can convert the call_rcu() to call_rcu_hurry() in
> > your patch itself. Would you be willing to do that? If not, that's
> > totally OK and I can send a patch later once yours is in (after
> > further testing).
>
> I can add it to part 4 (see my rxrpc-ringless-5 branch) if it is necessary.

Ok sounds good, on module removal the rcu_barrier() will flush out
pending callbacks so that should not be an issue.

Based on your message, I think we can drop this patch then. Since Paul
is already dropping it, no other action is needed.

(I just realized my patch was not fixing a test failure, like the
other net ones did, but rather we found the issue by static analysis
-- i.e. programmatically auditing all callbacks in the kernel doing
wake ups).

thanks,
 - Joel
