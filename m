Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978A06A812B
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCBLfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCBLfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:35:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E25314EB1
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 03:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677756880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMUvg2hEs0iMx2dm3/Jg9b5hv2Rlumo7TQ+47EWr+7I=;
        b=eqM4MKD4lbhRF16c0egtl+jxhsbdRBQsXRI4OHQkwG+VozXKm3UxGokgCw0Zq5uPLEPCfu
        NXl5vgLB/aDOCv+Zsp8zMHfkgbP7oZcEWgWf/q/o3GiDfb2GTqItxf4LidNxasFa+rhfYz
        2ej4Im32XE4zOHKneIupZ+1GCn7w7rM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-648-7y_wI6bgNvmFrq9cMsrUlw-1; Thu, 02 Mar 2023 06:34:39 -0500
X-MC-Unique: 7y_wI6bgNvmFrq9cMsrUlw-1
Received: by mail-qv1-f69.google.com with SMTP id x18-20020ad44592000000b00571bb7cdc42so8677762qvu.23
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 03:34:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nMUvg2hEs0iMx2dm3/Jg9b5hv2Rlumo7TQ+47EWr+7I=;
        b=2xLDH6PbRBFZg0ATPvZJdTvYswfuVkN6PPvACDAI1nnOtxfqaQ7bJxNYd0604GPpOu
         GyQVpT/Y322AVGQLNuNXLEn7NygQ9680cZl5Py+jPyCNZxxAPfOYWmYi9Ehj2MqZZQGy
         n7l7lBRl74ve92e7Ewa3kD0oBmdIq0JMiuq5+CVY8HdxHklbN3AIdrjlC/Ptp0hFwQDL
         hvyQ7ZanVoNWs2nV2WEzSaIi+916kx8j002OYoPvtQRSx4YZiJTsXvXZ8+QZn2zdg4U6
         8yisIMi4QgV/BSUMBWR3b8jptVqg+DqQoDlPgNG8XtGYyVgskEQV7oBZCuRoy/20yXwg
         gjTw==
X-Gm-Message-State: AO0yUKVydOl/o1L5Nx5brHgVQsGXD65Q/7UIOBx5aABVIvSyJdz0RDIv
        JpPNaESmfRyNwHHOye3ERk9N7BQWsIpz7jGgM4J0hVfFqAscZDwOfsfVm605gYvuh1abe8wGWC4
        cIdPEVyL5eg9Ybkae
X-Received: by 2002:ac8:5850:0:b0:3bf:d6ad:5236 with SMTP id h16-20020ac85850000000b003bfd6ad5236mr15655321qth.32.1677756879139;
        Thu, 02 Mar 2023 03:34:39 -0800 (PST)
X-Google-Smtp-Source: AK7set9TavRztcG0ZSYQlhYEtTPhNvB2VmTMeHABCwp3UyKfmeGcD6URaSgRaErRo454+a/9s5fAlA==
X-Received: by 2002:ac8:5850:0:b0:3bf:d6ad:5236 with SMTP id h16-20020ac85850000000b003bfd6ad5236mr15655295qth.32.1677756878884;
        Thu, 02 Mar 2023 03:34:38 -0800 (PST)
Received: from step1.redhat.com (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id o12-20020ac8698c000000b003ba19e53e43sm10084156qtq.25.2023.03.02.03.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:34:38 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 3/8] vringh: replace kmap_atomic() with kmap_local_page()
Date:   Thu,  2 Mar 2023 12:34:16 +0100
Message-Id: <20230302113421.174582-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302113421.174582-1-sgarzare@redhat.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmap_atomic() is deprecated in favor of kmap_local_page().

With kmap_local_page() the mappings are per thread, CPU local, can take
page-faults, and can be called from any context (including interrupts).
Furthermore, the tasks can be preempted and, when they are scheduled to
run again, the kernel virtual addresses are restored and still valid.

kmap_atomic() is implemented like a kmap_local_page() which also disables
page-faults and preemption (the latter only for !PREEMPT_RT kernels,
otherwise it only disables migration).

The code within the mappings/un-mappings in getu16_iotlb() and
putu16_iotlb() don't depend on the above-mentioned side effects of
kmap_atomic(), so that mere replacements of the old API with the new one
is all that is required (i.e., there is no need to explicitly add calls
to pagefault_disable() and/or preempt_disable()).

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v2:
    - added this patch since checkpatch.pl complained about deprecation
      of kmap_atomic() touched by next patch

 drivers/vhost/vringh.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index a1e27da54481..0ba3ef809e48 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1220,10 +1220,10 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_atomic(iov.bv_page);
+	kaddr = kmap_local_page(iov.bv_page);
 	from = kaddr + iov.bv_offset;
 	*val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	return 0;
 }
@@ -1241,10 +1241,10 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_atomic(iov.bv_page);
+	kaddr = kmap_local_page(iov.bv_page);
 	to = kaddr + iov.bv_offset;
 	WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
-	kunmap_atomic(kaddr);
+	kunmap_local(kaddr);
 
 	return 0;
 }
-- 
2.39.2

