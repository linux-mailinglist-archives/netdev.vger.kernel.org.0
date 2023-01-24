Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C3E6797A4
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbjAXMUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjAXMUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:20:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0565F442ED
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674562761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ja6XBTgJF8fduvhlLZsubiJtPEa4YLR6BF91vfJnpaY=;
        b=LZYAcnYbSbt9RHYkPAxk3OFdj0jgKALRLvjLbkfriidLMTjGejoutExVTxFr6FO9wvAiNZ
        vyH6SOBZ3H5jjPOdRHSqykZ/hGabOTwkoVKNhtwwoLasAyFbHpK/UGN67g9GeJKxX7iJMe
        0Cor4f6caSZS5G4EQ0QI/cbyUGrCwN8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-261-0-z5MW6DOACbPj27LHPdyA-1; Tue, 24 Jan 2023 07:19:19 -0500
X-MC-Unique: 0-z5MW6DOACbPj27LHPdyA-1
Received: by mail-qk1-f198.google.com with SMTP id de37-20020a05620a372500b00707391077b4so10900991qkb.17
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:19:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ja6XBTgJF8fduvhlLZsubiJtPEa4YLR6BF91vfJnpaY=;
        b=X1fnHTJVAN0AdIU1J5XCtMCIjBNeeI2QEAFxwW5S4sCNXA0U1sAJhcOmWTvhZbpgFY
         D7zCuqYGmHc1GBs76imddFPS9inR5wxBM5wO3Y1FcI2/M5cSKqmY3QutVo1Tq/E60ysD
         0mERVnEW57dzyFNddhc4EOTuwPFN/vrPUMoK5uOiHr3txep01QOPPTgZkGenNw3RP3b9
         fyjRJD0/feitBlLds6peEYvJz2DjC62lcC3qfFX4tL/5GtEsf5O3yFuOhgZm5CQ02Y5J
         OBiQT8Hwx4jGVSH5dXwYelTSffJ+hYZnc6xAFt8O9B7m++2qQNtEKEANsqbIv4J9X/ya
         ch2Q==
X-Gm-Message-State: AFqh2kprn42qkA0R8GWWhINlw4mOPuRNBZgVj4wyMs4hxGHrZS07R8mQ
        xhbDE5sLc4tE0UIpv+nI2NlhvjBFPV64aagJErmH3YYe+7r3deBZwi1ALL5jQ6+LTRI0ifRh+ec
        ZWCgWfsvsOXGmmibj
X-Received: by 2002:ac8:4f47:0:b0:3b0:3b56:58c9 with SMTP id i7-20020ac84f47000000b003b03b5658c9mr38235990qtw.30.1674562759291;
        Tue, 24 Jan 2023 04:19:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXudwl/Qr5oLlQW+bX+bvqI6LKPzmIlrS3B7lYN3Pfc75a1xQK62iCexdVOIHaNTd4RhJ+uaZw==
X-Received: by 2002:ac8:4f47:0:b0:3b0:3b56:58c9 with SMTP id i7-20020ac84f47000000b003b03b5658c9mr38235972qtw.30.1674562759031;
        Tue, 24 Jan 2023 04:19:19 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id x6-20020ac87306000000b003b34650039bsm1115498qto.76.2023.01.24.04.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 04:19:18 -0800 (PST)
Message-ID: <a9e7d8f528828c0c7cd0966a4f3023027425011b.camel@redhat.com>
Subject: Re: [PATCH v3 net 1/3] net: mediatek: sgmii: ensure the SGMII PHY
 is powered down on configuration
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        Russell King <rmk+kernel@armlinux.org.uk>
Date:   Tue, 24 Jan 2023 13:19:15 +0100
In-Reply-To: <20230122212153.295387-2-bjorn@mork.no>
References: <20230122212153.295387-1-bjorn@mork.no>
         <20230122212153.295387-2-bjorn@mork.no>
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

On Sun, 2023-01-22 at 22:21 +0100, Bj=C3=B8rn Mork wrote:
> From: Alexander Couzens <lynxis@fe80.eu>
>=20
> The code expect the PHY to be in power down which is only true after rese=
t.
> Allow changes of the SGMII parameters more than once.
>=20
> Only power down when reconfiguring to avoid bouncing the link when there'=
s
> no reason to - based on code from Russell King.
>=20
> There are cases when the SGMII_PHYA_PWD register contains 0x9 which
> prevents SGMII from working. The SGMII still shows link but no traffic
> can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
> taken from a good working state of the SGMII interface.

This looks like a legitimate fix for -net, but we need a suitable Fixes
tag pointing to the culprit commit.

Please repost including such tag. While at that you could also consider
including Simon's suggestion.

The following 2 patches looks like new features/refactor that would be
more suitable for net-next, and included here due to the code
dependency.

If so, please repost the later 2 separately for net-next after the fix
will land there.

Thanks,

Paolo

