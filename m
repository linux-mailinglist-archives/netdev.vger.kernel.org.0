Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 365DA116689
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 06:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfLIFp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 00:45:59 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:43722 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfLIFp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 00:45:58 -0500
Received: by mail-pj1-f65.google.com with SMTP id g4so5359991pjs.10;
        Sun, 08 Dec 2019 21:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=g33JCzSgSLsniJXoMm0lPSyKRuCxhDLqEg3V8PmS2D4=;
        b=SfJ8UpKNBtcLhXNPUyE+46l0lxQL7JdBzYSdfepxkCWPCTXTSRpuAK7+3wdjgXdXPP
         AjzkbtbDyPNh5TXB3CtVdGa2LgpzHzqgl8qDPZkZNcjhzWPen0OHldCVFJZ+evA9+wZD
         H7yIyRSBJr2ZTgCYZtunu31RYVQCotwLZXy2Caauk34PxGT9rTaSlDkcqLapbadcA1YZ
         aNc2iFJ/nKqQ0+CYRgh5heIh95lkUsfPEGhGRhgnHNTi75iDFr5IHQRi5mv8R1GMBaJQ
         5CLdSAJzfF3SksSkXNLS8FxMUFYFsQ+/0yeC0SEgKDCIj0OVVMG+WTv6nMd88Cy0rYkT
         +e3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=g33JCzSgSLsniJXoMm0lPSyKRuCxhDLqEg3V8PmS2D4=;
        b=tluJ1rZQW/iCQNonm4S8mjJxqBAzldHtmApCksyIcMndm/mqI//8dxpnu8x54JJ403
         81N3HCir/b1gBzukhlWIez4luy7LUW70sSOce2zyntzLDWkiAW4hruWtMmNR/iNZm9Y9
         iTTtKkWDGKMghZRDBaDwHdkz7fLQxCI9JaIatkUtrnbye9ImzW6+YWmG+r1Mk8YJIATP
         qs1A0mjVjGKgGegu97EOCBPrqttwWnX9i91IOBE1mc3VM8k//uxMSzrr1gb6wxRkUvGd
         oJnZWMJpkfG603+RzsjaYEAQJBsh58RoYoSi3FghHMJ2+D0QgY1eUkygxe4VsdEqsS4U
         JZKA==
X-Gm-Message-State: APjAAAXeMGLbpX0IMBF6nuLjnKVVkzHHU7IK+1Q/y64Ny+2shwFYFTCN
        Zeod9zBuxfYNSCXeC1PL6Xf7QP+B
X-Google-Smtp-Source: APXvYqwmfixd4M7Ru2bLkukyMhCJRITYesOLT7mIXWWXFCWPyu6Dwae+XHywu0IegJ8d6MIGmmpWkg==
X-Received: by 2002:a17:90a:b301:: with SMTP id d1mr29659638pjr.20.1575870357631;
        Sun, 08 Dec 2019 21:45:57 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 8sm25755374pfu.21.2019.12.08.21.45.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Dec 2019 21:45:57 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: fully initialize v4 addr in some functions
Date:   Mon,  9 Dec 2019 13:45:54 +0800
Message-Id: <dfabc15c8718ae26d93f4ed1b023baee81eb5c34.1575870354.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot found a crash:

  BUG: KMSAN: uninit-value in crc32_body lib/crc32.c:112 [inline]
  BUG: KMSAN: uninit-value in crc32_le_generic lib/crc32.c:179 [inline]
  BUG: KMSAN: uninit-value in __crc32c_le_base+0x4fa/0xd30 lib/crc32.c:202
  Call Trace:
    crc32_body lib/crc32.c:112 [inline]
    crc32_le_generic lib/crc32.c:179 [inline]
    __crc32c_le_base+0x4fa/0xd30 lib/crc32.c:202
    chksum_update+0xb2/0x110 crypto/crc32c_generic.c:90
    crypto_shash_update+0x4c5/0x530 crypto/shash.c:107
    crc32c+0x150/0x220 lib/libcrc32c.c:47
    sctp_csum_update+0x89/0xa0 include/net/sctp/checksum.h:36
    __skb_checksum+0x1297/0x12a0 net/core/skbuff.c:2640
    sctp_compute_cksum include/net/sctp/checksum.h:59 [inline]
    sctp_packet_pack net/sctp/output.c:528 [inline]
    sctp_packet_transmit+0x40fb/0x4250 net/sctp/output.c:597
    sctp_outq_flush_transports net/sctp/outqueue.c:1146 [inline]
    sctp_outq_flush+0x1823/0x5d80 net/sctp/outqueue.c:1194
    sctp_outq_uncork+0xd0/0xf0 net/sctp/outqueue.c:757
    sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1781 [inline]
    sctp_side_effects net/sctp/sm_sideeffect.c:1184 [inline]
    sctp_do_sm+0x8fe1/0x9720 net/sctp/sm_sideeffect.c:1155
    sctp_primitive_REQUESTHEARTBEAT+0x175/0x1a0 net/sctp/primitive.c:185
    sctp_apply_peer_addr_params+0x212/0x1d40 net/sctp/socket.c:2433
    sctp_setsockopt_peer_addr_params net/sctp/socket.c:2686 [inline]
    sctp_setsockopt+0x189bb/0x19090 net/sctp/socket.c:4672

The issue was caused by transport->ipaddr set with uninit addr param, which
was passed by:

  sctp_transport_init net/sctp/transport.c:47 [inline]
  sctp_transport_new+0x248/0xa00 net/sctp/transport.c:100
  sctp_assoc_add_peer+0x5ba/0x2030 net/sctp/associola.c:611
  sctp_process_param net/sctp/sm_make_chunk.c:2524 [inline]

where 'addr' is set by sctp_v4_from_addr_param(), and it doesn't initialize
the padding of addr->v4.

Later when calling sctp_make_heartbeat(), hbinfo.daddr(=transport->ipaddr)
will become the part of skb, and the issue occurs.

This patch is to fix it by initializing the padding of addr->v4 in
sctp_v4_from_addr_param(), as well as other functions that do the similar
thing, and these functions shouldn't trust that the caller initializes the
memory, as Marcelo suggested.

Reported-by: syzbot+6dcbfea81cd3d4dd0b02@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index fbbf191..78af2fc 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -227,6 +227,7 @@ static void sctp_v4_from_skb(union sctp_addr *addr, struct sk_buff *skb,
 		sa->sin_port = sh->dest;
 		sa->sin_addr.s_addr = ip_hdr(skb)->daddr;
 	}
+	memset(sa->sin_zero, 0, sizeof(sa->sin_zero));
 }
 
 /* Initialize an sctp_addr from a socket. */
@@ -235,6 +236,7 @@ static void sctp_v4_from_sk(union sctp_addr *addr, struct sock *sk)
 	addr->v4.sin_family = AF_INET;
 	addr->v4.sin_port = 0;
 	addr->v4.sin_addr.s_addr = inet_sk(sk)->inet_rcv_saddr;
+	memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
 }
 
 /* Initialize sk->sk_rcv_saddr from sctp_addr. */
@@ -257,6 +259,7 @@ static void sctp_v4_from_addr_param(union sctp_addr *addr,
 	addr->v4.sin_family = AF_INET;
 	addr->v4.sin_port = port;
 	addr->v4.sin_addr.s_addr = param->v4.addr.s_addr;
+	memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
 }
 
 /* Initialize an address parameter from a sctp_addr and return the length
@@ -281,6 +284,7 @@ static void sctp_v4_dst_saddr(union sctp_addr *saddr, struct flowi4 *fl4,
 	saddr->v4.sin_family = AF_INET;
 	saddr->v4.sin_port = port;
 	saddr->v4.sin_addr.s_addr = fl4->saddr;
+	memset(saddr->v4.sin_zero, 0, sizeof(saddr->v4.sin_zero));
 }
 
 /* Compare two addresses exactly. */
@@ -303,6 +307,7 @@ static void sctp_v4_inaddr_any(union sctp_addr *addr, __be16 port)
 	addr->v4.sin_family = AF_INET;
 	addr->v4.sin_addr.s_addr = htonl(INADDR_ANY);
 	addr->v4.sin_port = port;
+	memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
 }
 
 /* Is this a wildcard address? */
-- 
2.1.0

