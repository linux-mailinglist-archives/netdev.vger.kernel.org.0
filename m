Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D370455E8DF
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347280AbiF1P0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347495AbiF1P0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:26:17 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7FD2DA95;
        Tue, 28 Jun 2022 08:26:15 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so7797242wmb.5;
        Tue, 28 Jun 2022 08:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fvFBEHCo1qH1EpWhDVKqHf9IDy6JRx+nY8qFP/kBMhY=;
        b=KxQLq7QONownthdqop92oYKwYYFYISLoMKf9ehLy0vv1r8UFYTE+7PgxsoQ5u76CnT
         rZ8H9Zd6PryENnGnjZxlS2I+xQsLlNsdD9jgnmRB0PEMWML5CGrSEsvonVfyeJXyD1WI
         2VC7XYo2XPTbxGiXeCyjX8yN733r44TRNivAeerqD9xLb4OQ2vMyarl4Ga96Ef1Xl9Ha
         w+WNUWBFsuzhtnO/5Y3iYrbgzvbohsI4sCmYrs8TSuZ86JGvImK10xRGjPpkGIMnJiJU
         c0FQBO16LV+jH5uJccBbgXI/ctyufg5SBxOpac+95wDfEt7FQ0UmrEunzOzZTUVgNCnX
         7Tsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fvFBEHCo1qH1EpWhDVKqHf9IDy6JRx+nY8qFP/kBMhY=;
        b=CK42xg60Sp8N1BA1Afz+sjo1e0zr8jKeUFn1b2XFdNLfXFKE2JiwVebsDUhwp+SpK8
         N180Yak9LfefKBL95JdwEXP63NSLNtb+HjobXP/7vqJ50cLMFoGWrFPHZkzdLz6cy3tN
         xe6wytKW/1CRusfRhAldnELm0t7099LQFuOXJRYndOy6BTTt6z8sDHlBifGwkuJ7zNqW
         i2VeQedlxva6bvUSJW/cts47BWzBmw51Zh3OkosxTjWL8xQM8JxeZzdsDP5/472ll+V8
         QDyAiJaWdz0hO4U0WWQBByKfp6VvmoMqoG4iZ6H/a7OJ9fcY8TNNj0HaNFxIlnUCbei0
         YhjA==
X-Gm-Message-State: AJIora/tslDfGPQgNylWWQiMvOlfOeellJIHdx4Ha9G0Vr5ndI8Xahup
        I0opzGwl1OPvTRwp1j57im8milNzVEdr0A==
X-Google-Smtp-Source: AGRyM1sA6ZFCQWb1zW117IHiYrAI11XwEaU/NW/NufaxRKB6mQkfCKPdHnyekumv+v78K1vhafEvnw==
X-Received: by 2002:a05:600c:6013:b0:3a0:2aec:8695 with SMTP id az19-20020a05600c601300b003a02aec8695mr176135wmb.192.1656429974248;
        Tue, 28 Jun 2022 08:26:14 -0700 (PDT)
Received: from localhost.localdomain (91-170-156-47.subs.proxad.net. [91.170.156.47])
        by smtp.gmail.com with ESMTPSA id c3-20020a05600c0a4300b00397393419e3sm26293264wmq.28.2022.06.28.08.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 08:26:13 -0700 (PDT)
From:   Julien Salleyron <julien.salleyron@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Julien Salleyron <julien.salleyron@gmail.com>,
        Marc Vertes <mvertes@free.fr>
Subject: [PATCH] net: tls: fix tls with sk_redirect using a BPF verdict.
Date:   Tue, 28 Jun 2022 17:25:05 +0200
Message-Id: <20220628152505.298790-1-julien.salleyron@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to use KTLS on a socket where we apply sk_redirect using a BPF
verdict program.

Without this patch, we see that the data received after the redirection are
decrypted but with an incorrect offset and length. It seems to us that the
offset and length are correct in the stream-parser data, but finally not applied
in the skb. We have simply applied those values to the skb.

In the case of regular sockets, we saw a big performance improvement from
applying redirect. This is not the case now with KTLS, may be related to the
following point.

It is still necessary to perform a read operation (never triggered) from user
space despite the redirection. It makes no sense, since this read operation is
not necessary on regular sockets without KTLS.

We do not see how to fix this problem without a change of architecture, for
example by performing TLS decrypt directly inside the BPF verdict program.

An example program can be found at
https://github.com/juliens/ktls-bpf_redirect-example/

Co-authored-by: Marc Vertes <mvertes@free.fr>
---
 net/tls/tls_sw.c                           | 6 ++++++
 tools/testing/selftests/bpf/test_sockmap.c | 8 +++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0513f82b8537..a409f8a251db 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1839,8 +1839,14 @@ int tls_sw_recvmsg(struct sock *sk,
 			if (bpf_strp_enabled) {
 				/* BPF may try to queue the skb */
 				__skb_unlink(skb, &ctx->rx_list);
+
 				err = sk_psock_tls_strp_read(psock, skb);
+
 				if (err != __SK_PASS) {
+                    if (err == __SK_REDIRECT) {
+                        skb->data += rxm->offset;
+                        skb->len = rxm->full_len;
+                    }
 					rxm->offset = rxm->offset + rxm->full_len;
 					rxm->full_len = 0;
 					if (err == __SK_DROP)
diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 0fbaccdc8861..503e0f3d16a7 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -739,13 +739,11 @@ static int sendmsg_test(struct sockmap_options *opt)
 
 	if (ktls) {
 		/* Redirecting into non-TLS socket which sends into a TLS
-		 * socket is not a valid test. So in this case lets not
-		 * enable kTLS but still run the test.
+		 * socket is not a valid test. So in this case just skip
+		 * the test.
 		 */
 		if (!txmsg_redir || txmsg_ingress) {
-			err = sockmap_init_ktls(opt->verbose, rx_fd);
-			if (err)
-				return err;
+			return 0;
 		}
 		err = sockmap_init_ktls(opt->verbose, c1);
 		if (err)
-- 
2.36.1

