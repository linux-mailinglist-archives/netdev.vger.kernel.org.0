Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CDF6657CC
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbjAKJjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238256AbjAKJhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:35 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06B98FE1;
        Wed, 11 Jan 2023 01:36:23 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id w1so14416861wrt.8;
        Wed, 11 Jan 2023 01:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ceU3BaOqyEvsRo0mtkcK52G8cv5p44x/vPfM9JGc0sQ=;
        b=RP8Z9UceLo3KVhzFfaAbUZvHL5Ll7eYm6MFRhK3erGL11VvEl5JESXg9Wy4ZztCLhK
         JNM9ihxDaEp3sOGten5vOr684kFsFHQsTeaKP5r5GSpPWxAE8e7dlYuqXtOo39yx6yv4
         REht9E2LYok2Q4SzggjMgPTsQ+Nf7gOe7xrW9yqvzWzuGI13rpvPgpZD2hWQJLtEtJI4
         zYiQA8izmJ2TEj1H4HXdEcMo6y4vxe8hY6halSM2ZrfnB6VP0HgIRwmdADgh9/wtYga5
         RNpQvnmbXUTjXicqxtiqLhIA1gQgUtB2VCEmx0pPrq4rLfz6X43z81h8xUldMdUm/Epg
         rgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ceU3BaOqyEvsRo0mtkcK52G8cv5p44x/vPfM9JGc0sQ=;
        b=Tq/4W3kOEW8Ek0oyfeumyCozF8MvosW2O3tUGcZk0Fedj2TjNzhZPNY/3i2YGGxDC/
         otkSqC0lVW4+yZUOsMoyIu4CPfMaWdsDHKsgpDzppAB/IFR5Z6PVyyDq2OXtRk1p3YH2
         eiNfku+Dl2Elx/gcGAXCSWjP6RnkHm42+f2+7qZyO28gfZFGDzeB18bjfkg1y4LiiiMr
         oqQlNP5wGHAFUrGiWIqVKVIrMKaDbH736L6+di7mZVyFJ7oGR1+lwFCkvpLGbC1+265r
         qKP1bLP8TvYNWmIgnqoV1uUH81hEEnY9U6VwaZbXCXcPdAmQlaAiilzqtwyz4VNAxKKr
         wvxg==
X-Gm-Message-State: AFqh2kpPEtAS975qVM4qadFbUJgoq6fDQZeYBgjwtDwzqOEjIzc7/Kj9
        jU4RF2B1QaHjRrgqE0iI/lc5mAQsllIWD7/v
X-Google-Smtp-Source: AMrXdXs4Uk9DLk4PJCNEajvrLHWZfJR2Z6vGwORMXT24icTWC0qCEnItjQPAHTi5eaFYVAClPR8y7g==
X-Received: by 2002:a5d:620e:0:b0:242:7307:ae04 with SMTP id y14-20020a5d620e000000b002427307ae04mr40200094wru.57.1673429783351;
        Wed, 11 Jan 2023 01:36:23 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:22 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 13/15] selftests/xsk: merge dual and single thread dispatchers
Date:   Wed, 11 Jan 2023 10:35:24 +0100
Message-Id: <20230111093526.11682-14-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make the thread dispatching code common by unifying the dual and
single thread dispatcher code. This so we do not have to add code in
two places in upcoming commits.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 120 ++++++++++-------------
 1 file changed, 54 insertions(+), 66 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index a33f11b4c598..11e4f29d40f7 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1356,83 +1356,59 @@ static void handler(int signum)
 	pthread_exit(NULL);
 }
 
-static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
-						  enum test_type type)
+static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj1,
+				      struct ifobject *ifobj2)
 {
-	bool old_shared_umem = ifobj->shared_umem;
-	pthread_t t0;
+	pthread_t t0, t1;
 
-	if (pthread_barrier_init(&barr, NULL, 2))
-		exit_with_error(errno);
+	if (ifobj2)
+		if (pthread_barrier_init(&barr, NULL, 2))
+			exit_with_error(errno);
 
 	test->current_step++;
-	if (type == TEST_TYPE_POLL_RXQ_TMOUT)
-		pkt_stream_reset(ifobj->pkt_stream);
+	pkt_stream_reset(ifobj1->pkt_stream);
 	pkts_in_flight = 0;
 
-	test->ifobj_rx->shared_umem = false;
-	test->ifobj_tx->shared_umem = false;
-
 	signal(SIGUSR1, handler);
-	/* Spawn thread */
-	pthread_create(&t0, NULL, ifobj->func_ptr, test);
+	/*Spawn RX thread */
+	pthread_create(&t0, NULL, ifobj1->func_ptr, test);
 
-	if (type != TEST_TYPE_POLL_TXQ_TMOUT)
+	if (ifobj2) {
 		pthread_barrier_wait(&barr);
+		if (pthread_barrier_destroy(&barr))
+			exit_with_error(errno);
 
-	if (pthread_barrier_destroy(&barr))
-		exit_with_error(errno);
+		/*Spawn TX thread */
+		pthread_create(&t1, NULL, ifobj2->func_ptr, test);
 
-	pthread_kill(t0, SIGUSR1);
-	pthread_join(t0, NULL);
+		pthread_join(t1, NULL);
+	}
+
+	if (!ifobj2)
+		pthread_kill(t0, SIGUSR1);
+	else
+		pthread_join(t0, NULL);
 
 	if (test->total_steps == test->current_step || test->fail) {
-		xsk_socket__delete(ifobj->xsk->xsk);
-		xsk_clear_xskmap(ifobj->xskmap);
-		testapp_clean_xsk_umem(ifobj);
+		if (ifobj2)
+			xsk_socket__delete(ifobj2->xsk->xsk);
+		xsk_socket__delete(ifobj1->xsk->xsk);
+		testapp_clean_xsk_umem(ifobj1);
+		if (ifobj2 && !ifobj2->shared_umem)
+			testapp_clean_xsk_umem(ifobj2);
 	}
 
-	test->ifobj_rx->shared_umem = old_shared_umem;
-	test->ifobj_tx->shared_umem = old_shared_umem;
-
 	return !!test->fail;
 }
 
 static int testapp_validate_traffic(struct test_spec *test)
 {
-	struct ifobject *ifobj_tx = test->ifobj_tx;
-	struct ifobject *ifobj_rx = test->ifobj_rx;
-	pthread_t t0, t1;
-
-	if (pthread_barrier_init(&barr, NULL, 2))
-		exit_with_error(errno);
-
-	test->current_step++;
-	pkt_stream_reset(ifobj_rx->pkt_stream);
-	pkts_in_flight = 0;
-
-	/*Spawn RX thread */
-	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
-
-	pthread_barrier_wait(&barr);
-	if (pthread_barrier_destroy(&barr))
-		exit_with_error(errno);
-
-	/*Spawn TX thread */
-	pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
-
-	pthread_join(t1, NULL);
-	pthread_join(t0, NULL);
-
-	if (test->total_steps == test->current_step || test->fail) {
-		xsk_socket__delete(ifobj_tx->xsk->xsk);
-		xsk_socket__delete(ifobj_rx->xsk->xsk);
-		testapp_clean_xsk_umem(ifobj_rx);
-		if (!ifobj_tx->shared_umem)
-			testapp_clean_xsk_umem(ifobj_tx);
-	}
+	return __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
+}
 
-	return !!test->fail;
+static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj)
+{
+	return __testapp_validate_traffic(test, ifobj, NULL);
 }
 
 static void testapp_teardown(struct test_spec *test)
@@ -1674,6 +1650,26 @@ static void testapp_xdp_drop(struct test_spec *test)
 	}
 }
 
+static void testapp_poll_txq_tmout(struct test_spec *test)
+{
+	test_spec_set_name(test, "POLL_TXQ_FULL");
+
+	test->ifobj_tx->use_poll = true;
+	/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
+	test->ifobj_tx->umem->frame_size = 2048;
+	pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
+	testapp_validate_traffic_single_thread(test, test->ifobj_tx);
+
+	pkt_stream_restore_default(test);
+}
+
+static void testapp_poll_rxq_tmout(struct test_spec *test)
+{
+	test_spec_set_name(test, "POLL_RXQ_EMPTY");
+	test->ifobj_rx->use_poll = true;
+	testapp_validate_traffic_single_thread(test, test->ifobj_rx);
+}
+
 static int xsk_load_xdp_programs(struct ifobject *ifobj)
 {
 	ifobj->xdp_progs = xsk_xdp_progs__open_and_load();
@@ -1784,18 +1780,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_POLL_TXQ_TMOUT:
-		test_spec_set_name(test, "POLL_TXQ_FULL");
-		test->ifobj_tx->use_poll = true;
-		/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
-		test->ifobj_tx->umem->frame_size = 2048;
-		pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
-		testapp_validate_traffic_single_thread(test, test->ifobj_tx, type);
-		pkt_stream_restore_default(test);
+		testapp_poll_txq_tmout(test);
 		break;
 	case TEST_TYPE_POLL_RXQ_TMOUT:
-		test_spec_set_name(test, "POLL_RXQ_EMPTY");
-		test->ifobj_rx->use_poll = true;
-		testapp_validate_traffic_single_thread(test, test->ifobj_rx, type);
+		testapp_poll_rxq_tmout(test);
 		break;
 	case TEST_TYPE_ALIGNED_INV_DESC:
 		test_spec_set_name(test, "ALIGNED_INV_DESC");
-- 
2.34.1

