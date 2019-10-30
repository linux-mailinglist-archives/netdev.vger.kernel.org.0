Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4866CEA5BA
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfJ3Vv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:51:27 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37678 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfJ3Vv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:51:27 -0400
Received: by mail-oi1-f194.google.com with SMTP id y194so3390352oie.4
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 14:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f/22oU9ITDEvWLVMzt6EYHu2iWpHwZHJesTlfTtN7lU=;
        b=njYzlWbGXTl+tfgI7t23Nk5LWBCiu2FGV6yJe7yaC6gOLmq6pIEbn32+r3g1o9Yjfg
         ExP8TyGbW5+Qr3WvsefvM1X1urd/QSFUClt+Wi8tthdGAL/Jj7KQRli4xkxZ1KvpiVQL
         7Qqtk2h5VhuEED7UCe1Nx70DGXGhVhHQyAiDhMflTQAl8Q5DiVy2aym/c47zsZ9xB0pl
         bdyZmPEDHP2fAwMBrxgciW245c4IVVJU3+TQcsc8TVfYCwo5SoswDckbWVN69w9C4+hB
         EuYB0tAVeYDm80JjVfOBU2FkUWu77UW3zN6rZ72/+w54hnDLJDJ21j375XHb8cF7Nxnu
         MXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f/22oU9ITDEvWLVMzt6EYHu2iWpHwZHJesTlfTtN7lU=;
        b=re0ENgaOtQcAHu1MBpqNmLZwSQ7bJOblrGbuBD3dxPIcR2OPMxRkRCRRjX8od1oICJ
         y/Zn4vmkVuIL2+KOXNBTZw2UQCx7xrZFAa1nbeyOePSZofSGm0+hicztbpwTF+aTrRgE
         tEgBKVTfjF+KPFCfzt2cnyKsatcEffS+0ptqHOgG347D3scC8CH+jNFGiIJOZOUTvG1N
         aMjjehz8plT9gUEpXtdIUrSYWkEsYie2eBrnjyX7gTgOMcDZNJrE9PRyjGu0KePrFppL
         ZMLwPJGscPJcph6IBfKjJXXRlCvUm4+KI8fl2I+FfIBbnuYJoYoHYYXTt6MzzipGDXJo
         Cm3w==
X-Gm-Message-State: APjAAAU0B4vcgF+jFh8yNL+Qn7/RMf8g8pKvE2lUlYCIz6koUMm7eMqZ
        fYYXENJW3xhpcg4kcPd7c/7SrF26bqu2zksFcSOjOQ==
X-Google-Smtp-Source: APXvYqzTrAp9KSLID9rvJNHqyzuvH+E1yrN3XepMl8KLAcbD9/r/kA8c6lF7iIGIuuTcMPtA3ezg68fH/TDKsc6xYig=
X-Received: by 2002:aca:602:: with SMTP id 2mr1228585oig.19.1572472286034;
 Wed, 30 Oct 2019 14:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191028182309.73313-1-yangchun@google.com> <20191029.174111.1326267225443351642.davem@davemloft.net>
In-Reply-To: <20191029.174111.1326267225443351642.davem@davemloft.net>
From:   Yangchun Fu <yangchun@google.com>
Date:   Wed, 30 Oct 2019 14:51:14 -0700
Message-ID: <CAOPXMbnBtxY4bkXkCJY3hUZjF48V7eoXa6oLmY9EO456kr4svQ@mail.gmail.com>
Subject: Re: [PATCH net] gve: Fixes DMA synchronization.
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 5:41 PM David Miller <davem@davemloft.net> wrote:
>> diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
>> index 778b87b5a06c..d8342b7b9764 100644
>> --- a/drivers/net/ethernet/google/gve/gve_tx.c
>> +++ b/drivers/net/ethernet/google/gve/gve_tx.c
>> @@ -390,7 +390,23 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
>>       seg_desc->seg.seg_addr = cpu_to_be64(addr);
>>  }
>>
>> -static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
>> +static inline void gve_dma_sync_for_device(struct gve_priv *priv,
>> +                                        dma_addr_t *page_buses,
>> +                                        u64 iov_offset, u64 iov_len)
>
> Never use the inline keyword in foo.c files, let the compiler device

Thanks for the review. I will send the v2 patch with the fix.
