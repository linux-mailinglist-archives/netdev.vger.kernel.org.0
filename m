Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2933D9E87
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhG2HgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbhG2HgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:36:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECDDC0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:36:08 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t21so5904320plr.13
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 00:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x7lCOA+2uHcoDlHpnAPiyr08qHLnKknrRwhD42bW14c=;
        b=L3+zrqxq1jDIch5mBMRlq4aMkZWeJXNgz//RgYj4u3V1lMU7q20ZSp16442c0mWaWo
         3pimykQ5c3xo5hFxpe8YP2kPqJRUDXMEfySemYatlQJMfgm4TKPWnxljrQ4scQVJVmAe
         SgYBeBiHSj6pBrjI7edJBnGY1o6V08/DYlBoSrgQMsrmRK906zgqaAWchZrUKOHWJ1s2
         G28MPqjFEY3cvBXfzP0Rxts8xu3e5wgWbnD4qAUWn0c4JOpCgg0t7ExynJrXsb/Lqv0X
         wvgLL4SNtH3zcQoSC98vHFIPnTb8V3qERqJnvlidDS9Zlh9UapAb0RrBTxogd7yCCZ8j
         K9/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x7lCOA+2uHcoDlHpnAPiyr08qHLnKknrRwhD42bW14c=;
        b=j/6/1HuVTBWzbZ5kZ3/guW8wmaK3/fcAnXsIk2A+CWcLECWje2ytq0Nfgn4CwVtCOs
         uGCtk98zIHU9SbJmdMyTgjjWspXM7Wh8ncb96PnrxKI/YaI6tB+qjN3y1NXhreDLrqIA
         zpkxLkBbpxABv17W64NB2VGSPt4efx6ODzg/F9uoVtR98WzCXNybc+62pQ/8Re2bTrKc
         NnjXK4okGeRsxZh+FjG4hN5lPoTD2coFN+NqwgkncU1y/2wq31AjYGE11AhH5IDgG80N
         LKehkEjimHYi7q8JzugFcwslruS9BGRY12A0SwjzmC1kHmYdFGfsZE6nQRaTVEtAMk7B
         SHvw==
X-Gm-Message-State: AOAM531wJp7/txJ/Nkd60SeOq5qDqyhWNIUz9cBak9ejhhNYlHj+hxZz
        LAfpYnS4kApWQ15kyvaTPdVs
X-Google-Smtp-Source: ABdhPJz6gtDSzVbKQwR9fMTMuBAxDE/HudL65A5sjPsB1aFvsDsAWmfl9tE1fqIYigp4LRfAx1lPGg==
X-Received: by 2002:a62:804b:0:b029:328:db41:1f47 with SMTP id j72-20020a62804b0000b0290328db411f47mr3610895pfd.43.1627544168542;
        Thu, 29 Jul 2021 00:36:08 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id y8sm2535031pfe.162.2021.07.29.00.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:36:08 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 02/17] file: Export receive_fd() to modules
Date:   Thu, 29 Jul 2021 15:34:48 +0800
Message-Id: <20210729073503.187-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729073503.187-1-xieyongji@bytedance.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export receive_fd() so that some modules can use
it to pass file descriptor between processes without
missing any security stuffs.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 fs/file.c            | 6 ++++++
 include/linux/file.h | 7 +++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 86dc9956af32..210e540672aa 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1134,6 +1134,12 @@ int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
 	return new_fd;
 }
 
+int receive_fd(struct file *file, unsigned int o_flags)
+{
+	return __receive_fd(file, NULL, o_flags);
+}
+EXPORT_SYMBOL_GPL(receive_fd);
+
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
diff --git a/include/linux/file.h b/include/linux/file.h
index 2de2e4613d7b..51e830b4fe3a 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -94,6 +94,9 @@ extern void fd_install(unsigned int fd, struct file *file);
 
 extern int __receive_fd(struct file *file, int __user *ufd,
 			unsigned int o_flags);
+
+extern int receive_fd(struct file *file, unsigned int o_flags);
+
 static inline int receive_fd_user(struct file *file, int __user *ufd,
 				  unsigned int o_flags)
 {
@@ -101,10 +104,6 @@ static inline int receive_fd_user(struct file *file, int __user *ufd,
 		return -EFAULT;
 	return __receive_fd(file, ufd, o_flags);
 }
-static inline int receive_fd(struct file *file, unsigned int o_flags)
-{
-	return __receive_fd(file, NULL, o_flags);
-}
 int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags);
 
 extern void flush_delayed_fput(void);
-- 
2.11.0

