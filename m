Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B28CDADC
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfJGEKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 00:10:01 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43331 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJGEKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 00:10:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id c4so4649083qtn.10
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 21:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+2+jI9bm9pSuj8YfLh9qySWHl8T1Wg6OrX5Uh1PkTo0=;
        b=ge/0kq2sL+wQwp1mX+T+6LTQ9mVfhM36p+iHg49y8pM3w+NIuRRl6DuKfsgoU6hZn4
         kLKgqh1PhzsH/koWudt9RPDDx6gUKOXBK+ZXxdQEP29tP3G6ZQd8mIvLIjeMfmlsqi/c
         a9mpKkP8RhkBmkc9aQnrAKy4WzJ49Rd4HoU8vxXbeRFWifkYtz8A3irV0NF/gKfysJ7M
         VdYRnWTs96lBMr6AIyJSujjcdZTNMlcdW1oIxB4aN4Cxp6KriLSoeN7CAysgGUQlt5Gb
         W8IR0H7YqR2x52hlb98xuGRXJpJqso2HoOUGmlcEqWhKbmqwgN7PYKIFcmA5UwvoCKVK
         fq7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+2+jI9bm9pSuj8YfLh9qySWHl8T1Wg6OrX5Uh1PkTo0=;
        b=JyJdOFIZRc79htq/u0moeNd1N7n7iKrYGjaCggx1hXEW+hW4DoBzuwTJDn0YKSoFyV
         9SegfGQxVjAiv1LtzXcZN0teorp1e1BKvedIh19norr+BJvJGMJ8MLg08k8aKFeBIiGZ
         1WCiDJisP9shHmtVhBUbxQbZoH59eRIOqbOsCv22BY/FkCc+cFvz1lqoKM3rqpJJqc3d
         3rngiBJJJGxZeGgupLjVUYl/3CTPfuwOzI7OKtjSC/9Nz7nkka8WcAxDbjbx44wzB+iI
         oTdHbESkMGGh9Np2av7NFJtgpmptY1fVvV9ZcYS4ajZrO0MCwaxrEnGlXJ8lno29Xj08
         7wpg==
X-Gm-Message-State: APjAAAUwEr6bW5fKElKRHv12LCYBdWj0quqSRStvJ1AoPNFViaH+DEP/
        NhfOlZibYGNVUDarF8zbz8FXPQ==
X-Google-Smtp-Source: APXvYqzfS5AQyfAcHV4OsbzJ85WutdexGBzmpuV4uS8AJy6ffAu4ZXrC2uLReWv5JNfwnrwOl7uY/g==
X-Received: by 2002:ac8:134c:: with SMTP id f12mr27779587qtj.162.1570421400663;
        Sun, 06 Oct 2019 21:10:00 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y22sm3796058qka.59.2019.10.06.21.09.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 21:10:00 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 1/6] net: sockmap: use bitmap for copy info
Date:   Sun,  6 Oct 2019 21:09:27 -0700
Message-Id: <20191007040932.26395-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007040932.26395-1-jakub.kicinski@netronome.com>
References: <20191007040932.26395-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't use bool array in struct sk_msg_sg, save 12 bytes.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/linux/skmsg.h | 12 ++++++++----
 net/core/filter.c     |  4 ++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index e4b3fb4bb77c..fe80d537945d 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -28,13 +28,14 @@ struct sk_msg_sg {
 	u32				end;
 	u32				size;
 	u32				copybreak;
-	bool				copy[MAX_MSG_FRAGS];
+	unsigned long			copy;
 	/* The extra element is used for chaining the front and sections when
 	 * the list becomes partitioned (e.g. end < start). The crypto APIs
 	 * require the chaining.
 	 */
 	struct scatterlist		data[MAX_MSG_FRAGS + 1];
 };
+static_assert(BITS_PER_LONG >= MAX_MSG_FRAGS);
 
 /* UAPI in filter.c depends on struct sk_msg_sg being first element. */
 struct sk_msg {
@@ -227,7 +228,7 @@ static inline void sk_msg_compute_data_pointers(struct sk_msg *msg)
 {
 	struct scatterlist *sge = sk_msg_elem(msg, msg->sg.start);
 
-	if (msg->sg.copy[msg->sg.start]) {
+	if (test_bit(msg->sg.start, &msg->sg.copy)) {
 		msg->data = NULL;
 		msg->data_end = NULL;
 	} else {
@@ -246,7 +247,7 @@ static inline void sk_msg_page_add(struct sk_msg *msg, struct page *page,
 	sg_set_page(sge, page, len, offset);
 	sg_unmark_end(sge);
 
-	msg->sg.copy[msg->sg.end] = true;
+	__set_bit(msg->sg.end, &msg->sg.copy);
 	msg->sg.size += len;
 	sk_msg_iter_next(msg, end);
 }
@@ -254,7 +255,10 @@ static inline void sk_msg_page_add(struct sk_msg *msg, struct page *page,
 static inline void sk_msg_sg_copy(struct sk_msg *msg, u32 i, bool copy_state)
 {
 	do {
-		msg->sg.copy[i] = copy_state;
+		if (copy_state)
+			__set_bit(i, &msg->sg.copy);
+		else
+			__clear_bit(i, &msg->sg.copy);
 		sk_msg_iter_var_next(i);
 		if (i == msg->sg.end)
 			break;
diff --git a/net/core/filter.c b/net/core/filter.c
index ed6563622ce3..46196e212413 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2245,7 +2245,7 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 	 * account for the headroom.
 	 */
 	bytes_sg_total = start - offset + bytes;
-	if (!msg->sg.copy[i] && bytes_sg_total <= len)
+	if (!test_bit(i, &msg->sg.copy) && bytes_sg_total <= len)
 		goto out;
 
 	/* At this point we need to linearize multiple scatterlist
@@ -2450,7 +2450,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 	/* Place newly allocated data buffer */
 	sk_mem_charge(msg->sk, len);
 	msg->sg.size += len;
-	msg->sg.copy[new] = false;
+	__clear_bit(new, &msg->sg.copy);
 	sg_set_page(&msg->sg.data[new], page, len + copy, 0);
 	if (rsge.length) {
 		get_page(sg_page(&rsge));
-- 
2.21.0

