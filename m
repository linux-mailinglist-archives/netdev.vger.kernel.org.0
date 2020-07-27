Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B16522ECEA
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgG0NLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728650AbgG0NLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 09:11:04 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78956C0619D2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:11:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z188so1198193pfc.6
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pesu-pes-edu.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=oo7t1szfhSJG4+lLjDn/55PA1qMXizqbtOUBsQKprnY=;
        b=IKv9ZWNl5oPuF/Hbsm3asfdyP9HaYe/mxICK6RG1SgT3zKAB8sxuQQL1XA8yu6w9Hf
         3Pq/S2N6OUNiVTZ08xBO6q4DLVRRAVoZ5aP9gt9WOjXnnT/CM2iE2UrfCt/DC4tlk7oR
         CfG6rpHa4CGqHzd1LxL+yB/HlTMI/Q1HEBbkKOiVzW5imPXy5wn9GpFwSvBrUoX1g1xG
         B/JswoCbooEL6Gh4E+digCzV7kkJQx2EACZTMIdeUgI0g9GgLJPOVLTU+7PHZ55p8EBx
         1sFah/C5yrzr5WrRhTOYXKBY+2Vv4G093NzoFfUyPEjv4ajGR8UAKc89iZCxyklYygP0
         tLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=oo7t1szfhSJG4+lLjDn/55PA1qMXizqbtOUBsQKprnY=;
        b=b+K1hv9wdvVVKmeQfIl28Y6dWWXpglBWOh1RejlYPCVnI4sJUSt9xVdnkzLmwOYC8B
         zSLBvswqKct5qdTbZmpp6WD5Fi+aF9+JKdDdZjpc4+pklEi7+KCvIKrQnk7W2A6Pril8
         Gq/pdBlNTuGK+xCBa+b1cLYE+ABsxQYmipDPVPsHylRF+Rd/eiPajWPSSo4WWzhkMlrG
         NWybfHOE0l9Po0yjXWFw4qmQaVSxMuZHZuFBIEG0WpEQcVt3J9ptJueUmE4p61rEtR/V
         /A3m88kBk1TlaaB83s1tCoHZl/xmhU8zZ/qQZtBPFHhpD55FBvvgjOlyJYoB4Sq3YrHd
         OM9A==
X-Gm-Message-State: AOAM533/eHR7jgujjm2N34tveltMIyV8yleQ97Ki0HL+VrXeh6SJYAk5
        LxYnSICFVYn4ur+k6/v9ohuHiA==
X-Google-Smtp-Source: ABdhPJw3tmoN5FqHqeiB17jmvdY/CDjzKTGGE7lx1eCIOSPp2h/rfIYEoROrvCmYE6Y+WAOoODGTig==
X-Received: by 2002:a63:aa42:: with SMTP id x2mr19123351pgo.361.1595855462960;
        Mon, 27 Jul 2020 06:11:02 -0700 (PDT)
Received: from localhost ([2406:7400:73:7c93:d1f0:826d:1814:b78e])
        by smtp.gmail.com with ESMTPSA id q5sm15251100pfc.130.2020.07.27.06.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 06:11:01 -0700 (PDT)
Date:   Mon, 27 Jul 2020 18:40:57 +0530
From:   B K Karthik <bkkarthik@pesu.pes.edu>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] net: tipc: fix general protection fault in
 tipc_conn_delete_sub
Message-ID: <20200727131057.7a3of3hhsld4ng5t@pesu.pes.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3oporsfwhg5guuw5"
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3oporsfwhg5guuw5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

fix a general protection fault in tipc_conn_delete_sub
by checking for the existance of con->server.
prevent a null-ptr-deref by returning -EINVAL when
con->server is NULL

general protection fault, probably for non-canonical address 0xdffffc000000=
0014: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000a0-0x00000000000000a7]
CPU: 1 PID: 113 Comm: kworker/u4:3 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 01/01/2011
Workqueue: tipc_send tipc_conn_send_work
RIP: 0010:tipc_conn_delete_sub+0x54/0x440 net/tipc/topsrv.c:231
Code: 48 c1 ea 03 80 3c 02 00 0f 85 f0 03 00 00 48 b8 00 00 00 00 00 fc ff =
df 48 8b 6b 18 48 8d bd a0 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 8=
5 c0 03 00 00 48 c7 c0 34 0b 8a 8a 4c 8b a5 a0 00
RSP: 0018:ffffc900012d7b58 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff8880a8269c00 RCX: ffffffff8789ca01
RDX: 0000000000000014 RSI: ffffffff8789a059 RDI: 00000000000000a0
RBP: 0000000000000000 R08: ffff8880a8d88380 R09: fffffbfff18577a8
R10: fffffbfff18577a7 R11: ffffffff8c2bbd3f R12: dffffc0000000000
R13: ffff888093d35a18 R14: ffff8880a8269c00 R15: ffff888093d35a00
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000076c000 CR3: 000000009441d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tipc_conn_send_to_sock+0x380/0x560 net/tipc/topsrv.c:266
 tipc_conn_send_work+0x6f/0x90 net/tipc/topsrv.c:304
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x388/0x470 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 2c161a84be832606 ]---
RIP: 0010:tipc_conn_delete_sub+0x54/0x440 net/tipc/topsrv.c:231
Code: 48 c1 ea 03 80 3c 02 00 0f 85 f0 03 00 00 48 b8 00 00 00 00 00 fc ff =
df 48 8b 6b 18 48 8d bd a0 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 8=
5 c0 03 00 00 48 c7 c0 34 0b 8a 8a 4c 8b a5 a0 00
RSP: 0018:ffffc900012d7b58 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff8880a8269c00 RCX: ffffffff8789ca01
RDX: 0000000000000014 RSI: ffffffff8789a059 RDI: 00000000000000a0
RBP: 0000000000000000 R08: ffff8880a8d88380 R09: fffffbfff18577a8
R10: fffffbfff18577a7 R11: ffffffff8c2bbd3f R12: dffffc0000000000
R13: ffff888093d35a18 R14: ffff8880a8269c00 R15: ffff888093d35a00
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020800000 CR3: 0000000091b8e000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Reported-and-tested-by: syzbot+55a38037455d0351efd3@syzkaller.appspotmail.c=
om
Signed-off-by: B K Karthik <bkkarthik@pesu.pes.edu>
---
 net/tipc/topsrv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 1489cfb941d8..6c8d0c6bb112 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -255,6 +255,9 @@ static void tipc_conn_send_to_sock(struct tipc_conn *co=
n)
 	int count =3D 0;
 	int ret;
=20
+	if (!con->server)
+		return -EINVAL;
+
 	spin_lock_bh(&con->outqueue_lock);
=20
 	while (!list_empty(queue)) {
--=20
2.20.1


--3oporsfwhg5guuw5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEIF+jd5Z5uS7xKTfpQZdt+T1HgiEFAl8e0mAACgkQQZdt+T1H
giEigQwAmYk+gOwehagBEv8UhqJ1UqlaZSNxIpHfUVZMZjlUmezkFHWoi1cN0S+Z
XmG8taRygB6MDiT4uZQCWVLWDdcNndlwuha/UGWZ4oQ0G/v1J3yDvDQojPgHelhw
XdMk0bKJGg4LdHDQNkpNTUg5mTm2qKJDEUyiNz0aGL25HuVdF4VZEKY/DT8p6h70
fistXiV6ADjEea4YvY1ieJbPCXQoMENeCnMToIjPEdunWCetdLYDp9TCM3NNBpH/
dXw2lAeijrcJVqJnGmxlF8VrGRudYKPDWLZixT4YnWX7Il/5z2fw9GUViODBJqly
+4B0+2920zila3hgLP2EL65+kbz4SdhaPj1mVw0cfF6t8Nfty9eqfiQybZKjnfJp
B5LStWwJxngeHLgk1MUGYu/fsE/EdtkkmSximCPkJnRIw/E6eVwc4F7GwWVc2yxr
aIIgaJwQxnhfuMUIrDSVvvfN37IlYaEFcIb3GLkn6qutUPLCyimr2idkLLu9I1DU
1qFtJL9z
=rv8l
-----END PGP SIGNATURE-----

--3oporsfwhg5guuw5--
