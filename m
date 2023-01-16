Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA9366CEAB
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjAPSWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbjAPSVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:21:24 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABCB2A9B6;
        Mon, 16 Jan 2023 10:07:33 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GI4wtd2106436
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:05:00 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GI4r1d2112691
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 19:04:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673892293; bh=q+LXchndemc/sNMv5my3g+K8PlBnxGthZAA6IpMmwiA=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=e8Yw0oL3Bdoj07I5EPWN0RnNtgxfnjEyN2O53RjXdrZNNdOxh5mNCTdBDn0A8E5gZ
         PyV6VlR1K79TOYCPI8YhG5oMczjyl7RuKTNq/2lPLA23919AGkvTpawLXYq8/94EF4
         SMeRtHjKYK/IS53VwZK7TbhHSJDp3Dx551AaA2N8=
Received: (nullmailer pid 386555 invoked by uid 1000);
        Mon, 16 Jan 2023 18:04:53 -0000
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
References: <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
        <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
        <87o7qy39v5.fsf@miraculix.mork.no>
        <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
        <87h6wq35dn.fsf@miraculix.mork.no>
        <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
        <87bkmy33ph.fsf@miraculix.mork.no>
        <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
        <875yd630cu.fsf@miraculix.mork.no> <871qnu2ztz.fsf@miraculix.mork.no>
        <Y8WNxAQ6C6NyUUn1@shell.armlinux.org.uk>
        <87pmbe1hu0.fsf@miraculix.mork.no>
Date:   Mon, 16 Jan 2023 19:04:53 +0100
In-Reply-To: <87pmbe1hu0.fsf@miraculix.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of
        "Mon, 16 Jan 2023 18:59:19 +0100")
Message-ID: <87lem21hkq.fsf@miraculix.mork.no>
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

Bj=C3=B8rn Mork <bjorn@mork.no> writes:

> [   52.473325] offset:20 0x10000

Should have warned about my inability to write the simplest code without
adding more bugs than characters.  20 !=3D 0x20

I hope this makes more sense:


[   44.139420] mtk_soc_eth 15100000.ethernet wan: Link is Down
[   47.259922] mtk_sgmii_select_pcs: id=3D1
[   47.263683] mtk_pcs_config: interface=3D4
[   47.267503] offset:0 0x140
[   47.267505] offset:4 0x4d544950
[   47.270210] offset:8 0x20
[   47.273335] offset:0x20 0x31120018
[   47.275939] forcing AN
[   47.281676] mtk_pcs_config: rgc3=3D0x0, advertise=3D0x1 (changed), link_=
timer=3D1600000,  sgm_mode=3D0x103, bmcr=3D0x1200, use_an=3D1
[   47.292610] mtk_pcs_link_up: interface=3D4
[   47.296516] offset:0 0x81140
[   47.296518] offset:4 0x4d544950
[   47.299387] offset:8 0x1
[   47.302512] offset:0x20 0x3112011b
[   47.305043] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full -=
 flow control rx/tx
[   56.619420] mtk_soc_eth 15100000.ethernet wan: Link is Down
[   60.779865] mtk_sgmii_select_pcs: id=3D1
[   60.783623] mtk_pcs_config: interface=3D22
[   60.787531] offset:0 0x81140
[   60.787533] offset:4 0x4d544950
[   60.790409] offset:8 0x1
[   60.793535] offset:0x20 0x3112011b
[   60.796057] mtk_pcs_config: rgc3=3D0x4, advertise=3D0x20 (changed), link=
_timer=3D10000000,  sgm_mode=3D0x0, bmcr=3D0x0, use_an=3D0
[   60.810117] mtk_pcs_link_up: interface=3D22
[   60.814110] offset:0 0x40140
[   60.814112] offset:4 0x4d544950
[   60.816976] offset:8 0x20
[   60.820105] offset:0x20 0x31120018
[   60.822723] mtk_soc_eth 15100000.ethernet wan: Link is Up - 2.5Gbps/Full=
 - flow control rx/tx


Bj=C3=B8rn
