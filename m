Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8EBC0458
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 13:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfI0L2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 07:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0L2f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 07:28:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B537309BF12;
        Fri, 27 Sep 2019 11:28:34 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-249.ams2.redhat.com [10.36.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F2AE5D9C3;
        Fri, 27 Sep 2019 11:28:27 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [RFC PATCH 11/13] vsock: add 'transport_hg' to handle g2h\h2g transports
Date:   Fri, 27 Sep 2019 13:27:01 +0200
Message-Id: <20190927112703.17745-12-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
References: <20190927112703.17745-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 27 Sep 2019 11:28:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VMCI transport provides both g2h and h2g behaviors in a single
transport.
We are able to set (or not) the g2h behavior, detecting if we
are in a VMware guest (or not), but the h2g feature is always set.
This prevents to load other h2g transports while we are in a
VMware guest.

This patch adds a new 'transport_hg' to handle this case, reducing
the priority of transports that provide both g2h and h2g
behaviors. A transport that has g2h and h2g features, can be
bypassed by a transport that has only the h2g feature.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c52203fe52c4..c5f46b8242ce 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -134,6 +134,8 @@ static struct proto vsock_proto = {
 static const struct vsock_transport *transport_h2g;
 /* Transport used for guest->host communication */
 static const struct vsock_transport *transport_g2h;
+/* Transport used for both host->guest and guest->host communication */
+static const struct vsock_transport *transport_hg;
 /* Transport used for DGRAM communication */
 static const struct vsock_transport *transport_dgram;
 static DEFINE_MUTEX(vsock_register_mutex);
@@ -402,10 +404,13 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		vsk->transport = transport_dgram;
 		break;
 	case SOCK_STREAM:
-		if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
+		if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST) {
 			vsk->transport = transport_h2g;
-		else
+			if (!vsk->transport)
+				vsk->transport = transport_hg;
+		} else {
 			vsk->transport = transport_g2h;
+		}
 		break;
 	default:
 		return -ESOCKTNOSUPPORT;
@@ -423,7 +428,7 @@ static bool vsock_find_cid(unsigned int cid)
 	if (transport_g2h && cid == transport_g2h->get_local_cid())
 		return true;
 
-	if (transport_h2g && cid == VMADDR_CID_HOST)
+	if ((transport_h2g || transport_hg) && cid == VMADDR_CID_HOST)
 		return true;
 
 	return false;
@@ -1997,6 +2002,8 @@ static long vsock_dev_do_ioctl(struct file *filp,
 			cid = transport_g2h->get_local_cid();
 		else if (transport_h2g)
 			cid = transport_h2g->get_local_cid();
+		else if (transport_hg)
+			cid = transport_hg->get_local_cid();
 
 		if (put_user(cid, p) != 0)
 			retval = -EFAULT;
@@ -2093,13 +2100,14 @@ EXPORT_SYMBOL_GPL(vsock_core_get_transport);
 
 int vsock_core_register(const struct vsock_transport *t)
 {
-	const struct vsock_transport *t_h2g, *t_g2h, *t_dgram;
+	const struct vsock_transport *t_h2g, *t_hg, *t_g2h, *t_dgram;
 	int err = mutex_lock_interruptible(&vsock_register_mutex);
 
 	if (err)
 		return err;
 
 	t_h2g = transport_h2g;
+	t_hg = transport_hg;
 	t_g2h = transport_g2h;
 	t_dgram = transport_dgram;
 
@@ -2107,7 +2115,14 @@ int vsock_core_register(const struct vsock_transport *t)
 	 * same transport. We are able to set the G2H feature only if we are
 	 * in a VMware guest, but we are not able to do the same for the host.
 	 */
-	if (t->features & VSOCK_TRANSPORT_F_H2G) {
+	if ((t->features & VSOCK_TRANSPORT_F_H2G) &&
+	    (t->features & VSOCK_TRANSPORT_F_G2H)) {
+		if (t_hg) {
+			err = -EBUSY;
+			goto err_busy;
+		}
+		t_hg = t;
+	} else if (t->features & VSOCK_TRANSPORT_F_H2G) {
 		if (t_h2g) {
 			err = -EBUSY;
 			goto err_busy;
@@ -2132,6 +2147,7 @@ int vsock_core_register(const struct vsock_transport *t)
 	}
 
 	transport_h2g = t_h2g;
+	transport_hg = t_hg;
 	transport_g2h = t_g2h;
 	transport_dgram = t_dgram;
 
@@ -2151,6 +2167,9 @@ void vsock_core_unregister(const struct vsock_transport *t)
 	if (transport_h2g == t)
 		transport_h2g = NULL;
 
+	if (transport_hg == t)
+		transport_hg = NULL;
+
 	if (transport_g2h == t)
 		transport_g2h = NULL;
 
-- 
2.21.0

