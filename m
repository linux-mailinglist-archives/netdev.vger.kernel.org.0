Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9043DC060
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhG3VoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhG3VoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:44:23 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2044BC06175F;
        Fri, 30 Jul 2021 14:44:17 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id h9so14318427ljq.8;
        Fri, 30 Jul 2021 14:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iUWsYGbYRvDKidtDFAD37LhSTu0mAAw/UZoF5BX5je4=;
        b=OBxPLbMIP9Zg1tCsP+gAveHb7Z/9qmetZxjEySQkmkZVrdOtfdVFg9vR/2s0vrE7DJ
         G4Y0G7XB7bsR6NcAgROrFQwttHTY69EXUww9skhLiR5Ku/WZCTgtjHknOKmDg4IiahMC
         i+tawWXEKt0K+gQw0otdQKclH++pyPaMd3vxryxAwIirSEPOt/Y1AcwOTvn3Z+5vkpga
         aj6I0mprZrERwbxMRtiO9f+kz5/A+cvg6gTqXW3Q4NLZxQ9WVs6HXLd4gpXceCpRnIPJ
         sZXx8GtiqDzZkQM86doOwKekydU+wTRpSBdhOQc99y5m83gJASGOX0mjzRnjRYSSgd8B
         F7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iUWsYGbYRvDKidtDFAD37LhSTu0mAAw/UZoF5BX5je4=;
        b=a90sbxe2qyUAU3g5EwalWSp3xt38EyOH9ei7WNWL9yMdz8RqXM4C/+fako/19BKdXT
         NJgocqhgBzbwF9/90KTmGjXPAqhYdoJbewJXprW0u15JAfjshmalFFDOwlOxgOaHrhDe
         ZYVLGVWnCezaBGg0+QxZc8A0Y2ZaMfIT3QtLzvgrrgiYBuMLLJUeJDoowZX20eY0Zgzl
         Zkx+H61fEmeVrh8Xo8JQLF3vr0CFylv+vLpIa83ivCRNGW9TCFkdx/h+hkbvTwGg4DPu
         J02UZKm3m61wLyfO52EyjTtl7JNdTvedIbFKG1pHoSMONy6IdPx/JHZEFD7sPkU0095e
         f2Ww==
X-Gm-Message-State: AOAM530x3MIORUg3oQoUaNdsg64/qIvd470h0C/vVbOXNtq9ABDJd2j9
        IcE+jRHMesW1Cj2McRdCkfc=
X-Google-Smtp-Source: ABdhPJx/siIPONhywOb1T7C7lk6QtoW4/5xKjW34rQU/7G6Jr2RCrRQRgPnwO1B6wzgDxNa7PZHQUQ==
X-Received: by 2002:a05:651c:b06:: with SMTP id b6mr3027530ljr.171.1627681455465;
        Fri, 30 Jul 2021 14:44:15 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id d18sm175512ljc.64.2021.07.30.14.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 14:44:15 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     petkan@nucleusys.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Subject: [PATCH] net: pegasus: fix uninit-value in get_interrupt_interval
Date:   Sat, 31 Jul 2021 00:44:11 +0300
Message-Id: <20210730214411.1973-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
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
 drivers/net/usb/pegasus.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 9a907182569c..bc2dbf86496b 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -735,12 +735,16 @@ static inline void disable_net_traffic(pegasus_t *pegasus)
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
@@ -755,6 +759,8 @@ static inline void get_interrupt_interval(pegasus_t *pegasus)
 		}
 	}
 	pegasus->intr_interval = interval;
+
+	return 0;
 }
 
 static void set_carrier(struct net_device *net)
@@ -1149,7 +1155,9 @@ static int pegasus_probe(struct usb_interface *intf,
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

