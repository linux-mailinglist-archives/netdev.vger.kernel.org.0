Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692FF352AD7
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235479AbhDBMxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbhDBMxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 08:53:03 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75313C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 05:53:02 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id j198so4989188ybj.11
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 05:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PIlwWyEUVKj7rG8Uiny+3sdvlwksHBpS/h835e2OjBQ=;
        b=GKJeItfMNFmpl+0gwLA2YTk1mB7dKLHIDu4je12hMXqfkzQGoOGnf65TdEYlMo817W
         aJIk9qbn7ue9Y5LEQmGAt3U8nRebiKm6caVR6UukUI/S3ZBJqYe/2OSvUUZHuv+wNI+j
         tKscugZq8mElgEXS/JSD1lpRPURBR7iuL2Be3Wwi0k3lk6F3rOnJpHw+KjE+z//oWv/S
         JoX0d4sncfUo14mbV5x01DcC2UlZin84HRLhGwCkv5xRIouDCEM65SjmVyitD0QTVjfz
         yFqGHGLeiKkfV0TEpHXyYUFdP9ZutugDwMzqmTLW3DfGT067LNkvaWmjZgw9ik1x6jFx
         lM6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PIlwWyEUVKj7rG8Uiny+3sdvlwksHBpS/h835e2OjBQ=;
        b=oSrjnIjoXvm846Qq4CaR0Kcyw64Gi6euBEUJII+yITiGeJKMDri0tnzEOxRKaRPxKu
         6uc7nzONf3nDBOvjhSzB9Nm/A70WnNTUSK6jgwRsx02WmbxusBfl/bw1kDmXg7BB/KoN
         HFOkvheGcoJWr2j2eTiqEHwe0p/fuigiF6HHy1CeY/NbfANLYywOMG+lX9y7alqiTtWf
         Tb6/2Vm9howh64z6zrtzyqjMSOkEMa9RQPMjW6ghZ4DRnhF1EyfCJDXqvIwonpFsiK9j
         L2c5k4WfraoJKmWk7wPEE/mr9KAV+F0oOFCOAJ8J0XU085meJtKNGDQK7JuyeWqBYngk
         HKEQ==
X-Gm-Message-State: AOAM5303Nkf1XxlJRFuF2GULf/3uDn6HK52oGIEneYT7Ik4uvhrJX8d1
        mabDPNRoWk5Muoy7SjrRT+O2eZ0YxpZYXo3k0/Ua8VwlDvw=
X-Google-Smtp-Source: ABdhPJzE207yt1ZmCYKl9EVW5LZrbXRUXikg3yeaCsMxG9kjdGzJZ6+z2vRRk6oVlmPZH4RUSvO1si2NN4fBMxdcSq4=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr18547757ybc.234.1617367981342;
 Fri, 02 Apr 2021 05:53:01 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+Sh3UXyfVb+X2AuXL6swX-8mrK++yn7y11EUnWRSd5HA@mail.gmail.com>
 <1617357110.3822439-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1617357110.3822439-1-xuanzhuo@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Apr 2021 14:52:49 +0200
Message-ID: <CANn89i+WiW+1KGVKqLZ8xQpUaZYywonZLCnkVGzRawFv=YeLzg@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 2, 2021 at 12:35 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
>
> Great!!
>
> test cmd:
>         sockperf tp --tcp --ip <ip> -m 8192 -t 300
>
>                 server softirq cpu | server sockperf cpu | rxpck/s | rxkB/s
> page_frag_alloc 100%.                86.1%                 2211785   3270145
> kmalloc         100%.                100%                  2226950   3292571
> copy ETH        100%                 69.3%                 2140552   3163408
>
> Compared with page_frag_alloc, the performance has also increased by 19.4%. The
> reason for such a big improvement I think is that although merge is turned on in
> my test environment, there is only one buffer for each packet received.
>
> So in the page_frag_alloc scenario, when performing gro merge, one skb will
> occupy two frags, one is used to store the data in the linear space, and the
> other is a frag in the skb frags. Now, the linear space only has the header, so
> one skb only occupies one frag space.
>
> In the case of using page_frag_alloc, an skb can only contain the original 8
> packets. Now a skb merges the original 17 packets

Exactly. Never put payload in skb->head, unless you are sure that :
1) All payload can be put there. (or it is filling a full page,
followed by remaining payload in further frags for big MTU)
2) skb->head is backed by a page fraf as well (skb->head_frag == 1)

>
> It's really exciting.
>
> I fixed the retval check of pskb_may_pull and added a pskb_may_pull call.
> Here is the patch I used for testing.
>
> Thanks very much.

Excellent, I am going to submit this patch officially, since it is not
risky for stable kernels.
I will give you credits as Reporter, and co-developer.

Thanks for your help !
