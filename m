Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2043D6741FA
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjASTB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjASTBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:01:55 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F3194C97
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:00:50 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id 12so413821plo.3
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I9RxIgWC70TuaTElw4EoihaHvyU+NcQMmBExfTqXEZU=;
        b=oJMU5Fb7sWUUgRifF1K4wBfpesb+4lwqzhQaP/6VWwkZAfm+L3ccEcf9wpIIOrxn+B
         GcEYmAryMz6/EOC6V6akdQw6TAXr09fRh24vf7MM9mO6vV3t+1TudnieLG9ZPA/a0get
         cppyMBkeoYpOWsNfYGNYL1l5o2iu7Mv1waR4MqMoqpZ6e0INNVytH5w1byHF7FH29D2v
         I1ayScIenPZ09GL1D/jO9gP3W813eELdmHx1rDwDBhRpOYPc0AyIR6+LKsniybYuPaaW
         i4aQaWrfsiOplDC0h7b+jo21GPeNAPiSWpLWqYVLzQqBhnQWVZv7AnG/Q5GAApDmGF2u
         /ZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I9RxIgWC70TuaTElw4EoihaHvyU+NcQMmBExfTqXEZU=;
        b=dYzt7txZWr00rogmp3U4AZFlZD3sYLdXK5jq0GylI1oV7O2yahqeHo3i+c1eKz/yKZ
         DoBZQLKy2nOpvRIiLTnKmud78PXhheHi709nGIiBaHfYdrRXDq5AhcqnaPQlIQcGRoph
         njCAKZUE9rZJPbMa7QFz6qCIp5MjTCTHqP1TdYR30+HSC/ow1o5ZrxVPSJpTF34JDu0l
         XuVWY4EVNtVfYqc6jz6coje9GZBUhkKiaJ/lPcuNjX38f7IKXmzo/gv8VC5kOk7080KG
         HBDixOkAaTNcX/1nHyx+WBDvcPcztuHfbDJZgtFJ5CzLq2A2F44DkgyCTEWWrYueWdnm
         rWSg==
X-Gm-Message-State: AFqh2kpF4QXKoOy6GZtxC3ArI5a/AmKfv4w3fL1pp4uJm/886qBFVnN6
        KDGHx8gcgGPdVHiVsPPUU9I=
X-Google-Smtp-Source: AMrXdXuB0B+HY7LRS5e1APR2mxGUnDNcGRyho9PZK3+aaYTod4HMOlQ1qTXWUZPUIzTv7xY/TK5Qrw==
X-Received: by 2002:a17:90a:db0b:b0:229:5028:b1fe with SMTP id g11-20020a17090adb0b00b002295028b1femr2727947pjv.1.1674154834226;
        Thu, 19 Jan 2023 11:00:34 -0800 (PST)
Received: from dmoe.c.googlers.com.com (25.11.145.34.bc.googleusercontent.com. [34.145.11.25])
        by smtp.gmail.com with ESMTPSA id mz15-20020a17090b378f00b002296bffb667sm3471721pjb.45.2023.01.19.11.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 11:00:33 -0800 (PST)
From:   David Morley <morleyd.kernel@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Morley <morleyd@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net] tcp: fix rate_app_limited to default to 1
Date:   Thu, 19 Jan 2023 19:00:28 +0000
Message-Id: <20230119190028.1098755-1-morleyd.kernel@gmail.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
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

From: David Morley <morleyd@google.com>

The initial default value of 0 for tp->rate_app_limited was incorrect,
since a flow is indeed application-limited until it first sends
data. Fixing the default to be 1 is generally correct but also
specifically will help user-space applications avoid using the initial
tcpi_delivery_rate value of 0 that persists until the connection has
some non-zero bandwidth sample.

Fixes: eb8329e0a04d ("tcp: export data delivery rate")
Suggested-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David Morley <morleyd@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Tested-by: David Morley <morleyd@google.com>
---
 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c567d5e8053e..33f559f491c8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -435,6 +435,7 @@ void tcp_init_sock(struct sock *sk)
 
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 
 	/* See draft-stevens-tcpca-spec-01 for discussion of the
 	 * initialization of these values.
@@ -3178,6 +3179,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	tp->plb_rehash = 0;
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
+	tp->rate_app_limited = 1;
 	tp->rack.mstamp = 0;
 	tp->rack.advanced = 0;
 	tp->rack.reo_wnd_steps = 1;
-- 
2.39.0.246.g2a6d74b583-goog

