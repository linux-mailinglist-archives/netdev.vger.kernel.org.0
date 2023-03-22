Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672B16C4EBE
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjCVO7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjCVO7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:59:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CD759F4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679497125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NTDHGidtxxNwvUoWqQhKBSxK12xTyzlrRv/7eEx1M9k=;
        b=JFpYdbVYYAxL6vXQcQwunLozIKNmrxs9cclhOEfzNZ6lobRBZbZYcXaNjN3b2unV5j9o3+
        K9vB9nLEM+F3giSVDZB3XTcdkc6S0NFUOw0/aBo2FDnoehf6QrpNa3r7Mfr0MsIyQBXh4L
        g1LyZCATTbkr4MT65aITrpLEY/q9ncg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-LjK3vEK6NVCYuDC6fzPSEA-1; Wed, 22 Mar 2023 10:58:44 -0400
X-MC-Unique: LjK3vEK6NVCYuDC6fzPSEA-1
Received: by mail-qv1-f70.google.com with SMTP id px9-20020a056214050900b005d510cdfc41so2156899qvb.7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679497124; x=1682089124;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NTDHGidtxxNwvUoWqQhKBSxK12xTyzlrRv/7eEx1M9k=;
        b=6S5gPhBvmhyhoM7s5/cxPgs+1PTHb2cM9sMNomTh1E5Otcy2e7j6EApT4egYxEuJYq
         RI6HEAXWaGhDFJgc40OPMo4iu0oY3j4dq/sMsyvrQUv5vVvIaOlhl9R834wFnZxpRGZd
         6nLGtRmonq37O8Bx/r9QwwNnM7arHhwr+XOPgtl3NHGcMng9CCp1McFjv/pUB08criUA
         iyeDtdKnD5wMzh2oPMx2gLa/PweDgxT+3lDzzBxWeyuJNd6DdQ93xn/WPmsWIUUDRs4F
         ebEUgiZf8MlmhZw+TWp5lkMNsKLWmOC4+GaGKoMHU/CeK7vA3JdqFFK4aeGEfsT8ns3F
         dKew==
X-Gm-Message-State: AO0yUKU9qfil2s0H93TBGxlfYPi0f4R+PghqSfwBMivKqT2oA69e4XYn
        DtpqhUqSg34KHg+csbCU0Tq4l8o5ZyMeyMXw/FrhnbVUcWNu2k2asYFmTtC1sJ5OyrZIOrOBD1y
        uudeToGIu69MBTPBC
X-Received: by 2002:a05:6214:528d:b0:5ad:cd4b:3765 with SMTP id kj13-20020a056214528d00b005adcd4b3765mr9966455qvb.1.1679497124425;
        Wed, 22 Mar 2023 07:58:44 -0700 (PDT)
X-Google-Smtp-Source: AK7set8v93I76Hrh6VYaSGaLjbIuUhXMY4ShyL1lpTiTt6XnQgpguzMVChPp0c+PhTr3DB86BOb1hw==
X-Received: by 2002:a05:6214:528d:b0:5ad:cd4b:3765 with SMTP id kj13-20020a056214528d00b005adcd4b3765mr9966419qvb.1.1679497124160;
        Wed, 22 Mar 2023 07:58:44 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-168.dyn.eolo.it. [146.241.244.168])
        by smtp.gmail.com with ESMTPSA id y3-20020a37f603000000b0074382b756c2sm11405364qkj.14.2023.03.22.07.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 07:58:43 -0700 (PDT)
Message-ID: <65d770947b98805a52573b3fa2df11f5d1778af7.camel@redhat.com>
Subject: Re: [PATCH net-next] smsc911x: remove superfluous variable init
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Wed, 22 Mar 2023 15:58:40 +0100
In-Reply-To: <ZBnBZwC9WEoNK0Gp@ninjato>
References: <20230321114721.20531-1-wsa+renesas@sang-engineering.com>
         <CAMuHMdXrvdUPTs=ExXJo-WM+=A=WgyCQM_0mGKZxQOrVFePbwA@mail.gmail.com>
         <ZBnBZwC9WEoNK0Gp@ninjato>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-21 at 15:38 +0100, Wolfram Sang wrote:
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct smsc911x_data =
*pdata =3D netdev_priv(dev);
> > > -       struct phy_device *phydev =3D NULL;
> > > +       struct phy_device *phydev;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret;
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0phydev =3D phy_find_f=
irst(pdata->mii_bus);
> >=20
> > Nit: perhaps combine this assignment with the variable declaration?
>=20
> I thought about it but found this version to be easier readable.

This patch does not apply cleanly to net-next, please rebase and
resping.

Thanks!

Paolo

