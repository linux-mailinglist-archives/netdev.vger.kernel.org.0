Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF875E984
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfGCQsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:48:52 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43936 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCQsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:48:52 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so1203447qto.10;
        Wed, 03 Jul 2019 09:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yJ/AMqCgjHOX7uREQW2b21H1rv+p0xkV9JezuXq3Lrs=;
        b=PYCV3Ki+HIxfv3LCSaaOhpNO0ILCQojaCN/Usn1R7wPqtJthrqytqFJ3xAEs5RVllF
         mcdBg1xGlEmpZV15vV47oY1ANNSVFV8PZqk8k+5J6Ap+moz06KU2dZf93XxMTp9crwOU
         SbC2rSoy/zfmOE+STsNSaVc26bxGUhMkIFh0OeZwUdllN2mqxZuG3Cflqoaxki6KrQOR
         UTuZv7+tBucPPxMZw/+l86b+cCSLX3Yt99lCF5r2NuM10pY1R6GrzKUWM/bTStwzrqSE
         659SFGlMCIgDiUKxk1SUDlpkSmmt4eGi6ULQNjPth35HN0TmSpmkHLFFeEZni/epIC8D
         Lv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yJ/AMqCgjHOX7uREQW2b21H1rv+p0xkV9JezuXq3Lrs=;
        b=nEngJeeZiYolpKUutDaLqpqHHKKGBZHfSfk09qD8reQPitkkojg9wU/VmkNyiiAZFJ
         7ODPn/XAsc0Wtz1RV03ABiXaAiVXo59XQr3Py+972oGAZ52is1AMVwgo+FI748HLGfvF
         SwWGqTg1x5M7UZxX89aQqe5Rb5X9reBqFv/nXRzOgWH91reb3D2SB8qUBqtj3nUomayo
         JX4ZGJwBRtiHtDDXSYm2yUK2mLwAkcABZe8DnXZ3YSq6f0CRJl6uyqWc2rVoL7uEsJhP
         urGCRJTbWVd2R1d/YLxf8jkwPQiBraZeYTl5QETXGvfxVAI9kUhqEKRWKNH3sH/2Ff6i
         xntA==
X-Gm-Message-State: APjAAAUJe+SwlPbB3Lac+m/TOJIkQWtjuLx9QcAPDzzXWXUKHIXEsGNz
        pwzTYMPXuSSQPSO6tjpVV3As/yL5a4m9yzLMzio=
X-Google-Smtp-Source: APXvYqzsFr7rYzgO9GtHdozh8mRRL64eWIT7m1KC+EQkslfS3kVovMPn+6YEufGDl076fJM7OZRCZ7UvZS6fd3bvZL4=
X-Received: by 2002:a0c:c586:: with SMTP id a6mr33611361qvj.177.1562172531460;
 Wed, 03 Jul 2019 09:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190703120922eucas1p2d97e3b994425ecdd2dadd13744ac2a77@eucas1p2.samsung.com>
 <20190703120916.19973-1-i.maximets@samsung.com> <CAJ8uoz1Wr+bJrO+HNtSD5b79ych-pNg7BxFiHVhzaMSGGAdqLA@mail.gmail.com>
In-Reply-To: <CAJ8uoz1Wr+bJrO+HNtSD5b79ych-pNg7BxFiHVhzaMSGGAdqLA@mail.gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Wed, 3 Jul 2019 09:48:09 -0700
Message-ID: <CALDO+SYj79zCV9A85OSbMFBQeor_z=ZT305HEoK3YWtCZLeR-A@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xdp: fix race on generic receive path
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Ilya Maximets <i.maximets@samsung.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 6:20 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Jul 3, 2019 at 2:09 PM Ilya Maximets <i.maximets@samsung.com> wrote:
> >
> > Unlike driver mode, generic xdp receive could be triggered
> > by different threads on different CPU cores at the same time
> > leading to the fill and rx queue breakage. For example, this
> > could happen while sending packets from two processes to the
> > first interface of veth pair while the second part of it is
> > open with AF_XDP socket.
> >
> > Need to take a lock for each generic receive to avoid race.
>
> I measured the performance degradation of rxdrop on my local machine
> and it went from 2.19 to 2.08, so roughly a 5% drop. I think we can
> live with this in XDP_SKB mode. If we at some later point in time need
> to boost performance in this mode, let us look at it then from a
> broader perspective and find the most low hanging fruit.
>
> Thanks Ilya for this fix.
>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> > Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> > Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> > ---

Tested on my machine and works ok.
Tested-by: William Tu <u9012063@gmail.com>
