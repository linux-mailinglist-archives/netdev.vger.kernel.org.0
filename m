Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DEF6D6278
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbjDDNPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbjDDNPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:15:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925A635B5
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680614039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4MlJ8boSBAN33TyWlK9MdNtuYbz66i2Pl/D7dBKo3iE=;
        b=MD1dTh6nUzasx7INnVVzUsIBMmzvud1lZez9LCM5z39VxnTZO3A0n74WTgB+uMb0t2EwMi
        Gv15cZHFAEukj3xezSoW98uuN4cah5rVUHhtNilNi8hb74i6G2xwwlbzb2X/ioaVL4RXEw
        NcgOFW458wnop+Wjxqr3Y3uaxKAABFM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-HRxuw45-MMqE_W4nziqL8w-1; Tue, 04 Apr 2023 09:13:59 -0400
X-MC-Unique: HRxuw45-MMqE_W4nziqL8w-1
Received: by mail-qt1-f199.google.com with SMTP id b11-20020ac87fcb000000b003e37d72d532so22027799qtk.18
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 06:13:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680614038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MlJ8boSBAN33TyWlK9MdNtuYbz66i2Pl/D7dBKo3iE=;
        b=qOdRAfpdlqjdISPQph3qnAKHKCAR+cfputq+nJJ6KSq6OQCNefiA+mCtKm/L7SL1i5
         MdhjnRhPc4PVKxaO33ljnnbzeoGz1XXSBkX6Q5MX+1IbBey1I0N1SI/rGe4nZgK3S638
         xdQAU1kKBbv487goFS1aU5e829azpmm/vC1GC7nTLdCXUS1E4MP7ZSBcZm267XbGVdQP
         Jwq7S0jonmfkcxyeBWBN5nIURDmIn8LA8oqf6JAwu3Hji24SfyGguptUeAe0uHIKg/FN
         w9HHl7FJ5qdv6XRKr0tPmcXvEuqTDEfV6VLMbWlzU0H1eYLat6Dgmo8pVBeDrpYNO9sF
         bNDw==
X-Gm-Message-State: AAQBX9d6WRd84ebzIcSTcs0qXooPN1lCenTaa9v8dgCrNwwof/M0FXb4
        Jat7V3dqhiUsUvN0zquovfuCmnrLt4y4pLfUjiL29H3APdLuok0lUJqK58lTKi7BzSGUkoRHV/L
        Xe+8tqfTGEGkFBnOIYYCwYhjn
X-Received: by 2002:a05:622a:452:b0:3e2:4280:bc5d with SMTP id o18-20020a05622a045200b003e24280bc5dmr2577060qtx.23.1680614038313;
        Tue, 04 Apr 2023 06:13:58 -0700 (PDT)
X-Google-Smtp-Source: AKy350YCSJM7sVlkvzpoiu/gc9FXBYw+oU6Dc67qLTb9UimmcbBb5Gh6pKFgktvtOVRk6+HyH/s72g==
X-Received: by 2002:a05:622a:452:b0:3e2:4280:bc5d with SMTP id o18-20020a05622a045200b003e24280bc5dmr2577024qtx.23.1680614038001;
        Tue, 04 Apr 2023 06:13:58 -0700 (PDT)
Received: from step1.redhat.com (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id z5-20020ac87105000000b003e64303bd2dsm2841837qto.63.2023.04.04.06.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:13:57 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     eperezma@redhat.com, stefanha@redhat.com,
        Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v5 2/9] vhost-vdpa: use bind_mm/unbind_mm device callbacks
Date:   Tue,  4 Apr 2023 15:13:19 +0200
Message-Id: <20230404131326.44403-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404131326.44403-1-sgarzare@redhat.com>
References: <20230404131326.44403-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the user call VHOST_SET_OWNER ioctl and the vDPA device
has `use_va` set to true, let's call the bind_mm callback.
In this way we can bind the device to the user address space
and directly use the user VA.

The unbind_mm callback is called during the release after
stopping the device.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v4:
    - added new switch after vhost_dev_ioctl() [Jason]
    v3:
    - added `case VHOST_SET_OWNER` in vhost_vdpa_unlocked_ioctl() [Jason]
    v2:
    - call the new unbind_mm callback during the release [Jason]
    - avoid to call bind_mm callback after the reset, since the device
      is not detaching it now during the reset

 drivers/vhost/vdpa.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7be9d9d8f01c..3824c249612f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -219,6 +219,28 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
 	return vdpa_reset(vdpa);
 }
 
+static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	if (!vdpa->use_va || !ops->bind_mm)
+		return 0;
+
+	return ops->bind_mm(vdpa, v->vdev.mm);
+}
+
+static void vhost_vdpa_unbind_mm(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	if (!vdpa->use_va || !ops->unbind_mm)
+		return;
+
+	ops->unbind_mm(vdpa);
+}
+
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -716,6 +738,17 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		break;
 	}
 
+	if (r)
+		goto out;
+
+	switch (cmd) {
+	case VHOST_SET_OWNER:
+		r = vhost_vdpa_bind_mm(v);
+		if (r)
+			vhost_dev_reset_owner(d, NULL);
+		break;
+	}
+out:
 	mutex_unlock(&d->mutex);
 	return r;
 }
@@ -1287,6 +1320,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
+	vhost_vdpa_unbind_mm(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_cleanup(v);
 	mutex_unlock(&d->mutex);
-- 
2.39.2

