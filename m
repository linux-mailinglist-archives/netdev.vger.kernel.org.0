Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F51A6A8126
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjCBLff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjCBLfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:35:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E568A158BA
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 03:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677756873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zd9PLJS6vpKJ6CPmR9YHtESYhzkUvkwsWDxsXaqlwQ8=;
        b=KBPxhpEZ/FO1f2jdraRNtjAM4oXlKEWSC3qkaxMTzF7kXTUXp+a3WEs+v8R7BbU78Xd+iG
        xBzhuoAk3eU3W4ksdhs9KDiqIzekmxvaLOJpnZPF90MXrTwwB8aHC/OMa64QyhMlffI+xv
        s7JHfdWcK3NfP42WHzABqgl6tCT/bRA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-257-rPeRteZuMOmey_TN3cYH7A-1; Thu, 02 Mar 2023 06:34:32 -0500
X-MC-Unique: rPeRteZuMOmey_TN3cYH7A-1
Received: by mail-qk1-f200.google.com with SMTP id d72-20020ae9ef4b000000b0072db6346c39so9868599qkg.16
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 03:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zd9PLJS6vpKJ6CPmR9YHtESYhzkUvkwsWDxsXaqlwQ8=;
        b=zfJuvTv4ekmkzjAieh9V51VFgqQhuMj6VwD+8zNvsOV8Tj69u1BXNXgzM/uRW7kFwe
         NJEpUhpoxb9Ys1tW6kAGWC+hEFA4liz3OK4P+38Y2K7Algni2vlgYge8PowHSaT+iWZb
         SVMSgtSDr0iVSKKxH7gKxoxSuFkeaYwfO0rxdu6PYSw13jEdgO3OOyxOJMA0RGC4TaXP
         v1Qj9a7HzXD8wwRvf3vPAri9h2yNYRHX4/u07j0y6aj8OG4v+yHmTmX9rx6GeAxrC3/x
         NHqMYuohBxw9Bk6G746c8lsPc8RuBB0vbhJxJlhhVIqU2S+qsBDKgcr05O1mRYG7B+Tb
         S6aw==
X-Gm-Message-State: AO0yUKWen+p25qRzSiHsthwRHP0jfAwrrI6tfHskXIXDQy8A4NzIyMe7
        kk051qEqJ6/vDjfxO5gmlMDxDZJyw6UBCx2bTKkJq+ihE6QghE6y4KwysZdetcVVgH5sJ90qai/
        tWIHibb4woXLmF3CR
X-Received: by 2002:a05:622a:14a:b0:3bf:d0b1:433d with SMTP id v10-20020a05622a014a00b003bfd0b1433dmr17172917qtw.60.1677756871625;
        Thu, 02 Mar 2023 03:34:31 -0800 (PST)
X-Google-Smtp-Source: AK7set+LNHqJ8iSXkQnBxJNED/Dd+UhTVPKK7gC7ULHZoFWAiCyFuYmT1oYs5XX8i5qwnVYajblszQ==
X-Received: by 2002:a05:622a:14a:b0:3bf:d0b1:433d with SMTP id v10-20020a05622a014a00b003bfd0b1433dmr17172896qtw.60.1677756871371;
        Thu, 02 Mar 2023 03:34:31 -0800 (PST)
Received: from step1.redhat.com (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id o12-20020ac8698c000000b003ba19e53e43sm10084156qtq.25.2023.03.02.03.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:34:30 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 1/8] vdpa: add bind_mm/unbind_mm callbacks
Date:   Thu,  2 Mar 2023 12:34:14 +0100
Message-Id: <20230302113421.174582-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302113421.174582-1-sgarzare@redhat.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
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

These new optional callbacks is used to bind/unbind the device to
a specific address space so the vDPA framework can use VA when
these callbacks are implemented.

Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v2:
    - removed `struct task_struct *owner` param (unused for now, maybe
      useful to support cgroups) [Jason]
    - add unbind_mm callback [Jason]

 include/linux/vdpa.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 43f59ef10cc9..369c21394284 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -290,6 +290,14 @@ struct vdpa_map_file {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns pointer to structure device or error (NULL)
+ * @bind_mm:			Bind the device to a specific address space
+ *				so the vDPA framework can use VA when this
+ *				callback is implemented. (optional)
+ *				@vdev: vdpa device
+ *				@mm: address space to bind
+ * @unbind_mm:			Unbind the device from the address space
+ *				bound using the bind_mm callback. (optional)
+ *				@vdev: vdpa device
  * @free:			Free resources that belongs to vDPA (optional)
  *				@vdev: vdpa device
  */
@@ -351,6 +359,8 @@ struct vdpa_config_ops {
 	int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
 			      unsigned int asid);
 	struct device *(*get_vq_dma_dev)(struct vdpa_device *vdev, u16 idx);
+	int (*bind_mm)(struct vdpa_device *vdev, struct mm_struct *mm);
+	void (*unbind_mm)(struct vdpa_device *vdev);
 
 	/* Free device resources */
 	void (*free)(struct vdpa_device *vdev);
-- 
2.39.2

