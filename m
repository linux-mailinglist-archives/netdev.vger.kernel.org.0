Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5C0BDBD4
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388203AbfIYKFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:05:55 -0400
Received: from mail-yw1-f46.google.com ([209.85.161.46]:39686 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733114AbfIYKFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:05:55 -0400
Received: by mail-yw1-f46.google.com with SMTP id n11so1790643ywn.6
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 03:05:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jOt+I5bYjovGTz/mGGHwppT9Wxd8+A5YxewlwM18KWU=;
        b=bcbB3L5rDGsdM1Ate9CcM8nTflyajit2Z575A0+Eb/KHhx5MQvdPgAB1jw6vdnpowP
         KXDSy/+PNj2/nscd0SURCWgCQM1UynMHMPtnEw/aO9VqtPNgm9MwiEqPIQft4chjs604
         Om6H686Us7apQTnyaD3DTv/kX8oiQAofsi5X+iagrJrKMMKg1Wo0qy628ID09eAG+gHu
         F7rmbdVZodaOwgBkQLaqJe0r4lxWHVsd24aQpDK7s/+qJVkFkEypL6WgJrGJ77sxm0pT
         TbaAB8pNBNmV+ZHOq0uxyvsnLrS/MGIaaVH9/DizzvPcFx5lyeR9bd8DywjYIWBtugxl
         wN9A==
X-Gm-Message-State: APjAAAW3d0PmiNj08LPBJDi1Pw73v8XB00MQT8xZ0NkS/iUIwkpnxtYo
        NuVURdwKEQvWqM+dcK91SAvRKZTeT6ylefnLPjoS3u1W
X-Google-Smtp-Source: APXvYqyxlaa2Fp7pqgojh8jLKrgckEVwkGrzjq3HT+QZfBw2Ct8Mdv4YaVSc5KH4hquaXLA3y9vKCsjQOfnFdbVM2Mk=
X-Received: by 2002:a81:a34c:: with SMTP id a73mr5000568ywh.51.1569405954175;
 Wed, 25 Sep 2019 03:05:54 -0700 (PDT)
MIME-Version: 1.0
References: <mvm4l1chemx.fsf@suse.de> <51458d2e-69a5-2a30-2167-7f47a43d9a2f@microchip.com>
 <mvmmuf4fszw.fsf@suse.de> <379c59d0-e31b-96c1-8a5e-416b98583da0@microchip.com>
In-Reply-To: <379c59d0-e31b-96c1-8a5e-416b98583da0@microchip.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Wed, 25 Sep 2019 15:35:43 +0530
Message-ID: <CAFcVECLwo64yduOQo21WQde_QLEw=H7iO+MWYvy2djAu=iT1fw@mail.gmail.com>
Subject: Re: macb: inconsistent Rx descriptor chain after OOM
To:     Claudiu Beznea <Claudiu.Beznea@microchip.com>
Cc:     schwab@suse.de, Nicolas Ferre <Nicolas.Ferre@microchip.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andreas,

On Mon, Sep 16, 2019 at 4:25 PM <Claudiu.Beznea@microchip.com> wrote:
>
>
>
> On 16.09.2019 13:14, Andreas Schwab wrote:
> > External E-Mail
> >
> >
> > On Sep 16 2019, <Claudiu.Beznea@microchip.com> wrote:
> >
> >> I will have a look on it. It would be good if you could give me some
> >> details about the steps to reproduce it.
> >
> > You need to trigger OOM.
>
> Ok, thank you!
>
> >
> > Andreas.

Can you please try incrementing the rx_prepared_head after skb
allocation as follows?

@@ -920,7 +920,6 @@ static void gem_rx_refill(struct macb_queue *queue)
  /* Make hw descriptor updates visible to CPU */
  rmb();

- queue->rx_prepared_head++;
  desc = macb_rx_desc(queue, entry);

  if (!queue->rx_skbuff[entry]) {
@@ -959,6 +958,7 @@ static void gem_rx_refill(struct macb_queue *queue)
  dma_wmb();
  desc->addr &= ~MACB_BIT(RX_USED);
  }
+ queue->rx_prepared_head++;
  }

  /* Make descriptor updates visible to hardware */

Without this, head will increase even when skb allocation fails. It is a valid
fix anyway and I'll patch it. But I recall a *similar* issue with inconsistent
RX BD chain that was solved by this.

Regards,
Harini
