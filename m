Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C03E6E8453
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 00:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjDSWBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 18:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDSWBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 18:01:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEAC46AB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 15:01:18 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id z6so1899603ejc.5
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 15:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681941677; x=1684533677;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jE7wFjUHDEsBd3OPJhV20VpgiyEnucWm25dyji9JD5Q=;
        b=dZV8QYYO70/evae582p451U0wHAsWrKaFnQKJ6RD0nx3kp2smSKjQjE1+LkhV9vv6x
         KmQ+EC75AgWAUDkHqW1NgAnGvMQuB5tZnWbIZdiV2PtV6WPaUKmQwa3qmzfmDjCsMXQg
         7LIzYdIHS67POjQ83/qRjSb70MTQiiJ+7lbug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681941677; x=1684533677;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jE7wFjUHDEsBd3OPJhV20VpgiyEnucWm25dyji9JD5Q=;
        b=R56vexIAsWlwaSKxQq/P6RFb+RC/BKFYs2ovuhpQQsb23Kao/IcdrhtTjpIzXEEmAA
         LRZZ6x3CF9LO5etYgSLVV9OLlh9T/+sXaD1feON9O8e0Twu3bpxHRYCjwmy5Bw+U1f4t
         rK1B1yICJ+fAoI/yO8Be0RpmixVTNpr77YPP4nhEbCfPQ8a+/M+zXhErhZ5X4KaSCn52
         ayzaleGMfAFNLB7l7xI6KvTsJ6iQFqkHIowhgLlZvC0DQs2UJD7slAoYuBtWP/YKCUYi
         GMdtuv4kYfPWCMZOZ9wFod9PnZOBmhp57wX4QKclvG9eP8k+VShD6PtaE+7gySXZEgTk
         aRkg==
X-Gm-Message-State: AAQBX9edqwV4/J04ub9ChXD9QlTY20RyJABbhd1EtVSTirASg98kGmVI
        VZ0UsmnWaQ0AknrzPllq3q1E0nPg+S457qQ+vn8b7A==
X-Google-Smtp-Source: AKy350YjjT1VoAU95rqQwDYgVp2T0/Z2yknoMw2oeeeLWQgyrP15YKyPRVBF2Xr+fv9QqfsBii7iS0j6cCFfhHpXoJ4=
X-Received: by 2002:a17:906:e247:b0:94e:4926:7716 with SMTP id
 gq7-20020a170906e24700b0094e49267716mr6943931ejb.0.1681941676728; Wed, 19 Apr
 2023 15:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230418143617.27762-1-magnus.karlsson@gmail.com>
In-Reply-To: <20230418143617.27762-1-magnus.karlsson@gmail.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Thu, 20 Apr 2023 00:06:04 +0200
Message-ID: <CAHApi-=_=ia8Pa23QRchxdx-ekPTgT5nYj=ktYGO4gRwP0cvCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/xsk: fix munmap for hugepage allocated umem
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, tirthendu.sarkar@intel.com,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1286,16 +1287,19 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
>         u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
>         int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
>         LIBBPF_OPTS(bpf_xdp_query_opts, opts);
> +       off_t mmap_offset = 0;
>         void *bufs;
>         int ret;
>
> -       if (ifobject->umem->unaligned_mode)
> +       if (ifobject->umem->unaligned_mode) {
>                 mmap_flags |= MAP_HUGETLB;
> +               mmap_offset = MAP_HUGE_2MB;
> +       }

MAP_HUGE_2MB should be ORed into mmap_flags. The offset argument
should be zero for MAP_ANONYMOUS mappings. The tests may still fail if
the default hugepage size is not 2MB.

>
>         if (ifobject->shared_umem)
>                 umem_sz *= 2;
>
> -       bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
> +       bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, mmap_offset);
>         if (bufs == MAP_FAILED)
>                 exit_with_error(errno);
>

-Kal
