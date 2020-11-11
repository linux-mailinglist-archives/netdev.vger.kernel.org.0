Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33BB2AFA0D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgKKUxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 15:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgKKUxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:53:48 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F78C0613D4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:53:47 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id b129so1991302vsb.1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=psGipTvtJXXMs5tMVxJJQYxzrCJyApYy7H+utaw4tcc=;
        b=DOpXuL8IXEq3po5ARQbZ/BZ4D6V0BajyoAohVnH59fSxzrFqY+V9eUiyYezOQwGSBK
         Vu+HlzENn+hLyrhtOpjGjwHQmJ0MqpbnPJr83cLbdu4uKMsFH4ggRrKHsSmKv4JjM1+t
         pgTBI5nBQa00NVxtzchYmJJQTG1cn4RfmVtDusHKxN6eU9D5VzO/koQcdhj+CJgQ/AqK
         +WdpOTc1oS/JEW0phhjc9VkYWB8QHMjgyZsoupLr3kdO4r/P5kYuF+DdDJsytMNJxQ2N
         hDznO44SCG0wEwCJZFG6T/hJSkwQPtX3HbungD7sbYjal84Cy72UK3bxj7f4y37N+1f0
         JceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=psGipTvtJXXMs5tMVxJJQYxzrCJyApYy7H+utaw4tcc=;
        b=Mk1pSRmNiSmI5VaMIsmnS6j+GrHGeT8vA/iDpEXac9eIO2IEPoYKFj+Lavqjz3gkh6
         JuCNIXm5Qb/PmLyG2b8/zors+WC0H5VAisFj6wNR5F5K8b+UtbkzL0fJU+WoKDB/4wt/
         eS0q6tk0AbLmO0e1rysDU+2E39E6w9K4Oc4bbBulbeXN6CDgbEEDXpbKaGKKJxg7S9jn
         x95yyECBMlhuXYpXMWsxdukb4wp2GpQFpckDLr/R+K+sH9jy1sjjoVXzMEOYoYTmrHoT
         CIg2uEYZiiO940Wx1bHvRYdBKPaUQWy3jtXj/5mXU2InIivWPV4ObYFXjksOPRzWhjpd
         aPjQ==
X-Gm-Message-State: AOAM532VsG78XfjfE5N6M86XKtbY+cxAv7D1Dt0i/krtYFWnzO5nol74
        G3D+INFvArQfLAAf6xWbIZAIJ+bSwdQq/l6qppGa8A==
X-Google-Smtp-Source: ABdhPJzS2kKXaLE1TfhCz1vMvyQOow+aWmOLuUy4mXeLnBTK5hws+ZPmAbU1wUug2DBPIxCVZjIMMC3ygKzyhbnxrb0=
X-Received: by 2002:a67:7704:: with SMTP id s4mr16130547vsc.51.1605128026626;
 Wed, 11 Nov 2020 12:53:46 -0800 (PST)
MIME-Version: 1.0
References: <BWGqSgvElVUWVBHlyAGeResnioScs0ES23kwzp1JHo@cp4-web-028.plabs.ch>
In-Reply-To: <BWGqSgvElVUWVBHlyAGeResnioScs0ES23kwzp1JHo@cp4-web-028.plabs.ch>
From:   Willem de Bruijn <willemb@google.com>
Date:   Wed, 11 Nov 2020 15:53:08 -0500
Message-ID: <CA+FuTSenr+f-PxHyfP0A4Xu4QvCUSb4-zbVpUAFU05cdTRNLHQ@mail.gmail.com>
Subject: Re: [PATCH v5 net 1/2] net: udp: fix UDP header access on Fast/frag0
 UDP GRO
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 3:45 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> UDP GRO uses udp_hdr(skb) in its .gro_receive() callback. While it's
> probably OK for non-frag0 paths (when all headers or even the entire
> frame are already in skb head), this inline points to junk when
> using Fast GRO (napi_gro_frags() or napi_gro_receive() with only
> Ethernet header in skb head and all the rest in the frags) and breaks
> GRO packet compilation and the packet flow itself.
> To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
> are typically used. UDP even has an inline helper that makes use of
> them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
> to get rid of the out-of-order delivers.
>
> Present since the introduction of plain UDP GRO in 5.0-rc1.
>
> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Willem de Bruijn <willemb@google.com>
