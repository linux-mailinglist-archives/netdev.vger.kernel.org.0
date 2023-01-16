Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CCB66CF44
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 20:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbjAPTAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 14:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbjAPTAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 14:00:48 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4835A234D5;
        Mon, 16 Jan 2023 11:00:47 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GIxuOn2109213
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:59:57 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GIxoPL2177984
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 19:59:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673895591; bh=a4SXkIxmSrOYxxcCMtrOU0vev2/ZChtTN7KgK4Iptkk=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=kQkPNgTCxYO8ZngrQVLf1ev5VkkeS7NUDz467UYSHqRWRl33bLvhs5qsTRMrCWf8c
         6BYJthnUdI7buFBRRe/TUfe/2722DX6fmLLcctQ6KCh+QzQDgJJgX/SqlVB7UoUvb1
         O0vsA831gPz393sL+SYfAC2vQRFmH+wZqbhHF3W8=
Received: (nullmailer pid 387067 invoked by uid 1000);
        Mon, 16 Jan 2023 18:59:50 -0000
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
References: <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
        <87bkmy33ph.fsf@miraculix.mork.no>
        <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
        <875yd630cu.fsf@miraculix.mork.no> <871qnu2ztz.fsf@miraculix.mork.no>
        <Y8WNxAQ6C6NyUUn1@shell.armlinux.org.uk>
        <87pmbe1hu0.fsf@miraculix.mork.no> <87lem21hkq.fsf@miraculix.mork.no>
        <Y8WT6GwMqwi8rBe7@shell.armlinux.org.uk>
        <87a62i1ge4.fsf@miraculix.mork.no>
        <Y8WdTVU141f2L1R5@shell.armlinux.org.uk>
Date:   Mon, 16 Jan 2023 19:59:50 +0100
In-Reply-To: <Y8WdTVU141f2L1R5@shell.armlinux.org.uk> (Russell King's message
        of "Mon, 16 Jan 2023 18:54:05 +0000")
Message-ID: <87zgaiz4nt.fsf@miraculix.mork.no>
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

> On Mon, Jan 16, 2023 at 07:30:27PM +0100, Bj=C3=B8rn Mork wrote:
>> "Russell King (Oracle)" <linux@armlinux.org.uk> writes:
>>=20
>> > That all looks fine. However, I'm running out of ideas.
>>=20
>> Thanks a lot for the effort in any case.  It's comforting that even the
>> top experts can't figure out this one :-)
>>=20
>>=20
>> > What we seem to have is:
>> >
>> > PHY:
>> > VSPEC1_SGMII_CTRL =3D 0x34da
>> > VSPEC1_SGMII_STAT =3D 0x000e
>> >
>> > The PHY is programmed to exchange SGMII with the host PCS, and it
>> > says that it hasn't completed that exchange (bit 5 of STAT).
>> >
>> > The Mediatek PCS says:
>> > BMCR =3D 0x1140		AN enabled
>> > BMSR =3D 0x0008		AN capable
>> > ADVERTISE =3D 0x0001	SGMII response (bit 14 is clear, hardware is
>> > 			supposed to manage that bit)
>> > LPA =3D 0x0000		SGMII received control word (nothing)
>> > SGMII_MODE =3D 0x011b	SGMII mode, duplex AN, 1000M, Full duplex,
>> > 			Remote fault disable
>> >
>> > which all looks like it should work - but it isn't.
>> >
>> > One last thing I can think of trying at the moment would be writing
>> > the VSPEC1_SGMII_CTRL with 0x36da, setting bit 9 which allegedly
>> > restarts the SGMII exchange. There's some comments in the PHY driver
>> > that this may be needed - maybe it's necessary once the MAC's PCS
>> > has been switched to SGMII mode.
>>=20
>>=20
>> Tried that now.  Didn't change anything.  And still no packets.
>>=20
>> root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
>> 0x34da
>> root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
>> 0x000e
>> root@OpenWrt:/# mdio mdio-bus 6:30 raw 8 0x36da
>> root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
>> 0x34da
>> root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
>> 0x000e
>
> If bit 9 is indeed the restart-an bit, it will be self-clearing, so
> I wouldn't expect a read back of it to change to 0x36da.
>
> I guess next thing to try is clearing and setting the AN enable bit,
> bit 12, so please try this:
>
> mdio mdio-bus 6:30 raw 8 0x24da
> mdio mdio-bus 6:30 raw 8 0x36da
> mdio mdio-bus 6:30 raw 9
>
> If that doesn't work, then let's try something a bit harder:
>
> mdio mdio-bus 6:30 raw 8 0xb4da
> mdio mdio-bus 6:30 raw 9
>
> Please let me know the results from those.

OK, back to the original dts with phy-mode =3D "2500base-x", with peer set
to 1G.  Still no success:

root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
0x34da
root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
0x000e
root@OpenWrt:/#  mdio mdio-bus 6:30 raw 8 0x24da
root@OpenWrt:/# mdio mdio-bus 6:30 raw 8 0x36da
root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
0x000e
root@OpenWrt:/# mdio mdio-bus 6:30 raw 8 0xb4da
root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
0x000e



Bj=C3=B8rn
