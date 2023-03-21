Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C250D6C360D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjCUPnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjCUPnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:43:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC12D166C5
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679413358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QASJhsJ+hdJk3WLN6OfGqjuqBH1Q3bTytFBvValx858=;
        b=bRpPSBlpXRWBUBRFa8kgCgMpMLo9T0Imx+bPFs/NXLDXe2M7KDeDWzlFMm0PS4V5FD4xak
        xyZyfhJS/ZDwEoxoyya3JexdqGpvN+sAj5zwLQVUNNA8Ao1tQ8aSPyD26dsrO5AiNDpkQ+
        Xv3kRYe2z4VEw6puiMYcR8Po67zu2iI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-Evmh3U9lPEq5VQEBzG_U8Q-1; Tue, 21 Mar 2023 11:42:37 -0400
X-MC-Unique: Evmh3U9lPEq5VQEBzG_U8Q-1
Received: by mail-wm1-f71.google.com with SMTP id bi7-20020a05600c3d8700b003edecc610abso3504701wmb.7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679413355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QASJhsJ+hdJk3WLN6OfGqjuqBH1Q3bTytFBvValx858=;
        b=kBZudUqxo+ZSrADK61Hu6zYfqj5ZxZRd8xM9nMpAIeo3H+twd1+nDfWB83iMmFfvVZ
         9L7Suvu80AJ7VBfqJUwweM08HzCmghVEDYTZlqDnDlbuKUDexWQNqMui8s4ON6Mm2Mkt
         mfdttVrOfAxoyAXZ236HVi9p3ykS/pJA5fmllz7LWFWQctbQS0+1rUh0Ev92rb6lQhBy
         H90sDqGGNFMfbdsBOxyocv6XWZrWq2zUyh68Pq84jHc0mylAgu2ciafzS3MCcBsoKwS1
         ED+njzaa1qy4v8T5doZ+cc4+hNU2pV+FPOJToaDH4ftGLtwiSQXn2ZXBcV2bggiG492Q
         9CXQ==
X-Gm-Message-State: AO0yUKXNywgsxq+gBFYfqUWK7tzUSeacikL5GJFbBFf9o4CZxO39LKsI
        hzKeQrg4xOqGcTK7D49eQVzc1fVwSaxD6yHeRKbmCLyIF1Xryp4Cq1buwVMxgxdw5xE0fw8IEK4
        0cjSiKoP8FFGSVEpD
X-Received: by 2002:a5d:5382:0:b0:2cf:ed44:693c with SMTP id d2-20020a5d5382000000b002cfed44693cmr2551084wrv.31.1679413355449;
        Tue, 21 Mar 2023 08:42:35 -0700 (PDT)
X-Google-Smtp-Source: AK7set+cPTfHDIMahJYsEyI78yh9D7tSYE1RLi2Gk+kcor46FddUKzpMWH1lQfIFzdB3Llbe5PLtkg==
X-Received: by 2002:a5d:5382:0:b0:2cf:ed44:693c with SMTP id d2-20020a5d5382000000b002cfed44693cmr2551068wrv.31.1679413355138;
        Tue, 21 Mar 2023 08:42:35 -0700 (PDT)
Received: from step1.redhat.com (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id n2-20020adffe02000000b002cfeffb442bsm11582490wrr.57.2023.03.21.08.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 08:42:34 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v3 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
Date:   Tue, 21 Mar 2023 16:42:22 +0100
Message-Id: <20230321154228.182769-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321154228.182769-1-sgarzare@redhat.com>
References: <20230321154228.182769-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
    v3:
    - added `case VHOST_SET_OWNER` in vhost_vdpa_unlocked_ioctl() [Jason]
    v2:
    - call the new unbind_mm callback during the release [Jason]
    - avoid to call bind_mm callback after the reset, since the device
      is not detaching it now during the reset

 drivers/vhost/vdpa.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7be9d9d8f01c..20250c3418b2 100644
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
@@ -709,6 +731,14 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_RESUME:
 		r = vhost_vdpa_resume(v);
 		break;
+	case VHOST_SET_OWNER:
+		r = vhost_dev_set_owner(d);
+		if (r)
+			break;
+		r = vhost_vdpa_bind_mm(v);
+		if (r)
+			vhost_dev_reset_owner(d, NULL);
+		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
 		if (r == -ENOIOCTLCMD)
@@ -1287,6 +1317,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
+	vhost_vdpa_unbind_mm(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_cleanup(v);
 	mutex_unlock(&d->mutex);
-- 
2.39.2

