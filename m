Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B1D66CEFD
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbjAPSjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbjAPSin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:38:43 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF6214E94;
        Mon, 16 Jan 2023 10:31:08 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GIUWgx2107688
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:30:34 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30GIURQS2116310
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 19:30:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673893827; bh=YIreTAFzFbHVGEZj5QHfTlpaspfbnqFUVKN4fQm7d5o=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=DoK6r50BgPDxe/DnATBMHLjR6PsHXGsBHeDf0iTkHbxqh3ledlOf0c0hYMF6FuWPU
         RkS6eRhgioGhTBvkQ65f+/+rIVU9TU14YTM3VgX+rijYX8a/jfhMl+IpYXkSmqdfrL
         MErgDDJMzwcn5tF05aLblF+AjqFKcuMwK/psVxWI=
Received: (nullmailer pid 386862 invoked by uid 1000);
        Mon, 16 Jan 2023 18:30:27 -0000
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
References: <Y8VVa0zHk0nCwS1w@shell.armlinux.org.uk>
        <87h6wq35dn.fsf@miraculix.mork.no>
        <Y8VmSrjHTlllaDy2@shell.armlinux.org.uk>
        <87bkmy33ph.fsf@miraculix.mork.no>
        <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
        <875yd630cu.fsf@miraculix.mork.no> <871qnu2ztz.fsf@miraculix.mork.no>
        <Y8WNxAQ6C6NyUUn1@shell.armlinux.org.uk>
        <87pmbe1hu0.fsf@miraculix.mork.no> <87lem21hkq.fsf@miraculix.mork.no>
        <Y8WT6GwMqwi8rBe7@shell.armlinux.org.uk>
Date:   Mon, 16 Jan 2023 19:30:27 +0100
In-Reply-To: <Y8WT6GwMqwi8rBe7@shell.armlinux.org.uk> (Russell King's message
        of "Mon, 16 Jan 2023 18:14:00 +0000")
Message-ID: <87a62i1ge4.fsf@miraculix.mork.no>
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

> That all looks fine. However, I'm running out of ideas.

Thanks a lot for the effort in any case.  It's comforting that even the
top experts can't figure out this one :-)


> What we seem to have is:
>
> PHY:
> VSPEC1_SGMII_CTRL =3D 0x34da
> VSPEC1_SGMII_STAT =3D 0x000e
>
> The PHY is programmed to exchange SGMII with the host PCS, and it
> says that it hasn't completed that exchange (bit 5 of STAT).
>
> The Mediatek PCS says:
> BMCR =3D 0x1140		AN enabled
> BMSR =3D 0x0008		AN capable
> ADVERTISE =3D 0x0001	SGMII response (bit 14 is clear, hardware is
> 			supposed to manage that bit)
> LPA =3D 0x0000		SGMII received control word (nothing)
> SGMII_MODE =3D 0x011b	SGMII mode, duplex AN, 1000M, Full duplex,
> 			Remote fault disable
>
> which all looks like it should work - but it isn't.
>
> One last thing I can think of trying at the moment would be writing
> the VSPEC1_SGMII_CTRL with 0x36da, setting bit 9 which allegedly
> restarts the SGMII exchange. There's some comments in the PHY driver
> that this may be needed - maybe it's necessary once the MAC's PCS
> has been switched to SGMII mode.


Tried that now.  Didn't change anything.  And still no packets.

root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
0x34da
root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
0x000e
root@OpenWrt:/# mdio mdio-bus 6:30 raw 8 0x36da
root@OpenWrt:/# mdio mdio-bus 6:30 raw 8
0x34da
root@OpenWrt:/# mdio mdio-bus 6:30 raw 9
0x000e


Bj=C3=B8rn
