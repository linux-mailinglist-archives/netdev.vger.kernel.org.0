Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA366B9F22
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjCNSx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCNSx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:53:28 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B4C738B0;
        Tue, 14 Mar 2023 11:52:56 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ek18so34916228edb.6;
        Tue, 14 Mar 2023 11:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678819975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bFOyZxhTEQ66iydcDjikLDtBNykrynyigYQE3FGKkOs=;
        b=RoO1t3hXwmQpU/UQ95cT+vP5fCNybmsmvhDZabHye5Y2FrSzH3bjHCBNOND6I1HXyN
         qJQ4TdTIq0v9UI0aAl27qtYQbRQD0CW/ErzcJvgIOkGkrmhQz0XXFJfNMJJPnwTB5oeM
         4FOL3GllZ2ByfdwvhH/tkQ2rcvsb62rR/A/dP5vfNlDB81DbSatkjL3hnd7X0tKGbQ7p
         jAiyI0ESdbHgtVwZCawZ07IusvxFnp8vmKmLMDtwVB9IPcOiIcz035A2QkAM2bg4iSxi
         7fhPIvWluwJCynvrq9/gWPfizxUP17jbPlTS5zSCrK2GC9jHMrMlEo8ZVYOb0XqTJKEG
         EYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678819975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bFOyZxhTEQ66iydcDjikLDtBNykrynyigYQE3FGKkOs=;
        b=nPiXbbPARYzFW1t2OjzYTZnOlttsOtLcaPN/6q/TWO979e+MYfAI5csPcHA3FR9cVn
         JKncgszSXPiHEDGpMG4JDXARFcs18svv+Onyau+/O6yYTbmexpUsa9tELQlqM9bMDu2F
         BaVGs1h0R8XUBnHIVfGgxlqnSgQigmzZBD7rQGoX4bCi4+A7rvICTekE11AX0DrSYzse
         L5aw5KqZRKTDboPov1ojRVyKVhnVuajpsUjLieSioesukS202fhkYiKmVYfnV72Hu1FY
         mu/8BbyeMP4Hjry4nD2vsDnLj/Mea+IGhE+8Sji/bx0LMYNRwdwpRYHM2VK1Bd/V6pIp
         4aYg==
X-Gm-Message-State: AO0yUKUONmvWUTMzkAC2Yy57/P4uwtaPRzH5xudxTox9I6pV90RG/v3n
        F5ZFUTw7r2Rwg7PUqxUK9IR9Y7EGDepnTkrCZZw=
X-Google-Smtp-Source: AK7set/IE1VM2wr2edOJrOf5TOMg6HrvmMvAsSawnujR4IBRheQlVDJI/j09ng/0zGcBLqdaXkGlUw2tkVDGdhS5kr8=
X-Received: by 2002:a17:906:6b92:b0:926:8f9:735d with SMTP id
 l18-20020a1709066b9200b0092608f9735dmr1798824ejr.3.1678819974825; Tue, 14 Mar
 2023 11:52:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com> <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com>
In-Reply-To: <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Mar 2023 11:52:43 -0700
Message-ID: <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 4:58=E2=80=AFAM Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
>   All error logs:
>   libbpf: prog 'trace_virtqueue_add_sgs': BPF program load failed: Bad
> address
>   libbpf: prog 'trace_virtqueue_add_sgs': -- BEGIN PROG LOAD LOG --
>   The sequence of 8193 jumps is too complex.
>   verification time 77808 usec
>   stack depth 64
>   processed 156616 insns (limit 1000000) max_states_per_insn 8
> total_states 1754 peak_states 1712 mark_read 12
>   -- END PROG LOAD LOG --
>   libbpf: prog 'trace_virtqueue_add_sgs': failed to load: -14
>   libbpf: failed to load object 'loop6.bpf.o'
>   scale_test:FAIL:expect_success unexpected error: -14 (errno 14)
>   #257     verif_scale_loop6:FAIL
>   Summary: 288/1766 PASSED, 21 SKIPPED, 1 FAILED
>
> So, xdp_do_redirect, which was previously failing, now works fine. OTOH,
> "verif_scale_loop6" now fails, but from what I understand from the log,
> it has nothing with the series ("8193 jumps is too complex" -- I don't
> even touch program-related stuff). I don't know what's the reason of it
> failing, can it be some CI issues or maybe some recent commits?

Yeah. It's an issue with the latest clang.
We don't have a workaround for this yet.
It's not a blocker for your patchset.
We didn't have time to look at it closely.
