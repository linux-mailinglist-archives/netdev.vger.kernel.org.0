Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8DF1253FB
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfLRU7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:59:36 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46470 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLRU7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:59:36 -0500
Received: by mail-pg1-f194.google.com with SMTP id z124so1885463pgb.13
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 12:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tehnerd-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=lb/ixr1m+45xtCqPRmjvhdcCjstQd1ipG5JtVMM9d1g=;
        b=Bef2IopS49vtVLjD2Rvhhsf8K94aU1nyGWPFRSYjV2pu85vGgQ+n5dpdrdJu8St5gh
         +a6pReNCrl4gHXNP0A4FO436uKAS3SF4Aahp9exK6UQ29PXKke67ECU/IGbNo9auTqqq
         AR612B0P/I3Hr+S6nJ3/L97XJT6qR+BWeMOf1FIPIkebwSD76gpIdCdh+TXXSaKvNR4m
         PJ3+U5Huk4EC9krutY56oX7/oCd96mJcbBEW8JyPLOeMWUarel22JCXxwGtW0LW5GVOd
         cBbToVedlgOU0oGHT0CIIlOVVkB/2HIfCTOYcE3flWv99XcXvBbjpXnBq9KllcSGh7QK
         P4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lb/ixr1m+45xtCqPRmjvhdcCjstQd1ipG5JtVMM9d1g=;
        b=Nbjpr06RrNtbKgpP4qhrFN8wgWy/WgG28A/dITPLG3u7vzOUze8nktb2XGQPWYVK/B
         +b7Dub+mvjKnXMRbZ8Rz0iEWZsD2Wm7mnfG03DMSk+gsh1lrGLcYD2ehZvPLkKxz+0Ae
         HIdNA6kthCJcV6EnKKr5jQoUXG0ObwISVxWmKv9J2g4uQowACNW84WxXYTt0mpIEJenW
         spF/jCDz/aCGtEW61PnzIu1vPgoofNfJKcq7/9zdqr4NNI6WkWjHhbSXvtu93wdwBNUu
         ovjr0wvov37ic0EiJHuavEoFxOc2Z50EsXvVj9VJ2wZp8ih3MY4eGpYiAEjD282uwmMY
         TYBA==
X-Gm-Message-State: APjAAAXGCRUc9hzYKue3z5QllRbEN0oyFtFRvcdJpw6LD3lqnB5d+ZBX
        /A9cOT4YFO5vW2XUtWnNGcrAFg==
X-Google-Smtp-Source: APXvYqy1JzVXsbGhoagZUggzXCoHg7B0PRTSeNRmpgjwjUt5nB5HaTq1jHF/EArXG4OBds/RQjzWCA==
X-Received: by 2002:aa7:968d:: with SMTP id f13mr5124215pfk.67.1576702775762;
        Wed, 18 Dec 2019 12:59:35 -0800 (PST)
Received: from localhost.localdomain ([205.189.0.106])
        by smtp.gmail.com with ESMTPSA id i127sm4754874pfc.55.2019.12.18.12.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 12:59:35 -0800 (PST)
From:   "Nikita V. Shirokov" <tehnerd@tehnerd.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, "Nikita V. Shirokov" <tehnerd@tehnerd.com>
Subject: [PATCH bpf-next] bpf: allow to change skb mark in test_run
Date:   Wed, 18 Dec 2019 12:57:47 -0800
Message-Id: <20191218205747.107438-1-tehnerd@tehnerd.com>
X-Mailer: git-send-email 2.15.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

allow to pass skb's mark field into bpf_prog_test_run ctx
for BPF_PROG_TYPE_SCHED_CLS prog type. that would allow
to test bpf programs which are doing decision based on this
field

Signed-off-by: Nikita V. Shirokov <tehnerd@tehnerd.com>
---
 net/bpf/test_run.c                               | 10 +++++++++-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c |  5 +++++
 tools/testing/selftests/bpf/progs/test_skb_ctx.c |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 93a9c87787e0..d555c0d8657d 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -251,7 +251,13 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 		return 0;
 
 	/* make sure the fields we don't use are zeroed */
-	if (!range_is_zero(__skb, 0, offsetof(struct __sk_buff, priority)))
+	if (!range_is_zero(__skb, 0, offsetof(struct __sk_buff, mark)))
+		return -EINVAL;
+
+	/* mark is allowed */
+
+	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, mark),
+			   offsetof(struct __sk_buff, priority)))
 		return -EINVAL;
 
 	/* priority is allowed */
@@ -274,6 +280,7 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 			   sizeof(struct __sk_buff)))
 		return -EINVAL;
 
+	skb->mark = __skb->mark;
 	skb->priority = __skb->priority;
 	skb->tstamp = __skb->tstamp;
 	memcpy(&cb->data, __skb->cb, QDISC_CB_PRIV_LEN);
@@ -301,6 +308,7 @@ static void convert_skb_to___skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	if (!__skb)
 		return;
 
+	__skb->mark = skb->mark;
 	__skb->priority = skb->priority;
 	__skb->tstamp = skb->tstamp;
 	memcpy(__skb->cb, &cb->data, QDISC_CB_PRIV_LEN);
diff --git a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
index edf5e8c7d400..c6d6b685a946 100644
--- a/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
+++ b/tools/testing/selftests/bpf/prog_tests/skb_ctx.c
@@ -13,6 +13,7 @@ void test_skb_ctx(void)
 		.tstamp = 7,
 		.wire_len = 100,
 		.gso_segs = 8,
+		.mark = 9,
 	};
 	struct bpf_prog_test_run_attr tattr = {
 		.data_in = &pkt_v4,
@@ -93,4 +94,8 @@ void test_skb_ctx(void)
 		   "ctx_out_tstamp",
 		   "skb->tstamp == %lld, expected %d\n",
 		   skb.tstamp, 8);
+	CHECK_ATTR(skb.mark != 10,
+		   "ctx_out_mark",
+		   "skb->mark == %u, expected %d\n",
+		   skb.mark, 10);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_skb_ctx.c b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
index 534fbf9a7344..e18da87fe84f 100644
--- a/tools/testing/selftests/bpf/progs/test_skb_ctx.c
+++ b/tools/testing/selftests/bpf/progs/test_skb_ctx.c
@@ -17,6 +17,7 @@ int process(struct __sk_buff *skb)
 	}
 	skb->priority++;
 	skb->tstamp++;
+	skb->mark++;
 
 	if (skb->wire_len != 100)
 		return 1;
-- 
2.15.1

