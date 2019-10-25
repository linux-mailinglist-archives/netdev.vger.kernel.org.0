Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C63CE450A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 10:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437528AbfJYIA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 04:00:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26587 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2437520AbfJYIA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 04:00:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571990425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/LoaaTv4vAnICJNi9X+ns+lbhK+lgVEY+k5kW3oHXGY=;
        b=EVFb7boQUOjHNiUBbZ9P5jAp0HEDa+Evw83vtDR6zsIRA9rQcrzOtwxMo6LGegW2H3uLby
        U8KTjGHH0GyT7YnUte6I4ZCTYGtv3N/PcfjtEGjQEDNi0FvK5ReFPCTyHyqgYCV3v6q+fG
        2nai31WsIBDt5JWmq81UpAbeymVKmeg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-VPCrquMeNZOwl9fTyy1DVw-1; Fri, 25 Oct 2019 04:00:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E295C1800E00;
        Fri, 25 Oct 2019 08:00:18 +0000 (UTC)
Received: from ovpn-116-201.ams2.redhat.com (ovpn-116-201.ams2.redhat.com [10.36.116.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82CBE60852;
        Fri, 25 Oct 2019 08:00:17 +0000 (UTC)
Message-ID: <5ef3ce11785c58bc93ff7809cc1b35dfb354974f.camel@redhat.com>
Subject: Re: [PATCH net] udp: fix data-race in udp_set_dev_scratch()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Date:   Fri, 25 Oct 2019 10:00:16 +0200
In-Reply-To: <20191024184331.28920-1-edumazet@google.com>
References: <20191024184331.28920-1-edumazet@google.com>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: VPCrquMeNZOwl9fTyy1DVw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-24 at 11:43 -0700, Eric Dumazet wrote:
> KCSAN reported a data-race in udp_set_dev_scratch() [1]
>=20
> The issue here is that we must not write over skb fields
> if skb is shared. A similar issue has been fixed in commit
> 89c22d8c3b27 ("net: Fix skb csum races when peeking")
>=20
> While we are at it, use a helper only dealing with
> udp_skb_scratch(skb)->csum_unnecessary, as this allows
> udp_set_dev_scratch() to be called once and thus inlined.
>=20
> [1]
> BUG: KCSAN: data-race in udp_set_dev_scratch / udpv6_recvmsg
>=20
> write to 0xffff888120278317 of 1 bytes by task 10411 on cpu 1:
>  udp_set_dev_scratch+0xea/0x200 net/ipv4/udp.c:1308
>  __first_packet_length+0x147/0x420 net/ipv4/udp.c:1556
>  first_packet_length+0x68/0x2a0 net/ipv4/udp.c:1579
>  udp_poll+0xea/0x110 net/ipv4/udp.c:2720
>  sock_poll+0xed/0x250 net/socket.c:1256
>  vfs_poll include/linux/poll.h:90 [inline]
>  do_select+0x7d0/0x1020 fs/select.c:534
>  core_sys_select+0x381/0x550 fs/select.c:677
>  do_pselect.constprop.0+0x11d/0x160 fs/select.c:759
>  __do_sys_pselect6 fs/select.c:784 [inline]
>  __se_sys_pselect6 fs/select.c:769 [inline]
>  __x64_sys_pselect6+0x12e/0x170 fs/select.c:769
>  do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> read to 0xffff888120278317 of 1 bytes by task 10413 on cpu 0:
>  udp_skb_csum_unnecessary include/net/udp.h:358 [inline]
>  udpv6_recvmsg+0x43e/0xe90 net/ipv6/udp.c:310
>  inet6_recvmsg+0xbb/0x240 net/ipv6/af_inet6.c:592
>  sock_recvmsg_nosec+0x5c/0x70 net/socket.c:871
>  ___sys_recvmsg+0x1a0/0x3e0 net/socket.c:2480
>  do_recvmmsg+0x19a/0x5c0 net/socket.c:2601
>  __sys_recvmmsg+0x1ef/0x200 net/socket.c:2680
>  __do_sys_recvmmsg net/socket.c:2703 [inline]
>  __se_sys_recvmmsg net/socket.c:2696 [inline]
>  __x64_sys_recvmmsg+0x89/0xb0 net/socket.c:2696
>  do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 PID: 10413 Comm: syz-executor.0 Not tainted 5.4.0-rc3+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
>=20
> Fixes: 2276f58ac589 ("udp: use a separate rx queue for packet reception")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/ipv4/udp.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 345a3d43f5a655e009e99c16bb19e047cdf003c6..d1ed160af202c054839387201=
abd3f13b55d00e9 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1316,6 +1316,20 @@ static void udp_set_dev_scratch(struct sk_buff *sk=
b)
>  =09=09scratch->_tsize_state |=3D UDP_SKB_IS_STATELESS;
>  }
> =20
> +static void udp_skb_csum_unnecessary_set(struct sk_buff *skb)
> +{
> +=09/* We come here after udp_lib_checksum_complete() returned 0.
> +=09 * This means that __skb_checksum_complete() might have
> +=09 * set skb->csum_valid to 1.
> +=09 * On 64bit platforms, we can set csum_unnecessary
> +=09 * to true, but only if the skb is not shared.
> +=09 */
> +#if BITS_PER_LONG =3D=3D 64
> +=09if (!skb_shared(skb))
> +=09=09udp_skb_scratch(skb)->csum_unnecessary =3D true;
> +#endif
> +}
> +
>  static int udp_skb_truesize(struct sk_buff *skb)
>  {
>  =09return udp_skb_scratch(skb)->_tsize_state & ~UDP_SKB_IS_STATELESS;
> @@ -1550,10 +1564,7 @@ static struct sk_buff *__first_packet_length(struc=
t sock *sk,
>  =09=09=09*total +=3D skb->truesize;
>  =09=09=09kfree_skb(skb);
>  =09=09} else {
> -=09=09=09/* the csum related bits could be changed, refresh
> -=09=09=09 * the scratch area
> -=09=09=09 */
> -=09=09=09udp_set_dev_scratch(skb);
> +=09=09=09udp_skb_csum_unnecessary_set(skb);
>  =09=09=09break;
>  =09=09}
>  =09}

LGTM, Thanks Eric!

Reviewed-by: Paolo Abeni <pabeni@redhat.com>

