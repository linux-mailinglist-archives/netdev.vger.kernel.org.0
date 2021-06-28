Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757073B6B53
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbhF1X1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbhF1X1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 19:27:16 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18237C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:24:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id l24so382885edr.11
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 16:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=2k16VreGlb0/o0N+zmbY+GmliwSFX9zafv1cD1flMTw=;
        b=I0/8CKu1r3M+S9dhlXB6ZuAayinoekfIC8FdfKhCxK3/fhZJu1hoaFyNaNO+CJnTCC
         Z1LD0BIyU2q3yHKZ+pzBi8AnJEToWFcjIVFpwx1LXz5k4ZxjAfLvVTbDs1oyk8+sudAi
         DTOlrBqhQL3SYycop7tiEnUrDe/Cos9J6zl+5yBClGtQWixkden8GZnPdhaUoXpi9GQI
         zRtAa8grRTTrkTgv4FXx8mZ8KCYFjTitJ1LbERoldAKFiLmbRsVX/JD16hYD8oIPcOj2
         xMsFncN92IimTFnkbzmC6ebsBCquc/uqb0KAI1cbdU/6iZuz3Kk2GfDjWPgiLnfmN3pW
         yFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=2k16VreGlb0/o0N+zmbY+GmliwSFX9zafv1cD1flMTw=;
        b=YP8xTOpVwXzWfy8QQH8+Jj16sU+K7t/Q3ftkwcYnmUDWaY7bl4k6oVzcF6aJyyQTwk
         NcZ9TLLbjJ3p2nCI0vnDYMWNKRqCo+YAbYsYYrpD35+fjXTn70BN45Cjz6eJst7e772K
         cNdEYUhdfcuJCrKAeWlyeATaz3l3iwEpLLTgjRXH4RQ8mQX1sanz8pjMljNlvDQsZAfW
         ESkYo+0Eg1xNBUy4pleZq+KnwJZDZkSxrUP6/nnb4txwfKD9WdoPMWDHivNdFUhzu/8X
         v5HkEl9e69TQRYgxioQbA9euFwPQc/0SCyDXomYdmrFJ8j2wgQKUNhRV1vn369O8kzpc
         kSfA==
X-Gm-Message-State: AOAM5305HWzKAXZxhY+dLULQYHt0CB3VGKtnvfOEicmZ+h4+t1GTdxH7
        SOgGVGY/dpC5nH1V0KHN+MtiovX9unu6qg==
X-Google-Smtp-Source: ABdhPJzYt4gdth1N1tyVzVzz+yZV76ydDAN6K9uJlrVvKIO/rLFQ4vn1yjRJm5eN6A8/wkIQE2A0lQ==
X-Received: by 2002:a05:6402:49a:: with SMTP id k26mr36133613edv.279.1624922688583;
        Mon, 28 Jun 2021 16:24:48 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id p19sm10131276edr.73.2021.06.28.16.24.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 16:24:48 -0700 (PDT)
Date:   Tue, 29 Jun 2021 01:24:46 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 1/2] utils: Fix BIT() to support up to 64 bits on
 all architectures
Message-ID: <20210628232446.GA1443@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink and vdpa use BIT() together with 64-bit flag fields.  devlink
is already using bit numbers greater than 31 and so does not work
correctly on 32-bit architectures.

Fix this by making BIT() use uint64_t instead of unsigned long.

Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 include/utils.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index 187444d5..70db9f60 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <stdbool.h>
 #include <time.h>
+#include <stdint.h>
 
 #ifdef HAVE_LIBBSD
 #include <bsd/string.h>
@@ -264,7 +265,7 @@ void print_nlmsg_timestamp(FILE *fp, const struct nlmsghdr *n);
 unsigned int print_name_and_link(const char *fmt,
 				 const char *name, struct rtattr *tb[]);
 
-#define BIT(nr)                 (1UL << (nr))
+#define BIT(nr)                 (UINT64_C(1) << (nr))
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
-- 
2.20.1

