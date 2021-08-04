Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD64B3E0340
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 16:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbhHDObN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 10:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238822AbhHDOap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 10:30:45 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C2DC0613D5;
        Wed,  4 Aug 2021 07:30:21 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id u3so4774497lff.9;
        Wed, 04 Aug 2021 07:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mKJzb3ll4dn13iZlEAdIWf6tqFSFs0x9Rq1Rej/qSjg=;
        b=ACv//ihaYWedxDc0yEk4YmwQ6HFrya4rg/t/C/kt9UkDksqBV/+bjUrlcx8dVAzfKm
         f78ZZu2jXvr2xFw6OglQ3ATEWAry3E2MdRSnKvhcM92+HfY6nfL3PnLVjMDZfBQymOw3
         JYi32nVMHitxOhbtGEMm/ezrNttJVOcCO5/ZwqBxQAXuy5HswrgEF+mFn9upqjHszBp6
         xyTkC88Egu+hYxNx9RhT5Ha875IRamZMaQpDsf5lYkTdXxpvwqYyHRMfDJEjz9Xzkrql
         2Q9OsmBjiQL/SQ8nnYx8eaiRbUsDmnxGhKQN/EQGvV7tMUByO5eqS7MptNm02Zvv6bYC
         fp9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mKJzb3ll4dn13iZlEAdIWf6tqFSFs0x9Rq1Rej/qSjg=;
        b=pgCJPCAu2o8TAVlYSHHX78SxGk2pVl9PGSaHYklz4LveLFeCLozTg9ctqDcDxUJnn3
         jDF9v/pgrIzYK/CU/sjY8AR9tLYttQb4bIUphgUvAlAvnnuNLihcTroEKEBs22ERiJON
         JbfPGDjty2Bb0YyPcR/1Fz4yD3Fq9Bp+5LnASKh18Q4xQGNEi3Kcb/i+yMtAI6hg5T2o
         uT2SzBTyiWySzynkQzP/eVGjFW+8Fpo0ScDbKVJ/UUFwKYVAg5i389T6+teU09ZjRKOe
         K05DopDbySJwSL1/uZ+Ofq0ZBH3GJU0X3Xbyc2RNHt9JqGlsYL+if4q93VOJCXa5e7bx
         Y4gQ==
X-Gm-Message-State: AOAM531UiLxQzKBCXXhvUmvinfBBHCnYp4XAV8tDaLZsQahAVll6DwDc
        e8xpuMwCEpQipu1mfgiJi+4=
X-Google-Smtp-Source: ABdhPJwkKsHNDLJ6c/JFRTey0AqGNnMx4xhUQKjGEIqRINMcv24UiA8COKYjLDaHf85zU2OcXMYAUA==
X-Received: by 2002:a05:6512:1281:: with SMTP id u1mr3461472lfs.136.1628087420062;
        Wed, 04 Aug 2021 07:30:20 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id b15sm213794lff.104.2021.08.04.07.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 07:30:19 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     petkan@nucleusys.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Subject: [PATCH net v2] net: pegasus: fix uninit-value in get_interrupt_interval
Date:   Wed,  4 Aug 2021 17:30:05 +0300
Message-Id: <20210804143005.439-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210804045839.101fe0f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210804045839.101fe0f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported uninit value pegasus_probe(). The problem was in missing
error handling.

get_interrupt_interval() internally calls read_eprom_word() which can
fail in some cases. For example: failed to receive usb control message.
These cases should be handled to prevent uninit value bug, since
read_eprom_word() will not initialize passed stack variable in case of
internal failure.

Fail log:

BUG: KMSAN: uninit-value in get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
BUG: KMSAN: uninit-value in pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
CPU: 1 PID: 825 Comm: kworker/1:1 Not tainted 5.12.0-rc6-syzkaller #0
...
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x24c/0x2e0 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5c/0xa0 mm/kmsan/kmsan_instr.c:197
 get_interrupt_interval drivers/net/usb/pegasus.c:746 [inline]
 pegasus_probe+0x10e7/0x4080 drivers/net/usb/pegasus.c:1152
....

Local variable ----data.i@pegasus_probe created at:
 get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
 pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152
 get_interrupt_interval drivers/net/usb/pegasus.c:1151 [inline]
 pegasus_probe+0xe57/0x4080 drivers/net/usb/pegasus.c:1152

Reported-and-tested-by: syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	Rebased on top of -net

---
 drivers/net/usb/pegasus.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index f18b03be1..652e9fcf0 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -744,12 +744,16 @@ static inline void disable_net_traffic(pegasus_t *pegasus)
 	set_registers(pegasus, EthCtrl0, sizeof(tmp), &tmp);
 }
 
-static inline void get_interrupt_interval(pegasus_t *pegasus)
+static inline int get_interrupt_interval(pegasus_t *pegasus)
 {
 	u16 data;
 	u8 interval;
+	int ret;
+
+	ret = read_eprom_word(pegasus, 4, &data);
+	if (ret < 0)
+		return ret;
 
-	read_eprom_word(pegasus, 4, &data);
 	interval = data >> 8;
 	if (pegasus->usb->speed != USB_SPEED_HIGH) {
 		if (interval < 0x80) {
@@ -764,6 +768,8 @@ static inline void get_interrupt_interval(pegasus_t *pegasus)
 		}
 	}
 	pegasus->intr_interval = interval;
+
+	return 0;
 }
 
 static void set_carrier(struct net_device *net)
@@ -1165,7 +1171,9 @@ static int pegasus_probe(struct usb_interface *intf,
 				| NETIF_MSG_PROBE | NETIF_MSG_LINK);
 
 	pegasus->features = usb_dev_id[dev_index].private;
-	get_interrupt_interval(pegasus);
+	res = get_interrupt_interval(pegasus);
+	if (res)
+		goto out2;
 	if (reset_mac(pegasus)) {
 		dev_err(&intf->dev, "can't reset MAC\n");
 		res = -EIO;
-- 
2.32.0

