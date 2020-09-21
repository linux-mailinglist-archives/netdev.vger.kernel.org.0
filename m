Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1282B27288A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgIUOoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:44:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727708AbgIUOoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:44:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600699440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iTLgdYwcoOtd3+aRPiNk2TAXvMVG7FyPFzlZfNt4vp4=;
        b=i8SyiOLPuZSdAkYMeo4mJeBPfyraLpHMIMis3cNx+6bjAdUSm9m2SFOSz+oWpIDAmfkuNr
        g2SLRD4l7GAvp5C+LZwD73lVATomS47RWG8W4vKm78TycoIm3YvaxwqoFwph7HYQ31zl21
        mNb5QkgJLlSgqDf5f+O9i7gmHsQL0Ag=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-Zcqt39AqOr-kfalZEhla8A-1; Mon, 21 Sep 2020 10:43:58 -0400
X-MC-Unique: Zcqt39AqOr-kfalZEhla8A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A854E10082E6;
        Mon, 21 Sep 2020 14:43:56 +0000 (UTC)
Received: from ovpn-114-83.ams2.redhat.com (ovpn-114-83.ams2.redhat.com [10.36.114.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D996119744;
        Mon, 21 Sep 2020 14:43:54 +0000 (UTC)
Message-ID: <4ebf5db8d182c68875961d9a03b83411ab05dc72.camel@redhat.com>
Subject: Re: [PATCH net] inet_diag: validate INET_DIAG_REQ_PROTOCOL attribute
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Date:   Mon, 21 Sep 2020 16:43:53 +0200
In-Reply-To: <20200921142720.2328827-1-edumazet@google.com>
References: <20200921142720.2328827-1-edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-21 at 07:27 -0700, Eric Dumazet wrote:
> User space could send an invalid INET_DIAG_REQ_PROTOCOL attribute
> as caught by syzbot.
> 
> BUG: KMSAN: uninit-value in inet_diag_lock_handler
> net/ipv4/inet_diag.c:55 [inline]
> BUG: KMSAN: uninit-value in __inet_diag_dump+0x58c/0x720
> net/ipv4/inet_diag.c:1147
> CPU: 0 PID: 8505 Comm: syz-executor174 Not tainted 5.9.0-rc4-
> syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x21c/0x280 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:122
>  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:219
>  inet_diag_lock_handler net/ipv4/inet_diag.c:55 [inline]
>  __inet_diag_dump+0x58c/0x720 net/ipv4/inet_diag.c:1147
>  inet_diag_dump_compat+0x2a5/0x380 net/ipv4/inet_diag.c:1254
>  netlink_dump+0xb73/0x1cb0 net/netlink/af_netlink.c:2246
>  __netlink_dump_start+0xcf2/0xea0 net/netlink/af_netlink.c:2354
>  netlink_dump_start include/linux/netlink.h:246 [inline]
>  inet_diag_rcv_msg_compat+0x5da/0x6c0 net/ipv4/inet_diag.c:1288
>  sock_diag_rcv_msg+0x24f/0x620 net/core/sock_diag.c:256
>  netlink_rcv_skb+0x6d7/0x7e0 net/netlink/af_netlink.c:2470
>  sock_diag_rcv+0x63/0x80 net/core/sock_diag.c:275
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x11c8/0x1490 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x173a/0x1840 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg net/socket.c:671 [inline]
>  ____sys_sendmsg+0xc82/0x1240 net/socket.c:2353
>  ___sys_sendmsg net/socket.c:2407 [inline]
>  __sys_sendmsg+0x6d1/0x820 net/socket.c:2440
>  __do_sys_sendmsg net/socket.c:2449 [inline]
>  __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
>  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x441389
> Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48>
> 3d 01 f0 ff ff 0f 83 1b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fff3b02ce98 EFLAGS: 00000246 ORIG_RAX:
> 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441389
> RDX: 0000000000000000 RSI: 0000000020001500 RDI: 0000000000000003
> RBP: 00000000006cb018 R08: 00000000004002c8 R09: 00000000004002c8
> R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402130
> R13: 00000000004021c0 R14: 0000000000000000 R15: 0000000000000000
> 
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:143 [inline]
>  kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:126
>  kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
>  slab_alloc_node mm/slub.c:2907 [inline]
>  __kmalloc_node_track_caller+0x9aa/0x12f0 mm/slub.c:4511
>  __kmalloc_reserve net/core/skbuff.c:142 [inline]
>  __alloc_skb+0x35f/0xb30 net/core/skbuff.c:210
>  alloc_skb include/linux/skbuff.h:1094 [inline]
>  netlink_alloc_large_skb net/netlink/af_netlink.c:1176 [inline]
>  netlink_sendmsg+0xdb9/0x1840 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg net/socket.c:671 [inline]
>  ____sys_sendmsg+0xc82/0x1240 net/socket.c:2353
>  ___sys_sendmsg net/socket.c:2407 [inline]
>  __sys_sendmsg+0x6d1/0x820 net/socket.c:2440
>  __do_sys_sendmsg net/socket.c:2449 [inline]
>  __se_sys_sendmsg+0x97/0xb0 net/socket.c:2447
>  __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2447
>  do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fixes: 3f935c75eb52 ("inet_diag: support for wider protocol numbers")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Christoph Paasch <cpaasch@apple.com>
> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  net/ipv4/inet_diag.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index
> 4a98dd7362702c32620638227c19bf986551d792..f1bd95f243b3065b705b0e5ccff
> 3acbc5cd21127 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -186,8 +186,8 @@ int inet_diag_msg_attrs_fill(struct sock *sk,
> struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL_GPL(inet_diag_msg_attrs_fill);
>  
> -static void inet_diag_parse_attrs(const struct nlmsghdr *nlh, int
> hdrlen,
> -				  struct nlattr **req_nlas)
> +static int inet_diag_parse_attrs(const struct nlmsghdr *nlh, int
> hdrlen,
> +				 struct nlattr **req_nlas)
>  {
>  	struct nlattr *nla;
>  	int remaining;
> @@ -195,9 +195,13 @@ static void inet_diag_parse_attrs(const struct
> nlmsghdr *nlh, int hdrlen,
>  	nlmsg_for_each_attr(nla, nlh, hdrlen, remaining) {
>  		int type = nla_type(nla);
>  
> +		if (type == INET_DIAG_REQ_PROTOCOL && nla_len(nla) !=
> sizeof(u32))
> +			return -EINVAL;
> +
>  		if (type < __INET_DIAG_REQ_MAX)
>  			req_nlas[type] = nla;
>  	}
> +	return 0;
>  }
>  
>  static int inet_diag_get_protocol(const struct inet_diag_req_v2
> *req,
> @@ -574,7 +578,10 @@ static int inet_diag_cmd_exact(int cmd, struct
> sk_buff *in_skb,
>  	int err, protocol;
>  
>  	memset(&dump_data, 0, sizeof(dump_data));
> -	inet_diag_parse_attrs(nlh, hdrlen, dump_data.req_nlas);
> +	err = inet_diag_parse_attrs(nlh, hdrlen, dump_data.req_nlas);
> +	if (err)
> +		return err;
> +
>  	protocol = inet_diag_get_protocol(req, &dump_data);
>  
>  	handler = inet_diag_lock_handler(protocol);
> @@ -1180,8 +1187,11 @@ static int __inet_diag_dump_start(struct
> netlink_callback *cb, int hdrlen)
>  	if (!cb_data)
>  		return -ENOMEM;
>  
> -	inet_diag_parse_attrs(nlh, hdrlen, cb_data->req_nlas);
> -
> +	err = inet_diag_parse_attrs(nlh, hdrlen, cb_data->req_nlas);
> +	if (err) {
> +		kfree(cb_data);
> +		return err;
> +	}
>  	nla = cb_data->inet_diag_nla_bc;
>  	if (nla) {
>  		err = inet_diag_bc_audit(nla, skb);

Thanks Eric, LGTM!

Acked-by: Paolo Abeni <pabeni@redhat.com>

