Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CE12F2F2C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 13:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388199AbhALMdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 07:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388120AbhALMds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 07:33:48 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556FDC061786
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 04:33:08 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id d9so3559203iob.6
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 04:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Of78Vmc8hauFqd9I7zupUdsPMLB4WSeLIFBQZhkt6D0=;
        b=MKW2IKppYfWC8TX5Q9Cc26aDS0tUhLFPNRZ8DYFW6JKZxT9nhFFRNcoxJFp26Q997M
         GIAsw6oPGFbk+L12zZRfygAWffLL/ik6B7anx9Zo3V303ga1AwpRUJVwF3N9BcWrupBw
         2O8riPClVVLPU0baIWY7uACtS9lnME9uNhnVveUAkjLxeTy6Qek5bYLvuf8Ep1SUairF
         CznXKsoePlneK0AxhyXfMYoH73CuH91FGivryh1zTuYaVDBCWQXp1Vu2bogGFmr+re5b
         CrQRe7GFvBB+/LCcG+6OyWS/kcCd+yIN9ekfHj4ZJmvfprAgyl3skiRIjINvkCV+7Zbf
         1wyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Of78Vmc8hauFqd9I7zupUdsPMLB4WSeLIFBQZhkt6D0=;
        b=RopBEmAl22ispPu6OJTL8cL3UcOoTHRIbm5Mn/ccy45M5v1vJ9aYN78L9+DQDl0qYE
         pzAgf3yJKVszWXhQS+sFa6DbKUXxwX3sf0E20Ja/YW0l1Lyv2Ld6yYjsxsr4ZmWUuUYo
         JSzx83/9UrndHHFqGpb9amuiTLZ059r2T3ZtUHpiFD2PGKEDNGUUwG3sz0HhysqiQIkE
         UeD1D32wJHmsxng4pZEUbrDYLX/NNjMvV7doGmb6LMj1DzzsPUD1Liqy2A300xd+4aSm
         F5Y05QWjeZR4DhrniuMAhOaQHJNqUH6Dd6VRshqCWWeNZQRcY1d99E7phZiEsIyOio8U
         mlRg==
X-Gm-Message-State: AOAM5312wGCFPTkLuVOmT62VTjsCW9C1zruFjqddTy7tklN0dDcLPYA+
        ovTSkL0/rxGZ77IwIMRAJSGgPZXjdOQk+N1UQlj9VQ==
X-Google-Smtp-Source: ABdhPJycqY3rswN9NW/Vo08dGf7zIPK57Sy6wLEU25pmLm88I4BVOLs+rK/QLeFQiypa3Okwur/TwYIwhW8Uo+Z+/78=
X-Received: by 2002:a92:9153:: with SMTP id t80mr3776680ild.216.1610454787513;
 Tue, 12 Jan 2021 04:33:07 -0800 (PST)
MIME-Version: 1.0
References: <20210111182655.12159-1-alobakin@pm.me> <CANn89iKceTG_Mm4RrF+WVg-EEoFBD48gwpWX=GQiNdNnj2R8+A@mail.gmail.com>
 <20210112105529.3592-1-alobakin@pm.me>
In-Reply-To: <20210112105529.3592-1-alobakin@pm.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jan 2021 13:32:56 +0100
Message-ID: <CANn89i+2VC3ZH5_fyWZvJA_6QrJLzaSupusQ1rXe8CqVffCB1Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and reusing
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree@solarflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 11:56 AM Alexander Lobakin <alobakin@pm.me> wrote:
>

>
> Ah, I should've mentioned that I use UDP GRO Fraglists, so these
> numbers are for GRO.
>

Right, this suggests UDP GRO fraglist is a pathological case of GRO,
not saving memory.

Real GRO (TCP in most cases) will consume one skb, and have page
fragments for each segment.

Having skbs linked together is not cache friendly.

So I would try first to make this case better, instead of trying to
work around the real issue.
