Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028A8282375
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 12:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgJCKCP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 3 Oct 2020 06:02:15 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:48367 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbgJCKCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 06:02:15 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-fajacoYON_SSdHYDcB0WXA-1; Sat, 03 Oct 2020 06:02:10 -0400
X-MC-Unique: fajacoYON_SSdHYDcB0WXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A6171005E5A;
        Sat,  3 Oct 2020 10:02:08 +0000 (UTC)
Received: from bahia.lan (ovpn-112-192.ams2.redhat.com [10.36.112.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1BBC10027AB;
        Sat,  3 Oct 2020 10:02:03 +0000 (UTC)
Subject: [PATCH v3 2/3] vhost: Use vhost_get_used_size() in
 vhost_vring_set_addr()
From:   Greg Kurz <groug@kaod.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Date:   Sat, 03 Oct 2020 12:02:03 +0200
Message-ID: <160171932300.284610.11846106312938909461.stgit@bahia.lan>
In-Reply-To: <160171888144.284610.4628526949393013039.stgit@bahia.lan>
References: <160171888144.284610.4628526949393013039.stgit@bahia.lan>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The open-coded computation of the used size doesn't take the event
into account when the VIRTIO_RING_F_EVENT_IDX feature is present.
Fix that by using vhost_get_used_size().

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 drivers/vhost/vhost.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c3b49975dc28..9d2c225fb518 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1519,8 +1519,7 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 		/* Also validate log access for used ring if enabled. */
 		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
 			!log_access_ok(vq->log_base, a.log_guest_addr,
-				sizeof *vq->used +
-				vq->num * sizeof *vq->used->ring))
+				       vhost_get_used_size(vq, vq->num)))
 			return -EINVAL;
 	}
 


