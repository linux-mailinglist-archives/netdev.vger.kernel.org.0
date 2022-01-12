Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BA748CAD2
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356138AbiALSS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349910AbiALSSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:18:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1279C06173F;
        Wed, 12 Jan 2022 10:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CDB6B82032;
        Wed, 12 Jan 2022 18:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5139FC36AEF;
        Wed, 12 Jan 2022 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642011500;
        bh=bIDjqw08vK+vCsDN0E+8vvzXVt7P4d2wm5OTqpvgBgQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d0be0jYr0uglevjUk8BYcn+4IAbabxUHt20qCHeltY9o19ber4+Z369B4wyR6xJ2O
         lXx6IJVDmgZl2kPa4MLa0Q5v9dV9lPQLA6PUzltUkJCQ/39thSYykTDNkvhjmxoYSG
         1Mb0TMQauxaErN25EU/DEtZeGMSwV7J/W80MOmh/LXCkbwn7MeKBiDxxr73/hEJ0F6
         JQcgkkmVQUZAI0c1GFbvgk+cbSAZz0ETNo21wPLUSH5r9iXCwNGGwoLnBksb1aDk0u
         mkOdBozxDmNuTQfMNtRI9kHogz3njhawX8Mnz3udv00Nb8lJqQceodye5Adfbe+eIW
         xxAbTMi8L8L/A==
Received: by mail-yb1-f171.google.com with SMTP id c6so8034397ybk.3;
        Wed, 12 Jan 2022 10:18:20 -0800 (PST)
X-Gm-Message-State: AOAM533ImlCxNAPPtQ1/2ff0ZJFz0+0qWJbZY+e4v6oYGbYl7MTzj92R
        eH7qVrQ5AwOW0S113xoz4YDkrPj3iQFwHpfolfM=
X-Google-Smtp-Source: ABdhPJysO5jVaHT7Buc5XPI4H+MAtMB7BLn5Wl5iR11oNybxIBaWBpTRFJDJ8nbP29FOXHHuZ2nyqCTkfoNHwhxhqow=
X-Received: by 2002:a25:8d0d:: with SMTP id n13mr1228904ybl.208.1642011499395;
 Wed, 12 Jan 2022 10:18:19 -0800 (PST)
MIME-Version: 1.0
References: <20220112002503.115968-1-connoro@google.com>
In-Reply-To: <20220112002503.115968-1-connoro@google.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 12 Jan 2022 10:18:07 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4T4DDPaiF0zUyxN4nUX-a9OWYd0OLMGLjCnUO38-d74g@mail.gmail.com>
Message-ID: <CAPhsuW4T4DDPaiF0zUyxN4nUX-a9OWYd0OLMGLjCnUO38-d74g@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/resolve_btfids: build with host flags
To:     "Connor O'Brien" <connoro@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 4:25 PM Connor O'Brien <connoro@google.com> wrote:
>
> resolve_btfids is built using $(HOSTCC) and $(HOSTLD) but does not
> pick up the corresponding flags. As a result, host-specific settings
> (such as a sysroot specified via HOSTCFLAGS=--sysroot=..., or a linker
> specified via HOSTLDFLAGS=-fuse-ld=...) will not be respected.
>
> Fix this by setting CFLAGS to KBUILD_HOSTCFLAGS and LDFLAGS to
> KBUILD_HOSTLDFLAGS.
>
> Also pass the cflags through to libbpf via EXTRA_CFLAGS to ensure that
> the host libbpf is built with flags consistent with resolve_btfids.
>
> Signed-off-by: Connor O'Brien <connoro@google.com>

I guess this should go to bpf-next tree?

Other than that,

Acked-by: Song Liu <songliubraving@fb.com>
