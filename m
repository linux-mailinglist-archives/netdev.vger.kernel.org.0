Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F138524639
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 08:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350651AbiELG4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 02:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350649AbiELG4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 02:56:31 -0400
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1260D1AF05;
        Wed, 11 May 2022 23:56:28 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id o12-20020a1c4d0c000000b00393fbe2973dso4529746wmh.2;
        Wed, 11 May 2022 23:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mugOzymoMq4dVIDoH9hEwumMUl2ghOS/UvtuYdo5Zns=;
        b=Nmckd5Sg3CyCsWilcYjNkEDhB06AaNqwy9AmISORBqHVUhJ0u6nzM14hqRT3tzzV2L
         6gDLHwGV9khFInAQgerI4sXHLatUU2Zewn48XlaQay5T7rdOzV33c2x8St7wZvvpDYMG
         7lEORhwZsXzGidicyJEd6VuI23YL6vynmqa2pHkDs0OyWZvohQewPZ/PgNYoX4tNVen1
         K6jLXmr+g8624W6Vv+pBqe2hOoc96CwIBAfw8L6gYgS4UrOjI+lmIPvjsmdslVnJtZb2
         Vq7H1AvMAbhKUFgpaEA8yNJweWiYg7k5Gg1PpRhprkbAjIRHNWGgTVrj2OocqVDHdJor
         urbg==
X-Gm-Message-State: AOAM533mcZFBC2pZvMHG1R1GmvZ7ShEiYmBzZokK+mXPUeseLf5vg4Gu
        QeuwDsO9TOmDK3CPogm82GFAd7zrXw5ZljYc/SM6uiA42ZMDxZAs
X-Google-Smtp-Source: ABdhPJzVrw+X68hLS5mQxWV0WiQDF01gEzNjVdQKU8s5VbcI6nntk1RmY5YdZyo/S5xfx7pYfpFzDUgJJxwwKaRWS5k=
X-Received: by 2002:a05:600c:2e12:b0:395:b6ae:f551 with SMTP id
 o18-20020a05600c2e1200b00395b6aef551mr6697479wmf.36.1652338586578; Wed, 11
 May 2022 23:56:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220510162809.5511-1-harini.katakam@xilinx.com> <20220511154024.5e231704@kernel.org>
In-Reply-To: <20220511154024.5e231704@kernel.org>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Thu, 12 May 2022 12:26:15 +0530
Message-ID: <CAFcVECK2gARjppHjALg4w2v94FPgo6BvqNrZvCY-4x_mJbh7oQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: macb: Disable macb pad and fcs for fragmented packets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        dumazet@google.com, Paolo Abeni <pabeni@redhat.com>,
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

On Thu, May 12, 2022 at 4:10 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 10 May 2022 21:58:09 +0530 Harini Katakam wrote:
> > data_len in skbuff represents bytes resident in fragment lists or
> > unmapped page buffers. For such packets, when data_len is non-zero,
> > skb_put cannot be used - this will throw a kernel bug. Hence do not
> > use macb_pad_and_fcs for such fragments.
> >
> > Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
> > Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> > Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>
> I'm confused. When do we *have to* compute the FCS?
>
> This commit seems to indicate that we can't put the FCS so it's okay to
> ask the HW to do it. But that's backwards. We should ask the HW to
> compute the FCS whenever possible, to save the CPU cycles.
>
> Is there an unstated HW limitation here?

Thanks for the review. The top level summary is that there CSUM
offload is enabled by
via NETIF_F_HW_CSUM (and universally in IP registers) and then
selectively disabled for
certain packets (using NOCRC bit in buffer descriptors) where the
application intentionally
performs CSUM and HW should not replace it, for ex. forwarding usecases.
I'm modifying this list of exceptions with this patch.

This was due to HW limitation (see
https://www.spinics.net/lists/netdev/msg505065.html).
Further to this, Claudiu added macb_pad_and_fcs support. Please see
comment starting
with "It was reported in" below:
https://lists.openwall.net/netdev/2018/10/30/76

Hope this helps.
I'll fix the nit and send another version.

Regards,
Harini
