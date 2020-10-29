Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFAF29F363
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgJ2Rg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbgJ2Rg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:36:58 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2CDC0613CF;
        Thu, 29 Oct 2020 10:36:57 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w23so605838wmi.4;
        Thu, 29 Oct 2020 10:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TB+DUFEnKNYJXJ7LZxFHnOPKfGyG/Mg3M5rLxoluigk=;
        b=Qh7iYeJwxrFrzso7bTrTPPTL1IlIclaWX7zNptG2g7B9U4vuiPzVqvzNVKvJlg9zt8
         s+J9bUcDUvm8D5Itg/YxW7HRKPZvr4FwxWMSyCcnJqwZMw3nGhNccXjDohGKjvdQrOt+
         7X8RX4/QOMjMcLL300aoBTR4Q9jhH6r7djpCM7U9dc44Ul0bjTOIOyab0ygzgqHWu/g3
         /goC6QCeJQjV7QMN3QvedAyntonsaSfzV34J2PiqN0FC35e1aPWdJWA1AFvbnZT8D0jV
         pZX8kiQuJ/BvPXzL8SRIF5sa6ozDBpU3EjAAX4UBBiqZiUmPoeJjsqyUmZbaX3b2lqkb
         QiRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TB+DUFEnKNYJXJ7LZxFHnOPKfGyG/Mg3M5rLxoluigk=;
        b=t4p+/f/e61oRBma3erI3DjgoTPd9AB4tyRkAR7V5F3HPuqQ7lEqitTcBbQLueRCKn6
         VcQWNr7VNNm/vU6HMazmwVYBUW4JQMVahu0Lgvmc0MSXgN+M+aWNjjvI3bhQiIHOj0FJ
         TSOaBEuHTpsRlLW1wEqIIxHOEohGBk+4claA1QN3UEw3bIM50t5zHbJOUVFwLfjIi0Gk
         wuiMzANfgiEGnftAFdURyjYu5j34XXnIX4Dgb+HjQNyjMHz+922hl+qUj795XSapxbyU
         n9R4DKwe3IXMo8z9WS9MGQjHlHj2zNrW1znsn4qvokeB9N9EOzTtVbN75hm8HHHE4VTM
         qEPA==
X-Gm-Message-State: AOAM532RhKRR+CYFAJasKDoRhd89DGLEOrExha0auafVcNFJGuY8wFXe
        WUsXJKF1WsPAEjIqUdTM0rs=
X-Google-Smtp-Source: ABdhPJwv+dMDxHi+FmnULoPMfVYEAgPflZ9cis8xNrdMt+tDZDBnPsSoEUhQYueibuKdMi8ERMFbrQ==
X-Received: by 2002:a1c:a145:: with SMTP id k66mr196783wme.177.1603993016660;
        Thu, 29 Oct 2020 10:36:56 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id t4sm852122wmb.20.2020.10.29.10.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 10:36:56 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v5 1/3] kernel: make kcov_common_handle consider the current context
Date:   Thu, 29 Oct 2020 17:36:18 +0000
Message-Id: <20201029173620.2121359-2-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
In-Reply-To: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
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
2.29.1.341.ge80a0c044ae-goog

