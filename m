Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9712649C2E6
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 06:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiAZFEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 00:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiAZFEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 00:04:47 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01946C061748
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 21:04:46 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so5092470pja.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 21:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jf1uLBjki4K7jOvn/YnWyQnOsAzyavSVcBTDjzhWZVk=;
        b=s7zMJJFXWLUbfFvY366952O0Q+8AFj8b7golOj4f4DUT2Ig3S/Ux7+A/xPSsSayUK3
         s/ClbYRwLtCtL61JcvR+QDFmmYqqKMnfjAW6eKUrgerAzsRMNxqqJmQlX78Yz+UsrjTf
         SuCxCxb3zsywUvXYpmYrai+fOh9GnBqo8MRY7o+5p4x8p7qyF/FrtAxlnr/leRgymrlV
         /pcn9Y+bBBoP8Ma39k9fXyYMNPWYxLnDUjhnI7TD3qKagJ8bhT/3vBNPWhPvVcvcl4tA
         vlEilOw8pkcnnpkWEsoVIB0wCi9SrL5mWCUv0JV7DybEm+ikDSbXAdDMxXEYJiCBebIr
         PjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jf1uLBjki4K7jOvn/YnWyQnOsAzyavSVcBTDjzhWZVk=;
        b=cM7W+1i45dDWgfLW1ZZzTC3E+RmrPG1TJu4et1wfqX+oshMRSXUYlEtO6tZ/F9Bdtx
         9FJhWEVMZ1Gwn/M+doFPyJze7g1JTg6y7SlmnOfaSvBkrWNkQYYv5/BE8TD1xmyAPpmw
         NrDfWdvhcO+jejnA8OJcGhCJqpBe6N5k1ID61h0QkIVoBTnqRvzR34TtH1HpmBwgq/Pn
         TKUCd+c0/yQbv6QnLT31K26JXnKKjUNdZVHE95OoXv1iPGsILiC8ZOaufCK8293fHWsy
         /34YEalEz9uS7DMSOPgkPZHdzqGpVZqd0IMfLagfvz3Qauy28tDtat4uM65jHoMKf6VM
         d7pA==
X-Gm-Message-State: AOAM532Ut8iIYFlR0HM6kLP8680suWEqoy3XnxGd1jU6zxgZn+WvdkyH
        X8pkBTPPHGHKpftqLjVt98ouMg==
X-Google-Smtp-Source: ABdhPJwOVq35me3v2iCUelV0LLrjYA8ON0acuAtFss/NFZas9ZGWW4ak4OsMA0sStDAr/pWhdhWgtA==
X-Received: by 2002:a17:90b:1108:: with SMTP id gi8mr7106811pjb.222.1643173486376;
        Tue, 25 Jan 2022 21:04:46 -0800 (PST)
Received: from localhost ([134.195.101.46])
        by smtp.gmail.com with ESMTPSA id nm14sm1894531pjb.32.2022.01.25.21.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 21:04:45 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH net v3 2/2] connector/cn_proc: Use task_is_in_init_pid_ns()
Date:   Wed, 26 Jan 2022 13:04:27 +0800
Message-Id: <20220126050427.605628-3-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126050427.605628-1-leo.yan@linaro.org>
References: <20220126050427.605628-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces open code with task_is_in_init_pid_ns() to check if
a task is in root PID namespace.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Balbir Singh <bsingharora@gmail.com>
---
 drivers/connector/cn_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 646ad385e490..ccac1c453080 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -358,7 +358,7 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	 * other namespaces.
 	 */
 	if ((current_user_ns() != &init_user_ns) ||
-	    (task_active_pid_ns(current) != &init_pid_ns))
+	    !task_is_in_init_pid_ns(current))
 		return;
 
 	/* Can only change if privileged. */
-- 
2.25.1

