Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE7745C3D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 14:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfFNMKm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jun 2019 08:10:42 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38296 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727692AbfFNMKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 08:10:42 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so996346edo.5
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 05:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XLlLHksTC0yxOESsFyxxxiYxkKN8pdc2F58BlGgcWg0=;
        b=QPl57m4fNaX48L5x5VR6PrOBvnL7S5JCnbljXhO2TgvKI8k75W4xcx695WTyEf8zJB
         AZraasMeJNLCDxe0Un+/FxPzjLQKvCpk/U0S23E8+DPac6ql5GIGI8S7T8OKcjwyzdvc
         Lts0e7kMe0E1gMZ84BvzsB39hnP5jrDy3dLsy4YoMal3LQDHbBZ73S39InWalzVtolJX
         5Lay8p5UOCG/dpPWLVmr7QLm0+1KWkCBoZkRdIZCTlfti+pVhVy3weIhuT8CcCUwCGJg
         6PVpifH+aag1lHsQlu/Cu7biUScorK4Lt6WQslHlq2jne05VjTu+5kg8nz7H+SyXRcyL
         JDRw==
X-Gm-Message-State: APjAAAUPuzPEvZb+kkHEhaveeiVX3Q4snzwzbDltTlTxXlRLrS63jDDM
        /kLmqvw+OFKoDId5X8muK0rasg==
X-Google-Smtp-Source: APXvYqxoNbtKbpy/btptoDlq7ip+Nw9Gj+2UeqoGWBE6r0aFpGw8qJdyH+25ljIk33c3tAmmbbEzHg==
X-Received: by 2002:a17:906:5a48:: with SMTP id l8mr34249129ejs.169.1560514240496;
        Fri, 14 Jun 2019 05:10:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id l6sm860802edk.8.2019.06.14.05.10.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 05:10:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 37D681804AF; Fri, 14 Jun 2019 14:10:38 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf 1/3] devmap: Fix premature entry free on destroying map
In-Reply-To: <877e9octre.fsf@toke.dk>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com> <20190614082015.23336-2-toshiaki.makita1@gmail.com> <877e9octre.fsf@toke.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 14 Jun 2019 14:10:38 +0200
Message-ID: <87sgscbc5d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> writes:

> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>
>> dev_map_free() waits for flush_needed bitmap to be empty in order to
>> ensure all flush operations have completed before freeing its entries.
>> However the corresponding clear_bit() was called before using the
>> entries, so the entries could be used after free.
>>
>> All access to the entries needs to be done before clearing the bit.
>> It seems commit a5e2da6e9787 ("bpf: netdev is never null in
>> __dev_map_flush") accidentally changed the clear_bit() and memory access
>> order.
>>
>> Note that the problem happens only in __dev_map_flush(), not in
>> dev_map_flush_old(). dev_map_flush_old() is called only after nulling
>> out the corresponding netdev_map entry, so dev_map_free() never frees
>> the entry thus no such race happens there.
>>
>> Fixes: a5e2da6e9787 ("bpf: netdev is never null in __dev_map_flush")
>> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>
> I recently posted a patch[0] that gets rid of the bitmap entirely, so I
> think you can drop this one...

Alternatively, since this entire series should probably go to stable, I
can respin mine on top of it?

-Toke
