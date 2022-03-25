Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5204E7408
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 14:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344473AbiCYNRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 09:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351441AbiCYNRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 09:17:45 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFF8D1114
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:16:08 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id kk12so6127707qvb.13
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ojhQc8wwq4Mt3zqH+Tzsk4pKO2fJA+vx/nl666A8ZgQ=;
        b=kAe+D12jyP3SQQDhbwOWEkBriuyTNQIjpvtQMi89l+18wlZkQj+yA2/u7tilj8K9dY
         veMbA9FVXVU96eWrKNPoWRqKKRMpwLa1BH0z/nsITOj3zGds+BCkXKI+fdFvuKhj5IPp
         /LXW787m8+849RrG5z52dYIOa0iPlwcdR2RId6nE96ARPcBUWe0B2NjMM0+XKdRkTtJy
         7nL7m1xws16CAkMXY7JNVfJJ/a7xfokmobOjygoIctJnEDVMnECX1SS1l8bV5+7LoGqv
         LxFaR+kdQIr8cY7kTK70kIqZg0LVcdQqIl4FZ28uajByW5fRcfgs045yt8BgMwqRqoJY
         VGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ojhQc8wwq4Mt3zqH+Tzsk4pKO2fJA+vx/nl666A8ZgQ=;
        b=Odere/KVQZs2kV4v8TV5IpDApsaOB1/GCyV/OH1/bnuBNa07kh6/9R55BXBwg4NnSS
         W1TiX000dbuE49e6WLPq+EvIpFh6PjGlAD5+3OIaAdMLZaAfOnpMOv1rIYzsdrUCbq6P
         kETNRgkldiqTn2KQE7eZ8vzgqo+TCBL9QGS+JoR0e0v/kFzR5bv4HpumrBJEkWEyJi/R
         cLQzh3Hgn7NLqiFnIvWTf/Zo0cZ/Tq2sOJVjre7SF+w+/8ewYMX7EPBZsadJPfjJGEZq
         X4jiVjdoceCgE5b3GUzajbZJrxHpHw+ndl3hx9iCE4We67HBkXW+LO8ZCelni5JvB5aE
         HW4Q==
X-Gm-Message-State: AOAM532NzzZv4x13KmxiOKEjwxXtFGVuNbogVduF3mPBOcYXRp3S+gAI
        HNXjBastdqH/GVzadshPyA1bQk4qFbE=
X-Google-Smtp-Source: ABdhPJxk9OOInRW+NZ38ACToq+s34nyywBSKNA00qa7eBOX0IKbGXMybfKTdMxGtE0vVuDRBkUtOrA==
X-Received: by 2002:ad4:5bc1:0:b0:42c:3700:a6df with SMTP id t1-20020ad45bc1000000b0042c3700a6dfmr8893620qvt.94.1648214167330;
        Fri, 25 Mar 2022 06:16:07 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id u187-20020a3792c4000000b0067e679cfe5asm3207844qkd.59.2022.03.25.06.16.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:16:06 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2d07ae0b1c0so82779637b3.2
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:16:06 -0700 (PDT)
X-Received: by 2002:a81:7187:0:b0:2dd:4526:b289 with SMTP id
 m129-20020a817187000000b002dd4526b289mr10325294ywc.262.1648214166447; Fri, 25
 Mar 2022 06:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220324213954.3ln7kvl5utadnux6@skbuf>
In-Reply-To: <20220324213954.3ln7kvl5utadnux6@skbuf>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 25 Mar 2022 09:15:30 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe9hXG1x0-8e1P8_JmckOFaCFujZbJ=-=WTJW3y1sJQNQ@mail.gmail.com>
Message-ID: <CA+FuTSe9hXG1x0-8e1P8_JmckOFaCFujZbJ=-=WTJW3y1sJQNQ@mail.gmail.com>
Subject: Re: Broken SOF_TIMESTAMPING_OPT_ID in linux-4.19.y and earlier stable branches
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"

On Thu, Mar 24, 2022 at 5:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hello Willem,
>
> I have an application which makes use of SOF_TIMESTAMPING_OPT_ID, and I
> received reports from multiple users that all timestamps are delivered
> with a tskey of 0 for all stable kernel branches earlier than, and
> including, 4.19.
>
> I bisected this issue down to:
>
> | commit 8f932f762e7928d250e21006b00ff9b7718b0a64 (HEAD)
> | Author: Willem de Bruijn <willemb@google.com>
> | Date:   Mon Dec 17 12:24:00 2018 -0500
> |
> |     net: add missing SOF_TIMESTAMPING_OPT_ID support
> |
> |     SOF_TIMESTAMPING_OPT_ID is supported on TCP, UDP and RAW sockets.
> |     But it was missing on RAW with IPPROTO_IP, PF_PACKET and CAN.
> |
> |     Add skb_setup_tx_timestamp that configures both tx_flags and tskey
> |     for these paths that do not need corking or use bytestream keys.
> |
> |     Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
> |     Signed-off-by: Willem de Bruijn <willemb@google.com>
> |     Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> |     Signed-off-by: David S. Miller <davem@davemloft.net>
>
> and, interestingly, I found this discussion on the topic:
> https://www.spinics.net/lists/netdev/msg540752.html
> (copied here in case the link rots in the future)
>
> | > Series applied.
> | >
> | > What is your opinion about -stable for this?
> |
> | Thanks David. Since these are just missing features that no one has
> | reported as actually having been missing a whole lot, I don't think
> | that they are worth the effort or risk.
>
> So I have 2 questions:
>
> Is there a way for user space to validate functional kernel support for
> SOF_TIMESTAMPING_OPT_ID? What I'm noticing is that (at least with
> AF_PACKET sockets) the "level == SOL_PACKET && type == PACKET_TX_TIMESTAMP"
> cmsg is _not_ missing, but instead contains a valid sock_err->ee_data
> (tskey) of 0.

The commit only fixes missing OPT_ID support for PF_PACKET and various SOCK_RAW.

The cmsg structure returned for timestamps is the same regardless of
whether the option is set configured. It just uses an otherwise constant field.

On these kernels the feature is supported, and should work on TCP and UDP.
So a feature check would give the wrong answer.

> If it's not possible, could you please consider sending these fixes as
> patches to linux-stable?

The first of the two fixes

    fbfb2321e9509 ("ipv6: add missing tx timestamping on IPPROTO_RAW")

is in 4.19.y as of 4.19.99

The follow-on fix that you want

    8f932f762e79 ("net: add missing SOF_TIMESTAMPING_OPT_ID support")

applies cleanly to 4.19.236.

I think it's fine to cherry-pick. Not sure how to go about that.
