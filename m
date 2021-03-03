Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5725532C44F
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391566AbhCDAMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:45 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9523 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350353AbhCCNBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 08:01:04 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603f88620001>; Wed, 03 Mar 2021 05:00:18 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 13:00:17 +0000
Received: from c-234-232-1-005.mtl.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Mar 2021 13:00:16 +0000
From:   Oz Shlomo <ozsh@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: [PATCH nf-next] netfilter: flowtable: separate replace, destroy and stats to different workqueues
Date:   Wed, 3 Mar 2021 14:59:53 +0200
Message-ID: <20210303125953.11911-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614776418; bh=MUHuLCjXX3t/8ImY1TmDnYdZ4Z9dE7G/7v165qPlICY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type;
        b=lfE/CnP/PdWHF8yaLIFHtA83ibqKFguCAPzF6elqvD51P1IBsvk3JMqcE7v/aJOWM
         6zoH/8t2BWfWUKptF/7Z4HosTR7rEPzlqLhPf0aVVVCReAo+oHs6Var+Us5tK9glcv
         +wki6acSTe4mmrsimqT+M2BPngzWgBBHoRE+KPlkSD6mqRGryDGgNPiyw+unotmsuK
         2erPfLxiFZuCfFlk1kiCwVTivCewajyHAyD23hrSLRr9DOPZiq0QiMTRY9DhEul9ky
         eOTH+8Fd8vYXM/i2RGwVUVc9Eua6k0r95xDLo2s8Zu5YVjpG7T0UZxxlCwkZt1X4Fj
         65i0u7tucJn5g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the flow table offload replace, destroy and stats work items are
executed on a single workqueue. As such, DESTROY and STATS commands may
be backloged after a burst of REPLACE work items. This scenario can bloat
up memory and may cause active connections to age.

Instatiate add, del and stats workqueues to avoid backlogs of non-dependent
actions. Provide sysfs control over the workqueue attributes, allowing
userspace applications to control the workqueue cpumask.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 net/netfilter/nf_flow_table_offload.c | 44 ++++++++++++++++++++++++++++---=
----
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_=
table_offload.c
index 2a6993fa40d7..1b979c8b3ba0 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -13,7 +13,9 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
=20
-static struct workqueue_struct *nf_flow_offload_wq;
+static struct workqueue_struct *nf_flow_offload_add_wq;
+static struct workqueue_struct *nf_flow_offload_del_wq;
+static struct workqueue_struct *nf_flow_offload_stats_wq;
=20
 struct flow_offload_work {
 	struct list_head	list;
@@ -826,7 +828,12 @@ static void flow_offload_work_handler(struct work_stru=
ct *work)
=20
 static void flow_offload_queue_work(struct flow_offload_work *offload)
 {
-	queue_work(nf_flow_offload_wq, &offload->work);
+	if (offload->cmd =3D=3D FLOW_CLS_REPLACE)
+		queue_work(nf_flow_offload_add_wq, &offload->work);
+	else if (offload->cmd =3D=3D FLOW_CLS_DESTROY)
+		queue_work(nf_flow_offload_del_wq, &offload->work);
+	else
+		queue_work(nf_flow_offload_stats_wq, &offload->work);
 }
=20
 static struct flow_offload_work *
@@ -898,8 +905,11 @@ void nf_flow_offload_stats(struct nf_flowtable *flowta=
ble,
=20
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
-	if (nf_flowtable_hw_offload(flowtable))
-		flush_workqueue(nf_flow_offload_wq);
+	if (nf_flowtable_hw_offload(flowtable)) {
+		flush_workqueue(nf_flow_offload_add_wq);
+		flush_workqueue(nf_flow_offload_del_wq);
+		flush_workqueue(nf_flow_offload_stats_wq);
+	}
 }
=20
 static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
@@ -1011,15 +1021,33 @@ int nf_flow_table_offload_setup(struct nf_flowtable=
 *flowtable,
=20
 int nf_flow_table_offload_init(void)
 {
-	nf_flow_offload_wq  =3D alloc_workqueue("nf_flow_table_offload",
-					      WQ_UNBOUND, 0);
-	if (!nf_flow_offload_wq)
+	nf_flow_offload_add_wq  =3D alloc_workqueue("nf_ft_offload_add",
+						  WQ_UNBOUND | WQ_SYSFS, 0);
+	if (!nf_flow_offload_add_wq)
 		return -ENOMEM;
=20
+	nf_flow_offload_del_wq  =3D alloc_workqueue("nf_ft_offload_del",
+						  WQ_UNBOUND | WQ_SYSFS, 0);
+	if (!nf_flow_offload_del_wq)
+		goto err_del_wq;
+
+	nf_flow_offload_stats_wq  =3D alloc_workqueue("nf_ft_offload_stats",
+						    WQ_UNBOUND | WQ_SYSFS, 0);
+	if (!nf_flow_offload_stats_wq)
+		goto err_stats_wq;
+
 	return 0;
+
+err_stats_wq:
+	destroy_workqueue(nf_flow_offload_del_wq);
+err_del_wq:
+	destroy_workqueue(nf_flow_offload_add_wq);
+	return -ENOMEM;
 }
=20
 void nf_flow_table_offload_exit(void)
 {
-	destroy_workqueue(nf_flow_offload_wq);
+	destroy_workqueue(nf_flow_offload_add_wq);
+	destroy_workqueue(nf_flow_offload_del_wq);
+	destroy_workqueue(nf_flow_offload_stats_wq);
 }
--=20
1.8.3.1

