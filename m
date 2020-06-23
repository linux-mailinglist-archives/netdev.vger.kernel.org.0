Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34392047ED
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731929AbgFWDWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:22:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30570 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731701AbgFWDWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:22:48 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N3EZvp012272
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 20:22:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=tqGsdLNXtJyLkdBFAmWdL6JJXmq/BHagEJHftswph4E=;
 b=AzZrtMVBw/sOJ47/UDcH6YnY06C0A5xyiRImcDLzXl9+LK3D8GpPu8oKqIauDi+Zs5jJ
 rJUF3VGo1KOH+X9K4yRix7b/ya52RIGWsF+GF6pZ52NrZRRFkPnaU4LYikZprtRIeSzp
 yZvzhBBwt/b3BoNhg11+YqaFdzz56iQhd8E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31sg6sbkrc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 20:22:30 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Jun 2020 20:22:27 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 50B882EC33D1; Mon, 22 Jun 2020 20:22:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/3] bpf: switch most helper return values from 32-bit int to 64-bit long
Date:   Mon, 22 Jun 2020 20:22:21 -0700
Message-ID: <20200623032224.4020118-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_16:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501 suspectscore=8
 impostorscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230024
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch most of BPF helper definitions from returning int to long. These
definitions are coming from comments in BPF UAPI header and are used to
generate bpf_helper_defs.h (under libbpf) to be later included and used f=
rom
BPF programs.

In actual in-kernel implementation, all the helpers are defined as return=
ing
u64, but due to some historical reasons, most of them are actually define=
d as
returning int in UAPI (usually, to return 0 on success, and negative valu=
e on
error).

This actually causes Clang to quite often generate sub-optimal code, beca=
use
compiler believes that return value is 32-bit, and in a lot of cases has =
to be
up-converted (usually with a pair of 32-bit bit shifts) to 64-bit values,
before they can be used further in BPF code.

Besides just "polluting" the code, these 32-bit shifts quite often cause
problems for cases in which return value matters. This is especially the =
case
for the family of bpf_probe_read_str() functions. There are few other sim=
ilar
helpers (e.g., bpf_read_branch_records()), in which return value is used =
by
BPF program logic to record variable-length data and process it. For such
cases, BPF program logic carefully manages offsets within some array or m=
ap to
read variable-length data. For such uses, it's crucial for BPF verifier t=
o
track possible range of register values to prove that all the accesses ha=
ppen
within given memory bounds. Those extraneous zero-extending bit shifts,
inserted by Clang (and quite often interleaved with other code, which mak=
es
the issues even more challenging and sometimes requires employing extra
per-variable compiler barriers), throws off verifier logic and makes it m=
ark
registers as having unknown variable offset. We'll study this pattern a b=
it
later below.

Another common pattern is to check return of BPF helper for non-zero stat=
e to
detect error conditions and attempt alternative actions in such case. Eve=
n in
this simple and straightforward case, this 32-bit vs BPF's native 64-bit =
mode
quite often leads to sub-optimal and unnecessary extra code. We'll look a=
t
this pattern as well.

Clang's BPF target supports two modes of code generation: ALU32, in which=
 it
is capable of using lower 32-bit parts of registers, and no-ALU32, in whi=
ch
only full 64-bit registers are being used. ALU32 mode somewhat mitigates =
the
above described problems, but not in all cases.

This patch switches all the cases in which BPF helpers return 0 or negati=
ve
error from returning int to returning long. It is shown below that such c=
hange
in definition leads to equivalent or better code. No-ALU32 mode benefits =
more,
but ALU32 mode doesn't degrade or still gets improved code generation.

Another class of cases switched from int to long are bpf_probe_read_str()=
-like
helpers, which encode successful case as non-negative values, while still
returning negative value for errors.

In all of such cases, correctness is preserved due to two's complement
encoding of negative values and the fact that all helpers return values w=
ith
32-bit absolute value. Two's complement ensures that for negative values
higher 32 bits are all ones and when truncated, leave valid negative 32-b=
it
value with the same value. Non-negative values have upper 32 bits set to =
zero
and similarly preserve value when high 32 bits are truncated. This means =
that
just casting to int/u32 is correct and efficient (and in ALU32 mode doesn=
't
require any extra shifts).

To minimize the chances of regressions, two code patterns were investigat=
ed,
as mentioned above. For both patterns, BPF assembly was analyzed in
ALU32/NO-ALU32 compiler modes, both with current 32-bit int return type a=
nd
new 64-bit long return type.

Case 1. Variable-length data reading and concatenation. This is quite
ubiquitous pattern in tracing/monitoring applications, reading data like
process's environment variables, file path, etc. In such case, many piece=
s of
string-like variable-length data are read into a single big buffer, and a=
t the
end of the process, only a part of array containing actual data is sent t=
o
user-space for further processing. This case is tested in test_varlen.c
selftest (in the next patch). Code flow is roughly as follows:

  void *payload =3D &sample->payload;
  u64 len;

  len =3D bpf_probe_read_kernel_str(payload, MAX_SZ1, &source_data1);
  if (len <=3D MAX_SZ1) {
      payload +=3D len;
      sample->len1 =3D len;
  }
  len =3D bpf_probe_read_kernel_str(payload, MAX_SZ2, &source_data2);
  if (len <=3D MAX_SZ2) {
      payload +=3D len;
      sample->len2 =3D len;
  }
  /* and so on */
  sample->total_len =3D payload - &sample->payload;
  /* send over, e.g., perf buffer */

There could be two variations with slightly different code generated: whe=
n len
is 64-bit integer and when it is 32-bit integer. Both variations were ana=
lysed.
BPF assembly instructions between two successive invocations of
bpf_probe_read_kernel_str() were used to check code regressions. Results =
are
below, followed by short analysis. Left side is using helpers with int re=
turn
type, the right one is after the switch to long.

ALU32 + INT                                ALU32 + LONG
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                                =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

64-BIT (13 insns):                         64-BIT (10 insns):
------------------------------------       ------------------------------=
------
  17:   call 115                             17:   call 115
  18:   if w0 > 256 goto +9 <LBB0_4>         18:   if r0 > 256 goto +6 <L=
BB0_4>
  19:   w1 =3D w0                              19:   r1 =3D 0 ll
  20:   r1 <<=3D 32                            21:   *(u64 *)(r1 + 0) =3D=
 r0
  21:   r1 s>>=3D 32                           22:   r6 =3D 0 ll
  22:   r2 =3D 0 ll                            24:   r6 +=3D r0
  24:   *(u64 *)(r2 + 0) =3D r1              00000000000000c8 <LBB0_4>:
  25:   r6 =3D 0 ll                            25:   r1 =3D r6
  27:   r6 +=3D r1                             26:   w2 =3D 256
00000000000000e0 <LBB0_4>:                   27:   r3 =3D 0 ll
  28:   r1 =3D r6                              29:   call 115
  29:   w2 =3D 256
  30:   r3 =3D 0 ll
  32:   call 115

32-BIT (11 insns):                         32-BIT (12 insns):
------------------------------------       ------------------------------=
------
  17:   call 115                             17:   call 115
  18:   if w0 > 256 goto +7 <LBB1_4>         18:   if w0 > 256 goto +8 <L=
BB1_4>
  19:   r1 =3D 0 ll                            19:   r1 =3D 0 ll
  21:   *(u32 *)(r1 + 0) =3D r0                21:   *(u32 *)(r1 + 0) =3D=
 r0
  22:   w1 =3D w0                              22:   r0 <<=3D 32
  23:   r6 =3D 0 ll                            23:   r0 >>=3D 32
  25:   r6 +=3D r1                             24:   r6 =3D 0 ll
00000000000000d0 <LBB1_4>:                   26:   r6 +=3D r0
  26:   r1 =3D r6                            00000000000000d8 <LBB1_4>:
  27:   w2 =3D 256                             27:   r1 =3D r6
  28:   r3 =3D 0 ll                            28:   w2 =3D 256
  30:   call 115                             29:   r3 =3D 0 ll
                                             31:   call 115

In ALU32 mode, the variant using 64-bit length variable clearly wins and
avoids unnecessary zero-extension bit shifts. In practice, this is even m=
ore
important and good, because BPF code won't need to do extra checks to "pr=
ove"
that payload/len are within good bounds.

32-bit len is one instruction longer. Clang decided to do 64-to-32 castin=
g
with two bit shifts, instead of equivalent `w1 =3D w0` assignment. The fo=
rmer
uses extra register. The latter might potentially lose some range informa=
tion,
but not for 32-bit value. So in this case, verifier infers that r0 is [0,=
 256]
after check at 18:, and shifting 32 bits left/right keeps that range inta=
ct.
We should probably look into Clang's logic and see why it chooses bitshif=
ts
over sub-register assignments for this.

NO-ALU32 + INT                             NO-ALU32 + LONG
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                             =3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

64-BIT (14 insns):                         64-BIT (10 insns):
------------------------------------       ------------------------------=
------
  17:   call 115                             17:   call 115
  18:   r0 <<=3D 32                            18:   if r0 > 256 goto +6 =
<LBB0_4>
  19:   r1 =3D r0                              19:   r1 =3D 0 ll
  20:   r1 >>=3D 32                            21:   *(u64 *)(r1 + 0) =3D=
 r0
  21:   if r1 > 256 goto +7 <LBB0_4>         22:   r6 =3D 0 ll
  22:   r0 s>>=3D 32                           24:   r6 +=3D r0
  23:   r1 =3D 0 ll                          00000000000000c8 <LBB0_4>:
  25:   *(u64 *)(r1 + 0) =3D r0                25:   r1 =3D r6
  26:   r6 =3D 0 ll                            26:   r2 =3D 256
  28:   r6 +=3D r0                             27:   r3 =3D 0 ll
00000000000000e8 <LBB0_4>:                   29:   call 115
  29:   r1 =3D r6
  30:   r2 =3D 256
  31:   r3 =3D 0 ll
  33:   call 115

32-BIT (13 insns):                         32-BIT (13 insns):
------------------------------------       ------------------------------=
------
  17:   call 115                             17:   call 115
  18:   r1 =3D r0                              18:   r1 =3D r0
  19:   r1 <<=3D 32                            19:   r1 <<=3D 32
  20:   r1 >>=3D 32                            20:   r1 >>=3D 32
  21:   if r1 > 256 goto +6 <LBB1_4>         21:   if r1 > 256 goto +6 <L=
BB1_4>
  22:   r2 =3D 0 ll                            22:   r2 =3D 0 ll
  24:   *(u32 *)(r2 + 0) =3D r0                24:   *(u32 *)(r2 + 0) =3D=
 r0
  25:   r6 =3D 0 ll                            25:   r6 =3D 0 ll
  27:   r6 +=3D r1                             27:   r6 +=3D r1
00000000000000e0 <LBB1_4>:                 00000000000000e0 <LBB1_4>:
  28:   r1 =3D r6                              28:   r1 =3D r6
  29:   r2 =3D 256                             29:   r2 =3D 256
  30:   r3 =3D 0 ll                            30:   r3 =3D 0 ll
  32:   call 115                             32:   call 115

In NO-ALU32 mode, for the case of 64-bit len variable, Clang generates mu=
ch
superior code, as expected, eliminating unnecessary bit shifts. For 32-bi=
t
len, code is identical.

So overall, only ALU-32 32-bit len case is more-or-less equivalent and th=
e
difference stems from internal Clang decision, rather than compiler lacki=
ng
enough information about types.

Case 2. Let's look at the simpler case of checking return result of BPF h=
elper
for errors. The code is very simple:

  long bla;
  if (bpf_probe_read_kenerl(&bla, sizeof(bla), 0))
      return 1;
  else
      return 0;

ALU32 + CHECK (9 insns)                    ALU32 + CHECK (9 insns)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  0:    r1 =3D r10                             0:    r1 =3D r10
  1:    r1 +=3D -8                             1:    r1 +=3D -8
  2:    w2 =3D 8                               2:    w2 =3D 8
  3:    r3 =3D 0                               3:    r3 =3D 0
  4:    call 113                             4:    call 113
  5:    w1 =3D w0                              5:    r1 =3D r0
  6:    w0 =3D 1                               6:    w0 =3D 1
  7:    if w1 !=3D 0 goto +1 <LBB2_2>          7:    if r1 !=3D 0 goto +1=
 <LBB2_2>
  8:    w0 =3D 0                               8:    w0 =3D 0
0000000000000048 <LBB2_2>:                 0000000000000048 <LBB2_2>:
  9:    exit                                 9:    exit

Almost identical code, the only difference is the use of full register
assignment (r1 =3D r0) vs half-registers (w1 =3D w0) in instruction #5. O=
n 32-bit
architectures, new BPF assembly might be slightly less optimal, in theory=
. But
one can argue that's not a big issue, given that use of full registers is
still prevalent (e.g., for parameter passing).

NO-ALU32 + CHECK (11 insns)                NO-ALU32 + CHECK (9 insns)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D       =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  0:    r1 =3D r10                             0:    r1 =3D r10
  1:    r1 +=3D -8                             1:    r1 +=3D -8
  2:    r2 =3D 8                               2:    r2 =3D 8
  3:    r3 =3D 0                               3:    r3 =3D 0
  4:    call 113                             4:    call 113
  5:    r1 =3D r0                              5:    r1 =3D r0
  6:    r1 <<=3D 32                            6:    r0 =3D 1
  7:    r1 >>=3D 32                            7:    if r1 !=3D 0 goto +1=
 <LBB2_2>
  8:    r0 =3D 1                               8:    r0 =3D 0
  9:    if r1 !=3D 0 goto +1 <LBB2_2>        0000000000000048 <LBB2_2>:
 10:    r0 =3D 0                               9:    exit
0000000000000058 <LBB2_2>:
 11:    exit

NO-ALU32 is a clear improvement, getting rid of unnecessary zero-extensio=
n bit
shifts.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/uapi/linux/bpf.h       | 192 ++++++++++++++++-----------------
 tools/include/uapi/linux/bpf.h | 192 ++++++++++++++++-----------------
 2 files changed, 192 insertions(+), 192 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 19684813faae..be0efee49093 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -653,7 +653,7 @@ union bpf_attr {
  * 		Map value associated to *key*, or **NULL** if no entry was
  * 		found.
  *
- * int bpf_map_update_elem(struct bpf_map *map, const void *key, const v=
oid *value, u64 flags)
+ * long bpf_map_update_elem(struct bpf_map *map, const void *key, const =
void *value, u64 flags)
  * 	Description
  * 		Add or update the value of the entry associated to *key* in
  * 		*map* with *value*. *flags* is one of:
@@ -671,13 +671,13 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_map_delete_elem(struct bpf_map *map, const void *key)
+ * long bpf_map_delete_elem(struct bpf_map *map, const void *key)
  * 	Description
  * 		Delete entry with *key* from *map*.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read(void *dst, u32 size, const void *unsafe_ptr)
+ * long bpf_probe_read(void *dst, u32 size, const void *unsafe_ptr)
  * 	Description
  * 		For tracing programs, safely attempt to read *size* bytes from
  * 		kernel space address *unsafe_ptr* and store the data in *dst*.
@@ -695,7 +695,7 @@ union bpf_attr {
  * 	Return
  * 		Current *ktime*.
  *
- * int bpf_trace_printk(const char *fmt, u32 fmt_size, ...)
+ * long bpf_trace_printk(const char *fmt, u32 fmt_size, ...)
  * 	Description
  * 		This helper is a "printk()-like" facility for debugging. It
  * 		prints a message defined by format *fmt* (of size *fmt_size*)
@@ -775,7 +775,7 @@ union bpf_attr {
  * 	Return
  * 		The SMP id of the processor running the program.
  *
- * int bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *=
from, u32 len, u64 flags)
+ * long bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void =
*from, u32 len, u64 flags)
  * 	Description
  * 		Store *len* bytes from address *from* into the packet
  * 		associated to *skb*, at *offset*. *flags* are a combination of
@@ -792,7 +792,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_l3_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u6=
4 to, u64 size)
+ * long bpf_l3_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u=
64 to, u64 size)
  * 	Description
  * 		Recompute the layer 3 (e.g. IP) checksum for the packet
  * 		associated to *skb*. Computation is incremental, so the helper
@@ -817,7 +817,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_l4_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u6=
4 to, u64 flags)
+ * long bpf_l4_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u=
64 to, u64 flags)
  * 	Description
  * 		Recompute the layer 4 (e.g. TCP, UDP or ICMP) checksum for the
  * 		packet associated to *skb*. Computation is incremental, so the
@@ -849,7 +849,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_tail_call(void *ctx, struct bpf_map *prog_array_map, u32 inde=
x)
+ * long bpf_tail_call(void *ctx, struct bpf_map *prog_array_map, u32 ind=
ex)
  * 	Description
  * 		This special helper is used to trigger a "tail call", or in
  * 		other words, to jump into another eBPF program. The same stack
@@ -880,7 +880,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_clone_redirect(struct sk_buff *skb, u32 ifindex, u64 flags)
+ * long bpf_clone_redirect(struct sk_buff *skb, u32 ifindex, u64 flags)
  * 	Description
  * 		Clone and redirect the packet associated to *skb* to another
  * 		net device of index *ifindex*. Both ingress and egress
@@ -916,7 +916,7 @@ union bpf_attr {
  * 		A 64-bit integer containing the current GID and UID, and
  * 		created as such: *current_gid* **<< 32 \|** *current_uid*.
  *
- * int bpf_get_current_comm(void *buf, u32 size_of_buf)
+ * long bpf_get_current_comm(void *buf, u32 size_of_buf)
  * 	Description
  * 		Copy the **comm** attribute of the current task into *buf* of
  * 		*size_of_buf*. The **comm** attribute contains the name of
@@ -953,7 +953,7 @@ union bpf_attr {
  * 	Return
  * 		The classid, or 0 for the default unconfigured classid.
  *
- * int bpf_skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vla=
n_tci)
+ * long bpf_skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vl=
an_tci)
  * 	Description
  * 		Push a *vlan_tci* (VLAN tag control information) of protocol
  * 		*vlan_proto* to the packet associated to *skb*, then update
@@ -969,7 +969,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_vlan_pop(struct sk_buff *skb)
+ * long bpf_skb_vlan_pop(struct sk_buff *skb)
  * 	Description
  * 		Pop a VLAN header from the packet associated to *skb*.
  *
@@ -981,7 +981,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_get_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_key=
 *key, u32 size, u64 flags)
+ * long bpf_skb_get_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_ke=
y *key, u32 size, u64 flags)
  * 	Description
  * 		Get tunnel metadata. This helper takes a pointer *key* to an
  * 		empty **struct bpf_tunnel_key** of **size**, that will be
@@ -1032,7 +1032,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_set_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_key=
 *key, u32 size, u64 flags)
+ * long bpf_skb_set_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_ke=
y *key, u32 size, u64 flags)
  * 	Description
  * 		Populate tunnel metadata for packet associated to *skb.* The
  * 		tunnel metadata is set to the contents of *key*, of *size*. The
@@ -1098,7 +1098,7 @@ union bpf_attr {
  * 		The value of the perf event counter read from the map, or a
  * 		negative error code in case of failure.
  *
- * int bpf_redirect(u32 ifindex, u64 flags)
+ * long bpf_redirect(u32 ifindex, u64 flags)
  * 	Description
  * 		Redirect the packet to another net device of index *ifindex*.
  * 		This helper is somewhat similar to **bpf_clone_redirect**\
@@ -1145,7 +1145,7 @@ union bpf_attr {
  * 		The realm of the route for the packet associated to *skb*, or 0
  * 		if none was found.
  *
- * int bpf_perf_event_output(void *ctx, struct bpf_map *map, u64 flags, =
void *data, u64 size)
+ * long bpf_perf_event_output(void *ctx, struct bpf_map *map, u64 flags,=
 void *data, u64 size)
  * 	Description
  * 		Write raw *data* blob into a special BPF perf event held by
  * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -1190,7 +1190,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_load_bytes(const void *skb, u32 offset, void *to, u32 len=
)
+ * long bpf_skb_load_bytes(const void *skb, u32 offset, void *to, u32 le=
n)
  * 	Description
  * 		This helper was provided as an easy way to load data from a
  * 		packet. It can be used to load *len* bytes from *offset* from
@@ -1207,7 +1207,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stackid(void *ctx, struct bpf_map *map, u64 flags)
+ * long bpf_get_stackid(void *ctx, struct bpf_map *map, u64 flags)
  * 	Description
  * 		Walk a user or a kernel stack and return its id. To achieve
  * 		this, the helper needs *ctx*, which is a pointer to the context
@@ -1276,7 +1276,7 @@ union bpf_attr {
  * 		The checksum result, or a negative error code in case of
  * 		failure.
  *
- * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
+ * long bpf_skb_get_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
  * 	Description
  * 		Retrieve tunnel options metadata for the packet associated to
  * 		*skb*, and store the raw tunnel option data to the buffer *opt*
@@ -1294,7 +1294,7 @@ union bpf_attr {
  * 	Return
  * 		The size of the option data retrieved.
  *
- * int bpf_skb_set_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
+ * long bpf_skb_set_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
  * 	Description
  * 		Set tunnel options metadata for the packet associated to *skb*
  * 		to the option data contained in the raw buffer *opt* of *size*.
@@ -1304,7 +1304,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_change_proto(struct sk_buff *skb, __be16 proto, u64 flags=
)
+ * long bpf_skb_change_proto(struct sk_buff *skb, __be16 proto, u64 flag=
s)
  * 	Description
  * 		Change the protocol of the *skb* to *proto*. Currently
  * 		supported are transition from IPv4 to IPv6, and from IPv6 to
@@ -1331,7 +1331,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_change_type(struct sk_buff *skb, u32 type)
+ * long bpf_skb_change_type(struct sk_buff *skb, u32 type)
  * 	Description
  * 		Change the packet type for the packet associated to *skb*. This
  * 		comes down to setting *skb*\ **->pkt_type** to *type*, except
@@ -1358,7 +1358,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_under_cgroup(struct sk_buff *skb, struct bpf_map *map, u3=
2 index)
+ * long bpf_skb_under_cgroup(struct sk_buff *skb, struct bpf_map *map, u=
32 index)
  * 	Description
  * 		Check whether *skb* is a descendant of the cgroup2 held by
  * 		*map* of type **BPF_MAP_TYPE_CGROUP_ARRAY**, at *index*.
@@ -1389,7 +1389,7 @@ union bpf_attr {
  * 	Return
  * 		A pointer to the current task struct.
  *
- * int bpf_probe_write_user(void *dst, const void *src, u32 len)
+ * long bpf_probe_write_user(void *dst, const void *src, u32 len)
  * 	Description
  * 		Attempt in a safe way to write *len* bytes from the buffer
  * 		*src* to *dst* in memory. It only works for threads that are in
@@ -1408,7 +1408,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_current_task_under_cgroup(struct bpf_map *map, u32 index)
+ * long bpf_current_task_under_cgroup(struct bpf_map *map, u32 index)
  * 	Description
  * 		Check whether the probe is being run is the context of a given
  * 		subset of the cgroup2 hierarchy. The cgroup2 to test is held by
@@ -1420,7 +1420,7 @@ union bpf_attr {
  * 		* 1, if the *skb* task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
- * int bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
+ * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
  * 	Description
  * 		Resize (trim or grow) the packet associated to *skb* to the
  * 		new *len*. The *flags* are reserved for future usage, and must
@@ -1444,7 +1444,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_pull_data(struct sk_buff *skb, u32 len)
+ * long bpf_skb_pull_data(struct sk_buff *skb, u32 len)
  * 	Description
  * 		Pull in non-linear data in case the *skb* is non-linear and not
  * 		all of *len* are part of the linear section. Make *len* bytes
@@ -1500,7 +1500,7 @@ union bpf_attr {
  * 		recalculation the next time the kernel tries to access this
  * 		hash or when the **bpf_get_hash_recalc**\ () helper is called.
  *
- * int bpf_get_numa_node_id(void)
+ * long bpf_get_numa_node_id(void)
  * 	Description
  * 		Return the id of the current NUMA node. The primary use case
  * 		for this helper is the selection of sockets for the local NUMA
@@ -1511,7 +1511,7 @@ union bpf_attr {
  * 	Return
  * 		The id of current NUMA node.
  *
- * int bpf_skb_change_head(struct sk_buff *skb, u32 len, u64 flags)
+ * long bpf_skb_change_head(struct sk_buff *skb, u32 len, u64 flags)
  * 	Description
  * 		Grows headroom of packet associated to *skb* and adjusts the
  * 		offset of the MAC header accordingly, adding *len* bytes of
@@ -1532,7 +1532,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_xdp_adjust_head(struct xdp_buff *xdp_md, int delta)
+ * long bpf_xdp_adjust_head(struct xdp_buff *xdp_md, int delta)
  * 	Description
  * 		Adjust (move) *xdp_md*\ **->data** by *delta* bytes. Note that
  * 		it is possible to use a negative value for *delta*. This helper
@@ -1547,7 +1547,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_str(void *dst, u32 size, const void *unsafe_ptr)
+ * long bpf_probe_read_str(void *dst, u32 size, const void *unsafe_ptr)
  * 	Description
  * 		Copy a NUL terminated string from an unsafe kernel address
  * 		*unsafe_ptr* to *dst*. See **bpf_probe_read_kernel_str**\ () for
@@ -1595,14 +1595,14 @@ union bpf_attr {
  * 		is returned (note that **overflowuid** might also be the actual
  * 		UID value for the socket).
  *
- * u32 bpf_set_hash(struct sk_buff *skb, u32 hash)
+ * long bpf_set_hash(struct sk_buff *skb, u32 hash)
  * 	Description
  * 		Set the full hash for *skb* (set the field *skb*\ **->hash**)
  * 		to value *hash*.
  * 	Return
  * 		0
  *
- * int bpf_setsockopt(void *bpf_socket, int level, int optname, void *op=
tval, int optlen)
+ * long bpf_setsockopt(void *bpf_socket, int level, int optname, void *o=
ptval, int optlen)
  * 	Description
  * 		Emulate a call to **setsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1630,7 +1630,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_adjust_room(struct sk_buff *skb, s32 len_diff, u32 mode, =
u64 flags)
+ * long bpf_skb_adjust_room(struct sk_buff *skb, s32 len_diff, u32 mode,=
 u64 flags)
  * 	Description
  * 		Grow or shrink the room for data in the packet associated to
  * 		*skb* by *len_diff*, and according to the selected *mode*.
@@ -1676,7 +1676,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_redirect_map(struct bpf_map *map, u32 key, u64 flags)
+ * long bpf_redirect_map(struct bpf_map *map, u32 key, u64 flags)
  * 	Description
  * 		Redirect the packet to the endpoint referenced by *map* at
  * 		index *key*. Depending on its type, this *map* can contain
@@ -1697,7 +1697,7 @@ union bpf_attr {
  * 		**XDP_REDIRECT** on success, or the value of the two lower bits
  * 		of the *flags* argument on error.
  *
- * int bpf_sk_redirect_map(struct sk_buff *skb, struct bpf_map *map, u32=
 key, u64 flags)
+ * long bpf_sk_redirect_map(struct sk_buff *skb, struct bpf_map *map, u3=
2 key, u64 flags)
  * 	Description
  * 		Redirect the packet to the socket referenced by *map* (of type
  * 		**BPF_MAP_TYPE_SOCKMAP**) at index *key*. Both ingress and
@@ -1708,7 +1708,7 @@ union bpf_attr {
  * 	Return
  * 		**SK_PASS** on success, or **SK_DROP** on error.
  *
- * int bpf_sock_map_update(struct bpf_sock_ops *skops, struct bpf_map *m=
ap, void *key, u64 flags)
+ * long bpf_sock_map_update(struct bpf_sock_ops *skops, struct bpf_map *=
map, void *key, u64 flags)
  * 	Description
  * 		Add an entry to, or update a *map* referencing sockets. The
  * 		*skops* is used as a new value for the entry associated to
@@ -1727,7 +1727,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_xdp_adjust_meta(struct xdp_buff *xdp_md, int delta)
+ * long bpf_xdp_adjust_meta(struct xdp_buff *xdp_md, int delta)
  * 	Description
  * 		Adjust the address pointed by *xdp_md*\ **->data_meta** by
  * 		*delta* (which can be positive or negative). Note that this
@@ -1756,7 +1756,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_perf_event_read_value(struct bpf_map *map, u64 flags, struct =
bpf_perf_event_value *buf, u32 buf_size)
+ * long bpf_perf_event_read_value(struct bpf_map *map, u64 flags, struct=
 bpf_perf_event_value *buf, u32 buf_size)
  * 	Description
  * 		Read the value of a perf event counter, and store it into *buf*
  * 		of size *buf_size*. This helper relies on a *map* of type
@@ -1806,7 +1806,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_perf_prog_read_value(struct bpf_perf_event_data *ctx, struct =
bpf_perf_event_value *buf, u32 buf_size)
+ * long bpf_perf_prog_read_value(struct bpf_perf_event_data *ctx, struct=
 bpf_perf_event_value *buf, u32 buf_size)
  * 	Description
  * 		For en eBPF program attached to a perf event, retrieve the
  * 		value of the event counter associated to *ctx* and store it in
@@ -1817,7 +1817,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_getsockopt(void *bpf_socket, int level, int optname, void *op=
tval, int optlen)
+ * long bpf_getsockopt(void *bpf_socket, int level, int optname, void *o=
ptval, int optlen)
  * 	Description
  * 		Emulate a call to **getsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1842,7 +1842,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_override_return(struct pt_regs *regs, u64 rc)
+ * long bpf_override_return(struct pt_regs *regs, u64 rc)
  * 	Description
  * 		Used for error injection, this helper uses kprobes to override
  * 		the return value of the probed function, and to set it to *rc*.
@@ -1867,7 +1867,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_sock_ops_cb_flags_set(struct bpf_sock_ops *bpf_sock, int argv=
al)
+ * long bpf_sock_ops_cb_flags_set(struct bpf_sock_ops *bpf_sock, int arg=
val)
  * 	Description
  * 		Attempt to set the value of the **bpf_sock_ops_cb_flags** field
  * 		for the full TCP socket associated to *bpf_sock_ops* to
@@ -1911,7 +1911,7 @@ union bpf_attr {
  * 		be set is returned (which comes down to 0 if all bits were set
  * 		as required).
  *
- * int bpf_msg_redirect_map(struct sk_msg_buff *msg, struct bpf_map *map=
, u32 key, u64 flags)
+ * long bpf_msg_redirect_map(struct sk_msg_buff *msg, struct bpf_map *ma=
p, u32 key, u64 flags)
  * 	Description
  * 		This helper is used in programs implementing policies at the
  * 		socket level. If the message *msg* is allowed to pass (i.e. if
@@ -1925,7 +1925,7 @@ union bpf_attr {
  * 	Return
  * 		**SK_PASS** on success, or **SK_DROP** on error.
  *
- * int bpf_msg_apply_bytes(struct sk_msg_buff *msg, u32 bytes)
+ * long bpf_msg_apply_bytes(struct sk_msg_buff *msg, u32 bytes)
  * 	Description
  * 		For socket policies, apply the verdict of the eBPF program to
  * 		the next *bytes* (number of bytes) of message *msg*.
@@ -1959,7 +1959,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_msg_cork_bytes(struct sk_msg_buff *msg, u32 bytes)
+ * long bpf_msg_cork_bytes(struct sk_msg_buff *msg, u32 bytes)
  * 	Description
  * 		For socket policies, prevent the execution of the verdict eBPF
  * 		program for message *msg* until *bytes* (byte number) have been
@@ -1977,7 +1977,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_msg_pull_data(struct sk_msg_buff *msg, u32 start, u32 end, u6=
4 flags)
+ * long bpf_msg_pull_data(struct sk_msg_buff *msg, u32 start, u32 end, u=
64 flags)
  * 	Description
  * 		For socket policies, pull in non-linear data from user space
  * 		for *msg* and set pointers *msg*\ **->data** and *msg*\
@@ -2008,7 +2008,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_bind(struct bpf_sock_addr *ctx, struct sockaddr *addr, int ad=
dr_len)
+ * long bpf_bind(struct bpf_sock_addr *ctx, struct sockaddr *addr, int a=
ddr_len)
  * 	Description
  * 		Bind the socket associated to *ctx* to the address pointed by
  * 		*addr*, of length *addr_len*. This allows for making outgoing
@@ -2026,7 +2026,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_xdp_adjust_tail(struct xdp_buff *xdp_md, int delta)
+ * long bpf_xdp_adjust_tail(struct xdp_buff *xdp_md, int delta)
  * 	Description
  * 		Adjust (move) *xdp_md*\ **->data_end** by *delta* bytes. It is
  * 		possible to both shrink and grow the packet tail.
@@ -2040,7 +2040,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_get_xfrm_state(struct sk_buff *skb, u32 index, struct bpf=
_xfrm_state *xfrm_state, u32 size, u64 flags)
+ * long bpf_skb_get_xfrm_state(struct sk_buff *skb, u32 index, struct bp=
f_xfrm_state *xfrm_state, u32 size, u64 flags)
  * 	Description
  * 		Retrieve the XFRM state (IP transform framework, see also
  * 		**ip-xfrm(8)**) at *index* in XFRM "security path" for *skb*.
@@ -2056,7 +2056,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stack(void *ctx, void *buf, u32 size, u64 flags)
+ * long bpf_get_stack(void *ctx, void *buf, u32 size, u64 flags)
  * 	Description
  * 		Return a user or a kernel stack in bpf program provided buffer.
  * 		To achieve this, the helper needs *ctx*, which is a pointer
@@ -2089,7 +2089,7 @@ union bpf_attr {
  * 		A non-negative value equal to or less than *size* on success,
  * 		or a negative error in case of failure.
  *
- * int bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *to=
, u32 len, u32 start_header)
+ * long bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *t=
o, u32 len, u32 start_header)
  * 	Description
  * 		This helper is similar to **bpf_skb_load_bytes**\ () in that
  * 		it provides an easy way to load *len* bytes from *offset*
@@ -2111,7 +2111,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_fib_lookup(void *ctx, struct bpf_fib_lookup *params, int plen=
, u32 flags)
+ * long bpf_fib_lookup(void *ctx, struct bpf_fib_lookup *params, int ple=
n, u32 flags)
  *	Description
  *		Do FIB lookup in kernel tables using parameters in *params*.
  *		If lookup is successful and result shows packet is to be
@@ -2142,7 +2142,7 @@ union bpf_attr {
  *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
  *		  packet is not forwarded or needs assist from full stack
  *
- * int bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *=
map, void *key, u64 flags)
+ * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map =
*map, void *key, u64 flags)
  *	Description
  *		Add an entry to, or update a sockhash *map* referencing sockets.
  *		The *skops* is used as a new value for the entry associated to
@@ -2161,7 +2161,7 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_redirect_hash(struct sk_msg_buff *msg, struct bpf_map *ma=
p, void *key, u64 flags)
+ * long bpf_msg_redirect_hash(struct sk_msg_buff *msg, struct bpf_map *m=
ap, void *key, u64 flags)
  *	Description
  *		This helper is used in programs implementing policies at the
  *		socket level. If the message *msg* is allowed to pass (i.e. if
@@ -2175,7 +2175,7 @@ union bpf_attr {
  *	Return
  *		**SK_PASS** on success, or **SK_DROP** on error.
  *
- * int bpf_sk_redirect_hash(struct sk_buff *skb, struct bpf_map *map, vo=
id *key, u64 flags)
+ * long bpf_sk_redirect_hash(struct sk_buff *skb, struct bpf_map *map, v=
oid *key, u64 flags)
  *	Description
  *		This helper is used in programs implementing policies at the
  *		skb socket level. If the sk_buff *skb* is allowed to pass (i.e.
@@ -2189,7 +2189,7 @@ union bpf_attr {
  *	Return
  *		**SK_PASS** on success, or **SK_DROP** on error.
  *
- * int bpf_lwt_push_encap(struct sk_buff *skb, u32 type, void *hdr, u32 =
len)
+ * long bpf_lwt_push_encap(struct sk_buff *skb, u32 type, void *hdr, u32=
 len)
  *	Description
  *		Encapsulate the packet associated to *skb* within a Layer 3
  *		protocol header. This header is provided in the buffer at
@@ -2226,7 +2226,7 @@ union bpf_attr {
  *	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_lwt_seg6_store_bytes(struct sk_buff *skb, u32 offset, const v=
oid *from, u32 len)
+ * long bpf_lwt_seg6_store_bytes(struct sk_buff *skb, u32 offset, const =
void *from, u32 len)
  *	Description
  *		Store *len* bytes from address *from* into the packet
  *		associated to *skb*, at *offset*. Only the flags, tag and TLVs
@@ -2241,7 +2241,7 @@ union bpf_attr {
  *	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_lwt_seg6_adjust_srh(struct sk_buff *skb, u32 offset, s32 delt=
a)
+ * long bpf_lwt_seg6_adjust_srh(struct sk_buff *skb, u32 offset, s32 del=
ta)
  *	Description
  *		Adjust the size allocated to TLVs in the outermost IPv6
  *		Segment Routing Header contained in the packet associated to
@@ -2257,7 +2257,7 @@ union bpf_attr {
  *	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_lwt_seg6_action(struct sk_buff *skb, u32 action, void *param,=
 u32 param_len)
+ * long bpf_lwt_seg6_action(struct sk_buff *skb, u32 action, void *param=
, u32 param_len)
  *	Description
  *		Apply an IPv6 Segment Routing action of type *action* to the
  *		packet associated to *skb*. Each action takes a parameter
@@ -2286,7 +2286,7 @@ union bpf_attr {
  *	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_rc_repeat(void *ctx)
+ * long bpf_rc_repeat(void *ctx)
  *	Description
  *		This helper is used in programs implementing IR decoding, to
  *		report a successfully decoded repeat key message. This delays
@@ -2305,7 +2305,7 @@ union bpf_attr {
  *	Return
  *		0
  *
- * int bpf_rc_keydown(void *ctx, u32 protocol, u64 scancode, u32 toggle)
+ * long bpf_rc_keydown(void *ctx, u32 protocol, u64 scancode, u32 toggle=
)
  *	Description
  *		This helper is used in programs implementing IR decoding, to
  *		report a successfully decoded key press with *scancode*,
@@ -2370,7 +2370,7 @@ union bpf_attr {
  *	Return
  *		A pointer to the local storage area.
  *
- * int bpf_sk_select_reuseport(struct sk_reuseport_md *reuse, struct bpf=
_map *map, void *key, u64 flags)
+ * long bpf_sk_select_reuseport(struct sk_reuseport_md *reuse, struct bp=
f_map *map, void *key, u64 flags)
  *	Description
  *		Select a **SO_REUSEPORT** socket from a
  *		**BPF_MAP_TYPE_REUSEPORT_ARRAY** *map*.
@@ -2471,7 +2471,7 @@ union bpf_attr {
  *		result is from *reuse*\ **->socks**\ [] using the hash of the
  *		tuple.
  *
- * int bpf_sk_release(struct bpf_sock *sock)
+ * long bpf_sk_release(struct bpf_sock *sock)
  *	Description
  *		Release the reference held by *sock*. *sock* must be a
  *		non-**NULL** pointer that was returned from
@@ -2479,7 +2479,7 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_map_push_elem(struct bpf_map *map, const void *value, u64 fla=
gs)
+ * long bpf_map_push_elem(struct bpf_map *map, const void *value, u64 fl=
ags)
  * 	Description
  * 		Push an element *value* in *map*. *flags* is one of:
  *
@@ -2489,19 +2489,19 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_map_pop_elem(struct bpf_map *map, void *value)
+ * long bpf_map_pop_elem(struct bpf_map *map, void *value)
  * 	Description
  * 		Pop an element from *map*.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_map_peek_elem(struct bpf_map *map, void *value)
+ * long bpf_map_peek_elem(struct bpf_map *map, void *value)
  * 	Description
  * 		Get an element from *map* without removing it.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_push_data(struct sk_msg_buff *msg, u32 start, u32 len, u6=
4 flags)
+ * long bpf_msg_push_data(struct sk_msg_buff *msg, u32 start, u32 len, u=
64 flags)
  *	Description
  *		For socket policies, insert *len* bytes into *msg* at offset
  *		*start*.
@@ -2517,7 +2517,7 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_pop_data(struct sk_msg_buff *msg, u32 start, u32 len, u64=
 flags)
+ * long bpf_msg_pop_data(struct sk_msg_buff *msg, u32 start, u32 len, u6=
4 flags)
  *	Description
  *		Will remove *len* bytes from a *msg* starting at byte *start*.
  *		This may result in **ENOMEM** errors under certain situations if
@@ -2529,7 +2529,7 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_rc_pointer_rel(void *ctx, s32 rel_x, s32 rel_y)
+ * long bpf_rc_pointer_rel(void *ctx, s32 rel_x, s32 rel_y)
  *	Description
  *		This helper is used in programs implementing IR decoding, to
  *		report a successfully decoded pointer movement.
@@ -2543,7 +2543,7 @@ union bpf_attr {
  *	Return
  *		0
  *
- * int bpf_spin_lock(struct bpf_spin_lock *lock)
+ * long bpf_spin_lock(struct bpf_spin_lock *lock)
  *	Description
  *		Acquire a spinlock represented by the pointer *lock*, which is
  *		stored as part of a value of a map. Taking the lock allows to
@@ -2591,7 +2591,7 @@ union bpf_attr {
  *	Return
  *		0
  *
- * int bpf_spin_unlock(struct bpf_spin_lock *lock)
+ * long bpf_spin_unlock(struct bpf_spin_lock *lock)
  *	Description
  *		Release the *lock* previously locked by a call to
  *		**bpf_spin_lock**\ (\ *lock*\ ).
@@ -2614,7 +2614,7 @@ union bpf_attr {
  *		A **struct bpf_tcp_sock** pointer on success, or **NULL** in
  *		case of failure.
  *
- * int bpf_skb_ecn_set_ce(struct sk_buff *skb)
+ * long bpf_skb_ecn_set_ce(struct sk_buff *skb)
  *	Description
  *		Set ECN (Explicit Congestion Notification) field of IP header
  *		to **CE** (Congestion Encountered) if current value is **ECT**
@@ -2651,7 +2651,7 @@ union bpf_attr {
  *		result is from *reuse*\ **->socks**\ [] using the hash of the
  *		tuple.
  *
- * int bpf_tcp_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_l=
en, struct tcphdr *th, u32 th_len)
+ * long bpf_tcp_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_=
len, struct tcphdr *th, u32 th_len)
  * 	Description
  * 		Check whether *iph* and *th* contain a valid SYN cookie ACK for
  * 		the listening socket in *sk*.
@@ -2666,7 +2666,7 @@ union bpf_attr {
  * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * 		error otherwise.
  *
- * int bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf=
_len, u64 flags)
+ * long bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t bu=
f_len, u64 flags)
  *	Description
  *		Get name of sysctl in /proc/sys/ and copy it into provided by
  *		program buffer *buf* of size *buf_len*.
@@ -2682,7 +2682,7 @@ union bpf_attr {
  *		**-E2BIG** if the buffer wasn't big enough (*buf* will contain
  *		truncated name in this case).
  *
- * int bpf_sysctl_get_current_value(struct bpf_sysctl *ctx, char *buf, s=
ize_t buf_len)
+ * long bpf_sysctl_get_current_value(struct bpf_sysctl *ctx, char *buf, =
size_t buf_len)
  *	Description
  *		Get current value of sysctl as it is presented in /proc/sys
  *		(incl. newline, etc), and copy it as a string into provided
@@ -2701,7 +2701,7 @@ union bpf_attr {
  *		**-EINVAL** if current value was unavailable, e.g. because
  *		sysctl is uninitialized and read returns -EIO for it.
  *
- * int bpf_sysctl_get_new_value(struct bpf_sysctl *ctx, char *buf, size_=
t buf_len)
+ * long bpf_sysctl_get_new_value(struct bpf_sysctl *ctx, char *buf, size=
_t buf_len)
  *	Description
  *		Get new value being written by user space to sysctl (before
  *		the actual write happens) and copy it as a string into
@@ -2718,7 +2718,7 @@ union bpf_attr {
  *
  *		**-EINVAL** if sysctl is being read.
  *
- * int bpf_sysctl_set_new_value(struct bpf_sysctl *ctx, const char *buf,=
 size_t buf_len)
+ * long bpf_sysctl_set_new_value(struct bpf_sysctl *ctx, const char *buf=
, size_t buf_len)
  *	Description
  *		Override new value being written by user space to sysctl with
  *		value provided by program in buffer *buf* of size *buf_len*.
@@ -2735,7 +2735,7 @@ union bpf_attr {
  *
  *		**-EINVAL** if sysctl is being read.
  *
- * int bpf_strtol(const char *buf, size_t buf_len, u64 flags, long *res)
+ * long bpf_strtol(const char *buf, size_t buf_len, u64 flags, long *res=
)
  *	Description
  *		Convert the initial part of the string from buffer *buf* of
  *		size *buf_len* to a long integer according to the given base
@@ -2759,7 +2759,7 @@ union bpf_attr {
  *
  *		**-ERANGE** if resulting value was out of range.
  *
- * int bpf_strtoul(const char *buf, size_t buf_len, u64 flags, unsigned =
long *res)
+ * long bpf_strtoul(const char *buf, size_t buf_len, u64 flags, unsigned=
 long *res)
  *	Description
  *		Convert the initial part of the string from buffer *buf* of
  *		size *buf_len* to an unsigned long integer according to the
@@ -2810,7 +2810,7 @@ union bpf_attr {
  *		**NULL** if not found or there was an error in adding
  *		a new bpf-local-storage.
  *
- * int bpf_sk_storage_delete(struct bpf_map *map, struct bpf_sock *sk)
+ * long bpf_sk_storage_delete(struct bpf_map *map, struct bpf_sock *sk)
  *	Description
  *		Delete a bpf-local-storage from a *sk*.
  *	Return
@@ -2818,7 +2818,7 @@ union bpf_attr {
  *
  *		**-ENOENT** if the bpf-local-storage cannot be found.
  *
- * int bpf_send_signal(u32 sig)
+ * long bpf_send_signal(u32 sig)
  *	Description
  *		Send signal *sig* to the process of the current task.
  *		The signal may be delivered to any of this process's threads.
@@ -2859,7 +2859,7 @@ union bpf_attr {
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
  *
- * int bpf_skb_output(void *ctx, struct bpf_map *map, u64 flags, void *d=
ata, u64 size)
+ * long bpf_skb_output(void *ctx, struct bpf_map *map, u64 flags, void *=
data, u64 size)
  * 	Description
  * 		Write raw *data* blob into a special BPF perf event held by
  * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -2883,21 +2883,21 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_user(void *dst, u32 size, const void *unsafe_ptr)
+ * long bpf_probe_read_user(void *dst, u32 size, const void *unsafe_ptr)
  * 	Description
  * 		Safely attempt to read *size* bytes from user space address
  * 		*unsafe_ptr* and store the data in *dst*.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr=
)
+ * long bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_pt=
r)
  * 	Description
  * 		Safely attempt to read *size* bytes from kernel space address
  * 		*unsafe_ptr* and store the data in *dst*.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_user_str(void *dst, u32 size, const void *unsafe_p=
tr)
+ * long bpf_probe_read_user_str(void *dst, u32 size, const void *unsafe_=
ptr)
  * 	Description
  * 		Copy a NUL terminated string from an unsafe user address
  * 		*unsafe_ptr* to *dst*. The *size* should include the
@@ -2941,7 +2941,7 @@ union bpf_attr {
  * 		including the trailing NUL character. On error, a negative
  * 		value.
  *
- * int bpf_probe_read_kernel_str(void *dst, u32 size, const void *unsafe=
_ptr)
+ * long bpf_probe_read_kernel_str(void *dst, u32 size, const void *unsaf=
e_ptr)
  * 	Description
  * 		Copy a NUL terminated string from an unsafe kernel address *unsafe_=
ptr*
  * 		to *dst*. Same semantics as with **bpf_probe_read_user_str**\ () ap=
ply.
@@ -2949,14 +2949,14 @@ union bpf_attr {
  * 		On success, the strictly positive length of the string, including
  * 		the trailing NUL character. On error, a negative value.
  *
- * int bpf_tcp_send_ack(void *tp, u32 rcv_nxt)
+ * long bpf_tcp_send_ack(void *tp, u32 rcv_nxt)
  *	Description
  *		Send out a tcp-ack. *tp* is the in-kernel struct **tcp_sock**.
  *		*rcv_nxt* is the ack_seq to be sent out.
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_send_signal_thread(u32 sig)
+ * long bpf_send_signal_thread(u32 sig)
  *	Description
  *		Send signal *sig* to the thread corresponding to the current task.
  *	Return
@@ -2976,7 +2976,7 @@ union bpf_attr {
  *	Return
  *		The 64 bit jiffies
  *
- * int bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *bu=
f, u32 size, u64 flags)
+ * long bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *b=
uf, u32 size, u64 flags)
  *	Description
  *		For an eBPF program attached to a perf event, retrieve the
  *		branch records (**struct perf_branch_entry**) associated to *ctx*
@@ -2995,7 +2995,7 @@ union bpf_attr {
  *
  *		**-ENOENT** if architecture does not support branch records.
  *
- * int bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_in=
fo *nsdata, u32 size)
+ * long bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_i=
nfo *nsdata, u32 size)
  *	Description
  *		Returns 0 on success, values for *pid* and *tgid* as seen from the c=
urrent
  *		*namespace* will be returned in *nsdata*.
@@ -3007,7 +3007,7 @@ union bpf_attr {
  *
  *		**-ENOENT** if pidns does not exists for the current task.
  *
- * int bpf_xdp_output(void *ctx, struct bpf_map *map, u64 flags, void *d=
ata, u64 size)
+ * long bpf_xdp_output(void *ctx, struct bpf_map *map, u64 flags, void *=
data, u64 size)
  *	Description
  *		Write raw *data* blob into a special BPF perf event held by
  *		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -3062,7 +3062,7 @@ union bpf_attr {
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
  *
- * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags=
)
+ * long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flag=
s)
  *	Description
  *		Assign the *sk* to the *skb*. When combined with appropriate
  *		routing configuration to receive the packet towards the socket,
@@ -3097,7 +3097,7 @@ union bpf_attr {
  * 	Return
  * 		Current *ktime*.
  *
- * int bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size,=
 const void *data, u32 data_len)
+ * long bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size=
, const void *data, u32 data_len)
  * 	Description
  * 		**bpf_seq_printf**\ () uses seq_file **seq_printf**\ () to print
  * 		out the format string.
@@ -3126,7 +3126,7 @@ union bpf_attr {
  *
  *		**-EOVERFLOW** if an overflow happened: The same object will be trie=
d again.
  *
- * int bpf_seq_write(struct seq_file *m, const void *data, u32 len)
+ * long bpf_seq_write(struct seq_file *m, const void *data, u32 len)
  * 	Description
  * 		**bpf_seq_write**\ () uses seq_file **seq_write**\ () to write the =
data.
  * 		The *m* represents the seq_file. The *data* and *len* represent the
@@ -3221,7 +3221,7 @@ union bpf_attr {
  *	Return
  *		Requested value, or 0, if flags are not recognized.
  *
- * int bpf_csum_level(struct sk_buff *skb, u64 level)
+ * long bpf_csum_level(struct sk_buff *skb, u64 level)
  * 	Description
  * 		Change the skbs checksum level by one layer up or down, or
  * 		reset it entirely to none in order to have the stack perform
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 19684813faae..be0efee49093 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -653,7 +653,7 @@ union bpf_attr {
  * 		Map value associated to *key*, or **NULL** if no entry was
  * 		found.
  *
- * int bpf_map_update_elem(struct bpf_map *map, const void *key, const v=
oid *value, u64 flags)
+ * long bpf_map_update_elem(struct bpf_map *map, const void *key, const =
void *value, u64 flags)
  * 	Description
  * 		Add or update the value of the entry associated to *key* in
  * 		*map* with *value*. *flags* is one of:
@@ -671,13 +671,13 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_map_delete_elem(struct bpf_map *map, const void *key)
+ * long bpf_map_delete_elem(struct bpf_map *map, const void *key)
  * 	Description
  * 		Delete entry with *key* from *map*.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read(void *dst, u32 size, const void *unsafe_ptr)
+ * long bpf_probe_read(void *dst, u32 size, const void *unsafe_ptr)
  * 	Description
  * 		For tracing programs, safely attempt to read *size* bytes from
  * 		kernel space address *unsafe_ptr* and store the data in *dst*.
@@ -695,7 +695,7 @@ union bpf_attr {
  * 	Return
  * 		Current *ktime*.
  *
- * int bpf_trace_printk(const char *fmt, u32 fmt_size, ...)
+ * long bpf_trace_printk(const char *fmt, u32 fmt_size, ...)
  * 	Description
  * 		This helper is a "printk()-like" facility for debugging. It
  * 		prints a message defined by format *fmt* (of size *fmt_size*)
@@ -775,7 +775,7 @@ union bpf_attr {
  * 	Return
  * 		The SMP id of the processor running the program.
  *
- * int bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void *=
from, u32 len, u64 flags)
+ * long bpf_skb_store_bytes(struct sk_buff *skb, u32 offset, const void =
*from, u32 len, u64 flags)
  * 	Description
  * 		Store *len* bytes from address *from* into the packet
  * 		associated to *skb*, at *offset*. *flags* are a combination of
@@ -792,7 +792,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_l3_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u6=
4 to, u64 size)
+ * long bpf_l3_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u=
64 to, u64 size)
  * 	Description
  * 		Recompute the layer 3 (e.g. IP) checksum for the packet
  * 		associated to *skb*. Computation is incremental, so the helper
@@ -817,7 +817,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_l4_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u6=
4 to, u64 flags)
+ * long bpf_l4_csum_replace(struct sk_buff *skb, u32 offset, u64 from, u=
64 to, u64 flags)
  * 	Description
  * 		Recompute the layer 4 (e.g. TCP, UDP or ICMP) checksum for the
  * 		packet associated to *skb*. Computation is incremental, so the
@@ -849,7 +849,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_tail_call(void *ctx, struct bpf_map *prog_array_map, u32 inde=
x)
+ * long bpf_tail_call(void *ctx, struct bpf_map *prog_array_map, u32 ind=
ex)
  * 	Description
  * 		This special helper is used to trigger a "tail call", or in
  * 		other words, to jump into another eBPF program. The same stack
@@ -880,7 +880,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_clone_redirect(struct sk_buff *skb, u32 ifindex, u64 flags)
+ * long bpf_clone_redirect(struct sk_buff *skb, u32 ifindex, u64 flags)
  * 	Description
  * 		Clone and redirect the packet associated to *skb* to another
  * 		net device of index *ifindex*. Both ingress and egress
@@ -916,7 +916,7 @@ union bpf_attr {
  * 		A 64-bit integer containing the current GID and UID, and
  * 		created as such: *current_gid* **<< 32 \|** *current_uid*.
  *
- * int bpf_get_current_comm(void *buf, u32 size_of_buf)
+ * long bpf_get_current_comm(void *buf, u32 size_of_buf)
  * 	Description
  * 		Copy the **comm** attribute of the current task into *buf* of
  * 		*size_of_buf*. The **comm** attribute contains the name of
@@ -953,7 +953,7 @@ union bpf_attr {
  * 	Return
  * 		The classid, or 0 for the default unconfigured classid.
  *
- * int bpf_skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vla=
n_tci)
+ * long bpf_skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vl=
an_tci)
  * 	Description
  * 		Push a *vlan_tci* (VLAN tag control information) of protocol
  * 		*vlan_proto* to the packet associated to *skb*, then update
@@ -969,7 +969,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_vlan_pop(struct sk_buff *skb)
+ * long bpf_skb_vlan_pop(struct sk_buff *skb)
  * 	Description
  * 		Pop a VLAN header from the packet associated to *skb*.
  *
@@ -981,7 +981,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_get_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_key=
 *key, u32 size, u64 flags)
+ * long bpf_skb_get_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_ke=
y *key, u32 size, u64 flags)
  * 	Description
  * 		Get tunnel metadata. This helper takes a pointer *key* to an
  * 		empty **struct bpf_tunnel_key** of **size**, that will be
@@ -1032,7 +1032,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_set_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_key=
 *key, u32 size, u64 flags)
+ * long bpf_skb_set_tunnel_key(struct sk_buff *skb, struct bpf_tunnel_ke=
y *key, u32 size, u64 flags)
  * 	Description
  * 		Populate tunnel metadata for packet associated to *skb.* The
  * 		tunnel metadata is set to the contents of *key*, of *size*. The
@@ -1098,7 +1098,7 @@ union bpf_attr {
  * 		The value of the perf event counter read from the map, or a
  * 		negative error code in case of failure.
  *
- * int bpf_redirect(u32 ifindex, u64 flags)
+ * long bpf_redirect(u32 ifindex, u64 flags)
  * 	Description
  * 		Redirect the packet to another net device of index *ifindex*.
  * 		This helper is somewhat similar to **bpf_clone_redirect**\
@@ -1145,7 +1145,7 @@ union bpf_attr {
  * 		The realm of the route for the packet associated to *skb*, or 0
  * 		if none was found.
  *
- * int bpf_perf_event_output(void *ctx, struct bpf_map *map, u64 flags, =
void *data, u64 size)
+ * long bpf_perf_event_output(void *ctx, struct bpf_map *map, u64 flags,=
 void *data, u64 size)
  * 	Description
  * 		Write raw *data* blob into a special BPF perf event held by
  * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -1190,7 +1190,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_load_bytes(const void *skb, u32 offset, void *to, u32 len=
)
+ * long bpf_skb_load_bytes(const void *skb, u32 offset, void *to, u32 le=
n)
  * 	Description
  * 		This helper was provided as an easy way to load data from a
  * 		packet. It can be used to load *len* bytes from *offset* from
@@ -1207,7 +1207,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stackid(void *ctx, struct bpf_map *map, u64 flags)
+ * long bpf_get_stackid(void *ctx, struct bpf_map *map, u64 flags)
  * 	Description
  * 		Walk a user or a kernel stack and return its id. To achieve
  * 		this, the helper needs *ctx*, which is a pointer to the context
@@ -1276,7 +1276,7 @@ union bpf_attr {
  * 		The checksum result, or a negative error code in case of
  * 		failure.
  *
- * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
+ * long bpf_skb_get_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
  * 	Description
  * 		Retrieve tunnel options metadata for the packet associated to
  * 		*skb*, and store the raw tunnel option data to the buffer *opt*
@@ -1294,7 +1294,7 @@ union bpf_attr {
  * 	Return
  * 		The size of the option data retrieved.
  *
- * int bpf_skb_set_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
+ * long bpf_skb_set_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
  * 	Description
  * 		Set tunnel options metadata for the packet associated to *skb*
  * 		to the option data contained in the raw buffer *opt* of *size*.
@@ -1304,7 +1304,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_change_proto(struct sk_buff *skb, __be16 proto, u64 flags=
)
+ * long bpf_skb_change_proto(struct sk_buff *skb, __be16 proto, u64 flag=
s)
  * 	Description
  * 		Change the protocol of the *skb* to *proto*. Currently
  * 		supported are transition from IPv4 to IPv6, and from IPv6 to
@@ -1331,7 +1331,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_change_type(struct sk_buff *skb, u32 type)
+ * long bpf_skb_change_type(struct sk_buff *skb, u32 type)
  * 	Description
  * 		Change the packet type for the packet associated to *skb*. This
  * 		comes down to setting *skb*\ **->pkt_type** to *type*, except
@@ -1358,7 +1358,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_under_cgroup(struct sk_buff *skb, struct bpf_map *map, u3=
2 index)
+ * long bpf_skb_under_cgroup(struct sk_buff *skb, struct bpf_map *map, u=
32 index)
  * 	Description
  * 		Check whether *skb* is a descendant of the cgroup2 held by
  * 		*map* of type **BPF_MAP_TYPE_CGROUP_ARRAY**, at *index*.
@@ -1389,7 +1389,7 @@ union bpf_attr {
  * 	Return
  * 		A pointer to the current task struct.
  *
- * int bpf_probe_write_user(void *dst, const void *src, u32 len)
+ * long bpf_probe_write_user(void *dst, const void *src, u32 len)
  * 	Description
  * 		Attempt in a safe way to write *len* bytes from the buffer
  * 		*src* to *dst* in memory. It only works for threads that are in
@@ -1408,7 +1408,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_current_task_under_cgroup(struct bpf_map *map, u32 index)
+ * long bpf_current_task_under_cgroup(struct bpf_map *map, u32 index)
  * 	Description
  * 		Check whether the probe is being run is the context of a given
  * 		subset of the cgroup2 hierarchy. The cgroup2 to test is held by
@@ -1420,7 +1420,7 @@ union bpf_attr {
  * 		* 1, if the *skb* task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
- * int bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
+ * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
  * 	Description
  * 		Resize (trim or grow) the packet associated to *skb* to the
  * 		new *len*. The *flags* are reserved for future usage, and must
@@ -1444,7 +1444,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_pull_data(struct sk_buff *skb, u32 len)
+ * long bpf_skb_pull_data(struct sk_buff *skb, u32 len)
  * 	Description
  * 		Pull in non-linear data in case the *skb* is non-linear and not
  * 		all of *len* are part of the linear section. Make *len* bytes
@@ -1500,7 +1500,7 @@ union bpf_attr {
  * 		recalculation the next time the kernel tries to access this
  * 		hash or when the **bpf_get_hash_recalc**\ () helper is called.
  *
- * int bpf_get_numa_node_id(void)
+ * long bpf_get_numa_node_id(void)
  * 	Description
  * 		Return the id of the current NUMA node. The primary use case
  * 		for this helper is the selection of sockets for the local NUMA
@@ -1511,7 +1511,7 @@ union bpf_attr {
  * 	Return
  * 		The id of current NUMA node.
  *
- * int bpf_skb_change_head(struct sk_buff *skb, u32 len, u64 flags)
+ * long bpf_skb_change_head(struct sk_buff *skb, u32 len, u64 flags)
  * 	Description
  * 		Grows headroom of packet associated to *skb* and adjusts the
  * 		offset of the MAC header accordingly, adding *len* bytes of
@@ -1532,7 +1532,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_xdp_adjust_head(struct xdp_buff *xdp_md, int delta)
+ * long bpf_xdp_adjust_head(struct xdp_buff *xdp_md, int delta)
  * 	Description
  * 		Adjust (move) *xdp_md*\ **->data** by *delta* bytes. Note that
  * 		it is possible to use a negative value for *delta*. This helper
@@ -1547,7 +1547,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_str(void *dst, u32 size, const void *unsafe_ptr)
+ * long bpf_probe_read_str(void *dst, u32 size, const void *unsafe_ptr)
  * 	Description
  * 		Copy a NUL terminated string from an unsafe kernel address
  * 		*unsafe_ptr* to *dst*. See **bpf_probe_read_kernel_str**\ () for
@@ -1595,14 +1595,14 @@ union bpf_attr {
  * 		is returned (note that **overflowuid** might also be the actual
  * 		UID value for the socket).
  *
- * u32 bpf_set_hash(struct sk_buff *skb, u32 hash)
+ * long bpf_set_hash(struct sk_buff *skb, u32 hash)
  * 	Description
  * 		Set the full hash for *skb* (set the field *skb*\ **->hash**)
  * 		to value *hash*.
  * 	Return
  * 		0
  *
- * int bpf_setsockopt(void *bpf_socket, int level, int optname, void *op=
tval, int optlen)
+ * long bpf_setsockopt(void *bpf_socket, int level, int optname, void *o=
ptval, int optlen)
  * 	Description
  * 		Emulate a call to **setsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1630,7 +1630,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_adjust_room(struct sk_buff *skb, s32 len_diff, u32 mode, =
u64 flags)
+ * long bpf_skb_adjust_room(struct sk_buff *skb, s32 len_diff, u32 mode,=
 u64 flags)
  * 	Description
  * 		Grow or shrink the room for data in the packet associated to
  * 		*skb* by *len_diff*, and according to the selected *mode*.
@@ -1676,7 +1676,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_redirect_map(struct bpf_map *map, u32 key, u64 flags)
+ * long bpf_redirect_map(struct bpf_map *map, u32 key, u64 flags)
  * 	Description
  * 		Redirect the packet to the endpoint referenced by *map* at
  * 		index *key*. Depending on its type, this *map* can contain
@@ -1697,7 +1697,7 @@ union bpf_attr {
  * 		**XDP_REDIRECT** on success, or the value of the two lower bits
  * 		of the *flags* argument on error.
  *
- * int bpf_sk_redirect_map(struct sk_buff *skb, struct bpf_map *map, u32=
 key, u64 flags)
+ * long bpf_sk_redirect_map(struct sk_buff *skb, struct bpf_map *map, u3=
2 key, u64 flags)
  * 	Description
  * 		Redirect the packet to the socket referenced by *map* (of type
  * 		**BPF_MAP_TYPE_SOCKMAP**) at index *key*. Both ingress and
@@ -1708,7 +1708,7 @@ union bpf_attr {
  * 	Return
  * 		**SK_PASS** on success, or **SK_DROP** on error.
  *
- * int bpf_sock_map_update(struct bpf_sock_ops *skops, struct bpf_map *m=
ap, void *key, u64 flags)
+ * long bpf_sock_map_update(struct bpf_sock_ops *skops, struct bpf_map *=
map, void *key, u64 flags)
  * 	Description
  * 		Add an entry to, or update a *map* referencing sockets. The
  * 		*skops* is used as a new value for the entry associated to
@@ -1727,7 +1727,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_xdp_adjust_meta(struct xdp_buff *xdp_md, int delta)
+ * long bpf_xdp_adjust_meta(struct xdp_buff *xdp_md, int delta)
  * 	Description
  * 		Adjust the address pointed by *xdp_md*\ **->data_meta** by
  * 		*delta* (which can be positive or negative). Note that this
@@ -1756,7 +1756,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_perf_event_read_value(struct bpf_map *map, u64 flags, struct =
bpf_perf_event_value *buf, u32 buf_size)
+ * long bpf_perf_event_read_value(struct bpf_map *map, u64 flags, struct=
 bpf_perf_event_value *buf, u32 buf_size)
  * 	Description
  * 		Read the value of a perf event counter, and store it into *buf*
  * 		of size *buf_size*. This helper relies on a *map* of type
@@ -1806,7 +1806,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_perf_prog_read_value(struct bpf_perf_event_data *ctx, struct =
bpf_perf_event_value *buf, u32 buf_size)
+ * long bpf_perf_prog_read_value(struct bpf_perf_event_data *ctx, struct=
 bpf_perf_event_value *buf, u32 buf_size)
  * 	Description
  * 		For en eBPF program attached to a perf event, retrieve the
  * 		value of the event counter associated to *ctx* and store it in
@@ -1817,7 +1817,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_getsockopt(void *bpf_socket, int level, int optname, void *op=
tval, int optlen)
+ * long bpf_getsockopt(void *bpf_socket, int level, int optname, void *o=
ptval, int optlen)
  * 	Description
  * 		Emulate a call to **getsockopt()** on the socket associated to
  * 		*bpf_socket*, which must be a full socket. The *level* at
@@ -1842,7 +1842,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_override_return(struct pt_regs *regs, u64 rc)
+ * long bpf_override_return(struct pt_regs *regs, u64 rc)
  * 	Description
  * 		Used for error injection, this helper uses kprobes to override
  * 		the return value of the probed function, and to set it to *rc*.
@@ -1867,7 +1867,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_sock_ops_cb_flags_set(struct bpf_sock_ops *bpf_sock, int argv=
al)
+ * long bpf_sock_ops_cb_flags_set(struct bpf_sock_ops *bpf_sock, int arg=
val)
  * 	Description
  * 		Attempt to set the value of the **bpf_sock_ops_cb_flags** field
  * 		for the full TCP socket associated to *bpf_sock_ops* to
@@ -1911,7 +1911,7 @@ union bpf_attr {
  * 		be set is returned (which comes down to 0 if all bits were set
  * 		as required).
  *
- * int bpf_msg_redirect_map(struct sk_msg_buff *msg, struct bpf_map *map=
, u32 key, u64 flags)
+ * long bpf_msg_redirect_map(struct sk_msg_buff *msg, struct bpf_map *ma=
p, u32 key, u64 flags)
  * 	Description
  * 		This helper is used in programs implementing policies at the
  * 		socket level. If the message *msg* is allowed to pass (i.e. if
@@ -1925,7 +1925,7 @@ union bpf_attr {
  * 	Return
  * 		**SK_PASS** on success, or **SK_DROP** on error.
  *
- * int bpf_msg_apply_bytes(struct sk_msg_buff *msg, u32 bytes)
+ * long bpf_msg_apply_bytes(struct sk_msg_buff *msg, u32 bytes)
  * 	Description
  * 		For socket policies, apply the verdict of the eBPF program to
  * 		the next *bytes* (number of bytes) of message *msg*.
@@ -1959,7 +1959,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_msg_cork_bytes(struct sk_msg_buff *msg, u32 bytes)
+ * long bpf_msg_cork_bytes(struct sk_msg_buff *msg, u32 bytes)
  * 	Description
  * 		For socket policies, prevent the execution of the verdict eBPF
  * 		program for message *msg* until *bytes* (byte number) have been
@@ -1977,7 +1977,7 @@ union bpf_attr {
  * 	Return
  * 		0
  *
- * int bpf_msg_pull_data(struct sk_msg_buff *msg, u32 start, u32 end, u6=
4 flags)
+ * long bpf_msg_pull_data(struct sk_msg_buff *msg, u32 start, u32 end, u=
64 flags)
  * 	Description
  * 		For socket policies, pull in non-linear data from user space
  * 		for *msg* and set pointers *msg*\ **->data** and *msg*\
@@ -2008,7 +2008,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_bind(struct bpf_sock_addr *ctx, struct sockaddr *addr, int ad=
dr_len)
+ * long bpf_bind(struct bpf_sock_addr *ctx, struct sockaddr *addr, int a=
ddr_len)
  * 	Description
  * 		Bind the socket associated to *ctx* to the address pointed by
  * 		*addr*, of length *addr_len*. This allows for making outgoing
@@ -2026,7 +2026,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_xdp_adjust_tail(struct xdp_buff *xdp_md, int delta)
+ * long bpf_xdp_adjust_tail(struct xdp_buff *xdp_md, int delta)
  * 	Description
  * 		Adjust (move) *xdp_md*\ **->data_end** by *delta* bytes. It is
  * 		possible to both shrink and grow the packet tail.
@@ -2040,7 +2040,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_skb_get_xfrm_state(struct sk_buff *skb, u32 index, struct bpf=
_xfrm_state *xfrm_state, u32 size, u64 flags)
+ * long bpf_skb_get_xfrm_state(struct sk_buff *skb, u32 index, struct bp=
f_xfrm_state *xfrm_state, u32 size, u64 flags)
  * 	Description
  * 		Retrieve the XFRM state (IP transform framework, see also
  * 		**ip-xfrm(8)**) at *index* in XFRM "security path" for *skb*.
@@ -2056,7 +2056,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stack(void *ctx, void *buf, u32 size, u64 flags)
+ * long bpf_get_stack(void *ctx, void *buf, u32 size, u64 flags)
  * 	Description
  * 		Return a user or a kernel stack in bpf program provided buffer.
  * 		To achieve this, the helper needs *ctx*, which is a pointer
@@ -2089,7 +2089,7 @@ union bpf_attr {
  * 		A non-negative value equal to or less than *size* on success,
  * 		or a negative error in case of failure.
  *
- * int bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *to=
, u32 len, u32 start_header)
+ * long bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *t=
o, u32 len, u32 start_header)
  * 	Description
  * 		This helper is similar to **bpf_skb_load_bytes**\ () in that
  * 		it provides an easy way to load *len* bytes from *offset*
@@ -2111,7 +2111,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_fib_lookup(void *ctx, struct bpf_fib_lookup *params, int plen=
, u32 flags)
+ * long bpf_fib_lookup(void *ctx, struct bpf_fib_lookup *params, int ple=
n, u32 flags)
  *	Description
  *		Do FIB lookup in kernel tables using parameters in *params*.
  *		If lookup is successful and result shows packet is to be
@@ -2142,7 +2142,7 @@ union bpf_attr {
  *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
  *		  packet is not forwarded or needs assist from full stack
  *
- * int bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *=
map, void *key, u64 flags)
+ * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map =
*map, void *key, u64 flags)
  *	Description
  *		Add an entry to, or update a sockhash *map* referencing sockets.
  *		The *skops* is used as a new value for the entry associated to
@@ -2161,7 +2161,7 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_redirect_hash(struct sk_msg_buff *msg, struct bpf_map *ma=
p, void *key, u64 flags)
+ * long bpf_msg_redirect_hash(struct sk_msg_buff *msg, struct bpf_map *m=
ap, void *key, u64 flags)
  *	Description
  *		This helper is used in programs implementing policies at the
  *		socket level. If the message *msg* is allowed to pass (i.e. if
@@ -2175,7 +2175,7 @@ union bpf_attr {
  *	Return
  *		**SK_PASS** on success, or **SK_DROP** on error.
  *
- * int bpf_sk_redirect_hash(struct sk_buff *skb, struct bpf_map *map, vo=
id *key, u64 flags)
+ * long bpf_sk_redirect_hash(struct sk_buff *skb, struct bpf_map *map, v=
oid *key, u64 flags)
  *	Description
  *		This helper is used in programs implementing policies at the
  *		skb socket level. If the sk_buff *skb* is allowed to pass (i.e.
@@ -2189,7 +2189,7 @@ union bpf_attr {
  *	Return
  *		**SK_PASS** on success, or **SK_DROP** on error.
  *
- * int bpf_lwt_push_encap(struct sk_buff *skb, u32 type, void *hdr, u32 =
len)
+ * long bpf_lwt_push_encap(struct sk_buff *skb, u32 type, void *hdr, u32=
 len)
  *	Description
  *		Encapsulate the packet associated to *skb* within a Layer 3
  *		protocol header. This header is provided in the buffer at
@@ -2226,7 +2226,7 @@ union bpf_attr {
  *	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_lwt_seg6_store_bytes(struct sk_buff *skb, u32 offset, const v=
oid *from, u32 len)
+ * long bpf_lwt_seg6_store_bytes(struct sk_buff *skb, u32 offset, const =
void *from, u32 len)
  *	Description
  *		Store *len* bytes from address *from* into the packet
  *		associated to *skb*, at *offset*. Only the flags, tag and TLVs
@@ -2241,7 +2241,7 @@ union bpf_attr {
  *	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_lwt_seg6_adjust_srh(struct sk_buff *skb, u32 offset, s32 delt=
a)
+ * long bpf_lwt_seg6_adjust_srh(struct sk_buff *skb, u32 offset, s32 del=
ta)
  *	Description
  *		Adjust the size allocated to TLVs in the outermost IPv6
  *		Segment Routing Header contained in the packet associated to
@@ -2257,7 +2257,7 @@ union bpf_attr {
  *	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_lwt_seg6_action(struct sk_buff *skb, u32 action, void *param,=
 u32 param_len)
+ * long bpf_lwt_seg6_action(struct sk_buff *skb, u32 action, void *param=
, u32 param_len)
  *	Description
  *		Apply an IPv6 Segment Routing action of type *action* to the
  *		packet associated to *skb*. Each action takes a parameter
@@ -2286,7 +2286,7 @@ union bpf_attr {
  *	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_rc_repeat(void *ctx)
+ * long bpf_rc_repeat(void *ctx)
  *	Description
  *		This helper is used in programs implementing IR decoding, to
  *		report a successfully decoded repeat key message. This delays
@@ -2305,7 +2305,7 @@ union bpf_attr {
  *	Return
  *		0
  *
- * int bpf_rc_keydown(void *ctx, u32 protocol, u64 scancode, u32 toggle)
+ * long bpf_rc_keydown(void *ctx, u32 protocol, u64 scancode, u32 toggle=
)
  *	Description
  *		This helper is used in programs implementing IR decoding, to
  *		report a successfully decoded key press with *scancode*,
@@ -2370,7 +2370,7 @@ union bpf_attr {
  *	Return
  *		A pointer to the local storage area.
  *
- * int bpf_sk_select_reuseport(struct sk_reuseport_md *reuse, struct bpf=
_map *map, void *key, u64 flags)
+ * long bpf_sk_select_reuseport(struct sk_reuseport_md *reuse, struct bp=
f_map *map, void *key, u64 flags)
  *	Description
  *		Select a **SO_REUSEPORT** socket from a
  *		**BPF_MAP_TYPE_REUSEPORT_ARRAY** *map*.
@@ -2471,7 +2471,7 @@ union bpf_attr {
  *		result is from *reuse*\ **->socks**\ [] using the hash of the
  *		tuple.
  *
- * int bpf_sk_release(struct bpf_sock *sock)
+ * long bpf_sk_release(struct bpf_sock *sock)
  *	Description
  *		Release the reference held by *sock*. *sock* must be a
  *		non-**NULL** pointer that was returned from
@@ -2479,7 +2479,7 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_map_push_elem(struct bpf_map *map, const void *value, u64 fla=
gs)
+ * long bpf_map_push_elem(struct bpf_map *map, const void *value, u64 fl=
ags)
  * 	Description
  * 		Push an element *value* in *map*. *flags* is one of:
  *
@@ -2489,19 +2489,19 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_map_pop_elem(struct bpf_map *map, void *value)
+ * long bpf_map_pop_elem(struct bpf_map *map, void *value)
  * 	Description
  * 		Pop an element from *map*.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_map_peek_elem(struct bpf_map *map, void *value)
+ * long bpf_map_peek_elem(struct bpf_map *map, void *value)
  * 	Description
  * 		Get an element from *map* without removing it.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_push_data(struct sk_msg_buff *msg, u32 start, u32 len, u6=
4 flags)
+ * long bpf_msg_push_data(struct sk_msg_buff *msg, u32 start, u32 len, u=
64 flags)
  *	Description
  *		For socket policies, insert *len* bytes into *msg* at offset
  *		*start*.
@@ -2517,7 +2517,7 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_msg_pop_data(struct sk_msg_buff *msg, u32 start, u32 len, u64=
 flags)
+ * long bpf_msg_pop_data(struct sk_msg_buff *msg, u32 start, u32 len, u6=
4 flags)
  *	Description
  *		Will remove *len* bytes from a *msg* starting at byte *start*.
  *		This may result in **ENOMEM** errors under certain situations if
@@ -2529,7 +2529,7 @@ union bpf_attr {
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_rc_pointer_rel(void *ctx, s32 rel_x, s32 rel_y)
+ * long bpf_rc_pointer_rel(void *ctx, s32 rel_x, s32 rel_y)
  *	Description
  *		This helper is used in programs implementing IR decoding, to
  *		report a successfully decoded pointer movement.
@@ -2543,7 +2543,7 @@ union bpf_attr {
  *	Return
  *		0
  *
- * int bpf_spin_lock(struct bpf_spin_lock *lock)
+ * long bpf_spin_lock(struct bpf_spin_lock *lock)
  *	Description
  *		Acquire a spinlock represented by the pointer *lock*, which is
  *		stored as part of a value of a map. Taking the lock allows to
@@ -2591,7 +2591,7 @@ union bpf_attr {
  *	Return
  *		0
  *
- * int bpf_spin_unlock(struct bpf_spin_lock *lock)
+ * long bpf_spin_unlock(struct bpf_spin_lock *lock)
  *	Description
  *		Release the *lock* previously locked by a call to
  *		**bpf_spin_lock**\ (\ *lock*\ ).
@@ -2614,7 +2614,7 @@ union bpf_attr {
  *		A **struct bpf_tcp_sock** pointer on success, or **NULL** in
  *		case of failure.
  *
- * int bpf_skb_ecn_set_ce(struct sk_buff *skb)
+ * long bpf_skb_ecn_set_ce(struct sk_buff *skb)
  *	Description
  *		Set ECN (Explicit Congestion Notification) field of IP header
  *		to **CE** (Congestion Encountered) if current value is **ECT**
@@ -2651,7 +2651,7 @@ union bpf_attr {
  *		result is from *reuse*\ **->socks**\ [] using the hash of the
  *		tuple.
  *
- * int bpf_tcp_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_l=
en, struct tcphdr *th, u32 th_len)
+ * long bpf_tcp_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_=
len, struct tcphdr *th, u32 th_len)
  * 	Description
  * 		Check whether *iph* and *th* contain a valid SYN cookie ACK for
  * 		the listening socket in *sk*.
@@ -2666,7 +2666,7 @@ union bpf_attr {
  * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * 		error otherwise.
  *
- * int bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf=
_len, u64 flags)
+ * long bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t bu=
f_len, u64 flags)
  *	Description
  *		Get name of sysctl in /proc/sys/ and copy it into provided by
  *		program buffer *buf* of size *buf_len*.
@@ -2682,7 +2682,7 @@ union bpf_attr {
  *		**-E2BIG** if the buffer wasn't big enough (*buf* will contain
  *		truncated name in this case).
  *
- * int bpf_sysctl_get_current_value(struct bpf_sysctl *ctx, char *buf, s=
ize_t buf_len)
+ * long bpf_sysctl_get_current_value(struct bpf_sysctl *ctx, char *buf, =
size_t buf_len)
  *	Description
  *		Get current value of sysctl as it is presented in /proc/sys
  *		(incl. newline, etc), and copy it as a string into provided
@@ -2701,7 +2701,7 @@ union bpf_attr {
  *		**-EINVAL** if current value was unavailable, e.g. because
  *		sysctl is uninitialized and read returns -EIO for it.
  *
- * int bpf_sysctl_get_new_value(struct bpf_sysctl *ctx, char *buf, size_=
t buf_len)
+ * long bpf_sysctl_get_new_value(struct bpf_sysctl *ctx, char *buf, size=
_t buf_len)
  *	Description
  *		Get new value being written by user space to sysctl (before
  *		the actual write happens) and copy it as a string into
@@ -2718,7 +2718,7 @@ union bpf_attr {
  *
  *		**-EINVAL** if sysctl is being read.
  *
- * int bpf_sysctl_set_new_value(struct bpf_sysctl *ctx, const char *buf,=
 size_t buf_len)
+ * long bpf_sysctl_set_new_value(struct bpf_sysctl *ctx, const char *buf=
, size_t buf_len)
  *	Description
  *		Override new value being written by user space to sysctl with
  *		value provided by program in buffer *buf* of size *buf_len*.
@@ -2735,7 +2735,7 @@ union bpf_attr {
  *
  *		**-EINVAL** if sysctl is being read.
  *
- * int bpf_strtol(const char *buf, size_t buf_len, u64 flags, long *res)
+ * long bpf_strtol(const char *buf, size_t buf_len, u64 flags, long *res=
)
  *	Description
  *		Convert the initial part of the string from buffer *buf* of
  *		size *buf_len* to a long integer according to the given base
@@ -2759,7 +2759,7 @@ union bpf_attr {
  *
  *		**-ERANGE** if resulting value was out of range.
  *
- * int bpf_strtoul(const char *buf, size_t buf_len, u64 flags, unsigned =
long *res)
+ * long bpf_strtoul(const char *buf, size_t buf_len, u64 flags, unsigned=
 long *res)
  *	Description
  *		Convert the initial part of the string from buffer *buf* of
  *		size *buf_len* to an unsigned long integer according to the
@@ -2810,7 +2810,7 @@ union bpf_attr {
  *		**NULL** if not found or there was an error in adding
  *		a new bpf-local-storage.
  *
- * int bpf_sk_storage_delete(struct bpf_map *map, struct bpf_sock *sk)
+ * long bpf_sk_storage_delete(struct bpf_map *map, struct bpf_sock *sk)
  *	Description
  *		Delete a bpf-local-storage from a *sk*.
  *	Return
@@ -2818,7 +2818,7 @@ union bpf_attr {
  *
  *		**-ENOENT** if the bpf-local-storage cannot be found.
  *
- * int bpf_send_signal(u32 sig)
+ * long bpf_send_signal(u32 sig)
  *	Description
  *		Send signal *sig* to the process of the current task.
  *		The signal may be delivered to any of this process's threads.
@@ -2859,7 +2859,7 @@ union bpf_attr {
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
  *
- * int bpf_skb_output(void *ctx, struct bpf_map *map, u64 flags, void *d=
ata, u64 size)
+ * long bpf_skb_output(void *ctx, struct bpf_map *map, u64 flags, void *=
data, u64 size)
  * 	Description
  * 		Write raw *data* blob into a special BPF perf event held by
  * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -2883,21 +2883,21 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_user(void *dst, u32 size, const void *unsafe_ptr)
+ * long bpf_probe_read_user(void *dst, u32 size, const void *unsafe_ptr)
  * 	Description
  * 		Safely attempt to read *size* bytes from user space address
  * 		*unsafe_ptr* and store the data in *dst*.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr=
)
+ * long bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_pt=
r)
  * 	Description
  * 		Safely attempt to read *size* bytes from kernel space address
  * 		*unsafe_ptr* and store the data in *dst*.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_probe_read_user_str(void *dst, u32 size, const void *unsafe_p=
tr)
+ * long bpf_probe_read_user_str(void *dst, u32 size, const void *unsafe_=
ptr)
  * 	Description
  * 		Copy a NUL terminated string from an unsafe user address
  * 		*unsafe_ptr* to *dst*. The *size* should include the
@@ -2941,7 +2941,7 @@ union bpf_attr {
  * 		including the trailing NUL character. On error, a negative
  * 		value.
  *
- * int bpf_probe_read_kernel_str(void *dst, u32 size, const void *unsafe=
_ptr)
+ * long bpf_probe_read_kernel_str(void *dst, u32 size, const void *unsaf=
e_ptr)
  * 	Description
  * 		Copy a NUL terminated string from an unsafe kernel address *unsafe_=
ptr*
  * 		to *dst*. Same semantics as with **bpf_probe_read_user_str**\ () ap=
ply.
@@ -2949,14 +2949,14 @@ union bpf_attr {
  * 		On success, the strictly positive length of the string, including
  * 		the trailing NUL character. On error, a negative value.
  *
- * int bpf_tcp_send_ack(void *tp, u32 rcv_nxt)
+ * long bpf_tcp_send_ack(void *tp, u32 rcv_nxt)
  *	Description
  *		Send out a tcp-ack. *tp* is the in-kernel struct **tcp_sock**.
  *		*rcv_nxt* is the ack_seq to be sent out.
  *	Return
  *		0 on success, or a negative error in case of failure.
  *
- * int bpf_send_signal_thread(u32 sig)
+ * long bpf_send_signal_thread(u32 sig)
  *	Description
  *		Send signal *sig* to the thread corresponding to the current task.
  *	Return
@@ -2976,7 +2976,7 @@ union bpf_attr {
  *	Return
  *		The 64 bit jiffies
  *
- * int bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *bu=
f, u32 size, u64 flags)
+ * long bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *b=
uf, u32 size, u64 flags)
  *	Description
  *		For an eBPF program attached to a perf event, retrieve the
  *		branch records (**struct perf_branch_entry**) associated to *ctx*
@@ -2995,7 +2995,7 @@ union bpf_attr {
  *
  *		**-ENOENT** if architecture does not support branch records.
  *
- * int bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_in=
fo *nsdata, u32 size)
+ * long bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_i=
nfo *nsdata, u32 size)
  *	Description
  *		Returns 0 on success, values for *pid* and *tgid* as seen from the c=
urrent
  *		*namespace* will be returned in *nsdata*.
@@ -3007,7 +3007,7 @@ union bpf_attr {
  *
  *		**-ENOENT** if pidns does not exists for the current task.
  *
- * int bpf_xdp_output(void *ctx, struct bpf_map *map, u64 flags, void *d=
ata, u64 size)
+ * long bpf_xdp_output(void *ctx, struct bpf_map *map, u64 flags, void *=
data, u64 size)
  *	Description
  *		Write raw *data* blob into a special BPF perf event held by
  *		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -3062,7 +3062,7 @@ union bpf_attr {
  * 	Return
  * 		The id is returned or 0 in case the id could not be retrieved.
  *
- * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags=
)
+ * long bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flag=
s)
  *	Description
  *		Assign the *sk* to the *skb*. When combined with appropriate
  *		routing configuration to receive the packet towards the socket,
@@ -3097,7 +3097,7 @@ union bpf_attr {
  * 	Return
  * 		Current *ktime*.
  *
- * int bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size,=
 const void *data, u32 data_len)
+ * long bpf_seq_printf(struct seq_file *m, const char *fmt, u32 fmt_size=
, const void *data, u32 data_len)
  * 	Description
  * 		**bpf_seq_printf**\ () uses seq_file **seq_printf**\ () to print
  * 		out the format string.
@@ -3126,7 +3126,7 @@ union bpf_attr {
  *
  *		**-EOVERFLOW** if an overflow happened: The same object will be trie=
d again.
  *
- * int bpf_seq_write(struct seq_file *m, const void *data, u32 len)
+ * long bpf_seq_write(struct seq_file *m, const void *data, u32 len)
  * 	Description
  * 		**bpf_seq_write**\ () uses seq_file **seq_write**\ () to write the =
data.
  * 		The *m* represents the seq_file. The *data* and *len* represent the
@@ -3221,7 +3221,7 @@ union bpf_attr {
  *	Return
  *		Requested value, or 0, if flags are not recognized.
  *
- * int bpf_csum_level(struct sk_buff *skb, u64 level)
+ * long bpf_csum_level(struct sk_buff *skb, u64 level)
  * 	Description
  * 		Change the skbs checksum level by one layer up or down, or
  * 		reset it entirely to none in order to have the stack perform
--=20
2.24.1

