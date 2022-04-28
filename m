Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456B85134FE
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347125AbiD1N0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346514AbiD1N0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:26:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86C27AC91C
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651152171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a14xq4pv5r/FkYeXeUtrnJ56gM2JRtUzYDAyxUxKyXw=;
        b=iDC0CFsnmCpHl15+zW16wPNx+Dh8aGQYLzhqz8TjfbntpWAeOxpIMmYtq6uMG4nlO+C0Se
        dwDOQ46Jhs9KTSFAkQWE/ImWH6DR97Flgyo/eLHGdo78c5hmeJ9QjZL8Vu2MQ80iwzcT00
        V13ei9k+yHRrNdtAO9Qnd4oRZbO1Spc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-HEFcfq4YNFeRr4139CyTNQ-1; Thu, 28 Apr 2022 09:22:50 -0400
X-MC-Unique: HEFcfq4YNFeRr4139CyTNQ-1
Received: by mail-wr1-f70.google.com with SMTP id y13-20020adfc7cd000000b0020ac7c7bf2eso1935958wrg.9
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a14xq4pv5r/FkYeXeUtrnJ56gM2JRtUzYDAyxUxKyXw=;
        b=vdf6+JNhTXqwl5C65l22KBo0XIdzV7qE1YlBeeur/KZrC1WdWK5ZK+GV4lruA5uo4H
         wmpza3kAooMCfX9wZYU5dR5YL7tgOgFgrD+/Tx/clJOLdYozLuYs6+b7yD4EYjer6ILe
         HKAz1ReechAzxzvXePucDPcAy19DTagtMExALKJTAB17Nmt/KbS1B+7KPNOacdGcKil2
         clKl+Q85F3Tq2UeMhtVnNmNBCGaDPeR6/cIKE8y39EPFf31Nupd0wwgjmkOSzpahJCqN
         LxlMMUYFoWl5HHD8JGWx3R9k5rQlKX9NmuIPXbsypwb8y7tejIXMzyt0vEhbx1uF3cL0
         jkqw==
X-Gm-Message-State: AOAM53247BE3v+G0iLNVp3Y0E9mOu0FNkuaGRpHPLS0gaFc+S6MBA0TH
        ZbHtQn9QDUc38ppHkbZ/eVNra48QemvO2TA7SWgPrgKUtpVYmNsNZuz1eG2zNgkjBFjfXdHGxfI
        SJ+mENrSDzia3wimbdTlADFQV4f+nhX4kryBEKjuf00PZJ5mG3ZOC7GQeTqf+W9RNNA0B
X-Received: by 2002:a05:600c:502b:b0:38f:f7c6:3609 with SMTP id n43-20020a05600c502b00b0038ff7c63609mr31169287wmr.15.1651152168843;
        Thu, 28 Apr 2022 06:22:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQVnCQJ38EwfNhzDeSYDCstkye3h+BWbMt9XxC8erbs+iXajlC/fBdW5XhbJa/npUVsWgZzw==
X-Received: by 2002:a05:600c:502b:b0:38f:f7c6:3609 with SMTP id n43-20020a05600c502b00b0038ff7c63609mr31169254wmr.15.1651152168532;
        Thu, 28 Apr 2022 06:22:48 -0700 (PDT)
Received: from step1.redhat.com (host-87-11-6-234.retail.telecomitalia.it. [87.11.6.234])
        by smtp.gmail.com with ESMTPSA id f7-20020a05600c4e8700b00393f1393abfsm4680978wmq.41.2022.04.28.06.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:22:47 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vilas R K <vilas.r.k@intel.com>,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH net-next 2/2] vsock/virtio: add support for device suspend/resume
Date:   Thu, 28 Apr 2022 15:22:41 +0200
Message-Id: <20220428132241.152679-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428132241.152679-1-sgarzare@redhat.com>
References: <20220428132241.152679-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement .freeze and .restore callbacks of struct virtio_driver
to support device suspend/resume.

During suspension all connected sockets are reset and VQs deleted.
During resume the VQs are re-initialized.

Reported by: Vilas R K <vilas.r.k@intel.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 47 ++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 31f4f6f40614..ad64f403536a 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -743,6 +743,49 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	kfree(vsock);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int virtio_vsock_freeze(struct virtio_device *vdev)
+{
+	struct virtio_vsock *vsock = vdev->priv;
+
+	mutex_lock(&the_virtio_vsock_mutex);
+
+	rcu_assign_pointer(the_virtio_vsock, NULL);
+	synchronize_rcu();
+
+	virtio_vsock_vqs_del(vsock);
+
+	mutex_unlock(&the_virtio_vsock_mutex);
+
+	return 0;
+}
+
+static int virtio_vsock_restore(struct virtio_device *vdev)
+{
+	struct virtio_vsock *vsock = vdev->priv;
+	int ret;
+
+	mutex_lock(&the_virtio_vsock_mutex);
+
+	/* Only one virtio-vsock device per guest is supported */
+	if (rcu_dereference_protected(the_virtio_vsock,
+				lockdep_is_held(&the_virtio_vsock_mutex))) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = virtio_vsock_vqs_init(vsock);
+	if (ret < 0)
+		goto out;
+
+	rcu_assign_pointer(the_virtio_vsock, vsock);
+
+out:
+	mutex_unlock(&the_virtio_vsock_mutex);
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
 static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_VSOCK, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -760,6 +803,10 @@ static struct virtio_driver virtio_vsock_driver = {
 	.id_table = id_table,
 	.probe = virtio_vsock_probe,
 	.remove = virtio_vsock_remove,
+#ifdef CONFIG_PM_SLEEP
+	.freeze = virtio_vsock_freeze,
+	.restore = virtio_vsock_restore,
+#endif
 };
 
 static int __init virtio_vsock_init(void)
-- 
2.35.1

