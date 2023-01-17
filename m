Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BBC66E7BC
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 21:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbjAQUhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 15:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjAQUaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 15:30:09 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B7B3D93D
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:16:35 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id q141so12674606vkb.13
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sQ0fqePd9cg0iYOXvStS50d7S3Cj+Hdty54/rrVz/Dk=;
        b=EQFnYxXINy8pwKk7Qqs0HDK/dwbmPl2e5y5bew0TUUHYmdglT+3uSncXO+C3hZ84vI
         tUz8RXECdNrhymMrTDwzPs7Wq1TNC8Ze3XPV0OpdZUxCQg8KY2ip9TXYvDsn8A52JCJ6
         vHQ8kvhOfT8g5F+qPqK2u/HCDUdp7/omJp0QI3X9VKMDoo/vLhLynkl/C82UIlG3lx+I
         SEwPmOhNrfv25rNcvpCOY4JkQxeU3ZWpwdy/LxRSiIOO9ycKoHbmQQ/E+sN+F9YrKk/+
         BlVDfFOIbAD3vu50eqqzsWFxaT2Ts9pZ7b7SxVylnUkPOi8SP99v4nXd4Q78nNGSEksz
         ne/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sQ0fqePd9cg0iYOXvStS50d7S3Cj+Hdty54/rrVz/Dk=;
        b=pCoZHDikDyLGsFF+2/IZ2wOdHKCMaMmOC8ycWziAA9AuT2uYH+nKnKcS1B2B+9KjJj
         SyyRLc6l3PnB9Mc7Z7KqtdrUN5D2osJj8HAkQrOxWiJ06DM2rMLzTMcV/8thBU1Qq8aw
         hJbBzSGTtt1dKkwhIwUtYlDtRRrw8sb0Cb5jYwIMaRL8y98CLKxvp/xoGVGejo8mlXAm
         CuGnt4eaX5aWVSbf4ji6a3Co2pO6eoWcnWFaw2g4DzBRI6gizyqPb8U8gorqY/8khxtg
         T04DXaYW4K/Qd2eMPOpwzBsc9w7kFG+6KywIly2kdiTWA/Y/Wm2YaTAubwP3xQ1nlpxG
         wxTg==
X-Gm-Message-State: AFqh2koRLaRR0ZCuK4fIxbOoRLO1+fx/xaSNbd+2EL4ZVEm75hDw21wH
        auZldCTrUa0VP28hWwtXWFQKRFl0crWj0c0Js2c=
X-Google-Smtp-Source: AMrXdXu3OjkcSsupdqiGrzcoZyUETKKtuzuM9zsw/av94GqPUv3ArpnBxQmKnKeyPb3QLOKyoFaN6atbqfVPda8Sn64=
X-Received: by 2002:a05:6122:625:b0:3da:222:7fff with SMTP id
 g5-20020a056122062500b003da02227fffmr580721vkp.9.1673982994120; Tue, 17 Jan
 2023 11:16:34 -0800 (PST)
MIME-Version: 1.0
References: <20230116174013.3272728-1-willemdebruijn.kernel@gmail.com> <5f494ec3-9435-b9dc-6dd8-9e1b7354430d@intel.com>
In-Reply-To: <5f494ec3-9435-b9dc-6dd8-9e1b7354430d@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 17 Jan 2023 14:15:58 -0500
Message-ID: <CAF=yD-LMO5Y1Uith1jsbh1kOO3t4oagTnKSdKoM=gQkfd61oAA@mail.gmail.com>
Subject: Re: [PATCH net] selftests/net: toeplitz: fix race on tpacket_v3 block close
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        Willem de Bruijn <willemb@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 1/16/2023 9:40 AM, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Avoid race between process wakeup and tpacket_v3 block timeout.
> >
> > The test waits for cfg_timeout_msec for packets to arrive. Packets
> > arrive in tpacket_v3 rings, which pass packets ("frames") to the
> > process in batches ("blocks"). The sk waits for req3.tp_retire_blk_tov
> > msec to release a block.
> >
> > Set the block timeout lower than the process waiting time, else
> > the process may find that no block has been released by the time it
> > scans the socket list. Convert to a ring of more than one, smaller,
> > blocks with shorter timeouts. Blocks must be page aligned, so >= 64KB.
> >
> > Somewhat awkward while () notation dictated by checkpatch: no empty
> > braces allowed, nor statement on the same line as the condition.
> >
> > Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  tools/testing/selftests/net/toeplitz.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
> > index 90026a27eac0c..66f7f6568643a 100644
> > --- a/tools/testing/selftests/net/toeplitz.c
> > +++ b/tools/testing/selftests/net/toeplitz.c
> > @@ -215,7 +215,7 @@ static char *recv_frame(const struct ring_state *ring, char *frame)
> >  }
> >
> >  /* A single TPACKET_V3 block can hold multiple frames */
> > -static void recv_block(struct ring_state *ring)
> > +static bool recv_block(struct ring_state *ring)
> >  {
> >       struct tpacket_block_desc *block;
> >       char *frame;
> > @@ -223,7 +223,7 @@ static void recv_block(struct ring_state *ring)
> >
> >       block = (void *)(ring->mmap + ring->idx * ring_block_sz);
> >       if (!(block->hdr.bh1.block_status & TP_STATUS_USER))
> > -             return;
> > +             return false;
> >
> >       frame = (char *)block;
> >       frame += block->hdr.bh1.offset_to_first_pkt;
> > @@ -235,6 +235,8 @@ static void recv_block(struct ring_state *ring)
> >
> >       block->hdr.bh1.block_status = TP_STATUS_KERNEL;
> >       ring->idx = (ring->idx + 1) % ring_block_nr;
> > +
> > +     return true;
> >  }
> >
> >  /* simple test: sleep once unconditionally and then process all rings */
> > @@ -245,7 +247,8 @@ static void process_rings(void)
> >       usleep(1000 * cfg_timeout_msec);
> >
> >       for (i = 0; i < num_cpus; i++)
> > -             recv_block(&rings[i]);
> > +             while (recv_block(&rings[i]))
> > +                     ;
>
> I'd rather have one of
>
>   while (recv_block(&rings[i]));
>
> or
>
>   while (recv_block(&rings[i])) {}
>
> or even (but less preferred:
>
>   do {} (while (recv_block(&rings[i]));
>
> instead of  this ; on its own line.
>
> Even if this violates checkpatch attempts to catch other bad style this
> is preferable to the lone ';' on its own line.
>
> If necessary we can/should change checkpatch to allow the idiomatic
> approach.

Let me send a v2 with the do {} while construct.

Cc:ed the checkpatch maintainers for visibility.
