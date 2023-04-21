Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D132F6EA13A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjDUBtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjDUBtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:49:06 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E132244A0;
        Thu, 20 Apr 2023 18:49:05 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63d2ba63dddso1493864b3a.2;
        Thu, 20 Apr 2023 18:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682041745; x=1684633745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j6eFFid3zYK7gTdaKpKvDnC8bu0Wn+9im+sC1MyL9qY=;
        b=TdwbyvxPuvtR1I2lwaDkYB8gJwIJWUaVGU8kpm9m3u+vPjnlWpIACkny4dEeBYD+PL
         z1hzi5bdG0TslPCknsyiQzSJrgUpDWMt+rweQPCa/Rw21KKquYvaRM/aWli2aYCKmgeS
         3eQ31vpSvQ9FY6DAEOt0z00iN/G5IbEvX4NQqiBXN0PjjzPALFiMuamiMbuVl9TSeVjO
         OcgPfFnw7ALE04YSjj7qgIJ3mMhrO1FzLqhWUmcHwgC91mZb8ygZSnlHL+z7nOhn+YUS
         PX2mUcwmYU/WRHIRS3DM7dNQvCTHiDUf82t4mUrwB01jvIrGY1fOEr5jByWAzIViwCl8
         3jFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682041745; x=1684633745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j6eFFid3zYK7gTdaKpKvDnC8bu0Wn+9im+sC1MyL9qY=;
        b=CWFbpSUo1MK1yna0BehhOXUeGa3cLiLvgB8aDBj2ACNCSl39xYl7SER+uva2p/iMit
         veCoJ2ihkwDq6tcEewLNJrQI0JDpBeUI0d8GSog6Ewj0Go9otKK0gVXmblI/EyJeg1IZ
         YKnng9VFDyTax5K5DC6MNzBjvrGQW6iCA5FDIrJOJIRibBaWd9tfuZ0TuHC5dEp1MOa3
         yBMg783D/M9Q8u2Ys1Fu2jhvNHeedkBQBmzvWhJm5df3L+3elz/vG/hYJijb13L7dYVm
         x0TtvDqekBV3YwOmQyqeUlYRWvlRvg6UB8YcM9is6pXsevxU8nHE8WR2dMTORygi9cE4
         m3+w==
X-Gm-Message-State: AAQBX9cQtCzw+iq15DE+NZ+wOg+wrMNERerPPBB5qMt2bSJi7WDWSG2B
        yPOpfAJ5cmQiVSdBBZ4AoR8=
X-Google-Smtp-Source: AKy350aMCk1+Y4L38EDM0Ce6hL00N31UAOM6RDeiSysp/mhTNoE6CEmoWSLGUwZp9WYOkbZ6Mc4O6w==
X-Received: by 2002:a05:6a00:2e8f:b0:626:1523:b10d with SMTP id fd15-20020a056a002e8f00b006261523b10dmr3965921pfb.4.1682041745129;
        Thu, 20 Apr 2023 18:49:05 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:ef5e])
        by smtp.gmail.com with ESMTPSA id fb10-20020a056a002d8a00b00631fecabdcfsm1904980pfb.97.2023.04.20.18.49.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 20 Apr 2023 18:49:04 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        fw@strlen.de, eddyz87@gmail.com, davemarchevsky@meta.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Fix race between btf_put and btf_idr walk.
Date:   Thu, 20 Apr 2023 18:49:01 -0700
Message-Id: <20230421014901.70908-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
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

From: Alexei Starovoitov <ast@kernel.org>

Florian and Eduard reported hard dead lock:
[   58.433327]  _raw_spin_lock_irqsave+0x40/0x50
[   58.433334]  btf_put+0x43/0x90
[   58.433338]  bpf_find_btf_id+0x157/0x240
[   58.433353]  btf_parse_fields+0x921/0x11c0

This happens since btf->refcount can be 1 at the time of btf_put() and
btf_put() will call btf_free_id() which will try to grab btf_idr_lock
and will dead lock.
Avoid the issue by doing btf_put() without locking.

Reported-by: Florian Westphal <fw@strlen.de>
Reported-by: Eduard Zingerman <eddyz87@gmail.com>
Fixes: 3d78417b60fb ("bpf: Add bpf_btf_find_by_name_kind() helper.")
Fixes: 1e89106da253 ("bpf: Add bpf_core_add_cands() and wire it into bpf_core_apply_relo_insn().")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/btf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a0887ee44e89..7db4ec125fbd 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -577,8 +577,8 @@ static s32 bpf_find_btf_id(const char *name, u32 kind, struct btf **btf_p)
 			*btf_p = btf;
 			return ret;
 		}
-		spin_lock_bh(&btf_idr_lock);
 		btf_put(btf);
+		spin_lock_bh(&btf_idr_lock);
 	}
 	spin_unlock_bh(&btf_idr_lock);
 	return ret;
@@ -8354,12 +8354,10 @@ bpf_core_find_cands(struct bpf_core_ctx *ctx, u32 local_type_id)
 		btf_get(mod_btf);
 		spin_unlock_bh(&btf_idr_lock);
 		cands = bpf_core_add_cands(cands, mod_btf, btf_nr_types(main_btf));
-		if (IS_ERR(cands)) {
-			btf_put(mod_btf);
+		btf_put(mod_btf);
+		if (IS_ERR(cands))
 			return ERR_CAST(cands);
-		}
 		spin_lock_bh(&btf_idr_lock);
-		btf_put(mod_btf);
 	}
 	spin_unlock_bh(&btf_idr_lock);
 	/* cands is a pointer to kmalloced memory here if cands->cnt > 0
-- 
2.34.1

