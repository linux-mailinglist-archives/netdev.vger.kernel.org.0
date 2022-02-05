Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86F34AA6AC
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379493AbiBEE4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiBEE4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:56:19 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ED0C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 20:56:18 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso7999388pjt.3
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 20:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=11G5imdIqAGfRpY+HyPONPkJw0UCSaJlNF6DMjTn1lw=;
        b=p/1G0lvUCCgchIOH9FB1Wyila6oY/yEuoN+8tw96VOd9RstA4XoP+4/yy8rQZDxWBR
         wCSLruPkDV1STsGE0AIrfzyQ+SiQuDAKrMW32p/q8hjut9uDxBR7LKnn9wHbbpXVuEge
         rRNxMHQBr0xsDZTjEUtb2Zi1vF+RSjf3yb04VS5GK3N9slJv2WS4pqsG7omH1urD7ZTl
         cz0sp6f7IP81CqdPE2sWwbce2e9x39xvvbXkirUB48KyJOZgzd8fK8PHeNOgj6ji1ns1
         fpAqiN3r7VsBfoporuN/nV5izVO9dfmRzWWYSCMTv+kuab1SCuZR/2zfXafMUwmIOXek
         1MQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=11G5imdIqAGfRpY+HyPONPkJw0UCSaJlNF6DMjTn1lw=;
        b=jvvrjnyFJAu9Bcejfj2GUZgqpclfJ+JlaDvBLnkFz93G824EFA005yP6ePbgnYij0I
         BBJiFgWkc9/oIcBjMOiuscax0eiP82wd/S4AwozRQKC8lsEYllbeXTEwo8v0VmzDAtLL
         KlDzilJ+aJhYq4c3UFfJiNZfe3ymye3xR8UEB53y8G8tRmZvA9qjAqgCNk+1Rt0sYco4
         VEJEXm8bdr0s3zDcYjh9tiXJBA96Cj4oS3r/FaUjTfCSkFKWt9dj//Ke93b3MS/qAOYv
         dbPLwdEr+hio5jlA7gBDc7luYiuVwzkRS8CRQg13j2yjxjxCcbUpiK9+2kl9JNRIuAlJ
         O7oQ==
X-Gm-Message-State: AOAM533TzktkVYDpMaBUjmhcDzjwL5EKgdWWbHwb7DGACvcYMABSEewq
        Q6OF35gNUXNg0+tiGl7TiuY=
X-Google-Smtp-Source: ABdhPJwON7ZrmoUIPH7fCkb5fPl8Bdv3YYoUn6t2Pwu0iNpihDjLLGT/FjAKwteLL1Q4M+HJNTdzBg==
X-Received: by 2002:a17:902:7e06:: with SMTP id b6mr6712191plm.58.1644036977908;
        Fri, 04 Feb 2022 20:56:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id r11sm4167361pff.81.2022.02.04.20.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 20:56:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next] skmsg: convert struct sk_msg_sg::copy to a bitmap
Date:   Fri,  4 Feb 2022 20:56:14 -0800
Message-Id: <20220205045614.3457092-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
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

From: Eric Dumazet <edumazet@google.com>

We have plans for increasing MAX_SKB_FRAGS, but sk_msg_sg::copy
is currently an unsigned long, limiting MAX_SKB_FRAGS to 30 on 32bit arches.

Convert it to a bitmap, as Jakub suggested.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
v2: Sent as a stand alone patch.

 include/linux/skmsg.h | 11 +++++------
 net/core/filter.c     |  4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 18a717fe62eb049758bc1502da97365cf7587ffd..1ff68a88c58de0dc30a50fd030b49ea55a6c2cb9 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -29,7 +29,7 @@ struct sk_msg_sg {
 	u32				end;
 	u32				size;
 	u32				copybreak;
-	unsigned long			copy;
+	DECLARE_BITMAP(copy, MAX_MSG_FRAGS + 2);
 	/* The extra two elements:
 	 * 1) used for chaining the front and sections when the list becomes
 	 *    partitioned (e.g. end < start). The crypto APIs require the
@@ -38,7 +38,6 @@ struct sk_msg_sg {
 	 */
 	struct scatterlist		data[MAX_MSG_FRAGS + 2];
 };
-static_assert(BITS_PER_LONG >= NR_MSG_FRAG_IDS);
 
 /* UAPI in filter.c depends on struct sk_msg_sg being first element. */
 struct sk_msg {
@@ -234,7 +233,7 @@ static inline void sk_msg_compute_data_pointers(struct sk_msg *msg)
 {
 	struct scatterlist *sge = sk_msg_elem(msg, msg->sg.start);
 
-	if (test_bit(msg->sg.start, &msg->sg.copy)) {
+	if (test_bit(msg->sg.start, msg->sg.copy)) {
 		msg->data = NULL;
 		msg->data_end = NULL;
 	} else {
@@ -253,7 +252,7 @@ static inline void sk_msg_page_add(struct sk_msg *msg, struct page *page,
 	sg_set_page(sge, page, len, offset);
 	sg_unmark_end(sge);
 
-	__set_bit(msg->sg.end, &msg->sg.copy);
+	__set_bit(msg->sg.end, msg->sg.copy);
 	msg->sg.size += len;
 	sk_msg_iter_next(msg, end);
 }
@@ -262,9 +261,9 @@ static inline void sk_msg_sg_copy(struct sk_msg *msg, u32 i, bool copy_state)
 {
 	do {
 		if (copy_state)
-			__set_bit(i, &msg->sg.copy);
+			__set_bit(i, msg->sg.copy);
 		else
-			__clear_bit(i, &msg->sg.copy);
+			__clear_bit(i, msg->sg.copy);
 		sk_msg_iter_var_next(i);
 		if (i == msg->sg.end)
 			break;
diff --git a/net/core/filter.c b/net/core/filter.c
index 9615ae1ab530a9735e3d862b1ddf12b1b1f55060..f497ca7a16d223855004876e3a868d5de8cea879 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2603,7 +2603,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 	 * account for the headroom.
 	 */
 	bytes_sg_total = start - offset + bytes;
-	if (!test_bit(i, &msg->sg.copy) && bytes_sg_total <= len)
+	if (!test_bit(i, msg->sg.copy) && bytes_sg_total <= len)
 		goto out;
 
 	/* At this point we need to linearize multiple scatterlist
@@ -2809,7 +2809,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 	/* Place newly allocated data buffer */
 	sk_mem_charge(msg->sk, len);
 	msg->sg.size += len;
-	__clear_bit(new, &msg->sg.copy);
+	__clear_bit(new, msg->sg.copy);
 	sg_set_page(&msg->sg.data[new], page, len + copy, 0);
 	if (rsge.length) {
 		get_page(sg_page(&rsge));
-- 
2.35.0.263.gb82422642f-goog

