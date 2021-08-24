Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E973F61A2
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbhHXPaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:30:18 -0400
Received: from mail-yb1-f182.google.com ([209.85.219.182]:43675 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhHXPaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 11:30:16 -0400
Received: by mail-yb1-f182.google.com with SMTP id z128so41786986ybc.10;
        Tue, 24 Aug 2021 08:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bj6/PIAHxTxWiNTDP0ZybZlwOVfBWJrxxo5gWj3Vjh4=;
        b=lrKUPVu4zjRMH6kndntOSRZCqQWHoKqMthoEB4X7xUVB0r7I6oku3AeoTv1eRjQyuV
         IYkGhEd5lVIPM+fOW/M8HnYNUzUkdgEyhPxONauLTNpJ8QB9NYIYjoBI2752duReHg8g
         EC7M7p4rS4ps24GE1zcJH9TzZLIG9nsOvbq8A7CG31S0EwsKACpyqf2Re1n93mSE+n5q
         vwhmDrBSn0rDLj4EBOWGlTuCC/cxnOlUbrX7W5A30FpcmQgKtBgZ8GFf/P/TXoPSaF5T
         tXHByLH3lJow8Bf8X2Q4mFqr67CXIAXfO20BB7Eg+SVEayldl6cvGAzHijwRl3I1lI1l
         Z1tQ==
X-Gm-Message-State: AOAM531sAKgU5HUVGyFqbSRsJj7mLeJ+oK3A+V0Agp1hUJ0xXA49Jj9Z
        Y45Ui6ZoGpWwrY1LXcgaXMAaqVoSaTvGiywH0LU=
X-Google-Smtp-Source: ABdhPJybMAropxVAgAdwF2hgd9qQDL3dbrW1+qEOIIaZM4BUH364bfuFHZKbaDVefItlsjAQMfi7PR4lROGM6BtdB+M=
X-Received: by 2002:a5b:108:: with SMTP id 8mr52503590ybx.174.1629818971616;
 Tue, 24 Aug 2021 08:29:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210824101238.21105-1-harini.katakam@xilinx.com> <20210824140542.GA17195@hoboy.vegasvil.org>
In-Reply-To: <20210824140542.GA17195@hoboy.vegasvil.org>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 24 Aug 2021 20:59:20 +0530
Message-ID: <CAFcVECKXOVwpsR=bEUmTXZpSQTjez1fjf1X9bXV_sFCe_U3_qA@mail.gmail.com>
Subject: Re: [RFC PATCH] net: macb: Process tx timestamp only on ptp packets
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Andrei Pistirica <andrei.pistirica@microchip.com>,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Tue, Aug 24, 2021 at 7:35 PM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Tue, Aug 24, 2021 at 03:42:38PM +0530, Harini Katakam wrote:
> > The current implementation timestamps all packets and also processes
> > the BD timestamp for the same. While it is true that HWTSTAMP_TX_ON
> > enables timestamps for outgoing packets, the sender of the packet
> > i.e. linuxptp enables timestamp for PTP or PTP event packets. Cadence
> > GEM IP has a provision to enable this in HW only for PTP packets.
> > Enable this option in DMA BD settings register to decrease overhead.
>
> NAK, because the HWTSTAMP_TX_ON means to time stamp any frame marked
> by user space, not just PTP frames.
>
> This patch does not "decrease overhead" because the code tests whether
> time stamping was request per packet:
>

Thanks for the review.
Yes, there is no SW overhead because the  skb check ensures timestamp
post processing is done only on requested packets. But the IP
timestamps all packets
because this is a register level setting, not per packet. That's the
overhead I was referring to.
But based on your explanation, it looks like we have no option but to enable
TSTAMP_ALL_FRAMES. Thanks.

Regards,
Harini
