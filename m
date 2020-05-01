Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8001C1CA3
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 20:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgEASLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 14:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729138AbgEASLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 14:11:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240FEC061A0E
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 11:11:17 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l12so2016197pgr.10
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 11:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sEE+9q9q/1h8du81gQRd9iPK//uageAjQ+T/D7pnVnA=;
        b=izv/Qvdm/97RDV7LoigbPI4MpwOrem463I5zIj+7J4Hqrg4/9+ocDBrMZWRqx/ggGu
         y2BGQ9IiOZT0i94kWD/NwdUdd4j+xeD3LhCccTkwyHOvMUalaupSDHENcXjDdWuiN9gr
         PxktAx6OENX5TavmKUYcoQ/HR1YotwhnnQAUO3Y4KNH0EQJUNRbsKxLRGfYyld4BJZsv
         kIg3B4XJekJg3By35gH2I1rX6iQSc/YcBJ8IhFBAP6k+Ps90/AfMee3ffAjwT8/xTvoC
         t6L1xW0bn6F+6W27tkzXTdhF6Wx4GFjcdqswb1FesilR34LVsawbTCeZwV1HbBkQi7Pw
         3wTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sEE+9q9q/1h8du81gQRd9iPK//uageAjQ+T/D7pnVnA=;
        b=LPFN7he8kMwJ4tP/VsbJ4DBgGpH0RO5lTgnnrBLHAq88cdU/8ZsrKcRUFCp8F0hbw9
         Ez7CEELe6OBy8Jcdj3NxTc5OQgfO/HD2cGkNOpXlkfQiAdtm4T2xsHMBJLGClxgQ6Otg
         EiKWT20VJpb7StceQ0A0DoEOcaQkakcfLqEH16ELMnInf5J/tjN6RB079O/O4IAlduso
         6dthfbv7xn9VP7JD7kNybu2i11ZQ5xeUaNBipI6Vj+ZZhoa2h6iZW4IZPZvRT6HoIAgT
         r1rm2YcKxGPAJsMJbfTxc/pu1ceqqSy3MJnP80db+zwPOHpOXfJpKY4fPUSYgKxQmws0
         NffA==
X-Gm-Message-State: AGi0PuZImLrDVh1b7eXBVE3MwcULfZZYzPRDQ/0r3uUM9JXu6a5rDjW2
        QOcoxIMQsBK3ZBF5Yeq+/A6QTR5lyOM=
X-Google-Smtp-Source: APiQypLpTydLleVU0e3q5pMQH2PR9F6jnlYUNfahLRDS2VQ7Cg9ONU3OZJ4Gv0np97AEeBYQyBtpbQ==
X-Received: by 2002:a63:e10f:: with SMTP id z15mr5309139pgh.88.1588356676537;
        Fri, 01 May 2020 11:11:16 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id d12sm2881138pfq.36.2020.05.01.11.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 11:11:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Gengming Liu <l.dmxcsnsbh@gmail.com>
Subject: [Patch net] atm: fix a memory leak of vcc->user_back
Date:   Fri,  1 May 2020 11:11:09 -0700
Message-Id: <20200501181109.14542-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200501181109.14542-1-xiyou.wangcong@gmail.com>
References: <20200501181109.14542-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In lec_arp_clear_vccs() only entry->vcc is freed, but vcc
could be installed on entry->recv_vcc too in lec_vcc_added().

This fixes the following memory leak:

unreferenced object 0xffff8880d9266b90 (size 16):
  comm "atm2", pid 425, jiffies 4294907980 (age 23.488s)
  hex dump (first 16 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 6b 6b 6b a5  ............kkk.
  backtrace:
    [<(____ptrval____)>] kmem_cache_alloc_trace+0x10e/0x151
    [<(____ptrval____)>] lane_ioctl+0x4b3/0x569
    [<(____ptrval____)>] do_vcc_ioctl+0x1ea/0x236
    [<(____ptrval____)>] svc_ioctl+0x17d/0x198
    [<(____ptrval____)>] sock_do_ioctl+0x47/0x12f
    [<(____ptrval____)>] sock_ioctl+0x2f9/0x322
    [<(____ptrval____)>] vfs_ioctl+0x1e/0x2b
    [<(____ptrval____)>] ksys_ioctl+0x61/0x80
    [<(____ptrval____)>] __x64_sys_ioctl+0x16/0x19
    [<(____ptrval____)>] do_syscall_64+0x57/0x65
    [<(____ptrval____)>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

Cc: Gengming Liu <l.dmxcsnsbh@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/atm/lec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 25fa3a7b72bd..ca37f5a71f5e 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -1264,6 +1264,12 @@ static void lec_arp_clear_vccs(struct lec_arp_table *entry)
 		entry->vcc = NULL;
 	}
 	if (entry->recv_vcc) {
+		struct atm_vcc *vcc = entry->recv_vcc;
+		struct lec_vcc_priv *vpriv = LEC_VCC_PRIV(vcc);
+
+		kfree(vpriv);
+		vcc->user_back = NULL;
+
 		entry->recv_vcc->push = entry->old_recv_push;
 		vcc_release_async(entry->recv_vcc, -EPIPE);
 		entry->recv_vcc = NULL;
-- 
2.26.1

