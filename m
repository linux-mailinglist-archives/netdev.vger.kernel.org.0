Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC5C49C2E5
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 06:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiAZFEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 00:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiAZFEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 00:04:44 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E70C06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 21:04:44 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l24-20020a17090aec1800b001b55738f633so2466767pjy.1
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 21:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LymW6PUOvmHHk0t/aZG7OwTx34gGDOgM/8aOiJBjMoY=;
        b=bCNMubob4uLUgkxduJa6dIISrtOZ9XCo5RHxWYcZMNmh9pQo8A6uQxpVV3R4o+drU9
         JxYbJEbmewq86YNgOJho3goihYXnv1gQQEOy80l1ECYHbgg60gU+zr7FoqJqhNw4N4hV
         6Eanz0hNrYke+w+ea28Rg/X3qiKD5TdtStq7S3Wv96MPycCk+YzD9P2wUx0hXuMH53z9
         E4kubKpoVBlneakaLfX7JqFChA7PN64aSMwc55HRaS91vuAtnBgY9h3uKmnOeut0YQeu
         JU4pwvPFjSe31pkC47oSrDQFpnr78TYr7rkGzB+WhvdYFDsIorbKQqienIuE3RgFCpnl
         pNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LymW6PUOvmHHk0t/aZG7OwTx34gGDOgM/8aOiJBjMoY=;
        b=rRzsMGGOW3oDV9nM8Wn7QvEz1Eg5sMnHUJL+uF7iW5XPz6i3k17iYDe02VjmKjnHkS
         T+Wulm6tyzNu0+Ie06j/3MR1jNTfYXdNgsk/n0Sy3fjh4GmqjQg5i7vM9xNMM/4EHxxC
         EX7j1ECvmjLmlsU3eRvAPRELwPjnxbJLUXBuxn1G0XD6Y5HwIfn3eM7wJzMA8f7LscpV
         zM8Ltf4M1apjxciICBjDgUNuPxNq4TpbqcYd4D7iPwNH33zfwts/Gz0jvJ+MtDst9VJc
         UkUAquOy9qacNdC9VWcOrbBHdeGgjiHdLGSmlLUlvw/7ia6lYUlp/YdveqK7hQp9soBo
         /BwA==
X-Gm-Message-State: AOAM532oDMbkhvDg8cmyY+2kf2I9gV9usSr7hzN62fHtjzfy2Gu0ucFX
        WK9RbxFaszArupv9B7q/nyZa/w==
X-Google-Smtp-Source: ABdhPJwJmbw+cC52lHR4HHf99/ag6oVQGs3up2giyXNZXQAanzfb+0gwg2JhZ2zXwgsfpBZqorwobg==
X-Received: by 2002:a17:90b:3ec4:: with SMTP id rm4mr7011825pjb.120.1643173483499;
        Tue, 25 Jan 2022 21:04:43 -0800 (PST)
Received: from localhost ([134.195.101.46])
        by smtp.gmail.com with ESMTPSA id a13sm665441pfv.97.2022.01.25.21.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 21:04:43 -0800 (PST)
From:   Leo Yan <leo.yan@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>, Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net v3 1/2] pid: Introduce helper task_is_in_init_pid_ns()
Date:   Wed, 26 Jan 2022 13:04:26 +0800
Message-Id: <20220126050427.605628-2-leo.yan@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126050427.605628-1-leo.yan@linaro.org>
References: <20220126050427.605628-1-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the kernel uses open code in multiple places to check if a
task is in the root PID namespace with the kind of format:

  if (task_active_pid_ns(current) == &init_pid_ns)
      do_something();

This patch creates a new helper function, task_is_in_init_pid_ns(), it
returns true if a passed task is in the root PID namespace, otherwise
returns false.  So it will be used to replace open codes.

Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
---
 include/linux/pid_namespace.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 7c7e627503d2..07481bb87d4e 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -86,4 +86,9 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pid_idr_init(void);
 
+static inline bool task_is_in_init_pid_ns(struct task_struct *tsk)
+{
+	return task_active_pid_ns(tsk) == &init_pid_ns;
+}
+
 #endif /* _LINUX_PID_NS_H */
-- 
2.25.1

