Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196BB6D1813
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjCaHFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCaHFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:05:37 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E813FC66B
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 00:05:05 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id bl9so9356247iob.8
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 00:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680246299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3rNqd0R6uZ87QEvrC+b3tYk7NmTqwJbiMttF/TqyvLo=;
        b=SV73hhUYeNECirBjzFQHECDp8iA2UY+lvxT9oH766LjB5QO6fkZ/SC3sqpjXV8qKXG
         vriqrCo1PUyDcl57uvEbsCgyDr2ia/vCiXFuOiX59d+eFoFQtpJj2RUqnnAPRKhjnYtI
         iJOIWnubdHdrlz2M13wIg8IUJ5Z4rD2Szu8thmho7wVuP64X3HGXV8qUh321Kz7NvRmh
         HYy0p++MG2Xudoivog+M+au5Hri8FY1icZS0hKCra+XtZ2ibFBLnhaI6W7dEJMP/F/xe
         90RD5JiFYvnEn0uSBANz+YkuAFewx0oc5RgXSo81fha3uO3PgttLPNatvTwq19XfT14a
         rkyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680246299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3rNqd0R6uZ87QEvrC+b3tYk7NmTqwJbiMttF/TqyvLo=;
        b=rL39Do3tABDc79X+VhuaMZIaTphk48A+l9/bnT23v+G1eEXHMjeZJA2La0cbpv3Txl
         ph+TFALFzR0JKVVsjX0skHzRCulu/j8LGIJJSJkQJTtiLwLiHiJNTbkva3RpJ65waIA/
         9w+tL0SD6foV1v0rwF97NLWisJ9bMmU6xsIzztWjT5RMdWFil+Lkw7UOTkp4C8OSopHW
         X23w8Q97MxVgbpAbgd7kFzfLLOak9BWIIte20FgkG/amosCUbTryLBxQY6o7P+goiJCw
         KnSauiA+y0QrLXB8UxnygZ82nbF806/JJ9p+FDAwkwM8rizFy+4JnZsOnBSMhPOmJgO4
         2/9Q==
X-Gm-Message-State: AAQBX9cIaDFiqK7Xshn9oJlMHpUlzitOSLvXzLMwZDN95z0i4H2mhlkY
        b6ogrKsL4Me8ybMYf1yOdCQm01kJn4AJ1QCOwc4D/w==
X-Google-Smtp-Source: AKy350bbq1kxngMe2Xqo4557i36QfCmq/VHYYN9GagOVSk70y7aHOb1HKGgUhdkuAfthDEmtErlo2T5h/LCAtGNZzyI=
X-Received: by 2002:a02:a182:0:b0:406:c43f:6320 with SMTP id
 n2-20020a02a182000000b00406c43f6320mr3896110jah.0.1680246299092; Fri, 31 Mar
 2023 00:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <ZCA2mGV_cmq7lIfV@dragonet> <20230330215507.56509-1-kuniyu@amazon.com>
In-Reply-To: <20230330215507.56509-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Mar 2023 09:04:47 +0200
Message-ID: <CANn89iK5D75-SNg28ALi4Zr9JEHnreBpfu_pq0_zLe4jDLT5rw@mail.gmail.com>
Subject: Re: general protection fault in raw_seq_start
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     threeearcat@gmail.com, davem@davemloft.net, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 11:55=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.c=
om> wrote:

> Thanks for reporting the issue.
>
> It seems we need to use RCU variant in raw_get_first().
> I'll post a patch.
>
> ---
> diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> index 3cf68695b40d..fe0d1ad20b35 100644
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -957,7 +957,7 @@ static struct sock *raw_get_first(struct seq_file *se=
q, int bucket)
>         for (state->bucket =3D bucket; state->bucket < RAW_HTABLE_SIZE;
>                         ++state->bucket) {
>                 hlist =3D &h->ht[state->bucket];
> -               sk_nulls_for_each(sk, hnode, hlist) {
> +               sk_nulls_for_each_rcu(sk, hnode, hlist) {
>                         if (sock_net(sk) =3D=3D seq_file_net(seq))
>                                 return sk;
>

No, we do not want this.
You missed that sk_nulls_for_each_rcu() needs a specific protocol
(see Documentation/RCU/rculist_nulls.rst for details)

RCU is needed in the data path, not for this control path.

My patch went too far in the RCU conversion. I did not think about
syzbot harassing /proc files :)

We need raw_seq_start and friends to go back to use the lock.
