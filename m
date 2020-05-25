Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1997E1E0EAC
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 14:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390596AbgEYMsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 08:48:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45660 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390488AbgEYMsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 08:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590410890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cXTd2ppK+6r836CB8dInVYoZ8j7/dPNzPVKmNNkloxQ=;
        b=SkGiB0iWeFt3adbmdQW4bZaxBXvkE0GpwRPJAlDOGVqQSS53sLHV9CWUgS21jx9M/uhhxe
        xgM2qp9P14o6QBzWwWMorMovZrLCB9QWJBHuGWx0aEpgPP7nK68+3HmeEeJrlhtKlpo6os
        SiAWNFEwVzPjXxA3E+8Nw76f1HVAccE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-Jmz0_aHlNFSZqh2XTlpW4w-1; Mon, 25 May 2020 08:48:06 -0400
X-MC-Unique: Jmz0_aHlNFSZqh2XTlpW4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82A91107ACCD;
        Mon, 25 May 2020 12:48:04 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4317D10013D2;
        Mon, 25 May 2020 12:47:54 +0000 (UTC)
Date:   Mon, 25 May 2020 14:47:52 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        brouer@redhat.com
Subject: Re: [PATCH RFC bpf-next 0/4] bpf: Add support for XDP programs in
 DEVMAPs
Message-ID: <20200525144752.3e87f8cd@carbon>
In-Reply-To: <87v9kki523.fsf@toke.dk>
References: <20200522010526.14649-1-dsahern@kernel.org>
        <87lflkj6zs.fsf@toke.dk>
        <f94be4c8-c547-1be0-98c8-7e7cd3b7ee71@gmail.com>
        <87v9kki523.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 May 2020 14:15:32 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> David Ahern <dsahern@gmail.com> writes:
>=20
> > On 5/22/20 9:59 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote: =20
> >> David Ahern <dsahern@kernel.org> writes:
> >>  =20
> >>> Implementation of Daniel's proposal for allowing DEVMAP entries to be
> >>> a device index, program id pair. Daniel suggested an fd to specify the
> >>> program, but that seems odd to me that you insert the value as an fd,=
 but
> >>> read it back as an id since the fd can be closed. =20
> >>=20
> >> While I can be sympathetic to the argument that it seems odd, every
> >> other API uses FD for insert and returns ID, so why make it different
> >> here? Also, the choice has privilege implications, since the CAP_BPF
> >> series explicitly makes going from ID->FD a more privileged operation
> >> than just querying the ID.

Sorry, I don't follow.
Can someone explain why is inserting an ID is a privilege problem?

  =20
> >
> > I do not like the model where the kernel changes the value the user
> > pushed down. =20
>=20
> Yet it's what we do in every other interface where a user needs to
> supply a program, including in prog array maps. So let's not create a
> new inconsistent interface here...

I sympathize with Ahern on this.  It seems very weird to insert/write
one value-type, but read another value-type.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

