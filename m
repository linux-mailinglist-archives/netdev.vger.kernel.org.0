Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E02F5D197A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfJIUPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:15:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55162 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729865AbfJIUPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:15:11 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x99K7aP5031754
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 13:15:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=SGfSGZXyMNUpFbdsgogFBw/OH+Ele0g7eMFQCeXulHM=;
 b=Bqdzmo4wEi/0KNk6ND1w/4xEDQKW3ZoNZRkKQrYbh0bbwVUPpIW8WIBQcxDO92gHfupD
 1XHjeGzj1IALVk4RNUXY3nxw0QQDdOEiVJRflcvcXAScuH44OBlkjcp8fjtV+gXwnWFp
 DafUU+qEYG6UlfQSMLUIA5DKvhYc4U/djJQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vgr0grt9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:15:09 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 9 Oct 2019 13:15:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 7CA5A86191B; Wed,  9 Oct 2019 13:15:03 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 1/2] bpf: track contents of read-only maps as scalars
Date:   Wed, 9 Oct 2019 13:14:57 -0700
Message-ID: <20191009201458.2679171-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009201458.2679171-1-andriin@fb.com>
References: <20191009201458.2679171-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_09:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=8 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090160
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
 kernel/bpf/verifier.c | 57 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ffc3e53f5300..b818fed3208d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2739,6 +2739,41 @@ static void coerce_reg_to_size(struct bpf_reg_state *reg, int size)
 	reg->smax_value = reg->umax_value;
 }
 
+static bool bpf_map_is_rdonly(const struct bpf_map *map)
+{
+	return (map->map_flags & BPF_F_RDONLY_PROG) && map->frozen;
+}
+
+static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
+{
+	void *ptr;
+	u64 addr;
+	int err;
+
+	err = map->ops->map_direct_value_addr(map, &addr, off);
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
@@ -2776,9 +2811,27 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
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

