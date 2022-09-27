Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05295EC99C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 18:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiI0Qft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 12:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiI0Qfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 12:35:38 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A43ED33EB
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:35:37 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x18so15833741wrm.7
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 09:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=4UXsHyJgnSTgjR93XD83/w/5RLI1fKHdJHJp4rDBZBY=;
        b=LdlgbYTFB/zwzrnkWgDR0czAiUqHTcwejey3Xb1Bs+bOINiukuhc++/WuVXnhH0KLZ
         UzpQerYyZ3iuBZbYvPZXKL0C6ziDEqlkK9Rp+OXJ9+Z6URR5M7toPv9K6FPy+sGG39vI
         VIeIeMDSQUAlWSY4Pdo0/jah8DjCXOrzkIbFbogtF4+aBQit9gb4lPP8mXpDRTpbxO4Q
         N0IY1SbNo3MpmAfh36zWLn0U1cKWet/DpXAkRkR0VEYe4pgbJC4nhnkZOucHliBnloVU
         5CBtVzq4q9tGD5sGtd0f/mJYnXx/UW2xGLUZkTdzDFaxPGnyYZZWkGmnmAuY1mfEjXaz
         YIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=4UXsHyJgnSTgjR93XD83/w/5RLI1fKHdJHJp4rDBZBY=;
        b=gHOEzvaN51PQoOU+6oBX4UdE7inIKotQZ84ClVc8hi3kGcGyIiMNGpCKAPp03V7+zk
         UWQWFdnrbThFKe4wZ+A5YKaoWHWuH6xt7JmH9Lw3makiM/6hBnKDK1l75LWKtQi1NGaZ
         tFvEbhG2Nsi80/aDiD63cyy2ai9Wpo63CoB0GKy8NhwmUF1kD2yDLzWn8wKtWSDp6yZu
         rIFUfD1gUKPfVlSUhjNKCJtBiNjmcaR6k0MbO37YJfdbE+HXJv3gUdH+fmESnmMhs5+c
         h8YU2+NTQ9UPNQVxSMQZ3oKeGTA8v5VCLIq4HGO68jVjpkqWVW73dQ1O2g5yCpk8E50c
         kFjA==
X-Gm-Message-State: ACrzQf2NyRSGYJTvYc5GB8uruovh/QpGPRYmQNWsQ5HjawSlpsKFE+DN
        p2J0uq8utdghSrVZI4yLqrkYkpWGbampgGcVvO7V8A==
X-Google-Smtp-Source: AMsMyM5ddAOUgTzr73et0BXizv7TPXD9kskrwpiWPHigU4p3c6oHem7L/AtYysQjqSp3FNex6urXnFgdiwrEwaIbW18=
X-Received: by 2002:adf:9dce:0:b0:22c:bd91:e04a with SMTP id
 q14-20020adf9dce000000b0022cbd91e04amr2694011wre.102.1664296535680; Tue, 27
 Sep 2022 09:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com>
 <dd9b012f-88a2-c9fe-7ee2-863909e33e25@linux.dev>
In-Reply-To: <dd9b012f-88a2-c9fe-7ee2-863909e33e25@linux.dev>
From:   Alexander Potapenko <glider@google.com>
Date:   Tue, 27 Sep 2022 18:34:59 +0200
Message-ID: <CAG_fn=XtQDq2h+Kv70awUfmbHeuPRDm8fKP8+psweUdVd7hOQA@mail.gmail.com>
Subject: Re: Use of uninit value in inet_bind2_bucket_find
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Networking <netdev@vger.kernel.org>, joannelkoong@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
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

On Tue, Sep 27, 2022 at 2:33 AM Martin KaFai Lau <martin.lau@linux.dev> wro=
te:
>
> On 9/19/22 6:41 AM, Alexander Potapenko wrote:
> > Hi Joanne, Jakub et al.,
> >
> > When building next-20220919 with KMSAN I am seeing the following error
> > at boot time:
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > BUG: KMSAN: uninit-value in inet_bind2_bucket_find+0x71f/0x790
> > net/ipv4/inet_hashtables.c:827
> >   inet_bind2_bucket_find+0x71f/0x790 net/ipv4/inet_hashtables.c:827
> >   inet_csk_get_port+0x2415/0x32e0 net/ipv4/inet_connection_sock.c:529
> >   __inet6_bind+0x1474/0x1a20 net/ipv6/af_inet6.c:406
> >   inet6_bind+0x176/0x360 net/ipv6/af_inet6.c:465
> >   __sys_bind+0x5b3/0x750 net/socket.c:1776
> >   __do_sys_bind net/socket.c:1787
> >   __se_sys_bind net/socket.c:1785
> >   __x64_sys_bind+0x8d/0xe0 net/socket.c:1785
> >   do_syscall_x64 arch/x86/entry/common.c:50
> >   do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> >   entry_SYSCALL_64_after_hwframe+0x63/0xcd ??:?
> >
> > Uninit was created at:
> >   slab_post_alloc_hook+0x156/0xb40 mm/slab.h:759
> >   slab_alloc_node mm/slub.c:3331
> >   slab_alloc mm/slub.c:3339
> >   __kmem_cache_alloc_lru mm/slub.c:3346
> >   kmem_cache_alloc+0x47e/0x9f0 mm/slub.c:3355
> >   inet_bind2_bucket_create+0x4b/0x3b0 net/ipv4/inet_hashtables.c:128
> >   inet_csk_get_port+0x2513/0x32e0 net/ipv4/inet_connection_sock.c:533
> >   __inet_bind+0xbd2/0x1040 net/ipv4/af_inet.c:525
> >   inet_bind+0x184/0x360 net/ipv4/af_inet.c:456
> >   __sys_bind+0x5b3/0x750 net/socket.c:1776
> >   __do_sys_bind net/socket.c:1787
> >   __se_sys_bind net/socket.c:1785
> >   __x64_sys_bind+0x8d/0xe0 net/socket.c:1785
> >   do_syscall_x64 arch/x86/entry/common.c:50
> >   do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> >   entry_SYSCALL_64_after_hwframe+0x63/0xcd ??:?
> >
> > CPU: 3 PID: 5983 Comm: sshd Not tainted 6.0.0-rc6-next-20220919 #211
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > 1.16.0-debian-1.16.0-4 04/01/2014
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> > I think this is related to "net: Add a bhash2 table hashed by port and
> > address", could you please take a look?
> > This error is not reported on v6.0-rc5 (note that KMSAN only exists in
> > -next and as a v6.0-rc5 fork at https://github.com/google/kmsan).
>
> Hi Alex, thanks for the report.
>
> I have posted a fix [0].  I have problem getting kmsan kernel to boot.
> Could you help to give the patch a try ?  Thanks.
>
> [0]: https://lore.kernel.org/netdev/20220927002544.3381205-1-kafai@fb.com=
/

Hi Martin,

Thanks, I'll give it a shot.

Could you please share the config you're using to build KMSAN? I am
really curious about what's wrong.

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
