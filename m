Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F631F899
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfEOQ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:27:07 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40324 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbfEOQ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:27:07 -0400
Received: by mail-yw1-f65.google.com with SMTP id 18so162518ywe.7
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 09:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y0Fvd931uIQ8F6pIMnDR02AXRzZtizyoB2S/6wIGolg=;
        b=Ti4U/XviximNsd/AGd5LY8AQI1do2TR6QxnqP+TdaaNVsFjx5gloNI/GcpglIPm17I
         SGYpBVyge8EX8yfihqyJUYamO87LxJY6n85TNPb+JdHu80BUwQHMzkgc/48ziOYqH1SV
         +XZgq00Hknx2pvWXPFx7kmIs73bm/Go3+FfI3MbA7X8/Ul0i3YStPqRvHqOo2FWplDfp
         3FZD43UI0NqgZhgIg2ufPFc+zT+K7L8UPYfx1zZVV0h79U6pLxLuOGMCRsBbN6eZvJG5
         OOci/FE8wEvMdHomxbk27PfwWai3ElflHhrbnAbO4SDsVyPdI8lo776x+cQScfOU+03+
         jPOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y0Fvd931uIQ8F6pIMnDR02AXRzZtizyoB2S/6wIGolg=;
        b=KUlUGOA6sFtHM/+Uuxy/IzNtjE9QTMo3yjUYcJpYuC1aLLe5PuCVeDSG0UZ5Uds3bb
         Fs+rWsCVdVzRt7oNScRK3+02f/c2Z0RZNGxREehOVGuSai1ulJFIfkPuiSfghPMGbIMm
         8H/SwNskbFYnmjdReSNcCOCbuie/BMYZxOHXG3hBGzaqer9V81YKHdPZVGcgZ952+Hb3
         FxtVovXY22SefgoI6lNGxpFW5fkE35NP08OuHCJeB3UD1sCG7TwfNERbvIiq5WPoMgrn
         jwsumpmYKX82TuwFrZdxymQ8Jrsbg3gj4RooigVEnBK5UeKdspakGdJUwpimDsBP3Wmu
         H+Vg==
X-Gm-Message-State: APjAAAWNSu6ZkpEcECKN3XulfhKemVgTtCjooEAoZ8sr43XXUhP3IKfP
        2KsBArZy3oiFfkW6xH5nlydXjejeonP1qqpEDHqb8w==
X-Google-Smtp-Source: APXvYqx7omwPuHlSVBfcK9pllK4IwDRL3ehYbjsQUgyuI4px0Lwes4o1ukIUsJd9sj16GeuEQk6Gn0Un/RsS3dWbgfw=
X-Received: by 2002:a81:c801:: with SMTP id n1mr21634942ywi.441.1557937626446;
 Wed, 15 May 2019 09:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190515161015.16115-1-edumazet@google.com> <20190515.092412.1272864626450901775.davem@davemloft.net>
In-Reply-To: <20190515.092412.1272864626450901775.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 May 2019 09:26:54 -0700
Message-ID: <CANn89i+2OuujyrwxR_n=VBwNHABai3B+0tti_jMkMU4UD1Wn8A@mail.gmail.com>
Subject: Re: [PATCH net] tcp: do not recycle cloned skbs
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 9:24 AM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Wed, 15 May 2019 09:10:15 -0700
>
> > It is illegal to change arbitrary fields in skb_shared_info if the
> > skb is cloned.
> >
> > Before calling skb_zcopy_clear() we need to ensure this rule,
> > therefore we need to move the test from sk_stream_alloc_skb()
> > to sk_wmem_free_skb()
> >
> > Fixes: 4f661542a402 ("tcp: fix zerocopy and notsent_lowat issues")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Diagnosed-by: Willem de Bruijn <willemb@google.com>
>
> Applied and queued up for -stable.

Note the patch targets current net tree, but does not need to be
backported to older kernel versions
(4f661542a402 is only in upcoming 5.2)

Thanks !
