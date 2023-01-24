Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4951B679E23
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 17:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjAXQC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 11:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjAXQC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 11:02:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E25A185
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 08:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674576101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CNEyduoYFYdPU7xRDfr0uXDGqlCIdsjuEdlayV8AUp4=;
        b=TQ4wXOTxGyN5PUz6fud5z+skI6xWjJwoGnz037JV98alI2+9qpol4NlsnH8p6uoNrEFlAd
        YRZvMFQb5p70SOcVOHrCqKKrRNi59XiQGPdEcX/KhSknT85nPEAkvz+HwJcUWDGmj837Vm
        tVcX58E78qvwAphg2wkBknVcg3z5XBo=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-428-McMEX46CNCWhLMH9AKrZWw-1; Tue, 24 Jan 2023 11:01:39 -0500
X-MC-Unique: McMEX46CNCWhLMH9AKrZWw-1
Received: by mail-oi1-f198.google.com with SMTP id u9-20020a056808150900b0036f087d05fdso352892oiw.0
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 08:01:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CNEyduoYFYdPU7xRDfr0uXDGqlCIdsjuEdlayV8AUp4=;
        b=zAYOife6lNgIIV28SZNHGikLfp/Aupih/063MbovPUaj+ilAdVjzbvcUDoflqM1JP/
         CQXj3eAhOtWuXi1LZSRI0D52DmITYDRIy9xSSBi5m4fxap2wYKcfVan4qdcO05rR/SMZ
         VX6I+wUJ7iI3DDz9Jp8ae1bHo7YAnR2SQRHaJg7mkr0gY5iJlpljSh4Oo9anwpfn9vMG
         tAFkSyClIXXQ1Pj8Csa5mvch3kzfUBcInyf6WRG0MG6V9cq0DtAuWvkOjnnv4KfgrYO7
         Cl7EXtnOZnVKXpAjP1y+DVLSPmFoETLIcSifngyYQ80JX4M6/2PZFkaXPz5wf468KG9C
         RcBA==
X-Gm-Message-State: AFqh2kqhDfM0/gOut7gLmQ8N+uUY0eCbQDqMADxRYiE1d4+rNXEaOCy0
        dq66mxoWN/QnGSqxSoWhEvYaCa5c4Qla2A7HWo8Y2FJGU+pQdIOyIhf2Y096l5J59DXyxb52a9D
        v3GCmPezbLEopRh2o
X-Received: by 2002:a05:6871:4684:b0:15f:2908:12bb with SMTP id ni4-20020a056871468400b0015f290812bbmr13767810oab.28.1674576098343;
        Tue, 24 Jan 2023 08:01:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXumBNXHaNd6tId6qhINCiV8PtezvE1Gbk2h53nR+sETsJ0rofUkC4rSEaIbwiSd8O1HDeP85Q==
X-Received: by 2002:a05:6871:4684:b0:15f:2908:12bb with SMTP id ni4-20020a056871468400b0015f290812bbmr13767793oab.28.1674576097998;
        Tue, 24 Jan 2023 08:01:37 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id h15-20020a05620a21cf00b006fbb4b98a25sm1612098qka.109.2023.01.24.08.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 08:01:37 -0800 (PST)
Message-ID: <705636def3df5f958e702733bdf50ee7dfed8d8d.camel@redhat.com>
Subject: Re: [PATCH v3 net 1/3] net: mediatek: sgmii: ensure the SGMII PHY
 is powered down on configuration
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Date:   Tue, 24 Jan 2023 17:01:33 +0100
In-Reply-To: <Y8/S4eAK338MG53B@shell.armlinux.org.uk>
References: <20230122212153.295387-1-bjorn@mork.no>
         <20230122212153.295387-2-bjorn@mork.no>
         <a9e7d8f528828c0c7cd0966a4f3023027425011b.camel@redhat.com>
         <Y8/S4eAK338MG53B@shell.armlinux.org.uk>
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

On Tue, 2023-01-24 at 12:45 +0000, Russell King (Oracle) wrote:
> On Tue, Jan 24, 2023 at 01:19:15PM +0100, Paolo Abeni wrote:
> > On Sun, 2023-01-22 at 22:21 +0100, Bj=C3=B8rn Mork wrote:
> > > From: Alexander Couzens <lynxis@fe80.eu>
> > >=20
> > > The code expect the PHY to be in power down which is only true after =
reset.
> > > Allow changes of the SGMII parameters more than once.
> > >=20
> > > Only power down when reconfiguring to avoid bouncing the link when th=
ere's
> > > no reason to - based on code from Russell King.
> > >=20
> > > There are cases when the SGMII_PHYA_PWD register contains 0x9 which
> > > prevents SGMII from working. The SGMII still shows link but no traffi=
c
> > > can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
> > > taken from a good working state of the SGMII interface.
> >=20
> > This looks like a legitimate fix for -net, but we need a suitable Fixes
> > tag pointing to the culprit commit.
> >=20
> > Please repost including such tag. While at that you could also consider
> > including Simon's suggestion.
> >=20
> > The following 2 patches looks like new features/refactor that would be
> > more suitable for net-next, and included here due to the code
> > dependency.
>=20
> I'm not sure why you think that, especially for patch 2.

Because I misread the patch contents as a simple macro rename (I missed
the s/=3D=3D/!=3D/ part).
>=20
> Patch 2 corrects the sense of the duplex bit - the code originally
> set this for full duplex, but in actual fact, the bit needs to be set
> for half duplex. I can't see how one could regard that as a feature
> or a refactor.
>=20
> I'm also not sure how you could regard patch 3 as a refactor. It
> could be argued that it is a new feature, but it is actually a bug
> fix for the patch converting the driver to phylink_pcs which
> omitted setting this, making the pcs_get_state() method rather
> useless.

Well, it looked more a new feature than a fix to me. The above
explanation cleared the matter. A more descriptive commit could have
avoid confusion on my side :)

> So I regard all three patches as fixes, not features or refactoring.

No objections on my side, but please add suitable fixes tag on every
patch then.

Thanks!

Paolo

