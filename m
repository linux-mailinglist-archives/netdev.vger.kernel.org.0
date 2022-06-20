Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA7655152B
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiFTKD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240821AbiFTKCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:02:53 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9B8265D;
        Mon, 20 Jun 2022 03:02:52 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id u37so9779381pfg.3;
        Mon, 20 Jun 2022 03:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bpfZ/kYo7akCRG3R46WmbFjXJuTRk2P19UNZKT2W+CY=;
        b=GIJbtJWy0EkRqQ5Wo8Ij7IWK47z8TDBPFMPnoHQGbGD2EpAKUocGqFHef/JamYJc8D
         XA3iKG+kepUG+2B9rjjWileafUhosulHE155BEsnh6vpdNWRlFDqODduyKNrIlxDDteV
         yzgyR0SEgzk/OTTi7Au0CYIDDCGwXvarlIMCEZHz9GDoaVO/Onpbe8cmjBccMgRL5N4V
         7xWslV7xPSqJzCMhAxNPpWYCbA+l5x2skf/Bc2W6724F6lRx2veg/SNWuh/mOuJ980Mr
         Uw6DIMRFCJPQnJj4sDEe7FzSReZWUr8YROLcy9Vdyon7AAQskRqE6tSoDJaEpmZ4ehc+
         C9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bpfZ/kYo7akCRG3R46WmbFjXJuTRk2P19UNZKT2W+CY=;
        b=DbXy5Dc1QcIzJFHZ8idwu9eqWfgaMRFK3SpjKTIsbaz3Ft5xS2v6vOrGIffaN4HEZI
         fEKYpBpgbc7f8A18t9g8hY1leEziArQZ2Z/3MzEKWJtaYK8V3ROJHeJ/8BAOgHmT3Azc
         nGBRt9h+NHeR54JL9C79dJLp80pMq4LPnYTswvOIzBkEhOgkWQ1jKbHKdrpcvnfX6j9K
         DmcYntSf/KunugfAXzJGSUPE2u38JrDq9ate85otWOMYFIQB74ds95KcDlKLoepBUL6T
         s+S5d8PftznmDM+aVvAx2UTAdxpJgn7XgYp1WdIDeXoq0Lb7odwWevBdTjJ9bcZZiMxL
         g65g==
X-Gm-Message-State: AJIora/RuXqprKCQvM+9V2p3VrJvaIuryZY4ZPXFnaUW0m8z54t138ri
        dTh8/S5DSiLqiJK+pqLB/iDnmbuU0IiyM6al
X-Google-Smtp-Source: AGRyM1uIZZ/N3u1c3wCPbZ8U+wpCgO9AkAqhO+btuKzCy2ZGLybOVqHxKWYlIz4BJA9psC9OKyb5CQ==
X-Received: by 2002:a05:6a00:1a4a:b0:518:bbd5:3c1d with SMTP id h10-20020a056a001a4a00b00518bbd53c1dmr23728781pfv.64.1655719371441;
        Mon, 20 Jun 2022 03:02:51 -0700 (PDT)
Received: from C02FG34WMD6R.bytedance.net ([139.177.225.236])
        by smtp.gmail.com with ESMTPSA id bj24-20020a056a00319800b0050dc76281ddsm8481679pfb.183.2022.06.20.03.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 03:02:51 -0700 (PDT)
From:   wuchi <wuchi.zero@gmail.com>
To:     mhiramat@kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] lib/error-inject: Traverse list with mutex
Date:   Mon, 20 Jun 2022 18:02:44 +0800
Message-Id: <20220620100244.82896-1-wuchi.zero@gmail.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
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

Traversing list without mutex in get_injectable_error_type will
race with the following code:
    list_del_init(&ent->list)
    kfree(ent)
in module_unload_ei_list. So fix that.

Signed-off-by: wuchi <wuchi.zero@gmail.com>
---
 lib/error-inject.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/lib/error-inject.c b/lib/error-inject.c
index 4a4f1278c419..1afca1b1cdea 100644
--- a/lib/error-inject.c
+++ b/lib/error-inject.c
@@ -40,12 +40,18 @@ bool within_error_injection_list(unsigned long addr)
 int get_injectable_error_type(unsigned long addr)
 {
 	struct ei_entry *ent;
+	int ei_type = EI_ETYPE_NONE;
 
+	mutex_lock(&ei_mutex);
 	list_for_each_entry(ent, &error_injection_list, list) {
-		if (addr >= ent->start_addr && addr < ent->end_addr)
-			return ent->etype;
+		if (addr >= ent->start_addr && addr < ent->end_addr) {
+			ei_type = ent->etype;
+			break;
+		}
 	}
-	return EI_ETYPE_NONE;
+	mutex_unlock(&ei_mutex);
+
+	return ei_type;
 }
 
 /*
-- 
2.20.1

