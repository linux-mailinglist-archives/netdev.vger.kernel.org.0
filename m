Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E0457B4F0
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbiGTK5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240136AbiGTK5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:57:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 200AC4B0D8
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 03:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658314659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L3tIBK3odCi2wiUtSPbriFkXsk8gcjLDaLnSU7OmMoI=;
        b=fPBJa0/py+kGodCSgF2EepSI/mEiozAkR7y84kNKKo9vMFKvEypX2jSvSt1T+X57Vp+qzQ
        0EML7H+XcMb0Zel14PMPCo3FSliGgUyfj+k71OZrviFr5pOKx2jPQG4Rj4imKf3kKXtA1m
        aC9qlE7k6rQeAj0PxIWjCTjVVPgR694=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-MuSP0FTYNRqfMXiEAoR0EA-1; Wed, 20 Jul 2022 06:57:37 -0400
X-MC-Unique: MuSP0FTYNRqfMXiEAoR0EA-1
Received: by mail-ej1-f70.google.com with SMTP id nb10-20020a1709071c8a00b006e8f89863ceso3932530ejc.18
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 03:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=L3tIBK3odCi2wiUtSPbriFkXsk8gcjLDaLnSU7OmMoI=;
        b=IWz6+H2U/7D0Ey1mg93QF207/YmXXz0mTW0zMRoHP97GHmYZeSml4bKPYX9b9a73gt
         bk4Nxl+OEi7OUtfBvoj4/V1VlxHzpTFIOv0cjOleV6L548tU3RmTCGurQpJ+yfoxTibZ
         cQ0GvqlfY3mHk/jXcqvHB3+s1ci9lqgwQYkdc5dh5TJ4suk5KG+opipBFfJ18fmIh0H3
         SzVMtOMOAJMxjOyX8QDcVqTqICu6pirC+asmp1scPwylQlDM46eJ4xjE1ffOixGCUS7Q
         bmwGfLNEJ72MhijpRDdyxj5x22Pp7UfPlFXgTYxnaVDe/1IqILl4alkUgHZZO1cl1GHr
         NseA==
X-Gm-Message-State: AJIora/NQ9i1NAa8ZQqIluTUsQAVqHVhT2/Tn42CbSmFK4WINJaAPC8Z
        JEjYjHRJ6j9k3/0+ODaiuUFoSDeJDWEd0qD+HNUGVEvBTgTWPsb0rDLVd6ruiVo5GMYpzp0vbh1
        K5ARqQY8iXs5eeN0h
X-Received: by 2002:a05:6402:1cc8:b0:437:a61a:5713 with SMTP id ds8-20020a0564021cc800b00437a61a5713mr2233488edb.340.1658314656425;
        Wed, 20 Jul 2022 03:57:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uDdXKfV3xVrIkUIckfn6yUw5ELuqmmf+oZ2zwhtsXXU1rrwGdBmLWNy+ePIewka02ZjThKhw==
X-Received: by 2002:a05:6402:1cc8:b0:437:a61a:5713 with SMTP id ds8-20020a0564021cc800b00437a61a5713mr2233452edb.340.1658314656095;
        Wed, 20 Jul 2022 03:57:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g8-20020a056402320800b0043bb8023caesm1031429eda.62.2022.07.20.03.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 03:57:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8C22B4DA011; Wed, 20 Jul 2022 12:57:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Linus =?utf-8?Q?L=C3=BCssing?= <ll@simonwunderlich.de>,
        Adrian Chadd <adrian@freebsd.org>,
        Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Fix wrong channel bandwidths reported for
 aggregates
In-Reply-To: <31e87fa2-6fea-5fe2-ab80-6050da9af7ce@simonwunderlich.de>
References: <20220718222804.21708-1-linus.luessing@c0d3.blue>
 <CAJ-VmomaQ-ai7n5i8-8sXsgaih4vjjHXyw+JQESGMERgC8Qqdw@mail.gmail.com>
 <31e87fa2-6fea-5fe2-ab80-6050da9af7ce@simonwunderlich.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jul 2022 12:57:34 +0200
Message-ID: <87cze0kq5d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus L=C3=BCssing <ll@simonwunderlich.de> writes:

> On 19/07/2022 17:03, Adrian Chadd wrote:
>> Hi!
>>=20
>> It's not a hardware bug. Dating back to the original AR5416 11n chip,
>> most flags aren't valid for subframes in an aggregate. Only the final
>> frame has valid flags. This was explicitly covered internally way back
>> when.
>
> Ah, thanks for the clarification! I see it in the datasheet for the=20
> QCA9531, too, now. And thanks for the confirmation, that what we are=20
> doing so far is not correct for ath9k.
>
> Words 0+2 are valid for all RX descriptors, 0+2+11 valid for the last RX=
=20
> descriptor of each packet and 0-11 for the last RX descriptor of an=20
> aggregate or last RX descriptor of a stand-alone packet. Or in other=20
> words, word 4, which contains the 20 vs. 40 MHz indicator, is invalid=20
> for any aggregate sub-frame other than the last one. I can rename that=20
> in the commit message.
>
>
> Another approach that also came to my mind was introducing more explicit=
=20
> flags in cfg80211.h's "struct rate_info", like a RATE_INFO_BW_UNKNOWN in=
=20
> "enum rate_info_bw" and/or RATE_INFO_FLAGS_UNKNOWN in "enum=20
> rate_info_flags". And setting those flags in ath9k_cmn_process_rate().
>
> The current approach is smaller though, as it simply uses the already=20
> existing flags. If anyone has any preferences, please let me know.

I have no objections to doing it in mac80211 like you're proposing here :)

-Toke

