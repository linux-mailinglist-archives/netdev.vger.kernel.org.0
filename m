Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CFB3EE9C5
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239573AbhHQJ3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbhHQJ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:35 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4864C0613C1;
        Tue, 17 Aug 2021 02:29:01 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id j12-20020a05600c1c0c00b002e6d80c902dso1675108wms.4;
        Tue, 17 Aug 2021 02:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p1ZV12Wr3LwBHVU+XKp6bzmBy9RlmTyfmIyQtKDzVq4=;
        b=qAG77GVVar4vVIqyZrx8xFMuTHcwy6YuLc1fB+U6XwXVudiWqYoa1kfE/KFqKUNojs
         ZQKtPsbByaj5xuJt3HxyqFboyocv7vgeAKrVFVWEfAVzm02IyF/Sj4O5Tr3hYWwhSoOw
         XqzvXgjK+pMTxDYsuuF7c6BHwZO9U2FqLRCmRM+BejH24aHGwmt0XmI8hqaUXvJbpLZP
         FqTzCET7rt9gFI99IJlLeV2B5nJyNNeH7feJgUOy8vacOv8j9nrtpkXawoL6DgL+WL6r
         DWHYYtPnmAc0duy2iE98mtUO6HRIVr2YxEqRNEdLi+1Exfxsg9ARRy6yiBXJI79SABUx
         Jz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p1ZV12Wr3LwBHVU+XKp6bzmBy9RlmTyfmIyQtKDzVq4=;
        b=TZATD2aobDUbipHmjzK/CNWT60q9JRrwIfEvo4otsO77HcnGWoEIt86xZGlGwcJiAT
         MWtTHbm539FxHUHJZel5CnoEZhkGcw4srtgjs3zTfPjTW/xFoRGcSn2BWDNx2xP0NTPU
         dgb1CtbgpwH1KE7kh5yZyO7qHNP3Wgcj8iwcrr/RrFj8+VbaCOJirRHuk7y19z8Fojoi
         LAreIeg+WPtlPKHOCTo75X+iuOE5ABVd0oOIZ9farqEzxZhvvr7krpKlPil5biW0ueqO
         agA4uvY1Nv8wfcxTmo8rrN/q4aSlI20mT+jKrnUSkF5s8S5aJbNtwnM858x+X31t1iz8
         CZIg==
X-Gm-Message-State: AOAM532uTxKPRoAIOZXTgHKDVrKXVpMSj+aQlwLl5TiGBs4xVEJPlw6+
        WpQJKfKFitHbBxDNr0pdMHo=
X-Google-Smtp-Source: ABdhPJxhNCBrpcnjtPFsw2jpdMnMR2bbrVbOyKXUK99pTolblnTWUojXYy6PmAIuEfYmYL3JQ6e4NA==
X-Received: by 2002:a1c:3c8b:: with SMTP id j133mr2400148wma.9.1629192540444;
        Tue, 17 Aug 2021 02:29:00 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.28.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:00 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 05/16] selftests: xsk: simplify the retry code
Date:   Tue, 17 Aug 2021 11:27:18 +0200
Message-Id: <20210817092729.433-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Simplify the retry code and make it more efficient by waiting first,
instead of trying immediately which always fails due to the
asynchronous nature of xsk socket close. Also decrease the wait time
to significantly lower the run-time of the test suite.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 23 ++++++++++-------------
 tools/testing/selftests/bpf/xdpxceiver.h |  2 +-
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index f221bc5dae17..b7d193a96083 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -745,24 +745,19 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 	if (bufs == MAP_FAILED)
 		exit_with_error(errno);
 
-	xsk_configure_umem(ifobject, bufs, 0);
-	ifobject->umem = ifobject->umem_arr[0];
-	ret = xsk_configure_socket(ifobject, 0);
-
-	/* Retry Create Socket if it fails as xsk_socket__create()
-	 * is asynchronous
-	 */
-	while (ret && ctr < SOCK_RECONF_CTR) {
+	while (ctr++ < SOCK_RECONF_CTR) {
 		xsk_configure_umem(ifobject, bufs, 0);
 		ifobject->umem = ifobject->umem_arr[0];
 		ret = xsk_configure_socket(ifobject, 0);
+		if (!ret)
+			break;
+
+		/* Retry Create Socket if it fails as xsk_socket__create() is asynchronous */
 		usleep(USLEEP_MAX);
-		ctr++;
+		if (ctr >= SOCK_RECONF_CTR)
+			exit_with_error(-ret);
 	}
 
-	if (ctr >= SOCK_RECONF_CTR)
-		exit_with_error(ret);
-
 	ifobject->umem = ifobject->umem_arr[0];
 	ifobject->xsk = ifobject->xsk_arr[0];
 
@@ -1125,8 +1120,10 @@ int main(int argc, char **argv)
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
 	for (i = 0; i < TEST_MODE_MAX; i++) {
-		for (j = 0; j < TEST_TYPE_MAX; j++)
+		for (j = 0; j < TEST_TYPE_MAX; j++) {
 			run_pkt_test(i, j);
+			usleep(USLEEP_MAX);
+		}
 	}
 
 cleanup:
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 02b7d0d6f45d..1c94230c351a 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -35,7 +35,7 @@
 #define UDP_PKT_SIZE (IP_PKT_SIZE - sizeof(struct iphdr))
 #define UDP_PKT_DATA_SIZE (UDP_PKT_SIZE - sizeof(struct udphdr))
 #define EOT (-1)
-#define USLEEP_MAX 200000
+#define USLEEP_MAX 10000
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
 #define POLL_TMOUT 1000
-- 
2.29.0

