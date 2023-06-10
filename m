Return-Path: <netdev+bounces-9785-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0342B72A95A
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 08:26:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DFA8281AB3
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 06:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC9446FAE;
	Sat, 10 Jun 2023 06:26:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C8A1878
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 06:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7141FC433EF;
	Sat, 10 Jun 2023 06:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686378374;
	bh=D6HyayhXVPLTIsJDCmDDDxuJNPSJo6AL0U2eIvf/M6Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jlPH8ZcDj9TI2+B2OYBOMGSZfzNGyMcK8D83g8MIaWEAdbrGMALk8OgPWbkfotA6B
	 ULyWIrrp5+gc1lVuUeLQmhFzUXjjmjZyOCHeciSsG3p9Fp8V5xA3AVLzlcz8INops6
	 ZQDKFJ3u6k0Eb6TRww/QFVrZm+IaKN9mEpZSaRUORY9eCY6dnttqDVnxckUvjjixKA
	 wsl8h1jS4RAJf9VDFDFn/kiFoAzHNEKqeKNLRgSjAxQ8Ady5GuUP2IIM2xakzXs/dE
	 owGOBYHcecZEccPg0Oxk8OZC9naQ9CmSMU8xsoQ3rvtlwfuivJCQifDmEprO3GSkj4
	 QCjWg2AFD3XfQ==
Date: Fri, 9 Jun 2023 23:26:13 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Vlad Yasevich
 <vladislav.yasevich@hp.com>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 net] sctp: fix an error code in sctp_sf_eat_auth()
Message-ID: <20230609232613.14475572@kernel.org>
In-Reply-To: <CADvbK_e2JwH3OqFSu89EvrtGbBbuCvD-C=Db_sExjvD1EcVLrw@mail.gmail.com>
References: <4629fee1-4c9f-4930-a210-beb7921fa5b3@moroto.mountain>
	<bfb9c077-b9a6-47f4-8cd8-a7a86b056a21@moroto.mountain>
	<CADvbK_f25PEaR1bSuyqeGQsoOp0v1Psaeu2zPhfEi8Zcu-J5Tw@mail.gmail.com>
	<7899ff13-ab06-4970-a306-85b218486571@kadam.mountain>
	<CADvbK_e2JwH3OqFSu89EvrtGbBbuCvD-C=Db_sExjvD1EcVLrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 9 Jun 2023 19:04:17 -0400 Xin Long wrote:
> On Fri, Jun 9, 2023 at 12:41=E2=80=AFPM Dan Carpenter <dan.carpenter@lina=
ro.org> wrote:
> >
> > On Fri, Jun 09, 2023 at 11:13:03AM -0400, Xin Long wrote: =20
> > > This one looks good to me.
> > >
> > > But for the patch 1/2 (somehow it doesn't show up in my mailbox):
> > >
> > >   default:
> > >   pr_err("impossible disposition %d in state %d, event_type %d, event=
_id %d\n",
> > >         status, state, event_type, subtype.chunk);
> > > - BUG();
> > > + error =3D status;
> > > + if (error >=3D 0)
> > > + error =3D -EINVAL;
> > > + WARN_ON_ONCE(1);
> > >
> > > I think from the sctp_do_sm() perspective, it expects the state_fn
> > > status only from
> > > enum sctp_disposition. It is a BUG to receive any other values and
> > > must be fixed,
> > > as you did in 2/2. It does the same thing as other functions in SCTP =
code, like
> > > sctp_sf_eat_data_*(), sctp_retransmit() etc. =20
> >
> > It is a bug, sure.  And after my patch is applied it will still trigger
> > a stack trace.  But we should only call the actual BUG() function
> > in order to prevent filesystem corruption or a privilege escalation or
> > something along those lines. =20
> Hi, Dan,
>=20
> Sorry, I'm not sure about this.
>=20
> Look at the places where it's using  BUG(), it's not exactly the case, li=
ke
> in ping_err() or ping_common_sendmsg(), BUG() are used more for
> unexpected cases, which don't cause any filesystem corruption or a
> privilege escalation.
>=20
> You may also check more others under net/*.

Most BUG()s under net/ are historic. The legit BUG() uses I can think
of are at boot, if something fails you can't bring up the system at all.

https://docs.kernel.org/process/deprecated.html?highlight=3Dbug#bug-and-bug=
-on

> > Calling BUG() makes the system unusable so it makes bugs harder to
> > debug.  This is even mentioned in checkpatch.pl "Do not crash the kernel
> > unless it is absolutely unavoidable--use WARN_ON_ONCE() plus recovery
> > code (if feasible) instead of BUG() or variants".
> > =20
> "absolutely unavoidable", I think in a module, if it gets a case that is =
not
> expected at all, and the consequence (it may cause or has caused) is
> unsure, WARN_ON_ONCE() is not enough.

