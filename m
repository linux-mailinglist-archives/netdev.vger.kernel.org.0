Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB0E68D738
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 13:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjBGMvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 07:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjBGMvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 07:51:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739E11BAF4
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 04:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675774213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71cYRxnNV3Nft1MSIVwkiRyc27YIpqb/GO4Gw6LJbDk=;
        b=H5u3TyapeByykotx2q9Enndyxgdz6VgKTQiZEdP0cElCisAA+srMOgACwqsjvLeP8wYHmW
        doLd5ygKyciMNzL7jnwaFnO8Ha9lkXFnmC5a1PzMufzFhJ2JN/BLZtk8fUWjIRmrrxHxHC
        LacblUNh2lABK6wlT5aasdidqvQSBns=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-394-fMvZTZ44Mr2czqbYHi9EZg-1; Tue, 07 Feb 2023 07:50:12 -0500
X-MC-Unique: fMvZTZ44Mr2czqbYHi9EZg-1
Received: by mail-qv1-f71.google.com with SMTP id i7-20020a056214020700b004ffce246a2bso7541225qvt.3
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 04:50:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=71cYRxnNV3Nft1MSIVwkiRyc27YIpqb/GO4Gw6LJbDk=;
        b=TyzaRP2u396sX6i71/5fHvE2ToNmX4ZMqhh9cQ8zxDL1EQNz5xHTFDWSId2zfZ6iDM
         9l13oN2MaHp5eXtD3HRugH2bX75hsDJcWa6uzY4v4nC+eImDhKcrgzyIJl12f6EIfhyt
         u85a9/SlHkNOwibFqIrTJHcGMLn5gKP3C127DV2ECamDRp4tRbq/D+Xp6SY70kvhiksm
         B1XZUuSQ2BCR4u3GSXiW9i3r63xByfSqZbmJuvT4RU5xTNZcy6pcP5iFw3kU9JjGivLH
         sXxvfGDeNy+qc44HdEHfAf5KSe329s4b+XY5u/M5/ldcG6xAGNes0x6Y7AN43P6+OnZe
         xsNA==
X-Gm-Message-State: AO0yUKWkHnUTbK26mpAq7ZpqJOZ7JdC9sdv7yaWRr9M8XkLn2NU5FUx7
        mpcOtO62otCRoECoMM17bpogW2GoBhfVC3Xy19biDvQA94vZIlsfrwMRuMixTej8+mvoZwCBM/+
        ia8NLS6aQg0+khl7lK1vFXQ==
X-Received: by 2002:a05:622a:1744:b0:3b8:5dfe:c3dc with SMTP id l4-20020a05622a174400b003b85dfec3dcmr5917168qtk.3.1675774211741;
        Tue, 07 Feb 2023 04:50:11 -0800 (PST)
X-Google-Smtp-Source: AK7set/ofJT8hG3bXOqWznWfBGft9pgR+PxcAUyqKEkc7AJ4FJU4PHXFlEEAbAST9Dw/uR8q/nnbJw==
X-Received: by 2002:a05:622a:1744:b0:3b8:5dfe:c3dc with SMTP id l4-20020a05622a174400b003b85dfec3dcmr5917147qtk.3.1675774211494;
        Tue, 07 Feb 2023 04:50:11 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id 63-20020a370a42000000b00719d9f823c4sm9301703qkk.34.2023.02.07.04.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 04:50:11 -0800 (PST)
Message-ID: <7a88a3bb4cd2f55dfd7fa11b12e9134df83143a5.camel@redhat.com>
Subject: Re: [PATCH net] net: txgbe: Update support email address
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Date:   Tue, 07 Feb 2023 13:50:08 +0100
In-Reply-To: <20230206025529.3333674-1-jiawenwu@trustnetic.com>
References: <20230206025529.3333674-1-jiawenwu@trustnetic.com>
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

Hi,

On Mon, 2023-02-06 at 10:55 +0800, Jiawen Wu wrote:
> Update new email address for Wangxun 10Gb NIC support team.
>=20
> Fixes: 3ce7547e5b71 ("net: txgbe: Add build support for txgbe")
>=20
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

I'm sorry for nit-picking, but you must avoid empty lines in the tag
are. Please post a v2 without the empty line between the 'Fixes' and
SoB tag,

Thanks,

Paolo

