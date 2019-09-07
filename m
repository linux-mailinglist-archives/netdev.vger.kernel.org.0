Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFFAAC4C5
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 07:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394446AbfIGFaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 01:30:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52487 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394420AbfIGFaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 01:30:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id t17so8446867wmi.2
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 22:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eGHarff9FRFVkSuJ2XYS/AC6bZO7MZEONTwO+G1Ua7A=;
        b=seRsbNMQqAN+Bz7PLLOYm7tTC18/gfYzeGKHznsfj9sncbl9AtlwkZGuIVwEj+PaM0
         Im5X3nWEJvwz+DQ6ZG85dqV0iPv+iA/s3W3GdY4SzdJFJQfY1O3Wy2SBInsaLP8+UvEc
         bNZFhonNv2jz/o5IKa4m6LYXYki8D+L68cekzaOBJrcTvZWXnmTlGH1srPPdGSOSN92I
         DkhBIc59Z4v9EGCxI2qmsbJouyVH5Kw23Za/nTNDoPoTedRkjcl9nTmioor/HNbiaTm7
         wPVKeQ25ZNpaU+mfygIc5Bghy0yuwLG4E6wRiYYhBhfiTstR0kIk/fau33cAPYNEL3im
         KmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eGHarff9FRFVkSuJ2XYS/AC6bZO7MZEONTwO+G1Ua7A=;
        b=hOek5NYaM9w+LadXrePXBp3eyfDWF86Op0TOQwyujmKd4h+J//O8GwiLDf+/FgLjSC
         YxPsaAzPFw3O43AtP6BRLq9TZ62NbCZ2mkztFrbeXQuo1gu7A9cUk9a4/YHNKdCSmWGI
         9tYiRFvUfCI6SSLOILe4YnsLhDCXGaVwbiIddgA5NCilT+XTvuCJTGHE5KewZ3XnrFT1
         Zci2eSM+oKNVkQrBivmlP9SUXDEjLkIBdxitKQ21yZyYMNelCIa7i/Xs2CaeyZFbemxi
         ZIao6GTTSi2I12CR9b7Oq7nezc/xjzZM0arCrs/gt4BM0Ouc+y8PvxkCrgI6lpKCI6cP
         qEYg==
X-Gm-Message-State: APjAAAWdk9ZTBFuYU0gx6/dGT+Dsv/Nq60wtyQbyYwu2WY02bDDkwyfT
        Z0v5B25pCf5ek6fYyTQPn8UKLg==
X-Google-Smtp-Source: APXvYqxFCC5+LiVjd9f7WE08SVNUxSpDx1WqnLUJifSC/L+y5jOEB/rVjj6nyQNi2H7k0uktltCCpA==
X-Received: by 2002:a1c:1981:: with SMTP id 123mr9791837wmz.88.1567834227955;
        Fri, 06 Sep 2019 22:30:27 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n4sm2446939wmd.45.2019.09.06.22.30.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 22:30:27 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 4/4] net/tls: align non temporal copy to cache lines
Date:   Fri,  6 Sep 2019 22:30:00 -0700
Message-Id: <20190907053000.23869-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190907053000.23869-1-jakub.kicinski@netronome.com>
References: <20190907053000.23869-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike normal TCP code TLS has to touch the cache lines
it copies into to fill header info. On memory-heavy workloads
having non temporal stores and normal accesses targeting
the same cache line leads to significant overhead.

Measured 3% overhead running 3600 round robin connections
with additional memory heavy workload.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 916c3c0a99f0..f959487c5cd1 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -372,6 +372,31 @@ static int tls_do_allocation(struct sock *sk,
 	return 0;
 }
 
+static int tls_device_copy_data(void *addr, size_t bytes, struct iov_iter *i)
+{
+	size_t pre_copy, nocache;
+
+	pre_copy = ~((unsigned long)addr - 1) & (SMP_CACHE_BYTES - 1);
+	if (pre_copy) {
+		pre_copy = min(pre_copy, bytes);
+		if (copy_from_iter(addr, pre_copy, i) != pre_copy)
+			return -EFAULT;
+		bytes -= pre_copy;
+		addr += pre_copy;
+	}
+
+	nocache = round_down(bytes, SMP_CACHE_BYTES);
+	if (copy_from_iter_nocache(addr, nocache, i) != nocache)
+		return -EFAULT;
+	bytes -= nocache;
+	addr += nocache;
+
+	if (bytes && copy_from_iter(addr, bytes, i) != bytes)
+		return -EFAULT;
+
+	return 0;
+}
+
 static int tls_push_data(struct sock *sk,
 			 struct iov_iter *msg_iter,
 			 size_t size, int flags,
@@ -445,12 +470,10 @@ static int tls_push_data(struct sock *sk,
 		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
 		copy = min_t(size_t, copy, (max_open_record_len - record->len));
 
-		if (copy_from_iter_nocache(page_address(pfrag->page) +
-					       pfrag->offset,
-					   copy, msg_iter) != copy) {
-			rc = -EFAULT;
+		rc = tls_device_copy_data(page_address(pfrag->page) +
+					  pfrag->offset, copy, msg_iter);
+		if (rc)
 			goto handle_error;
-		}
 		tls_append_frag(record, pfrag, copy);
 
 		size -= copy;
-- 
2.21.0

