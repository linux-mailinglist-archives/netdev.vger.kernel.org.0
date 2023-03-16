Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20C16BCAB5
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjCPJZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCPJZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:25:17 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF25B5FE9;
        Thu, 16 Mar 2023 02:25:15 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m18-20020a05600c3b1200b003ed2a3d635eso589886wms.4;
        Thu, 16 Mar 2023 02:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678958714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JHk3LkW04FxegI0HeDKKkz9Skqui6v3gP3Rg7i28Ek0=;
        b=oV1BMXWx8tzbSTJaIVWUKxpRPo1C4IKBtsYDtMhmwTqJL1liiOwJKeHPKtLVjAiK2c
         qslQkG9POSHjMs/3sW3hURDmcrCDiZk7btaoGwBS7OkVYrcJuTL0WF/EqlraA0HOJjOH
         pdS0Ffz/f//EfOf4HuqYoqSqAqJQ+DOrfdZblaMvFDuzRcw2ZU+XYaNgLMTn3jDPgfXn
         VfY9UKWpw2EH0hI2ilwXFsbW3N/uDOa65CcG8ayThWsyNkK9X3rOZ4Yr0WbzI+VOsKyd
         2amB0m/miEKI7qlzTKiYIY455JMcg8FZ96BSA/tBWQIJtephCoC1cE7ytmPBZF/bdhqM
         3gZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678958714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JHk3LkW04FxegI0HeDKKkz9Skqui6v3gP3Rg7i28Ek0=;
        b=Am6L3fWbc0+INDwpfQMBO+ToLpoQnmbKKm/I4aRiEw1nK+9+yAhYce5RcMqsuzP9WY
         HrQ2rY5h215IP1RFxEGpURSfWTnXSa9YJ8JVElpm2e1pmw+4Q0LS86ZnNlvJq4/vidP0
         TkSZJEwlOnXKijmjTYWqXgK9rhRHc+8x9qftioivt8KF/6fGYxPNvXVidJld6KR7Qa8F
         3ZWMvfsQA44CulJ0EBnfoGZykvTzjpxCuf7RvnvsvX4aYPKQby4DdGXDfP9TOngdYsdI
         h+/Y8mJvgFOzrJm6cO7OubV0T5qEMorwgmmLU4V/V4Awf0eFzue0ohiXtE1j/Z81ZJUJ
         ezBQ==
X-Gm-Message-State: AO0yUKVf7yygwJvXSJwAQMGhgYSRg7HfSut0UTdlUuMOiy4XVK1SNpwl
        2sRBBVixhYbFgfm0jVqaU2+ra/YzBJnufg==
X-Google-Smtp-Source: AK7set/5wRJv3GP2yYF4DVmYKAYBS3hOXmW5dm0XysfflqGjwgFweuDKwlS9lgZC3vHbJhBTrY+Zbw==
X-Received: by 2002:a05:600c:4f87:b0:3df:de28:f819 with SMTP id n7-20020a05600c4f8700b003dfde28f819mr20969428wmq.15.1678958714201;
        Thu, 16 Mar 2023 02:25:14 -0700 (PDT)
Received: from suse.localnet (host-79-35-102-94.retail.telecomitalia.it. [79.35.102.94])
        by smtp.gmail.com with ESMTPSA id e18-20020a056000121200b002cf1c435afcsm6708222wrx.11.2023.03.16.02.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 02:25:13 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/8] vringh: replace kmap_atomic() with kmap_local_page()
Date:   Thu, 16 Mar 2023 10:25:12 +0100
Message-ID: <2155970.irdbgypaU6@suse>
In-Reply-To: <CAGxU2F4k-UHxHxpLcsvKvJdvcXfb3WpV+wU=8ZpnJwMNkx0rdA@mail.gmail.com>
References: <20230302113421.174582-1-sgarzare@redhat.com> <1980067.5pFmK94fv0@suse>
 <CAGxU2F4k-UHxHxpLcsvKvJdvcXfb3WpV+wU=8ZpnJwMNkx0rdA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On gioved=C3=AC 16 marzo 2023 09:09:29 CET Stefano Garzarella wrote:
> On Wed, Mar 15, 2023 at 10:12=E2=80=AFPM Fabio M. De Francesco
>=20
> <fmdefrancesco@gmail.com> wrote:
> > On marted=C3=AC 14 marzo 2023 04:56:08 CET Jason Wang wrote:
> > > On Thu, Mar 2, 2023 at 7:34=E2=80=AFPM Stefano Garzarella <sgarzare@r=
edhat.com>
> >=20
> > wrote:
> > > > kmap_atomic() is deprecated in favor of kmap_local_page().
> > >=20
> > > It's better to mention the commit or code that introduces this.
> > >=20
> > > > With kmap_local_page() the mappings are per thread, CPU local, can=
=20
take
> > > > page-faults, and can be called from any context (including=20
interrupts).
> > > > Furthermore, the tasks can be preempted and, when they are schedule=
d=20
to
> > > > run again, the kernel virtual addresses are restored and still vali=
d.
> > > >=20
> > > > kmap_atomic() is implemented like a kmap_local_page() which also
> > > > disables
> > > > page-faults and preemption (the latter only for !PREEMPT_RT kernels,
> > > > otherwise it only disables migration).
> > > >=20
> > > > The code within the mappings/un-mappings in getu16_iotlb() and
> > > > putu16_iotlb() don't depend on the above-mentioned side effects of
> > > > kmap_atomic(),
> > >=20
> > > Note we used to use spinlock to protect simulators (at least until
> > > patch 7, so we probably need to re-order the patches at least) so I
> > > think this is only valid when:
> > >=20
> > > The vringh IOTLB helpers are not used in atomic context (e.g spinlock,
> > > interrupts).
> >=20
> > I'm probably missing some context but it looks that you are saying that
> > kmap_local_page() is not suited for any use in atomic context (you are
> > mentioning spinlocks).
> >=20
> > The commit message (that I know pretty well since it's the exact copy,=
=20
word
> > by word, of my boiler plate commits)
>=20
> I hope it's not a problem for you, should I mention it somehow?

Sorry, I had missed your last message when I wrote a another message few=20
minutes ago in this thread.

Obviously, I'm happy that my commit message it's being reused. As I said in=
=20
the other message I would appreciate some kind of crediting me as the autho=
r.

I proposed a means you can use, but feel free to ignore my suggestion and d=
o=20
differently if you prefer to.

Again thanks,

=46abio

> I searched for the last commits that made a similar change and found
> yours that explained it perfectly ;-)
>=20
> Do I need to rephrase?
>=20
> > explains that kmap_local_page() is perfectly
> > usable in atomic context (including interrupts).
> >=20
> > I don't know this code, however I am not able to see why these vringh=20
IOTLB
> > helpers cannot work if used under spinlocks. Can you please elaborate a
> > little more?
> >=20
> > > If yes, should we document this? (Or should we introduce a boolean to
> > > say whether an IOTLB variant can be used in an atomic context)?
> >=20
> > Again, you'll have no problems from the use of kmap_local_page() and so=
=20
you
> > don't need any boolean to tell whether or not the code is running in=20
atomic
> > context.
> >=20
> > Please take a look at the Highmem documentation which has been recently
> > reworked and extended by me: https://docs.kernel.org/mm/highmem.html
> >=20
> > Anyway, I have been ATK 12 or 13 hours in a row. So I'm probably missin=
g=20
the
> > whole picture.
>=20
> Thanks for your useful info!
> Stefano




