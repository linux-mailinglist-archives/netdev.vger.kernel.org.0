Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42A527AE0C
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 14:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgI1Mlc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Sep 2020 08:41:32 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:50555 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726393AbgI1Mlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 08:41:31 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 08:41:31 EDT
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-mF0ZdjI4MHKeMhrLaFIPOw-1; Mon, 28 Sep 2020 08:35:19 -0400
X-MC-Unique: mF0ZdjI4MHKeMhrLaFIPOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D96C5708B;
        Mon, 28 Sep 2020 12:35:18 +0000 (UTC)
Received: from bahia.lan (ovpn-112-195.ams2.redhat.com [10.36.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 415965C1BB;
        Mon, 28 Sep 2020 12:35:05 +0000 (UTC)
Subject: [PATCH] vhost: Don't call vq_access_ok() when using IOTLB
From:   Greg Kurz <groug@kaod.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Date:   Mon, 28 Sep 2020 14:35:04 +0200
Message-ID: <160129650442.480158.12085353517983890660.stgit@bahia.lan>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=groug@kaod.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the IOTLB device is enabled, the vring addresses we get from
userspace are GIOVAs. It is thus wrong to pass them to vq_access_ok()
which only takes HVAs. The IOTLB map is likely empty at this stage,
so there isn't much that can be done with these GIOVAs. Access validation
will be performed at IOTLB prefetch time anyway.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1883084
Fixes: 6b1e6cc7855b ("vhost: new device IOTLB API")
Cc: jasowang@redhat.com
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Greg Kurz <groug@kaod.org>
---
 drivers/vhost/vhost.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b45519ca66a7..6296e33df31d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1509,7 +1509,10 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 	 * If it is not, we don't as size might not have been setup.
 	 * We will verify when backend is configured. */
 	if (vq->private_data) {
-		if (!vq_access_ok(vq, vq->num,
+		/* If an IOTLB device is present, the vring addresses are
+		 * GIOVAs. Access will be validated during IOTLB prefetch. */
+		if (!vq->iotlb &&
+		    !vq_access_ok(vq, vq->num,
 			(void __user *)(unsigned long)a.desc_user_addr,
 			(void __user *)(unsigned long)a.avail_user_addr,
 			(void __user *)(unsigned long)a.used_user_addr))


