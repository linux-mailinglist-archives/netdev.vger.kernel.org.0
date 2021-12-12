Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B2471842
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 05:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhLLEmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 23:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhLLEmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 23:42:19 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E912C061714;
        Sat, 11 Dec 2021 20:42:19 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g18so12062668pfk.5;
        Sat, 11 Dec 2021 20:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=FkhTj63126y9lAhicHFfO4FpHXcr7hg/OoN3XKYiZo4=;
        b=Opq0Mv5C0QupzX/jrhdWt82gxjAVPnLhkFGbU4Wdcwp/PCwwiuJq4hNDvH4RyjN7GU
         p/JmFgFjDuGc4c2+EuSFZo6f2Skt1xSTk4SXlNpXN2ATHLk+m/BtyXrdvRnc0U/4V06Q
         bwMeZZDIrSaElT+yoIwVA2j5Ddmwa7OxKa+4cKK4ZHH8sL1FWmJdGZFrfOjU1T+61z4v
         gmBRl1oxqWyruYrE34o9leTaW58+TUHWuwqCAI+WMjzxxg7JcikVgPfu15DC79q+YWXT
         A3AXj197ESqy7gaWNbcK3eUcsKjS6TGPKa6+MBG+iLOjRxVVwBnq0avo5O7vjGriiBZm
         Hw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FkhTj63126y9lAhicHFfO4FpHXcr7hg/OoN3XKYiZo4=;
        b=qm0Mh/X3GALWanwSHuFuylVj4RsMEqzDUWi2435zgvGTjPaslVoZlwdleb8mHBdMDT
         GJV9qTQM+IffLAIKb8q9ymKSiydmQ7XV5MEaXw978Oyc25FpVbzpgOrtl13uqa67sNQO
         9QrnWIERRWtZvSV62KkFT9qaBeK94vpvE8pQ8AJBKvsW3GqUM0Gr15rqYagDC4fKUZjh
         yMOCbextkIM8RyoC4eGMwcUSdrqb3vcWcmvS+1QnZDflAjFeV3lyMB7kTiffVAxtKNeq
         bgkyXi4Fbr58t7jshFJpwKdtt7U0QCV1Mr331eHO/xqCmua17S8a3ASXnXWlBsu7fl9S
         MyzA==
X-Gm-Message-State: AOAM533rFn5HNchQ1IrPZVLOXcEl4LtAZxoHKJBmLA9XISILifO9J4gC
        fyDDw/ypiDcAS4ky9kDG3wo=
X-Google-Smtp-Source: ABdhPJy2SHqTFnQRsphqnWkzjkLNcmj8IoIrxu/fahFcIL+OV2q+cNACuGZv89j6Ty/3GnlyDtu2Ng==
X-Received: by 2002:a62:e908:0:b0:49f:c633:51ec with SMTP id j8-20020a62e908000000b0049fc63351ecmr26676099pfh.1.1639284138566;
        Sat, 11 Dec 2021 20:42:18 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id on6sm3430471pjb.47.2021.12.11.20.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 20:42:18 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Hengqi Chen <hengqi.chen@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpftool: Fix NULL vs IS_ERR() checking in do_show()
Date:   Sun, 12 Dec 2021 04:42:08 +0000
Message-Id: <20211212044212.12551-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 The hashmap__new() function does not return NULL on errors. It returns
 ERR_PTR(-ENOMEM). Using IS_ERR() to check the return value
 to fix this.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 tools/bpf/bpftool/prog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 515d22952602..564a15f881c6 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -571,7 +571,7 @@ static int do_show(int argc, char **argv)
 	if (show_pinned) {
 		prog_table = hashmap__new(hash_fn_for_key_as_id,
 					  equal_fn_for_key_as_id, NULL);
-		if (!prog_table) {
+		if (IS_ERR(prog_table)) {
 			p_err("failed to create hashmap for pinned paths");
 			return -1;
 		}
-- 
2.17.1

