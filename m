Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FBA63F880
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 20:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiLATmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 14:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiLATme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 14:42:34 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC995C2A
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 11:42:32 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id y83so3376378yby.12
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 11:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Yplj9OLHQy4Fa2CQM/nOqHM1WaB6p1zFWZx1JaQhTQo=;
        b=SA6c7+IIWqr5LsKyPZpe9GGKg4sD+nU2eRDx6kwQIJUWrfWo5oW0OEz7ycNQlMke2b
         TX7URQr8zXzDfdIJKVcRfb85gWAZQ3GlKmdH4kQJIgMQYbGmprgTpRqxB+CLpwuutD1+
         Sk1IvlsEqIrsv80FzLMvMZBr7kDoPoex4Gtlk+Jhfe8u9tGT8lFO+Mnd1GE5A/ydUBo5
         UK2GLpAW/ldwh6fbju7vQGb5Lzp+lKdJL2egoHTatKX/ebiPdcU6JzyorxgeukxKjO2B
         SNunrrlEY+fAdYdRHSxIKxzyRH7hp1lWH0OeVoOCWSbC6hquPSuGMEw/WuVvxguQypw1
         1E6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yplj9OLHQy4Fa2CQM/nOqHM1WaB6p1zFWZx1JaQhTQo=;
        b=UDdMNaLLlN1oQureRI7XMjYa9uUPQ/2GfIL+4Y2u9bjHIhJEniKh8nFm3k9Sfr0xKY
         4eYHb+dOVJW8jr1/s1GEC9oR+Zk6Dz4L5mzNXHkfx37S/ZFaZThlJe1ZNNsD3LgxRmYj
         LTUdU/HssamarW8+ml2TAFE6hHydlEL30J+8BdrpLgCYd1Y/4kLwL1qkthb3hANNqC9I
         AWO5yoqdA+sM1Sxkevdro8ISoSr/j1gd0OJLdFE6biHPQ77I6EFSwvwpk2tKeEgx40Hm
         FIs009d+xwWnltRlKA7cGpOzAQtF9bwujTTJesFpE6HvwuMKWSMfHfnfOCqE2NYFIIwe
         vmLw==
X-Gm-Message-State: ANoB5pkHWRzxwL8ibjbJG5S+D4lXpv7ObA69IR5zTALfL7hbiirPDwND
        cbf8V2Fo6S7Uog3e73RKAiYmW8DIAT8juI1E+ORLGQ==
X-Google-Smtp-Source: AA0mqf4oqDz0yD4QmilED4SYANZdrhwqb1ofUwjwIJdlCo4OGUEcvd6n7jWNDTE9LsFpfLocco5g41uGtb5wCjpZs6E=
X-Received: by 2002:a25:d88:0:b0:6f0:9db5:63e7 with SMTP id
 130-20020a250d88000000b006f09db563e7mr36519727ybn.387.1669923751805; Thu, 01
 Dec 2022 11:42:31 -0800 (PST)
MIME-Version: 1.0
References: <20221123173859.473629-1-dima@arista.com> <20221123173859.473629-5-dima@arista.com>
In-Reply-To: <20221123173859.473629-5-dima@arista.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Dec 2022 20:42:19 +0100
Message-ID: <CANn89iJv3JP0roZdcHuTr4HS=O_wv8s91PYM3TeCsOZVzqK8KA@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] net/tcp: Do cleanup on tcp_md5_key_copy() failure
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 6:39 PM Dmitry Safonov <dima@arista.com> wrote:
>
> If the kernel was short on (atomic) memory and failed to allocate it -
> don't proceed to creation of request socket. Otherwise the socket would
> be unsigned and userspace likely doesn't expect that the TCP is not
> MD5-signed anymore.
>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Eric Dumazet <edumazet@google.com>
