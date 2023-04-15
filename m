Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299ED6E3453
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 00:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjDOW46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 18:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjDOW44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 18:56:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF412D59
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 15:56:55 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v9so27349990pjk.0
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 15:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1681599414; x=1684191414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubRjxle8AfL59Prm/wkmTmVjb75/p8iBeRuuijtLjNg=;
        b=TZKMN8poAHP4YwAqnU9eEVSOlb5ek8a5pOp6pAenCZDEHOJssxaf+A4++1IIYw7MpM
         7aq9yaEQTpQNruGixDOeSiEIZuumGKqQqq61OfoKbml+6JwtYe2rw4/T/V8o5iEBSi51
         OSOWCMJ+FlQaNG/1ktYx6rTm4HSd8b8EpSnbipfzd+GjNGowid2Q/djKv2jOWWHaHmEP
         hSiqOIeyIH6QSf2ALrjHP/WGwHSsfWJFwgnpnRFGR3vBzTBTPXI+33kdhOkhQoB8hegE
         UeeIqG5sqAzmDiUPg8p1YaOLplu+Tnxv7+bB8KIo23tQvL0qQzEtGCfEbteC9xiY3pS+
         pioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681599414; x=1684191414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubRjxle8AfL59Prm/wkmTmVjb75/p8iBeRuuijtLjNg=;
        b=GRV7E3wSYQr+4BbfFXnjIjmji0Pd895ufvWdm5tDktGor5Y8us+nFh8EzpDEW9gY9s
         z6NmTWksS18pbvqUdgatLyhpQ8O4BvSHYryOxsAmKJovoLiyOyvziCmizZmcbWGAePL+
         31Pa6hOPKbq4ChZiOYpRBHEuIl+8noGQOgcoIuL7nbPyT1lsPAG80rrDEWDEIVlr+HV+
         /tZoyfK4yU78xTPrD0hq0b3bzuI1fTNybVGFUiiVqGWKpysNRm78T1xDw+pRGAyCbivM
         mNb0C6hNwZlKzkddIz/V6ILMr4KHx/UIiCbKuBjgd3U1lBqt7VKlTrgo7ygqOJ80Oegm
         wEmw==
X-Gm-Message-State: AAQBX9eU2KuP7VvrN4hQVdSypBB8AFkpmQHPTbVbyTmsh/EXKY4lm/rP
        6ngP4WdBic5JKmpOA0RRnGRfAA==
X-Google-Smtp-Source: AKy350bsEaGCTirqACeAVtm48St3ie5XE0fYZj2D3HWUz1dZxDWvNItGbUZOV8DjHKhZt7C3oJG6Eg==
X-Received: by 2002:a05:6a20:78a8:b0:e9:5b0a:deff with SMTP id d40-20020a056a2078a800b000e95b0adeffmr9990865pzg.22.1681599414582;
        Sat, 15 Apr 2023 15:56:54 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id e25-20020a635019000000b00502e6bfedc0sm4647359pgb.0.2023.04.15.15.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 15:56:54 -0700 (PDT)
Date:   Sat, 15 Apr 2023 15:56:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     david.keisarschm@mail.huji.ac.il
Cc:     linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Joel Fernandes <joel@joelfernandes.org>, Jason@zx2c4.com,
        keescook@chromium.org, ilay.bahat1@gmail.com, aksecurity@gmail.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v5 3/3] Replace invocation of weak PRNG
Message-ID: <20230415155651.18ce590f@hermes.local>
In-Reply-To: <20230415173756.5520-1-david.keisarschm@mail.huji.ac.il>
References: <20230415173756.5520-1-david.keisarschm@mail.huji.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Apr 2023 20:37:53 +0300
david.keisarschm@mail.huji.ac.il wrote:

> diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
> index 7594e4df8..223d635e8 100644
> --- a/include/uapi/linux/netfilter/xt_dscp.h
> +++ b/include/uapi/linux/netfilter/xt_dscp.h
> @@ -1,32 +1,27 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/* x_tables module for matching the IPv4/IPv6 DSCP field
> +/* x_tables module for setting the IPv4/IPv6 DSCP field
>   *
>   * (C) 2002 Harald Welte <laforge@gnumonks.org>
> + * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
>   * This software is distributed under GNU GPL v2, 1991
>   *
>   * See RFC2474 for a description of the DSCP field within the IP Header.
>   *
> - * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
> + * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
>  */

This part of the change is a mess.
Why are you adding ipt_FTOS.c here?
Why are you updating ancient header line from 2002?

