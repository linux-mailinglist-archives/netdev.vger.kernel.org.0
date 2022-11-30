Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A9563E39D
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiK3WsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiK3Wr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:47:59 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA861A23F
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:47:58 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id o13so148999ejm.1
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QZD29PB1DDnmxaZlq47fhYeHRcAqoUfi3bc/ZNgB9gU=;
        b=omJRN5aYV43lsSLL/yIGbBrYHdeY5lcQwNAbaYZOIuJbZ1auvK/sIXPiVt/1MzRpUR
         X89Jvizn78r4Q0w0g2NpVVxk7uaR40j8uv6ukZFpiwji9kVcArT0yeAhGP1MpyI3j+Vc
         07Uy/Qr7sKaft4E+L+OHOB2/t5OvAyLwaBmKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QZD29PB1DDnmxaZlq47fhYeHRcAqoUfi3bc/ZNgB9gU=;
        b=Ro2ckBQ1Y/ngfikqLerG2J1mFfBCtgqa+nh1pg0F6/96lrPZ7pfejZzZWkulcG6oNs
         EuSPHllV3SLKz4rvJmpQ9fHzYnuzsgC1vg+BBFvcsOjyyeSBrcXlyFmGaSdsqv15liox
         XlZ0VUPE6c7ugUbLMZmB0Xr31gf+8t3KEdhufVk15c06CGhlyUA6lc25o4oqEJ5w8J30
         pT4dTMRk1Q+0iDCKWf7rSW8XiK4gZhuiDc8xWg5zZBT2iBSmojZ5A8CXNGP87YPLSvrM
         GPriZNxhyJf0uGxUjsELpyQyru+z2txki4ySwDeHMf69Izo4rO8N5CQbEfMrBMsDdG0q
         dY4A==
X-Gm-Message-State: ANoB5pnCyMCKE+ex9hqbA/peEh6WAg90ATYAyU3L06XX4nVJjkG3Shfy
        75P4xT0VjOXtjABwfWJrfvz+WcSE7/qa+KoisBg9TQ==
X-Google-Smtp-Source: AA0mqf6BCXA5CM22fNyGWD/c96fXFEueNSkrFbKgiBvP38k8xPpVPlHBEhq1P0g+KzDS2ef5OtP6Q7GFGQgfT5K4plg=
X-Received: by 2002:a17:906:fcd0:b0:7ad:b8c0:3057 with SMTP id
 qx16-20020a170906fcd000b007adb8c03057mr54317182ejb.440.1669848476743; Wed, 30
 Nov 2022 14:47:56 -0800 (PST)
MIME-Version: 1.0
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
 <20221130181325.1012760-14-paulmck@kernel.org> <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com>
 <639433.1669835344@warthog.procyon.org.uk>
In-Reply-To: <639433.1669835344@warthog.procyon.org.uk>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Wed, 30 Nov 2022 22:47:41 +0000
Message-ID: <CAEXW_YSd3dyxHxnU1EuER+xyBGGatONzPovphFX5K9seSbkdkg@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, Nov 30, 2022 at 7:09 PM David Howells <dhowells@redhat.com> wrote:
>
> Note that this conflicts with my patch:
>
>         rxrpc: Don't hold a ref for connection workqueue
>         https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=rxrpc-next&id=450b00011290660127c2d76f5c5ed264126eb229
>
> which should render it unnecessary.  It's a little ahead of yours in the
> net-next queue, if that means anything.

Could you clarify why it is unnecessary?

After your patch, you are still doing a wake up in your call_rcu() callback:

- ASSERTCMP(refcount_read(&conn->ref), ==, 0);
+ if (atomic_dec_and_test(&rxnet->nr_conns))
+    wake_up_var(&rxnet->nr_conns);
+}

Are you saying the code can now tolerate delays? What if the RCU
callback is invoked after arbitrarily long delays making the sleeping
process to wait?

If you agree, you can convert the call_rcu() to call_rcu_hurry() in
your patch itself. Would you be willing to do that? If not, that's
totally OK and I can send a patch later once yours is in (after
further testing).

Thanks,

 - Joel
