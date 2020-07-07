Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA6521671C
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgGGHMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:12:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54241 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728174AbgGGHMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 03:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594105949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJ2u3BtHw/gjxmZh9JTdaDzy0J/3L7Tf4wqVQ4apjc4=;
        b=AvG/+FW5mrMFnI40hHj51Toz+XZm50uhkR7eCt5Gl2Cu3UPu3izKLsyRoQuEVfzEQvWoZW
        4lHTEDiMFwUPg5CeYSkQSW1o+5ZI6yzyrNN+4/co08dTiqUqx469HA8kg+1EfZ7a2+T6z6
        Gr373xuarWyLUN07/CsFrRyD+/6VJXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-6j_oPuNoPge-FahGjpZIlQ-1; Tue, 07 Jul 2020 03:12:27 -0400
X-MC-Unique: 6j_oPuNoPge-FahGjpZIlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50186800C64;
        Tue,  7 Jul 2020 07:12:26 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 096EA77889;
        Tue,  7 Jul 2020 07:12:26 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 0E8EE3002D6DA;
        Tue,  7 Jul 2020 09:12:25 +0200 (CEST)
Subject: [PATCH bpf-next V3 2/2] selftests/bpf: test_progs avoid minus shell
 exit codes
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        vkabatov@redhat.com, jbenc@redhat.com, yhs@fb.com, kafai@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Jul 2020 09:12:25 +0200
Message-ID: <159410594499.1093222.11080787853132708654.stgit@firesoul>
In-Reply-To: <159410590190.1093222.8436994742373578091.stgit@firesoul>
References: <159410590190.1093222.8436994742373578091.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a number of places in test_progs that use minus-1 as the argument
to exit(). This is confusing as a process exit status is masked to be a
number between 0 and 255 as defined in man exit(3). Thus, users will see
status 255 instead of minus-1.

This patch use positive exit code 3 instead of minus-1. These cases are put
in the same group of infrastructure setup errors.

Fixes: fd27b1835e70 ("selftests/bpf: Reset process and thread affinity after each test/sub-test")
Fixes: 811d7e375d08 ("bpf: selftests: Restore netns after each test")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/test_progs.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 65d3f8686e29..b1e4dadacd9b 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -13,6 +13,7 @@
 #include <execinfo.h> /* backtrace */
 
 #define EXIT_NO_TEST		2
+#define EXIT_ERR_SETUP_INFRA	3
 
 /* defined in test_progs.h */
 struct test_env env = {};
@@ -113,13 +114,13 @@ static void reset_affinity() {
 	if (err < 0) {
 		stdio_restore();
 		fprintf(stderr, "Failed to reset process affinity: %d!\n", err);
-		exit(-1);
+		exit(EXIT_ERR_SETUP_INFRA);
 	}
 	err = pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
 	if (err < 0) {
 		stdio_restore();
 		fprintf(stderr, "Failed to reset thread affinity: %d!\n", err);
-		exit(-1);
+		exit(EXIT_ERR_SETUP_INFRA);
 	}
 }
 
@@ -128,7 +129,7 @@ static void save_netns(void)
 	env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
 	if (env.saved_netns_fd == -1) {
 		perror("open(/proc/self/ns/net)");
-		exit(-1);
+		exit(EXIT_ERR_SETUP_INFRA);
 	}
 }
 
@@ -137,7 +138,7 @@ static void restore_netns(void)
 	if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
 		stdio_restore();
 		perror("setns(CLONE_NEWNS)");
-		exit(-1);
+		exit(EXIT_ERR_SETUP_INFRA);
 	}
 }
 


