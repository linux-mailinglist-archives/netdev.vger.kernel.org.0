Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9195C69DC7C
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbjBUJB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbjBUJBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:01:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E37233F0
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676970064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=alEius1H4Y8w76WB7xmYU0Ggwjx3hA9AGAhRmkeiUTc=;
        b=csUvhH4a9G3PYQsYBVmgeTVbgrj8P1i7/wPo60hVH7vwjMk7kG8za+5HeSFp8j5wwYyVEL
        Wl/uc3PaANn1X/oT/ysHPPz//EL7Q/tZ7fY/3+YON2+k8zlJQBDmr37HbzrviOOYYd1KJO
        EKAVajXeFY+3jJzrRHUu2g9v2uqDLC4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-263-Jvx1s4rrOpOAmWKaIkP7gw-1; Tue, 21 Feb 2023 04:01:03 -0500
X-MC-Unique: Jvx1s4rrOpOAmWKaIkP7gw-1
Received: by mail-qv1-f70.google.com with SMTP id pv11-20020ad4548b000000b0056e96f4fd64so1589371qvb.15
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:01:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676970063;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=alEius1H4Y8w76WB7xmYU0Ggwjx3hA9AGAhRmkeiUTc=;
        b=bRxh5UMl8yLtlFfhvrHhayp76buaelAT52uvRIU5L/FeGWMxfUxwnqr5WnIEjTudTg
         kNynqRny4JQ0uVsPH78UX525v4QvnKJeGWOph/I9efThk1DLTdtpKQOsbFlUsxu66mC/
         EzJDfyixxBpiEDS3RAa1CUk0Af1TlAx0rcIG/tvlqw1iSmtIy5NGXXdek/z525Aqa4WQ
         vaTzhW8HC1El9uHYw2pHcTlpchsY0+L4xU/GsuO0mZ67arveBjMrZxQe1zvDWX3ZTgNs
         QMu32lGsL12DfzxuqZCQucE10o+O1D5J+5GiyVwtJHd7mO6ALbtiExCWRqqHL4W+XPjW
         OpkA==
X-Gm-Message-State: AO0yUKV77cmNCTCNJWgJ6MR6emIwj6jz5GGzLB8bSnRvDsN2h1CAnXqZ
        dr2unWKwwv1XlbwVCav+80ASU5qRujj/DevMWzVcveUfmJPEtcb9s3acj98hwcUMVV3eMoYsiUQ
        qt/70ljBFH07wsT3K
X-Received: by 2002:a0c:f2ce:0:b0:56e:b6f0:e102 with SMTP id c14-20020a0cf2ce000000b0056eb6f0e102mr5321078qvm.0.1676970062645;
        Tue, 21 Feb 2023 01:01:02 -0800 (PST)
X-Google-Smtp-Source: AK7set9bNxSgvAs/GHzQpOohJLTvtYH+L3tWy9vURFBZyZVmzfwSmBF/kXeV3JS4/e2m+VqWWWGB3w==
X-Received: by 2002:a0c:f2ce:0:b0:56e:b6f0:e102 with SMTP id c14-20020a0cf2ce000000b0056eb6f0e102mr5321046qvm.0.1676970062276;
        Tue, 21 Feb 2023 01:01:02 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id z131-20020a376589000000b007186c9e167esm2077680qkb.52.2023.02.21.01.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 01:01:01 -0800 (PST)
Message-ID: <e9269e140d0027534e91368475155d83ccbe66fb.camel@redhat.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: mediatek,mt7530: change some
 descriptions to literal
From:   Paolo Abeni <pabeni@redhat.com>
To:     arinc9.unal@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
Date:   Tue, 21 Feb 2023 10:00:56 +0100
In-Reply-To: <20230218072348.13089-1-arinc.unal@arinc9.com>
References: <20230218072348.13089-1-arinc.unal@arinc9.com>
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

On Sat, 2023-02-18 at 10:23 +0300, arinc9.unal@gmail.com wrote:
> From: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
>=20
> The line endings must be preserved on gpio-controller, io-supply, and
> reset-gpios properties to look proper when the YAML file is parsed.
>=20
> Currently it's interpreted as a single line when parsed. Change the style
> of the description of these properties to literal style to preserve the
> line endings.
>=20
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.

