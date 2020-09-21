Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913402735F8
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgIUWr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgIUWr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 18:47:56 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06270C061755;
        Mon, 21 Sep 2020 15:47:56 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id y17so15875328lfa.8;
        Mon, 21 Sep 2020 15:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I3wqyDDdLIpvUwpV/Ohrox6ZG5qHliCePHoNJJbUxkM=;
        b=g9AGcK6LPw7fwA50/Zs+2rqHoGD2jGb34/+PSMpTK8mMVYMZiR4wpVsdBD+Co7D7d9
         qI9Fn/Yb0rrVUWuG44FosMiy9s7T0jy4KuLka2JcYCsd53ZGf/IUtocUDmlNWpXWrCDt
         dXnn3P0bwsGLPiMXskrCuTlkfsbQTnvh0WSPiKJLusuZOhIr7FXNyW1GUvzEI9u3kDo7
         v+oSErcRLK2Fg5kc7KIXv04f1/5KT2D5NlpNknek701BNyeKykmEMm8mWaO11L9TeCj1
         WgX7sTZXn8JAg5NC3c+MNGfVhKLFnnS7/WORJKzw038+boYMxigef1L6ycNNoXpfFNb0
         CvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I3wqyDDdLIpvUwpV/Ohrox6ZG5qHliCePHoNJJbUxkM=;
        b=OX6yh9yWTunPCSCwTIMQd7Hgz0Qedv0W9unON09h6VKk1hVD2lv7g3QYE1lp/jELzM
         cDETv/qRA/9C5yJHz3lWW7gS1Kyc/3cubxOz3nvtPGEtT0uZOrOxa5TSJAJ4BS4m7lKJ
         dQRxkfObl8k9U/S2PTk5sPFtlqTkk1dd7bKB/C7XGYGYPL1F+Et4tCUplAwY3thT4J/r
         FyxtnA2rgQJJwf7Oyi3729Cptre2kI9l2ipjFyN17Ny5Dj52+/MRXAmYUXKlzDwpaiHd
         Ebc5Erj0UfjCAZatJVnYz94BcpG/P4mILUmAKSF+J+zOem1Ysl60yAh63lC9GRMfmWIH
         4mVw==
X-Gm-Message-State: AOAM531svxGU4YO1dJpbOglVJ9JUoOgd5PIzoQiqwEgIqjTkEmRtsTtL
        35oF2GHgVPZfbs46wpkRwXcP/r3QzbDaXYsNjrA=
X-Google-Smtp-Source: ABdhPJyHuuP8QxGRb86dFMisJVgbwzFWgnaQRHkB02wWWiJxfdAKzOpYUaNhCcZ7QhIIJO75BcBlPvgHF+/n/DApUIk=
X-Received: by 2002:a19:df53:: with SMTP id q19mr613550lfj.119.1600728474311;
 Mon, 21 Sep 2020 15:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200916224645.720172-1-yhs@fb.com>
In-Reply-To: <20200916224645.720172-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 21 Sep 2020 15:47:42 -0700
Message-ID: <CAADnVQK13a4fnczaLTeZEnj4TJn7WyRTz4p7667aQJ_dwNMfaw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpf: using rcu_read_lock for
 bpf_sk_storage_map iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 8:46 AM Yonghong Song <yhs@fb.com> wrote:
>
> If a bucket contains a lot of sockets, during bpf_iter traversing
> a bucket, concurrent userspace bpf_map_update_elem() and
> bpf program bpf_sk_storage_{get,delete}() may experience
> some undesirable delays as they will compete with bpf_iter
> for bucket lock.
>
> Note that the number of buckets for bpf_sk_storage_map
> is roughly the same as the number of cpus. So if there
> are lots of sockets in the system, each bucket could
> contain lots of sockets.
>
> Different actual use cases may experience different delays.
> Here, using selftest bpf_iter subtest bpf_sk_storage_map,
> I hacked the kernel with ktime_get_mono_fast_ns()
> to collect the time when a bucket was locked
> during bpf_iter prog traversing that bucket. This way,
> the maximum incurred delay was measured w.r.t. the
> number of elements in a bucket.
>     # elems in each bucket          delay(ns)
>       64                            17000
>       256                           72512
>       2048                          875246
>
> The potential delays will be further increased if
> we have even more elemnts in a bucket. Using rcu_read_lock()
> is a reasonable compromise here. It may lose some precision, e.g.,
> access stale sockets, but it will not hurt performance of
> bpf program or user space application which also tries
> to get/delete or update map elements.
>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  net/core/bpf_sk_storage.c | 31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
>
> Changelog:
>   v3 -> v4:
>      - use rcu_dereference/hlist_next_rcu for hlist_entry_safe. (Martin)

Applied. Thanks
