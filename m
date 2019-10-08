Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82532D0164
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 21:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbfJHTqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 15:46:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729647AbfJHTqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 15:46:00 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x98Jj5TM013388
        for <netdev@vger.kernel.org>; Tue, 8 Oct 2019 12:45:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=HydwzqXo6v8irjSiYEXaUDDGIzdO0k9kBEh1T5hG0Dw=;
 b=C/U2aKuratK4IPe0nY+GVhZYi0QZdhvwgriah+xUQQgsl8ARCHqEJ1jth/A10AdN/1Gs
 Vo9BL2SNckWWIXkq/5uWPFP/xOc6/3PZg9YCQST3+YgHO//tXIBPwD25DVZZwlS/0P+7
 Vwl7dKu+C3niaW+A9hCNkYT1CD1+EV/fz24= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgvc7swvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 12:45:59 -0700
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 8 Oct 2019 12:45:58 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 871DD8618E0; Tue,  8 Oct 2019 12:45:58 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 1/2] bpf: track contents of read-only maps as scalars
Date:   Tue, 8 Oct 2019 12:45:47 -0700
Message-ID: <20191008194548.2344473-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191008194548.2344473-1-andriin@fb.com>
References: <20191008194548.2344473-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-08_07:2019-10-08,2019-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910080151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maps that are read-only both from BPF program side and user space side
have their contents constant, so verifier can track referenced values
precisely and use that knowledge for dead code elimination, branch
pruning, etc. This patch teaches BPF verifier how to do this.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/verifier.c | 58 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ffc3e53f5300..1e4e4bd64ca5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2739,6 +2739,42 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
 	reg->smax_value = reg->umax_value;
 }
 
+static bool bpf_map_is_rdonly(const struct bpf_map *map)
+{
+	return (map->map_flags & BPF_F_RDONLY_PROG) &&
+	       ((map->map_flags & BPF_F_RDONLY) || map->frozen);
+}
+
+static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
+{
+	void *ptr;
+	u64 addr;
+	int err;
+
+	err = map->ops->map_direct_value_addr(map, &addr, off + size);
+	if (err)
+		return err;
+	ptr = (void *)addr + off;
+
+	switch (size) {
+	case sizeof(u8):
+		*val = (u64)*(u8 *)ptr;
+		break;
+	case sizeof(u16):
+		*val = (u64)*(u16 *)ptr;
+		break;
+	case sizeof(u32):
+		*val = (u64)*(u32 *)ptr;
+		break;
+	case sizeof(u64):
+		*val = *(u64 *)ptr;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /* check whether memory at (regno + off) is accessible for t = (read | write)
  * if t==write, value_regno is a register which value is stored into memory
  * if t==read, value_regno is a register which will receive the value from memory
@@ -2776,9 +2812,27 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		if (err)
 			return err;
 		err = check_map_access(env, regno, off, size, false);
-		if (!err && t == BPF_READ && value_regno >= 0)
-			mark_reg_unknown(env, regs, value_regno);
+		if (!err && t == BPF_READ && value_regno >= 0) {
+			struct bpf_map *map = reg->map_ptr;
+
+			/* if map is read-only, track its contents as scalars */
+			if (tnum_is_const(reg->var_off) &&
+			    bpf_map_is_rdonly(map) &&
+			    map->ops->map_direct_value_addr) {
+				int map_off = off + reg->var_off.value;
+				u64 val = 0;
 
+				err = bpf_map_direct_read(map, map_off, size,
+							  &val);
+				if (err)
+					return err;
+
+				regs[value_regno].type = SCALAR_VALUE;
+				__mark_reg_known(&regs[value_regno], val);
+			} else {
+				mark_reg_unknown(env, regs, value_regno);
+			}
+		}
 	} else if (reg->type == PTR_TO_CTX) {
 		enum bpf_reg_type reg_type = SCALAR_VALUE;
 
-- 
2.17.1

