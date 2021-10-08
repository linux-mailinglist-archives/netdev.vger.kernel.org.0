Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CE74264FF
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 08:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhJHHAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 03:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbhJHHAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 03:00:37 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC74C061766;
        Thu,  7 Oct 2021 23:58:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id v18so32797501edc.11;
        Thu, 07 Oct 2021 23:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=erlteIIJpoUZzEhxsq0PsclSRtPFNNij9prHhS0lAOA=;
        b=jwZb8VY+BGiLthud4f3shU80uwK5yfNZCHPK5U94zylbdJCD3vcdypX6Dh4LXl66QN
         vJWRZuUkcFFYGlmyMBAwesMsXeGkwGUM/hVrLGcpfPPFA902MJEFfLEmaN+mvd5GOUaO
         teLZqOQQ/u1V0viS0TAiBz6flE9ZJk3w1PdjXeWnqJ5GF0yUh67zbRG56abpXGwXUIfs
         I95iUtzCG/5yLalzewl2ZpHgcvJ8AUUJq1F7zMELq/w9n0Lvh/t5HFC8LTbtK6kgMSWw
         l5m9Un8wVr+RpOHltw8Si4DjccxpZN3//Tjipkacq3snkJY0L+C4U34lFpLJ8RPvT9Jn
         23gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=erlteIIJpoUZzEhxsq0PsclSRtPFNNij9prHhS0lAOA=;
        b=gYlO94adaj9Kv3gjUhvcN4jNWs5O4WVSyiFQCc9nC1YGsmmDWfUbUKbiccfDvHpU1W
         3weGXf6CZxlq+gU0sPanidAnOKJ7+pKXAfWYf7+fjK0f8hI7NNqnuWXs5GnfJeGZP3Zg
         EyHzsBk4WK3b5/G9keMfCBWqvwZ5U1j3NZKe/PO+ndKNgmQ68wGYJdqhrRkpL3OA/fLX
         JMOfDen5p6RF1GTqhoVV1KkyHoj2JVjgBQrlvEd4LyEeknSV+pOV4NNwEoudaSkVkuhR
         2a+TKEpVdbNJcRSclAOYrvjVwxZXSL1EX4wjHAPPgXUvfyw6TQX6NLvYR3UmNG95x2hK
         KrEQ==
X-Gm-Message-State: AOAM531cIkuIg9IrCW9mfGW5HBvs9TnF9X3rGEmojOaqnhcLfesja5IK
        fctKVSeVD76pn7skSvRtVDDdpNiCqWB8VPhs
X-Google-Smtp-Source: ABdhPJzPVOLmlqOhJc/56bd+uO5LmTQe1YgrClpg2kR1WYQFstYgQqqQ9+Cxpb8qNv/K1W9LYz5eqQ==
X-Received: by 2002:a05:6402:5112:: with SMTP id m18mr4797448edd.101.1633676321288;
        Thu, 07 Oct 2021 23:58:41 -0700 (PDT)
Received: from localhost.localdomain (185.239.71.98.16clouds.com. [185.239.71.98])
        by smtp.gmail.com with ESMTPSA id l16sm580867eje.67.2021.10.07.23.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 23:58:41 -0700 (PDT)
From:   Xiaolong Huang <butterflyhuangxx@gmail.com>
To:     isdn@linux-pingi.de, davem@davemloft.net, arnd@arndb.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>
Subject: [PATCH] isdn: cpai: check ctr->cnr to avoid array index out of bound
Date:   Fri,  8 Oct 2021 14:58:30 +0800
Message-Id: <20211008065830.305057-1-butterflyhuangxx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cmtp_add_connection() would add a cmtp session to a controller
and run a kernel thread to process cmtp.

	__module_get(THIS_MODULE);
	session->task = kthread_run(cmtp_session, session, "kcmtpd_ctr_%d",
								session->num);

During this process, the kernel thread would call detach_capi_ctr()
to detach a register controller. if the controller
was not attached yet, detach_capi_ctr() would
trigger an array-index-out-bounds bug.

[   46.866069][ T6479] UBSAN: array-index-out-of-bounds in
drivers/isdn/capi/kcapi.c:483:21
[   46.867196][ T6479] index -1 is out of range for type 'capi_ctr *[32]'
[   46.867982][ T6479] CPU: 1 PID: 6479 Comm: kcmtpd_ctr_0 Not tainted
5.15.0-rc2+ #8
[   46.869002][ T6479] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.14.0-2 04/01/2014
[   46.870107][ T6479] Call Trace:
[   46.870473][ T6479]  dump_stack_lvl+0x57/0x7d
[   46.870974][ T6479]  ubsan_epilogue+0x5/0x40
[   46.871458][ T6479]  __ubsan_handle_out_of_bounds.cold+0x43/0x48
[   46.872135][ T6479]  detach_capi_ctr+0x64/0xc0
[   46.872639][ T6479]  cmtp_session+0x5c8/0x5d0
[   46.873131][ T6479]  ? __init_waitqueue_head+0x60/0x60
[   46.873712][ T6479]  ? cmtp_add_msgpart+0x120/0x120
[   46.874256][ T6479]  kthread+0x147/0x170
[   46.874709][ T6479]  ? set_kthread_struct+0x40/0x40
[   46.875248][ T6479]  ret_from_fork+0x1f/0x30
[   46.875773][ T6479]

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
---
 drivers/isdn/capi/kcapi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index cb0afe897162..7313454e403a 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -480,6 +480,11 @@ int detach_capi_ctr(struct capi_ctr *ctr)
 
 	ctr_down(ctr, CAPI_CTR_DETACHED);
 
+	if (ctr->cnr < 1 || ctr->cnr - 1 >= CAPI_MAXCONTR) {
+		err = -EINVAL;
+		goto unlock_out;
+	}
+
 	if (capi_controller[ctr->cnr - 1] != ctr) {
 		err = -EINVAL;
 		goto unlock_out;
-- 
2.25.1

