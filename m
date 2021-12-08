Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC5A46DB13
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238893AbhLHScZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238889AbhLHScW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:32:22 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A284EC061A72
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 10:28:50 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u11so2098150plf.3
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 10:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAHYsn80W/cLHnf6ht51GzLoiJp0ynFyHN6zfSS2Mg4=;
        b=XeYENC/ehYAImGZe9+myaSRhkNfR5/LdUowH0QRQqKPyZ4ON15sfaRbnWo5OzZIHP2
         iNsFftUGHV6REbBEv2aWABqJ6HptiZMyvi1188f12mslhlx4cPs/qqBauRtFCeOLyn6q
         4aUWyp5qQgAELffNcQEbgXsI0jXYa2Eh3l5nBQc/CU2NgoAJox3zn2MSd0tg2ZCK9BL/
         zHBk640JfuIP9SRPB5Izr5U2G7k6sKjCdLGpqjZdhSZQ7ruNNQLAcpVrPKW06kRQunSC
         lvtB44PTRvZnfkpfFES0zEdQUgBp5xmmEVZpNwg+qRpYvFCX+ciIS/y8dqaDlUiw4qgP
         QwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RAHYsn80W/cLHnf6ht51GzLoiJp0ynFyHN6zfSS2Mg4=;
        b=53MD7mW4orU9s6R6WDT2f9ZgQOBG3cytSkrcdyFWE4lF5vLMeuWxbNDjSEWVWD+t9d
         ExvL7YGBvqAbby6peYwKjnf+s3DADUXcQcyVlyl+HF7b0XBOF+RJpID+Hq5lYcRhPDOO
         UrvWVev6rOE2i5GiF4jkg/pKxN3IQvt7EwOl4ZhbVnmsQmhqXV832Dq6opI7UgOdfquD
         liVzRYDhryENGOaf7NjfJ64DOEKDVWTAVwp4EhOAa582u3xkQbX1BRp+U3OcSViKxk4y
         oRThph7cQusbeOyB6AP6nSalJXdm4sEP5m7rvFjNbj0bfllMAkYmNTRLSCjf2gdFm3tB
         LnBw==
X-Gm-Message-State: AOAM533ue5OiUuitEjl4gsEjPDU2SldlHqDAJZdRFzi6kxqsntsxlOX1
        eLdz/zEjsKxfspnm7YFhle55lxQVlrLbzA==
X-Google-Smtp-Source: ABdhPJwe4TPTy0GHNA6JeJJcGjVeT51U8qxGCLZLydC+k2fTYOqDNPP1iZn5EFgq7tG8Ucv1WR5lvw==
X-Received: by 2002:a17:90a:db89:: with SMTP id h9mr9223384pjv.71.1638988130016;
        Wed, 08 Dec 2021 10:28:50 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id l1sm3178185pgl.61.2021.12.08.10.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 10:28:49 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org,
        syzbot+f9f76f4a0766420b4a02@syzkaller.appspotmail.com
Subject: [PATCH] nfc: fix segfault in nfc_genl_dump_devices_done
Date:   Wed,  8 Dec 2021 10:27:42 -0800
Message-Id: <20211208182742.340542-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kmalloc in nfc_genl_dump_devices() fails then
nfc_genl_dump_devices_done() segfaults as below

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 25 Comm: kworker/0:1 Not tainted 5.16.0-rc4-01180-g2a987e65025e-dirty #5
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-6.fc35 04/01/2014
Workqueue: events netlink_sock_destruct_work
RIP: 0010:klist_iter_exit+0x26/0x80
Call Trace:
<TASK>
class_dev_iter_exit+0x15/0x20
nfc_genl_dump_devices_done+0x3b/0x50
genl_lock_done+0x84/0xd0
netlink_sock_destruct+0x8f/0x270
__sk_destruct+0x64/0x3b0
sk_destruct+0xa8/0xd0
__sk_free+0x2e8/0x3d0
sk_free+0x51/0x90
netlink_sock_destruct_work+0x1c/0x20
process_one_work+0x411/0x710
worker_thread+0x6fd/0xa80

Link: https://syzkaller.appspot.com/bug?id=fc0fa5a53db9edd261d56e74325419faf18bd0df
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Reported-by: syzbot+f9f76f4a0766420b4a02@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 net/nfc/netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 334f63c9529e..0b4fae183a4b 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -636,8 +636,10 @@ static int nfc_genl_dump_devices_done(struct netlink_callback *cb)
 {
 	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
 
-	nfc_device_iter_exit(iter);
-	kfree(iter);
+	if (iter) {
+		nfc_device_iter_exit(iter);
+		kfree(iter);
+	}
 
 	return 0;
 }
-- 
2.33.1

