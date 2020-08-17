Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA16245E51
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 09:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgHQHsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 03:48:18 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:45265 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgHQHsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 03:48:15 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6bfdcc46;
        Mon, 17 Aug 2020 07:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :in-reply-to:references:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=UfEdk9aa6S5dxYeKZTnmjv6glRQ=; b=ovjN9W
        s9dOHqOsNMvdwOqJhUtFIA1ve7deb9PC3rx6H9x+MSop5g2vx7vGUNM8gb4tqFb/
        22ZgcyE+oekzVgHdA0ll7iR4/6FC20BFCwxcadSnev3Hx8Zmc4Oligkoc3OnSN4O
        ktebcGHvSufALKqNEXbp70KVN0VWAczTEZkCHCSGfWfmfZFC0IDi2BxAyzlANJ8j
        5+0OODJMKTI711bX693VjX/ZDS5bYmEKKiAlzWRVs7UpuS0P6GCtNYhUxduLFJJn
        y4pLzVbOL7AuxKD/mvpNNnGQorFyqgc4Y/dJsVBwXQTYcV6COoui1bAT+2HGxbLX
        +KY77IMYDE7N1CCA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1af569d9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 17 Aug 2020 07:22:10 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id q75so16786261iod.1;
        Mon, 17 Aug 2020 00:48:11 -0700 (PDT)
X-Gm-Message-State: AOAM531ZPSc2lfZsdnb8jGx9u9b9gNzW86FP9UtTX41MLero+llC6ltf
        nezxkvRq1JK9zIiaAesQXrC3sMYr6qDOOZgDnpo=
X-Google-Smtp-Source: ABdhPJwyjsFwcAS6uI9wLn0QxQTJj4DFx0YIBBWCUxuUJXdF6gK3t3IxHRihGDwEO4luy1wbjVzQiyVdtxTxJwJ3zSc=
X-Received: by 2002:a6b:5c17:: with SMTP id z23mr11443692ioh.67.1597650490600;
 Mon, 17 Aug 2020 00:48:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6e02:ed0:0:0:0:0 with HTTP; Mon, 17 Aug 2020 00:48:10
 -0700 (PDT)
In-Reply-To: <20200817080102.61e109cf@carbon>
References: <20200815072930.4564-1-Jason@zx2c4.com> <20200816.152937.1107786737475087036.davem@davemloft.net>
 <20200817080102.61e109cf@carbon>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 17 Aug 2020 09:48:10 +0200
X-Gmail-Original-Message-ID: <CAHmME9ojV+6xgvmEPYV+_oGjzykDG+ZpOe5kct+DG87A+YyLvQ@mail.gmail.com>
Message-ID: <CAHmME9ojV+6xgvmEPYV+_oGjzykDG+ZpOe5kct+DG87A+YyLvQ@mail.gmail.com>
Subject: Re: [PATCH net] net: xdp: pull ethernet header off packet after
 computing skb->protocol
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> On Sun, 16 Aug 2020 15:29:37 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
>
>> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
>> Date: Sat, 15 Aug 2020 09:29:30 +0200
>>
>> > When an XDP program changes the ethernet header protocol field,
>> > eth_type_trans is used to recalculate skb->protocol. In order for
>> > eth_type_trans to work correctly, the ethernet header must actually be
>> > part of the skb data segment, so the code first pushes that onto the
>> > head of the skb. However, it subsequently forgets to pull it back off,
>> > making the behavior of the passed-on packet inconsistent between the
>> > protocol modifying case and the static protocol case. This patch fixes
>> > the issue by simply pulling the ethernet header back off of the skb
>> > head.
>> >
>> > Fixes: 297249569932 ("net: fix generic XDP to handle if eth header was
>> > mangled")
>> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>> > Cc: David S. Miller <davem@davemloft.net>
>> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>>
>> Applied and queued up for -stable, thanks.
>>
>> Jesper, I wonder how your original patch was tested because it pushes a
>> packet
>> with skb->data pointing at the ethernet header into the stack.  That
>> should be
>> popped at this point as per this fix here.
>
> I think this patch is wrong, because eth_type_trans() also does a
> skb_pull_inline(skb, ETH_HLEN).

Huh, wow. That's one unusual and confusing function. But indeed it
seems like I'm the one who needs to reevaluate testing methodology
here. I'm very sorry for the noise and hassle.

Jason
