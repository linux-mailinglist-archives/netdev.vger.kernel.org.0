Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760F03FC614
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241285AbhHaKjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 06:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241102AbhHaKi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 06:38:28 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040C1C0617A8
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 03:37:12 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e7so16222674pgk.2
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 03:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Vl3AHwuQDLe0ZGngtEfFx668CIPSygY8Oaw4ZN4vCo=;
        b=wObpuu7touPHyE2FlMtp6j82DVKvgvJGqxVDpQh426PCA4G0/SKGQXKEyHJVZQ8cIm
         L9XkoweTnt+6I4BW0Mn5WMJvosr3G5o8gM7IIYvH3KGm6heQlvcQObzommcU8i7cnUT0
         QRgkYd46omJIk7r6/K6p/cRey3grFpdCYxr0txvNQ+lkyVHC2OMROz/ezIQJEf6W9yvR
         2jeQJkG2XFVufs6nY4wO6FwV8xejE3tq1kLU6PROTvNysrRr7cvUwW3cLlScU5q9AQEA
         thnUcb8QN1ab0y0YDAkUPLMGlydGB6EUB2ANfuVz00VX5Kyh4O6qNPMi5OPi5yf/pyIu
         26kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Vl3AHwuQDLe0ZGngtEfFx668CIPSygY8Oaw4ZN4vCo=;
        b=MfUqMSrVehzBN/t7JbKFc/lVMZPOGWF8IjMBN7PNr8uTjDX4rUERIbpzxCya3wPS0L
         mZRHUo3FeKHtjDUaAh+r1rvjChTChLInPtM20XD+Uq10YaIL8a9kay3TkwjEbLDbsrqx
         Tk4QiO/ISv9vQwdeoKhqRr2sSqdn7FGFhr4wG0TYq3gZHbfwHsE5pEs7qLqjGfuZCmDL
         jC5kVHyUtDYH2HxlTlRCLDT6MQh6eqi7ZoNZBcSq8k6A4X122b+RFLQVsC9XBEjNWbK3
         r5uADlWam3TjKMxoQzNhCaCtNTslG5cQ9d9AMbuuIcOQ2LyW5YNc9bFP8+EhkmW+fNtG
         y5kA==
X-Gm-Message-State: AOAM53026LzK+SFYDPntUgZbBP+XzQ8XdpE7se/+onIfe9V1ocx+xxLs
        EOPJ9f0KG05A+tmLN44U0EfY
X-Google-Smtp-Source: ABdhPJypZEfGrqo1WgyHIL6EcT5LWw7WqnAwRGMuQX/YOGdJQ19c5iZukJRXGO5wvdTG9X6CBrVIsA==
X-Received: by 2002:a63:101c:: with SMTP id f28mr26080762pgl.330.1630406231592;
        Tue, 31 Aug 2021 03:37:11 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id x15sm6941154pfq.31.2021.08.31.03.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 03:37:11 -0700 (PDT)
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
Subject: [PATCH v13 02/13] eventfd: Export eventfd_wake_count to modules
Date:   Tue, 31 Aug 2021 18:36:23 +0800
Message-Id: <20210831103634.33-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210831103634.33-1-xieyongji@bytedance.com>
References: <20210831103634.33-1-xieyongji@bytedance.com>
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

