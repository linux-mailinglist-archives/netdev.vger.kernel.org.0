Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891BCA8174
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 13:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbfIDLtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 07:49:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43115 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfIDLtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 07:49:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id u72so6930583pgb.10;
        Wed, 04 Sep 2019 04:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rf5cm9DW3GYmLUhGmmReL+VRthRlK1ZY0sLaJ4jk6OE=;
        b=QpckPe4Tlgmy8GgSZme52KHTZXB3Vn0gU7/fatjHnpornjVrV5ShUyuUF1Q3SL6nqO
         guOyMAxl3agY7npQwHxhI7KAuHQ9oCj7arnnScXSF2Jz8U2IrFXC29YLm+0eJL5rJK7u
         0GTc/vGnL0VQZ9lb90O5cUjP/fubJpqJboaX69qIH+iDNEcnYoWPEs3D/W7ShZHKwkTg
         cvGYJOJSKBYF0sNL1Si2KLxwpbqJnfeMOz2kytdZ5xuBAllL7bpfTWDbyNlzFQ62p4xK
         CDQiMGizlj1Wd/kLfA1JI+rlT2RMgqyWvQYuC/I/675dCb9s053RswWiFj29IcvtPB+R
         QvUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rf5cm9DW3GYmLUhGmmReL+VRthRlK1ZY0sLaJ4jk6OE=;
        b=PVI9d6QWxW2WqmHKi2mvJHYkrvNZGa/eYjNrp34bHPUueZ4QxsD2mu5Y5HJD4y2zxK
         5iIwgyAyVFmoSgAmBSiihw5eOvi7JAHalaNChAXSdB7zY2/o8QwgZ6BUTRxeQUOLdJnC
         wxlgyZsxtPgwTwbv866z8bCTURlgNrjmLyNNVDv6r6LyzS/DGZIQLfgNUSW4sbRlftfp
         3QfK0cXmNDXLPXQA8cmcGfVuUI0WTk1ZDtHLDF/uVM/7upzgUBiskIOD3X1nNscjPpO4
         8GCbpLP6wepPodcv/nC/8UqoJVrlqIapDx2guBf74g7rHnCkvEYiCaJJUP9Ozw/zndKQ
         JCWQ==
X-Gm-Message-State: APjAAAVHmpxJiLi7RPjvJaOnFFSINq3hjTc6M6RW1W3lr7ba/7IORJ8a
        L9jDiBR6Riz7qzVnX1iJ5A4=
X-Google-Smtp-Source: APXvYqwun13qkIqsxwyOUGIoOqs+AD/fNEIQv/hADdErW6Gp3/ZUOfbbIp7onSS1ULyarcpvYBoyxQ==
X-Received: by 2002:a62:75d2:: with SMTP id q201mr10033584pfc.43.1567597771654;
        Wed, 04 Sep 2019 04:49:31 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.54.39])
        by smtp.gmail.com with ESMTPSA id b126sm48257008pfa.177.2019.09.04.04.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 04:49:31 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v3 1/4] xsk: avoid store-tearing when assigning queues
Date:   Wed,  4 Sep 2019 13:49:10 +0200
Message-Id: <20190904114913.17217-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904114913.17217-1-bjorn.topel@gmail.com>
References: <20190904114913.17217-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Use WRITE_ONCE when doing the store of tx, rx, fq, and cq, to avoid
potential store-tearing. These members are read outside of the control
mutex in the mmap implementation.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Fixes: 37b076933a8e ("xsk: add missing write- and data-dependency barrier")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 187fd157fcff..271d8d3fb11e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -434,7 +434,7 @@ static int xsk_init_queue(u32 entries, struct xsk_queue **queue,
 
 	/* Make sure queue is ready before it can be seen by others */
 	smp_wmb();
-	*queue = q;
+	WRITE_ONCE(*queue, q);
 	return 0;
 }
 
-- 
2.20.1

