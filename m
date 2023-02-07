Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2D768D5EC
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 12:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjBGLrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 06:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjBGLri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 06:47:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8014F7EF2
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 03:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675770413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tY2wed5f/V57Hx/LRC1TG2QiSN3PNPA5huQOMGtUxpw=;
        b=EE8sH5SWN0rOVFU8sVhNlW6wM1MtYgyFwvwKk9QDA2rVAN6IjWaEKXGXlleywafZDjIzu/
        BRTsRp+aPC17W3/49DbMONLgfKlGxuQiteTN0zPaqdaxMGkR/FG7WOYplBZaBM8MQ20cEy
        eKa9KXiyis/QjQVX+8Fv96Zs1yx0kew=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-480-Uj2hvEp2M1i8o7UyGanyIg-1; Tue, 07 Feb 2023 06:46:52 -0500
X-MC-Unique: Uj2hvEp2M1i8o7UyGanyIg-1
Received: by mail-qt1-f200.google.com with SMTP id a24-20020ac84d98000000b003b9a4958f0cso8317178qtw.3
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 03:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tY2wed5f/V57Hx/LRC1TG2QiSN3PNPA5huQOMGtUxpw=;
        b=Zkk0czBWVtcgOR8CQjWTwWS/VG9imk051cly6Y1VtMNNu5TVv/QeF4i4ZpCVzPFthU
         8VldkwYuwwdJmnlRPcsgFsBYkKJGxgawOt2EMiZ6WVn+4jg/ZFNVl8t48dN4OpIU/0jd
         HY26VFu4YksZY63atWiRQ9OA+fR4VD5A0ekhXAUmuprApm/ygFKRK8T3EbaQNmYmMKuH
         n8Xd5XvFZqJq6tapDZsLThzZlarU6z0E3H8dPFarSvHEL4yXaazzEBCg4DBOy28KUoZN
         4iOQ0eNzWClPKGnit2AXFPVpxx5beepBCLFszi6ZauTsZCuFuUvi6AqhSpeLxYHpfymS
         WItw==
X-Gm-Message-State: AO0yUKXLvNUmNGUhB+cxtS+x3ab2GhuMPHVBVs4aKQYbsh3CC8U2uydQ
        fhZ8hXVZ5WCPVsLhxij5SfzKlNDlOPlr+rSxLoizZzbBiJt3jbrP5E9iA5mtHhiX8oI62wi0Zem
        ca6SkFJ/sPZfv3F/MFzJz1Q==
X-Received: by 2002:a05:622a:1109:b0:3b8:6bef:61df with SMTP id e9-20020a05622a110900b003b86bef61dfmr5474607qty.6.1675770411752;
        Tue, 07 Feb 2023 03:46:51 -0800 (PST)
X-Google-Smtp-Source: AK7set80+2jLVgbmkvTXmqfs03eB+I4BaJaqsMomvLKpF7Ztcs0DLiZu4JmuR1oSUnmsvgZctOgU8Q==
X-Received: by 2002:a05:622a:1109:b0:3b8:6bef:61df with SMTP id e9-20020a05622a110900b003b86bef61dfmr5474581qty.6.1675770411513;
        Tue, 07 Feb 2023 03:46:51 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id l12-20020a05620a210c00b00725fd2aabd3sm9232877qkl.1.2023.02.07.03.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 03:46:50 -0800 (PST)
Message-ID: <bc632bea2357e7cd01a6f130a9413fc7e2933af4.camel@redhat.com>
Subject: Re: [PATCH repost] net: fec: Refactor: rename `adapter` to `fep`
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?ISO-8859-1?Q?Cs=F3k=E1s?= Bence <Csokas.Bence@prolan.hu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Date:   Tue, 07 Feb 2023 12:46:48 +0100
In-Reply-To: <b0d5ef8d98324e3898a261c3c06ac039@prolan.hu>
References: <20221222094951.11234-1-csokas.bence@prolan.hu>
         <b0d5ef8d98324e3898a261c3c06ac039@prolan.hu>
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

On Mon, 2023-02-06 at 00:03 +0000, Cs=C3=B3k=C3=A1s Bence wrote:
> Commit 01b825f reverted a style fix, which renamed
> `struct fec_enet_private *adapter` to `fep` to match
> the rest of the driver. This commit factors out
> that style fix.
>=20
> Signed-off-by: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>

The patch does not apply cleanly to net-next (nor net, FWIS).

When referencing an existing commit you should use the:

<12 char hash> ("<commit tile>")

format.

More importantly, this kind of refactors are useful if you are going to
touch the relevant code with fixes or new feature in the same series,
otherwise they mainly produces later backport conflicts.

I'm not going to accept this kind of change, sorry.

Paolo

