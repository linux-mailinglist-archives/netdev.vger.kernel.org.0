Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559304C85AF
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbiCAH7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiCAH7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:59:47 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A181C50E03;
        Mon, 28 Feb 2022 23:59:03 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b8so13389637pjb.4;
        Mon, 28 Feb 2022 23:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YmXLEDuShcOW3JnBcgY++d4c0kg2D36rSz3AenVtmRY=;
        b=P+Lo9i6QowRAx0EEntsNvNUxCt1I6HaXTfmY+33mqDxWWil2KSfipziM4Nn/14h0Oq
         z3ypRqxwexLrfYlQJoFd5+rVz7UslgYwUmHKWvJwvuKairaWtKd3veo5qsliUZ77MFPs
         4HnpB+JqFuavKk7cpK2Xv26KsS2ayZZif2Pr2d/FgeJA2JDTyHKjs7+K7Ws+K0zgWKRI
         ruFI6zDEScMjqU+vBM3+W3qJPu1gsLFAzxWdPEOww2yB+9dZENlLnBl8qdXU/rKNsiTR
         Eg+MOzpR1yqVnUoWa8XtPdBWxpwcFODjLHq/RzIc9anKNpZ0JutOuz4IzAjjjND7Pu74
         wYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YmXLEDuShcOW3JnBcgY++d4c0kg2D36rSz3AenVtmRY=;
        b=h0xc4E5hZjhr3VBZ7Hc/gAcRMCBZt+gWhh5Jf0kbUt4W/kMbzOpNcIIIbD3HcVyTh/
         DMxn9A/+0y0RhjDaeYbqlb9yvG6ZwpSsWqI+SAwAagYUM4KTdKckhtfbPGOIl4mBQryh
         MhNPA9hmwE388LypyCAmq8aJFBB9v1PU7JtYvRqAxzlaxCdRA4GbI2ekrhRk+9mBRgMl
         fdlLV6SDmSQydxdmEWTR+cDKxHq7RjKqyKKevVZDN1nJFurG3Gw2aCfihu4wX1f4zP/A
         I85NQFQGaELtNbHGtglU6gSSmmE8PfFZo/wTKGbOWhlTKjfg3kDqYld+S5JyDHn3Jrdj
         HnKA==
X-Gm-Message-State: AOAM530k5BclnEQB3LgCwojt9NF/kP8yuapWfF7jEJYbJwX15yFrbcnB
        Iup6qT1E0YKSDnovWx38Sb4=
X-Google-Smtp-Source: ABdhPJzyKErM8pnzRaH8ojeB27k6eMiFHyMnxjPUJP6pxbk0TO4CP5X8i6d+VfvO4iKjFenzpV33QA==
X-Received: by 2002:a17:902:7d83:b0:14e:f2f4:743 with SMTP id a3-20020a1709027d8300b0014ef2f40743mr24258960plm.107.1646121542543;
        Mon, 28 Feb 2022 23:59:02 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id o12-20020a17090aac0c00b001b9e5286c90sm1662745pjq.0.2022.02.28.23.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 23:59:02 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH 2/6] list: add new MACROs to make iterator invisiable outside the loop
Date:   Tue,  1 Mar 2022 15:58:35 +0800
Message-Id: <20220301075839.4156-3-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each list_for_each_entry* macros(10 variants), implements a respective
new *_inside one. Such as the new macro list_for_each_entry_inside for
list_for_each_entry. The idea is to be as compatible with the original
interface as possible and to minimize code changes.

Here are 2 examples:

list_for_each_entry_inside:
 - declare the iterator-variable pos inside the loop. Thus, the origin
   declare of the inputed *pos* outside the loop should be removed. In
   other words, the inputed *pos* now is just a string name.
 - add a new "type" argument as the type of the container struct this is
   embedded in, and should be inputed when calling the macro.

list_for_each_entry_safe_continue_inside:
 - declare the iterator-variable pos and n inside the loop. Thus, the
   origin declares of the inputed *pos* and *n* outside the loop should
   be removed. In other words, the inputed *pos* and *n* now are just
   string name.
 - add a new "start" argument as the given iterator to start with and
   can be used to get the container struct *type*. This should be inputed
   when calling the macro.

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 include/linux/list.h | 156 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index dd6c2041d..1595ce865 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -639,6 +639,19 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     !list_entry_is_head(pos, head, member);			\
 	     pos = list_next_entry(pos, member))
 
+/**
+ * list_for_each_entry_inside
+ *  - iterate over list of given type and keep iterator inside the loop
+ * @pos:	the type * to use as a loop cursor.
+ * @type:	the type of the container struct this is embedded in.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry_inside(pos, type, head, member)		\
+	for (type * pos = list_first_entry(head, type, member);		\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = list_next_entry(pos, member))
+
 /**
  * list_for_each_entry_reverse - iterate backwards over list of given type.
  * @pos:	the type * to use as a loop cursor.
@@ -650,6 +663,19 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     !list_entry_is_head(pos, head, member); 			\
 	     pos = list_prev_entry(pos, member))
 
+/**
+ * list_for_each_entry_reverse_inside
+ * - iterate backwards over list of given type and keep iterator inside the loop.
+ * @pos:	the type * to use as a loop cursor.
+ * @type:	the type of the container struct this is embedded in.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry_reverse_inside(pos, type, head, member)	\
+	for (type * pos = list_last_entry(head, type, member);		\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = list_prev_entry(pos, member))
+
 /**
  * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
  * @pos:	the type * to use as a start point
@@ -675,6 +701,22 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     !list_entry_is_head(pos, head, member);			\
 	     pos = list_next_entry(pos, member))
 
+/**
+ * list_for_each_entry_continue_inside
+ *  - continue iteration over list of given type and keep iterator inside the loop
+ * @pos:	the type * to use as a loop cursor.
+ * @start:	the given iterator to start with.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Continue to iterate over list of given type, continuing after
+ * the current position.
+ */
+#define list_for_each_entry_continue_inside(pos, start, head, member)	\
+	for (typeof(*start) *pos = list_next_entry(start, member);	\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = list_next_entry(pos, member))
+
 /**
  * list_for_each_entry_continue_reverse - iterate backwards from the given point
  * @pos:	the type * to use as a loop cursor.
@@ -689,6 +731,22 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     !list_entry_is_head(pos, head, member);			\
 	     pos = list_prev_entry(pos, member))
 
+/**
+ * list_for_each_entry_continue_reverse_inside
+ *  - iterate backwards from the given point and keep iterator inside the loop
+ * @pos:	the type * to use as a loop cursor.
+ * @start:	the given iterator to start with.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Start to iterate over list of given type backwards, continuing after
+ * the current position.
+ */
+#define list_for_each_entry_continue_reverse_inside(pos, start, head, member)	\
+	for (typeof(*start) *pos = list_prev_entry(start, member);		\
+	     !list_entry_is_head(pos, head, member);				\
+	     pos = list_prev_entry(pos, member))
+
 /**
  * list_for_each_entry_from - iterate over list of given type from the current point
  * @pos:	the type * to use as a loop cursor.
@@ -701,6 +759,20 @@ static inline void list_splice_tail_init(struct list_head *list,
 	for (; !list_entry_is_head(pos, head, member);			\
 	     pos = list_next_entry(pos, member))
 
+/**
+ * list_for_each_entry_from_inside
+ *  - iterate over list of given type from the current point and keep iterator inside the loop
+ * @pos:	the type * to use as a loop cursor.
+ * @start:	the given iterator to start with.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing from current position.
+ */
+#define list_for_each_entry_from_inside(pos, start, head, member)			\
+	for (typeof(*start) *pos = start; !list_entry_is_head(pos, head, member);	\
+	     pos = list_next_entry(pos, member))
+
 /**
  * list_for_each_entry_from_reverse - iterate backwards over list of given type
  *                                    from the current point
@@ -714,6 +786,21 @@ static inline void list_splice_tail_init(struct list_head *list,
 	for (; !list_entry_is_head(pos, head, member);			\
 	     pos = list_prev_entry(pos, member))
 
+/**
+ * list_for_each_entry_from_reverse_inside
+ *  - iterate backwards over list of given type from the current point
+ *    and keep iterator inside the loop
+ * @pos:	the type * to use as a loop cursor.
+ * @start:	the given iterator to start with.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate backwards over list of given type, continuing from current position.
+ */
+#define list_for_each_entry_from_reverse_inside(pos, start, head, member)		\
+	for (typeof(*start) *pos = start; !list_entry_is_head(pos, head, member);	\
+	     pos = list_prev_entry(pos, member))
+
 /**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
  * @pos:	the type * to use as a loop cursor.
@@ -727,6 +814,22 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_next_entry(n, member))
 
+/**
+ * list_for_each_entry_safe_inside
+ *  - iterate over list of given type safe against removal of list entry
+ *    and keep iterator inside the loop
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @type:	the type of the container struct this is embedded in.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry_safe_inside(pos, n, type, head, member)	\
+	for (type * pos = list_first_entry(head, type, member),		\
+		*n = list_next_entry(pos, member);			\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_next_entry(n, member))
+
 /**
  * list_for_each_entry_safe_continue - continue list iteration safe against removal
  * @pos:	the type * to use as a loop cursor.
@@ -743,6 +846,24 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
+/**
+ * list_for_each_entry_safe_continue_inside
+ *  - continue list iteration safe against removal and keep iterator inside the loop
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @start:	the given iterator to start with.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing after current point,
+ * safe against removal of list entry.
+ */
+#define list_for_each_entry_safe_continue_inside(pos, n, start, head, member)	\
+	for (typeof(*start) *pos = list_next_entry(start, member),		\
+		*n = list_next_entry(pos, member);				\
+	     !list_entry_is_head(pos, head, member);				\
+	     pos = n, n = list_next_entry(n, member))
+
 /**
  * list_for_each_entry_safe_from - iterate over list from current point safe against removal
  * @pos:	the type * to use as a loop cursor.
@@ -758,6 +879,23 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
+/**
+ * list_for_each_entry_safe_from_inside
+ *  - iterate over list from current point safe against removal and keep iterator inside the loop
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @start:	the given iterator to start with.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type from current point, safe against
+ * removal of list entry.
+ */
+#define list_for_each_entry_safe_from_inside(pos, n, start, head, member)	\
+	for (typeof(*start) *pos = start, *n = list_next_entry(pos, member);	\
+	     !list_entry_is_head(pos, head, member);				\
+	     pos = n, n = list_next_entry(n, member))
+
 /**
  * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
  * @pos:	the type * to use as a loop cursor.
@@ -774,6 +912,24 @@ static inline void list_splice_tail_init(struct list_head *list,
 	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_prev_entry(n, member))
 
+/**
+ * list_for_each_entry_safe_reverse_insde
+ *  - iterate backwards over list safe against removal and keep iterator inside the loop
+ * @pos:	the type * to use as a loop cursor.
+ * @n:		another type * to use as temporary storage
+ * @type:	the type of the struct this is enmbeded in.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Iterate backwards over list of given type, safe against removal
+ * of list entry.
+ */
+#define list_for_each_entry_safe_reverse_inside(pos, n, type, head, member)	\
+	for (type * pos = list_last_entry(head, type, member),			\
+		*n = list_prev_entry(pos, member);				\
+	     !list_entry_is_head(pos, head, member);				\
+	     pos = n, n = list_prev_entry(n, member))
+
 /**
  * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
  * @pos:	the loop cursor used in the list_for_each_entry_safe loop
-- 
2.17.1

