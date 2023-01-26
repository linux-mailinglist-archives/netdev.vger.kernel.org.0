Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3156F67D7D4
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbjAZVgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjAZVgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:36:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC6A13E
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674768931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPp5FgezLTRv8/n6j2CbiI3M1hJrXQSjOFT+aTSHCWQ=;
        b=BR8Fn1YSWXzDZk+vs4FQ8c9uy0W4HZI9z0yCV72u5mts6tnPHf9L7ZSYXhzVjHpg5InnyD
        Qc2UliviMwoNH8SKAUlMFPFN8tABKnOWD788KjQFiyzgW4tVYZyhPklIji7P4VXkl5iKZr
        WP0Kv/GYVArsPRVQXa8o1eousk1ucL4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-76-S6cHk9qGO5yqYUYNIi5Yjw-1; Thu, 26 Jan 2023 16:35:30 -0500
X-MC-Unique: S6cHk9qGO5yqYUYNIi5Yjw-1
Received: by mail-ej1-f70.google.com with SMTP id nb4-20020a1709071c8400b0084d4712780bso2046721ejc.18
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:35:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wPp5FgezLTRv8/n6j2CbiI3M1hJrXQSjOFT+aTSHCWQ=;
        b=VoiVugm8luEPzbcEHQn1vLtc4rYvEybIcevbUWz5tXL5lfU8Vr6xY8v06WRmJF4fuW
         KNpbHq+3XHqqnoN5txLXlcs9fm9T7fI5dLQ2X9yDHi1KvZVVrMgyUOEyiMpYjzN/ADvb
         GeoZ9sMQojMaN29krHP3zvapyoy5DpWqP6GUIxkBd9Gk7lUeVFoUleX230ehz8lHDHEZ
         zqQYQ3UyEVYArfNghZ24+fbvT+/BraArte1cAoHwPgnAxhusXg5v9bM+xEYdvFVJ8uoF
         vJ6Wr8gH/UQSTXxjJhtdcSUfPnkhP7w9zhBmyO/QzInXLb5Ev/JMi70ChNp51oyY0Q/J
         i0UQ==
X-Gm-Message-State: AFqh2kolHGN9LwP+zUV9G+xOK9U+JCm0Ei+ixJYv38gJJ2aYQd2AzulJ
        nLw3pu/6VK7+zbt3gthC5NfNjGeklnBqqB7HwrAwUlOancr1CzFf3XEX7VdMX1lZyZPbMqhhV9p
        8KhzTTRHSpclX/zkK
X-Received: by 2002:a17:906:f299:b0:7c0:fd1a:79ee with SMTP id gu25-20020a170906f29900b007c0fd1a79eemr39636414ejb.63.1674768929148;
        Thu, 26 Jan 2023 13:35:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXse1aQgjk7OzwHyV0hK4unOcklvyKMqYnBLn5Dt4eFYSU4VegC3jZmirDgxa/gkgJwaBBS/EA==
X-Received: by 2002:a17:906:f299:b0:7c0:fd1a:79ee with SMTP id gu25-20020a170906f29900b007c0fd1a79eemr39636386ejb.63.1674768928756;
        Thu, 26 Jan 2023 13:35:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cm20-20020a170907939400b0086f40238403sm1125890ejc.223.2023.01.26.13.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 13:35:28 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7327B9430CD; Thu, 26 Jan 2023 22:35:27 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nbd@nbd.name, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        lorenzo@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in GRO
In-Reply-To: <CAKgT0UfsLFuCK0vQF70s=8XC8qwrzxag_NR2dCDvxqx84E0K=g@mail.gmail.com>
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
 <87tu0dkt1h.fsf@toke.dk>
 <CAKgT0UfsLFuCK0vQF70s=8XC8qwrzxag_NR2dCDvxqx84E0K=g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 26 Jan 2023 22:35:27 +0100
Message-ID: <87o7qlkmhs.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Duyck <alexander.duyck@gmail.com> writes:

> On Thu, Jan 26, 2023 at 11:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Alexander Duyck <alexander.duyck@gmail.com> writes:
>>
>> > From: Alexander Duyck <alexanderduyck@fb.com>
>> >
>> > GSO should not merge page pool recycled frames with standard reference
>> > counted frames. Traditionally this didn't occur, at least not often.
>> > However as we start looking at adding support for wireless adapters th=
ere
>> > becomes the potential to mix the two due to A-MSDU repartitioning fram=
es in
>> > the receive path. There are possibly other places where this may have
>> > occurred however I suspect they must be few and far between as we have=
 not
>> > seen this issue until now.
>> >
>> > Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in pa=
ge pool")
>> > Reported-by: Felix Fietkau <nbd@nbd.name>
>> > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
>>
>> I know I'm pattern matching a bit crudely here, but we recently had
>> another report where doing a get_page() on skb->head didn't seem to be
>> enough; any chance they might be related?
>>
>> See: https://lore.kernel.org/r/Y9BfknDG0LXmruDu@JNXK7M3
>
> Looking at it I wouldn't think so. Doing get_page() on these frames is
> fine. In the case you reference it looks like get_page() is being
> called on a slab allocated skb head. So somehow a slab allocated head
> is leaking through.

Alright, thanks for taking a look! :)

-Toke

