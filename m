Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7E0E9F62
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfJ3Pnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:43:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55564 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727519AbfJ3Pnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572450210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gdd9cCjAtlepKq87OMAJm91YGZlanwB5qxkXhBSjz/M=;
        b=FH8osFtrCaKvqbUM2e4nvfGOsy17rxgVklmL30hhzvKBBomFZ+kSrkmQwS5MUVMadsI00v
        w4ctVrktpIfGsCqv+bODxWi+IjJp1DBn5CqKcWcMy7ihkIneHyL9VkHEoyRoJ2R0BEaJ/h
        FB8Uw6Bj0D/V/VQb20QFOkNnoAAvn3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-VclQOFIiOK-GfgwiohyncQ-1; Wed, 30 Oct 2019 11:43:27 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03192800EB5;
        Wed, 30 Oct 2019 15:43:26 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6E886619A9;
        Wed, 30 Oct 2019 15:43:24 +0000 (UTC)
Date:   Wed, 30 Oct 2019 16:43:23 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [BUG] bpf:
Message-ID: <20191030154323.GJ20826@krava>
MIME-Version: 1.0
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: VclQOFIiOK-GfgwiohyncQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


hi,
I'm getting oops when running the kfree_skb test:

dell-r440-01 login: [  758.049877] BUG: kernel NULL pointer dereference, ad=
dress: 0000000000000000^M
[  758.056834] #PF: supervisor read access in kernel mode^M
[  758.061975] #PF: error_code(0x0000) - not-present page^M
[  758.067112] PGD 8000000befba8067 P4D 8000000befba8067 PUD bffe11067 PMD =
0 ^M
[  758.073987] Oops: 0000 [#1] SMP PTI^M
[  758.077478] CPU: 16 PID: 6854 Comm: test_progs Not tainted 5.4.0-rc3+ #9=
6^M
[  758.084263] Hardware name: Dell Inc. PowerEdge R440/08CYF7, BIOS 1.7.0 1=
2/14/2018^M
[  758.091745] RIP: 0010:0xffffffffc03b672c^M
[  758.095669] Code: 4c 8b 6a 00 4c 89 6d c0 8b 77 00 89 75 cc 31 ff 89 75 =
fc 48 8b 71 00 48 01 fe bf 78 00 00 00 48 89 da 48 01 fa bf 08 00 00 00 <4c=
> 8b 76 00 4c 89 f6 48 01 fe 4c 8b 7e 00 48 89 ef 48 83 c7 f9 be^M
[  758.114414] RSP: 0018:ffffaa3287583d20 EFLAGS: 00010286^M
[  758.119640] RAX: ffffffffc03b66ac RBX: ffff9cef028c3900 RCX: ffff9cef0a6=
52018^M
[  758.126775] RDX: ffff9cef028c3978 RSI: 0000000000000000 RDI: 00000000000=
00008^M
[  758.133906] RBP: ffffaa3287583d90 R08: 00000000000000b0 R09: 00000000000=
00000^M
[  758.141040] R10: 98ff036c00000000 R11: 0000000000000040 R12: ffffffffba8=
b5c37^M
[  758.148170] R13: ffff9cfb05daf440 R14: 0000000000000000 R15: 00000000000=
0004a^M
[  758.155303] FS:  00007f08a18d3740(0000) GS:ffff9cef10c00000(0000) knlGS:=
0000000000000000^M
[  758.163392] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
[  758.169136] CR2: 0000000000000000 CR3: 0000000c08e50001 CR4: 00000000007=
606e0^M
[  758.176268] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000^M
[  758.183401] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400^M
[  758.190534] PKRU: 55555554^M
[  758.193248] Call Trace:^M
[  758.195704]  ? bpf_test_run+0x13d/0x230^M
[  758.199539]  ? _cond_resched+0x15/0x30^M
[  758.203304]  bpf_trace_run2+0x37/0x90^M
[  758.206967]  ? bpf_prog_test_run_skb+0x337/0x450^M
[  758.211589]  kfree_skb+0x73/0xa0^M
[  758.214820]  bpf_prog_test_run_skb+0x337/0x450^M
[  758.219293]  __do_sys_bpf+0x82e/0x1730^M
[  758.223043]  ? ep_show_fdinfo+0x80/0x80^M
[  758.226885]  do_syscall_64+0x5b/0x180^M
[  758.230550]  entry_SYSCALL_64_after_hwframe+0x44/0xa9^M
[  758.235620] RIP: 0033:0x7f08a19e91fd^M
[  758.239198] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 5b 8c 0c 00 f7 d8 64 89 01 48^M


this seems to be the culprit:

; ptr =3D dev->ifalias->rcuhead.next;
  80:   mov    0x0(%rsi),%r14

I used the patch below to bypass the crash, but I guess
verifier should not let this through

also the net_device struct in the test seems outdated

thanks,
jirka


---
 tools/testing/selftests/bpf/progs/kfree_skb.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/=
selftests/bpf/progs/kfree_skb.c
index 89af8a921ee4..64d8c0237186 100644
--- a/tools/testing/selftests/bpf/progs/kfree_skb.c
+++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
@@ -3,6 +3,7 @@
 #include <linux/bpf.h>
 #include "bpf_helpers.h"
 #include "bpf_endian.h"
+#include "bpf_core_read.h"
=20
 char _license[] SEC("license") =3D "GPL";
 struct {
@@ -70,14 +71,12 @@ int trace_kfree_skb(struct trace_kfree_skb *ctx)
 =09unsigned short pkt_data;
 =09char pkt_type;
=20
-=09__builtin_preserve_access_index(({
-=09=09users =3D skb->users.refs.counter;
-=09=09data =3D skb->data;
-=09=09dev =3D skb->dev;
-=09=09ifindex =3D dev->ifindex;
-=09=09ptr =3D dev->ifalias->rcuhead.next;
-=09=09func =3D ptr->func;
-=09}));
+=09users   =3D BPF_CORE_READ(skb, users.refs.counter);
+=09data    =3D BPF_CORE_READ(skb, data);
+=09dev     =3D BPF_CORE_READ(skb, dev);
+=09ifindex =3D BPF_CORE_READ(dev, ifindex);
+=09ptr     =3D BPF_CORE_READ(dev, ifalias, rcuhead.next);
+=09func    =3D BPF_CORE_READ(ptr, func);
=20
 =09bpf_probe_read(&pkt_type, sizeof(pkt_type), _(&skb->__pkt_type_offset))=
;
 =09pkt_type &=3D 7;
--=20
2.21.0

