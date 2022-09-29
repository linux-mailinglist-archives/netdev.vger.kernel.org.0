Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2538B5EF4F7
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 14:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiI2MIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 08:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbiI2MIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 08:08:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA85147CC2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 05:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664453322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ronFZfpjdb0h2Pzp479l493H9793DC5HHxc3BcSHGuA=;
        b=UzR0bjHp5lC52Ri93VtOVMggu7jyEiALmmzW5sNkC7hPlnBOZYPJJEO3khyTGpxYQhph9E
        UFkxBuRqs2VuHu4AtRvZiaUc5mfaJIXMy/8/HmIcWIw/nRYxKdc3Mx89OwY++dZNvR8bPY
        Kx7WR1TnnGY1VGC3SCjDL5zpM7UnBf8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-639-OcEanYf2PHyc458QRG5oFg-1; Thu, 29 Sep 2022 08:08:41 -0400
X-MC-Unique: OcEanYf2PHyc458QRG5oFg-1
Received: by mail-ej1-f69.google.com with SMTP id qk10-20020a1709077f8a00b0078297c303afso617606ejc.20
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 05:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=ronFZfpjdb0h2Pzp479l493H9793DC5HHxc3BcSHGuA=;
        b=UeeKMw8xOinuo8hvzlsIUp9+/40QGw5yt0jOi1z57bpyWot/Ku285SoLjLlnUeYw28
         YbqYkv58JlZymYytY47bZjGRvvppmGjq/OqB7dS7IyPecc/gONHc0vhtyIERAA8dIMiW
         Z+j6UKwOtATJ/WJoqYJ2vw5FmFM6E9OrLHENXrgn2KgmhuEwjYtziKnh2//LQGKfw9TA
         7VJc+vnW3yF/dx6JZwFHJJpu4suavX95Y+CRA/UL/ugKWy2wJ4lX9a4Nql3LcKoX9KkN
         OpDSyTMkwI6beNoQX1m/2uCygZ8N/wP9IHO1UYMIXfU0vfjzCsYqxaygmSuLNOODIIoR
         2UgA==
X-Gm-Message-State: ACrzQf0C+Q+18u6OWTmarX2eT4fNJ38tBBU66ZZid+cBNFZ36oEOhTsW
        gNpHqHh2TC7uyG4Z9qDyLiKhoacHof8hboNgWyz8/vuhApAc6ZQRjpCnTq01zu+UCpRzG0lpSfS
        tFmBR09rIKiVTLUL9
X-Received: by 2002:a05:6402:5288:b0:457:22e5:8022 with SMTP id en8-20020a056402528800b0045722e58022mr3005450edb.244.1664453319973;
        Thu, 29 Sep 2022 05:08:39 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4qtrJKq/7svdmTq8uLbOZlzvysvk2Y9tXJZ8fLxphshbRLgH8xBPCuAZsAknXbyTHEoxLubQ==
X-Received: by 2002:a05:6402:5288:b0:457:22e5:8022 with SMTP id en8-20020a056402528800b0045722e58022mr3005427edb.244.1664453319645;
        Thu, 29 Sep 2022 05:08:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 16-20020a170906329000b007389c5a45f0sm3913491ejw.148.2022.09.29.05.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 05:08:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 61B4C64E010; Thu, 29 Sep 2022 14:08:38 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Heng Qi <hengqi@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
In-Reply-To: <c1831b89-c896-80c3-7258-01bcf2defcbc@linux.alibaba.com>
References: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
 <87wn9proty.fsf@toke.dk>
 <f760701a-fb9d-11e5-f555-ebcf773922c3@linux.alibaba.com>
 <87v8p7r1f2.fsf@toke.dk>
 <189b8159-c05f-1730-93f3-365999755f72@linux.alibaba.com>
 <567d3635f6e7969c4e1a0e4bc759556c472d1dff.camel@redhat.com>
 <c1831b89-c896-80c3-7258-01bcf2defcbc@linux.alibaba.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 29 Sep 2022 14:08:38 +0200
Message-ID: <87o7uymlh5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heng Qi <hengqi@linux.alibaba.com> writes:

>>> As I said above in the real case, the user's concern is not why the performance
>>> of xdp becomes bad, but why the data packets are not received.
>> Well, that arguably tells the end-user there is something wrong in
>> their setup. On the flip side, having a functionally working setup with
>> horrible performances would likely lead the users (perhaps not yours,
>> surely others) in very wrong directions (from "XDP is slow" to "the
>> problem is in the application")...
>>
>>> The default number of veth queues is not num_possible_cpus(). When GRO is enabled
>>> by default, if there is only one veth queue, but multiple CPUs read and write at the
>>> same time, the efficiency of napi is actually very low due to the existence of
>>> production locks and races. On the contrary, the default veth_xmit() each cpu has
>>> its own unique queue, and this way of sending and receiving packets is also efficient.
>>>
>> This patch adds a bit of complexity and it looks completely avoidable
>> with some configuration - you could enable GRO and set the number of
>> queues to num_possible_cpus().
>>
>> I agree with Toke, you should explain the end-users that their
>> expecations are wrong, and guide them towards a better setup.
>>
>> Thanks!
>
> Well, one thing I want to know is that in the following scenario,
>
> NIC   ->   veth0----veth1
>   |           |        |
> (XDP)      (XDP)    (no XDP)
>
> xdp_redirect is triggered,
> and NIC and veth0 are both mounted with the xdp program, then why our default behavior
> is to drop packets that should be sent to veth1 instead of when veth0 is mounted with xdp
> program, the napi ring of veth1 is opened by default at the same time? Why not make it like
> this, but we must configure a simple xdp program on veth1?

As I said in my initial reply, you don't actually need to load an XDP
program (anymore), it's enough to enable GRO through ethtool on both
peers. You can easily do this on setup if you know XDP is going to be
used in your environment.

-Toke

