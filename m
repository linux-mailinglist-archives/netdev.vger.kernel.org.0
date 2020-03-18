Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A4D189C8B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCRNGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:06:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:56272 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726775AbgCRNGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:06:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584536801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ka1gLTJKqMcefNuAj8Jp4rzkqApYStpQB6I5WNUUMAU=;
        b=ChqTnSdv9KFjmeGOSCipua75ZHG+tALyWe9nSjoP8JHwEBFq6F/AcVa2HUm/5l4pppZUxS
        /aHbQA3MZiwINjzXJLlLK48q87PHcrtOi7bf8ypxWJ3ANf8JG7Du1TgjG9Px+ZMY4gycGo
        qA07IHfTUd5/jT/88NFGaAIkpeKYtz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-znNt6VRBNUGkbKYhK1bnnA-1; Wed, 18 Mar 2020 09:06:38 -0400
X-MC-Unique: znNt6VRBNUGkbKYhK1bnnA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AFD875ED1;
        Wed, 18 Mar 2020 13:06:32 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83D9E60BFB;
        Wed, 18 Mar 2020 13:06:30 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com
Subject: [RFC PATCH bpf-next 3/3] selftests/bpf: call bpf_prog_test_run with trace enabled for XDP test
Date:   Wed, 18 Mar 2020 13:06:27 +0000
Message-Id: <158453678749.3043.9870294925481791434.stgit@xdp-tutorial>
In-Reply-To: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a quick and dirty version of bpf_prog_test_run_trace() right
in the xdp.c selftest to demonstrate the new trace functionality.

This is a (too long) example output of the trace functionality:

STACK(32 bytes):
  ffffb82b4081faa8: 0x0000000000000000 0000000000000000 0000000000000000 =
0000000000000000

REGISTERS:
  r00-03: 0x0000000000000000 ffffb82b4081fde8 0000000000000000 0000000000=
000000
  r04-07: 0x0000000000000000 0000000000000000 0000000000000000 0000000000=
000000
  r08-11: 0x0000000000000000 0000000000000000 ffffb82b4081fac8 0000000000=
000000

1[0x0]: (bf) r6 =3D r1
  r6: 0x0000000000000000 -> 0xffffb82b4081fde8
2[0x1]: (b4) w8 =3D 1
  r8: 0x0000000000000000 -> 0x0000000000000001
3[0x2]: (b7) r11 =3D -439116112
  r11: 0x0000000000000000 -> 0xffffffffe5d39eb0
4[0x3]: (67) r11 <<=3D 32
  r11: 0xffffffffe5d39eb0 -> 0xe5d39eb000000000
5[0x4]: (4f) r8 |=3D r11
  r8: 0x0000000000000001 -> 0xe5d39eb000000001
6[0x5]: (79) r2 =3D *(u64 *)(r6 +8)
  r2: 0x0000000000000000 -> 0xffff8fbaec6d3b36
7[0x6]: (79) r1 =3D *(u64 *)(r6 +0)
  r1: 0xffffb82b4081fde8 -> 0xffff8fbaec6d3b00
8[0x7]: (bf) r3 =3D r1
  r3: 0x0000000000000000 -> 0xffff8fbaec6d3b00
9[0x8]: (07) r3 +=3D 14
  r3: 0xffff8fbaec6d3b00 -> 0xffff8fbaec6d3b0e
10[0x9]: (2d) if r3 > r2 goto pc+76
  r3: 0xffff8fbaec6d3b0e <=3D=3D> r2: 0xffff8fbaec6d3b36
  branch was NOT taken
...
...
300[0x152]: (a4) w2 ^=3D -1
  r2: 0x6ec5cf350000934d -> 0x00000000ffff6cb2
301[0x153]: (b7) r11 =3D -412759113
  r11: 0x6ec5cf3500000000 -> 0xffffffffe765cbb7
302[0x154]: (67) r11 <<=3D 32
  r11: 0xffffffffe765cbb7 -> 0xe765cbb700000000
303[0x155]: (4f) r2 |=3D r11
  r2: 0x00000000ffff6cb2 -> 0xe765cbb7ffff6cb2
304[0x156]: (6b) *(u16 *)(r1 +24) =3D r2
  MEM[ffff8fbaec6d3b04]: 0x00 -> 0xb2
305[0x157]: (71) r1 =3D *(u8 *)(r10 -12)
  r1: 0xffff8fbaec6d3aec -> 0x0000000000000006
306[0x158]: (b7) r11 =3D -1438054225
  r11: 0xe765cbb700000000 -> 0xffffffffaa4908af
307[0x159]: (67) r11 <<=3D 32
  r11: 0xffffffffaa4908af -> 0xaa4908af00000000
308[0x15a]: (4f) r1 |=3D r11
  r1: 0x0000000000000006 -> 0xaa4908af00000006
309[0x15b]: (63) *(u32 *)(r10 -4) =3D r1
  MEM[ffffb82b4081fac4]: 0x0000000000000000 -> 0x0000000000000006
310[0x15c]: (bf) r2 =3D r10
  r2: 0xe765cbb7ffff6cb2 -> 0xffffb82b4081fac8
311[0x15d]: (07) r2 +=3D -4
  r2: 0xffffb82b4081fac8 -> 0xffffb82b4081fac4
312[0x15e]: (18) r1 =3D 0xffff8fbaeef8c000
  r1: 0xaa4908af00000006 -> 0xffff8fbaeef8c000
313[0x160]: (85) call percpu_array_map_lookup_elem#164336
  r0: 0x7af818e200000000 -> 0xffffd82b3fbb4048
314[0x161]: (15) if r0 =3D=3D 0x0 goto pc+229
  r0: 0xffffd82b3fbb4048 <=3D=3D> 0x000000
  branch was NOT taken
315[0x162]: (05) goto pc+225
  pc: 0x0000000000000162 -> 0x0000000000000244
  branch was taken
316[0x244]: (79) r1 =3D *(u64 *)(r0 +0)
  r1: 0xffff8fbaeef8c000 -> 0x0000000000000000
317[0x245]: (07) r1 +=3D 1
  r1: 0x0000000000000000 -> 0x0000000000000001
318[0x246]: (7b) *(u64 *)(r0 +0) =3D r1
  MEM[ffffd82b3fbb4048]: 0x00 -> 0x01
319[0x247]: (b4) w8 =3D 3
  r8: 0x14d492f700000045 -> 0x0000000000000003
320[0x248]: (b7) r11 =3D -1474974291
  r11: 0xaa4908af00000000 -> 0xffffffffa815adad
321[0x249]: (67) r11 <<=3D 32
  r11: 0xffffffffa815adad -> 0xa815adad00000000
322[0x24a]: (4f) r8 |=3D r11
  r8: 0x0000000000000003 -> 0xa815adad00000003
323[0x24b]: (05) goto pc-502
  pc: 0x000000000000024b -> 0x0000000000000056
  branch was taken
324[0x56]: (bc) w0 =3D w8
  r0: 0xffffd82b3fbb4048 -> 0x0000000000000003
325[0x57]: (95) exit

STACK(32 bytes):
  ffffb82b4081faa8: 0x0000000000000000 0000000000000000 0000000600020000 =
0000000600000000

REGISTERS:
  r00-03: 0x0000000000000003 0000000000000001 ffffb82b4081fac4 9b5fd9b800=
000000
  r04-07: 0x03f00a9d00000000 2c071e5a00000000 7437bef800000000 ffff8fbaf4=
b5b6f8
  r08-11: 0xa815adad00000003 be1b210e0000934d ffffb82b4081fac8 a815adad00=
000000

RESULT:
  return =3D 0x0000000000000003


Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/xdp.c |   36 ++++++++++++++++++++=
+++++-
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp.c b/tools/testing=
/selftests/bpf/prog_tests/xdp.c
index dcb5ecac778e..8f7a70d39dbf 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp.c
@@ -1,6 +1,38 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
=20
+
+static inline int sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
+			  unsigned int size)
+{
+	return syscall(__NR_bpf, cmd, attr, size);
+}
+
+int bpf_prog_test_run_trace(int prog_fd, int repeat, void *data, __u32 s=
ize,
+			    void *data_out, __u32 *size_out, __u32 *retval,
+			    __u32 *duration)
+{
+	union bpf_attr attr;
+	int ret;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.test.prog_fd =3D prog_fd;
+	attr.test.data_in =3D ptr_to_u64(data);
+	attr.test.data_out =3D ptr_to_u64(data_out);
+	attr.test.data_size_in =3D size;
+	attr.test.repeat =3D repeat;
+	attr.test.flags =3D BPF_F_TEST_ENABLE_TRACE;
+
+	ret =3D sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
+	if (size_out)
+		*size_out =3D attr.test.data_size_out;
+	if (retval)
+		*retval =3D attr.test.retval;
+	if (duration)
+		*duration =3D attr.test.duration;
+	return ret;
+}
+
 void test_xdp(void)
 {
 	struct vip key4 =3D {.protocol =3D 6, .family =3D AF_INET};
@@ -25,7 +57,7 @@ void test_xdp(void)
 	bpf_map_update_elem(map_fd, &key4, &value4, 0);
 	bpf_map_update_elem(map_fd, &key6, &value6, 0);
=20
-	err =3D bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+	err =3D bpf_prog_test_run_trace(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				buf, &size, &retval, &duration);
=20
 	CHECK(err || retval !=3D XDP_TX || size !=3D 74 ||
@@ -33,7 +65,7 @@ void test_xdp(void)
 	      "err %d errno %d retval %d size %d\n",
 	      err, errno, retval, size);
=20
-	err =3D bpf_prog_test_run(prog_fd, 1, &pkt_v6, sizeof(pkt_v6),
+	err =3D bpf_prog_test_run_trace(prog_fd, 1, &pkt_v6, sizeof(pkt_v6),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval !=3D XDP_TX || size !=3D 114 ||
 	      iph6->nexthdr !=3D IPPROTO_IPV6, "ipv6",

