Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1D3F71E1
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239750AbhHYJiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239718AbhHYJip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:45 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CC9C061757;
        Wed, 25 Aug 2021 02:38:00 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d22-20020a1c1d16000000b002e7777970f0so3793337wmd.3;
        Wed, 25 Aug 2021 02:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p1ZV12Wr3LwBHVU+XKp6bzmBy9RlmTyfmIyQtKDzVq4=;
        b=u+FyZ5VJdKGWnfMbjNKgHNRoYHqOzR+5+0mXiKT3/Y+TmSmlY2t59nZZ9ixIux1Bo5
         ow/8Tt+h2NiTtFz2ybkB0waZR32zXbn5KsIZMt53LCVD1UVFd4/t8QinOxatKxcUAVVz
         H4vVXLeZILrqaDL9t+PggNTjTj7gzlKhsZlyq+fdvCrClEyWM8XM+hbt6hMc4SLY8B7Y
         uTCexHHk/jJQadWDnIB0b7TGCLLC33CRldE+pUdBwFrq09AyXz4IYN+G8yAHoPpwaJAh
         drE0tsFiA6tnQ54MYbZZ9ONPCfxNew15t/i3pJ+f06qRPOtl2Z9NQQzCOhjWW4+V2aeR
         m/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p1ZV12Wr3LwBHVU+XKp6bzmBy9RlmTyfmIyQtKDzVq4=;
        b=Qs4Oy5zxDP6P4rEsba+zJkWGMgoAbjUxi2Ji9P7xpR/V1l077YTMCicVNbeFEokXeu
         knMZZnj6t4I6pXfkwMdLI0Yu7hzKoTWYZFQ1p9qt3T5Pk0DHhm+s6MkbvrxVH5RQY6zn
         +RlfIrgIhemobtosJbMaUYsM1EhvL/O/cvdNuazSk8kKE+Ttq5fYxnGreT/ANQtClbJs
         MEeojeQ8cueH34/cgHxhGsS/R+9uh0y5mUO1ROJ/sDiwvNa5+fxbJbPE2JyAiJCoDVWq
         HTFcR2AEnZr+VOBNLgfiUzA1+4Kd51115uE2OZ+h8LtRkjAZr1bh7QnKyHspZE8HOg+m
         o2Pw==
X-Gm-Message-State: AOAM530A78E3xNWrGlj5BXgBlG3UQA+wxWYzJtnYHuslVlcWaWNlaKpB
        QqgOv9GhDq+J/2Eg67YH5vk=
X-Google-Smtp-Source: ABdhPJyVIZ7d8sDYLKoOI5DhDOrYdy+RSMsarjpftLHBziPxOWfMDlpR94CZi+vCezolMn4hkcLbjw==
X-Received: by 2002:a7b:c401:: with SMTP id k1mr1465911wmi.141.1629884279012;
        Wed, 25 Aug 2021 02:37:59 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.37.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:37:58 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 05/16] selftests: xsk: simplify the retry code
Date:   Wed, 25 Aug 2021 11:37:11 +0200
Message-Id: <20210825093722.10219-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
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

