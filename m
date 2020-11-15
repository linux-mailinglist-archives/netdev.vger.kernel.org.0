Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061152B3211
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 04:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgKODyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 22:54:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:32946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgKODyj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 22:54:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9444422447;
        Sun, 15 Nov 2020 03:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605412478;
        bh=NdpELu3ijuYKuP5wu8Fdm+fYg0C6lCTP9JvSu5BVkE0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IZLz1Ik49jlpQMtmYkSDWVdAUJ+umBIjHSfmRVPTOCbMffcicIdxz46Xazqme6ax6
         mMXp4ZIx3YiTOOFpxLKBSKjM9IETnXgW93vjkXZ84nZc6uIbjNG5gadLRQoLiajPWt
         ELT7TcrtMivJCWIsam6PurxLw3sZKyFhmTQeQEdw=
Date:   Sat, 14 Nov 2020 19:54:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net] net/tls: fix corrupted data in recvmsg
Message-ID: <20201114195437.4d0493b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2f5daf5a-0d38-d766-c345-9875f6d2d66d@novek.ru>
References: <1605326982-2487-1-git-send-email-vfedorenko@novek.ru>
        <20201114181249.4fab54d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2f5daf5a-0d38-d766-c345-9875f6d2d66d@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please don't top post.

On Sun, 15 Nov 2020 02:26:30 +0000 Vadim Fedorenko wrote:
> No, I don't have any BPFs in test.
> If we have Application Data in TCP queue then tls_sw_advance_skb
> will change ctx->control from 0x16 to 0x17 (TLS_RECORD_TYPE_DATA)
> and the loop will continue.

Ah! Missed that, unpausing the parser will make it serve us another
message and overwrite ctx.

> The patched if will make zc =3D true and
> data will be decrypted into msg->msg_iter.
> After that the loop will break on:
>  =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (!control)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 control =
=3D tlm->control;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 else if (control !=3D tlm->control)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto rec=
v_end;
>
> and the data will be lost.
> Next call to recvmsg will find ctx->decrypted set to true and will
> copy the unencrypted data from skb assuming that it has been decrypted
> already.
>=20
> The patch that I put into Fixes: changed the check you mentioned to
> ctx->control, but originally it was checking the value of control that
> was stored before calling to tls_sw_advance_skb.

Is there a reason why we wouldn't just go back to checking the stored
control? Or better - put your condition there (control !=3D ctx->control)?
Decrypting the next record seems unnecessary given we can't return it.
