Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D736D08FA
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjC3PBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjC3PBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:01:06 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DE41BC;
        Thu, 30 Mar 2023 08:00:59 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5BCA04000B;
        Thu, 30 Mar 2023 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680188458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W+fF9+hXUqTVKBtkjbyAVsPYf8+Z/jN24amAbg/Esug=;
        b=I+eZwnKw0YV2yA5a4IdM7h2HHx5PsrKBF1G1q4qjSO6ZYs51TqyH6E5IBd5X/8Wu4kkerR
        6Tkxv3H5hA+c2t1pYmpEpowHKsVfugebbuJPcq5R0sqEC+1AHxwh4rzwZ19xrbz3uev6bH
        9/zNs4+GUSvgxaWMjSKjnG1Ly6+nWXAL+YwrnOBdHHjd+JStyxLo8dnR0mJ43lyu98tubX
        nNCccyGgNP7acXQv8IluJ400Nlo9vXYwSnE9xAAjb9suS6oklgyT5HbTU/q9Aqh9Cqa7BI
        p6bn+6roXHtvowBYnu6mo+a97MTSRv6dw0ZelkCCAtTbzBpsgQ59iO6PHOmASw==
Date:   Thu, 30 Mar 2023 17:01:34 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Alexis =?UTF-8?B?TG90aG9yw6k=?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rzn1-a5psw: enable DPBU for CPU
 port and fix STP states
Message-ID: <20230330170134.2f0cd3d1@fixe.home>
In-Reply-To: <20230330145623.z5q44euny3zj3uat@skbuf>
References: <20230330083408.63136-1-clement.leger@bootlin.com>
        <20230330083408.63136-2-clement.leger@bootlin.com>
        <20230330104828.6badaaad@fixe.home>
        <20230330145623.z5q44euny3zj3uat@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 30 Mar 2023 17:56:23 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Thu, Mar 30, 2023 at 10:48:28AM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Actually, after leaving a bridge, it seems like the DSA core put the
> > port in STP DISABLED state. Which means it will potentially leave that
> > port with TX disable... Since this TX enable is applying not only on
> > bridge port but also on standalone port, it seems like this also needs
> > to be reenabled in bridge_leave(). =20
>=20
> That's... not true? dsa_port_switchdev_unsync_attrs() has:
>=20
> 	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
> 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
> 	 */
> 	dsa_port_set_state_now(dp, BR_STATE_FORWARDING, true);
>=20
> a dump_stack() could help explain what's going on in your system?

Indeed, I was referring to the messages displayed by the STP setp state
function (br0: port 2(lan1) entered disabled state). But the DSA core
indeed calls the stp_set_state() to enable forwarding which then
reenables the Tx path so I guess we are all good with this series.
Sorry for that.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
