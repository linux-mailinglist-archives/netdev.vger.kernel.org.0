Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC8130BAD7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 10:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhBBJXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 04:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhBBJVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 04:21:52 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99448C06174A;
        Tue,  2 Feb 2021 01:21:09 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id m22so15687827ljj.4;
        Tue, 02 Feb 2021 01:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rLnGvO/qQHa2EWoyYFO5NVkGeyHgHfQpLXHqwUMHMr4=;
        b=mDNKERf1KBX0XmIX4zsOhJb63ydOHXL2XHEFNpHjVjlJ7u6D8d7FN9Wr3y5MOL88C5
         wQ+3jiGTBq7GgicBJ1KM8Xub/5seUqxsdRJZxuvITLuf9wSFIR1lntBv5eDcM0HJt9/o
         lQQLV2plNX3z6ES1abdAsowBtTpGpwimCjJZc7mwpRa8o90GhTODHBZLUZ0I2u+5j/5j
         /iQ6AtTk9uNcP2Yr+V4WKjg44gsvhrYVJgmOlNBJnqVfQtBxS34dy0TsnQt49Qf9iuAa
         etccBCTLA3iAAhBxnQL7sIx9xw7D9gd6Ijlb/ogKibgy/CPhUqob+F7eCs0rAfAZr8sD
         N5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rLnGvO/qQHa2EWoyYFO5NVkGeyHgHfQpLXHqwUMHMr4=;
        b=W/l4MXNb7p25IUOnzRDKbj2D2HveqEOfiXb/vD3kHGopYh3aFssmSL913Zwartp1av
         fLWRR0WV+m77nVS2xZzBZI1z4xXEgpy6l/FWUgvQeGbFwI/tkNMlk55Ln8uvLushnogU
         BFkEruMyMgKYeC8QwVCMf9Uk373Q7/SEwGy0ocTU0DGVsPhcSgOZzPzLq/Oci4thVuyh
         2Mg9vDOGVAu9eLXlOnbuitzRKUMh4PDnpus772scLOv0aArCCkqrae1BZ15Dy85ywY/w
         7gIYOCVhnkgSk0tlMz0V7xqi12QqXx5J0nP38N/izooRtX3xy3Pr2yRvKbcPggLxKjqw
         uODA==
X-Gm-Message-State: AOAM533L6FzyhS+QcWYgZxgNFxiGLX5JuC8cDZYrCMu7BqwKyBhWaUJj
        jdDhMa0j4yL+VeNopElzFMQ=
X-Google-Smtp-Source: ABdhPJy3u8txAbV4kKg26JT2C4g4fzcj8b4ktT2GGh0vXRJ7U3zgmPVu9Uv3X085E4iNnQ/PqRQQ3g==
X-Received: by 2002:a2e:b048:: with SMTP id d8mr13097228ljl.138.1612257668162;
        Tue, 02 Feb 2021 01:21:08 -0800 (PST)
Received: from localhost.localdomain ([146.158.65.228])
        by smtp.googlemail.com with ESMTPSA id y18sm3213608lfe.29.2021.02.02.01.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 01:21:07 -0800 (PST)
From:   Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
Subject: [PATCH] net/qrtr: restrict user-controlled length in qrtr_tun_write_iter()
Date:   Tue,  2 Feb 2021 15:20:59 +0600
Message-Id: <20210202092059.1361381-1-snovitoll@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found WARNING in qrtr_tun_write_iter [1] when write_iter length
exceeds KMALLOC_MAX_SIZE causing order >= MAX_ORDER condition.

Additionally, there is no check for 0 length write.

[1]
WARNING: mm/page_alloc.c:5011
[..]
Call Trace:
 alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
 kmalloc include/linux/slab.h:557 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 qrtr_tun_write_iter+0x8a/0x180 net/qrtr/tun.c:83
 call_write_iter include/linux/fs.h:1901 [inline]

Reported-by: syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 net/qrtr/tun.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
index 15ce9b642b25..b238c40a9984 100644
--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -80,6 +80,12 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	void *kbuf;
 
+	if (!len)
+		return -EINVAL;
+
+	if (len > KMALLOC_MAX_SIZE)
+		return -ENOMEM;
+
 	kbuf = kzalloc(len, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
-- 
2.25.1

