Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7ED46ADD48
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjCGL3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjCGL3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:29:06 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B60305F3
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 03:29:01 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h14so11770382wru.4
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 03:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678188539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=umtjBf7EsDJIIui+vVt2XX5NZRUSzKr151r7ol+V9AQ=;
        b=EpQVdDazRNWRk56qsyEmhottDqYSGUykaZKTeFCuuziyRaPK6lJIOeXzXDzpucUvGd
         QC+t6QZYZpKvjRag+iTUKNcaMMJ9vjzjALF8tJTNSjaDddoi8fbrL0Muy3ETWlaLHdRM
         /d6PEMLQ2PN97qJEvGbo2+7Pe3EXPhx2TotgQSn+lem+lC4qbkeeImHgJA6F8RGo0/Pb
         aYCP2eHMQj2DD15UfxSTZrTRBEM42qq9DXZfX0XwVPngcD2/dYI7h1cRKw9VZ7qWNEAz
         0YEryd7OVhr7yaQzM0+aKIOtGs07yySTZyVl8CWRL6nPz79PReJh9x8d1Dcu0NoHA5uT
         1uDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678188539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=umtjBf7EsDJIIui+vVt2XX5NZRUSzKr151r7ol+V9AQ=;
        b=DP46g8hHuwdl8nQxSbIlCxUOygdZ+K7ujKL9Kwccv0//cM3I4u+bq6pUO+Jj0hO8oc
         0k5WKpw26LKQXyqBlaQoqop8svDEq1jnFWk3KjSBJxtR+N6Ag+b1p5NQGiherBsROgp0
         zIhbdNihuTMWtANgR/JKn8iRPIxjgGqaC2BWAthgccBQyL6Ulp7nK1kWiW+EKgEj3I2Q
         aF2uN8rGzcFqusMaf1Dk9sI5o8u/aOXYYp4eQIMfoztipgkgTff5wQfCv/UWnN/KFhCB
         bPKYj8Gh+V3hT0Mnq68XuDZ1+3lBEvkd8pUXzPD4lOpMDW92ee0zJJzHIiOKQlbRZaBA
         lSfA==
X-Gm-Message-State: AO0yUKXR1V7CnIicInmIGiDLV3MPl934fD26PKphq6H3v3OlW97sbMg5
        hgVW+uztHQ7JnoeAGvt5hxbLqxeEpBlD+QuSGc4Cuw==
X-Google-Smtp-Source: AK7set/WBLq7N1ONAROTIqsoJy7ILPN/2iHwz/z7HEjXz6Gs+1iaqio0QKa+k9tUYZUhwSMNTY6gG3ybp1t9n/++/u8=
X-Received: by 2002:adf:f584:0:b0:2cb:80af:e8ab with SMTP id
 f4-20020adff584000000b002cb80afe8abmr3073488wro.11.1678188539351; Tue, 07 Mar
 2023 03:28:59 -0800 (PST)
MIME-Version: 1.0
References: <20230307100231.227738-1-edumazet@google.com> <ZAcVL3ZYGkaoFX1+@gondor.apana.org.au>
In-Reply-To: <ZAcVL3ZYGkaoFX1+@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Mar 2023 12:28:47 +0100
Message-ID: <CANn89iKns8CmuM3AK45B5bYFEwcEiNmfMee_4H2SHBcZDVdX+g@mail.gmail.com>
Subject: Re: [PATCH net] af_key: fix kernel-infoleak vs XFRMA_ALG_COMP
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 11:43=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Tue, Mar 07, 2023 at 10:02:31AM +0000, Eric Dumazet wrote:
> > When copy_to_user_state_extra() copies to netlink skb
> > x->calg content, it expects calg was fully initialized.
> >
> > We must make sure all unused bytes are cleared at
> > allocation side.
>
> This has already been fixed:
>
> https://lore.kernel.org/all/Y+RH4Fv8yj0g535y@gondor.apana.org.au/

Ah, I thought this was for a different issue.

I do not see this patch in net tree yet ?

Thanks.
