Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E100552B16A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 06:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiEREXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 00:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiEREXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 00:23:43 -0400
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD68E2E9E0;
        Tue, 17 May 2022 21:23:42 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id l38-20020a05600c1d2600b00395b809dfbaso360582wms.2;
        Tue, 17 May 2022 21:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=76dv2VpjMRgZPVQFYZ0FWzLo+rlCzcsp4h55jthexNg=;
        b=MZ+xMMXjoDM9tgU9uaFNDeT8Uulqcj7rQAZoQZrtUemDhZQtPB+O5NzuoQ5Ok1VxqV
         T0nQHqAT+Vt3JWpFgGND3UjcIF4TOu7znNHIUxjPBxypjC78KTqL7YsxpRqWpWQd6rIJ
         34W9ljB67V+l7Xj99pwnIh2UVO0aXwKPl3cTjV5bNYsg8xHBZMrmpR9BNIa0O6BNQoJ6
         TTqiKUN4NUchdF0OJmvmSANMhbKOYzlrBkB3eAcqmzGa3bp9Kl3ERkO4+C0nE2aHJ4SQ
         /A4HPqxIVeMrN9DR+t1pSduRI7WjPo0bMuBMPvlmwR/3Cin+OMMx4BC1vLCYr6IYX7h2
         LIQQ==
X-Gm-Message-State: AOAM530UwSGlk0CCJaoaSmyYXybai9kR9XtnPTiVikLUxTlLRRHQnVe/
        0J/j0QIjkpQbtpJ99xKPcrpu7oNEYZusuUgeRDk=
X-Google-Smtp-Source: ABdhPJzyyLEmhI/Yu+0jMqaa9YJP/smoyEgq2hb8jsNCdzNCwzf+hEXAJSpALAwsB8QS0g0ztXlsVahSfL2UrMlLhuc=
X-Received: by 2002:a05:600c:1c84:b0:394:5de0:245e with SMTP id
 k4-20020a05600c1c8400b003945de0245emr35217055wms.32.1652847821016; Tue, 17
 May 2022 21:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220517073259.23476-1-harini.katakam@xilinx.com>
 <20220517073259.23476-2-harini.katakam@xilinx.com> <20220517194254.015e87f3@kernel.org>
In-Reply-To: <20220517194254.015e87f3@kernel.org>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Wed, 18 May 2022 09:53:29 +0530
Message-ID: <CAFcVEC+qdouQ+tJdBG_Vv8QsaUX99uFtjKnB5WwQawA1fxmgEQ@mail.gmail.com>
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

On Wed, May 18, 2022 at 8:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 May 2022 13:02:57 +0530 Harini Katakam wrote:
> > PTP one step sync packets cannot have CSUM padding and insertion in
> > SW since time stamp is inserted on the fly by HW.
> > In addition, ptp4l version 3.0 and above report an error when skb
> > timestamps are reported for packets that not processed for TX TS
> > after transmission.
> > Add a helper to identify PTP one step sync and fix the above two
> > errors.
> > Also reset ptp OSS bit when one step is not selected.
> >
> > Fixes: ab91f0a9b5f4 ("net: macb: Add hardware PTP support")
> > Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
>
> Please make sure to CC authors of the patches under fixes.
> ./scripts/get_maintainer should point them out.

Thanks for the review.
Rafal Ozieblo <rafalo@cadence.com> is the author of the first Fixes
patch but that
address hasn't worked in the last ~4 yrs.
I have cced Claudiu and everyone else from the maintainers
(Eric Dumazet <edumazet@google.com> also doesn't work)

<snip>
> > +/* IEEE1588 PTP flag field values  */
> > +#define PTP_FLAG_TWOSTEP     0x2
>
> Shouldn't this go into the PTP header?

Let me add it to ptp_classify where the relevant helpers are present.

<snip>
> > +static inline bool ptp_oss(struct sk_buff *skb)
>
> Please spell out then name more oss == open source software.

Will change to ptp_one_step_sync

>
> No inline here, please, let the compiler decide if the function is
> small enough. One step timestamp may be a rare use case so inlining
> this twice is not necessarily the right choice.

One step is a rare case but the check happens on every PTP packet in the
transmit data path and hence I wanted to explicitly inline it.

<snip>
> > @@ -1158,13 +1192,14 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
> >
> >                       /* First, update TX stats if needed */
> >                       if (skb) {
> > -                             if (unlikely(skb_shinfo(skb)->tx_flags &
> > -                                          SKBTX_HW_TSTAMP) &&
> > -                                 gem_ptp_do_txstamp(queue, skb, desc) == 0) {
> > -                                     /* skb now belongs to timestamp buffer
> > -                                      * and will be removed later
> > -                                      */
> > -                                     tx_skb->skb = NULL;
> > +                             if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
>
> ptp_oss already checks if HW_TSTAMP is set.

The check for SKBTX_HW_TSTAMP is required here universally and not
just inside ptp_oss.
I will remove the redundant check in ptp_oss instead. Please see the
reply below.

>
> > +                                 !ptp_oss(skb)) {
> > +                                     if (gem_ptp_do_txstamp(queue, skb, desc) == 0) {
>
> Why convert the gem_ptp_do_txstamp check from a && in the condition to
> a separate if?

The intention is that ptp_oss should only be evaluated when
SKBTX_HW_TSTAMP is set and
gem_ptp_do_txstamp should only be called if ptp_oss is false. Since
compiler follows the order
of evaluation, I'll simplify this to:

if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) && !ptp_oss(skb) &&
    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
...
}

Regards,
Harini
