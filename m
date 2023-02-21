Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D17D69E037
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbjBUMWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbjBUMWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:22:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0694A59C6
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676982028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gziN/XKTmlqDV7Elwm8JhOAFtvAWBXGN7UBs14HUdfA=;
        b=TErrh+8YbphDi/pW99nC3RpMF1hNNmpwJsmpia6rI0+3pCw4JLmcd7D+yIZ1Fl5G1m3nBo
        I87h3t/EqtN+Qoz4c+qIXlz9Xn+AHBL4NSpP8wQrjuWeMNw08RBvWbUGm7FCNSJtaqpaXq
        Igrtdn39G960xglhWDh46d9flwwy1UU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-319-mu6qLGSbN2inQRGY4X02mQ-1; Tue, 21 Feb 2023 07:20:24 -0500
X-MC-Unique: mu6qLGSbN2inQRGY4X02mQ-1
Received: by mail-wm1-f70.google.com with SMTP id e17-20020a05600c219100b003e21fa60ec1so2176740wme.2
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:20:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gziN/XKTmlqDV7Elwm8JhOAFtvAWBXGN7UBs14HUdfA=;
        b=7PmwUxBrOA6+mQuDrJ2ZvVjP4eu0cU0fqLjMK+LcEl69P5Bj30K+I+p7vt7jdRlQWg
         IWG/nelaWCKdBHRGVbJrxKgmiSYlBZUPmBDJXcLZoK76/W3bALIPLlsLtWfqKFrVCAn2
         9rf6RzAvtfkoT9iT5pHhruIop9TRTNBu+Cm6Te4vcrbGP1uyo9Ak/jSYfY+tvhAi+Piv
         x2MeCZJAtyeRZXRFTu2qiarI/mXdsKQCyHGO5UK4qmZdp800FGAMKM6cWh8Hpv1c2Nly
         Rjuse5ITg8xmMwQ1eqBcPvpx7+5beKZxdTUu3+LtYjyWj0kCvC481sYoVqyrf6UhoZwF
         SuCQ==
X-Gm-Message-State: AO0yUKW10s5GU1ZfZPo5j6Uh/zzUMtIX766KWfaS3ZhQ3qvj9AEvU0BO
        zsFgODyKpoUkGtuZ3E0cX1w7inJIfjVS6wXcjWDng5mmbFj4QWjUCcy1WBWvp+KR5fSIcJEmnE9
        Y0PrWOcA4Nm/mxV6N
X-Received: by 2002:a05:600c:1c9c:b0:3dc:5ae4:c13d with SMTP id k28-20020a05600c1c9c00b003dc5ae4c13dmr4846838wms.4.1676982023775;
        Tue, 21 Feb 2023 04:20:23 -0800 (PST)
X-Google-Smtp-Source: AK7set8lbV2WFcK+o7DtrFByZVT8litE+mTmB8ikeVTsesdZtnbGIUjq/rZ+QzGc2zwrHjOleTptLw==
X-Received: by 2002:a05:600c:1c9c:b0:3dc:5ae4:c13d with SMTP id k28-20020a05600c1c9c00b003dc5ae4c13dmr4846821wms.4.1676982023499;
        Tue, 21 Feb 2023 04:20:23 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id t23-20020a05600c2f9700b003dc521f336esm3904036wmn.14.2023.02.21.04.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 04:20:22 -0800 (PST)
Message-ID: <0d080cbd157fba352ea035611fa44354b8f875bd.camel@redhat.com>
Subject: Re: [PATCH 0/2] Add PTP support for sama7g5
From:   Paolo Abeni <pabeni@redhat.com>
To:     Durai Manickam KR <durai.manickamkr@microchip.com>,
        Hari.PrasathGE@microchip.com,
        balamanikandan.gunasundar@microchip.com,
        manikandan.m@microchip.com, varshini.rajendran@microchip.com,
        dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
        balakrishnan.s@microchip.com, claudiu.beznea@microchip.com,
        cristian.birsan@microchip.com, nicolas.ferre@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        richardcochran@gmail.com, linux@armlinux.org.uk,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Date:   Tue, 21 Feb 2023 13:20:21 +0100
In-Reply-To: <20230221092104.730504-1-durai.manickamkr@microchip.com>
References: <20230221092104.730504-1-durai.manickamkr@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
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

On Tue, 2023-02-21 at 14:51 +0530, Durai Manickam KR wrote:
> This patch series is intended to add PTP capability to the GEM and=20
> EMAC for sama7g5.
>=20
> Durai Manickam KR (2):
>   net: macb: Add PTP support to GEM for sama7g5
>   net: macb: Add PTP support to EMAC for sama7g5
>=20
>  drivers/net/ethernet/cadence/macb_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.

