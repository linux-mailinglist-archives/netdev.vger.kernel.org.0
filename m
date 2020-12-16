Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062252DBB9F
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgLPGvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:51:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbgLPGva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:51:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qec1O4Z5wG2P97LtrHHfJdT6ZAPwYeTAYdFi8D5KI2U=;
        b=iblKrY+N0k/7fmVYg7MGMD92VC6m0K9a1M/MMdrGL/9DdlGONl4CZ1VS0lohXAv6QkOyI+
        P8SKMnYzQAfxjATULaxFf7kN7mWJm4NBNbWdUabAViMp4V/IEHIU7Ue5KlxCKMA5DrlaEI
        dQ0hLrFfmkiqXXsLq7PCHQjyg3gwdqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-PMZrlp1qPJiIOCCbzR0k-A-1; Wed, 16 Dec 2020 01:50:02 -0500
X-MC-Unique: PMZrlp1qPJiIOCCbzR0k-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BDBA107ACE3;
        Wed, 16 Dec 2020 06:50:01 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCE6A10013C1;
        Wed, 16 Dec 2020 06:49:56 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 13/21] vhost-vdpa: introduce uAPI to get the number of address spaces
Date:   Wed, 16 Dec 2020 14:48:10 +0800
Message-Id: <20201216064818.48239-14-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the uAPI for getting the number of address
spaces supported by this vDPA device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 3 +++
 include/uapi/linux/vhost.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 1ba5901b28e7..bff8aa214f78 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -540,6 +540,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		r = copy_to_user(argp, &v->vdpa->ngroups,
 				 sizeof(v->vdpa->ngroups));
 		break;
+	case VHOST_VDPA_GET_AS_NUM:
+		r = copy_to_user(argp, &v->vdpa->nas, sizeof(v->vdpa->nas));
+		break;
 	case VHOST_SET_LOG_BASE:
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 8a4e6e426bbf..8762911a3cb8 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -148,4 +148,6 @@
 /* Get the number of virtqueue groups. */
 #define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x79, unsigned int)
 
+/* Get the number of address spaces. */
+#define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
 #endif
-- 
2.25.1

