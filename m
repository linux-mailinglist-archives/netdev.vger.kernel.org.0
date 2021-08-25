Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB133F71EE
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbhHYJjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239807AbhHYJi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:56 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1E6C0617A8;
        Wed, 25 Aug 2021 02:38:10 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u9so501079wrg.8;
        Wed, 25 Aug 2021 02:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2fnNDxyYpKyxamB+m0HKg46XLLE6g1mX0MO5afICgk=;
        b=dWoprSC1KJMwtf+M4WH8Bzr8pR0D1tvBccge1I9zj9f0DdbbIZtVgt7hTumKUfcCzD
         bXMnMn27tL8l/yhxSxJLhk5QNJW+odKX5uZYxpiLcejrLidDY8AN4vUvg7FELbHDfNBD
         065uTeWsE+DaBGaBSdk7QEVLQHycbvozgN7RKCVETTyeK/aUHGzu8XRedkL0/T367DIv
         qHenmsG3qMbKxIksOlO7hXLOM8F7R+T6unzFYsfDZwSJRWRZ1W1Xt0KagUd77wv5THmZ
         CJtETPolcXk85K7yy1ZlEpvGKwzGOWOP5grbls6iDxJrv3lexHVXWU1SQH60k4JMxZyd
         rszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2fnNDxyYpKyxamB+m0HKg46XLLE6g1mX0MO5afICgk=;
        b=qwpZ3B7HoC/AL2ooSqmcpYD3+547jYqpewtaEdNebfvsLEuUjEFwzZVrOd+k98wKFg
         3u4ZAGnAhJHQKKKVQIYOyVRj5+QZPRn1Yl151e2ghSf92u0We/PnaRow3mKEPjPRsabY
         gOjlCNwv2qD10n3qnKQfjXExQlrEPE9nL8cOFSb2YsF520wC7Eb4zDZOd9I08FwqJy+/
         2e+3WAQGUC3OMZduZb7EujaGjfuTubehohu88w8TfvIfc5xX+sj5iucHJEiV21WVRYf9
         15TgHDYjLUj/UP8Ii8pUK+1Qt+JutEnQMDwMhVeCJcdMyee38m6Xyf80ypY0wAkzwe4m
         issQ==
X-Gm-Message-State: AOAM532PygEgGBWUWPKq2XRQpN1tJ+wSZeOl3G6POJ/C44rUGCU31ATV
        k7/xup76RZyY41OXF3VSwsl1NlFjRZPcdIrYfoDDXQ==
X-Google-Smtp-Source: ABdhPJw7/IdZRVMMQ5dF6rMH6vZzzxgULGhPUyOIXOaHZkH1uDs784GdXr6N8QqTCpoP8lW4K5WtKQ==
X-Received: by 2002:adf:eb4c:: with SMTP id u12mr25028854wrn.111.1629884289456;
        Wed, 25 Aug 2021 02:38:09 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.38.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:38:09 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 12/16] selftests: xsk: simplify cleanup of ifobjects
Date:   Wed, 25 Aug 2021 11:37:18 +0200
Message-Id: <20210825093722.10219-13-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Simpify the cleanup of ifobjects right before the program exits by
introducing functions for creating and destroying these objects.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 72 +++++++++++++-----------
 tools/testing/selftests/bpf/xdpxceiver.h |  1 -
 2 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index bc7d6bbbb867..5e586a696742 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1039,62 +1039,70 @@ static void run_pkt_test(int mode, int type)
 	}
 }
 
+static struct ifobject *ifobject_create(void)
+{
+	struct ifobject *ifobj;
+
+	ifobj = calloc(1, sizeof(struct ifobject));
+	if (!ifobj)
+		return NULL;
+
+	ifobj->xsk_arr = calloc(2, sizeof(struct xsk_socket_info *));
+	if (!ifobj->xsk_arr)
+		goto out_xsk_arr;
+
+	ifobj->umem_arr = calloc(2, sizeof(struct xsk_umem_info *));
+	if (!ifobj->umem_arr)
+		goto out_umem_arr;
+
+	return ifobj;
+
+out_umem_arr:
+	free(ifobj->xsk_arr);
+out_xsk_arr:
+	free(ifobj);
+	return NULL;
+}
+
+static void ifobject_delete(struct ifobject *ifobj)
+{
+	free(ifobj->umem_arr);
+	free(ifobj->xsk_arr);
+	free(ifobj);
+}
+
 int main(int argc, char **argv)
 {
 	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
-	bool failure = false;
 	int i, j;
 
 	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
 		exit_with_error(errno);
 
-	for (int i = 0; i < MAX_INTERFACES; i++) {
-		ifdict[i] = malloc(sizeof(struct ifobject));
+	for (i = 0; i < MAX_INTERFACES; i++) {
+		ifdict[i] = ifobject_create();
 		if (!ifdict[i])
-			exit_with_error(errno);
-
-		ifdict[i]->ifdict_index = i;
-		ifdict[i]->xsk_arr = calloc(2, sizeof(struct xsk_socket_info *));
-		if (!ifdict[i]->xsk_arr) {
-			failure = true;
-			goto cleanup;
-		}
-		ifdict[i]->umem_arr = calloc(2, sizeof(struct xsk_umem_info *));
-		if (!ifdict[i]->umem_arr) {
-			failure = true;
-			goto cleanup;
-		}
+			exit_with_error(ENOMEM);
 	}
 
 	setlocale(LC_ALL, "");
 
 	parse_command_line(argc, argv);
 
-	init_iface(ifdict[0], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2, tx);
-	init_iface(ifdict[1], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1, rx);
+	init_iface(ifdict[tx], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2, tx);
+	init_iface(ifdict[rx], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1, rx);
 
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
-	for (i = 0; i < TEST_MODE_MAX; i++) {
+	for (i = 0; i < TEST_MODE_MAX; i++)
 		for (j = 0; j < TEST_TYPE_MAX; j++) {
 			run_pkt_test(i, j);
 			usleep(USLEEP_MAX);
 		}
-	}
 
-cleanup:
-	for (int i = 0; i < MAX_INTERFACES; i++) {
-		if (ifdict[i]->ns_fd != -1)
-			close(ifdict[i]->ns_fd);
-		free(ifdict[i]->xsk_arr);
-		free(ifdict[i]->umem_arr);
-		free(ifdict[i]);
-	}
-
-	if (failure)
-		exit_with_error(errno);
+	for (i = 0; i < MAX_INTERFACES; i++)
+		ifobject_delete(ifdict[i]);
 
 	ksft_exit_pass();
-
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 1c5457e9f1d6..316c3565a99e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -122,7 +122,6 @@ struct ifobject {
 	void *(*func_ptr)(void *arg);
 	struct flow_vector fv;
 	int ns_fd;
-	int ifdict_index;
 	u32 dst_ip;
 	u32 src_ip;
 	u16 src_port;
-- 
2.29.0

