Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC8D261E46
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732371AbgIHTu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:50:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729767AbgIHPus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 11:50:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088FoVir009242
        for <netdev@vger.kernel.org>; Tue, 8 Sep 2020 08:50:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=sX1lDjbtcr4lFFYhSncUWs+xJYEs/aYPfXw8eZepxVs=;
 b=UjvyJC7b5jv1Lmbp+xNeXAtvX0nXU0xBdA7Ryhd5Jig/nDniKPRr7fY+M29eiFpxgyIb
 xOGINHeiDQf/MelAhvgR7AhAPyvhardzg4NHj0BHywhkazXSCEg8zF0MtHpBtKaxY/Zj
 qh+x6AdK7QQ3Y9Z+C5HEp2VRAeU7owLu1Zw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33ct5tt4cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:50:34 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 08:50:33 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 6426C3700B8D; Tue,  8 Sep 2020 08:50:32 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next v2 1/2] bpf: permit map_ptr arithmetic with opcode add and offset 0
Date:   Tue, 8 Sep 2020 08:50:32 -0700
Message-ID: <20200908155032.1502579-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200908155032.1502450-1-yhs@fb.com>
References: <20200908155032.1502450-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_08:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 malwarescore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009080151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 41c48f3a98231 ("bpf: Support access
to bpf map fields") added support to access map fields
with CORE support. For example,

            struct bpf_map {
                    __u32 max_entries;
            } __attribute__((preserve_access_index));

            struct bpf_array {
                    struct bpf_map map;
                    __u32 elem_size;
            } __attribute__((preserve_access_index));

            struct {
                    __uint(type, BPF_MAP_TYPE_ARRAY);
                    __uint(max_entries, 4);
                    __type(key, __u32);
                    __type(value, __u32);
            } m_array SEC(".maps");

            SEC("cgroup_skb/egress")
            int cg_skb(void *ctx)
            {
                    struct bpf_array *array =3D (struct bpf_array *)&m_ar=
ray;

                    /* .. array->map.max_entries .. */
            }

In kernel, bpf_htab has similar structure,

	    struct bpf_htab {
		    struct bpf_map map;
                    ...
            }

In the above cg_skb(), to access array->map.max_entries, with CORE, the c=
lang will
generate two builtin's.
            base =3D &m_array;
            /* access array.map */
            map_addr =3D __builtin_preserve_struct_access_info(base, 0, 0=
);
            /* access array.map.max_entries */
            max_entries_addr =3D __builtin_preserve_struct_access_info(ma=
p_addr, 0, 0);
	    max_entries =3D *max_entries_addr;

In the current llvm, if two builtin's are in the same function or
in the same function after inlining, the compiler is smart enough to chai=
n
them together and generates like below:
            base =3D &m_array;
            max_entries =3D *(base + reloc_offset); /* reloc_offset =3D 0=
 in this case */
and we are fine.

But if we force no inlining for one of functions in test_map_ptr() selfte=
st, e.g.,
check_default(), the above two __builtin_preserve_* will be in two differ=
ent
functions. In this case, we will have code like:
   func check_hash():
            reloc_offset_map =3D 0;
            base =3D &m_array;
            map_base =3D base + reloc_offset_map;
            check_default(map_base, ...)
   func check_default(map_base, ...):
            max_entries =3D *(map_base + reloc_offset_max_entries);

In kernel, map_ptr (CONST_PTR_TO_MAP) does not allow any arithmetic.
The above "map_base =3D base + reloc_offset_map" will trigger a verifier =
failure.
  ; VERIFY(check_default(&hash->map, map));
  0: (18) r7 =3D 0xffffb4fe8018a004
  2: (b4) w1 =3D 110
  3: (63) *(u32 *)(r7 +0) =3D r1
   R1_w=3DinvP110 R7_w=3Dmap_value(id=3D0,off=3D4,ks=3D4,vs=3D8,imm=3D0) =
R10=3Dfp0
  ; VERIFY_TYPE(BPF_MAP_TYPE_HASH, check_hash);
  4: (18) r1 =3D 0xffffb4fe8018a000
  6: (b4) w2 =3D 1
  7: (63) *(u32 *)(r1 +0) =3D r2
   R1_w=3Dmap_value(id=3D0,off=3D0,ks=3D4,vs=3D8,imm=3D0) R2_w=3DinvP1 R7=
_w=3Dmap_value(id=3D0,off=3D4,ks=3D4,vs=3D8,imm=3D0) R10=3Dfp0
  8: (b7) r2 =3D 0
  9: (18) r8 =3D 0xffff90bcb500c000
  11: (18) r1 =3D 0xffff90bcb500c000
  13: (0f) r1 +=3D r2
  R1 pointer arithmetic on map_ptr prohibited

To fix the issue, let us permit map_ptr + 0 arithmetic which will
result in exactly the same map_ptr.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b4e9c56b8b32..814bc6c1ad16 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5317,6 +5317,10 @@ static int adjust_ptr_min_max_vals(struct bpf_veri=
fier_env *env,
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
 	case CONST_PTR_TO_MAP:
+		/* smin_val represents the known value */
+		if (known && smin_val =3D=3D 0 && opcode =3D=3D BPF_ADD)
+			break;
+		/* fall-through */
 	case PTR_TO_PACKET_END:
 	case PTR_TO_SOCKET:
 	case PTR_TO_SOCKET_OR_NULL:
--=20
2.24.1

