Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764F73C6C84
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhGMIvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbhGMIvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 04:51:00 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C823C06178A
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:48:00 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p17so10208349plf.12
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 01:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LsGekY4BvYvIO5Z8AgcJapYB7A/KQEKxuOgJFJnV+F0=;
        b=Et7FbWZVS2cx+fpTA8oSkjyi22zfg/JVBDFbigj20lktndc6w8VizCfnQbd8DLvnBV
         VNEhNSeBTNpJFAegw09Rg0mEfMyli4GMRdum0q4qn3U74w57SPrdejSMPmNtu9yMiPCF
         TiTyNrOHaIEsr8Bx2ZBmhMhJIuXrBF5pSlk5FJueUhyp4hfHn5krzzUtF6Q9Pl85RJaq
         SKkCpcUcgTDMKntqvaiRWItj7upm0Y9Xhp3HloIdnzr5/LU16LGuAsmTpAo3w7IY0Gn5
         K4vArTZXMxMG7swExsxAVe8b+arAc/H+tSgN2OIWI2JOdcmaiAlQmmKNmF3cbmgNWuUL
         EKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LsGekY4BvYvIO5Z8AgcJapYB7A/KQEKxuOgJFJnV+F0=;
        b=MrQU0ExGZof0SNMqB/+enLqgg+0CExIk29rXbzyVPpIBvv6Ffwu1wIpn0WCk9omtk8
         5VM/8eQbObhGTbjDWUk4HHfmu8LQ1QzVG2hJorDbiVl33VHFGu+DaGXMhN6vHHoES8aB
         ZANYN2m82K2LM9Z7Kod/PVwvU2FnlvQoeA4WXk1vje4qbHP3aHntquhAcM3ZFHZdfsIB
         1UBGCmJedjyk2uwOn7caZaeQyM/GAsdmFQXs8JdKuc/X/G0M4YX66llbkW/joKDmL+lC
         GUUcGyNo41daSwNtX/38emZToXprDdV6a44pDHKtm74YQlSLiP8SbjYH9Hxg76y9WJru
         C0mA==
X-Gm-Message-State: AOAM531f1G0uxRccB4gpRy/AF9dnU1dx32yzItvrjpwEb4QfllIjJtHE
        WAPsyIT6PW8ChZ0K0GFcb3VF
X-Google-Smtp-Source: ABdhPJzFJWinFNSX5sjhEi7EUxUYGzqDtd7WH488DhV7Pgm2CsQABcNDQNUVm8LAg6MjG7Qz0MbUVw==
X-Received: by 2002:a17:90a:5b07:: with SMTP id o7mr3372998pji.35.1626166080091;
        Tue, 13 Jul 2021 01:48:00 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id x10sm2437739pgj.73.2021.07.13.01.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 01:47:59 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 10/17] virtio: Handle device reset failure in register_virtio_device()
Date:   Tue, 13 Jul 2021 16:46:49 +0800
Message-Id: <20210713084656.232-11-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210713084656.232-1-xieyongji@bytedance.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device reset may fail in virtio-vdpa case now, so add checks to
its return value and fail the register_virtio_device().

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/virtio/virtio.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index a15beb6b593b..8df75425fb43 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -349,7 +349,9 @@ int register_virtio_device(struct virtio_device *dev)
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */
-	dev->config->reset(dev);
+	err = dev->config->reset(dev);
+	if (err)
+		goto err_reset;
 
 	/* Acknowledge that we've seen the device. */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
@@ -362,10 +364,13 @@ int register_virtio_device(struct virtio_device *dev)
 	 */
 	err = device_add(&dev->dev);
 	if (err)
-		ida_simple_remove(&virtio_index_ida, dev->index);
-out:
-	if (err)
-		virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
+		goto err_add;
+
+	return 0;
+err_add:
+	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
+err_reset:
+	ida_simple_remove(&virtio_index_ida, dev->index);
 	return err;
 }
 EXPORT_SYMBOL_GPL(register_virtio_device);
-- 
2.11.0

