Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F35C288F84
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390131AbgJIRC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390077AbgJIRCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:02:17 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D0FC0613D2;
        Fri,  9 Oct 2020 10:02:16 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i1so4904424wro.1;
        Fri, 09 Oct 2020 10:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mKF6JhtMIXBsKg0vHpcDdJeueS/mg2O52LZjELoH3og=;
        b=lFxqgpOmRGHdJEcIJAP7v12BeUXTlgAorPjZm6ANUJElw+zBAqqbkcFa+2TZkniPEp
         fMAvNxJQ7JagxpamezJva6YZzOW+UM75fknUtzV0Q2bhjgINro8XeWpJjVFSzJ5rZS/F
         pGllLlrAH/ecJBevhah+9KsCqSAjPmamruOi3fiW+ujkRqhVdmcF9+U5R7DwSJAG87Em
         sGeldnzNWiZEyHnfdqj6yuIR0xmtct18EKrJfg6CM4b3EvpIMOU+gCLTPnO/ZEXfXM3u
         9dWl6Gl7gcE6xWCF+UnhK0B5fZz5oNAKh1AEBLrxIhX1OBumVR5/yOxT8hgaQiW5JTht
         uMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mKF6JhtMIXBsKg0vHpcDdJeueS/mg2O52LZjELoH3og=;
        b=rBOwyfwqxcwG50c2WKHNvhx2nIqg5YvgGakyzbXcGmmJbm94Fkn4GV3Mq9OTg2m+ld
         22reIYPP215h0yWIwGH15fY3f8+adiOfpRHyfO4IVuVw1fn4mqJByrTmFCvy3Vs7TNX7
         KK7w7z80vVhDKoYd0yoCFp2NyPggkM5315YQRR0qbaC7S7zK0VK4sqsvVXe51PfPw8lI
         aaDmRoUUekKDyAM8rHSB6nvqVwUaByHhGlO+mugNJ9sQULXZ0FtVhANAd+QwWq0liqEt
         kt7PaQoRgsmnmho0aDWJrff1y2qppTvH4RWMVRPAJN9rMM3aRqgPy+OyXAvWlBjMEh8g
         eLvQ==
X-Gm-Message-State: AOAM530kH3Pjh9TG9bMzKsBaRAehyIIunu2SWVH1UJwqZrAnmtS5529A
        br7A5km6drsV4xBVNFWwgws=
X-Google-Smtp-Source: ABdhPJzTbbRyOrhoR4rqhttREvHmMOpgUTTng6NhSXCOuxloTMcVE4NdZDC1+VEJXMHSY6i+XN98ZQ==
X-Received: by 2002:adf:e741:: with SMTP id c1mr3975317wrn.16.1602262934750;
        Fri, 09 Oct 2020 10:02:14 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id s6sm13211092wrg.92.2020.10.09.10.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:02:14 -0700 (PDT)
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Subject: [PATCH v2 1/3] kernel: make kcov_common_handle consider the current context
Date:   Fri,  9 Oct 2020 17:02:00 +0000
Message-Id: <20201009170202.103512-2-a.nogikh@gmail.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
In-Reply-To: <20201009170202.103512-1-a.nogikh@gmail.com>
References: <20201009170202.103512-1-a.nogikh@gmail.com>
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

Presently, if kcov_common_handle is called in a hard IRQ context, it
will return a handle for the interrupted process. This may lead to
unreliable and incorrect coverage collection.

Adjust the behavior of kcov_common_handle in the following way. If it
is called in a task context, return the common handle for the
currently running task. Otherwise, return 0. It will make the returned
value more reliable and also will make it possible to use
kcov_remote_handle in routines that can be called from any context.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
---
v2:
* Added this patch to the series.
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
2.28.0.1011.ga647a8990f-goog

