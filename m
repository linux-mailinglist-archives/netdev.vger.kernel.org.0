Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01A96A5B83
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjB1PRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjB1PRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:17:48 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C842ED79
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:17:46 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id q6so4171305iot.2
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 07:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P7Cz6kbvRX5Jf355ebSBKy0RIgfXk61NCeYRAb4vPT8=;
        b=i4rv6znLYMhsTceJFOhHDG9ba1CMN/Xk36xMgbkEK9T50xA7NB4K8WlZUXAeHfZVaN
         qOeQ38C2ZXS/Iy1uZJn614UYbxacq9cN2VclRZHdRFUBRprtuc2LaVir1PHpApWHDIPt
         EBKTyqt1WJCPbljjDQgsRVQuB2DC44NbaT9sLH0lYHefgrnqfk71zUxSruat+Opongo4
         k0jkDNJKa/wVUdgEFynO5PGQqYhEI7vqd8usjc/l8pq/K05/wttqLXmk8Fx+jXIhJoJ1
         cVCRd08UgQYfXbbEud6th3PIR0kpX3sIJMveSBB1PACm6e1LRcOtVDRqVaM1AIpWlWCJ
         85Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P7Cz6kbvRX5Jf355ebSBKy0RIgfXk61NCeYRAb4vPT8=;
        b=MxFndP7hPU+c70J09AgGc80Kyip4TgjGpajN7nLaFtT4hnAkoNghhtFy5fPbhXF6qx
         9s/dxdIJ/EDH3GjdPsmGIMl4YtilZ5auhu2+z0dsjfYrzNmPHoY/X7Nu0krEXPR4WY1D
         5zD4196ME9HWH7K8DHeXo+GE9aJM6RNZci0ifBNpvF80Z5VoLmUnPR+6cwp6XYhgDSnE
         p3HmoL+XPdGpVTBSKWTrvNeTT++sulmFikubthi3NgOHK7lQP8XjJa8RJ1EONSr/aWyP
         I3biMbmKcurS28HKEBM/h3jz11fyioYLX5WW0xWUim9FR1PcvDmWmtaH9O2uTTb3a+Lf
         0y/g==
X-Gm-Message-State: AO0yUKUsgTRcFZpQYHzoEgx/DcFttxGhvH6w7w6nunZW0YfLwhQbgQBS
        PIm4isHrvKanFg3sqy1UwgHUV8fv0rIdybEvRJpNIA/JXZ6JTQsy1ZU=
X-Google-Smtp-Source: AK7set8p8GdPjTXxA1EMGlcXKaGQ77U2TcLGMP9YKcp9xsezJR3r0dwWN+BLGAkxLMMl8OKY5qO8Ulng+/xyxKzGfaM=
X-Received: by 2002:a6b:e40c:0:b0:744:d7fc:7a4f with SMTP id
 u12-20020a6be40c000000b00744d7fc7a4fmr1429782iog.1.1677597465904; Tue, 28 Feb
 2023 07:17:45 -0800 (PST)
MIME-Version: 1.0
References: <20230228132118.978145284@linutronix.de> <20230228132910.934296889@linutronix.de>
In-Reply-To: <20230228132910.934296889@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Feb 2023 16:17:34 +0100
Message-ID: <CANn89iKM6yMP2Doy0MuCrfX1LASPFt_OnpPY-aNg+hu=F3W7AA@mail.gmail.com>
Subject: Re: [patch 1/3] net: dst: Prevent false sharing vs. dst_entry::__refcnt
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
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

On Tue, Feb 28, 2023 at 3:33=E2=80=AFPM Thomas Gleixner <tglx@linutronix.de=
> wrote:
>
> From: Wangyang Guo <wangyang.guo@intel.com>
>
> dst_entry::__refcnt is highly contended in scenarios where many connectio=
ns
> happen from and to the same IP. The reference count is an atomic_t, so th=
e
> reference count operations have to take the cache-line exclusive.
>
> Aside of the unavoidable reference count contention there is another
> significant problem which is caused by that: False sharing.
>
> perf top identified two affected read accesses. dst_entry::lwtstate and
> rtable::rt_genid.
>
> dst_entry:__refcnt is located at offset 64 of dst_entry, which puts it in=
to
> a seperate cacheline vs. the read mostly members located at the beginning
> of the struct.

This will probably increase struct rt6_info past the 4 cache line size, rig=
ht ?

It would be nice to allow sharing the 'hot' cache line with seldom used fie=
lds.

Instead of mere pads, add some unions, and let rt6i_uncached/rt6i_uncached_=
list
use them.
