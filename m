Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177B53984A2
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhFBIzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhFBIzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:55:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A605C061574;
        Wed,  2 Jun 2021 01:54:05 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u7so762358plq.4;
        Wed, 02 Jun 2021 01:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3jN1riE8G5x/joSgn6CfxsOWR+MfQo/IZ4OM91hdWRU=;
        b=XZU0/5kihTt1Fi5lrecm22ldzuh1Z2j9FstXTpn0PlY3qTcINdmC9RcSfoEQ1xiXMA
         95aXNc3q/HsQL1Jk6ygkSS2wXzcHu9SARdpmZ7gSJUqXYsJjwcsXw38kE+AZ+nvglZef
         34RV21IbdUiRv6IbsE552aI/z6s456Eai+7IqCa+klsJAEXqdFQUlWraEPHrOBUf/dwg
         TyNG9gUOMNvvxqVqQM09JXxM1KUjjk5XACh0Kn5vkBWHenlzVT8DxUa+iQIHcb2GDUV1
         bYcULpOBdi/vB6bgwU1Y+d26N3F6n69AVqUJxkn7X7cb9SMjRHL1/kBUZ172oBIwSn1i
         uTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3jN1riE8G5x/joSgn6CfxsOWR+MfQo/IZ4OM91hdWRU=;
        b=cR5Znf4kYnsL4VLEIWpEgi6RZPT+vOjBiVLILXFtJc79ZsiFoEAJoIvtrRHiWvpW/p
         R46F7uTVQ/GcZHHnaYYt87jxq6XFIP6CBGHFg6p+W0JM26gIfMHjATjustemsS0bQMV1
         DE9QvpT86agJGPL3fehMuWRqgBBdhFCUTmdNwjYmbgJpuwJLlYrpbovoX/o7x41xyX3c
         eLOzj+Te5FAIvQJkAQUMG2LyrsRsqpdFNe9nBBpefq9FaJATE/CXL1KK7URJpUjAYEB5
         1B8jRj7TeSc6Rgil6jXMa4gPrvcr/dU1cneTJhkk17drIqXNKDc+b9jWmia9Qe6FGZTI
         oIIQ==
X-Gm-Message-State: AOAM533Cak8UnsW5SCW5tBxxwLz4ISULegfphUdas6H30VIIMFI2Qxe1
        eH1jOQkhlMDoPpyTTTQRLYJ0HhB9/5vaPw+RwfY=
X-Google-Smtp-Source: ABdhPJyam0wFcKF8z4CzmgGzK2e/33Enjt0y/yByEDIOJq499UTxgEmKGB9lI6M+5aRiSprbuu7B+8ipdGhw2VfN5ws=
X-Received: by 2002:a17:90a:a08c:: with SMTP id r12mr4431756pjp.204.1622624045045;
 Wed, 02 Jun 2021 01:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210602031001.18656-1-wanghai38@huawei.com> <CAJ8uoz2sT9iyqjWcsUDQZqZCVoCfpqgM7TseOTqeCzOuChAwww@mail.gmail.com>
 <87a6o8bqzs.fsf@toke.dk>
In-Reply-To: <87a6o8bqzs.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 2 Jun 2021 10:53:54 +0200
Message-ID: <CAJ8uoz1_fzpZkKZd=h=tEQG7_V+waYjGN5ocnC29pPaBGLrg4w@mail.gmail.com>
Subject: Re: [PATCH net-next] xsk: Return -EINVAL instead of -EBUSY after
 xsk_get_pool_from_qid() fails
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Wang Hai <wanghai38@huawei.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 10:38 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Magnus Karlsson <magnus.karlsson@gmail.com> writes:
>
> > On Wed, Jun 2, 2021 at 6:02 AM Wang Hai <wanghai38@huawei.com> wrote:
> >>
> >> xsk_get_pool_from_qid() fails not because the device's queues are busy=
,
> >> but because the queue_id exceeds the current number of queues.
> >> So when it fails, it is better to return -EINVAL instead of -EBUSY.
> >>
> >> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> >> ---
> >>  net/xdp/xsk_buff_pool.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> >> index 8de01aaac4a0..30ece117117a 100644
> >> --- a/net/xdp/xsk_buff_pool.c
> >> +++ b/net/xdp/xsk_buff_pool.c
> >> @@ -135,7 +135,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
> >>                 return -EINVAL;
> >>
> >>         if (xsk_get_pool_from_qid(netdev, queue_id))
> >> -               return -EBUSY;
> >> +               return -EINVAL;
> >
> > I guess your intent here is to return -EINVAL only when the queue_id
> > is larger than the number of active queues. But this patch also
> > changes the return code when the queue id is already in use and in
> > that case we should continue to return -EBUSY. As this function is
> > used by a number of drivers, the easiest way to accomplish this is to
> > introduce a test for queue_id out of bounds before this if-statement
> > and return -EINVAL there.
>
> Isn't the return code ABI by now, though?

You are probably right and in that case this should not change at all.
It has been returning this for quite a while too as it is nothing new.
But I leave the final decision to other people on the list.

> -Toke
>
