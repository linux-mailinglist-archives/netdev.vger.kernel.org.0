Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801BE6C471B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 11:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCVKAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 06:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCVKAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 06:00:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306253A88
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679479181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KGBG0nLcaqVCaoLHEF9OcE8CPFbuG5tHdTJ9VqGf1L0=;
        b=b+nQmfwJh+3YJXJF9NquWx3c3HMfOfuBj7zCB6ymRjhv1Xnu1PEQeQYOW58agXH46HmNp+
        azxBuQGAl931txwuX2uL4nocyM+2boMWNz0tL4qVfP29sQIux/S3tqhQQVs06rAg/Ws5uw
        GlThU8TF8H+rWkeweLua0g3B3jnMBHM=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-Lfhgq6IEP4iW-VSqMbesdw-1; Wed, 22 Mar 2023 05:59:40 -0400
X-MC-Unique: Lfhgq6IEP4iW-VSqMbesdw-1
Received: by mail-vs1-f72.google.com with SMTP id d18-20020a67e112000000b00425d3211955so4751662vsl.2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679479179; x=1682071179;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KGBG0nLcaqVCaoLHEF9OcE8CPFbuG5tHdTJ9VqGf1L0=;
        b=oui4NRsoQyTXT8exLtuLxj1HNmt9Sa6v88Tp6LLdY2qgjpoU/FFp+yu9tr9mWl3bpU
         0n+J4BuW218tNANar5ysL6mI0UO/aKuswK/R9J24Dw8CPIQyybq4TKFgIAzrqqy7pscD
         89M1GVFhQAVLDNM4mVTPJ4d4m0lKxNs91R+csitMkYbBxJPTOxl68CG/XEcSJUmuI7sR
         E/w9MBNVEiJiBf6AWYUMsIC3SF+Xw2MqHkbzz/QbTvPSjN1UM/aqjHLBSjch8rk4y4Cl
         GiUZEB+b+qnMHcwlOA27Dn+CPBE1UTMBwKsrILXZVv8Swd40520mmk78Wa7zqN3T8+pa
         niqA==
X-Gm-Message-State: AO0yUKUUJfQaR/n26L+YKyUWSJ6raJEkAuKnF4BDR5wgb4/kIy1fEt80
        P0HZBF+NJZ7H8Nzr3bvHtY7XXhHHbpfkj4gqENScuX/3ruBOIJFBaonacyAz1SEO6z8S5Z4SQgY
        VWj34rBiVmARbqzLmvwBkpqG/
X-Received: by 2002:ac5:ccc4:0:b0:40f:42c7:25f with SMTP id j4-20020ac5ccc4000000b0040f42c7025fmr2447920vkn.0.1679479179583;
        Wed, 22 Mar 2023 02:59:39 -0700 (PDT)
X-Google-Smtp-Source: AK7set8oKZIRsXd2QJi/YoLOXNCkOojL9HERUI1U8eu+QCc5P/KIxvm+kKXv/ez+/1Kn4g2NAzosHw==
X-Received: by 2002:ac5:ccc4:0:b0:40f:42c7:25f with SMTP id j4-20020ac5ccc4000000b0040f42c7025fmr2447911vkn.0.1679479179273;
        Wed, 22 Mar 2023 02:59:39 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-168.dyn.eolo.it. [146.241.244.168])
        by smtp.gmail.com with ESMTPSA id i13-20020a1f9f0d000000b004365a349a03sm1140018vke.7.2023.03.22.02.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 02:59:38 -0700 (PDT)
Message-ID: <889f2dc5e646992033e0d9b0951d5a42f1907e07.camel@redhat.com>
Subject: Re: [PATCH v4 2/2] gro: optimise redundant parsing of packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, dsahern@kernel.org,
        alexanderduyck@fb.com, lucien.xin@gmail.com, lixiaoyan@google.com,
        iwienand@redhat.com, leon@kernel.org, ye.xingchen@zte.com.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 22 Mar 2023 10:59:30 +0100
In-Reply-To: <20230320170009.GA27961@debian>
References: <20230320163703.GA27712@debian> <20230320170009.GA27961@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-03-20 at 18:00 +0100, Richard Gobert wrote:
> Currently the IPv6 extension headers are parsed twice: first in
> ipv6_gro_receive, and then again in ipv6_gro_complete.
>=20
> By using the new ->transport_proto field, and also storing the size of th=
e
> network header, we can avoid parsing extension headers a second time in
> ipv6_gro_complete (which saves multiple memory dereferences and condition=
al
> checks inside ipv6_exthdrs_len for a varying amount of extension headers =
in
> IPv6 packets).
>=20
> The implementation had to handle both inner and outer layers in case of
> encapsulation (as they can't use the same field). I've applied a similar
> optimisation to Ethernet.
>=20
> Performance tests for TCP stream over IPv6 with a varying amount of
> extension headers demonstrate throughput improvement of ~0.7%.

I'm surprised that the improvement is measurable: for large aggregate
packets a single ipv6_exthdrs_len() call is avoided out of tens calls
for the individual pkts. Additionally such figure is comparable to
noise level in my tests.

This adds a couple of additional branches for the common (no extensions
header) case.=20

while patch 1/2 could be useful, patch 2/2 overall looks not worthy to
me.

I suggest to re-post for inclusion only patch 1, unless others have
strong different opinions.

Cheers,

Paolo

