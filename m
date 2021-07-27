Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7061F3D75C8
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbhG0NSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236623AbhG0NSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:18 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35517C0613CF;
        Tue, 27 Jul 2021 06:18:18 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id r2so15242803wrl.1;
        Tue, 27 Jul 2021 06:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JZ/7s3Kptm0fO4rNApd05kyWr4dZU46G96Bk/AGq6Z4=;
        b=VhkpI8yOx3PuUZRCT+neRcJbn+g9XdLcCEzE4P6KKh3q6YzROSoWo6wpJkMdPSgeAz
         eSEBVK6z0Jfpcf5BvfsvLns2gnM9zqRB4CrlBXKfy45YVkgKHzTvimr/omMgeeRlHU0G
         RPhrX9E33POJz7QQUtMYEcV5aUuYPB8zSUFknWGi/mih5kHMORl6MC6uZnQwF5WlHWqV
         MrlB+B0vhAk7eOlafs/ALVYFjdkXio12/s2GA4KTr8QZ0Ia6rQn/1lCbu8jFjteu25Ja
         C1JfA+U6Nfkf0PRObjXmkq7mqSeaI3g2x1910zYTVhlgdp22PExdLeztDfy0QnLLitmp
         Fmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JZ/7s3Kptm0fO4rNApd05kyWr4dZU46G96Bk/AGq6Z4=;
        b=TBBu7s8aPuj77rMlYqRfZsVzTHa9wFeYo+iVIuzWpWwi5F5xYsOkt7+1gjEKlxbM7k
         2lnk4bDYBqzbN4M/AWaK3MGVvCkE/RXvhRjLdiS8acfWXXWWDFgYhIyBXIH+mECu3fXS
         Yjmgr3Qv/VYJ8hGgV9jKaKUEgUqUW7xFoxiDojQofc6HGZxU6tXsrhbUTiBZvOWsUecS
         BZveeHEbOcLrsNIYkI/MK/cpG1d5jV5LZG6j0/QugLEX52K/BtCD+X8N38tsql09fe7v
         t/bBKdbhH5nScIWLMqxUW4doYa6xbG6+/oHHh2/rfl2+aXlXR/BuO1GNEWELZiphs55i
         BVag==
X-Gm-Message-State: AOAM531WkjMEfTYq8QHIlGNZ+WTfN5Ikc1OPURDmKhQb9SpfTHLu94iE
        rjbPhe0Xb9uOaSh4yaE/1sY=
X-Google-Smtp-Source: ABdhPJx5Hjh+MFh0p0cquWwt7Oaomx1ePrMOdpl136WrfVdfJhiQGiDIe92vFFwsHt/FB6peVXbPTg==
X-Received: by 2002:adf:d0ce:: with SMTP id z14mr24319295wrh.67.1627391896839;
        Tue, 27 Jul 2021 06:18:16 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:16 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 06/17] selftests: xsk: simplify the retry code
Date:   Tue, 27 Jul 2021 15:17:42 +0200
Message-Id: <20210727131753.10924-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
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
index 2ae83b9a1ff4..dcde73db7b29 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -750,24 +750,19 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs)
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
 
@@ -1126,8 +1121,10 @@ int main(int argc, char **argv)
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

