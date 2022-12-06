Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67EF6444FB
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiLFNx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiLFNx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:53:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6F62B19D;
        Tue,  6 Dec 2022 05:53:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B122B80DF3;
        Tue,  6 Dec 2022 13:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BDDC433C1;
        Tue,  6 Dec 2022 13:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670334805;
        bh=pLK21N5d/EKb/syw7sI9+Uws4wdPPOjQjHEhyt51XUU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=nO+bo8un+V+ofnRZf16zv9tcWuY2QT1r4KaWAHFjvB4zhdNlHOs0P7x48LTLInYdo
         ZJPXalJcwpWZvZkF/+tET+dbFBmLEGZI1i9qflg73cO2OL3VVqJP8DszO/zo2nnkUe
         fZZmojkVMq5EtU6tqsezgJH3MJ4bS0FLY1e76kUofcj+x0xnCBCPAdRuv47ITB4ISX
         a7UlNZIy/04HGnwExrFBORnxC9BPSoFUZnl9m35meQWaNisFSWjlmjMohi2He+l6Su
         L4KqmG7N3mdvvuBrbzEPXcD1G+HTS5cMKWoCJ+S4UprT/lj4cU4znD3x/kH7ORFBv4
         u2zRcq0kvCA5A==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1C00582E399; Tue,  6 Dec 2022 14:53:22 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: [PATCH] bpf: call get_random_u32() for random integers
In-Reply-To: <CAHmME9pQoHBLob306ta4jswr5HnPX73Uq0GDK8bZBtYOLHVwbQ@mail.gmail.com>
References: <20221205181534.612702-1-Jason@zx2c4.com>
 <730fd355-ad86-a8fa-6583-df23d39e0c23@iogearbox.net>
 <Y451ENAK7BQQDJc/@zx2c4.com> <87lenku265.fsf@toke.dk>
 <CAHmME9poicgpHhXJ1ieWbDTFBu=ApSFaQKShhHezDmA0A5ajKQ@mail.gmail.com>
 <87iliou0hd.fsf@toke.dk>
 <CAHmME9pQoHBLob306ta4jswr5HnPX73Uq0GDK8bZBtYOLHVwbQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 06 Dec 2022 14:53:22 +0100
Message-ID: <87edtctz8t.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hi Toke,
>
> On Tue, Dec 6, 2022 at 2:26 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@ker=
nel.org> wrote:
>> So for instance, if there's a large fixed component of the overhead of
>> get_random_u32(), we could have bpf_user_rnd_u32() populate a larger
>> per-CPU buffer and then just emit u32 chunks of that as long as we're
>> still in the same NAPI loop as the first call. Or something to that
>> effect. Not sure if this makes sense for this use case, but figured I'd
>> throw the idea out there :)
>
> Actually, this already is how get_random_u32() works! It buffers a
> bunch of u32s in percpu batches, and doles them out as requested.

Ah, right. Not terribly surprised you already did this!

> However, this API currently works in all contexts, including in
> interrupts. So each call results in disabling irqs and reenabling
> them. If I bifurcated batches into irq batches and non-irq batches, so
> that we only needed to disable preemption for the non-irq batches,
> that'd probably improve things quite a bit, since then the overhead
> really would reduce to just a memcpy for the majority of calls. But I
> don't know if adding that duplication of all code paths is really
> worth the huge hassle.

Right, makes sense; happy to leave that decision entirely up to you :)

-Toke
