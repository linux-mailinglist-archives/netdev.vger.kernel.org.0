Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100FF13A20E
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgANH05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:26:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2054 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728877AbgANH05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:26:57 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00E7OhPS030011
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:26:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Jn/vM3BLOJYAU6XhXbI0LB+2RbDZv9JnGkvvY5EkGck=;
 b=ag/i49CMnINMjLcgl4ia8Q2krEfqkbWySH2wGFsu+TEdMKWeIY1P7KOfJrY0cSgv3ZE4
 jRmJW3jvSUfEGztzV+qTGfR+OZQ6qgDblQpKZwOagwdDTsUVKWqVY+wzsZOY1hyLxrru
 e1e341tBiV+VHHvTwqACZX4o8RKQAYV8NG8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2xfar4cdj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:26:56 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 23:26:55 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id DE34D29440CF; Mon, 13 Jan 2020 23:26:47 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: Fix seq_show for BPF_MAP_TYPE_STRUCT_OPS
Date:   Mon, 13 Jan 2020 23:26:47 -0800
Message-ID: <20200114072647.3188298-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_01:2020-01-13,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=707 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=38
 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001140064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using bpf_struct_ops_map_lookup_elem() which is
not implemented, bpf_struct_ops_map_seq_show_elem() should
also use bpf_struct_ops_map_sys_lookup_elem() which does
an inplace update to the value.  The change allocates
a value to pass to bpf_struct_ops_map_sys_lookup_elem().

[root@arch-fb-vm1 bpf]# cat /sys/fs/bpf/dctcp
{{{1}},BPF_STRUCT_OPS_STATE_INUSE,{{00000000df93eebc,00000000df93eebc},0,2, ...

Fixes: 85d33df357b6 ("bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/bpf_struct_ops.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index ddf48f49914b..8ad1c9ea26b2 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -496,14 +496,20 @@ static void bpf_struct_ops_map_seq_show_elem(struct bpf_map *map, void *key,
 					     struct seq_file *m)
 {
 	void *value;
+	int err;
 
-	value = bpf_struct_ops_map_lookup_elem(map, key);
+	value = kmalloc(map->value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		return;
 
-	btf_type_seq_show(btf_vmlinux, map->btf_vmlinux_value_type_id,
-			  value, m);
-	seq_puts(m, "\n");
+	err = bpf_struct_ops_map_sys_lookup_elem(map, key, value);
+	if (!err) {
+		btf_type_seq_show(btf_vmlinux, map->btf_vmlinux_value_type_id,
+				  value, m);
+		seq_puts(m, "\n");
+	}
+
+	kfree(value);
 }
 
 static void bpf_struct_ops_map_free(struct bpf_map *map)
-- 
2.17.1

