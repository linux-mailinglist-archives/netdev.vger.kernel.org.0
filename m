Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA50F28A22A
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389025AbgJJWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731406AbgJJTU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:20:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D56B22258;
        Sat, 10 Oct 2020 19:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602357626;
        bh=1rFFenx5YaOoyjN6AOp5kOMJV7iSmN0ey8iVvvT9Ck0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u1uXILE4wH+0QAJm6IeD5VwS/QkS3cEJnyAbweMQ2CZGsWfc1JVZHAL9qTYl/K+Fa
         ZBu/bchAgrF/5CmgDG3BM/ajQaUBEbepcDnZGCLlSAZtSQpTg2f8wpmeJOsqKXixhy
         cRBEorT0By3F6D1EY3DuANtfFgrE53GazWxPUNTc=
Date:   Sat, 10 Oct 2020 12:20:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [PATCH] net: usb: rtl8150: don't incorrectly assign random MAC
 addresses
Message-ID: <20201010122024.0ec7c2f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e772b9f0-f5cd-c50b-86a7-fde22b6e13e3@gmail.com>
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
        <20201010095302.5309c118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0de8e509-7ca5-7faf-70bf-5880ce0fc15c@gmail.com>
        <20201010111645.334647af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e772b9f0-f5cd-c50b-86a7-fde22b6e13e3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 00:14:05 +0530 Anant Thazhemadam wrote:
> Ah, my apologies. You're right. It doesn't look like those helpers have m=
ade
> their way into the networking tree yet.
>=20
> (This gets mentioned here as well,
> =C2=A0=C2=A0=C2=A0 https://www.mail-archive.com/netdev@vger.kernel.org/ms=
g357843.html)
>=20
> The commit ID pointed to by the fixes tag is correct.
> The change introduced by said commit looks right, but is logically incorr=
ect.
>=20
> get_registers() directly returns the return value of usb_control_msg_recv=
(),
> and usb_control_msg_recv() returns 0 on success and negative error number
> otherwise.
>=20
> (You can find more about the new helpers here
> =C2=A0=C2=A0=C2=A0 https://lore.kernel.org/alsa-devel/20200914153756.3412=
156-1-gregkh@linuxfoundation.org/ )
>=20
> The commit ID mentioned introduces a change that is supposed to copy over
> the ethernet only when get_registers() succeeds, i.e., a complete read oc=
curs,
> and generate and set a random ethernet address otherwise (reading the
> commit message should give some more insight).
>=20
> The condition that checks if get_registers() succeeds (as specified in f4=
5a4248ea4c)
> was,
> =C2=A0=C2=A0=C2=A0 ret =3D=3D sizeof(node_id)
> where ret is the return value of get_registers().
>=20
> However, ret will never equal sizeof(node_id), since ret can only be equa=
l to 0
> or a negative number.
>=20
> Thus, even in case where get_registers() succeeds, a randomly generated M=
AC
> address would get copied over, instead of copying the appropriate ethernet
> address, which is logically incorrect and not optimal.
>=20
> Hence, we need to modify this to check if (ret =3D=3D 0), and copy over t=
he correct
> ethernet address in that case, instead of randomly generating one and ass=
igning
> that.

I see... so we ended up with your fix applied to net, and Petko's
rework applied to the usb/usb-next tree.

What you're actually fixing is the improper resolution of the resulting
conflict in linux-next!

CCing Stephen and linux-next.
