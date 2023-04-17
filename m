Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A3B6E4227
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 10:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjDQIIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 04:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjDQIIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 04:08:35 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAB04C20
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 01:08:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y6so23687192plp.2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 01:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681718889; x=1684310889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hr7bhkX+Epn2YWYx/+oT337obKjgENzwcgRHzhBp9VI=;
        b=bJXY+7hDuLaSpYXxwM/yztjf06sBYybcq8xuD8cBmDItLAyd9PmLi0XpAUmOy6xHv+
         dpbs4n5YrNyNLE6256NVjkOrdAV6ktoGBOmDZ9w7UHcKgAIC3bNX800RYlnF+U6pPF5d
         m21gfVGUIQGEEs5qowWSv8XTYGM8zmGWtv7OcI8aqDLWt1uQ5wboTfo0EHtda091FaMw
         6iUnxdRbHa9aD3jdgBxyNYqLNz1cG0soqrHKFcaTf2LvRmOHyJ/96GhZ3Rzurl4r7P1p
         jipg6Ig8ym6ndYHYqs4TO55xszkUOh8WKQYAKfRyxwSrUHA7J+aT64DOXYKx+0vk10q/
         DqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681718889; x=1684310889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hr7bhkX+Epn2YWYx/+oT337obKjgENzwcgRHzhBp9VI=;
        b=lBYODtJJafTidgD4fbcpWdIMFXCWpF22FmlxmdxD6fAgezPw6ZFH3viNkcPw7n6Pp+
         Y/b7Z90w4tcU8JWkOyYbphZ2rfM/pPgMWCH3WIHLRS6eKw3gcK2Ri92I/xKuijSvyZeH
         nM/aWCwOfO8B7rDE5oWm/+k1XMuFicx3HG3rLe+R4q8jh95qSxvXTjGW46Kkx7xKadmM
         82p88D/M9QA8fnr8QGy81tPnTxtBmQu4vah27Fqv8+4Hcj2d+4uUe1iGCqqQMT5uw6Y0
         PRGQjbqhcX4GuGVTTAm/h9UIRqNyLUNJeI24AYeHu0z1MQVZAiXGYTaepBYWqzfJNKSP
         6c5w==
X-Gm-Message-State: AAQBX9d/fkxKXyaeTSkuB1R4gM54Lxhn1YEKg5BIewHZjG328H+n+hsa
        PfXaqu724tXkLi8/hIh6K5Pxyw==
X-Google-Smtp-Source: AKy350Y3sXXM1tDYSIZfPXRNb03tgaugGTrcsfNudlJlHZ3NSLoFefzqTDUv758I0MgQ0K4KVNT24g==
X-Received: by 2002:a17:902:db09:b0:19e:6cb9:4c8f with SMTP id m9-20020a170902db0900b0019e6cb94c8fmr15803413plx.41.1681718889687;
        Mon, 17 Apr 2023 01:08:09 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b0019a97a4324dsm7114135plb.5.2023.04.17.01.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 01:08:09 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com,
        zhouchengming@bytedance.com, zhoufeng.zf@bytedance.com
Subject: [PATCH 1/2] bpf: support access variable length array of integer type
Date:   Mon, 17 Apr 2023 16:07:48 +0800
Message-Id: <20230417080749.39074-2-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230417080749.39074-1-zhoufeng.zf@bytedance.com>
References: <20230417080749.39074-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

After this commit:
bpf: Support variable length array in tracing programs (9c5f8a1008a1)
Trace programs can access variable length array, but for structure
type. This patch adds support for integer type.

Example:
Hook load_balance
struct sched_domain {
	...
	unsigned long span[];
}

The access: sd->span[0].

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 kernel/bpf/btf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 027f9f8a3551..a0887ee44e89 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6157,11 +6157,13 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 		if (off < moff)
 			goto error;
 
-		/* Only allow structure for now, can be relaxed for
-		 * other types later.
-		 */
+		/* allow structure and integer */
 		t = btf_type_skip_modifiers(btf, array_elem->type,
 					    NULL);
+
+		if (btf_type_is_int(t))
+			return WALK_SCALAR;
+
 		if (!btf_type_is_struct(t))
 			goto error;
 
-- 
2.20.1

