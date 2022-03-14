Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D304D8F63
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245517AbiCNWR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiCNWR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:17:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B4C43D49A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647296176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WF7SE6fvYn0URatsmmFk/VwiejUBUmnRrvjWLretojY=;
        b=CB5Fl3MjpQc/4QByITuzXVPOHq6mL5L/lUasScK7w5zF+eO39mbyu2Iio5LQkUVa3gK6tC
        /GD3xagpBLw5TbQ1YwwzraXAo/Z2HRbY/ZhVJhT94VeiqVONMI4YCZySdT4SEyK47mI1PH
        fkY8aZFqHbQuQOmXSqfpSX8bcciQJvE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-hzeS8AHlOiGpZyyOM4eWVA-1; Mon, 14 Mar 2022 18:16:15 -0400
X-MC-Unique: hzeS8AHlOiGpZyyOM4eWVA-1
Received: by mail-ej1-f69.google.com with SMTP id gz16-20020a170907a05000b006db8b2baa10so6213664ejc.1
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:16:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=WF7SE6fvYn0URatsmmFk/VwiejUBUmnRrvjWLretojY=;
        b=Fq00eiRfG7izHoaoMH0UQgmQR87YA0sXv/LsTYMskpr+XPRgZlPbCkVinkVUx1VyQL
         jdRn0JrS7m579E29p8u1S/Yu2x2FK1xGPF/kapUeCTzzX6RQrMxILgVsG4sGP7bHyFAm
         Gf1qaxDkCNsejD6v0F2z7CkFb4mQLX/w0NTkPLg/sCXdO0/Xt254CVweebL0nPU5vPQ2
         YNxJM/ZjzPP4WMP2F9NG7WY5tgcezQ/314Jyw2mk/vaBFu4LgY0/qESchVYvKFKImovr
         G8HiQLQO4HJwnHFGE1m602QHHN7MQ/87a20tIsVrQxSXua8OGyOUvUiSE5OnSZmYOtjn
         JKGQ==
X-Gm-Message-State: AOAM533Q5DkYN22KaerxtC0GcPfxI2Gao+RY5qhsTOBNyQtyQVwghhLh
        n0N+H3jlf1Q9Nk6IDnDTUeFfAVGNF+puhAobvPCSD0woDktOdA52XQyjOoPZ68BMXrAr5iUcbv1
        l6vunlKIftnGV2YOs
X-Received: by 2002:a17:906:6158:b0:6ce:61d6:f243 with SMTP id p24-20020a170906615800b006ce61d6f243mr20083976ejl.268.1647296172798;
        Mon, 14 Mar 2022 15:16:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSqdt3hMHdgKKsPVZn3Wit7aXk5zzY+ry2bRAQ+NDvj1kZVSjbxnPpD/sueEr6hvtlBvHFaA==
X-Received: by 2002:a17:906:6158:b0:6ce:61d6:f243 with SMTP id p24-20020a170906615800b006ce61d6f243mr20083915ejl.268.1647296171667;
        Mon, 14 Mar 2022 15:16:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm7380911ejb.194.2022.03.14.15.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 15:16:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 07DAD1ABC05; Mon, 14 Mar 2022 23:16:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>,
        "Jesper D. Brouer" <netdev@brouer.com>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
Cc:     brouer@redhat.com, John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: xdp: allow user space to request a smaller packet
 headroom requirement
In-Reply-To: <4ff44a95-2818-32d9-c907-20e84f24a3e6@nbd.name>
References: <20220314102210.92329-1-nbd@nbd.name>
 <86137924-b3cb-3d96-51b1-19923252f092@brouer.com>
 <4ff44a95-2818-32d9-c907-20e84f24a3e6@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 14 Mar 2022 23:16:10 +0100
Message-ID: <87pmmouqmt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 14.03.22 21:39, Jesper D. Brouer wrote:
>> (Cc. BPF list and other XDP maintainers)
>> 
>> On 14/03/2022 11.22, Felix Fietkau wrote:
>>> Most ethernet drivers allocate a packet headroom of NET_SKB_PAD. Since it is
>>> rounded up to L1 cache size, it ends up being at least 64 bytes on the most
>>> common platforms.
>>> On most ethernet drivers, having a guaranteed headroom of 256 bytes for XDP
>>> adds an extra forced pskb_expand_head call when enabling SKB XDP, which can
>>> be quite expensive.
>>> Many XDP programs need only very little headroom, so it can be beneficial
>>> to have a way to opt-out of the 256 bytes headroom requirement.
>> 
>> IMHO 64 bytes is too small.
>> We are using this area for struct xdp_frame and also for metadata
>> (XDP-hints).  This will limit us from growing this structures for
>> the sake of generic-XDP.
>> 
>> I'm fine with reducting this to 192 bytes, as most Intel drivers
>> have this headroom, and have defacto established that this is
>> a valid XDP headroom, even for native-XDP.
>> 
>> We could go a small as two cachelines 128 bytes, as if xdp_frame
>> and metadata grows above a cache-line (64 bytes) each, then we have
>> done something wrong (performance wise).
> Here's some background on why I chose 64 bytes: I'm currently 
> implementing a userspace + xdp program to act as generic fastpath to 
> speed network bridging.

Any reason this can't run in the TC ingress hook instead? Generic XDP is
a bit of an odd duck, and I'm not a huge fan of special-casing it this
way...

-Toke

