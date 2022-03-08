Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CCE4D18DA
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbiCHNMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347064AbiCHNMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:30 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FCA48E4C;
        Tue,  8 Mar 2022 05:11:23 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id m2so11046567pll.0;
        Tue, 08 Mar 2022 05:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3u3VsA3Fi5wDkVLbct/DeOE8XIO9r5bCMklz39tC+30=;
        b=d3xMfPnSj9DUQxDjtQLyi+itK0WX3JodAeZCw3xPBtkpGMEM+aD8bzj6wZwCzhWcHZ
         kt5w7qKQK3TtStKQ3oT5qOYPzVp+cM1eosOYmB4siu0vBKluYV91Do7HgnXDEzhnVvWj
         /WVDgwGVTkUWcEoOPTIW8t2SQAfmnpXJiVWedbMFSLl9wZeb1olWm/3CDgl9nqVXGaK7
         1l6LV05YKWWBgXJBMIoPk8gJTEYnCZFusR5ixA0BtXVZJAfPp6gJtnzkg3aQPwjfKaqG
         3o+ON2B1FO4YimaKwPZj1bBFt+nJn4+/9+rHZp7yv1OvuJ13QO4UOZGSb9B2++pmQ4vx
         9ALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3u3VsA3Fi5wDkVLbct/DeOE8XIO9r5bCMklz39tC+30=;
        b=LA3uWsLE1HvBLU200/beBDdNvg1cYENKHzlSJ3uLVt9JOI59YrQzRkLHdNRPJ/+RII
         FFHifp477D8PijtZ7+rHiwYA03JiRF9bgOnL0KxTMSMm1/UyO5rnxwE3c9M6Yr9Qs6Lo
         P3GHWscWM7QaX/bbYTSwrl9IBFkbSf3OSAEucXqlZLdZ45S0rYLN4fTYRPlHvd10sveL
         ebYgtcAKIIHbup7iDA4bzOryRXQgqcNFR1l4vGCEN8JOo2OuqrGeDD4kAgFoXrS0D+Er
         wrsK+6R2Bo9tNyW5NzNTubdrQVgC4Aph8SSuAkpbNChKWoQCGJ8rgejxqtQyM0Is+4Ny
         5uag==
X-Gm-Message-State: AOAM531iKbNTYPgm8Zdu4pKldvBXhVUrw4hjqbT18yEL2WAF4N/YcNxI
        zOdm8Tk5/tp7EP2ClNjrsRo=
X-Google-Smtp-Source: ABdhPJzwC/En9lunCH8+wURsQQ1/FmGWLsc3MnOR1uRl1atGtzR7v2u8iVEpo0GJyAqsYIshW6NEaQ==
X-Received: by 2002:a17:902:f68f:b0:151:fbf5:db45 with SMTP id l15-20020a170902f68f00b00151fbf5db45mr4536477plg.60.1646745082822;
        Tue, 08 Mar 2022 05:11:22 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:22 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        guro@fb.com
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 6/9] bpf: add a helper to find map by id
Date:   Tue,  8 Mar 2022 13:10:53 +0000
Message-Id: <20220308131056.6732-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308131056.6732-1-laoar.shao@gmail.com>
References: <20220308131056.6732-1-laoar.shao@gmail.com>
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

A new helper bpf_map_idr_find() is introduced for later use.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/syscall.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 3b50fcb..68fea3b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3474,6 +3474,21 @@ static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
 	return fd;
 }
 
+static struct bpf_map *bpf_map_idr_find(unsigned long id)
+{
+	void *map;
+
+	spin_lock_bh(&map_idr_lock);
+	map = idr_find(&map_idr, id);
+	if (map)
+		map = __bpf_map_inc_not_zero(map, true);
+	else
+		map = ERR_PTR(-ENOENT);
+	spin_unlock_bh(&map_idr_lock);
+
+	return map;
+}
+
 #define BPF_MAP_GET_FD_BY_ID_LAST_FIELD open_flags
 
 static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
@@ -3494,14 +3509,7 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
 	if (f_flags < 0)
 		return f_flags;
 
-	spin_lock_bh(&map_idr_lock);
-	map = idr_find(&map_idr, id);
-	if (map)
-		map = __bpf_map_inc_not_zero(map, true);
-	else
-		map = ERR_PTR(-ENOENT);
-	spin_unlock_bh(&map_idr_lock);
-
+	map = bpf_map_idr_find(id);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
 
-- 
1.8.3.1

