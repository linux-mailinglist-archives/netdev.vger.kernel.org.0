Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE91104E3
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLCTPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:15:44 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:41562 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCTPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:15:44 -0500
Received: by mail-yw1-f65.google.com with SMTP id l22so1762460ywc.8
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 11:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8t7GxiCs+7hODF/V957xSVUj2w/IJpHn8ImHk85xhU=;
        b=CphqidHiNGcrW2L4zN25zRdQR7HK0omBTyYDOEsMT+9uYvUehvo5BAC43WeMH9+6qX
         oIPvf+CanTmpMqCZss7/v9NpIybW+oV2NaNcMmKeGXO+OMYJNouyE8xxv6bvS0EYWVHp
         H/zvpbMqdqEr9pNlAU0lT1hKjFQUL4CsX+678KyRgORDN9kqJ1EL0EIGYn2C2lI2fKsu
         oVK45hirB/pyhnae3Dt0x0NJIt1TeowNupWxO2berj8bRDvqOa37fc6U7C1i3ZqNUFqX
         0NGlWbuaKcc083zAQ5Ln1oVCAj82hIaFqRtyM+t1Wo9rXBHvIUMt7Sw/6towTGwMkBnK
         tQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8t7GxiCs+7hODF/V957xSVUj2w/IJpHn8ImHk85xhU=;
        b=uIlT1AiCegNL8KgSvRdXdVCs6I47BFAuin5DYJRb/bJpGi0j6lX0mlpJBN74D71eTs
         W5gTee0wcuv/nGrf4+8RgmAB7G01zj2YpmF2QylHwJD84UXDl87rngwRAx4QeTQPBe2R
         JnYTh5b5oqzGfHPivpSNE07HV8UttD/iHWq5McUfEmn8grqHdQEux1tRIQ83CJ7ntq6G
         2o08ZgRct6xidaf+cSrZvTMPn0nuEWGjG/2MgtUxuLq6tUYZXozbXjwnTSv0/SZGv+Jz
         lJVWgwtNmXcbTLxQ1H30TR9sSDEnZFQlF/r7eKXEmmKcj6Yr/vTxy8xM89dMc+t0lmeF
         gfJA==
X-Gm-Message-State: APjAAAVUnQ/mKJI+RuimTbysle92xOmIskE88I5eF/vjYSSQ4hwAJof8
        9J5nTISV3Cxy7nB8ODjCOQBqLlzjH6VEc6HJEdt5xA==
X-Google-Smtp-Source: APXvYqyJ8WQ/oIcUfEi+59zPDQ1STsP9Qbt+oTC9UwPWvo+j7n7eKpHcF8jsmxCx8BiM9h4370BkdLINOX1LXaLkv3E=
X-Received: by 2002:a81:b38a:: with SMTP id r132mr5429829ywh.114.1575400542897;
 Tue, 03 Dec 2019 11:15:42 -0800 (PST)
MIME-Version: 1.0
References: <20191203160552.31071-1-edumazet@google.com> <20191203191314.GA2734645@kroah.com>
In-Reply-To: <20191203191314.GA2734645@kroah.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 Dec 2019 11:15:31 -0800
Message-ID: <CANn89i+LK6wHWStHTn3swgx8KDGQ2VMULk59JaRWi599=yx2pw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: refactor tcp_retransmit_timer()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 3, 2019 at 11:13 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 03, 2019 at 08:05:52AM -0800, Eric Dumazet wrote:
> > It appears linux-4.14 stable needs a backport of commit
> > 88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")
> >
> > Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
> > let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()
>
> So does that mean that 4.19.y should get 88f8598d0a30 ("tcp: exit if
> nothing to retransmit on RTO timeout") as-is?
>

Yes indeed. All stable versions need it.

> > I will provide to stable teams the squashed patches.
>
> This is that squashed patch, right?

Yes, both patches squashed to avoid breaking future bisections.
