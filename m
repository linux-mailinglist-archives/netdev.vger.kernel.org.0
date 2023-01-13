Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC57766A720
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjAMXcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjAMXcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:32:02 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCE07A921
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:32:00 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id a184so17266011pfa.9
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Dg4fasa0/U26smnds+ADiRBUO7JOWwps5o7mm7SQok=;
        b=cCKnXJeBK3fkhDRhPY/1LWbH2+zn1n6zLXtesgFQ3Hq0sB1M4FCmH7V/dRGwqzt9Q7
         G/q9YpzozbpCliDrPjxbuFlALZ1NK8ZMKqMdJYYVBIifB+8Py+v8n+AMVT1rxNrTDqUp
         YfnOWFZhBpPriMUTwUL4fEBR0TRBzf/k5YFERWVmHYQXeK51xBwRtPlfu+vUNP5Rbmay
         zVsqi0TTZhtN2oUz9QLdzf+m4Ogrcy2b7nf3GwWNGsbp88AZ+ybxO+RBZu5HBlGu+ccd
         viMisacXNqEv6w/yaDE6WiDKnmz/DyCQ7EdLHDF0J40SPGdN0LpqyZpZTU0It4pSBkhG
         40lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Dg4fasa0/U26smnds+ADiRBUO7JOWwps5o7mm7SQok=;
        b=PWdd6mDbqiI7+ojOF3a8yBHriMTAzKAQKq6oAGHOUFII1EIoU94p2mB9dz0eArbiLR
         aObXt7lrXYK7YYUHmnJ7BRgWbe1YvsIx311poFHVyQYLz/O/De4FmKZOhYZwh7usRJKI
         QmNU5g0Up92xlnSg7vZSQW4hPT90aXjb1YS63vOXOQOgE0JPDXlMH1OgX63rqVGx5n2C
         1nCEmHA+Q/EPrlonE7fmnZB3yGmZYo7Z1BJoGBgJVz8Nu8xZzVeOX/8DsID9Uc2+bHBI
         guim7ttVPNAa07Jr1HSf0kuCvNPTj4XGGiX7/JG5oO7qcJa5r69EDV6R9/B+7E94ZOTk
         RFDw==
X-Gm-Message-State: AFqh2kp3yuf00IZSnYFQRfXwyNW/XxvbNDQDLEp0/YS9/7T999604FC0
        MF6d1T4w8ejbNbS4e9a2jIr+5zj2jM0=
X-Google-Smtp-Source: AMrXdXvuwjJcW39+oi9HlAOY874IRAsfJyMZ8+ulQwTZe1ryOh0TUswN+BF2O0ErtKyhWeSaDpeBew==
X-Received: by 2002:a05:6a00:2a9:b0:588:89bc:7f75 with SMTP id q9-20020a056a0002a900b0058889bc7f75mr19772005pfs.1.1673652719107;
        Fri, 13 Jan 2023 15:31:59 -0800 (PST)
Received: from localhost.localdomain (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79624000000b0056bd1bf4243sm14253244pfg.53.2023.01.13.15.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 15:31:58 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool 3/3] marvell.c: Fix build with musl-libc
Date:   Fri, 13 Jan 2023 15:31:48 -0800
Message-Id: <20230113233148.235543-4-f.fainelli@gmail.com>
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

After commit 1fa60003a8b8 ("misc: header includes cleanup") we stopped
including net/if.h which resolved the proper defines to pull in
sys/types.h and provide a definition for u_int32_t. With musl-libc we
need to define _GNU_SOURCE to ensure that sys/types.h does provide a
definition for u_int32_t.

Fixes: 1fa60003a8b8 ("misc: header includes cleanup")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/marvell.c b/marvell.c
index d3d570e4d4ad..be2fc36b8fc5 100644
--- a/marvell.c
+++ b/marvell.c
@@ -6,7 +6,7 @@
  */
 
 #include <stdio.h>
-
+#define _GNU_SOURCE
 #include "internal.h"
 
 static void dump_addr(int n, const u8 *a)
-- 
2.34.1

