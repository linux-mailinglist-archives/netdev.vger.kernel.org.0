Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425F362E188
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbiKQQXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240577AbiKQQWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:22:41 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977E87FC33
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:21:06 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-348608c1cd3so23276837b3.10
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=46Vuug64PODtLBjwL/B/YAALoGkMw5/FLSuRvqDbboM=;
        b=TtzwJ5mw4lglyKWrYLIYhgXG8j7w/2Mo8x+db6cNEFZuhu4qAcqujE/l7zP4VjtDjw
         TSJEi/tWu+DkL+f+T5BLa21qiR7Lr3MqTR3vTortlyyAhzdGNkqTUGw/1r+zV624NPcj
         hifIpTlJ23pblofVNKuIgIvday7mJwIc3uv68imwRGkGxuxWROKlOZz0ymeUwBm71Fe9
         /ZR5lddgTpENijpYJndlfxU8fkJP0OguzQA6YJ3rhQF8G0VA3MZ0QHHWDLUSb3rKLEKG
         95tEQf+7X708dxIWb6xCPfG1ECcNC9cXonqhLhtVqYaPRVmqwqGtOYRr0rWM/A/9bTrW
         qMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=46Vuug64PODtLBjwL/B/YAALoGkMw5/FLSuRvqDbboM=;
        b=TLKy0SuOeHl1ILtihG+EM1Ybx6qs1JN1oAm6St2pN+c+wqCqNtI/peALnnjVtdn2E5
         8EIOZzX1JEs3mJSLH5Kv1JpKSdtyGjr4HoS+FM7aFTE/oneiiR82MF4AcgtmqMRTKk+o
         aOTPCH8cRx5TCMtCmRBPnrY8AV+QjvyVE34q2Xa6pLcgOStmljIYo/G+4cuuUGzVB2u8
         tm1TZUMFd+ePA1t72f80oYskW9/zjP6jrL/YjWSSZR+AI4Tac0eKP6bj1wAJ+6MRVYHO
         +zWdjkUDe+cCmKgS+IjW1U6PA3K9ejEZuQCy9GAr2p2wuixPLtF6Ls5aa9VsaeaTSUz/
         5uJQ==
X-Gm-Message-State: ANoB5plC+TwJrs8slXjKCXef0Q3uS6tXWIB53HwGsn9wC6+Nxtm44PgZ
        ODdpGQiQ4Ts1I9U4dK2sbdkQu4Wp1fdQ
X-Google-Smtp-Source: AA0mqf43J10aYjN42GNtEeWG56YFKIkfLQiqASReL/cm4M/xCjqqmIgviWL98ab7TC7FX//GQ49zDeP5sR7P
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:9c:201:2498:56aa:d95d:5c2c])
 (user=dvyukov job=sendgmr) by 2002:a81:4644:0:b0:344:ff29:4526 with SMTP id
 t65-20020a814644000000b00344ff294526mr2666924ywa.63.1668702065098; Thu, 17
 Nov 2022 08:21:05 -0800 (PST)
Date:   Thu, 17 Nov 2022 17:21:01 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117162101.1467069-1-dvyukov@google.com>
Subject: [PATCH net-next v2] NFC: nci: Extend virtual NCI deinit test
From:   Dmitry Vyukov <dvyukov@google.com>
To:     pabeni@redhat.com, bongsu.jeon@samsung.com,
        krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     syzkaller@googlegroups.com, Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the test to check the scenario when NCI core tries to send data
to already closed device to ensure that nothing bad happens.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org

---

Changes in v2:
 - use C multi-line comment style instead of C++ style
---
 tools/testing/selftests/nci/nci_dev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 162c41e9bcae8..1562aa7d60b0f 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -888,6 +888,17 @@ TEST_F(NCI, deinit)
 			   &msg);
 	ASSERT_EQ(rc, 0);
 	EXPECT_EQ(get_dev_enable_state(&msg), 0);
+
+	/* Test that operations that normally send packets to the driver
+	 * don't cause issues when the device is already closed.
+	 * Note: the send of NFC_CMD_DEV_UP itself still succeeds it's just
+	 * that the device won't actually be up.
+	 */
+	close(self->virtual_nci_fd);
+	self->virtual_nci_fd = -1;
+	rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
+			       NFC_CMD_DEV_UP, self->dev_idex);
+	EXPECT_EQ(rc, 0);
 }
 
 TEST_HARNESS_MAIN

base-commit: f12ed9c04804eec4f1819097a0fd0b4800adac2f
prerequisite-patch-id: 214c5357c652cee65ee803d0f45f4b15cfcc9861
-- 
2.38.1.431.g37b22c650d-goog

