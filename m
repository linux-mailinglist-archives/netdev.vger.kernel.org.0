Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4544A6168
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 17:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbiBAQcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 11:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241086AbiBAQcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 11:32:15 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8520CC061714;
        Tue,  1 Feb 2022 08:32:14 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id j10so15795375pgc.6;
        Tue, 01 Feb 2022 08:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6xhI2zbG0jNZ5yz1fLORa/ua0vNztHYbX/bz96VcvOU=;
        b=q2ZAeuPodxwJQU2rztwogjbHdGzMD0vXKNmluHDiGxY4gtRzIlQdJAWWWWWjXUSV2s
         sGBRGBuiR3MLuht7jztdnvcbWjncBC4pE7MSdoXTXEmhvXqE1YL03UhOlqmEicbtmEW3
         dttGWBz6b0XBsS4vyD/PbuGMxQIlrRMNmA+6rKW0csnsIKjValSTr588y9+Y73EefhH9
         rfLZ4sBttt02feGAlBaiVpMyZrVVUFIWbEtGK3tOgBBiHxXtZ3P7J71Tahy9yrX8xbBa
         II0n4I93snxUBwmOMUlUNpjqrSGoLwevzi+sR1ogid7z+9OZjQAJbBAGLh/X/b8FnysZ
         uiGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6xhI2zbG0jNZ5yz1fLORa/ua0vNztHYbX/bz96VcvOU=;
        b=Dl7hVXkpvlcCimWjMUbJt7bz/y8tbugyEfj87QE+1fcmPrvhgpIGzEHLhRYrgoEbLO
         lDZaQ4CVMbxMdOkrrHH9yTDsFniH8SrJYkvtMp5jEz8kSRuHOIeTor3agEsR7VNpx0rX
         bSjHut3dHAXUiHFcE4yrCYrVXva1FmM1lPE/FFYuyM06GllFr+oneI46/r7U3OZlabuk
         123SD85CsOYOPFDCi5KXlRFvxQoaIMGUae9Ze8GNhZqGoVZCHhpNEKkxQ1pJEq0uJCBK
         UlUv5IS0NBT9FwgHSSpGe8680cKKnqdtR3X/WUj+ANoxRrWZfMbmk7wPISnmQYg35bV7
         VAcQ==
X-Gm-Message-State: AOAM531Xw1Dq/+KsDhTU4U/fCIwBYZVWrg50uK6BPvPtt+xTnODuJGr1
        H05pidYnhWPi1j9jELJFbzg=
X-Google-Smtp-Source: ABdhPJw+7LhIPln247qncqytiFgNPjhSAYA88YoV7GKl+p94CA5gb2dWEyZdTkrxr+/JsoKMGn4OLw==
X-Received: by 2002:aa7:8c02:: with SMTP id c2mr25899849pfd.81.1643733134011;
        Tue, 01 Feb 2022 08:32:14 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:38:1876:8c7:1622:c2a0])
        by smtp.gmail.com with ESMTPSA id e17sm21659800pfj.168.2022.02.01.08.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 08:32:13 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Netvsc: Call hv_unmap_memory() in the netvsc_device_remove()
Date:   Tue,  1 Feb 2022 11:32:11 -0500
Message-Id: <20220201163211.467423-1-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

netvsc_device_remove() calls vunmap() inside which should not be
called in the interrupt context. Current code calls hv_unmap_memory()
in the free_netvsc_device() which is rcu callback and maybe called
in the interrupt context. This will trigger BUG_ON(in_interrupt())
in the vunmap(). Fix it via moving hv_unmap_memory() to netvsc_device_
remove().

Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc driver")
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index afa81a9480cc..f989f920d4ce 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -154,19 +154,15 @@ static void free_netvsc_device(struct rcu_head *head)
 
 	kfree(nvdev->extension);
 
-	if (nvdev->recv_original_buf) {
-		hv_unmap_memory(nvdev->recv_buf);
+	if (nvdev->recv_original_buf)
 		vfree(nvdev->recv_original_buf);
-	} else {
+	else
 		vfree(nvdev->recv_buf);
-	}
 
-	if (nvdev->send_original_buf) {
-		hv_unmap_memory(nvdev->send_buf);
+	if (nvdev->send_original_buf)
 		vfree(nvdev->send_original_buf);
-	} else {
+	else
 		vfree(nvdev->send_buf);
-	}
 
 	bitmap_free(nvdev->send_section_map);
 
@@ -765,6 +761,12 @@ void netvsc_device_remove(struct hv_device *device)
 		netvsc_teardown_send_gpadl(device, net_device, ndev);
 	}
 
+	if (net_device->recv_original_buf)
+		hv_unmap_memory(net_device->recv_buf);
+
+	if (net_device->send_original_buf)
+		hv_unmap_memory(net_device->send_buf);
+
 	/* Release all resources */
 	free_netvsc_device_rcu(net_device);
 }
-- 
2.25.1

