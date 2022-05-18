Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C649552B7E4
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbiERKb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 06:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbiERKby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 06:31:54 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1786813D31;
        Wed, 18 May 2022 03:31:52 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id j24so2081728wrb.1;
        Wed, 18 May 2022 03:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eg50Z55dIlImdG91r9MKVZYSO4VE8hp0Z0PI1gXalc4=;
        b=17GhCUPB6gzydg59s66OzUrr1Zoxx5DDbNgqWvRHniESqu/LeRsEsUJeriOWT/cH6+
         UB1Pbxx6maO4TbrEDtpu/2Ll4WAy3tPw1khXUbtmQd88aM0sWwV4pEA4zyNvbxDsHmiy
         Gp8ykJwSAePBafZB1N0MN2IX6ekB2DUoA4P6aU/4Dspcr7nrr2uVipjmwNSQeJvDsflC
         wsDOGKV9lgwrhToOTYwLHijq/2stqHzX20gGC5JDE6HuVVJj+OVo+WEQgaaxqBkAzZ4f
         JcEJ+GeqxhEHXMIVSiUBSf4+JbLP3QVIb1AojKcmAm4j4d66Seni3ENTquq4LXnagLTe
         dZdQ==
X-Gm-Message-State: AOAM532E4jUf/ngr9gGB90f92HP34L5elGDS/PlUdo7Rxe12EWZzMMhI
        rkTE6jRYUuc5KjqKVa6f3wxRosY3J1FV+VvS4avvUToKv8oGDw==
X-Google-Smtp-Source: ABdhPJxyZbgVaQyT6J8R85YfGoFx158Afu+6TaWLZEGsBFx00ecoRJUc1+YMNuYZovSDNtJL6qWAmJJtDyzoDyjUIOo=
X-Received: by 2002:a5d:48c1:0:b0:20c:52e9:6c5b with SMTP id
 p1-20020a5d48c1000000b0020c52e96c5bmr21414633wrs.233.1652869910631; Wed, 18
 May 2022 03:31:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220517073259.23476-1-harini.katakam@xilinx.com>
 <20220517073259.23476-2-harini.katakam@xilinx.com> <20220517194254.015e87f3@kernel.org>
 <CAFcVEC+qdouQ+tJdBG_Vv8QsaUX99uFtjKnB5WwQawA1fxmgEQ@mail.gmail.com> <20220517220603.36eec66e@kernel.org>
In-Reply-To: <20220517220603.36eec66e@kernel.org>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Wed, 18 May 2022 16:01:39 +0530
Message-ID: <CAFcVEC+K42w0eW_bCd2XaBz91bFwF9+r52m0rEziHP+MZr5TWQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: macb: Fix PTP one step sync support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

<snip>
>
> > > > @@ -1158,13 +1192,14 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
> > > >
> > > >                       /* First, update TX stats if needed */
> > > >                       if (skb) {
> > > > -                             if (unlikely(skb_shinfo(skb)->tx_flags &
> > > > -                                          SKBTX_HW_TSTAMP) &&
> > > > -                                 gem_ptp_do_txstamp(queue, skb, desc) == 0) {
> > > > -                                     /* skb now belongs to timestamp buffer
> > > > -                                      * and will be removed later
> > > > -                                      */
> > > > -                                     tx_skb->skb = NULL;
> > > > +                             if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
> > >
> > > ptp_oss already checks if HW_TSTAMP is set.
> >
> > The check for SKBTX_HW_TSTAMP is required here universally and not
> > just inside ptp_oss.
> > I will remove the redundant check in ptp_oss instead. Please see the
> > reply below.
>
> But then you need to add this check in the padding/fcs call site and
> the place where NOCRC is set. If you wrap the check for SKBTX_HW_TSTAMP
> in the helper with likely() and remove the inline - will the compiler
> not split the function and inline just that check? And leave the rest
> as a functionname.part... thing?

Yes, I checked the disassembly and this is what's happening. This
should be good for
the non-PTP packet (going to "likely" branch) and the rest of ptp_oss
is evaluated for
PTP packets.

Regards,
Harini
