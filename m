Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80D4496CD5
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 16:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiAVPve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 10:51:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48894 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbiAVPvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jan 2022 10:51:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0Dkpea18J6WunFkXH5z3bm2XvFAUdlPI4g4c38Jf2PQ=; b=jtuCbIzf9YXW16xJ8KfxIwiIwx
        +4+OLTgctGWIH11VrLRMWamUZxlOZ1jyRAM4rwkzkqDE9Xvv41UuTuSv9ztX0SI/Zn0Dp8JzYAPmy
        CKkQaEfY7keoC007L+gBLC9AFn64eLgePhhaHvrlaLWD9tXtPuHEUvMGopyoNa45x5s4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBIfo-002IyP-71; Sat, 22 Jan 2022 16:51:28 +0100
Date:   Sat, 22 Jan 2022 16:51:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <YewoABDa0/u1f6tg@lunn.ch>
References: <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch>
 <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <20220121185009.pfkh5kbejhj5o5cs@skbuf>
 <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> trap_port seems to be where the switch will send any packet captured
> from LAN ports. There are a couple of situations it will be used like:
> 1) untagged or unmatched vlan packets (if configured to do so)
> 2) some multicasting packets (Reserved Multicast Address), for some
> cases like capturing STP or LACP
> 3) IGMP and 802.1X EAPOL packets
> 4) Switch ACL rules that could match a packet and send it to the trap port.
> 
> In my early tests, I only saw some IGMP packets trapped to CPU. I also
> do not know how important they are.

STP is important for detecting loops in the ethernet traffic and
blocking ports. The linux software bridge will want to see these
packets.

IGMP will become important when you implement multicast support in the
switch. It will allow you to optimize the distribution of multicast to
only ports which have expressed an interest in receiving the group.

Currently we don't have any switch driver making use of 802.1x. It is
something which many switches have, but so far nobody has spent the
time to implement an interface to wpa_supplicant etc.

     Andrew
