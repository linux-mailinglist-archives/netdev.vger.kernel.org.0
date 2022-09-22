Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E585E594B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 05:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiIVDMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 23:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiIVDLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 23:11:37 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C58291D33
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:29 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d82so7924476pfd.10
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8ihjvmU6X32IA3g0n6Ob0CbMhk1X+mcnfaE/5Wfmhd8=;
        b=YKrPYMNBSJFFHg571lPm5+W8CN7DnIcMIRdXREqQlAZ+eLEk9A8maJxy/vrjrQP/eu
         TYffJ29H5vDdp6sidFBvQbhMXABopPXRk6i9GT1lOsVVh5dTUpn3JKlyT+VRKM4PpYM3
         aDSZJo/bWB/q00QaHXbLQBN7xuQW5YNdYkiuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8ihjvmU6X32IA3g0n6Ob0CbMhk1X+mcnfaE/5Wfmhd8=;
        b=SBGP5XdwYF67LvfMAw86Pfu/vs948M6KsX6NenFglrT+wsjfCA/MTj3qy0CQvnP1Rl
         zlPhNo+btxFilASTa5a3mDoA46IP/12BNmvmDstJMTCB0Jo1iwe3Koa1G1prx7xC14r9
         s3czwMzaS/R5hjRWXYBv7RIq/c+GsgGVZT4aBbN13pRq2Mv1WUXFHng70yHKE2wM3p29
         xm3ogfhnOHv6tNYkJQN8gUlyZNOW1Bnoo6C1HieRX+7KWIhlHfWDsQIR1slS+DyqmIwt
         i8n/8paY7TWrI2RWBauvxh75/2P5qaVf51plgDPkrFBAJky989/f4WSXJZa1tqQFHAW6
         bPYQ==
X-Gm-Message-State: ACrzQf2ySHN835EPlHA5q38+A3oU94+Ljcmu9U5CRtyBb/h+vBmZtyGq
        XlZrY8/gKL1zi+xHGLdH9FJJtQ==
X-Google-Smtp-Source: AMsMyM76eF8+VNznj7IzekXG0QSV+my0aV1DgaIJkS6htzHMwsh1R3Wrb+39lk5TYLYW7ESUsWFZBQ==
X-Received: by 2002:a63:e305:0:b0:439:6e0c:f81e with SMTP id f5-20020a63e305000000b004396e0cf81emr1277721pgh.50.1663816228246;
        Wed, 21 Sep 2022 20:10:28 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i62-20020a17090a3dc400b001facf455c91sm2649631pjc.21.2022.09.21.20.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 20:10:26 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: [PATCH 06/12] coredump: Proactively round up to kmalloc bucket size
Date:   Wed, 21 Sep 2022 20:10:07 -0700
Message-Id: <20220922031013.2150682-7-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922031013.2150682-1-keescook@chromium.org>
References: <20220922031013.2150682-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1167; h=from:subject; bh=pDNvsGLyQA8RpBfkkqJxHruRXSdA8gdZalovRqbX85w=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjK9IT/n4E1MQAIRbO7TQnliesxT9vRRUjnB997VqU NfNmMx2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyvSEwAKCRCJcvTf3G3AJv1uD/ 0UeTRzC7PYbrNFpo0erBLhfyq0OXI7KWJPUznMmMf+cAop1hoIyAS6RCvOy3P43EFrYY2LvmcGU3Aj SICc7baXEFvYdMhDJ8d101AolLKruLzinzUGntwccPS2dZe2w/x8T733W5uMnEOoDIW14/zr4IUtRh Vlx7PoTaeYeaEQPZwbWSdxU7qtxeqxD9LsQu+HlBYfR1k5rQ/OwJUa0VLmxQS3VuLxNzcqUFIRrz3E N9wSWjXJ1fpBM5rUyeWWd8dLef4aKwvQUrxvsQ2VWqLB5t57NofX/QpwkS3ypabCJnUg2eUl37eba5 OV6vc8FtBSMSsXXhnZ0qRfqcqAOpIlqc5fvFIq+bl3f4xCiJNeEM7atqS3LN6ZEK9rF9EWiIyjfIU1 rFgqaXZ47QKcNt6D+tThDEVTDgBDzW+/xD6gFm/gAUYLMU55Xrc41oHohWX310hGuJ4uQfMnkpzfJD l7QDNBoaF6Eo/aHjjnO/L/2LHxrNen15gNgss8f3Pbl5cYUEIwKYQTUHz4t+WuflfhJ72ydBaVxPhi nvK5XI8oXLZUTCjvvJ0NvdCQbKmYhFiTddotTbfTvs9VyXcsa4oRA58e65OY4nlgV9+2HJHYaTy3u4 CX+OyRwkHX1tSGbw74SSBv0sSXX5LiEItWNDNN9XJyygxijXQxQ7uWbdLfNg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of discovering the kmalloc bucket size _after_ allocation, round
up proactively so the allocation is explicitly made for the full size,
allowing the compiler to correctly reason about the resulting size of
the buffer through the existing __alloc_size() hint.

Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/coredump.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 9f4aae202109..0894b2c35d98 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -68,7 +68,10 @@ struct core_name {
 
 static int expand_corename(struct core_name *cn, int size)
 {
-	char *corename = krealloc(cn->corename, size, GFP_KERNEL);
+	char *corename;
+
+	size = kmalloc_size_roundup(size);
+	corename = krealloc(cn->corename, size, GFP_KERNEL);
 
 	if (!corename)
 		return -ENOMEM;
@@ -76,7 +79,7 @@ static int expand_corename(struct core_name *cn, int size)
 	if (size > core_name_size) /* racy but harmless */
 		core_name_size = size;
 
-	cn->size = ksize(corename);
+	cn->size = size;
 	cn->corename = corename;
 	return 0;
 }
-- 
2.34.1

