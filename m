Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2DC2C4507
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgKYQZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731278AbgKYQZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 11:25:36 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006BEC0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 08:25:34 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id v18so2873463qta.22
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 08:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=no14nsVrqsySIKMLKuU/qBvlepwoMcLT6bSb3aZ/zhU=;
        b=rWRgvVMRO0CUdSU8Qv6si89hg0Ryx3BuzihRsJ47u3eFHN8LYh1Vimv5hzKVIwnCqu
         hHhZEMEXKzGG/6J9hRmAJVMlXv5ERrjFKOqHUIWCBPxIOC5mMwmJN7H3QOdxhNhXt/VG
         swcel8subQcvBB0Ej7qrbBhkiQBH/sZh1ylx9CT/o+cHUBSVen4/G7AW4d0ZP4gAupNF
         GqznoVtIWOHcm2ca8N8iz76MbpBV0CFtTxxNnNcwNxqia8ObmOjFgf003lx3zUP830e/
         Nu1jK/dza8+Ye+jjP5SEZn8F6YaAt8+EVvEMW2z4psRxqi730nD8nOtoF7k6wCp9+T9d
         FTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=no14nsVrqsySIKMLKuU/qBvlepwoMcLT6bSb3aZ/zhU=;
        b=aF1Zp5GSKop4/e615JdMYkZ2GWb3bwnXBHmACNaJtNH8g8Dw1NKYBNbns/UN9zMqQc
         eUsEK5tfr4Pljp7Z9PsxNhbqLyUwNzoGCLEqOkP3Zem2FSrXzat7lmmV2ZF113oQeox9
         /LOzz6UNIjzbDL/MTUS1Ywxoyq5WFeJYkq2sHtDN4ho+ejooM9EMflyB7ab2NQ2q1wX1
         anh+6Ivp8j/43h9Xx3H0uX3YzO5mA2/W1Vz5dWMkX9VnNtJqBkilPFfhMYUttaj3jrgB
         P7EVlnHdJd9AKHGKapIfiolvnxOStUp5WjJiLWOnnLFaOWtaaN21B7QFOJDPsXnCdbjh
         Xa0A==
X-Gm-Message-State: AOAM5300L8v94Ee3kd+ruuWLBDmWUJ8ZHjVenPJJWLtKp/izTTGIhLvd
        bI9DBphF8+JHf7igqVNyNDIslI6R6g==
X-Google-Smtp-Source: ABdhPJwCorX1KcHgm8LwihXrhAXtD9W3r7tduUqpOGEG1WJrDpd4LRl0b77lMC8XFLcOsbys4kX3bWoDwQ==
Sender: "elver via sendgmr" <elver@elver.muc.corp.google.com>
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
 (user=elver job=sendgmr) by 2002:a0c:e9c7:: with SMTP id q7mr4494432qvo.9.1606321534107;
 Wed, 25 Nov 2020 08:25:34 -0800 (PST)
Date:   Wed, 25 Nov 2020 17:24:53 +0100
In-Reply-To: <20201125162455.1690502-1-elver@google.com>
Message-Id: <20201125162455.1690502-2-elver@google.com>
Mime-Version: 1.0
References: <20201125162455.1690502-1-elver@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v6 1/3] kernel: make kcov_common_handle consider the current context
From:   Marco Elver <elver@google.com>
To:     elver@google.com, davem@davemloft.net, kuba@kernel.org,
        johannes@sipsolutions.net
Cc:     akpm@linux-foundation.org, a.nogikh@gmail.com, edumazet@google.com,
        andreyknvl@google.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, idosch@idosch.org, fw@strlen.de,
        willemb@google.com, Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
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
Signed-off-by: Marco Elver <elver@google.com>
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
2.29.2.454.gaff20da3a2-goog

