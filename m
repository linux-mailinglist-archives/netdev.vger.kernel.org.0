Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4C5215C77
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 19:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgGFRAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 13:00:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40116 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729495AbgGFRAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 13:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594054823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sxp8KWaWgJw4WshhI3nQX8hZlCBBJb92GnlvBY7ow9Q=;
        b=HfbGgJIr/nI5Kq2pbDtWCWP/VyNH0YbUi578O1mp0n7yj8Ek8FPkGOZS0ChupvHxgo91QU
        ruDKy6V9QnXBfIFiMFfN2rw6W6j5jRkKxOfzmMNAHMicjh5OAJcPHRisa1Xa0on1zmgsxQ
        Gj5T0Pq6+gAqo0oVZJ1BgBuzx7zIUh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-5wWf46BnOtmQAa7b9mq7OQ-1; Mon, 06 Jul 2020 13:00:19 -0400
X-MC-Unique: 5wWf46BnOtmQAa7b9mq7OQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E717787950B;
        Mon,  6 Jul 2020 17:00:17 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 953235C290;
        Mon,  6 Jul 2020 17:00:17 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 95636300019CC;
        Mon,  6 Jul 2020 19:00:16 +0200 (CEST)
Subject: [PATCH bpf-next V2 2/2] selftests/bpf: test_progs avoid minus shell
 exit codes
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        vkabatov@redhat.com, jbenc@redhat.com, yhs@fb.com, kafai@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 06 Jul 2020 19:00:16 +0200
Message-ID: <159405481655.1091613.6475075949369245359.stgit@firesoul>
In-Reply-To: <159405478968.1091613.16934652228902650021.stgit@firesoul>
References: <159405478968.1091613.16934652228902650021.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a number of places in test_progs that use minus-1 as the argument
to exit(). This improper use as a process exit status is masked to be a
number between 0 and 255 as defined in man exit(3).

This patch use two different positive exit codes instead, to allow a shell
script to tell the two error cases apart.

Fixes: fd27b1835e70 ("selftests/bpf: Reset process and thread affinity after each test/sub-test")
Fixes: 811d7e375d08 ("bpf: selftests: Restore netns after each test")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/test_progs.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index e8f7cd5dbae4..50803b080593 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -12,7 +12,9 @@
 #include <string.h>
 #include <execinfo.h> /* backtrace */
 
-#define EXIT_NO_TEST 2
+#define EXIT_NO_TEST		2
+#define EXIT_ERR_NETNS		3
+#define EXIT_ERR_RESET_AFFINITY	4
 
 /* defined in test_progs.h */
 struct test_env env = {};
@@ -113,13 +115,13 @@ static void reset_affinity() {
 	if (err < 0) {
 		stdio_restore();
 		fprintf(stderr, "Failed to reset process affinity: %d!\n", err);
-		exit(-1);
+		exit(EXIT_ERR_RESET_AFFINITY);
 	}
 	err = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
 	if (err < 0) {
 		stdio_restore();
 		fprintf(stderr, "Failed to reset thread affinity: %d!\n", err);
-		exit(-1);
+		exit(EXIT_ERR_RESET_AFFINITY);
 	}
 }
 
@@ -128,7 +130,7 @@ static void save_netns(void)
 	env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
 	if (env.saved_netns_fd == -1) {
 		perror("open(/proc/self/ns/net)");
-		exit(-1);
+		exit(EXIT_ERR_NETNS);
 	}
 }
 
@@ -137,7 +139,7 @@ static void restore_netns(void)
 	if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
 		stdio_restore();
 		perror("setns(CLONE_NEWNS)");
-		exit(-1);
+		exit(EXIT_ERR_NETNS);
 	}
 }
 


