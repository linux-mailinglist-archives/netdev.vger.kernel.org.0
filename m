Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C03E29D692
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731401AbgJ1WQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730955AbgJ1WQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:16:18 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6684AC0613CF;
        Wed, 28 Oct 2020 15:16:18 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id s15so1089014ejf.8;
        Wed, 28 Oct 2020 15:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iwQcabFRrU2vdBHXJKGgczaLWxbb/mobf9EMpVjlwVs=;
        b=q4gBqgyl5zVnZmWSvnnKZZIJZBciWMboNqlLvxmYb5kZa8bvPbIftieV+ScHhBjPhm
         ByAXEncuL0uCWZGCidtmsCkx3po0YE/YaMYvR9JKB5DhGuoyEwtnN735wH9U/+NvGRYc
         kO9yZin0GLhzl6PSgrdiJePNk7uvIF1g1YXAUHNmrdVWXlccVzuV/35sxiPgYzAsWJk2
         VH+QX+G52kaRNKUI0LGpFnWnKEuc4fy8sYcA+fcngqyHvy7DpHPFlFMNkkk715GFsgCN
         b9TkGrbvI6iKisjZKI7ESZtQlZ3nAD0QXKtP0It9YKJdkznrGKijH6EuOHk0cERtgn43
         e9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iwQcabFRrU2vdBHXJKGgczaLWxbb/mobf9EMpVjlwVs=;
        b=cfqjka4S6GZZ10IYcrub9wZ0rTComV5mW6gOgxWja/FfWRyq2gXEOueyiGuAD5wjMl
         DjORAkX2epfGlbwNKLoSDxCuEYE8aRlX37MPuqM1DqJgadBDEULqjlTgth6Ir8trhcH5
         +R/bnXruxFZs8HnZmSDzlqdA4sBwxpwHIQVldoBKDjy+UUkKeHO2rslO0T20KaPmgNy1
         A5pXXOhoqTR+T1/n1K++xjBtbXLcmpneMXqDrOtnvk8nKyozxVX82v1+1BfWYz64Bf76
         QUEEC+NjnJLDVe5Mxtvd0yIIz83mQUZ8NwvRVIiVkuSRod2FgEXeAB0/64H5yaZkdN3h
         pqMQ==
X-Gm-Message-State: AOAM531N/IU6UtV+xCRiZuW4qJz82JChyN++59cnDt/6PXkNH2t0PxjT
        whuJT11egEj4dIrZGEXn6wv5zijsrprF9A==
X-Google-Smtp-Source: ABdhPJyx/Tg3lpa91puNZ1/K/FVLjX3eAERpw3U7g9z2MqebNiUdnJ6XKDNtvID/bAL78uck3RiTLA==
X-Received: by 2002:a5d:55c8:: with SMTP id i8mr687366wrw.194.1603909263036;
        Wed, 28 Oct 2020 11:21:03 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id r28sm531178wrr.81.2020.10.28.11.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:21:02 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v4 1/3] kernel: make kcov_common_handle consider the current context
Date:   Wed, 28 Oct 2020 18:20:16 +0000
Message-Id: <20201028182018.1780842-2-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
In-Reply-To: <20201028182018.1780842-1-aleksandrnogikh@gmail.com>
References: <20201028182018.1780842-1-aleksandrnogikh@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

kcov_common_handle is a method that is used to obtain a "default" KCOV
remote handle of the current process. The handle can later be passed
to kcov_remote_start in order to collect coverage for the processing
that is initiated by one process, but done in another. For details see
Documentation/dev-tools/kcov.rst and comments in kernel/kcov.c.

Presently, if kcov_common_handle is called in an IRQ context, it will
return a handle for the interrupted process. This may lead to
unreliable and incorrect coverage collection.

Adjust the behavior of kcov_common_handle in the following way. If it
is called in a task context, return the common handle for the
currently running task. Otherwise, return 0.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
---
 kernel/kcov.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/kcov.c b/kernel/kcov.c
index 6b8368be89c8..80bfe71bbe13 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -1023,6 +1023,8 @@ EXPORT_SYMBOL(kcov_remote_stop);
 /* See the comment before kcov_remote_start() for usage details. */
 u64 kcov_common_handle(void)
 {
+	if (!in_task())
+		return 0;
 	return current->kcov_handle;
 }
 EXPORT_SYMBOL(kcov_common_handle);
-- 
2.29.0.rc2.309.g374f81d7ae-goog

