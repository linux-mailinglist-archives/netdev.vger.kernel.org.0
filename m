Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC96B77AF
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCMMkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCMMkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:40:07 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A0C5A1A8
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 05:39:55 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id v196so4269140ybe.9
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 05:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678711195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9io6j0j3yCA+FRlzkjNhxmUVgJVwDq0QTFewVP3dUI4=;
        b=bmeaSsZQa4l13aSdIsJ4YjhovEocbHMvZuocHaS8oYnye68uvqu6jpKAta8A6OrUVE
         ky8zJoTmlrMadp2pZQZCJQijCA0vOC3C8eXppOP2PTk90l6s7PfqaLDBWXQtV5XHJoR+
         PF4se1n+Ui72Bo1JNeFR0pxzInyfRkvl2dNrXw3c0blUGCaaRqt1nD9G13W5jdOkOyl8
         fyY5Sms9CUl88yYG55jSYej0cKBFE02Yt3Qt8JpgbvYcA++UwVd9eskVeXbbNI7GwGbZ
         9BWINMWm9Apf1LnW8bLPMIiVzC4OyBQ8+/BK2Ryf1BQA6CJwAEb1O5suSCqTKsz/6FGO
         mcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678711195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9io6j0j3yCA+FRlzkjNhxmUVgJVwDq0QTFewVP3dUI4=;
        b=TBXpmYKCUyUi3QT23WwxR1ISNwcNVMmxFWH8mxD1rsuWjY6QuYRJXT7/Ekh4iknvGI
         sS18qZXLFtlutadqIwLwMJWhHLH1w5oWw/GjdlxRPDSHT3OrzAW8MuWNpdGAF8abbqNN
         IEaAGI4Ady08pv+RPp1i1hDB+Z8GTl7o3kmE+H/ZkbpMRtdZBHyZi/4e6aFodZmSmKr1
         f3D18Ql2eC2IXvu6Y7sXCgdHal5y30uPj0EbnRM08iwdA8HZIldANn5A6FIH6/paNwoB
         vI3OtYnXtnvhHS/DeRlMeD0tviq+19zFs6fYmalb6XCx4Jp9vtMXA6Srlkujcc8wOwER
         wAWg==
X-Gm-Message-State: AO0yUKWPgxX49NV8kP75FKSqkj2lu3liZYiRqtv015Mp0UmpacHK8ueu
        uCk7mEyzcmxcvQHfK7rJbwuDs0MAa11SzZcvr9cgKg==
X-Google-Smtp-Source: AK7set8OCMGlyU9xXi9IiCwy3LhEPCMcXONmA24Rqqnp05GXJOvNpXhny9tk8HcMZd4LTaVymHdS/8vyKI6PNa3/rho=
X-Received: by 2002:a5b:4ca:0:b0:aaf:b6ca:9a30 with SMTP id
 u10-20020a5b04ca000000b00aafb6ca9a30mr20983997ybp.6.1678711194790; Mon, 13
 Mar 2023 05:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230312031904.4674-1-kuniyu@amazon.com> <20230312031904.4674-2-kuniyu@amazon.com>
In-Reply-To: <20230312031904.4674-2-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Mar 2023 05:39:43 -0700
Message-ID: <CANn89i+GSbOspXJJE=sL-zNqb2CcA=1=uFuJrPQFifX_dsUvDQ@mail.gmail.com>
Subject: Re: [PATCH v1 net 1/2] tcp: Fix bind() conflict check for dual-stack
 wildcard address.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Paul Holzinger <pholzing@redhat.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Sat, Mar 11, 2023 at 7:20=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> Paul Holzinger reported [0] that commit 5456262d2baa ("net: Fix
> incorrect address comparison when searching for a bind2 bucket")
> introduced a bind() regression.  Paul also gave a nice repro that
> calls two types of bind() on the same port, both of which now
> succeed, but the second call should fail:
>
>   bind(fd1, ::, port) + bind(fd2, 127.0.0.1, port)
>
> The cited commit added address family tests in three functions to
> fix the uninit-value KMSAN report. [1]  However, the test added to
> inet_bind2_bucket_match_addr_any() removed a necessary conflict
> check; the dual-stack wildcard address no longer conflicts with
> an IPv4 non-wildcard address.
>
> If tb->family is AF_INET6 and sk->sk_family is AF_INET in
> inet_bind2_bucket_match_addr_any(), we still need to check
> if tb has the dual-stack wildcard address.
>
> Note that the IPv4 wildcard address does not conflict with
> IPv6 non-wildcard addresses.
>
> [0]: https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@=
redhat.com/
> [1]: https://lore.kernel.org/netdev/CAG_fn=3DUd3zSW7AZWXc+asfMhZVL5ETnvuY=
44Pmyv4NPv-ijN-A@mail.gmail.com/
>
> Fixes: 5456262d2baa ("net: Fix incorrect address comparison when searchin=
g for a bind2 bucket")
> Reported-by: Paul Holzinger <pholzing@redhat.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
>

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
