Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667F76905C3
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjBIKzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjBIKzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:55:43 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A606F45F71
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 02:55:42 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id f47-20020a05600c492f00b003dc584a7b7eso3560261wmp.3
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 02:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SbYZuDPafCTRwfe1xrDi5/45JkFxbRdK8vjJ+ibDgNs=;
        b=NwbfzFl0r81VXWFYUA93hw+6lGVWt7VKO/Ttw21R9+6nFbI/gr8y1SPinYeL2uCG7O
         LJpk+Sbs6G0+s/u9Vv9sKeQJkGtxz6dVGbqTRZbT+WTw+IVyW4vcPUL44ophTp5vTpdS
         4QD1N0wLhoVh5KtyYtV9F9mk4daK5If0a6NGxPgfUoK4EymVarrfRA+02zjcLTbqFu4p
         3wxNwZGUl5kzBFbGW4OCzCJh1y+hEmNzOXpiqoD5rmLRc0wLdXF8GvljAI//FSTBsXNE
         9dfvOhymkfYERbBRmhbvbYJMKPN4bLM43nitfNfWRzDSxZC9ehONHdSqkcrSizq5Op2u
         GJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SbYZuDPafCTRwfe1xrDi5/45JkFxbRdK8vjJ+ibDgNs=;
        b=fSeH6pP2uwW0JhLhOIkNof8FKIQcuOK894ycda5cm952Q0J0FOv22hXwXhrBkE3EJJ
         B6LPkhgPusYPvsznyL2/Xpi1LYFCi3GpQqrUh1GAtn961d8gIs+KmGODOqdMPNlow83n
         enQ+kyxHK1NmqFBUUPztE6/W+JKa2VfWybhSIlf0iJtYqLBf/IUjD6mCcyZPgzZw0PWc
         q0VOrb22RIvK4t2wu9PwdNiaQOgHlSDzgfEsfP9TQO2B08K/YDnAJlUWAEcZrxwSFgrf
         /EjoHjhfnWsOhsPWErNH4TxqPZHzE11L2wkeAuSNr3o1+NSU2RYyMQiB2koEje+eqhTK
         tsHQ==
X-Gm-Message-State: AO0yUKXppIq60HVFJ7DwNwmcIVcIjao1vWNZ2OSkwLgJfGEV1qfKAXob
        stky+4UGdZ6h9lIWs0ik3wzDQ2mGh9uNEViGOsHn4Ri8OXLp8rvJ
X-Google-Smtp-Source: AK7set9QyJF2j/o4uVguAaspDKp50s5xxWht5JH++ImiZB+PD6OriOewnlqmb/IeGDw3W0Y3GTrO3PC6JYTeLSMGwVM=
X-Received: by 2002:a05:600c:3588:b0:3df:efdc:64fe with SMTP id
 p8-20020a05600c358800b003dfefdc64femr496232wmq.54.1675940141122; Thu, 09 Feb
 2023 02:55:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675875519.git.gnault@redhat.com> <b827a871f8dbc204f08e7f741242ba7f7d5cb8ab.1675875519.git.gnault@redhat.com>
In-Reply-To: <b827a871f8dbc204f08e7f741242ba7f7d5cb8ab.1675875519.git.gnault@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Feb 2023 11:55:29 +0100
Message-ID: <CANn89i+VRk1aH2Ajmu1prrj6Rxtswm=MxPP2Y4XriDU_Z24=Eg@mail.gmail.com>
Subject: Re: [PATCH net 1/3] ipv6: Fix datagram socket connection with DSCP.
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
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

On Wed, Feb 8, 2023 at 6:14 PM Guillaume Nault <gnault@redhat.com> wrote:
>
> Take into account the IPV6_TCLASS socket option (DSCP) in
> ip6_datagram_flow_key_init(). Otherwise fib6_rule_match() can't
> properly match the DSCP value, resulting in invalid route lookup.
>

>
> Fixes: 2cc67cc731d9 ("[IPV6] ROUTE: Routing by Traffic Class.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
