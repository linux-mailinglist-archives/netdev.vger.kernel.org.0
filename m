Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DD52FC7A8
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbhATCTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbhATCSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 21:18:46 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A2CC0613C1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:17:57 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a12so21564087wrv.8
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yz6wfFdfCo3UBgg7PaUnLQCU68zNH/kxCjD6nCwcTnM=;
        b=K6flu++us5ywUFlcrhr5uaUwGeH9b/oQP0xrcPtxyokVef/rlgo0kqF8m+aGWI+10w
         HJ4Xf1s6i8u7yBYyRZNArgxKh9/lLm/ZyiY4RsOf6Hs4abjMkDFMN2yYJkzH0ervN8L5
         jJNicGqXN8VseBRLZ2k6busIP+Mlm3ccQ22mwHMRkZQx51bF8BD5dU+UO5Vf294fDBzG
         gTXNukj+eOAh+j2s4kpN2TIIrDaIie4FFpBbAiOOH1FkRABlKZC4hbsGSn+esqa2Gnm3
         t8zl0f7yQfv4zwZHMLZ/bBhlp65oJkS6Eh5i9LIoYhaJe61fxmhGjHzk7IoNnq6gKpAL
         1LOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yz6wfFdfCo3UBgg7PaUnLQCU68zNH/kxCjD6nCwcTnM=;
        b=F089PKfuKckUOaStiGivxa7CHBJAJlejvIjc2tEAZJFo7vskLnmTbMp7QCA0IvUqR7
         g0e2ko5wqttLlSQDT6UvHdf/QcP3asnqFN+u5by0sVbXA8MDHRLEJFG0GXxJzqS2W5Uz
         pEYAoV57O6zo+P/kSd8AIBVWj5MdKR/8eRX4q5+amHToRFcGK1BKiSEdiSJyUyxOqY1Z
         qbkItxWWGN6NUhlndH/MiHFNBC3pfaZAHs1ieASvR6Gqa7Dyz4Y94/5cbDn4STPySNwI
         oc9TUm541PfhF7Hr1CMbeN9uZiX81i6iQyE9tVF8QlhUAnFyMTDhVxTlUs/o4WuDMCGV
         JF+Q==
X-Gm-Message-State: AOAM532JnZKPT0TzyG1LE5Ml7qupWKFEeIjeQf4E3FDbI76Wq6mlJwh3
        QNoIvuXWPxU3dIi1daAY4cOdJfhLqYksDJ3+c/g=
X-Google-Smtp-Source: ABdhPJxp7M8blDXOIUg8tRYUE42Kto6cdYsRyfLu4T/KYfq3fznaMX0BW0UAgh1oOzGo7aDBXbLK5coGHv0CwbZufbU=
X-Received: by 2002:adf:c642:: with SMTP id u2mr6969358wrg.243.1611109076037;
 Tue, 19 Jan 2021 18:17:56 -0800 (PST)
MIME-Version: 1.0
References: <861947c2d2d087db82af93c21920ce8147d15490.1611074818.git.pabeni@redhat.com>
In-Reply-To: <861947c2d2d087db82af93c21920ce8147d15490.1611074818.git.pabeni@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 20 Jan 2021 10:17:44 +0800
Message-ID: <CADvbK_ddoLTOH2q2v1NJW1igXaD2pN9SpWQJ3Td9S3Dx0h0n-Q@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: fix GSO for SG-enabled devices.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 12:57 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> The commit dbd50f238dec ("net: move the hsize check to the else
> block in skb_segment") introduced a data corruption for devices
> supporting scatter-gather.
>
> The problem boils down to signed/unsigned comparison given
> unexpected results: if signed 'hsize' is negative, it will be
> considered greater than a positive 'len', which is unsigned.
>
> This commit addresses resorting to the old checks order, so that
> 'hsize' never has a negative value when compared with 'len'.
>
> v1 -> v2:
>  - reorder hsize checks instead of explicit cast (Alex)
>
> Bisected-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Fixes: dbd50f238dec ("net: move the hsize check to the else block in skb_segment")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/core/skbuff.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index e835193cabcc3..cf2c4dcf42579 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3938,10 +3938,10 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>                         skb_release_head_state(nskb);
>                         __skb_push(nskb, doffset);
>                 } else {
> +                       if (hsize < 0)
> +                               hsize = 0;
>                         if (hsize > len || !sg)
>                                 hsize = len;
> -                       else if (hsize < 0)
> -                               hsize = 0;
>
>                         nskb = __alloc_skb(hsize + doffset + headroom,
>                                            GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
> --
> 2.26.2
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
