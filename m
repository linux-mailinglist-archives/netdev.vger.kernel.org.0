Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471E568DE61
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 17:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjBGQ6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 11:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjBGQ6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 11:58:07 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F2B3BDA6
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 08:58:07 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id pj3so15646028pjb.1
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 08:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HCOXezFqsZDHjjvOl5q6klLApbFo4bKDgjGcsq/psLk=;
        b=mfiVfnO6YmTFsqP5rHovzdwzoN/BEx2hxRq0dHL/7qyNZ1ppX5pUyRijsX2IbJ2ENe
         E4RLg0n5uYbHNnEkXPkZJoaOqMD2Byb2zNOqDfJIkSXLyBZM8di+rB4fid40d6ErObJ4
         4ttCL0XjAn/rvlBcid2HziZCpwA6ssqw16XToWeIWmTmDBMAyDP8aeCSca7AOA2C4pER
         mavGMTrnzhV5yfTGt0lEGjtlSCas7YmyPpiTdEHmIW1Om6+aIoI13ifl6s/kepQzvnxo
         XImG++2E7SDPjRBxhUl1cTod1aghmnJtYUUo1SGJcYX+r3ekrCWrZD4t+ru0QR1lTaE9
         /rGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HCOXezFqsZDHjjvOl5q6klLApbFo4bKDgjGcsq/psLk=;
        b=B4Yik/XUZ7E6S6CfeEFwPuiugGCLNZhR3F2Bmy1cdiVAuANf6dbZ7+s1pR2DxdeOY0
         PfLTIxL5eE9qAaB42HE1h4zp1gMg0vkPSICxYCXGdluLDDi9shcK6vugE0Xv1HTLFRKw
         bWogc8PVyA1ebc3fwR0qepgN1u/MDCVBFlr9owwp+YHqvOdW33HSScCDDh6MKjPOmJr0
         aRuqHcfCOGhr1fElCExVrOWyNLXosVpprSKoJGRQdHwSB5n5fvo28GOoJ5HaXWH82RVL
         jZWsj7aX6F6UD73g8kGZHnm4/Fq4jfwKh3oSzeiOWBIYsZU8gky7MZtflgTAtW3jGvvx
         MFdA==
X-Gm-Message-State: AO0yUKXWwLOR14w2iIkn8zoz155WD3Mhk/89WvLyyWOqYO6/vyAm0ybN
        lCFLpYy78pkdPkjgKB41iHE=
X-Google-Smtp-Source: AK7set/4rLoqNvgq9DhmBvqbYtpJfMzOLWLuEcwKu89LqKXYSM2gAjfOrwspq2u1CtGVEJuWV0Z5zA==
X-Received: by 2002:a17:902:cf09:b0:198:e13e:e73e with SMTP id i9-20020a170902cf0900b00198e13ee73emr3134834plg.53.1675789086240;
        Tue, 07 Feb 2023 08:58:06 -0800 (PST)
Received: from [192.168.0.128] ([98.97.39.127])
        by smtp.googlemail.com with ESMTPSA id x23-20020a1709027c1700b001946a3f4d9csm9146025pll.38.2023.02.07.08.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 08:58:05 -0800 (PST)
Message-ID: <b9eeaeb896fe5913e411d1bf90ebbec2a2ab0e31.camel@gmail.com>
Subject: Re: [PATCH v2 net-next 0/4] net: core: use a dedicated kmem_cache
 for skb head allocs
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 07 Feb 2023 08:58:04 -0800
In-Reply-To: <20230206173103.2617121-1-edumazet@google.com>
References: <20230206173103.2617121-1-edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-02-06 at 17:30 +0000, Eric Dumazet wrote:
> Our profile data show that using kmalloc(non_const_size)/kfree(ptr)
> has a certain cost, because kfree(ptr) has to pull a 'struct page'
> in cpu caches.
>=20
> Using a dedicated kmem_cache for TCP skb->head allocations makes
> a difference, both in cpu cycles and memory savings.
>=20
> This kmem_cache could also be used for GRO skb allocations,
> this is left as a future exercise.
>=20
> v2: addressed compile error with CONFIG_SLOB=3Dy (kernel bots)
>     Changed comment (Jakub)
>=20
> Eric Dumazet (4):
>   net: add SKB_HEAD_ALIGN() helper
>   net: remove osize variable in __alloc_skb()
>   net: factorize code in kmalloc_reserve()
>   net: add dedicated kmem_cache for typical/small skb->head
>=20
>  include/linux/skbuff.h |   8 +++
>  net/core/skbuff.c      | 115 +++++++++++++++++++++++++++++------------
>  2 files changed, 90 insertions(+), 33 deletions(-)
>=20

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>


