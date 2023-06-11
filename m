Return-Path: <netdev+bounces-9915-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F00072B286
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 17:45:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98F7C1C20963
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 15:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A5AC146;
	Sun, 11 Jun 2023 15:45:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3195D441D
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 15:45:54 +0000 (UTC)
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B320A10A
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:45:52 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-cKLjY-K5MyCtakIDyyyiKA-1; Sun, 11 Jun 2023 11:45:49 -0400
X-MC-Unique: cKLjY-K5MyCtakIDyyyiKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEF9C3C025A2;
	Sun, 11 Jun 2023 15:45:48 +0000 (UTC)
Received: from hog.localdomain (unknown [10.45.224.17])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 019B040CFD00;
	Sun, 11 Jun 2023 15:45:47 +0000 (UTC)
From: Sabrina Dubroca <sd@queasysnail.net>
To: netdev@vger.kernel.org
Cc: Sabrina Dubroca <sd@queasysnail.net>,
	kuba@kernel.org
Subject: [PATCH net-next] netdevsim: add dummy macsec offload
Date: Sun, 11 Jun 2023 17:45:33 +0200
Message-Id: <0b87a0b7f9faf82de05c5689fbe8b8b4a83aa25d.1686494112.git.sd@queasysnail.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When the kernel is compiled with MACsec support, add the
NETIF_F_HW_MACSEC feature to netdevsim devices and implement
macsec_ops.

To allow easy testing of failure from the device, support is limited
to 3 SecY's per netdevsim device, and 1 RXSC per SecY.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/netdevsim/Makefile    |   4 +
 drivers/net/netdevsim/macsec.c    | 355 ++++++++++++++++++++++++++++++
 drivers/net/netdevsim/netdev.c    |   3 +
 drivers/net/netdevsim/netdevsim.h |  34 +++
 4 files changed, 396 insertions(+)
 create mode 100644 drivers/net/netdevsim/macsec.c

diff --git a/drivers/net/netdevsim/Makefile b/drivers/net/netdevsim/Makefil=
e
index 5735e5b1a2cb..f8de93bc5f5b 100644
--- a/drivers/net/netdevsim/Makefile
+++ b/drivers/net/netdevsim/Makefile
@@ -17,3 +17,7 @@ endif
 ifneq ($(CONFIG_PSAMPLE),)
 netdevsim-objs +=3D psample.o
 endif
+
+ifneq ($(CONFIG_MACSEC),)
+netdevsim-objs +=3D macsec.o
+endif
diff --git a/drivers/net/netdevsim/macsec.c b/drivers/net/netdevsim/macsec.=
c
new file mode 100644
index 000000000000..355ba2f313df
--- /dev/null
+++ b/drivers/net/netdevsim/macsec.c
@@ -0,0 +1,355 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <net/macsec.h>
+#include "netdevsim.h"
+
+static int nsim_macsec_find_secy(struct netdevsim *ns, sci_t sci)
+{
+=09int i;
+
+=09for (i =3D 0; i < NSIM_MACSEC_MAX_SECY_COUNT; i++) {
+=09=09if (ns->macsec.nsim_secy[i].sci =3D=3D sci)
+=09=09=09return i;
+=09}
+
+=09return -1;
+}
+
+static int nsim_macsec_find_rxsc(struct nsim_secy *ns_secy, sci_t sci)
+{
+=09int i;
+
+=09for (i =3D 0; i < NSIM_MACSEC_MAX_RXSC_COUNT; i++) {
+=09=09if (ns_secy->nsim_rxsc[i].sci =3D=3D sci)
+=09=09=09return i;
+=09}
+
+=09return -1;
+}
+
+static int nsim_macsec_add_secy(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09int idx;
+
+=09if (ns->macsec.nsim_secy_count =3D=3D NSIM_MACSEC_MAX_SECY_COUNT)
+=09=09return -ENOSPC;
+
+=09for (idx =3D 0; idx < NSIM_MACSEC_MAX_SECY_COUNT; idx++) {
+=09=09if (!ns->macsec.nsim_secy[idx].used)
+=09=09=09break;
+=09}
+
+=09if (idx =3D=3D NSIM_MACSEC_MAX_SECY_COUNT)
+=09=09netdev_err(ctx->netdev, "%s: nsim_secy_count not full but all SecYs =
used\n",
+=09=09=09   __func__);
+
+=09netdev_dbg(ctx->netdev, "%s: adding new secy with sci %08llx at index %=
d\n",
+=09=09   __func__, be64_to_cpu(ctx->secy->sci), idx);
+=09ns->macsec.nsim_secy[idx].used =3D true;
+=09ns->macsec.nsim_secy[idx].nsim_rxsc_count =3D 0;
+=09ns->macsec.nsim_secy[idx].sci =3D ctx->secy->sci;
+=09ns->macsec.nsim_secy_count++;
+
+=09return 0;
+}
+
+static int nsim_macsec_upd_secy(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+
+=09netdev_dbg(ctx->netdev, "%s: updating secy with sci %08llx at index %d\=
n",
+=09=09   __func__, be64_to_cpu(ctx->secy->sci), idx);
+
+=09return 0;
+}
+
+static int nsim_macsec_del_secy(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+
+=09netdev_dbg(ctx->netdev, "%s: removing SecY with SCI %08llx at index %d\=
n",
+=09=09   __func__, be64_to_cpu(ctx->secy->sci), idx);
+
+=09ns->macsec.nsim_secy[idx].used =3D false;
+=09memset(&ns->macsec.nsim_secy[idx], 0, sizeof(ns->macsec.nsim_secy[idx])=
);
+=09ns->macsec.nsim_secy_count--;
+
+=09return 0;
+}
+
+static int nsim_macsec_add_rxsc(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09struct nsim_secy *secy;
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+=09secy =3D &ns->macsec.nsim_secy[idx];
+
+=09if (secy->nsim_rxsc_count =3D=3D NSIM_MACSEC_MAX_RXSC_COUNT)
+=09=09return -ENOSPC;
+
+=09for (idx =3D 0; idx < NSIM_MACSEC_MAX_RXSC_COUNT; idx++) {
+=09=09if (!secy->nsim_rxsc[idx].used)
+=09=09=09break;
+=09}
+
+=09if (idx =3D=3D NSIM_MACSEC_MAX_RXSC_COUNT)
+=09=09netdev_err(ctx->netdev, "%s: nsim_rxsc_count not full but all RXSCs =
used\n",
+=09=09=09   __func__);
+
+=09netdev_dbg(ctx->netdev, "%s: adding new rxsc with sci %08llx at index %=
d\n",
+=09=09   __func__, be64_to_cpu(ctx->rx_sc->sci), idx);
+=09secy->nsim_rxsc[idx].used =3D true;
+=09secy->nsim_rxsc[idx].sci =3D ctx->rx_sc->sci;
+=09secy->nsim_rxsc_count++;
+
+=09return 0;
+}
+
+static int nsim_macsec_upd_rxsc(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09struct nsim_secy *secy;
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+=09secy =3D &ns->macsec.nsim_secy[idx];
+
+=09idx =3D nsim_macsec_find_rxsc(secy, ctx->rx_sc->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in RXSC table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->rx_sc->sci));
+=09=09return -ENOENT;
+=09}
+
+=09netdev_dbg(ctx->netdev, "%s: updating RXSC with sci %08llx at index %d\=
n",
+=09=09   __func__, be64_to_cpu(ctx->rx_sc->sci), idx);
+
+=09return 0;
+}
+
+static int nsim_macsec_del_rxsc(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09struct nsim_secy *secy;
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+=09secy =3D &ns->macsec.nsim_secy[idx];
+
+=09idx =3D nsim_macsec_find_rxsc(secy, ctx->rx_sc->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in RXSC table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->rx_sc->sci));
+=09=09return -ENOENT;
+=09}
+
+=09netdev_dbg(ctx->netdev, "%s: removing RXSC with sci %08llx at index %d\=
n",
+=09=09   __func__, be64_to_cpu(ctx->rx_sc->sci), idx);
+
+=09secy->nsim_rxsc[idx].used =3D false;
+=09memset(&secy->nsim_rxsc[idx], 0, sizeof(secy->nsim_rxsc[idx]));
+=09secy->nsim_rxsc_count--;
+
+=09return 0;
+}
+
+static int nsim_macsec_add_rxsa(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09struct nsim_secy *secy;
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+=09secy =3D &ns->macsec.nsim_secy[idx];
+
+=09idx =3D nsim_macsec_find_rxsc(secy, ctx->sa.rx_sa->sc->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in RXSC table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->sa.rx_sa->sc->sci));
+=09=09return -ENOENT;
+=09}
+
+=09netdev_dbg(ctx->netdev, "%s: RXSC with sci %08llx, AN %u\n",
+=09=09   __func__, be64_to_cpu(ctx->sa.rx_sa->sc->sci), ctx->sa.assoc_num)=
;
+
+=09return 0;
+}
+
+static int nsim_macsec_upd_rxsa(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09struct nsim_secy *secy;
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+=09secy =3D &ns->macsec.nsim_secy[idx];
+
+=09idx =3D nsim_macsec_find_rxsc(secy, ctx->sa.rx_sa->sc->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in RXSC table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->sa.rx_sa->sc->sci));
+=09=09return -ENOENT;
+=09}
+
+=09netdev_dbg(ctx->netdev, "%s: RXSC with sci %08llx, AN %u\n",
+=09=09   __func__, be64_to_cpu(ctx->sa.rx_sa->sc->sci), ctx->sa.assoc_num)=
;
+
+=09return 0;
+}
+
+static int nsim_macsec_del_rxsa(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09struct nsim_secy *secy;
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+=09secy =3D &ns->macsec.nsim_secy[idx];
+
+=09idx =3D nsim_macsec_find_rxsc(secy, ctx->sa.rx_sa->sc->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in RXSC table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->sa.rx_sa->sc->sci));
+=09=09return -ENOENT;
+=09}
+
+=09netdev_dbg(ctx->netdev, "%s: RXSC with sci %08llx, AN %u\n",
+=09=09   __func__, be64_to_cpu(ctx->sa.rx_sa->sc->sci), ctx->sa.assoc_num)=
;
+
+=09return 0;
+}
+
+static int nsim_macsec_add_txsa(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09struct nsim_secy *secy;
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+=09secy =3D &ns->macsec.nsim_secy[idx];
+
+=09netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
+=09=09   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
+
+=09return 0;
+}
+
+static int nsim_macsec_upd_txsa(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09struct nsim_secy *secy;
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+=09secy =3D &ns->macsec.nsim_secy[idx];
+
+=09netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
+=09=09   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
+
+=09return 0;
+}
+
+static int nsim_macsec_del_txsa(struct macsec_context *ctx)
+{
+=09struct netdevsim *ns =3D netdev_priv(ctx->netdev);
+=09struct nsim_secy *secy;
+=09int idx;
+
+=09idx =3D nsim_macsec_find_secy(ns, ctx->secy->sci);
+=09if (idx < 0) {
+=09=09netdev_err(ctx->netdev, "%s: sci %08llx not found in secy table\n",
+=09=09=09   __func__, be64_to_cpu(ctx->secy->sci));
+=09=09return -ENOENT;
+=09}
+=09secy =3D &ns->macsec.nsim_secy[idx];
+
+=09netdev_dbg(ctx->netdev, "%s: SECY with sci %08llx, AN %u\n",
+=09=09   __func__, be64_to_cpu(ctx->secy->sci), ctx->sa.assoc_num);
+
+=09return 0;
+}
+
+static const struct macsec_ops nsim_macsec_ops =3D {
+=09.mdo_add_secy =3D nsim_macsec_add_secy,
+=09.mdo_upd_secy =3D nsim_macsec_upd_secy,
+=09.mdo_del_secy =3D nsim_macsec_del_secy,
+=09.mdo_add_rxsc =3D nsim_macsec_add_rxsc,
+=09.mdo_upd_rxsc =3D nsim_macsec_upd_rxsc,
+=09.mdo_del_rxsc =3D nsim_macsec_del_rxsc,
+=09.mdo_add_rxsa =3D nsim_macsec_add_rxsa,
+=09.mdo_upd_rxsa =3D nsim_macsec_upd_rxsa,
+=09.mdo_del_rxsa =3D nsim_macsec_del_rxsa,
+=09.mdo_add_txsa =3D nsim_macsec_add_txsa,
+=09.mdo_upd_txsa =3D nsim_macsec_upd_txsa,
+=09.mdo_del_txsa =3D nsim_macsec_del_txsa,
+};
+
+void nsim_macsec_init(struct netdevsim *ns)
+{
+=09ns->netdev->macsec_ops =3D &nsim_macsec_ops;
+=09ns->netdev->features |=3D NETIF_F_HW_MACSEC;
+=09memset(&ns->macsec, 0, sizeof(ns->macsec));
+}
+
+void nsim_macsec_teardown(struct netdevsim *ns)
+{
+}
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.=
c
index 35fa1ca98671..0c8daeb0d62b 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -304,6 +304,7 @@ static int nsim_init_netdevsim(struct netdevsim *ns)
 =09if (err)
 =09=09goto err_utn_destroy;
=20
+=09nsim_macsec_init(ns);
 =09nsim_ipsec_init(ns);
=20
 =09err =3D register_netdevice(ns->netdev);
@@ -314,6 +315,7 @@ static int nsim_init_netdevsim(struct netdevsim *ns)
=20
 err_ipsec_teardown:
 =09nsim_ipsec_teardown(ns);
+=09nsim_macsec_teardown(ns);
 =09nsim_bpf_uninit(ns);
 err_utn_destroy:
 =09rtnl_unlock();
@@ -374,6 +376,7 @@ void nsim_destroy(struct netdevsim *ns)
 =09rtnl_lock();
 =09unregister_netdevice(dev);
 =09if (nsim_dev_port_is_pf(ns->nsim_dev_port)) {
+=09=09nsim_macsec_teardown(ns);
 =09=09nsim_ipsec_teardown(ns);
 =09=09nsim_bpf_uninit(ns);
 =09}
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netd=
evsim.h
index 7d8ed8d8df5c..7be98b7dcca9 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -23,6 +23,7 @@
 #include <net/devlink.h>
 #include <net/udp_tunnel.h>
 #include <net/xdp.h>
+#include <net/macsec.h>
=20
 #define DRV_NAME=09"netdevsim"
=20
@@ -52,6 +53,25 @@ struct nsim_ipsec {
 =09u32 ok;
 };
=20
+#define NSIM_MACSEC_MAX_SECY_COUNT 3
+#define NSIM_MACSEC_MAX_RXSC_COUNT 1
+struct nsim_rxsc {
+=09sci_t sci;
+=09bool used;
+};
+
+struct nsim_secy {
+=09sci_t sci;
+=09struct nsim_rxsc nsim_rxsc[NSIM_MACSEC_MAX_RXSC_COUNT];
+=09u8 nsim_rxsc_count;
+=09bool used;
+};
+
+struct nsim_macsec {
+=09struct nsim_secy nsim_secy[NSIM_MACSEC_MAX_SECY_COUNT];
+=09u8 nsim_secy_count;
+};
+
 struct nsim_ethtool_pauseparam {
 =09bool rx;
 =09bool tx;
@@ -93,6 +113,7 @@ struct netdevsim {
=20
 =09bool bpf_map_accept;
 =09struct nsim_ipsec ipsec;
+=09struct nsim_macsec macsec;
 =09struct {
 =09=09u32 inject_error;
 =09=09u32 sleep;
@@ -366,6 +387,19 @@ static inline bool nsim_ipsec_tx(struct netdevsim *ns,=
 struct sk_buff *skb)
 }
 #endif
=20
+#if IS_ENABLED(CONFIG_MACSEC)
+void nsim_macsec_init(struct netdevsim *ns);
+void nsim_macsec_teardown(struct netdevsim *ns);
+#else
+static inline void nsim_macsec_init(struct netdevsim *ns)
+{
+}
+
+static inline void nsim_macsec_teardown(struct netdevsim *ns)
+{
+}
+#endif
+
 struct nsim_bus_dev {
 =09struct device dev;
 =09struct list_head list;
--=20
2.40.1


