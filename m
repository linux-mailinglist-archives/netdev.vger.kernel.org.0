Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5633104F4
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhBEG2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:28:42 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:60124 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229492AbhBEG2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 01:28:39 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UNwRPr4_1612506441;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNwRPr4_1612506441)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Feb 2021 14:27:46 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, shuah@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] selftests/bpf: Simplify the calculation of variables
Date:   Fri,  5 Feb 2021 14:27:19 +0800
Message-Id: <1612506439-56810-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./tools/testing/selftests/bpf/xdpxceiver.c:954:28-30: WARNING !A || A &&
B is equivalent to !A || B.

./tools/testing/selftests/bpf/xdpxceiver.c:932:28-30: WARNING !A || A &&
B is equivalent to !A || B.

./tools/testing/selftests/bpf/xdpxceiver.c:909:28-30: WARNING !A || A &&
B is equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 1e722ee..98ad4a2 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -906,7 +906,7 @@ static void *worker_testapp_validate(void *arg)
 			ksft_print_msg("Destroying socket\n");
 	}
 
-	if (!opt_bidi || (opt_bidi && bidi_pass)) {
+	if (!opt_bidi || bidi_pass) {
 		xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
 		(void)xsk_umem__delete(((struct ifobject *)arg)->umem->umem);
 	}
@@ -929,7 +929,7 @@ static void testapp_validate(void)
 	pthread_mutex_lock(&sync_mutex);
 
 	/*Spawn RX thread */
-	if (!opt_bidi || (opt_bidi && !bidi_pass)) {
+	if (!opt_bidi || !bidi_pass) {
 		if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[1]))
 			exit_with_error(errno);
 	} else if (opt_bidi && bidi_pass) {
@@ -951,7 +951,7 @@ static void testapp_validate(void)
 	pthread_mutex_unlock(&sync_mutex);
 
 	/*Spawn TX thread */
-	if (!opt_bidi || (opt_bidi && !bidi_pass)) {
+	if (!opt_bidi || !bidi_pass) {
 		if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[0]))
 			exit_with_error(errno);
 	} else if (opt_bidi && bidi_pass) {
-- 
1.8.3.1

