Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAE1197C8E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 15:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgC3NNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 09:13:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:32526 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729995AbgC3NNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 09:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585574010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a2eDVUDQg2hdmjkrT2WUUojNrMoGT9y+y9YRzbu0Ip0=;
        b=Mru4Z5YVGtcvWDDEzuWArRpfF8gaeCKywL1y5S8B5i1l5ZCmHvfUzMaOxLmH2Y7xwkcvKH
        gfgbwQ7KE/r4FcpDhdq4ZcniLjkhcHZNJhIGs1zAYo03uz0HEOh6/QW8QkpuECm0MqNUlh
        ib5uvvsiE1ZY5L6Y0mpAWqWuZLgY4/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-OthnFX7_NgKWEQWSP7_Lsw-1; Mon, 30 Mar 2020 09:13:16 -0400
X-MC-Unique: OthnFX7_NgKWEQWSP7_Lsw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18CFD1084424;
        Mon, 30 Mar 2020 13:13:15 +0000 (UTC)
Received: from localhost (ovpn-115-236.rdu2.redhat.com [10.10.115.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87DF819925;
        Mon, 30 Mar 2020 13:13:14 +0000 (UTC)
Date:   Mon, 30 Mar 2020 10:13:13 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH v2] net/bpfilter: fix dprintf usage for /dev/kmsg
Message-ID: <20200330131313.GA10754@glitch>
References: <CALidq=VmXZ5erdNOeBdXE087QHO7SZVn4rb5+M26GrB56dpYpQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALidq=VmXZ5erdNOeBdXE087QHO7SZVn4rb5+M26GrB56dpYpQ@mail.gmail.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2020 at 03:48:12PM +0300, Martin Zaharinov wrote:
> Hi Bruno
> i see after release kernel 5.6.0 with your latest patch have strange
> messages please check:
>=20
> [   31.025483] bpfilter: Loaded bpfilter_umh pid 2689
> [   31.025533] Started bpfilter
> [   31.042586] testing the buffer
> [   31.050822] testing the buffer
> [   31.059304] testing the buffer
> [   31.067747] testing the buffer
> [   31.148789] testing the buffer
> [   31.156130] testing the buffer
> [   31.164012] testing the buffer
> [   31.170685] testing the buffer
> [   31.176886] testing the buffer
>=20
> when drop bpfilter module stop enter new messages in kmsg.
>=20

Hi Martin,

these aren't really "strange messages", but the correct ones. They
started to appear now because before my patch the log wasn't working at
all. I'm not really aware what is the logic behind the bpfilter_umh
module, but AFAIK each iptable rule sent from kernel side to UMH
userspace code will generate one "testing the buffer" message.

I think we can silence it by limiting it to print only once, but I would
need to check with Alexei Starovoitov <ast@kernel.org> if it would be
fine (CC'ing here).

Thanks for the heads up :).

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl6B8GkACgkQYdRkFR+R
okNKIQf9Gsi8Gq4ZSChAxcqE2xRJucpZa6O3ZeLTnanukTt8SGYVfooBJFGDAtnO
qchchyTtC2Bk7QAuNnYf78/dtxXVsxXYBf0s9R3SA2v5p8aLuWZR5Pv5dMeLBkIN
3gSX4EBXsvfGGJVaeD2jvpw66fke22XNLBwR2tXMTIiJQNuA3RebNitoLQlFAYB1
x425c29sDxzAU2pcLS6dRPnSsH5HTEE5Uvp0094IgP/0JD44WLrLlLaqm1IxKhDJ
Lm2/8JkB8iMUm8YAA2MOxdd+ctdZThOPj8pYLA6Oi5dQv6TfAzh9r9FzMPo5MHz5
c3lyPWLR1NjgMdAWSA/kNKiTSg2lPQ==
=lYUs
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--

