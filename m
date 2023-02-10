Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE7F692239
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjBJPb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjBJPbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:31:55 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C412610A80;
        Fri, 10 Feb 2023 07:31:53 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d2so5510783pjd.5;
        Fri, 10 Feb 2023 07:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YntHxMIBRAfXBvg4kt1JOmAZhLio6nfUJbD5SfRxTNI=;
        b=kZuojpOy4YGVX16Sbed7M6v9WGJ0owZKwcTCcmXobeKdakzHXz0T07dSj7yl38XfoX
         99BQ+Ym17yAOZJGyYa8g4Rc8amfsCFctAI/Zv8zAitMYljcbIcX/RFPGnrTqzz9qyTsm
         f85D5gxirsOk8SV+XXJnzAcMIy6+4BzHlcgrJ5z+QrS7kwVyfQJZ9h6UgSUMg6RDp43e
         xgtfbmPppLoq/dwergZPD4z1MaFXOFWve1ETh5Dox7ykpNiVAVNajpcs3F7LY2pMduWy
         Gpkv5j0zTqnLcVcCUW0CWUYLBlTev7EE/2PGOriEZyNRNDBVcoFGFE5Hz6yv5alNFAyH
         l1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YntHxMIBRAfXBvg4kt1JOmAZhLio6nfUJbD5SfRxTNI=;
        b=ONLbmuOyBioj/9M5zpXsafTIIfHIuw9APHKhS1lrtQZK7uj9HTABEBFAqmyiBWffyl
         pdlQyL1qUkE62auDPS+2lwqntUvoGG/ghWPHPmUYxBlf7bV1T1r5q2dLsKx6JZ9KZeq7
         c6Bn/U8K1QtdXSPBNGOnWM0omlS9seUWUfz2Yg1z7d42hvb5nzKxOtamL1Oo03Hxgo07
         mvaSLNnfqINjHjF2XZpsdDBR+MjjA8htkigxW1dNv48z4xDMPeizDutzDGTVqgj3P52c
         2pFwLsVzhXAS9S9DifrMyGblVoed/WS1O13bS2cDWCTo9Wvhdcf35sQsqQUaG8okbD1g
         1FJg==
X-Gm-Message-State: AO0yUKUTxNrcBkX5FbphqNfWt6i17IleiabTCQ9IV9ymWGaPdrsSIbTC
        mC2ZrtqM4WNRDp4KypTRN1g=
X-Google-Smtp-Source: AK7set9z10lkKl1KoYacyMstnPFU+j27jsezsaXUaY+JBg5NQjyzruu3WE0iOmKHxxZsrlndkatchw==
X-Received: by 2002:a17:90a:5e4d:b0:22c:8161:5143 with SMTP id u13-20020a17090a5e4d00b0022c81615143mr16849764pji.31.1676043113061;
        Fri, 10 Feb 2023 07:31:53 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id t8-20020a17090a3e4800b002338b6bd196sm1779773pjm.44.2023.02.10.07.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 07:31:52 -0800 (PST)
Message-ID: <c57e43e4f7a42f8664cd46441c91c517c8fcb143.camel@gmail.com>
Subject: Re: [PATCH net-next v3 0/4] net: renesas: rswitch: Improve TX
 timestamp accuracy
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Date:   Fri, 10 Feb 2023 07:31:51 -0800
In-Reply-To: <20230209081741.2536034-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230209081741.2536034-1-yoshihiro.shimoda.uh@renesas.com>
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

On Thu, 2023-02-09 at 17:17 +0900, Yoshihiro Shimoda wrote:
> This patch series is based on next-20230206.
>=20
> The patch [[123]/4] are minor refacoring for readability.
> The patch [4/4] is for improving TX timestamp accuracy.
> To improve the accuracy, it requires refactoring so that this is not
> a fixed patch.
>=20
> Changes from v2:
> https://lore.kernel.org/all/20230208235721.2336249-1-yoshihiro.shimoda.uh=
@renesas.com/
>  - Fix sparse warnings in the patch [4/4].
>=20
> Changes from v1:
> https://lore.kernel.org/all/20230208073445.2317192-1-yoshihiro.shimoda.uh=
@renesas.com/
>  - Revise the patch description in the patch [3/4].
>=20
> Yoshihiro Shimoda (4):
>   net: renesas: rswitch: Rename rings in struct rswitch_gwca_queue
>   net: renesas: rswitch: Move linkfix variables to rswitch_gwca
>   net: renesas: rswitch: Remove gptp flag from rswitch_gwca_queue
>   net: renesas: rswitch: Improve TX timestamp accuracy
>=20
>  drivers/net/ethernet/renesas/rswitch.c | 295 ++++++++++++++++++-------
>  drivers/net/ethernet/renesas/rswitch.h |  46 +++-
>  2 files changed, 248 insertions(+), 93 deletions(-)
>=20

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

