Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCB964CE0E
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239033AbiLNQbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239026AbiLNQbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:31:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54476D2E9
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671035443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ntjy4bIssvEAdzLttb0Oirdk6ECvBiYBnXEucLTwyX4=;
        b=KanM77ZYg6z6rR0M+tCJETPSMMcDOf3Z0vkrjkgMJt7JmmDFeaeFZL3KtTZpNnJJjHIcqU
        cAYzRjYF0F+B4Qg39iwfVBo7iInmO8OnRNpD1Qq3l4e4AaEVTMQEjC2KhkBljO/R6vRft8
        tvloGLbh4Ie5W61LQA9ze+27HnLYrbc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-623-MyMEW1mCMYyguoNxF-NJ9Q-1; Wed, 14 Dec 2022 11:30:33 -0500
X-MC-Unique: MyMEW1mCMYyguoNxF-NJ9Q-1
Received: by mail-wm1-f71.google.com with SMTP id h81-20020a1c2154000000b003d1c8e519fbso7427659wmh.2
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:30:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ntjy4bIssvEAdzLttb0Oirdk6ECvBiYBnXEucLTwyX4=;
        b=N8B+0ZPIqV5tKGWAmxZpniFbafdkHfR2QA2Xz2AE9Wau8qmjLnNkLtR7j0ud5STj+u
         /zvuuGhkqH6G6aSdx6AcrvGPJs/3j9R0Vaih82Pex2cbOYESmdaxRXydcvLkoD4RpWsY
         Jy7DA6ntLcYfbLNHZKe1rEuKCuOAgRPuTL1TmNE/EUyRfhcS+GtpnFCjMnC5mkjze7wL
         wgWDZzo3ssO7OvNMPebsxC5AmWd536+y6poj2+7EEo6LSYpJPVnLrg6ep2yv3czcz2U+
         39Ua8I0SkC7apAJWJBYaBgGTwJ/EnDDr+jrQQTNSmt/NLsHYjgptpodtv3mqDc3rmmBc
         wbAQ==
X-Gm-Message-State: ANoB5pk7kX9QVta1cJqtVPzDwVYdcWbDJS4wfMrnxWrKLO7pgpM9Q6O9
        chf0ONYGG0ChzIVS5csyL47JJfr3v4dvEKmYiKmcMEPNgDOR2bkT7XOrCCrtl/mIdbpvJsMpyKu
        l3TUMNHNIM/dN+BgR
X-Received: by 2002:a5d:43c8:0:b0:242:659f:9411 with SMTP id v8-20020a5d43c8000000b00242659f9411mr18656562wrr.9.1671035432137;
        Wed, 14 Dec 2022 08:30:32 -0800 (PST)
X-Google-Smtp-Source: AA0mqf749Y7E+BT4q6kPhJknMxXoEgk8H6qeSlLUTLbG1hIMjBAx7MTauP5T5GnuPa8o2ZC6K5qBtA==
X-Received: by 2002:a5d:43c8:0:b0:242:659f:9411 with SMTP id v8-20020a5d43c8000000b00242659f9411mr18656541wrr.9.1671035431915;
        Wed, 14 Dec 2022 08:30:31 -0800 (PST)
Received: from step1.redhat.com (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id e17-20020adffd11000000b002422816aa25sm3791759wrr.108.2022.12.14.08.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:30:31 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [RFC PATCH 2/6] vhost-vdpa: use bind_mm device callback
Date:   Wed, 14 Dec 2022 17:30:21 +0100
Message-Id: <20221214163025.103075-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221214163025.103075-1-sgarzare@redhat.com>
References: <20221214163025.103075-1-sgarzare@redhat.com>
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

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index b08e07fc7d1f..a775d1a52c77 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -219,6 +219,17 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
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
+	return ops->bind_mm(vdpa, v->vdev.mm, current);
+}
+
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -276,6 +287,10 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 		ret = vdpa_reset(vdpa);
 		if (ret)
 			return ret;
+
+		ret = vhost_vdpa_bind_mm(v);
+		if (ret)
+			return ret;
 	} else
 		vdpa_set_status(vdpa, status);
 
@@ -679,6 +694,13 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		break;
 	default:
 		r = vhost_dev_ioctl(&v->vdev, cmd, argp);
+		if (!r && cmd == VHOST_SET_OWNER) {
+			r = vhost_vdpa_bind_mm(v);
+			if (r) {
+				vhost_dev_reset_owner(&v->vdev, NULL);
+				break;
+			}
+		}
 		if (r == -ENOIOCTLCMD)
 			r = vhost_vdpa_vring_ioctl(v, cmd, argp);
 		break;
-- 
2.38.1

