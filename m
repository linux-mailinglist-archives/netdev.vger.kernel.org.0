Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E689C8FA
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfHZGLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 02:11:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40505 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729348AbfHZGLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 02:11:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id w16so11091070pfn.7;
        Sun, 25 Aug 2019 23:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=brzyMJQEtSFOlIzSlYHmlx1qPiPRfraKFBoTUSQ5qVQ=;
        b=n7ol3gsfiohlI1FScybVRGDTue1g+Ikn7EjblmPNIveow6Xy31i6wKUjsz+mfuUiky
         k0rlNx4cdzbjPD3IdYMfrTW8EyXuk9QETcQDmHBJAKbkVIhrLr1x5m9gb2VNeqr5Jujm
         LX0fYrIfbiwOLxZdwfZawRA4F77hjA4NdGGGTtMjtiI7xU2U93YFAFoU1GAOfz4Oldj0
         ZsojSiC8BJmrT/pxJcf0P8lu2EnIoN4pvx7ltceW3VCETwStrmyA6UDparAU9BKZa4tI
         +wk8gBtds9lEnatC/AdETWBu+SjQCyGrwFBlQErINVntYRLRDqkmwhG1H4vDm15jckWr
         3pwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=brzyMJQEtSFOlIzSlYHmlx1qPiPRfraKFBoTUSQ5qVQ=;
        b=gf+1LgikoLpPISVJ+8CnBQVYyaydChSe14HQiP0AKBiauzVqyNi8arZYcsj6MKQaSs
         KFL5n3ufwr8DuDBsrNBK6ykxBDOOvQFEBY/PMKV99U2rxxzMSdKOZBDroHK7vD2KTUem
         VpOe1ra2oOMvi+uDP9j5Z12PQg1B4zrkgjMs0B3rRWNo49Ee19p8TKZQaPpGrOxIiCmQ
         A4UtKZQPZrWPDxKeQ1wEh4qr4GKp5IPC9VjyMH8esGr+Y/6jwMzAafQTcIEpLw61bzk5
         Ys39P/n0Bloxy0pQMjqJRRTQOOHkVit+FFOXPQVQBbY7bx/Zzw2Kzw4891CLqRh5kLJ9
         uddA==
X-Gm-Message-State: APjAAAV2xB9bL4uH5Iapru1C1MoQhDEOCSSDB2qngqU029Et8wimd4gP
        nsWXZqFV2nKpUy9C99x52bM=
X-Google-Smtp-Source: APXvYqx5JPVlgeMaKavxNyIJ4ZN38gQeIKtMPhMaVZrOl8HQmaqDsrEvUBLI3ALWdgSyTz6zkH4mwA==
X-Received: by 2002:a17:90a:eb05:: with SMTP id j5mr18461277pjz.102.1566799880636;
        Sun, 25 Aug 2019 23:11:20 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id d2sm9567452pjs.21.2019.08.25.23.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 23:11:20 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v2 1/4] xsk: avoid store-tearing when assigning queues
Date:   Mon, 26 Aug 2019 08:10:50 +0200
Message-Id: <20190826061053.15996-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826061053.15996-1-bjorn.topel@gmail.com>
References: <20190826061053.15996-1-bjorn.topel@gmail.com>
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
index ee4428a892fa..f3351013c2a5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -409,7 +409,7 @@ static int xsk_init_queue(u32 entries, struct xsk_queue **queue,
 
 	/* Make sure queue is ready before it can be seen by others */
 	smp_wmb();
-	*queue = q;
+	WRITE_ONCE(*queue, q);
 	return 0;
 }
 
-- 
2.20.1

