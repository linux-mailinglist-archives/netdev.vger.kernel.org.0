Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952A61722E5
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgB0QLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:11:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58552 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729134AbgB0QLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:11:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582819871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=baOVStFi/SNG29sbg/ucY09+VCW+eczt7xzz7SmVLS4=;
        b=StHWcebpjJs71a41p3mNK8ZJtXu1lTDtAeyaHNSVbuNOIDJC9H2KIQuF0B9BUNBt2Z30Uh
        oaGuQlDYx7Cv0iD2TldMk8E7Bnp1hqT0NM72PrRZZVBqMfVSslChl8Rr0ozJw/tnRGcSs2
        TxXifWkvcpxtHTmeb0p/DfO5YgkqiwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-5nDBex09N9-vClpZCVygwA-1; Thu, 27 Feb 2020 11:11:08 -0500
X-MC-Unique: 5nDBex09N9-vClpZCVygwA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D43FDB68;
        Thu, 27 Feb 2020 16:11:05 +0000 (UTC)
Received: from localhost (ovpn-117-38.ams2.redhat.com [10.36.117.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EE2760C63;
        Thu, 27 Feb 2020 16:11:03 +0000 (UTC)
Date:   Thu, 27 Feb 2020 16:11:02 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     davem@davemloft.net, Dexuan Cui <decui@microsoft.com>,
        Hillf Danton <hdanton@sina.com>,
        virtualization@lists.linux-foundation.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, kvm@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net] vsock: fix potential deadlock in transport->release()
Message-ID: <20200227161102.GC315098@stefanha-x1.localdomain>
References: <20200226105818.36055-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200226105818.36055-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2020 at 11:58:18AM +0100, Stefano Garzarella wrote:
> Some transports (hyperv, virtio) acquire the sock lock during the
> .release() callback.
>=20
> In the vsock_stream_connect() we call vsock_assign_transport(); if
> the socket was previously assigned to another transport, the
> vsk->transport->release() is called, but the sock lock is already
> held in the vsock_stream_connect(), causing a deadlock reported by
> syzbot:
>=20
>     INFO: task syz-executor280:9768 blocked for more than 143 seconds.
>       Not tainted 5.6.0-rc1-syzkaller #0
>     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mess=
age.
>     syz-executor280 D27912  9768   9766 0x00000000
>     Call Trace:
>      context_switch kernel/sched/core.c:3386 [inline]
>      __schedule+0x934/0x1f90 kernel/sched/core.c:4082
>      schedule+0xdc/0x2b0 kernel/sched/core.c:4156
>      __lock_sock+0x165/0x290 net/core/sock.c:2413
>      lock_sock_nested+0xfe/0x120 net/core/sock.c:2938
>      virtio_transport_release+0xc4/0xd60 net/vmw_vsock/virtio_transport_c=
ommon.c:832
>      vsock_assign_transport+0xf3/0x3b0 net/vmw_vsock/af_vsock.c:454
>      vsock_stream_connect+0x2b3/0xc70 net/vmw_vsock/af_vsock.c:1288
>      __sys_connect_file+0x161/0x1c0 net/socket.c:1857
>      __sys_connect+0x174/0x1b0 net/socket.c:1874
>      __do_sys_connect net/socket.c:1885 [inline]
>      __se_sys_connect net/socket.c:1882 [inline]
>      __x64_sys_connect+0x73/0xb0 net/socket.c:1882
>      do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>      entry_SYSCALL_64_after_hwframe+0x49/0xbe
>=20
> To avoid this issue, this patch remove the lock acquiring in the
> .release() callback of hyperv and virtio transports, and it holds
> the lock when we call vsk->transport->release() in the vsock core.
>=20
> Reported-by: syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com
> Fixes: 408624af4c89 ("vsock: use local transport when it is loaded")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/af_vsock.c                | 20 ++++++++++++--------
>  net/vmw_vsock/hyperv_transport.c        |  3 ---
>  net/vmw_vsock/virtio_transport_common.c |  2 --
>  3 files changed, 12 insertions(+), 13 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5X6hYACgkQnKSrs4Gr
c8hIwwf/VpB7q37vIv4l2+NFuq3CWGZbLfSSG7A9u4sXSo+VhcEltqh8jdz8xEfS
k9JaAaCosM43HAtz+LPmfHG6eL761HjpUQ9KnLgU53aWhJwFuIv000o2w+OA3X4O
cr1aWzcWJzFpkU1xQb41J1FR8FUymgWSqQPitEF3ElEnmbfFGSrEgrVOc9Ou2Qhb
57r4rlPuiZNNshiWMjCalPewQeJETnrEnB9cxsjc0gMu/xn1KRE7g6i4yG1smtjm
YSgZmV1NgDWrAKr//amiOCqTvKH2DUYYgvUwnx27G0iRrWO47TQYbE+/jDd+FUol
u2jPzVcR0q/qq1CJsyPqKx+7pdCqUg==
=t+mC
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--

