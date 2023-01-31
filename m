Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6FD682BC7
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjAaLr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjAaLr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:47:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10A55FE6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675165629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=viqpHWhPo/KOVRQlm6/EPChg5qrOk8FiTFF1q6ZWvFs=;
        b=Fo7vvvq4cpC5wiS0VrPOv8sP5i1DrF54KkajQJKGbiPyd7MGHZxrBN/rkdvrO790Ey1FKK
        mwlY3bIksYIXnhj8QH7g0cEzkDsqkUzhoTU4B7Hrzg74AasLOoa1FFAa8e5axeHP6hykjz
        re+5rbbz7s1tUBepjx9HEdSaW15mr88=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-472-Ucghc6vFPaWFQQhhvblLGQ-1; Tue, 31 Jan 2023 06:47:08 -0500
X-MC-Unique: Ucghc6vFPaWFQQhhvblLGQ-1
Received: by mail-qv1-f72.google.com with SMTP id i17-20020a0cfcd1000000b005377f5ce3baso7956931qvq.10
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:47:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=viqpHWhPo/KOVRQlm6/EPChg5qrOk8FiTFF1q6ZWvFs=;
        b=GrT2QxUVYnyBR6Mb3fYzISkaEUiX+SDITrC+1Xp8YBurvC7J+sIbm25kEPRGOTB/DO
         RuM41QLgxU95YiQfFvjbUSPf1zfaLwbWEDSCQcs35hIggt/63hxVCQ665lVJKKt/nXDs
         fXlFepEUKEXRLQ0WvjRAOG9RX2sstaKAyKCBxSO9sXChBKJf+Q2VY5LwOybKcLElFx2R
         zesQPs8JPtZN81fgHjyGlrOC6pcuO7Bo7pnv3mzH2srsXL74qZoI5P2Yrjg5dkclPx3F
         VToV+t9HgyZKgNtZWfOaPRJpoaesyItIcNfCLQIqeUWiU0eg1Wc8ZtXcBTjrmfFAD6jQ
         bZfQ==
X-Gm-Message-State: AO0yUKXIL0TLKU96budixRb8EbX/BDT/hFqHOx+Dg8QO+JnAzLFJGv61
        81RbKWrdzqVA+5lhNV5Q8ta8sG0CHnNIuYnV4TdvbDpUyA1zlMeb0Yl/KjSBCpFc0XIfUVZQmub
        BgEEjr7kAfNynTTHu
X-Received: by 2002:a05:622a:1b26:b0:3b9:b608:15ff with SMTP id bb38-20020a05622a1b2600b003b9b60815ffmr151746qtb.6.1675165627638;
        Tue, 31 Jan 2023 03:47:07 -0800 (PST)
X-Google-Smtp-Source: AK7set+OsvoMJaKEdiMO0IGIX2KVcCVugOQ5znDioMvtByElXVrSz1WJKmPFg6/YhgJO2QufL2FSxA==
X-Received: by 2002:a05:622a:1b26:b0:3b9:b608:15ff with SMTP id bb38-20020a05622a1b2600b003b9b60815ffmr151733qtb.6.1675165627386;
        Tue, 31 Jan 2023 03:47:07 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id k8-20020ac80208000000b003b1546ee6absm9792989qtg.11.2023.01.31.03.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 03:47:06 -0800 (PST)
Message-ID: <801a4a44f0fb6e37f79037eae9a3db50191cdb12.camel@redhat.com>
Subject: Re: [PATCH net-next v2] netlink: provide an ability to set default
 extack message
From:   Paolo Abeni <pabeni@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 31 Jan 2023 12:47:03 +0100
In-Reply-To: <c1a88f471a8aa6d780dde690e76b73ba15618b6d.1675010984.git.leon@kernel.org>
References: <c1a88f471a8aa6d780dde690e76b73ba15618b6d.1675010984.git.leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2023-01-29 at 18:51 +0200, Leon Romanovsky wrote:
> In netdev common pattern, extack pointer is forwarded to the drivers
> to be filled with error message. However, the caller can easily
> overwrite the filled message.
>=20
> Instead of adding multiple "if (!extack->_msg)" checks before any
> NL_SET_ERR_MSG() call, which appears after call to the driver, let's
> add new macro to common code.
>=20
> [1] https://lore.kernel.org/all/Y9Irgrgf3uxOjwUm@unreal
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

I'm sorry for nit-picking, but checkpatch complains the author
(leon@kernel.org) does not match the SoB tag. A v3 with a suitable
From: tag should fix that.

Thanks,

Paolo

