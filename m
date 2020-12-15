Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798302DB5F0
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 22:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgLOVel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:34:41 -0500
Received: from mail-03.mail-europe.com ([91.134.188.129]:50940 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgLOVee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 16:34:34 -0500
Date:   Tue, 15 Dec 2020 21:32:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1608067980;
        bh=+ErT7m0bXPd7Crgokd60v7Q830jr1gZutzvXrXse6qo=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=RNh2bIvtXlOL6gQN/R751USoqvMFozgHQiHZxi/U2NP/l0P4kdbqqZTuJSF+EKgXe
         93aWKnT+zsrNE/jcSav/J+kbErQDphUJKxvJFSQtDZ05Nguyc2jgbfKJPw/wGES89h
         OknbVP6n3NWY0CRceSWtSEMr+KI90SWgjYuT8I8s=
To:     Jakub Kicinski <kuba@kernel.org>
From:   Lars Everbrand <lars.everbrand@protonmail.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Reply-To: Lars Everbrand <lars.everbrand@protonmail.com>
Subject: Re: [PATCH net-next] bonding: correct rr balancing during link failure
Message-ID: <X9krelP/8MwGP0V5@black-debian>
In-Reply-To: <20201205114513.4886d15e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <X8f/WKR6/j9k+vMz@black-debian> <20201205114513.4886d15e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 11:45:13AM -0800, Jakub Kicinski wrote:
> Thanks for the patch!
Kind words for my first attempt at this. Sorry for answering a bit late,
proton-bridge is not my best friend lately.
>=20
> Looking at the code in question it feels a little like we're breaking
> abstractions if we bump the counter directly in get_slave_by_id.
My intention was to avoid a big change, and this was the easiest way. I
trust your opinion here.
>=20
> For one thing when the function is called for IGMP packets the counter
> should not be incremented at all. But also if packets_per_slave is not
> 1 we'd still be hitting the same leg multiple times (packets_per_slave
> / 2). So it seems like we should round the counter up somehow?
I did not consider this case, I only test =3D1 and random. Yeah, it breaks
if the counter is updated per packet in any >1 case.=20
>=20
> For IGMP maybe we don't have to call bond_get_slave_by_id() at all,
> IMHO, just find first leg that can TX. Then we can restructure
> bond_get_slave_by_id() appropriately for the non-IGMP case.
I can have another look but my I am not confident that I am skilled
enough in this area to produce a larger overhaul...=20

