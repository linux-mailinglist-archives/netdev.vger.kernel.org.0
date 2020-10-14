Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5DA28E275
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgJNOqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 10:46:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50552 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgJNOqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 10:46:16 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09EEdhkE022213
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 07:46:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=ATkRQGLm4zLVf7AvWVIMRIj4Ei6EozvH5D3eO5UBWOw=;
 b=cz7PV9tv4smhs6RuR14yLG88r/ET6T1FbBeUIQrdBYKsq9zgOLREZ5/hZntJxE6MhS4x
 zfOakWvUCtegwIG3om3mNUVS8plVrSZM5I4iPjLRzhKTSN8x1ie2CKVxR3Wqo9xB2qFr
 X8JXPaAMMGnNniMTiocPkaPfX0uorRV/AzA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 345ff5nqgd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 07:46:14 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 07:46:13 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 13C663701B20; Wed, 14 Oct 2020 07:46:12 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH net v3] net: fix pos incrementment in ipv6_route_seq_next
Date:   Wed, 14 Oct 2020 07:46:12 -0700
Message-ID: <20201014144612.2245396-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_08:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010140107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
tried to fix the issue where seq_file pos is not increased
if a NULL element is returned with seq_ops->next(). See bug
  https://bugzilla.kernel.org/show_bug.cgi?id=3D206283
The commit effectively does:
  - increase pos for all seq_ops->start()
  - increase pos for all seq_ops->next()

For ipv6_route, increasing pos for all seq_ops->next() is correct.
But increasing pos for seq_ops->start() is not correct
since pos is used to determine how many items to skip during
seq_ops->start():
  iter->skip =3D *pos;
seq_ops->start() just fetches the *current* pos item.
The item can be skipped only after seq_ops->show() which essentially
is the beginning of seq_ops->next().

For example, I have 7 ipv6 route entries,
  root@arch-fb-vm1:~/net-next dd if=3D/proc/net/ipv6_route bs=3D4096
  00000000000000000000000000000000 40 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
  fe800000000000000000000000000000 40 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
  00000000000000000000000000000001 80 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
  fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
  ff000000000000000000000000000000 08 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 00000100 00000004 00000000 00000001     eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
  0+1 records in
  0+1 records out
  1050 bytes (1.0 kB, 1.0 KiB) copied, 0.00707908 s, 148 kB/s
  root@arch-fb-vm1:~/net-next

In the above, I specify buffer size 4096, so all records can be returned
to user space with a single trip to the kernel.

If I use buffer size 128, since each record size is 149, internally
kernel seq_read() will read 149 into its internal buffer and return the data
to user space in two read() syscalls. Then user read() syscall will trigger
next seq_ops->start(). Since the current implementation increased pos even
for seq_ops->start(), it will skip record #2, #4 and #6, assuming the first
record is #1.

  root@arch-fb-vm1:~/net-next dd if=3D/proc/net/ipv6_route bs=3D128
  00000000000000000000000000000000 40 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
  fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00 0=
0000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
4+1 records in
4+1 records out
600 bytes copied, 0.00127758 s, 470 kB/s

To fix the problem, create a fake pos pointer so seq_ops->start()
won't actually increase seq_file pos. With this fix, the
above `dd` command with `bs=3D128` will show correct result.

Fixes: 4fc427e05158 ("ipv6_route_seq_next should increase position index")
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Suggested-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 net/ipv6/ip6_fib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Changelog:
 v2 -> v3:
  - initialize local variable "p" to avoid potential syzbot complaint. (Eri=
c)
 v1 -> v2:
  - instead of push increment of *pos in ipv6_route_seq_next() for
    seq_ops->next() only. Add a face pos pointer in seq_ops->start()
    and use it when calling ipv6_route_seq_next().

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 141c0a4c569a..605cdd38a919 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2622,8 +2622,10 @@ static void *ipv6_route_seq_start(struct seq_file *s=
eq, loff_t *pos)
 	iter->skip =3D *pos;
=20
 	if (iter->tbl) {
+		loff_t p =3D 0;
+
 		ipv6_route_seq_setup_walk(iter, net);
-		return ipv6_route_seq_next(seq, NULL, pos);
+		return ipv6_route_seq_next(seq, NULL, &p);
 	} else {
 		return NULL;
 	}
--=20
2.24.1

