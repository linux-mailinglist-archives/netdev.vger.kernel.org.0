Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68775296EE
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiEQBua convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 May 2022 21:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiEQBu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:50:29 -0400
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2282827CEF;
        Mon, 16 May 2022 18:50:28 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id d137so10929718ybc.13;
        Mon, 16 May 2022 18:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HAQnHQkvvpfj4UWRUX9L3RaXSVUszfpcXLBvvM7+tw8=;
        b=wQ/ypxNrN/iFv/cYUPJTwpSSUQfSVV4XBxNYHrhMzbE6qeig8gfdHPWrdmflUMrSvT
         0ztNqrzrKLF0el2nmh499EWRDRcPesDezAMatL4pBxTPhk7Lc7Qe2t4Um0DqdEhZSB1s
         cuBdsqbyHNFh9QJod8aQv8qBFaw4gNPqXDyTSgtPORFDtsCntfvj76iq8lOD87f1LLIV
         JPto/tFGLu4KgaxbbeHy/TLyYgObXcedowQx6gdsiBnmo09PYLvPKO341TiEXcoE9EJB
         NfHqak5lHXt4r+qts9DDjRWYMbNAmLeK6yECp9Vd2JrjBVRbAv4tvts8N1HB7E+B0uJH
         zqbQ==
X-Gm-Message-State: AOAM5336sowx5yL7EB8UAqb9kAGx2qftzWKkUGIXgB3dyE8O/v/mUCM/
        DhAuFMh2zeQvzJ+zw29jjTli8WPpt4+ZStvNkSg=
X-Google-Smtp-Source: ABdhPJzWdOTPcCnkYNgmduZHSmNH9ivwxv5LGSE4dNqt9li2/a5ScUyfMMUVpuGjRGzeql3MBWJuqzLaGVHVm2b4LHk=
X-Received: by 2002:a25:e093:0:b0:64d:6c85:6bc6 with SMTP id
 x141-20020a25e093000000b0064d6c856bc6mr12326409ybg.500.1652752227297; Mon, 16
 May 2022 18:50:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr> <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
 <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
In-Reply-To: <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 May 2022 10:50:16 +0900
Message-ID: <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Max Staudt <max@enpas.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oliver,

On Mon. 16 May 2022 at 04:17, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> Hi Vincent,
>
> On 14.05.22 16:16, Vincent Mailhol wrote:
> > The functions can_dropped_invalid_skb() and can_skb_headroom_valid()
> > grew a lot over the years to a point which it does not make much sense
> > to have them defined as static inline in header files. Move those two
> > functions to the .c counterpart of skb.h.
> >
> > can_skb_headroom_valid() only caller being can_dropped_invalid_skb(),
> > the declaration is removed from the header. Only
> > can_dropped_invalid_skb() gets its symbol exported.
>
> I can see your point but the need for can-dev was always given for
> hardware specific stuff like bitrates, TDC, transceivers, whatever.

I also see your point :)
Actually, I raised the exact same idea in a previous message:
https://lore.kernel.org/linux-can/CAMZ6RqLU-Wg0Cau3cM=QsU-t-7Lyzmo1nJ_VAA4Mbw3u0jnNtw@mail.gmail.com/

But you were not in CC and it seems that there is a lot of congestion
recently on the mailing list so I wouldn’t be surprised if you tell me
you did not receive it.

> As there would be more things in slcan (e.g. dev_alloc_skb() could be
> unified with alloc_can_skb())

And also the can_{put,get}_echo_skb() I guess.

> would it probably make sense to
> introduce a new can-skb module that could be used by all CAN
> virtual/software interfaces?
>
> Or some other split-up ... any idea?

My concern is: what would be the merrit? If we do not split, the users
of slcan and v(x)can would have to load the can-dev module which will
be slightly bloated for their use, but is this really an issue? I do
not see how this can become a performance bottleneck, so what is the
problem?
I could also argue that most of the devices do not depend on
rx-offload.o. So should we also split this one out of can-dev on the
same basis and add another module dependency?
The benefit (not having to load a bloated module for three drivers)
does not outweigh the added complexity: all hardware modules will have
one additional modprobe dependency on the tiny can-skb module.

But as said above, I am not fully opposed to the split, I am just
strongly divided. If we go for the split, creating a can-skb module is
the natural and only option I see.
If the above argument does not convince you, I will send a v3 with that split.


Yours sincerely,
Vincent Mailhol
