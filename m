Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4B163DD01
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiK3SUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiK3STa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:19:30 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417188DFF5
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 10:17:10 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id t19-20020a9d7753000000b0066d77a3d474so11740729otl.10
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 10:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GBXzxdXg5bUAJZPgixzV2JSkMT4QNamcZtjJqxGqukE=;
        b=fg7+/lcS2nkQfkY0N86X1M19BkSqKl1vYg7sG7AL8ukRjAlvjhPwur37ZYAsB4bv17
         Vw1BUczBwS8GXipFTUVDtXXlnJyZIWyk6impQU4sSBLBSbzIbP7eL8L4dr16x+XcFz1i
         y37jFI6zl9h4GxP5S3QqejwV/047FoquCuQF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GBXzxdXg5bUAJZPgixzV2JSkMT4QNamcZtjJqxGqukE=;
        b=jrvuietnTnHl6EKN9g9IacOVSXpzlnKEpjBWpsofh3WXnVsDSAMjHroSCEqRtHGWXW
         Zy6XHO61ozphpLbbHI6xPhPpdT//m9s+2YddsuaNU1V85/v1yhIsFdzizL76ffYI2Wi5
         LrYNlLdfra4z/07x+u8AsDWrFGQyUS5LDbKccv7hZaKEGQgA+2VOk+fLo4ZVkcPxhKwI
         yuS4Uso7lORxVVmZl1Hd6pTR7hBE7UoqHI4kDcDqaYdqNVSI4HBiV5XFfeUADEpV5Xj/
         2BoNdRnG+o92AeYUO1uhoTEPbojQmuxmzUn3p/GV+x02XFTeBGV3uqJqodJVQ3poTD/u
         C3ig==
X-Gm-Message-State: ANoB5pnTKPApVvXUyM/uj/2FmXBVz/OiMvgzSeNeG4h6Dt168M5a4IS1
        Q+0m1cetVnFcx/TZ+VaeyNlHT0TYPsxNPdALawuLlQ==
X-Google-Smtp-Source: AA0mqf78m7kFwguAA8Bp87iPgt1Q+8TWBOGjTiq6kFcLR2+AahX4iSmvXhYJv3RbVn883yEJJntmi9xn+DJBaIyA5m8=
X-Received: by 2002:a05:6830:d03:b0:66d:3e45:8e5a with SMTP id
 bu3-20020a0568300d0300b0066d3e458e5amr20987786otb.177.1669832229511; Wed, 30
 Nov 2022 10:17:09 -0800 (PST)
MIME-Version: 1.0
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1> <20221130181325.1012760-15-paulmck@kernel.org>
In-Reply-To: <20221130181325.1012760-15-paulmck@kernel.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Wed, 30 Nov 2022 18:16:58 +0000
Message-ID: <CAEXW_YQci19yD5wr2jyYi4wdNZ_CrZuGJ==jF9MObOzWg7f=_Q@mail.gmail.com>
Subject: Re: [PATCH rcu 15/16] net: Use call_rcu_hurry() for dst_release()
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Could you give your ACK for this patch for this one as well? This is
the other networking one.

The networking testing passed on ChromeOS and it has been in -next for
some time so has gotten testing there. The CONFIG option is default
disabled.

Thanks a lot,

- Joel

On Wed, Nov 30, 2022 at 6:14 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
>
> In a networking test on ChromeOS, kernels built with the new
> CONFIG_RCU_LAZY=y Kconfig option fail a networking test in the teardown
> phase.
>
> This failure may be reproduced as follows: ip netns del <name>
>
> The CONFIG_RCU_LAZY=y Kconfig option was introduced by earlier commits
> in this series for the benefit of certain battery-powered systems.
> This Kconfig option causes call_rcu() to delay its callbacks in order
> to batch them.  This means that a given RCU grace period covers more
> callbacks, thus reducing the number of grace periods, in turn reducing
> the amount of energy consumed, which increases battery lifetime which
> can be a very good thing.  This is not a subtle effect: In some important
> use cases, the battery lifetime is increased by more than 10%.
>
> This CONFIG_RCU_LAZY=y option is available only for CPUs that offload
> callbacks, for example, CPUs mentioned in the rcu_nocbs kernel boot
> parameter passed to kernels built with CONFIG_RCU_NOCB_CPU=y.
>
> Delaying callbacks is normally not a problem because most callbacks do
> nothing but free memory.  If the system is short on memory, a shrinker
> will kick all currently queued lazy callbacks out of their laziness,
> thus freeing their memory in short order.  Similarly, the rcu_barrier()
> function, which blocks until all currently queued callbacks are invoked,
> will also kick lazy callbacks, thus enabling rcu_barrier() to complete
> in a timely manner.
>
> However, there are some cases where laziness is not a good option.
> For example, synchronize_rcu() invokes call_rcu(), and blocks until
> the newly queued callback is invoked.  It would not be a good for
> synchronize_rcu() to block for ten seconds, even on an idle system.
> Therefore, synchronize_rcu() invokes call_rcu_hurry() instead of
> call_rcu().  The arrival of a non-lazy call_rcu_hurry() callback on a
> given CPU kicks any lazy callbacks that might be already queued on that
> CPU.  After all, if there is going to be a grace period, all callbacks
> might as well get full benefit from it.
>
> Yes, this could be done the other way around by creating a
> call_rcu_lazy(), but earlier experience with this approach and
> feedback at the 2022 Linux Plumbers Conference shifted the approach
> to call_rcu() being lazy with call_rcu_hurry() for the few places
> where laziness is inappropriate.
>
> Returning to the test failure, use of ftrace showed that this failure
> cause caused by the aadded delays due to this new lazy behavior of
> call_rcu() in kernels built with CONFIG_RCU_LAZY=y.
>
> Therefore, make dst_release() use call_rcu_hurry() in order to revert
> to the old test-failure-free behavior.
>
> [ paulmck: Apply s/call_rcu_flush/call_rcu_hurry/ feedback from Tejun Heo. ]
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: <netdev@vger.kernel.org>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> ---
>  net/core/dst.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/dst.c b/net/core/dst.c
> index bc9c9be4e0801..a4e738d321ba2 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -174,7 +174,7 @@ void dst_release(struct dst_entry *dst)
>                         net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
>                                              __func__, dst, newrefcnt);
>                 if (!newrefcnt)
> -                       call_rcu(&dst->rcu_head, dst_destroy_rcu);
> +                       call_rcu_hurry(&dst->rcu_head, dst_destroy_rcu);
>         }
>  }
>  EXPORT_SYMBOL(dst_release);
> --
> 2.31.1.189.g2e36527f23
>
