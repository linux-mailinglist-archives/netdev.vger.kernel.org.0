Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF3A53357A
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243697AbiEYCwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243695AbiEYCwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:52:03 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB3415FCB
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:52:01 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id g21so7643237qtg.5
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JnonedHAdyfrX6TlDYWWRsxrhqD0olRWt8hKAYQiBw4=;
        b=RU6PGyhlGpPWWmLnMkqPUQ33LO9k0IsN++A+KejvbwD/4mXXEMPMk0xw62u0Zf9bo8
         oYjdzTmdaZFmhiAKmeIcb9EH32LHZV1OIeAy/81TkSEIKwUcDCPNgXTRqVr5Y/J+M8iq
         xrp04NcMfTkzYoQ6WSj6VZWJZzHlYKS7j5hNk6LlZ6PAGO4QrblN/0mIrF17JK/PAK9g
         vqOn8LJO7klGjmD22bKGqKVLTSnNOJ097zA8+xzEQF8BInYUOHJbHHGS3rGC2mPKlPEw
         0dX9eHJ5L2/JbivSpcPdT4N7NeVTZHIUXUYSxBf+kPdfk90fqe6M85hd4cQcDh0nH/cn
         gWag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JnonedHAdyfrX6TlDYWWRsxrhqD0olRWt8hKAYQiBw4=;
        b=HoYiX0GYxIWUQGQHXUSJnWMsQbsXDuNob8UNKj11pnVLP4hlNs3AIxW4WA6IyXLDo8
         O8fZn+en3hx1h5KSuZTxW+9gbOO9Bxp641h3fVP5FbS/g+WQNXZq+Ua77dLAn/WoqQuJ
         DOl2058bUFlqrxqNnaZseUQ7jOGBVSDujuKkLguQIIAhKYxUQQzCr3yQPuCyNdpLQGg1
         dlLjzY1hr076zR4/uvdpdrJ7nZ6p+NxFcJO/AEi/txGptv/7VWzNjtGk5mQwQM79kk2S
         ASdAus8j6h7gmxTDhDU6f1pDcqbOmBXlT21k8WGR9CwGyYqdgy0FSA4IO6ffpQBtWct3
         i/0Q==
X-Gm-Message-State: AOAM5311Wfb0HVhLHj5wpc/Nmn1Jn5T4nQ8uE/l+7bzdr+mfebJIBDkO
        VUgUwq0VPKl+UBMt5nD0kQ==
X-Google-Smtp-Source: ABdhPJwsLd/XFa+rFLXkkbwAaunxLIj0vnIcptuJVogADJJnDO7fi1x5oIYl/zscsCp8JnS3SlhnMw==
X-Received: by 2002:a05:622a:15c8:b0:2f3:d7ae:bae6 with SMTP id d8-20020a05622a15c800b002f3d7aebae6mr23023325qty.106.1653447120539;
        Tue, 24 May 2022 19:52:00 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id z193-20020a3765ca000000b0069fc13ce207sm542314qkb.56.2022.05.24.19.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 19:52:00 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next 1/7] ss: Use assignment-suppression character in sscanf()
Date:   Tue, 24 May 2022 19:51:48 -0700
Message-Id: <5f0a2388e77ae0388a92505c0a24b4e9d00570fb.1653446538.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653446538.git.peilin.ye@bytedance.com>
References: <cover.1653446538.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Use the '*' assignment-suppression character, instead of an
inappropriately named temporary variable.

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 misc/ss.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 4b3ca9c4e86b..aa9da7e45e53 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -621,9 +621,8 @@ static void user_ent_hash_build(void)
 		char *p;
 		int pid, pos;
 		DIR *dir1;
-		char crap;
 
-		if (sscanf(d->d_name, "%d%c", &pid, &crap) != 1)
+		if (sscanf(d->d_name, "%d%*c", &pid) != 1)
 			continue;
 
 		if (getpidcon(pid, &pid_context) != 0)
@@ -647,7 +646,7 @@ static void user_ent_hash_build(void)
 			ssize_t link_len;
 			char tmp[1024];
 
-			if (sscanf(d1->d_name, "%d%c", &fd, &crap) != 1)
+			if (sscanf(d1->d_name, "%d%*c", &fd) != 1)
 				continue;
 
 			snprintf(name+pos, sizeof(name) - pos, "%d", fd);
-- 
2.20.1

