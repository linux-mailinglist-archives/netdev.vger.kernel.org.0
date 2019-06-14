Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC78460A4
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfFNOZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:25:36 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45115 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbfFNOZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:25:35 -0400
Received: by mail-yw1-f65.google.com with SMTP id m16so1153982ywh.12
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 07:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LYUOOkbDEtc/n63J16wUInERrQ528yDBZpQw3peOe88=;
        b=qdBwUMaogc4xCMq8nYw9mw2BMaMCPofGrk0xtOBNrpZEcRu8ecbbJ2gRK++oUcFy5b
         zAxEFOZ7dWU6kj3Ouu7nkjWPiydd/HSwZxS/h/cGqhS3MtTsHYGuQN5gngcAEM1zFfvt
         xVTnTxA9dwYp0gMCXIHvKHhQGaYH1fCGFSdEVNMc3UAteWux7Y/PkW9pDXN3mkdJR8GH
         jY+2SPuU5r3E46sRf3k2E/ocAcEvf1O3JOtjWHiCG6klFVJTxwIXOLK5Mutg+7UP711J
         lai7oSTxDPCXXYbW8eLZR97IKWFsrUGD7Tlng14vj4yvsBKs7tyP3PIG9rt3QXh1pSnZ
         8puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LYUOOkbDEtc/n63J16wUInERrQ528yDBZpQw3peOe88=;
        b=Sm6fA0JUKLJjt3FHMBBtzp8FjysPmPWas1zd4fZ9pDP/E1lWhT0VkozikIhFCYmNsG
         WNkEGFC5BmlpAPk1stTp9pLnsAFFSFI5uixRmKFljpKiAx4anL82sM4t5fagsAsLkhIJ
         ZgF/FomWquxsJEDfPvYgu9BOMP5Ip5YKgimtKeQgcogK9lbYyFcw+FUz60dretnyUxHs
         Mye8qEcRmD5pdZZN0I03a/RujtB2JTBfqGohD+OvuotyqWoZl4YGoUZ/ZuETWnbVSGGA
         FpawkaMa5uLoElaPQEluZa3xH9ZrIVz8u/xW/zPJp0y5w04c/w9dNBgg+H6uUdj/w47/
         RKsw==
X-Gm-Message-State: APjAAAUM9Y5ysdJXM9XGsWO+untKJ0So3OMGnGWO2tTMHLrXXpaIm0h+
        9ERiAzW7dnOeGIKtRYdxNOFRfDVF535nlCH7aLrPbg==
X-Google-Smtp-Source: APXvYqx1FaR3U1ZRHnOIFijrW4O3vjCsEduL+I5+YOFpO4Kz+puzSgk1iHxjH/mPPRVyJyb5GOmSOewLXM7BlC+xBRc=
X-Received: by 2002:a0d:fbc6:: with SMTP id l189mr34021112ywf.135.1560522334672;
 Fri, 14 Jun 2019 07:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190612035715.166676-1-maowenan@huawei.com> <CANn89iJH6ZBH774SNrd2sUd_A5OBniiUVX=HBq6H4PXEW4cjwQ@mail.gmail.com>
 <6de5d6d8-e481-8235-193e-b12e7f511030@huawei.com> <a674e90e-d06f-cb67-604f-30cb736d7c72@huawei.com>
 <6aa69ab5-ed81-6a7f-2b2b-214e44ff0ada@gmail.com> <52025f94-04d3-2a44-11cd-7aa66ebc7e27@huawei.com>
 <CANn89iKzfvZqZRo1pEwqW11DQk1YOPkoAR4tLbjRG9qbKOYEMw@mail.gmail.com> <7d0f5a21-717c-74ee-18ad-fc0432dfbe33@huawei.com>
In-Reply-To: <7d0f5a21-717c-74ee-18ad-fc0432dfbe33@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 14 Jun 2019 07:25:23 -0700
Message-ID: <CANn89iJW0DHBg=RKgdLq1r33THL15UO3c2n4MkR6DdD7-QwP1w@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
To:     maowenan <maowenan@huawei.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 7:04 AM maowenan <maowenan@huawei.com> wrote:
> I agree that this is a special case.
> I propose one point about the sequence of synack, if two synack with two different
> sequence since the time elapse 64ns, this issue disappear.
>
> tcp_conn_request->tcp_v4_init_seq->secure_tcp_seq->seq_scale
> static u32 seq_scale(u32 seq)
> {
>         /*
>          *      As close as possible to RFC 793, which
>          *      suggests using a 250 kHz clock.
>          *      Further reading shows this assumes 2 Mb/s networks.
>          *      For 10 Mb/s Ethernet, a 1 MHz clock is appropriate.
>          *      For 10 Gb/s Ethernet, a 1 GHz clock should be ok, but
>          *      we also need to limit the resolution so that the u32 seq
>          *      overlaps less than one time per MSL (2 minutes).
>          *      Choosing a clock of 64 ns period is OK. (period of 274 s)
>          */
>         return seq + (ktime_get_real_ns() >> 6);
> }
>
> So if the long delay larger than 64ns, the seq is difference.

The core issue has nothing to do with syncookies.

Are you sure you really understand this stack ?
