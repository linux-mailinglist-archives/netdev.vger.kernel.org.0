Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FA43FB7FF
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 16:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhH3OXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 10:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237159AbhH3OWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 10:22:55 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA35C061760
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:22:01 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id c17so13639549pgc.0
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 07:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Vl3AHwuQDLe0ZGngtEfFx668CIPSygY8Oaw4ZN4vCo=;
        b=rOdETcL4sxH6ECF/nEWQheSNSVqzE5EKTelanx7BQ2PKWpnXFO6rmcX6i+tCUi8Q32
         AYhqQkRrQa8EM7Bg7uRVJpsWguCG/stc4586BP6z6HBxOgZA6tDWfdRMnIhAzki5h5Ae
         A82GZnSP8cgEvspkQScLL8aSkhfVODJdv20wuKYROYhTPUQtHuCZ+ptiQo11dwBrvO6m
         JnbAIlSoMDWh/dofuquvv4s679GbOun0rVEEBVvEugywnej8zFSKmn+WI+VcVePqAa9P
         nSbFhH7u6iJ2ak14mt/Ka7JrjUwobfmDsaC4muwtLv2rse7bm0Cd65KsJK9uWREPsFly
         Kfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Vl3AHwuQDLe0ZGngtEfFx668CIPSygY8Oaw4ZN4vCo=;
        b=dpC0ozQaFADFDsTMoSFLvUWYawDpe1pyG+jhWE0fqRw2wGAm1nuwHKqPD7toH/dqig
         Qs9VqMf8ziPxD9HC6WgNIMVvB1KjGO0ISVOPgoI47czg0TzZK+QQ+I7cF1jkhkG8hxTu
         2tPliQfUnH3ItRSXSlAbbrAQLlq7jtkal+q2z4MrRXzlyisz5gcEcW/ZfMmloGlF4z9T
         AeGGdspB3N3uVYtgRQeB4VxgjUiqRW/7LKmvsD5/jiB056SnYLJ1e33fF2U61zxTN3/K
         CEfLWWW7y+tu0oagR6QuuPogKSm5eUpAzNzc+d1XHHyMB15aUgm0ucSnoDSdMQPxUZdn
         PaKg==
X-Gm-Message-State: AOAM532H19r2or4VEJNGBC6AScnFPVe5/5pFoZ/x60phwq6rFCPPjKe+
        sgciHNs7AyTt7urLwC1w5X0r
X-Google-Smtp-Source: ABdhPJyuMdXMw+vCPINhRkPdClG/pBGJOxyP0dOUhBuVr8N6XWMqky+vJCs5bkogn8kzhLBwyta7lQ==
X-Received: by 2002:aa7:8014:0:b029:3cd:b6f3:5dd6 with SMTP id j20-20020aa780140000b02903cdb6f35dd6mr23512141pfi.39.1630333321384;
        Mon, 30 Aug 2021 07:22:01 -0700 (PDT)
Received: from localhost ([139.177.225.237])
        by smtp.gmail.com with ESMTPSA id b17sm4424962pfo.98.2021.08.30.07.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 07:22:01 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 02/13] eventfd: Export eventfd_wake_count to modules
Date:   Mon, 30 Aug 2021 22:17:26 +0800
Message-Id: <20210830141737.181-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210830141737.181-1-xieyongji@bytedance.com>
References: <20210830141737.181-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export eventfd_wake_count so that some modules can use
the eventfd_signal_count() to check whether the
eventfd_signal() call should be deferred to a safe context.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 fs/eventfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index e265b6dd4f34..1b3130b8d6c1 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -26,6 +26,7 @@
 #include <linux/uio.h>
 
 DEFINE_PER_CPU(int, eventfd_wake_count);
+EXPORT_PER_CPU_SYMBOL_GPL(eventfd_wake_count);
 
 static DEFINE_IDA(eventfd_ida);
 
-- 
2.11.0

