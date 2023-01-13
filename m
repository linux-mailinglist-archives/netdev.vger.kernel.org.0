Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B28C66A71C
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjAMXb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjAMXb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:31:58 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299527C38A
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:31:57 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id z4-20020a17090a170400b00226d331390cso25883442pjd.5
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gUiOmYdAClhjr1lYOJkvhtLcFTPeC3S9Jm8rvtXuGbI=;
        b=Un45TgMGUkP8HDrkGZGpora+qJTydHAp60L9DGesJJux56CdHL0PxZ6voj/2MfW3/7
         pXuDiFbBnE6Z03/bXyOHzaNvCk+k0FfpYdA2rmVc+OfIzEV374mp2FT7gqYrN4K9yyy7
         RThvzVrSPRSx2UgZHbifnQdkvNGe48WDFF/+5nqvv9uUGVzEQyod/UxnH2Z9s6lsfyAi
         c+Ll5k82ecz+4HyXviugQG3btTfNJ12uWBkP0Of0ATAo2kxNX7Zc+1TL5BFol34YyuxM
         RjQ9TEl5+An09uOVQljP0bZAeM+7ZakaTVO5j1TgeB0NQxg85ZTzh9kY50oVEI1E12V2
         ZxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gUiOmYdAClhjr1lYOJkvhtLcFTPeC3S9Jm8rvtXuGbI=;
        b=f8dkOrj5YfLoeuO/PAJOWneG6ykogQvToI/WGv0Jznw+T1YdFyYvXfWu77wet381Zz
         hjbYA5Ss8gYZbgJGY9n96OxZguOhfVH8ILoz5m3NtKqKJymYB2RqO5hG0P7CS5mL5YfV
         k167iWM3v7O7RAeLRTb9JYoabrSCPJ3z93la3wwXf2cMxHWC+s92i8tR1BNJwfC/Qoxo
         rNZQviPpUoHub5Q6rQDx44DCa7gltpMcmJsfdZKitIFPkTgRp+orv0g3kukLJUZplOAk
         nYgrqiGd8f2GnKKKqvN9y2qdxqTWjiUSaPMVfgvgYAJv+IAt4rvUu5XfiLVS4svWQeXG
         ME3A==
X-Gm-Message-State: AFqh2kp2IzQYnFkxDAEi/5nN+yIshtl4V/t762aWvNYjr7W+jiouux+j
        tdIrkjFZhs8fn4quq3jOI01krRHgTpQ=
X-Google-Smtp-Source: AMrXdXtzsnrVSkGTEGH50CTxTlurBH29u0x5dvIsUSYHOOW9N3TOdjhn3lK8fM29MJRvBQXIUYjVOA==
X-Received: by 2002:a05:6a20:3945:b0:b3:5196:9505 with SMTP id r5-20020a056a20394500b000b351969505mr90534537pzg.30.1673652716226;
        Fri, 13 Jan 2023 15:31:56 -0800 (PST)
Received: from localhost.localdomain (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79624000000b0056bd1bf4243sm14253244pfg.53.2023.01.13.15.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 15:31:55 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Markus Mayer <mmayer@broadcom.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool 1/3] misc: Fix build with kernel headers < v4.11
Date:   Fri, 13 Jan 2023 15:31:46 -0800
Message-Id: <20230113233148.235543-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113233148.235543-1-f.fainelli@gmail.com>
References: <20230113233148.235543-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all toolchain kernel headers may contain upstream commit
2618be7dccf8739b89e1906b64bd8d551af351e6 ("uapi: fix linux/if.h
userspace compilation errors") which is included in v4.11 and onwards.
Err on the side of caution by including sys/socket.h ahead of including
linux/if.h.

Fixes: 1fa60003a8b8 ("misc: header includes cleanup")
Reported-by: Markus Mayer <mmayer@broadcom.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/internal.h b/internal.h
index b80f77afa4c0..f7aaaf5229f4 100644
--- a/internal.h
+++ b/internal.h
@@ -21,6 +21,7 @@
 #include <unistd.h>
 #include <endian.h>
 #include <sys/ioctl.h>
+#include <sys/socket.h>
 #include <linux/if.h>
 
 #include "json_writer.h"
-- 
2.34.1

