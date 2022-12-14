Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8BFB64CE0F
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239083AbiLNQbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239040AbiLNQbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:31:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51693B58
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671035449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1lGOBSIFe5pUAxEjRFkRz63QN+FtG9EzKvnfhz76nOw=;
        b=H5vWvRevavnEXugM0uZlQ/ks2z5Aczz2gobu1PQ1S02EN0hXlq6S2l0QPR2NI4rJEVsrfq
        wapnV8bKUTH3CNIX900EiHuTG7YkxjXKSZhbCAHq9eHdQI8oKD3x4Np6KIq6mrI6YL9gzx
        +7TDB8eL0sO3XQhOqnHv/aHNuZ3k8Uk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-577-pgySfDJONt-HeHlfH1nWUg-1; Wed, 14 Dec 2022 11:30:31 -0500
X-MC-Unique: pgySfDJONt-HeHlfH1nWUg-1
Received: by mail-wm1-f71.google.com with SMTP id m38-20020a05600c3b2600b003d1fc5f1f80so7439866wms.1
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:30:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1lGOBSIFe5pUAxEjRFkRz63QN+FtG9EzKvnfhz76nOw=;
        b=sWhUkTdJZiYIZSBFZo7DD2npX9dKk4BA2lw7oNPAzDku6hGK0FqwMNW4RO99KduJB0
         gthnGm1ZM4c8+6SR66T7JqhUNJY8vl/sHQEWER6pNn4K/YHwwYwHi5ixDDZTWIzUnsT1
         OTUWkRpgyNj89TT5+9Wqvzfl2i4fodXGKgMqoxqMpIpFuxWuR4t91UtzkV8fV9M+Qsh2
         HgZh6zrM9iFhDsjfuE7aG64oj4xGHvsvCREdhtLNp4sYwRhKej+bOXLUhWW/dRNaODL3
         wiAdihP0bHOhSjeBtXoyv95cawDe2hJotsk+IuSFoFTojanh98cBq6QhqIzBen62/apc
         cmqg==
X-Gm-Message-State: AFqh2kqpHPz4S8bolMvFj+SVJm3xu1IUOOpqoZKdobuBwHZAOrvWLQRT
        fPzYT65XE1GHizeczDo6OAxoF1oLyh83xWETzZoWaJr86W/+n8V5nuq/ldsRuN+u7RAkWQndNzM
        P0GcaQe8Yx9Npxhhz
X-Received: by 2002:a5d:6b82:0:b0:254:e300:df10 with SMTP id n2-20020a5d6b82000000b00254e300df10mr3175575wrx.0.1671035430300;
        Wed, 14 Dec 2022 08:30:30 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtON+i2KOCKckOC+y5p1sstetwPc0ECbYZbXcpC/pxYXEHqSVOOlJPZuP9yMFAhSEmoSjaS2Q==
X-Received: by 2002:a5d:6b82:0:b0:254:e300:df10 with SMTP id n2-20020a5d6b82000000b00254e300df10mr3175558wrx.0.1671035430129;
        Wed, 14 Dec 2022 08:30:30 -0800 (PST)
Received: from step1.redhat.com (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id e17-20020adffd11000000b002422816aa25sm3791759wrr.108.2022.12.14.08.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 08:30:29 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        stefanha@redhat.com, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [RFC PATCH 1/6] vdpa: add bind_mm callback
Date:   Wed, 14 Dec 2022 17:30:20 +0100
Message-Id: <20221214163025.103075-2-sgarzare@redhat.com>
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

This new optional callback is used to bind the device to a specific
address space so the vDPA framework can use VA when this callback
is implemented.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vdpa.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 6d0f5e4e82c2..34388e21ef3f 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -282,6 +282,12 @@ struct vdpa_map_file {
  *				@iova: iova to be unmapped
  *				@size: size of the area
  *				Returns integer: success (0) or error (< 0)
+ * @bind_mm:			Bind the device to a specific address space
+ *				so the vDPA framework can use VA when this
+ *				callback is implemented. (optional)
+ *				@vdev: vdpa device
+ *				@mm: address space to bind
+ *				@owner: process that owns the address space
  * @free:			Free resources that belongs to vDPA (optional)
  *				@vdev: vdpa device
  */
@@ -341,6 +347,8 @@ struct vdpa_config_ops {
 			 u64 iova, u64 size);
 	int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
 			      unsigned int asid);
+	int (*bind_mm)(struct vdpa_device *vdev, struct mm_struct *mm,
+		       struct task_struct *owner);
 
 	/* Free device resources */
 	void (*free)(struct vdpa_device *vdev);
-- 
2.38.1

