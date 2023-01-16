Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8374F66C98D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbjAPQvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbjAPQup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:50:45 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE8B4672A;
        Mon, 16 Jan 2023 08:36:47 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GGY0bR2101950
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 16:34:01 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GGXr3P2014953
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:33:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673886835; bh=HZM0nzxZNHaSTR5SVfaOwIn01lgse6hh/Vse4j0duJ4=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=MeHZphBLy/WJTEl/zcwDGdTxWHnycIiwQf/3kycFebPPZDK3i+cX1gi1CCk7Xo/NY
         OKaAbn23ofnBI4VDvVEPhRwGiRilgGl0nTMOiOyoGsduq8ajftuKXdSunPMWmKqEnW
         WYZafwxdwfZUDSz5AsxP1scHgPsDkCMBFB8Qqawg=
Received: (nullmailer pid 377772 invoked by uid 1000);
        Mon, 16 Jan 2023 16:33:53 -0000
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
References: <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
        <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
        <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
        <Y1ansgmD69AcITWx@shell.armlinux.org.uk>
        <trinity-defa4f3d-804e-401e-bea1-b36246cbc11b-1666685003285@3c-app-gmx-bap29>
        <87o7qy39v5.fsf@miraculix.mork.no>
        <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
        <87h6wq35dn.fsf@miraculix.mork.no>
        <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
        <87bkmy33ph.fsf@miraculix.mork.no>
        <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
Date:   Mon, 16 Jan 2023 17:33:53 +0100
In-Reply-To: <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk> (Russell King's message
        of "Mon, 16 Jan 2023 15:32:06 +0000")
Message-ID: <875yd630cu.fsf@miraculix.mork.no>
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

> On Mon, Jan 16, 2023 at 04:21:30PM +0100, Bj=C3=B8rn Mork wrote:
>> [   54.539438] mtk_soc_eth 15100000.ethernet wan: Link is Down
>> [   56.619937] mtk_sgmii_select_pcs: id=3D1
>> [   56.623690] mtk_pcs_config: interface=3D4
>> [   56.627511] offset:0 0x140
>> [   56.627513] offset:4 0x4d544950
>> [   56.630215] offset:8 0x20
>> [   56.633340] forcing AN
>> [   56.638292] mtk_pcs_config: rgc3=3D0x0, advertise=3D0x1 (changed), li=
nk_timer=3D1600000,  sgm_mode=3D0x103, bmcr=3D0x1000, use_an=3D1
>> [   56.649226] mtk_pcs_link_up: interface=3D4
>> [   56.653135] offset:0 0x81140
>> [   56.653137] offset:4 0x4d544950
>> [   56.656001] offset:8 0x1
>> [   56.659137] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Ful=
l - flow control rx/tx
>
> Thanks - there seems to be something weird with the bmcr value printed
> above in the mtk_pcs_config line.
>
> You have bmcr=3D0x1000, but the code sets two bits - SGMII_AN_RESTART and
> SGMII_AN_ENABLE which are bits 9 and 12, so bmcr should be 0x1200, not
> 0x1000. Any ideas why?

No, not really

> Can you also hint at what the bits in the PHY register you quote mean
> please?

This could very well be a red herring.  It's the only difference I've
been able to spot, but I have no idea what it means.

This is an attempt at reformatting the pdf tables for email.  Hope it's
readable:=20


VSPEC1_SGMII_STAT                                 Reset Value
Chip Level SGMII status register (Register 30.9)  0008 H

15        14..8   7     6     5     4     3     2    1 .. 0
MACSEC_*  Res     RES   Res   ANOK  RF    ANAB  LS   DR
ro                ro          ro    rolh  ro    roll ro


Field      Bits Type Description

MACSEC_CAP 15   RO   MACSEC Capability in the product
                     0 B DISABLED Product is not MACSEC capable
                     1 B ENABLED Product is MACSEC capable
RES        7    RO   Reserved
                     Ignore when read.
ANOK       5    RO   Auto-Negotiation Completed
                     Indicates whether the auto-negotiation process is comp=
leted or not.
                     0 B RUNNING Auto-negotiation process is in progress or=
 not started
                     1 B COMPLETED Auto-negotiation process is completed
RF         4    ROLH Remote Fault
                     Indicates the detection of a remote fault event.
                     0 B INACTIVE No remote fault condition detected
                     1 B ACTIVE Remote fault condition detected
ANAB       3    RO   Auto-Negotiation Ability
                     Specifies the auto-negotiation ability.
                     0 B DISABLED PHY is not able to perform auto-negotiati=
on
                     1 B ENABLED PHY is able to perform auto-negotiation
LS         2    ROLL Link Status
                     Indicates the link status of the SGMII
                     0 B INACTIVE The link is down. No communication with l=
ink partner possible.
                     1 B ACTIVE The link is up. Data communication with lin=
k partner is possible.
DR         1:0  RO   SGMII Data Rate
                     This field indicates the operating data rate of SGMII =
when link is up
                     00 B DR_10 SGMII link rate is 10 Mbit/s
                     01 B DR_100 SGMII link rate is 100 Mbit/s
                     10 B DR_1G SGMII link rate is 1000 Mbit/s
                     11 B DR_2G5 SGMII link rate is 2500 Mbit/s



Bj=C3=B8rn
