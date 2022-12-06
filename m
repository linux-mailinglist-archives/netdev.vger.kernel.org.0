Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF45644486
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiLFNao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiLFNan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:30:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A657F12AD1;
        Tue,  6 Dec 2022 05:30:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A926157F;
        Tue,  6 Dec 2022 13:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F01C433C1;
        Tue,  6 Dec 2022 13:30:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GdtRHbwO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670333438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xsLyD9vjJ8BNbBLT3UyVDqygIHFufr2hym4Qtk5jTZc=;
        b=GdtRHbwOKRbTBKRJ5321twDkVdEOD3+vwQOUmI1QeinTb/HS+PjTRbGcn+TkFXbbDCM9+d
        H/MVYmSl7Ll/gqBO7jktwwpmAKEoP3ZxAW8GR9J+jZrQHo5B5u1Ftld66UUtq83oNjdp2K
        Zf3fWm4bUHKZz1jDtpWZd6wqFVzqMRQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9794eb86 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 6 Dec 2022 13:30:38 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-381662c78a9so151758347b3.7;
        Tue, 06 Dec 2022 05:30:38 -0800 (PST)
X-Gm-Message-State: ANoB5plDsHZIcqA7/wf3kRcA/BaTG8ZZP0BdKFzgsUu9iDiWzXzBKbgO
        2WoTBDLdMzmHxlDX1rJgxCfE0qoylipJWyjCBHk=
X-Google-Smtp-Source: AA0mqf76Na1GEg6lULe98SoWtB1T1zVCAV6Bs+7z7nmmyj0QA52+uoIG2Q1ur/K6GJHNF1vMIEbChYtc7Oj7OfAdBlA=
X-Received: by 2002:a0d:c6c3:0:b0:3f8:5b0b:bbb8 with SMTP id
 i186-20020a0dc6c3000000b003f85b0bbbb8mr1377843ywd.79.1670333437439; Tue, 06
 Dec 2022 05:30:37 -0800 (PST)
MIME-Version: 1.0
References: <20221205181534.612702-1-Jason@zx2c4.com> <730fd355-ad86-a8fa-6583-df23d39e0c23@iogearbox.net>
 <Y451ENAK7BQQDJc/@zx2c4.com> <87lenku265.fsf@toke.dk> <CAHmME9poicgpHhXJ1ieWbDTFBu=ApSFaQKShhHezDmA0A5ajKQ@mail.gmail.com>
 <87iliou0hd.fsf@toke.dk>
In-Reply-To: <87iliou0hd.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 6 Dec 2022 14:30:26 +0100
X-Gmail-Original-Message-ID: <CAHmME9pQoHBLob306ta4jswr5HnPX73Uq0GDK8bZBtYOLHVwbQ@mail.gmail.com>
Message-ID: <CAHmME9pQoHBLob306ta4jswr5HnPX73Uq0GDK8bZBtYOLHVwbQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: call get_random_u32() for random integers
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On Tue, Dec 6, 2022 at 2:26 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@kerne=
l.org> wrote:
> So for instance, if there's a large fixed component of the overhead of
> get_random_u32(), we could have bpf_user_rnd_u32() populate a larger
> per-CPU buffer and then just emit u32 chunks of that as long as we're
> still in the same NAPI loop as the first call. Or something to that
> effect. Not sure if this makes sense for this use case, but figured I'd
> throw the idea out there :)

Actually, this already is how get_random_u32() works! It buffers a
bunch of u32s in percpu batches, and doles them out as requested.
However, this API currently works in all contexts, including in
interrupts. So each call results in disabling irqs and reenabling
them. If I bifurcated batches into irq batches and non-irq batches, so
that we only needed to disable preemption for the non-irq batches,
that'd probably improve things quite a bit, since then the overhead
really would reduce to just a memcpy for the majority of calls. But I
don't know if adding that duplication of all code paths is really
worth the huge hassle.

Jason
