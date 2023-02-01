Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CF26864E5
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 12:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjBALBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 06:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBALB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 06:01:28 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD8249021
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 03:01:24 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id p26so39030046ejx.13
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 03:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DkRIv/QAxxum41z2Wild0v5lK+azmjI3SmMGNQ2shaE=;
        b=y5tkf2zyzHVYFHjAVwOhH3lBY7KL/izCgu3sFbtAn/5ava++TxzHsVzeK5dIGI7BaD
         QtKuFIUdWpAi6RVfBbf/X9BmHbJxTtUsf3RbeuKFf/xlPa0jbAKg7HTOUGNnIwNNaRb0
         uUDzofu73EwLvzFfdpLLnxRquLe+/SX4J0+XQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DkRIv/QAxxum41z2Wild0v5lK+azmjI3SmMGNQ2shaE=;
        b=1UkKeI/AhdiLf5+T2Y55t46s8K19/Hyp9K8CY/WsDDapf2B5ivr3fsBIo5IL3QNUWL
         fX7s/ACU/daYisLc+W0ez1w3k9yU66ivRZ9N90apJ47REDrolknwMmpw21Q2vU7xInnC
         zlu8aPUMH8/ixpSwPXJmgmzuW+ZftQkdmWbqN0P5X7zisrqsqlEcfzOJaMQLthv1n9SQ
         NPP6XJJaXmeMin3hnCXacicpw+N2yKNncdk6MDriYfbpRg+Qm1olHrCT7DN1R7fNnB//
         XU7IO92DdtzKJfCv82z4A9moIoFAgQBGAXsW7bNkucfUs4OKTwQHfJ0z9woCe1H+rVz/
         cZdg==
X-Gm-Message-State: AO0yUKVNxpRJuUUZPbFXm9V3fv+lPVjPcwCLN2xyQKjzgiUt7BnTmoFw
        uPGBrF0FaKGnGWHHGKNfZ4BurubbYs5iCHiiTF5W3Q==
X-Google-Smtp-Source: AK7set8PtqanzwwYI1yyKrOIZchiZ+JGyocBPkHUh8tfC2Rs38UyldSn1YHnl9RGLbmFS8Uobtx2/P7Vfav6edr89ig=
X-Received: by 2002:a17:906:f203:b0:88d:33fe:3302 with SMTP id
 gt3-20020a170906f20300b0088d33fe3302mr520031ejb.203.1675249283513; Wed, 01
 Feb 2023 03:01:23 -0800 (PST)
MIME-Version: 1.0
References: <20230131-tuntap-sk-uid-v1-0-af4f9f40979d@diag.uniroma1.it>
 <20230131-tuntap-sk-uid-v1-1-af4f9f40979d@diag.uniroma1.it> <20230131191055.45bb4ab7@hermes.local>
In-Reply-To: <20230131191055.45bb4ab7@hermes.local>
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Wed, 1 Feb 2023 12:01:12 +0100
Message-ID: <CAEih1qWd_C=v5zrivZK3thbUaftX7N1qdiU7AkryvEotiGPZYw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] tun: tun_chr_open(): correctly initialize
 socket uid
To:     stephen@networkplumber.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Feb 2023 at 04:10, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Wed, 01 Feb 2023 00:35:45 +0000
> Pietro Borrello <borrello@diag.uniroma1.it> wrote:
>
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index a7d17c680f4a..6713fffb1488 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -3450,6 +3450,11 @@ static int tun_chr_open(struct inode *inode, struct file * file)
> >
> >       sock_init_data(&tfile->socket, &tfile->sk);
> >
> > +     // sock_init_data initializes sk.sk_uid assuming tfile->socket is embedded
> > +     // in a struct socket_alloc and reading its corresponding inode. Since we
> > +     // pass a socket contained in a struct tun_file we have to fix this manually
> > +     tfile->sk.sk_uid = inode->i_uid;
> > +
>
> Do not use C++ style comments in the kernel.

Thanks for pointing it out. I will fix this in v2.

> Rule #1 of code maintenance. Bug fixes should not stand out.

Thanks for the comment. I agree bug fixes should not stand out.
I sent the patches also to sparkle some discussion on how this should be
better fixed.
As briefly mentioned in the cover letter, I am not sure what is the
cleanest fix according
to Linux standards.
Are you suggesting a briefer comment or removing it completely?

The alternative fixes I see, would be:
1) pass a NULL socket and manually initialize it, which I think would
make the fix
to stand out more, but it would be probably cleaner
2) change the API of sock_init_data, but probably not worth it, given
tuntap devices
are the only 2 users among almost 60 to break the socket_alloc assumption
3) introduce a sock_init_data_with_inode which explicitly uses an
inode to initialize
uid, but would be a bad solution for code duplication
4) wrap sock_init_data call to fix uid in a similar fashion as done
here, maybe cleaner

Best regards,
Pietro
