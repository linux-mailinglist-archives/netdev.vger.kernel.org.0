Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCF3308E4A
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbhA2UTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:19:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233083AbhA2UTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 15:19:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5BB264DD8;
        Fri, 29 Jan 2021 20:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611951519;
        bh=+Ej3SeW7aMCRrsn2KltEXlHItvZVOd+FbBUWcZ8glKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VzHl6YgHWEuu95DpDf8mIGoKpNfEPXztGtxLF2I7KRgOzZwehQk3IyT3F0xD4tvyp
         bTMpFaxgWb6Zm9lYq+x4+XPEmr7hPi2NZ9EkLmzr1mmBUejGjav2XDpAni3dwfLONx
         yacR/oqyOIEtpmnxf3DxstxpVoCJ6y56OTGJEzAGiVLC70ktEAoajPoujoYLeBVH2P
         NLaD86b7Gh/26s1wHtiPibS6Slgu3zT1CCvRadr9Z8dVH+CPQgS8D4nKz3TphKZomg
         QOfQKPG9r/sp6GngHAZsxRzgL4Z0YKv3C3ljeHbRY3H0qv2HLflsPg3aN3XHqf7KOs
         CufAWgy2hDFmg==
Date:   Fri, 29 Jan 2021 12:18:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andy.rudoff@intel.com
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Message-ID: <20210129121837.467280fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cef52fb0-43cb-9038-7e48-906b58b356b6@oracle.com>
References: <20210122150638.210444-1-willy@infradead.org>
        <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
        <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a21dc26a-87dc-18c8-b8bd-24f9797afbad@oracle.com>
        <20210129120250.269c366d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cef52fb0-43cb-9038-7e48-906b58b356b6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 12:10:21 -0800 Shoaib Rao wrote:
> On 1/29/21 12:02 PM, Jakub Kicinski wrote:
> > On Fri, 29 Jan 2021 11:48:15 -0800 Shoaib Rao wrote: =20
> >> Data was discarded because the flag was not supported, this patch
> >> changes that but does not support any urgent data. =20
> > When you say it does not support any urgent data do you mean the
> > message len must be =3D=3D 0 because something is checking it, or that
> > the code does not support its handling?
> >
> > I'm perfectly fine with the former, just point me at the check, please.=
 =20
>=20
> The code does not care about the size of data -- All it does is that if=20
> MSG_OOB is set it will deliver the signal to the peer process=20
> irrespective of the length of the data (which can be zero length). Let's=
=20
> look at the code of unix_stream_sendmsg() It does the following (sent is=
=20
> initialized to zero)

Okay. Let me try again. AFAICS your code makes it so that data sent
with MSG_OOB is treated like any other data. It just sends a signal.
So you're hijacking the MSG_OOB to send a signal, because OOB also
sends a signal. But there is nothing OOB about the data itself. So=20
I'm asking you to make sure that there is no data in the message.=20
That way when someone wants _actual_ OOB data on UNIX sockets they=20
can implement it without breaking backwards compatibility of the=20
kernel uAPI.

> while (sent < len) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 size =3D len - sent;
> <..>
>=20
> }
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (msg->msg_flags & MSG_OOB)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 sk_send_sigurg(other);
>=20
> Before the patch there was a check above the while loop that checked the=
=20
> flag and returned and error, that has been removed.
