Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04E26DDA85
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjDKMOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjDKMOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:14:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5AF2D55
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681215206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+LAR+Nh+ywpoqn7HOuJEg1+vlx3eknXKjWPLOIZ+2s=;
        b=WrSeNHt5FN9/pqxip6OMZNZyoxy3x0o3MH13Vd3Ch7Db7aiXsnhSDWpO8GLzg976/oRdoT
        ORRKJ7dPROWhkbSJLhC25qgaNjm0hTKRFKZXAt9Rybu7su+v200P6gJmesH+TuoA/QRm4j
        jRBUnFMhvE6BTDqCsP4RaHosum9rG8g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-2A3AB4FMOm-t1EP6_M_UjQ-1; Tue, 11 Apr 2023 08:13:25 -0400
X-MC-Unique: 2A3AB4FMOm-t1EP6_M_UjQ-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5048993669bso1037885a12.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:13:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681215204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+LAR+Nh+ywpoqn7HOuJEg1+vlx3eknXKjWPLOIZ+2s=;
        b=kXd693ccX6uilVQCc2Ol4XD5535NG5YThBfnV83Ej9leQMViiz1rtwrxiw30u80r22
         V8A9x+pT3Nlxqbd02q2HvB+YYlsR3cYbRZHjWgoM4lYsSsJcdQW1UcuYHBUWvnsRBvj+
         tRFVa33c/RFS9kHypbcpiFN22DiUgyKJ5gwBIf+FL6wWKXS4mX0e/tb992KuxKvNJr5R
         xloHxLGAnlelGY7PQk0gabn6mtgM3E25hegAWp86dDcE1VDZrK16xgOWOT+34FaXLmZa
         MQbcHqpwOum8it8vvdwH72XGr2RL5l+OwkEkhiSWbWcyQ3Kj2IkVMNQK0HJZk36oDbA7
         zkVg==
X-Gm-Message-State: AAQBX9dJCzQCybSkrTg4++EAv0pht9IQAHQceSX+cqtvyzIxGib6Lg6B
        ZOjGwIHICIlYE1409pHDKC5tgeeRSEIr8IaleM9QPED2bDrhZQStUhtoh+uN81jjaoHffRV9Fi6
        OrYn3wA+VZNp/ojMS+5u3dVvcTKjIK5tX
X-Received: by 2002:aa7:dbcb:0:b0:502:233e:af49 with SMTP id v11-20020aa7dbcb000000b00502233eaf49mr11991548edt.4.1681215204284;
        Tue, 11 Apr 2023 05:13:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350ak30ZX/MBd/MO8vDkeMAWQK6PTsACeMUjed7L1rjoJ6tC2eFSQ1+po+0eatykOUssvudG2A7+swQR4Fw5uZRE=
X-Received: by 2002:aa7:dbcb:0:b0:502:233e:af49 with SMTP id
 v11-20020aa7dbcb000000b00502233eaf49mr11991530edt.4.1681215204013; Tue, 11
 Apr 2023 05:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230411090122.419761-1-miquel.raynal@bootlin.com> <20230411090122.419761-2-miquel.raynal@bootlin.com>
In-Reply-To: <20230411090122.419761-2-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 11 Apr 2023 08:13:12 -0400
Message-ID: <CAK-6q+gNq_dX0_EVrc1Sa8OxBUCFV6hpqmMokLiBbRLDUzXiMg@mail.gmail.com>
Subject: Re: [PATCH wpan-next 2/2] MAINTAINERS: Add wpan patchwork
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Apr 11, 2023 at 5:03=E2=80=AFAM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote:
>
> This patchwork instance is hosted on kernel.org and has been used for a
> long time already, it was just not mentioned in MAINTAINERS.
>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks.

- Alex

