Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20EF84D5C1A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346928AbiCKHQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346893AbiCKHQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:16:50 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED0D1B60A0
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:15:47 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d07ae11467so62105657b3.12
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kehSp/poBksAvN+ookLna3p1CLAB/x6vQemcHHjE9ck=;
        b=fegh3z766K7XxTtoebS427NIXVyVt0vELknatpspBcD93w7b4yKgCM8VTOA/JwonRG
         rA+XIToLf/q5jYCMKU1PttLZHvXYU8b3DL9xmEEz/UqE6uODJg+dymzXp38PNK1zNgJk
         6IGNpHaVAoKQYdyVZf5VzJoz+Yr03u9BIOws5FX/6piicMFh62mjwW9YawDLz9EcXjFR
         scPRFOv064kITQRykgdBz+yWBFfc7/wl4WNjXVlMmHTG6SCjAZheE5gqCCPSl0gH0Of5
         bqpRfI2LWAl4P0Bo06c4vhnC89KL6IYzks34DnptJpsluZQIszC276vQBxiEzAjhH5Mu
         SekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kehSp/poBksAvN+ookLna3p1CLAB/x6vQemcHHjE9ck=;
        b=gvgAUjzNOQJ65DuVuj+eCCKLUwhWJDL09FWghywV6QF9mqwd+L7sTdM3xtZh4BTk+9
         uQS5Dk1DGvzOs6e0pZJ6mVlNL81dHByhJWjJgDTLV1yUnm0uWRcFlI1SlcwCE5UKpVAN
         K8KL+utQprc2xhty7bvdFGzpalfdpSOTM0NhUC9u0O7HW522F5pcWA6iNxbRu7Q+fmN2
         PCpEq+puuOw7LdhGVzKzVY8K6ZHwaybeV9eAqAWNzrUWRXIMyfCMBHgCtg1ey0Sctpto
         1xsG1B5OHmAuS6cW1IeE2vJwZahJPw5Rbb254Tf7hDsQ1n3MzR3DiygpBJHeg1Fb4R47
         IyZg==
X-Gm-Message-State: AOAM532hbLoR7/B0hw33bpdkYbmD5KbeLyewqGtP1SIXtwtDIoScipfR
        CwwsrffJK0w6ogt9Rpv+nevBfvGhYhUKIA==
X-Google-Smtp-Source: ABdhPJxmCB7rj2KPICFIlO7jQTEBEIX3UJqMDu1xzucTtM+H9C5+zwsTdAQHebuflHkEJq4xsHVsGn3TSZXY/A==
X-Received: from slicestar.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:20a1])
 (user=davidgow job=sendgmr) by 2002:a25:8684:0:b0:629:917:c5c with SMTP id
 z4-20020a258684000000b0062909170c5cmr6701419ybk.403.1646982946981; Thu, 10
 Mar 2022 23:15:46 -0800 (PST)
Date:   Fri, 11 Mar 2022 15:15:29 +0800
In-Reply-To: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
Message-Id: <20220311071529.1836818-1-davidgow@google.com>
Mime-Version: 1.0
References: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH] list: test: Add a test for list_traverse
From:   David Gow <davidgow@google.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>,
        kunit-dev@googlegroups.com, David Gow <davidgow@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the list KUnit test to include a test for the new list_traverse()
macro. This adds a new 'head' member to the list_test_struct to use as a
list head, using the list_traverse_head macro.

Signed-off-by: David Gow <davidgow@google.com>
---

If, as seems likely, we're going to introduce new list traversal macros,
it'd be nice to update the linked list KUnit tests in lib/list-test.c to
test them. :-)

This patch works against the proposed list_traverse() macro posted here:
https://lore.kernel.org/all/CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com/

Feel free to use and/or adapt it if this or a similar macro is
introduced.

Cheers,
-- David

---
 lib/list-test.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/lib/list-test.c b/lib/list-test.c
index ee09505df16f..7fa2622ff9c7 100644
--- a/lib/list-test.c
+++ b/lib/list-test.c
@@ -12,6 +12,7 @@
 struct list_test_struct {
 	int data;
 	struct list_head list;
+	list_traversal_head(struct list_test_struct, head, list);
 };
 
 static void list_test_list_init(struct kunit *test)
@@ -656,6 +657,28 @@ static void list_test_list_for_each_prev_safe(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, list_empty(&list));
 }
 
+static void list_test_list_traverse(struct kunit *test)
+{
+	struct list_test_struct entries[5], head;
+	int i = 0;
+
+	INIT_LIST_HEAD(&head.head);
+
+	for (i = 0; i < 5; ++i) {
+		entries[i].data = i;
+		list_add_tail(&entries[i].list, &head.head);
+	}
+
+	i = 0;
+
+	list_traverse(cur, &head.head, list) {
+		KUNIT_EXPECT_EQ(test, cur->data, i);
+		i++;
+	}
+
+	KUNIT_EXPECT_EQ(test, i, 5);
+}
+
 static void list_test_list_for_each_entry(struct kunit *test)
 {
 	struct list_test_struct entries[5], *cur;
@@ -733,6 +756,7 @@ static struct kunit_case list_test_cases[] = {
 	KUNIT_CASE(list_test_list_for_each_prev),
 	KUNIT_CASE(list_test_list_for_each_safe),
 	KUNIT_CASE(list_test_list_for_each_prev_safe),
+	KUNIT_CASE(list_test_list_traverse),
 	KUNIT_CASE(list_test_list_for_each_entry),
 	KUNIT_CASE(list_test_list_for_each_entry_reverse),
 	{},
-- 
2.35.1.723.g4982287a31-goog

