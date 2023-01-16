Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF4966CE8A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjAPSOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjAPSOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:14:07 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC26223DA5;
        Mon, 16 Jan 2023 10:00:10 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GHxPUE2106206
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:59:26 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GHxJrP2083208
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:59:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673891960; bh=HDuvAz64SqsKbU9gYiKU5aaWYNXaEHcp2xofRwaGKA4=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=g3nhyG6Z9qnhfhTznf2bRAH/7kBCvKFOv8lPvw/AT4jnKqIzDU1AW1XPLuiTjt4jv
         vkbDjFSpCUeFSafYiM5CNsN9ZXw1gTAbFrz3EVZeFt7md8AGyfKVrBc+bykMPGdnI3
         RvLyCKn/9C59pTMdMSJv4SwPWLfA1pN8xQk/kigI=
Received: (nullmailer pid 386524 invoked by uid 1000);
        Mon, 16 Jan 2023 17:59:19 -0000
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
Date:   Mon, 16 Jan 2023 18:59:19 +0100
In-Reply-To: <Y8WNxAQ6C6NyUUn1@shell.armlinux.org.uk> (Russell King's message
        of "Mon, 16 Jan 2023 17:47:48 +0000")
Message-ID: <87pmbe1hu0.fsf@miraculix.mork.no>
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

> On Mon, Jan 16, 2023 at 05:45:12PM +0100, Bj=C3=B8rn Mork wrote:
>> Bj=C3=B8rn Mork <bjorn@mork.no> writes:
>>=20
>> >> You have bmcr=3D0x1000, but the code sets two bits - SGMII_AN_RESTART=
 and
>> >> SGMII_AN_ENABLE which are bits 9 and 12, so bmcr should be 0x1200, not
>> >> 0x1000. Any ideas why?
>> >
>> > No, not really
>>=20
>> Doh! Looked over it again, and this was my fault of course.  Had an
>>=20
>>   "bmcr =3D SGMII_AN_ENABLE;"
>>=20=20=20
>> line overwriting the original value from a previous attempt without
>> changing the if condition.. Thanks for spotting that.
>>=20
>> But this still doesn't work any better:
>>=20
>> [   43.019395] mtk_soc_eth 15100000.ethernet wan: Link is Down
>> [   45.099898] mtk_sgmii_select_pcs: id=3D1
>> [   45.103653] mtk_pcs_config: interface=3D4
>> [   45.107473] offset:0 0x140
>> [   45.107476] offset:4 0x4d544950
>> [   45.110181] offset:8 0x20
>> [   45.113305] forcing AN
>> [   45.118256] mtk_pcs_config: rgc3=3D0x0, advertise=3D0x1 (changed), li=
nk_timer=3D1600000,  sgm_mode=3D0x103, bmcr=3D0x1200, use_an=3D1
>> [   45.129191] mtk_pcs_link_up: interface=3D4
>> [   45.133100] offset:0 0x81140
>> [   45.133102] offset:4 0x4d544950
>> [   45.135967] offset:8 0x1
>> [   45.139104] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Ful=
l - flow control rx/tx
>
> In your _dump_pcs_ctrl() function, please can you dump the
> SGMSYS_SGMII_MODE register as well (offset 0x20), in case this gives
> more clue as to what's going on.


[   49.339410] mtk_soc_eth 15100000.ethernet wan: Link is Down
[   52.459913] mtk_sgmii_select_pcs: id=3D1
[   52.463673] mtk_pcs_config: interface=3D4
[   52.467494] offset:0 0x140
[   52.467496] offset:4 0x4d544950
[   52.470199] offset:8 0x20
[   52.473325] offset:20 0x10000
[   52.475929] forcing AN
[   52.481232] mtk_pcs_config: rgc3=3D0x0, advertise=3D0x1 (changed), link_=
timer=3D1600000,  sgm_mode=3D0x103, bmcr=3D0x1200, use_an=3D1
[   52.492166] mtk_pcs_link_up: interface=3D4
[   52.496072] offset:0 0x81140
[   52.496074] offset:4 0x4d544950
[   52.498938] offset:8 0x1
[   52.502067] offset:20 0x10000
[   52.504599] mtk_soc_eth 15100000.ethernet wan: Link is Up - 1Gbps/Full -=
 flow control rx/tx
[   65.979410] mtk_soc_eth 15100000.ethernet wan: Link is Down
[   70.139856] mtk_sgmii_select_pcs: id=3D1
[   70.143616] mtk_pcs_config: interface=3D22
[   70.147523] offset:0 0x81140
[   70.147525] offset:4 0x4d544950
[   70.150402] offset:8 0x1
[   70.153526] offset:20 0x10000
[   70.156049] mtk_pcs_config: rgc3=3D0x4, advertise=3D0x20 (changed), link=
_timer=3D10000000,  sgm_mode=3D0x0, bmcr=3D0x0, use_an=3D0
[   70.169672] mtk_pcs_link_up: interface=3D22
[   70.173664] offset:0 0x40140
[   70.173666] offset:4 0x4d544950
[   70.176530] offset:8 0x20
[   70.179659] offset:20 0x10000
[   70.182279] mtk_soc_eth 15100000.ethernet wan: Link is Up - 2.5Gbps/Full=
 - flow control rx/tx


Bj=C3=B8rn
