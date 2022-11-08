Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BCB620D6B
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiKHKfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbiKHKfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:35:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C9018E08
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667903683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKRP4+cw0VhFwZrp8HtA3cgViFo5lHlh1+6syG/i+wQ=;
        b=fimNQknFaTAUDv6871+ju9r+sWpLVjQOZ1iP2ULFUh30KF7B5anuxoHDfSwiv4zvFCoEtU
        AL/+c+ONgCBro5tf5cGOeu34agvlNRcy9qsRjnkZTj6MD6R1Dk37OBcLspWGRF6YUag3Nf
        2HZbPuKPMFURVqhalPeaTt64X2aNm0E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-6HsaHA6mOJama93TWBLLjg-1; Tue, 08 Nov 2022 05:34:42 -0500
X-MC-Unique: 6HsaHA6mOJama93TWBLLjg-1
Received: by mail-wr1-f69.google.com with SMTP id v12-20020adfa1cc000000b00236eaee7197so3803011wrv.0
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 02:34:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKRP4+cw0VhFwZrp8HtA3cgViFo5lHlh1+6syG/i+wQ=;
        b=Rn6RKe72c7ZxTIAJFtG3yJC1RNbK4JQCW2nD+SY4I6XpjUqOrseS4hwpqxRF5LjDrN
         rBeTyJb5hlTfzmp6Acrq9eTa33zlgPPqEyu5OOq1X9zxKMbFatHBrwLPbAhXaXB6s+/g
         WGxewX+fGjybm0TIMBg0eEc83/7JEsnYJJPGAmJ98t9sUSP9B2Qi18WeZcb5vZ67JazE
         JvKLdCdE2WiV8n2kAjMRKyAu6smIqQUWg4FOBg6w3usGHHIHWElmD9D6eMVDiOoPmKf0
         jL341sK6NmlsY8O8imvkt8kyq2c8/8BiT+U/O3CUS5vcOD0amGvBl6pynedkeqcG+9gV
         +noA==
X-Gm-Message-State: ACrzQf3fAXL7ejeur8+BkRTNKgnqQ5R22Cb6gIQxuknsoTpgAGRRyxYf
        rlHosqS1Ea4UadK5TdK++VNZ1bZzUPw4o7wtwhGTRrPL09N32NGrWHRn9dGNGnLyDTk+TXiMHKC
        kFeGO+rTldZFU5hMI
X-Received: by 2002:a05:600c:ad0:b0:3cf:692a:7f66 with SMTP id c16-20020a05600c0ad000b003cf692a7f66mr35280923wmr.200.1667903680917;
        Tue, 08 Nov 2022 02:34:40 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6ASsVMnXRj7BGCE+XsYeiyRdqfGCW4D/w7QesCAh5x6w9k97okW5QkPTlkLZADWxPYvplZtA==
X-Received: by 2002:a05:600c:ad0:b0:3cf:692a:7f66 with SMTP id c16-20020a05600c0ad000b003cf692a7f66mr35280908wmr.200.1667903680649;
        Tue, 08 Nov 2022 02:34:40 -0800 (PST)
Received: from step1.redhat.com (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id m11-20020a5d4a0b000000b0022ca921dc67sm9632802wrq.88.2022.11.08.02.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:34:40 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 1/2] vringh: fix range used in iotlb_translate()
Date:   Tue,  8 Nov 2022 11:34:36 +0100
Message-Id: <20221108103437.105327-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108103437.105327-1-sgarzare@redhat.com>
References: <20221108103437.105327-1-sgarzare@redhat.com>
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

