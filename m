Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1540521C93
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 16:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346507AbiEJOnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 10:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345157AbiEJOlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 10:41:03 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD042F7367;
        Tue, 10 May 2022 06:57:45 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id c11so23920688wrn.8;
        Tue, 10 May 2022 06:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kLUsJJIOjnBzu7Fn+p8pQABeh5O/fVn3NLgRAHyO7K0=;
        b=rVD9dGOLZ+KIygSPWyoOgiNbqk5Y7O5EI5WSPu309CM/BWGmLBiQqPVs+eT+pcOZ3M
         /304vDKX7fLNVfp26psi7TsjMF+5mF3LZcp7Z9ZaTBhYGuYCyglaU+ww/WKlwa2L7uO4
         jLHRe1P98OQpTcGQACbdmc8g04qJjk4cWPAmSiRX69E7MmDeWBhe1+mwAzxbiKqdLSTy
         0KGdTOLpxx9nUIMslBX2OzZqkBHcjHv56G6KXtv/Z+vrD7PNRtw6rWxnXRyomEVlSyTT
         cSXDSHxYPQuQJTj8Qf1JZIrS47rV0zTaqtn/3leQ7D9JK2CyJcFugN6i5E15r3YfnF2U
         jANg==
X-Gm-Message-State: AOAM532F5qv0uzP+f5GfeZivy8wsu1/L6KBLGhJcK1LN7CAs367+09+5
        8KjMvvLMvKFmcO4RUZeWuVux920EV81iAI8m/QQ=
X-Google-Smtp-Source: ABdhPJyXdjBKuRq72cBtrrUEpYnydXQDURkv81nEvnDJ+fmifrl92MntG3s+vyJ2HAL1KwM4b7mJ6Nl9QX59icqFeWU=
X-Received: by 2002:a05:6000:2a7:b0:20c:4d42:189b with SMTP id
 l7-20020a05600002a700b0020c4d42189bmr18882068wry.16.1652191053526; Tue, 10
 May 2022 06:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220509121958.3976-1-harini.katakam@xilinx.com> <19e704ace63483a765a3298610218c5d110bb0e4.camel@redhat.com>
In-Reply-To: <19e704ace63483a765a3298610218c5d110bb0e4.camel@redhat.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 10 May 2022 19:27:22 +0530
Message-ID: <CAFcVECJuB-F8=Gh3=jQsGhWwnNK2=-KvzzQ4MQQGCPoypiSXOQ@mail.gmail.com>
Subject: Re: [PATCH] net: macb: Increment rx bd head after allocating skb and buffer
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, dumazet@google.com,
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

Hi Paolo,

On Tue, May 10, 2022 at 6:54 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Mon, 2022-05-09 at 17:49 +0530, Harini Katakam wrote:
> > In gem_rx_refill rx_prepared_head is incremented at the beginning of
> > the while loop preparing the skb and data buffers. If the skb or data
> > buffer allocation fails, this BD will be unusable BDs until the head
> > loops back to the same BD (and obviously buffer allocation succeeds).
> > In the unlikely event that there's a string of allocation failures,
> > there will be an equal number of unusable BDs and an inconsistent RX
> > BD chain. Hence increment the head at the end of the while loop to be
> > clean.
> >
> > Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>
> This looks like targeting the "net" tree, please repost adding a
> suitable Fixes tag.

Thanks for the review. This behavior would theoretically have been the
same since
GEM RX path handling was introduced ~9 yrs ago but I'm not sure since I cannot
reproduce. Probably this?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/ethernet/cadence?id=4df95131ea803bcb94f472d465c73ed57015c470
Also, this patch can't be backported to stable branches so far back
since the driver
files have changed. It can also be queued for net-next instead.

Regards,
Harini
