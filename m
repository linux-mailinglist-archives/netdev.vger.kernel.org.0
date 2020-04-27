Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706261BAE8F
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 21:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgD0T7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 15:59:00 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:58805 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgD0T67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 15:58:59 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 42fa0f8d
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=l1ADPTBs4T7WqocE/eSPRPzKf6M=; b=SvideG
        fiMNIvjKADMf+UYBHqv4bDCENAzjkSkPQSqN+Iq44AneysIKlUVfVKfJX1hVHVGs
        DwbKb+JhuuD9af+ve5NgFe7/iVQjhGH6RMHDFoZYnqU2Qs2jio8+mbu2IuziVBVM
        cJchS7l3SBQ+nYvMQ2TZtDSIxaKUK7PBUfIseB/JB6Dmd16X+5lAN3zpJIVUNHpj
        nZJiunbj/vtPQJ9x5pH8IYJKmB9BNmDcrBwjp9kFtIdZtDQLSnlXGzGKqxxVDnX+
        HoYVRTkyXbVReRqePHCK6RYS9ooJqNC+S+yLqaxRo/+7OFtPOwX58O2szwyBf0xQ
        hMQVSRIRXUy/xaCg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 43a67c49 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 19:47:24 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id w6so18017777ilg.1
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 12:58:57 -0700 (PDT)
X-Gm-Message-State: AGi0Pua1ouJPQ/LsWlWs9mQF6WpUJ+eS7taNuLQpI4IetWLMPg0kVFz+
        Bl9nGBzPs0VbOg7ZzXd1Wz4w9C9klV2a343KW9A=
X-Google-Smtp-Source: APiQypIo9n9BcqE1Mdqcd32wzkZTXsZKxjZ76pEQbU+5XYtLYPR4jkmGzDxOWCa0m3gaP7x/Y9evg0fsjAAR2pz2/h4=
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr23504155ilm.38.1588017536771;
 Mon, 27 Apr 2020 12:58:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com>
 <20200427102229.414644-1-Jason@zx2c4.com> <58760713-438f-a332-77ab-e5c34f0f61b6@gmail.com>
In-Reply-To: <58760713-438f-a332-77ab-e5c34f0f61b6@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Apr 2020 13:58:45 -0600
X-Gmail-Original-Message-ID: <CAHmME9oygxd=Sa5PvXWYm7Mth4tc_LfqnZXM+XrHuouKP1AQxg@mail.gmail.com>
Message-ID: <CAHmME9oygxd=Sa5PvXWYm7Mth4tc_LfqnZXM+XrHuouKP1AQxg@mail.gmail.com>
Subject: Re: [PATCH RFC v2] net: xdp: allow for layer 3 packets in generic skb handler
To:     David Ahern <dsahern@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 8:45 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/27/20 4:22 AM, Jason A. Donenfeld wrote:
> > @@ -4544,6 +4544,13 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
> >        * header.
> >        */
> >       mac_len = skb->data - skb_mac_header(skb);
> > +     if (!mac_len) {
> > +             add_eth_hdr = true;
> > +             mac_len = sizeof(struct ethhdr);
> > +             *((struct ethhdr *)skb_push(skb, mac_len)) = (struct ethhdr) {
> > +                     .h_proto = skb->protocol
> > +             };
>
> please use a temp variable and explicit setting of the fields; that is
> not pleasant to read and can not be more performant than a more direct
>
>                 eth_zero_addr(eth->h_source);
>                 eth_zero_addr(eth->h_dest);
>                 eth->h_proto = skb->protocol;

Ack, will change for the non-RFC v3 patch. I need to actually figure
out how to test this thing first though...

Jason
