Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4587359CAA3
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 23:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbiHVVRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 17:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238000AbiHVVPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 17:15:34 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7123E3CBDD
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 14:15:33 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-32a115757b6so208678477b3.13
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 14:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=ro7AyiiJTqlq2vnZtnA0vZ1uJj0lH9BK/27il1sSics=;
        b=AE6eZd/aHkPF7Vo4GabGAh1ke4F7/4VZWL0U2B7m6TPTH6WEbA/rq+BPfFO+0xVrLA
         1j3VjTS1D0Ahh9u36dM4eSHXpf8eamN8d7UqElc+sxblQ8xbEIVbyjXAfBslUzw+RG2M
         zNXiKK6QLuiU69vbN86p3VKGMAy4CnNDkD/WM+K8yt+FFy+36ihTB/8Qhxv095EoTBAo
         DFuDeyBRT7Sd2hk6XwWZxjjqdgxCdX6rGiv+6wjC6SOLPyA9vkAYd2aqvuY3nlCJY33Q
         zfpgVNQ0fCkjUGeFNIHfV/C1B20JlgrYrWbn8ZRjwO7SJlXg2hlS/CLyTpU3YAIsOKCv
         RzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=ro7AyiiJTqlq2vnZtnA0vZ1uJj0lH9BK/27il1sSics=;
        b=dpi4QFw3QSXmxhglJG1f7eGCo/heUyEQjmu+kI2Fb34VvDcKeFzHSEFt778gbswN8y
         eqHmLXcCFiH640ifxCZFuIaVWXfJkcveiLjqk/5x144PoqPlJa0eRYL/EebMbKmDe2QU
         jZu1zykFctE24ylamvDWoBXiGgWBe+s1RPxVCwcvdp+JecL3/fVnMJPaHOcTkVIa6zmq
         6+Ld9pGKHzlvDe9xUrrWJEzZ1+oOOk5H9Am4Cr94ETmJT5KVlydVp4TGqPpmQWVYwcvi
         oZ3a0rXvjomKtQk6qUXhLV1cvpd/5wNXaOrlAFXjtH7qwtS+xf+wrGP7v6glNhH7Xph+
         to4A==
X-Gm-Message-State: ACgBeo1D2llb7fNCaGv1snuQ0IBVBFRPMfWIQqKE09JxQEe7xM/T+nGs
        BJy13EYKlcXZ0WTKGaRos0hBxMDJRgyzKA==
X-Google-Smtp-Source: AA6agR7H1DU4ZRs4T89rhTGAzEZuQSG2Qn3D4h4Zb45BT1GXJtU79WOgRRQpf9URYrt1aSydjZHtc2qcZqVhdQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:38a:b0:670:aa12:8908 with SMTP
 id f10-20020a056902038a00b00670aa128908mr20788127ybs.446.1661202932680; Mon,
 22 Aug 2022 14:15:32 -0700 (PDT)
Date:   Mon, 22 Aug 2022 21:15:28 +0000
Message-Id: <20220822211528.915954-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH net-next] tcp: annotate data-race around tcp_md5sig_pool_populated
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Abhishek Shah <abhishek.shah@columbia.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_md5sig_pool_populated can be read while another thread
changes its value.

The race has no consequence because allocations
are protected with tcp_md5sig_mutex.

This patch adds READ_ONCE() and WRITE_ONCE() to document
the race and silence KCSAN.

Reported-by: Abhishek Shah <abhishek.shah@columbia.edu>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bbe2187536620a9300ef7350e08c861625c042c0..ba62f8e8bd150c558e2399c134a5546f7def1b34 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4433,12 +4433,16 @@ static void __tcp_alloc_md5sig_pool(void)
 	 * to memory. See smp_rmb() in tcp_get_md5sig_pool()
 	 */
 	smp_wmb();
-	tcp_md5sig_pool_populated = true;
+	/* Paired with READ_ONCE() from tcp_alloc_md5sig_pool()
+	 * and tcp_get_md5sig_pool().
+	*/
+	WRITE_ONCE(tcp_md5sig_pool_populated, true);
 }
 
 bool tcp_alloc_md5sig_pool(void)
 {
-	if (unlikely(!tcp_md5sig_pool_populated)) {
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	if (unlikely(!READ_ONCE(tcp_md5sig_pool_populated))) {
 		mutex_lock(&tcp_md5sig_mutex);
 
 		if (!tcp_md5sig_pool_populated) {
@@ -4449,7 +4453,8 @@ bool tcp_alloc_md5sig_pool(void)
 
 		mutex_unlock(&tcp_md5sig_mutex);
 	}
-	return tcp_md5sig_pool_populated;
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	return READ_ONCE(tcp_md5sig_pool_populated);
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
@@ -4465,7 +4470,8 @@ struct tcp_md5sig_pool *tcp_get_md5sig_pool(void)
 {
 	local_bh_disable();
 
-	if (tcp_md5sig_pool_populated) {
+	/* Paired with WRITE_ONCE() from __tcp_alloc_md5sig_pool() */
+	if (READ_ONCE(tcp_md5sig_pool_populated)) {
 		/* coupled with smp_wmb() in __tcp_alloc_md5sig_pool() */
 		smp_rmb();
 		return this_cpu_ptr(&tcp_md5sig_pool);
-- 
2.37.1.595.g718a3a8f04-goog

