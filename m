Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97C16A5890
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 12:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjB1LvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 06:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjB1LvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 06:51:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD40211D8
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677585022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FfScrIsI5x6rEVkEdrSdiYdcOjklUHQX5rbDlaigbQQ=;
        b=D+WkNF45nvuPRrtgjJQVIt2+v/Ctj9mpYkzLkEnG1T0kA5dXv5+nSVxsu9O3fV2uA39pln
        /Rjfc1fOq0+9xR/kl+kqb1u3Q8+MwOuqis9MuckabO3BFd8PIGo5gbY47paw3cUQhKc7YN
        mk854bRZrJqNWvlOAyGMVtXpVxnoLlA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-244-cpWoW3F2MGSoIoWuBE3gMA-1; Tue, 28 Feb 2023 06:50:21 -0500
X-MC-Unique: cpWoW3F2MGSoIoWuBE3gMA-1
Received: by mail-wr1-f71.google.com with SMTP id m15-20020adfa3cf000000b002be0eb97f4fso1483468wrb.8
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FfScrIsI5x6rEVkEdrSdiYdcOjklUHQX5rbDlaigbQQ=;
        b=yf9RwNsdsEKwVvY2VfbEuz87qUId2Jyiss873PtYE3MiSrH76vraRNXNC7QplS5Ug2
         /TBIoFFVOjN7eI74xccW8VJYrE1eRH/PM4uNshmKTavNBcA4zr8I2Pai6B6TAqzKdtY4
         3wHFm3sDBMa+2dhi4p/8gMoWcSBjZ2aPMGjy1lpDTtV2YD/vJOzEQiK3cqn708JB5AuW
         uURkulGPssNsReNjbfT/ogOnJ4xee0802BwXYSWptrkLEowP2vUX8BXo0A8R5FSmtw80
         6mWH+ranp5dVpgIJPkLrv2yUf4qut62fKl5ZnnvrV9wGh7A241RW9LgcRqWkYc7WObnN
         DYJg==
X-Gm-Message-State: AO0yUKV5M66xJbqi3qOQVCoT0fd8eN2fl0ThwODw/ZOUJlLLW3xcVcAy
        lDxooGJSqv0mp9MX9rwlzMjISzAEUFrOUKqdD3TrUKLd5sJKe323XVGbeFA8HRF18T/8GF/EZlR
        BuEUPRvkpcEyD0SDK7u2mcA==
X-Received: by 2002:a5d:5962:0:b0:2c9:8b81:bd04 with SMTP id e34-20020a5d5962000000b002c98b81bd04mr1598334wri.0.1677585019329;
        Tue, 28 Feb 2023 03:50:19 -0800 (PST)
X-Google-Smtp-Source: AK7set/WCwUQ3kuQSoUUChN/7DoXag2/WHh+Ag1Cof24ZSeYbEAZPY3yHLOgPqbpAD21sl85tNb6aA==
X-Received: by 2002:a5d:5962:0:b0:2c9:8b81:bd04 with SMTP id e34-20020a5d5962000000b002c98b81bd04mr1598321wri.0.1677585019011;
        Tue, 28 Feb 2023 03:50:19 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id z10-20020a5d44ca000000b002c6e8af1037sm9651101wrr.104.2023.02.28.03.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 03:50:18 -0800 (PST)
Message-ID: <192d72313269845fe19d6d8baecbecfb9d184f77.camel@redhat.com>
Subject: Re: [PATCH v2] net: lan743x: LAN743X selects FIXED_PHY to resolve a
 link error
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tom Rix <trix@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, steen.hegelund@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 28 Feb 2023 12:50:17 +0100
In-Reply-To: <20230227130535.2828181-1-trix@redhat.com>
References: <20230227130535.2828181-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2023-02-27 at 08:05 -0500, Tom Rix wrote:
> A rand config causes this link error
> drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netde=
v_open':
> drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference t=
o `fixed_phy_register'
>=20
> lan743x_netdev_open is controlled by LAN743X
> fixed_phy_register is controlled by FIXED_PHY
>=20
> and the error happens when
> CONFIG_LAN743X=3Dy
> CONFIG_FIXED_PHY=3Dm
>=20
> So LAN743X should also select FIXED_PHY
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>

You are targeting the -net tree, but this lacks a 'Fixes' tag, please
post a new version with such info.

If instead the intended target was net-next (as I think it was agreed
on previous revision) please repost after that net-next re-opens (in
~1w from now).

Thanks,

Paolo

