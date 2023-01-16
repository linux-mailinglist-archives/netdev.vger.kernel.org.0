Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DE766C3DA
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjAPP34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjAPP3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:29:09 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5D32686A;
        Mon, 16 Jan 2023 07:24:16 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GFLaf62098571
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 15:21:37 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GFLUi12005449
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 16:21:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673882491; bh=YW340CRyYikMeWbLA1NSf7DqfUetbMMdynXgtHHdE48=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=QFnDAMX2JhFemSQY1nYiU1QWqvPvrdhpdtxFFvS9BhbBaNkMkhfHyu+adWDwk5FWB
         wESQkHOLc5fvYq048POks3giDPMA9iDjhke8m2pImwPDPn11yIkZ8+dLfhMIxzXubk
         d2Ob3c7U3Ii79c8FT3gFNEIH95nEv/Y4uamrjRX0=
Received: (nullmailer pid 376851 invoked by uid 1000);
        Mon, 16 Jan 2023 15:21:30 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Organization: m
References: <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
        <trinity-169e3c3f-3a64-485c-9a43-b7cc595531a9-1666552897046@3c-app-gmx-bs01>
        <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
        <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
        <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
        <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
        <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
        <87o7qy39v5.fsf@miraculix.mork.no>
        <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
        <87h6wq35dn.fsf@miraculix.mork.no>
        <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
Date:   Mon, 16 Jan 2023 16:21:30 +0100
In-Reply-To: <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk> (Russell King's message
        of "Mon, 16 Jan 2023 14:59:22 +0000")
Message-ID: <87bkmy33ph.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Russell King (Oracle)" <linux@armlinux.org.uk> writes:

> To prove the point, in mtk_pcs_config():
>
>         if (interface =3D=3D PHY_INTERFACE_MODE_SGMII) {
>                 sgm_mode =3D SGMII_IF_MODE_SGMII;
>                 if (phylink_autoneg_inband(mode)) {
>
> Force the second if() to always be true, and see whether that allows
> traffic to pass.

Changed it with a printk to make sure I didn't mess up:

		if (1 || phylink_autoneg_inband(mode)) {
			pr_info("forcing AN\n");

But unfortunately without success.  Still same failure.  Output when
changing peer speed:

[   54.539438] mtk_soc_eth 15100000.ethernet wan: Link is Down
[   56.619937] mtk_sgmii_select_pcs: id=3D1
[   56.623690] mtk_pcs_config: interface=3D4
[   56.627511] offset:0 0x140
[   56.627513] offset:4 0x4d544950
[   56.630215] offset:8 0x20
[   56.633340] forcing AN
[   56.638292] mtk_pcs_config: rgc3=3D0x0, advertise=3D0x1 (changed), link_=
timer=3D1600000,  sgm_mode=3D0x103, bmcr=3D0x1000, use_an=3D1
[   56.649226] mtk_pcs_link_up: interface=3D4
[   56.653135] offset:0 0x81140
[   56.653137] offset:4 0x4d544950
[   56.656001] offset:8 0x1
[   56.659137] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full -=
 flow control rx/tx

and the phy still reports this:

root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
0x000e



Bj=C3=B8rn
