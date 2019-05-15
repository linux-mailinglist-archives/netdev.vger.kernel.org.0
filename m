Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40271F8E6
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfEOQrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:47:25 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46668 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfEOQrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:47:25 -0400
Received: by mail-yw1-f66.google.com with SMTP id a130so169104ywe.13
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 09:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SSRGKlLmr1Q7WKzzcRfPfiaWqPnAH5WZISRsySpgCCU=;
        b=WgvqUl1DYY8wUllT1U81kO5lzadR17eH5i/w1ZBeMWDswXDvWyHtA+BKkj8ayPwwih
         NkresyuMpiTTP5kNSKAmIOMCkJRam2YRh1AUkgeBAHMf0YksuN17VsvUeYR56fL7XvTD
         7p+IsVRDfkp0rFPK9eRbD9UlhZCYxD0hxaCBqrk9Iwz51M+LNaroTJa1bYdyJyxy4VPt
         JkmlwNRXLFLw5E/WzAHp84zPa8k6+PDjXaaEK1S0ZpC2uu1LyXDdQMrN9Nffmz8AxBiT
         Bpfj6xSOBpSLmNd6BA2LorixUS5B7pOaKFzoFgbVer6X+MVq3oHH45bpQZfOL+dlCl5y
         8xJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SSRGKlLmr1Q7WKzzcRfPfiaWqPnAH5WZISRsySpgCCU=;
        b=CSRwMZ8mysatPh3dWVqfOEQTCKXQs0HJe+0fOU0rBO1zKakqOPQVx3JnOXxf6Kgms/
         h5YkoNmbB1LKB1+RxYpB6gbZXDzOOg2XjOLjPCuLKe3lWF+onRvWFvbiSXjbBxaxIuHm
         BU2DDGbklTWTn+tqU5ChpNzpmDL6upYF4OLh3MSyPyoTNwrV/B3VLDJ5UgH8XW1GLkfJ
         nH0gLVsGOnY1q9yiXIgMwxoK8jzbsLoPP4RrxIEz96V65C0iEcg2V5aghdoH1ZDxfw1M
         JAuSpWcqF+Eicf2i2w/DVUDrGNzzN75DSWd3PLQosg3AW2LxTPTx9Niv+T5ItQAar7Hq
         kvJQ==
X-Gm-Message-State: APjAAAWv8ccn3/2jHottRVIw01VRhtRPS411khCpH799FIArU8xsZ23L
        AZPnwi+zuBFlvWIfbJ3obe9xKjZnQjUDa4ujucUUi8OOAw1ZVg==
X-Google-Smtp-Source: APXvYqw/KDVGZc/iA029Jeo0pCjLR8fnJ11DnPkXBhxJlvG30OWeqIgQHamsJ3HIyb7KjVbsc8b0R8P5xe6JE3eg7DE=
X-Received: by 2002:a81:a8c9:: with SMTP id f192mr4422536ywh.37.1557938843884;
 Wed, 15 May 2019 09:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190515161015.16115-1-edumazet@google.com> <20190515.092412.1272864626450901775.davem@davemloft.net>
 <CANn89i+2OuujyrwxR_n=VBwNHABai3B+0tti_jMkMU4UD1Wn8A@mail.gmail.com> <20190515.094150.697892727321848072.davem@davemloft.net>
In-Reply-To: <20190515.094150.697892727321848072.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 May 2019 09:47:12 -0700
Message-ID: <CANn89iLo5rdV2WJyuxwSEC9QntsvuKaLsuE27qvqrYQ1vqvTJg@mail.gmail.com>
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

On Wed, May 15, 2019 at 9:41 AM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Wed, 15 May 2019 09:26:54 -0700
>
> > On Wed, May 15, 2019 at 9:24 AM David Miller <davem@davemloft.net> wrote:
> >>
> >> From: Eric Dumazet <edumazet@google.com>
> >> Date: Wed, 15 May 2019 09:10:15 -0700
> >>
> >> > It is illegal to change arbitrary fields in skb_shared_info if the
> >> > skb is cloned.
> >> >
> >> > Before calling skb_zcopy_clear() we need to ensure this rule,
> >> > therefore we need to move the test from sk_stream_alloc_skb()
> >> > to sk_wmem_free_skb()
> >> >
> >> > Fixes: 4f661542a402 ("tcp: fix zerocopy and notsent_lowat issues")
> >> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> >> > Diagnosed-by: Willem de Bruijn <willemb@google.com>
> >>
> >> Applied and queued up for -stable.
> >
> > Note the patch targets current net tree, but does not need to be
> > backported to older kernel versions
> > (4f661542a402 is only in upcoming 5.2)
>
> Doesn't it fix a fix for something in 5.0?

Hmm no, the whole thing is new for 5.2 only.

commit 472c2e07eef045145bc1493cc94a01c87140780a
Author: Eric Dumazet <edumazet@google.com>
Date:   Fri Mar 22 08:56:39 2019 -0700

    tcp: add one skb cache for tx
