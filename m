Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67D498EE7
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 11:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733042AbfHVJNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 05:13:48 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33623 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733031AbfHVJNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 05:13:48 -0400
Received: by mail-pl1-f193.google.com with SMTP id go14so3098748plb.0;
        Thu, 22 Aug 2019 02:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mzlRM96REuEosfmv5S1FfhcU+k21Y3nuygBDyIBSw50=;
        b=Rps69GMhSWVcDbR9c0fC/T58yszbwmfHp6VP9wSWe8S+/IFknD4+xjJlyRF5wfwVeK
         yso60e8F9ElHDHGziAEsNP3m0C14l0LH2UtM0C2sZDhcO0ZYi4Ig5VzCRFGtJkEcW6T7
         wIQWGX9cqw9X6O0Ds+n1AeiqvLZSmVXUmjWS6YbPCf/580SelT9z1iRUWi1YoXYee9jr
         OEmaj8oIKHhS7dltoOe00V1qKaRRr0l+kSO+LzUQU7SU4dKOe9o5W2r/qM0Wc0bxWH5q
         rTrqhOKx4BD1H1R5mAl8OwQf0fyUaQA+SQL45tWWHij/jpno0NTCWhfYcJ7YJ1vzwyXh
         79iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mzlRM96REuEosfmv5S1FfhcU+k21Y3nuygBDyIBSw50=;
        b=Pob/bdQ4dpwzz/cUoj3X/A9IDTle+yS+coQC/5Ob/OvVlN+BeNOqzAWwbbJ/vCMvrK
         1R1YGQPJ+5dDpIlW4m9XY3Bp3yycp+Ak0Q5B9Pz9+Lzr9HWEW1gk8M9Slw+SIOqqNlNe
         Y+qWzp5/ZumKHUrZSaCC3tPrEbW6Xh77V9qwlsXSadBlRfwSWaBLYxfYJQCwbgltZzE5
         J75E9jw4kKijhptf2FfRtzXCNqG1GBpHb7xabOfKA8oG59eo1TOnr4ZySAVcj+WDC2e+
         28BRRP38It2O1iVjgF/0Wpms9ObpANbUYHX4hN9L801TuidJeQUE+FNYbwaKvMIH00+Q
         blQg==
X-Gm-Message-State: APjAAAWMfeesYrQM7hyIfxb0x2M9S3oyZcAGtGC93Ef+2upUnRkAzRXr
        lej3YecnVAswUeEhkvS+SUQ=
X-Google-Smtp-Source: APXvYqyAyhGuZwD/a7dtPd3MK5m7Ju3Xe87NjOMlx1X+VZ6YbeyaLtyvdRRWO+llLMWXFwms8uDMDQ==
X-Received: by 2002:a17:902:8f95:: with SMTP id z21mr38616146plo.42.1566465227259;
        Thu, 22 Aug 2019 02:13:47 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id w207sm28414754pff.93.2019.08.22.02.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 02:13:46 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next 1/4] xsk: avoid store-tearing when assigning queues
Date:   Thu, 22 Aug 2019 11:13:03 +0200
Message-Id: <20190822091306.20581-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822091306.20581-1-bjorn.topel@gmail.com>
References: <20190822091306.20581-1-bjorn.topel@gmail.com>
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

