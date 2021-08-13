Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266343EB925
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242986AbhHMPWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244164AbhHMPUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:20:53 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D896BC034028;
        Fri, 13 Aug 2021 08:14:38 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id a7so16054071ljq.11;
        Fri, 13 Aug 2021 08:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qGBykzUHvO+mc7m2ZKZa337KSvPaPnpDZaAGPG4FlFk=;
        b=QKxeBCKrnNdm3R2q7WeaN94xWSbe/WNi98zc2dW9Dj7KtQVa27JD8wo4H5X9Aqh9CC
         9QGXM8FajTygobcNOOPNr0pi1Jjbb2arclodxpqb5+mCclK3iFunzvvbnZv9Y3xT4Pi9
         4dEwSEIDIJyVw4+8GpMQClxB/wVjYBGWKSngLnnTlXhaLFJZMpiOiy5OluO2FUL8jkpv
         1uVFeyuNokLgq6xtIReFGKVeIaG4iYCEvdd0LkkmBLt96R4LaK2QADx5i8XJMCm9XlaF
         67G65ecQjJvM7BT6VUpAYblvcfdIO/ULZ30zllGle568EeF3oACnKBz4+ZIJgv6MO8pF
         fYSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qGBykzUHvO+mc7m2ZKZa337KSvPaPnpDZaAGPG4FlFk=;
        b=MUJOvd+v+Ozuq7Vo50S8V4x1PP8AoxXg5uYJQhz5Xbgyr9HbqoGkkfW4A2+uqCOwqB
         38qqXisZgYHNgngE82yLg/IckirmekcResFkEuGConrBbH7VgQa6oQGTNFXyURFIrOas
         BTB34uWH8dvwIozskvZiXpt7ugV8OyVhgENkLkbwQkpLOoTpXexhdJ+AUd0XBWMLKJD3
         H/vhvK98WmfM56f4RkCVqfTk5x8sPRDT+LhNhxGDYDP2yW0V7Fx3Xhl/Hwn84vjnxzlS
         wLbIZS+hyB9h2pW2AVMFdPqEcVmzzzCmYoaS36ffxEVYUjtCJmC+12q42BHbPkAM1tgz
         T93w==
X-Gm-Message-State: AOAM532JrxX0xLgsoKKxEfxKJw20q/OOrZ/vg9td/29ZxSYbcCWZG/lK
        EBHCbuLvC/VqTVsaN5vMxVs=
X-Google-Smtp-Source: ABdhPJza/AsXX9Eah14o12B8iPtsO7VrEukozhO9ruzowumVxbf/75KPyBAePWh5VdfNtCwKP0+IcQ==
X-Received: by 2002:a05:651c:49c:: with SMTP id s28mr2150046ljc.189.1628867677175;
        Fri, 13 Aug 2021 08:14:37 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id q16sm180788lfg.102.2021.08.13.08.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 08:14:36 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
Subject: [PATCH v2] net: 6pack: fix slab-out-of-bounds in decode_data
Date:   Fri, 13 Aug 2021 18:14:33 +0300
Message-Id: <20210813151433.22493-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813145834.GC1931@kadam>
References: <20210813145834.GC1931@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported slab-out-of bounds write in decode_data().
The problem was in missing validation checks.

Syzbot's reproducer generated malicious input, which caused
decode_data() to be called a lot in sixpack_decode(). Since
rx_count_cooked is only 400 bytes and noone reported before,
that 400 bytes is not enough, let's just check if input is malicious
and complain about buffer overrun.

Fail log:
==================================================================
BUG: KASAN: slab-out-of-bounds in drivers/net/hamradio/6pack.c:843
Write of size 1 at addr ffff888087c5544e by task kworker/u4:0/7

CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.6.0-rc3-syzkaller #0
...
Workqueue: events_unbound flush_to_ldisc
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_store1_noabort+0x17/0x20 mm/kasan/generic_report.c:137
 decode_data.part.0+0x23b/0x270 drivers/net/hamradio/6pack.c:843
 decode_data drivers/net/hamradio/6pack.c:965 [inline]
 sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]

Reported-and-tested-by: syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	+ 3 -> +2 (Reported by Dan Carpenter)

---
 drivers/net/hamradio/6pack.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index fcf3af76b6d7..8fe8887d506a 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -827,6 +827,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
 		return;
 	}
 
+	if (sp->rx_count_cooked + 2 >= sizeof(sp->cooked_buf)) {
+		pr_err("6pack: cooked buffer overrun, data loss\n");
+		sp->rx_count = 0;
+		return;
+	}
+
 	buf = sp->raw_buf;
 	sp->cooked_buf[sp->rx_count_cooked++] =
 		buf[0] | ((buf[1] << 2) & 0xc0);
-- 
2.32.0

