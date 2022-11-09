Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DFF62286F
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiKIK0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 05:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiKIK0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:26:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473A514085
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667989512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yog0hcuy+DRZPETd9YkKxOoct4jxmNsATV6V9Xx3MWc=;
        b=Cubzxsp/FhdnicGCbhVeu3i8DFdv7sJKe48wsnkZMoQp7Hvgc1+gTA+spZ+aO3T13aChYp
        XCqZeEC9QcOT8MOzop+Pwni7Qv2zkK7Cpq4grURXR2I38IACB64iJgShINi3+0gf+4AT3X
        seVrIsp9h3SN0sk9trc1CdPCY0fFV7g=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-Mfw_B51iNF6hZxrH0hp1qg-1; Wed, 09 Nov 2022 05:25:11 -0500
X-MC-Unique: Mfw_B51iNF6hZxrH0hp1qg-1
Received: by mail-qk1-f198.google.com with SMTP id br12-20020a05620a460c00b006fa52448320so15315140qkb.0
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 02:25:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yog0hcuy+DRZPETd9YkKxOoct4jxmNsATV6V9Xx3MWc=;
        b=7/6udnppEGf3uIcLw94fSZ5t4f0OIGj2I6VWjOeI1LI4See9Lcpin5RXYs7ubodeJm
         Uyba8FcYkMqlc/fSIrKbio7HYmrTWyT4KgrdK3Fe+zFdQTgdZEuo3AnjGLnmu2wF0Btr
         MJOEJIq1O0gV43/tTMRnSK5vI1O5zf3N78H8ZTyz0Oe/C1Z3JXXCi3k7uRZ2pJWoQxl+
         CHkgOZegYhamW2BOqL4DwMhkbLKdVzp3cg2kqpMXN3PkmY3FlwXs4tn5yMqccH/ZMNvS
         BtqqBRmUTobxCsQY28M92z/kE6OfnzminGSr+bcv1q1D1/bEE2ZNrGRYDwqIxubloFyJ
         zMJg==
X-Gm-Message-State: ACrzQf3j7XXBThwBtKL/7s9fPklWtA1rw1lB9BYHHyuoeirTWuYobkS9
        EPjY8YzFvcTmKwinS2zEZs6+9JLGG+d0SzfVSjR7q14aBvgOqKjJOJKsGOulFEXyahpGN6rJj7I
        3ELOTNsSZw2OsWV9g
X-Received: by 2002:a05:622a:12:b0:3a5:6899:5add with SMTP id x18-20020a05622a001200b003a568995addmr20183667qtw.629.1667989510777;
        Wed, 09 Nov 2022 02:25:10 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7dHRvHahxNPyxd5cXNPDwYDthvEkrvK4CouVYmtTTQjEql4SHBFw0gbhGAtAaO5z7i7a0AnQ==
X-Received: by 2002:a05:622a:12:b0:3a5:6899:5add with SMTP id x18-20020a05622a001200b003a568995addmr20183656qtw.629.1667989510546;
        Wed, 09 Nov 2022 02:25:10 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id bj10-20020a05620a190a00b006fa313bf185sm10827522qkb.8.2022.11.09.02.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 02:25:09 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 1/2] vringh: fix range used in iotlb_translate()
Date:   Wed,  9 Nov 2022 11:25:02 +0100
Message-Id: <20221109102503.18816-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109102503.18816-1-sgarzare@redhat.com>
References: <20221109102503.18816-1-sgarzare@redhat.com>
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

vhost_iotlb_itree_first() requires `start` and `last` parameters
to search for a mapping that overlaps the range.

In iotlb_translate() we cyclically call vhost_iotlb_itree_first(),
incrementing `addr` by the amount already translated, so rightly
we move the `start` parameter passed to vhost_iotlb_itree_first(),
but we should hold the `last` parameter constant.

Let's fix it by saving the `last` parameter value before incrementing
`addr` in the loop.

Fixes: 9ad9c49cfe97 ("vringh: IOTLB support")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vringh.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 11f59dd06a74..828c29306565 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1102,7 +1102,7 @@ static int iotlb_translate(const struct vringh *vrh,
 	struct vhost_iotlb_map *map;
 	struct vhost_iotlb *iotlb = vrh->iotlb;
 	int ret = 0;
-	u64 s = 0;
+	u64 s = 0, last = addr + len - 1;
 
 	spin_lock(vrh->iotlb_lock);
 
@@ -1114,8 +1114,7 @@ static int iotlb_translate(const struct vringh *vrh,
 			break;
 		}
 
-		map = vhost_iotlb_itree_first(iotlb, addr,
-					      addr + len - 1);
+		map = vhost_iotlb_itree_first(iotlb, addr, last);
 		if (!map || map->start > addr) {
 			ret = -EINVAL;
 			break;
-- 
2.38.1

