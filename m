Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360DF2777FA
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 19:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgIXRml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 13:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgIXRml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 13:42:41 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E575C0613CE;
        Thu, 24 Sep 2020 10:42:41 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id b142so39643ybg.9;
        Thu, 24 Sep 2020 10:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RYnRJZLmHY5BkI28RkDFaACHcPCPE4zBTInCCbWdZOI=;
        b=iYfVBby4US7BbmDvzdsRy3A30i8CbX4dCDv26Qxu6yZClnmXOC7C5xaVY86iuO/Qjt
         Jzwzx5G0cm0hwvmmeWIMz+9M8qvhKMooHnta1fyCwneD1yrmhvb00dywlStXVEgbqVyK
         ISnK8c7Ys3nfgDqp3wVJmEvLf6VD5pMMAR0vQZZv3U9p/Nr61z4dkCwH7w92ua34QZfI
         eHqfoMt9Sj/13YcN06BxCjDASz5Jib40A3q+7Rf1nogt5jwQZafha+sgSEdrs9Tm+1TS
         prxzskZsTYeSq1dRH6lrE6EAuDJjbnhP+X559CcZZLS2QRVychLFYvhiZmIMAHI5dmZI
         3vZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RYnRJZLmHY5BkI28RkDFaACHcPCPE4zBTInCCbWdZOI=;
        b=dldCFZcRNw46IpDhgVraYMFgxfO0tbzwxN/uxy9N3DrIkhv+EBHOfTe5v6CVf2d5LA
         QAMg1OphoHCJ1HmZlY+8N1XctaEoG2DNT3Id0w1UTC67STSokjjDnL0mFwHgbx03rArL
         GX92VecjoPSifm/JZFeHpratAqtG5npfRkX9yJl2O6usgEhO5jsFkFgk83JUmS+D7gMa
         izIcPcpciU2N/Yav8yau50Q1SX8LW8T3CvKdAMsEcmkurNvx8BWTMa8082gYa1tvC1tr
         q7N6fbdSKnqBEvLl9spTh9C8haGVxPcs2RdPhvy0MjIk10lAVolRB18SOyXEGIU1lKsU
         Nixw==
X-Gm-Message-State: AOAM532iZlhHLHmd7Cenm5e/cw/4tfFCtiVB3P50IrMGF76YWkNhomOx
        k2/zJfQ2eTVgWBb2tQ7FLzBmESaDhP9BuTFxRcvynVVni8Q=
X-Google-Smtp-Source: ABdhPJwTzccitMB0XpTfYZxA2KL0qjMuE79D2SeAN+jKBVS3lxI4vndC501/VF34ZlHdN7jLHm0TX0k6BNatwX+8h+A=
X-Received: by 2002:a25:4446:: with SMTP id r67mr916659yba.459.1600969360304;
 Thu, 24 Sep 2020 10:42:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200924171705.3803628-1-andriin@fb.com> <CAADnVQLtxtMOsuBvt0U_UTLVuX-X__AWuih8t-CuGu67GbZJ_w@mail.gmail.com>
In-Reply-To: <CAADnVQLtxtMOsuBvt0U_UTLVuX-X__AWuih8t-CuGu67GbZJ_w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 10:42:29 -0700
Message-ID: <CAEf4Bza1qPfKjmbhLwZzBtGvg19Q3vps3-F6-nfvQb9vLhg-hA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix XDP program load regression for old kernels
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Nikita Shirokov <tehnerd@tehnerd.com>,
        Udip Pant <udippant@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 10:34 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Sep 24, 2020 at 10:18 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Fix regression in libbpf, introduced by XDP link change, which causes XDP
> > programs to fail to be loaded into kernel due to specified BPF_XDP
> > expected_attach_type. While kernel doesn't enforce expected_attach_type for
> > BPF_PROG_TYPE_XDP, some old kernels already support XDP program, but they
> > don't yet recognize expected_attach_type field in bpf_attr, so setting it to
> > non-zero value causes program load to fail.
> >
> > Luckily, libbpf already has a mechanism to deal with such cases, so just make
> > expected_attach_type optional for XDP programs.
> >
> > Reported-by: Nikita Shirokov <tehnerd@tehnerd.com>
> > Reported-by: Udip Pant <udippant@fb.com>
> > Fixes: dc8698cac7aa ("libbpf: Add support for BPF XDP link")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Applied. Thanks

Thanks!

>
> Looks like libbpf CI needs to add a few old kernels.

Yeah. We have 4.9 which is very old and only a few selftests can even
succeed there. Then we jump to 5.5, which is too recent to detect this
issue. This issue happened on 4.15, would that be a good version to
stick to? Any opinions?
