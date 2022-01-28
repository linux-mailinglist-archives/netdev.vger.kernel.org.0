Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247AA49F692
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 10:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347696AbiA1Jlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 04:41:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243738AbiA1Jle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 04:41:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643362894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gm/zIaqxAUJ7weu5vueVLpk6KOEoe9UgJ0ELP0kscoU=;
        b=ebdnjtyrBbFVDM8A59XDWW4FHeYME03yT5YEb2C5ay0gkoXJOr12xRvBG7Ud2xmOaHLC/z
        XVKRgifivUJoyQgeP06V0ZSvs8LfzfLZT88MwrGZ7frsCRPO2/jRictzgjr+WxJMqt8ONd
        i/Ax2zL5HLnhegQrABEPndEo2h/GvLs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-bWygqYQkOIShUUFkYLJlkw-1; Fri, 28 Jan 2022 04:41:32 -0500
X-MC-Unique: bWygqYQkOIShUUFkYLJlkw-1
Received: by mail-wr1-f72.google.com with SMTP id z1-20020adfbbc1000000b001df54394cebso1207415wrg.20
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 01:41:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gm/zIaqxAUJ7weu5vueVLpk6KOEoe9UgJ0ELP0kscoU=;
        b=NVdGotc5z6O1K6dTP18VaCa/PHPMQocrPzvkMsZDG/Sz45YYde8ZDiK08UKqGoMX7S
         2SZLcXQ/ixbYoR9KAOb/QGgw6BD099ANf1dJ9SL8tHyyy32sVNiLij8heBDZxL6VkkZD
         qi/GSc9m8MrSz4/SL4In7Nbc03ad7MydPY5gltgvQF5FxTqr80MYPEAWA51KC+xd00bR
         4zY96lUD4/DzmfPWgCxACvvaSsZf3GqSLaVaM8eV0VtiJfCgAgn5vVGCJAjJP+g4d5nE
         IUwHS/anqNAIjS97xJG+3pjKhm9ctwGgXHh3JP9DkdwTNv95D3rj9JQUWFECd1KH58zW
         WRpQ==
X-Gm-Message-State: AOAM533GCfhLzv+jG20Q8R+TiaQAUtjX6GixJbt+bssDVuA+xPInP3R8
        RJQlB5lii5sIhYOw3hCBcm55VYFIdAlfDyf5TMW7gQqbU6AcSztuR6d5tz2qwPzLQ9lFHlRcpYs
        QXMiwhBErzNbRWQ0d
X-Received: by 2002:a5d:554b:: with SMTP id g11mr6278081wrw.168.1643362891422;
        Fri, 28 Jan 2022 01:41:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyhT/5ouoGIlyIxVyr+Q5hXpBEiMOVIvHbdPHh42746reFTj6j3DnyqBWI059BBKWi7Vf/56w==
X-Received: by 2002:a5d:554b:: with SMTP id g11mr6278075wrw.168.1643362891224;
        Fri, 28 Jan 2022 01:41:31 -0800 (PST)
Received: from steredhat.redhat.com (host-95-238-125-214.retail.telecomitalia.it. [95.238.125.214])
        by smtp.gmail.com with ESMTPSA id o1sm683206wri.108.2022.01.28.01.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 01:41:30 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        stefanha@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v3] vhost: cache avail index in vhost_enable_notify()
Date:   Fri, 28 Jan 2022 10:41:29 +0100
Message-Id: <20220128094129.40809-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_enable_notify() we enable the notifications and we read
the avail index to check if new buffers have become available in
the meantime.

We do not update the cached avail index value, so when the device
will call vhost_get_vq_desc(), it will find the old value in the
cache and it will read the avail index again.

It would be better to refresh the cache every time we read avail
index, so let's change vhost_enable_notify() caching the value in
`avail_idx` and compare it with `last_avail_idx` to check if there
are new buffers available.

We don't expect a significant performance boost because
the above path is not very common, indeed vhost_enable_notify()
is often called with unlikely(), expecting that avail index has
not been updated.

We ran virtio-test/vhost-test and noticed minimal improvement as
expected. To stress the patch more, we modified vhost_test.ko to
call vhost_enable_notify()/vhost_disable_notify() on every cycle
when calling vhost_get_vq_desc(); in this case we observed a more
evident improvement, with a reduction of the test execution time
of about 3.7%.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v3
- reworded commit description [Stefan]
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..07363dff559e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2543,8 +2543,9 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 		       &vq->avail->idx, r);
 		return false;
 	}
+	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
 
-	return vhost16_to_cpu(vq, avail_idx) != vq->avail_idx;
+	return vq->avail_idx != vq->last_avail_idx;
 }
 EXPORT_SYMBOL_GPL(vhost_enable_notify);
 
-- 
2.34.1

