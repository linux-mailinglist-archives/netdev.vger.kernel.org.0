Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EB86E3C2A
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 23:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjDPVck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 17:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjDPVcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 17:32:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DBF1FEF
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 14:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681680706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruH//Xy9e9ni2YfVHT5JNNTiAFGpSuPtH8/J+rNytAA=;
        b=FamteYj7n5qy+4qGfjt9BLOmLhXbZ6J3fVt5+jGm9myWPVuVGc1WwiB50PVNUOVe3HFlWj
        r/OdgMywtTQyXP4wfiko4GQwrJDinhrECLVLRW77fT/JqoS0y7CmduOgMfcaRAfCaw8yHX
        uMBcckllZ83kmdjf8r0FrddxwoLZAPc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-pFeAozcgMZm1NsTq5WJgVg-1; Sun, 16 Apr 2023 17:31:45 -0400
X-MC-Unique: pFeAozcgMZm1NsTq5WJgVg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a341ee4fcso343888866b.0
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 14:31:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681680704; x=1684272704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ruH//Xy9e9ni2YfVHT5JNNTiAFGpSuPtH8/J+rNytAA=;
        b=UsQ692eMRjLAMX1g1dPR2myFAINIZMC3Xbt1qWP0mEzDm+KU4c8UYLMQ+yz61kcJde
         V1gTyakz3CohO07jPxohWpcwi85gZc3yZdM7+aGJAPFShJTCZy0J2LrF6NGKl+0r+nmz
         2LXmHwAiUItczBSc74THHHjNMlok52e59diDY3K6IBztGTUcF2n82FFMrps9oup9/j6h
         llhN1MdSotME5Ed4qj2YnuLr7kq+9C+QK8qs0TgDEcxFeGkj8L2z1FoTAvphtFcvhRyr
         YzEPJpwBkZMSkthWUPoPhjx1USEgzcY8t5NV1CeFAiLg7w1c/c41AATC4dtRfm5cNrwm
         vSeA==
X-Gm-Message-State: AAQBX9c9Bvg7kFSoanBzOAeDYQBmeFZrTtwEWsRyCImiimFK+/1OKgHx
        J2HVFeUDdONScCIFQ6Kfd5mXyM77pesYZA1ZwMry6ge1oFxShO2MfOzYDeRjMaeZFUP8wWhbDUv
        X5zNOIAnzrs0EFWnCsA48MI/8oR+udm7N
X-Received: by 2002:a05:6402:2d9:b0:506:87cb:149f with SMTP id b25-20020a05640202d900b0050687cb149fmr6259777edx.39.1681680704241;
        Sun, 16 Apr 2023 14:31:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350aR7Ah/WWghVQJKF8V+r/pbNP/8xiztQhL3nVkhLJX3wC7Q1Sm8LR73iCNJfCE140fXI9M5Axu5hFQUNH8LROQ=
X-Received: by 2002:a05:6402:2d9:b0:506:87cb:149f with SMTP id
 b25-20020a05640202d900b0050687cb149fmr6259758edx.39.1681680704011; Sun, 16
 Apr 2023 14:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230415210506.2283603-1-aahringo@redhat.com> <2501c864-cbca-0b81-2e6a-0ee63473c31c@kernel.org>
In-Reply-To: <2501c864-cbca-0b81-2e6a-0ee63473c31c@kernel.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 16 Apr 2023 17:31:32 -0400
Message-ID: <CAK-6q+iQprUr3JJCytxbAUC-QLxaSRgz6WO+U=bZ6L9rxYHFfg@mail.gmail.com>
Subject: Re: [PATCH net] net: rpl: fix rpl header size calculation
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alex.aring@gmail.com,
        daniel@iogearbox.net, ymittal@redhat.com, mcascell@redhat.com,
        torvalds@linuxfoundation.org, mcr@sandelman.ca
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Apr 16, 2023 at 12:37=E2=80=AFPM David Ahern <dsahern@kernel.org> w=
rote:
>
> On 4/15/23 3:05 PM, Alexander Aring wrote:
> > diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
> > index 488aec9e1a74..16e19fec18a4 100644
> > --- a/net/ipv6/rpl.c
> > +++ b/net/ipv6/rpl.c
> > @@ -32,7 +32,7 @@ static void *ipv6_rpl_segdata_pos(const struct ipv6_r=
pl_sr_hdr *hdr, int i)
> >  size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
> >                        unsigned char cmpre)
> >  {
> > -     return (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
> > +     return 8 + (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre=
);
>
>
>
> no magic numbers; there should be a macro for that size.
>

ok. We can actually use sizeof(*hdr) here. Which is actually the
header size without the "addresses" payload.

Thanks.

- Alex

