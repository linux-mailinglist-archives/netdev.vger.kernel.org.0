Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D0A3C7AA3
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 02:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbhGNAiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 20:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237159AbhGNAiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 20:38:14 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6520BC0613DD;
        Tue, 13 Jul 2021 17:35:23 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id x10so10705545ion.9;
        Tue, 13 Jul 2021 17:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EnP6Ly2WIp+QXLx5YSmZimw+qV+B8DDZxemfoa3U0L8=;
        b=VtJwVTQKoLJQtwX4Huobmad7hRfohuGFJf4zqLpRGFzU3rX9kZ+rTBzNU6Q07vHptJ
         dl5TjJ92fMLfV+QVqicYpzD6fLmiS8dlole4MX0CBilUJfjPuPz/cZ6VDX4VMMMdleFN
         SYbj7XvPycQg2NdwsoDD1jl54WjICkrcdk6GmvB5JsCJ/6QtxdB5MhojNK/3Q2Ma45ln
         MZ3At2GqjsVJqwpMubnVRqLZ6eGyb+eu5QULSDpttDXXCF9OrKltesQEKW2g2R5zvGop
         VA6UairaMgSGR4WlOgvvqBSEdSriEiYdWZYQMnT4gRrGCT6ranuoGDIa8I9vWYdcn3/8
         gvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EnP6Ly2WIp+QXLx5YSmZimw+qV+B8DDZxemfoa3U0L8=;
        b=Fx1NpgiLQSTeR7ClyThRLpRGZhE4w0vq7wqVe13abL2SUs90YNyt6/W1kcysGDcrts
         k2rbUakxXN6qZ2GOifAmBDfVxMiR/my1O28CI4P9rO2VORKrH+F9BMzZtlxB9fOCIrNH
         fp4NsuLW4c/KmsuXUs5o2pectWK3jMU9nZqXehF9AcnZSefAJ7ta7DpuGmqjX6Ig8oJp
         PmXCaARCinuRJeZ9wjo+MZH2Odgbq4pYsP5DiL/4Jgpb/Pj0qYSl4dRI8AD+7zkGJzM2
         RcRkEdRnMJLewxj6vQPaYQWCkwWnnJ8/ujKgui3tPRTGJlUXn3JcepIildWVwPi9nMiH
         l4CQ==
X-Gm-Message-State: AOAM5316bymOEbvgyKuasfxjuJ9RfCR3OMFfHVRBhQEjfc+S5jMJqu+0
        oZwLbQsydK3ybB1h3aOTDdYXuuLOyELFc8uHedA=
X-Google-Smtp-Source: ABdhPJzUA49Pg3dKLHsrWS/Uh+0ggz1s2KHjA/eW6Os5kHsNTqL30qzM0H+GHykxj/uq1evXg9jcDwTCPEELZ7gzQ0Y=
X-Received: by 2002:a02:3505:: with SMTP id k5mr6369942jaa.123.1626222922944;
 Tue, 13 Jul 2021 17:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210712195546.423990-1-john.fastabend@gmail.com> <20210712195546.423990-2-john.fastabend@gmail.com>
In-Reply-To: <20210712195546.423990-2-john.fastabend@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 13 Jul 2021 17:35:11 -0700
Message-ID: <CAM_iQpWQh2s_vRoGZVsKgkZj1SvDX6=-Q5esj0omZwL39hfA3w@mail.gmail.com>
Subject: Re: [PATCH bpf v4 1/2] bpf, sockmap: fix potential memory leak on
 unlikely error case
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 12:56 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> If skb_linearize is needed and fails we could leak a msg on the error
> handling. To fix ensure we kfree the msg block before returning error.
> Found during code review.
>
> Fixes: 4363023d2668e ("bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Reviewed-by: Cong Wang <cong.wang@bytedance.com>

Thanks for the update.
