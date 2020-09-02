Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749EB25B773
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 01:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgIBXxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 19:53:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23252 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbgIBXxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 19:53:44 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082NdbVI010361
        for <netdev@vger.kernel.org>; Wed, 2 Sep 2020 16:53:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=F3JhPxINOUTmiCbYAerWNL3PZOiQD4M4hPm8GnCfEZc=;
 b=gkyA+sF/RoVKlsn853CIuYcPWD+BtKDq5l/odRULTyYdVEqr96pds2jpmns5QCmoW6NK
 oKoEEcHn/eFSLKN8vbbWoBhfn7dMLvoKjljIIzLygGaWy2qcDlgPSyfE9P7/UhsA/OyT
 AEh1QT8PhoO8j4H9mwzWz30VOEROpu+IA/U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33ae5ujpxb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 16:53:42 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Sep 2020 16:53:41 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7C6003704F6E; Wed,  2 Sep 2020 16:53:40 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf 1/2] bpf: do not use bucket_lock for hashmap iterator
Date:   Wed, 2 Sep 2020 16:53:40 -0700
Message-ID: <20200902235340.2001375-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200902235340.2001300-1-yhs@fb.com>
References: <20200902235340.2001300-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_17:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 suspectscore=8 impostorscore=0 mlxlogscore=566 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020222
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, for hashmap, the bpf iterator will grab a bucket lock, a
spinlock, before traversing the elements in the bucket. This can ensure
all bpf visted elements are valid. But this mechanism may cause
deadlock if update/deletion happens to the same bucket of the
visited map in the program. For example, if we added bpf_map_update_elem(=
)
call to the same visited element in selftests bpf_iter_bpf_hash_map.c,
we will have the following deadlock:

  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  WARNING: possible recursive locking detected
  5.9.0-rc1+ #841 Not tainted
  --------------------------------------------
  test_progs/1750 is trying to acquire lock:
  ffff9a5bb73c5e70 (&htab->buckets[i].raw_lock){....}-{2:2}, at: htab_map=
_update_elem+0x1cf/0x410

  but task is already holding lock:
  ffff9a5bb73c5e20 (&htab->buckets[i].raw_lock){....}-{2:2}, at: bpf_hash=
_map_seq_find_next+0x94/0x120

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(&htab->buckets[i].raw_lock);
    lock(&htab->buckets[i].raw_lock);

   *** DEADLOCK ***
   ...
  Call Trace:
   dump_stack+0x78/0xa0
   __lock_acquire.cold.74+0x209/0x2e3
   lock_acquire+0xba/0x380
   ? htab_map_update_elem+0x1cf/0x410
   ? __lock_acquire+0x639/0x20c0
   _raw_spin_lock_irqsave+0x3b/0x80
   ? htab_map_update_elem+0x1cf/0x410
   htab_map_update_elem+0x1cf/0x410
   ? lock_acquire+0xba/0x380
   bpf_prog_ad6dab10433b135d_dump_bpf_hash_map+0x88/0xa9c
   ? find_held_lock+0x34/0xa0
   bpf_iter_run_prog+0x81/0x16e
   __bpf_hash_map_seq_show+0x145/0x180
   bpf_seq_read+0xff/0x3d0
   vfs_read+0xad/0x1c0
   ksys_read+0x5f/0xe0
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  ...

The bucket_lock first grabbed in seq_ops->next() called by bpf_seq_read()=
,
and then grabbed again in htab_map_update_elem() in the bpf program, caus=
ing
deadlocks.

Actually, we do not need bucket_lock here, we can just use rcu_read_lock(=
)
similar to netlink iterator where the rcu_read_{lock,unlock} likes below:
 seq_ops->start():
     rcu_read_lock();
 seq_ops->next():
     rcu_read_unlock();
     /* next element */
     rcu_read_lock();
 seq_ops->stop();
     rcu_read_unlock();

Compared to old bucket_lock mechanism, if concurrent updata/delete happen=
s,
we may visit stale elements, miss some elements, or repeat some elements.
I think this is a reasonable compromise. For users wanting to avoid
stale, missing/repeated accesses, bpf_map batch access syscall interface
can be used.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/hashtab.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 78dfff6a501b..7df28a45c66b 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1622,7 +1622,6 @@ struct bpf_iter_seq_hash_map_info {
 	struct bpf_map *map;
 	struct bpf_htab *htab;
 	void *percpu_value_buf; // non-zero means percpu hash
-	unsigned long flags;
 	u32 bucket_id;
 	u32 skip_elems;
 };
@@ -1632,7 +1631,6 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash=
_map_info *info,
 			   struct htab_elem *prev_elem)
 {
 	const struct bpf_htab *htab =3D info->htab;
-	unsigned long flags =3D info->flags;
 	u32 skip_elems =3D info->skip_elems;
 	u32 bucket_id =3D info->bucket_id;
 	struct hlist_nulls_head *head;
@@ -1656,19 +1654,18 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_ha=
sh_map_info *info,
=20
 		/* not found, unlock and go to the next bucket */
 		b =3D &htab->buckets[bucket_id++];
-		htab_unlock_bucket(htab, b, flags);
+		rcu_read_unlock();
 		skip_elems =3D 0;
 	}
=20
 	for (i =3D bucket_id; i < htab->n_buckets; i++) {
 		b =3D &htab->buckets[i];
-		flags =3D htab_lock_bucket(htab, b);
+		rcu_read_lock();
=20
 		count =3D 0;
 		head =3D &b->head;
 		hlist_nulls_for_each_entry_rcu(elem, n, head, hash_node) {
 			if (count >=3D skip_elems) {
-				info->flags =3D flags;
 				info->bucket_id =3D i;
 				info->skip_elems =3D count;
 				return elem;
@@ -1676,7 +1673,7 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash=
_map_info *info,
 			count++;
 		}
=20
-		htab_unlock_bucket(htab, b, flags);
+		rcu_read_unlock();
 		skip_elems =3D 0;
 	}
=20
@@ -1754,14 +1751,10 @@ static int bpf_hash_map_seq_show(struct seq_file =
*seq, void *v)
=20
 static void bpf_hash_map_seq_stop(struct seq_file *seq, void *v)
 {
-	struct bpf_iter_seq_hash_map_info *info =3D seq->private;
-
 	if (!v)
 		(void)__bpf_hash_map_seq_show(seq, NULL);
 	else
-		htab_unlock_bucket(info->htab,
-				   &info->htab->buckets[info->bucket_id],
-				   info->flags);
+		rcu_read_unlock();
 }
=20
 static int bpf_iter_init_hash_map(void *priv_data,
--=20
2.24.1

