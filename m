Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AB443AFBB
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbhJZKJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235127AbhJZKJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:09:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982C7C061745;
        Tue, 26 Oct 2021 03:07:15 -0700 (PDT)
Date:   Tue, 26 Oct 2021 12:07:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1635242832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fDUks0Y5u8e/cyrEnxYnECXBLNj7/1eacolyIstH2xA=;
        b=0mloKTcluxG1Y/NJw/3JJZP7nlzWzH0I9ZHAChDZQYpxVyK0ybtnjbscysan1f8Zn2J1kD
        spdbA0tpXLdg6hQyTLkJp6RPmveg3hpSVYNMksGBZOTRZ0UbYvla6vLhiHuEjHDexB54Q6
        z12cCyhm6y76w57DHbH6T8UUqLpQfUBs51UbMp9IUzTxVTkOjKJA2O+NB0scr/GURxZC7A
        SyP/louU0U6PpP739cZUniU3+m8l5wKT1pS/ACK2ioFqKhP2Tm11l2D4bHpJ3ZnfI5y0j8
        v+VNaJSqgrVZkssmjn4pg15AqIWYoM7+C3VWKP85V/Qw+Wi8clDElSA7dmGqGQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1635242832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fDUks0Y5u8e/cyrEnxYnECXBLNj7/1eacolyIstH2xA=;
        b=fRJnj9EvFWdzEok59wHJqiWk4KDaMIDD6uHo5HUW1MbYsuKCMuQmOni9usQakcpxocWvMT
        rh8H9zo/hE3W6QAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next v3] net: sched: gred: dynamically allocate
 tc_gred_qopt_offload
Message-ID: <20211026100711.nalhttf6mbe6sudx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=46rom: Arnd Bergmann <arnd@arndb.de>

The tc_gred_qopt_offload structure has grown too big to be on the
stack for 32-bit architectures after recent changes.

net/sched/sch_gred.c:903:13: error: stack frame size (1180) exceeds limit (=
1024) in 'gred_destroy' [-Werror,-Wframe-larger-than]
net/sched/sch_gred.c:310:13: error: stack frame size (1212) exceeds limit (=
1024) in 'gred_offload' [-Werror,-Wframe-larger-than]

Use dynamic allocation per qdisc to avoid this.

Fixes: 50dc9a8572aa ("net: sched: Merge Qdisc::bstats and Qdisc::cpu_bstats=
 data types")
Fixes: 67c9e6270f30 ("net: sched: Protect Qdisc::bstats with u64_stats")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v2=E2=80=A6v3:
 - drop not needed return statement in gred_offload() (Jakub)
 - use kzalloc(sizeof(*table->opt) in gred_init() (Eric)
 - Make the allocation conditional on ->ndo_setup_tc (Jakub).

 net/sched/sch_gred.c | 50 ++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 72de08ef8335e..1073c76d05c45 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -56,6 +56,7 @@ struct gred_sched {
 	u32 		DPs;
 	u32 		def;
 	struct red_vars wred_set;
+	struct tc_gred_qopt_offload *opt;
 };
=20
 static inline int gred_wred_mode(struct gred_sched *table)
@@ -311,42 +312,43 @@ static void gred_offload(struct Qdisc *sch, enum tc_g=
red_command command)
 {
 	struct gred_sched *table =3D qdisc_priv(sch);
 	struct net_device *dev =3D qdisc_dev(sch);
-	struct tc_gred_qopt_offload opt =3D {
-		.command	=3D command,
-		.handle		=3D sch->handle,
-		.parent		=3D sch->parent,
-	};
+	struct tc_gred_qopt_offload *opt =3D table->opt;
=20
 	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
 		return;
=20
+	memset(opt, 0, sizeof(*opt));
+	opt->command =3D command;
+	opt->handle =3D sch->handle;
+	opt->parent =3D sch->parent;
+
 	if (command =3D=3D TC_GRED_REPLACE) {
 		unsigned int i;
=20
-		opt.set.grio_on =3D gred_rio_mode(table);
-		opt.set.wred_on =3D gred_wred_mode(table);
-		opt.set.dp_cnt =3D table->DPs;
-		opt.set.dp_def =3D table->def;
+		opt->set.grio_on =3D gred_rio_mode(table);
+		opt->set.wred_on =3D gred_wred_mode(table);
+		opt->set.dp_cnt =3D table->DPs;
+		opt->set.dp_def =3D table->def;
=20
 		for (i =3D 0; i < table->DPs; i++) {
 			struct gred_sched_data *q =3D table->tab[i];
=20
 			if (!q)
 				continue;
-			opt.set.tab[i].present =3D true;
-			opt.set.tab[i].limit =3D q->limit;
-			opt.set.tab[i].prio =3D q->prio;
-			opt.set.tab[i].min =3D q->parms.qth_min >> q->parms.Wlog;
-			opt.set.tab[i].max =3D q->parms.qth_max >> q->parms.Wlog;
-			opt.set.tab[i].is_ecn =3D gred_use_ecn(q);
-			opt.set.tab[i].is_harddrop =3D gred_use_harddrop(q);
-			opt.set.tab[i].probability =3D q->parms.max_P;
-			opt.set.tab[i].backlog =3D &q->backlog;
+			opt->set.tab[i].present =3D true;
+			opt->set.tab[i].limit =3D q->limit;
+			opt->set.tab[i].prio =3D q->prio;
+			opt->set.tab[i].min =3D q->parms.qth_min >> q->parms.Wlog;
+			opt->set.tab[i].max =3D q->parms.qth_max >> q->parms.Wlog;
+			opt->set.tab[i].is_ecn =3D gred_use_ecn(q);
+			opt->set.tab[i].is_harddrop =3D gred_use_harddrop(q);
+			opt->set.tab[i].probability =3D q->parms.max_P;
+			opt->set.tab[i].backlog =3D &q->backlog;
 		}
-		opt.set.qstats =3D &sch->qstats;
+		opt->set.qstats =3D &sch->qstats;
 	}
=20
-	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_GRED, &opt);
+	dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_GRED, opt);
 }
=20
 static int gred_offload_dump_stats(struct Qdisc *sch)
@@ -731,6 +733,7 @@ static int gred_change(struct Qdisc *sch, struct nlattr=
 *opt,
 static int gred_init(struct Qdisc *sch, struct nlattr *opt,
 		     struct netlink_ext_ack *extack)
 {
+	struct gred_sched *table =3D qdisc_priv(sch);
 	struct nlattr *tb[TCA_GRED_MAX + 1];
 	int err;
=20
@@ -754,6 +757,12 @@ static int gred_init(struct Qdisc *sch, struct nlattr =
*opt,
 		sch->limit =3D qdisc_dev(sch)->tx_queue_len
 		             * psched_mtu(qdisc_dev(sch));
=20
+	if (qdisc_dev(sch)->netdev_ops->ndo_setup_tc) {
+		table->opt =3D kzalloc(sizeof(*table->opt), GFP_KERNEL);
+		if (!table->opt)
+			return -ENOMEM;
+	}
+
 	return gred_change_table_def(sch, tb[TCA_GRED_DPS], extack);
 }
=20
@@ -910,6 +919,7 @@ static void gred_destroy(struct Qdisc *sch)
 			gred_destroy_vq(table->tab[i]);
 	}
 	gred_offload(sch, TC_GRED_DESTROY);
+	kfree(table->opt);
 }
=20
 static struct Qdisc_ops gred_qdisc_ops __read_mostly =3D {
--=20
2.33.1

