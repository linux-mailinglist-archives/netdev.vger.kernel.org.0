Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3745563648
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiGAO63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGAO62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:58:28 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4A81CB0F
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 07:58:27 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3178acf2a92so26252427b3.6
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 07:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A+uIirz6Z40RKlayzkCmwx6QqczAjb5evF+ivkFEv8M=;
        b=ZAdMk7EdGv35WC0XPfPubzVzl+2zaLEnn1pxZXjWfHcs8fCvF5YHlWd7uFJ8F47ynP
         fYMqdT/6Ub5AMgBAGiz1J+nh1L7+g2dyE00czBBdsq5gkrxpa0sGftdOESc3XDrALC5l
         +2DpqaHTVcs6Z8U4teO08h45RwMg3a3JCXotTB1yWo1PHyfqATHjAVOQbZASy2v7jcEW
         FHlzZHJeVBVhAy8+99M70xZjPLOW2+8nvIYSkvxqOrBOEKlqwg9P/kerudnY1KcwTVbN
         +BNkttlWxVQjKlJYP0B9as3vlSY7Ho56tUFoOtQWZR5Fq7JnBJ7MBXpeRbkAascueDjR
         1Vmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A+uIirz6Z40RKlayzkCmwx6QqczAjb5evF+ivkFEv8M=;
        b=OuItxmUB4yLne3Vg693f529/6+xiHluqaTSnTOy2hFrKxbn9R9fMxE3WFq6lnZoXHB
         77eJcJnxz2qlRiolqC0YxTztvQ6RCrGl9DhyZlEfl602fgQR2NsNgyLgSOj5DZ7tt+hE
         RXTff1meDaWafsLM7erJy5QCj1LErkG4MO3fwDOOZf1p+clCLNtXtI66tToxn/BpWh8s
         qOj2LPcoI1K5k1JTp6kp3CMJxU5lSoaxcEugaNiz/8UYvv3Jx9ijc47bx7JVO1XYqOCx
         o+uDNnn80D9b20yH1b0ERIh4IjT/k3MCuWl+rbJxn+y6gdnFCiwyeAu1WMTJkUS3LnLp
         53Sw==
X-Gm-Message-State: AJIora8VeQfkjqcZEyiJMDlYZDXYWvOyla9mCp7G3NPhlM9NJOyXv+LX
        liHI4ouNZnukYRRpmvIiRjLasC8dI6UdWCAY3pxMZA==
X-Google-Smtp-Source: AGRyM1vklhtlCV9UGa1JfQODih687wjCSy9kH9Sl6nWwuug+snorhdiQ9rNausNu2/6S40BlBZRGzRb7G+PShYm80SU=
X-Received: by 2002:a81:600a:0:b0:318:81bc:e928 with SMTP id
 u10-20020a81600a000000b0031881bce928mr17472369ywb.119.1656687506372; Fri, 01
 Jul 2022 07:58:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
 <CANn89i+FZ7t6F6tA8iFMjAzGmKkK=A+kdFpsm6ioygg5DnwT8g@mail.gmail.com> <73774e57-64c3-e32d-d762-1fcf64d5628c@iogearbox.net>
In-Reply-To: <73774e57-64c3-e32d-d762-1fcf64d5628c@iogearbox.net>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Fri, 1 Jul 2022 16:58:15 +0200
Message-ID: <CAM1=_QR07rRTA5bdRScXnR5uA-GayXpbXAi2htX37uWwm+v9SA@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: Fix spurious packet loss in generic XDP TX path
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>, song@kernel.org,
        martin.lau@linux.dev, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 3:29 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/1/22 11:57 AM, Eric Dumazet wrote:
> > On Fri, Jul 1, 2022 at 11:43 AM Johan Almbladh
> > <johan.almbladh@anyfinetworks.com> wrote:
> >>
> >> The byte queue limits (BQL) mechanism is intended to move queuing from
> >> the driver to the network stack in order to reduce latency caused by
> >> excessive queuing in hardware. However, when transmitting or redirecting
> >> a packet with XDP, the qdisc layer is bypassed and there are no
> >> additional queues. Since netif_xmit_stopped() also takes BQL limits into
> >> account, but without having any alternative queuing, packets are
> >> silently dropped.
> >>
> >> This patch modifies the drop condition to only consider cases when the
> >> driver itself cannot accept any more packets. This is analogous to the
> >> condition in __dev_direct_xmit(). Dropped packets are also counted on
> >> the device.
> >
> > This means XDP packets are able to starve other packets going through a qdisc,
> > DDOS attacks will be more effective.
> >
> > in-driver-XDP use dedicated TX queues, so they do not have this
> > starvation issue.
> >
> > This should be mentioned somewhere I guess.
>
> +1, Johan, could you add this as comment and into commit description in a v2
> of your fix? Definitely should be clarified that it's limited to generic XDP.

Thanks for the review.

Daniel, I will prepare a v2 shortly.

Thanks,
Johan
