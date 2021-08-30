Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146163FBB0E
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbhH3Rfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbhH3Rfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:35:37 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2367AC061760;
        Mon, 30 Aug 2021 10:34:43 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u1so5160386plq.5;
        Mon, 30 Aug 2021 10:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5vCY6Sr0w4H1+O982a7RpdrWZPTqUObwvkknerCSN6A=;
        b=ZWfEQwd624GhxnLUPG+zOPSleiE9SWAYu1t+lwX50nV8ICHpGQ3iNVttSAYWfZjbf4
         Cjp8LXF8U+ddkIVN8i747irRGmZ8MQ0hcK/YUyboTQ5Z2eFuyfRpEO+VFxgzEeVO2DQQ
         /4pAbOqa4RyY2PW2neP4UKlYLJAtrWO9h+ZBRrJzeV5ePhsJwroUtGmbvuM7+YZZa5oz
         8j6SqZCeD8BZzQX7D7J4OCnfAp5dJt9BZC8eKkoHyG1tYN7QFnDnpr8HPtTaawk7us16
         Cw9mj7Q/RvwQm1WSj4GMZ14SZ5QYA6OQebMy6bdOQfFDczpnwQMeFO3gSPmF3BzO/CKm
         5VfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5vCY6Sr0w4H1+O982a7RpdrWZPTqUObwvkknerCSN6A=;
        b=ryrlvRQdpeC8qlNo7ME4/G0WQVzdfB8qlAcXRy8M6Ui/YCMofj42O8f8kBWX7Bw+NJ
         CE8iXezpmn7nGH+z81fj+bZqytJp9/a2B0zO1Ub9N+FDSu2ZtgFRIIyPpQeP6ujVFdU1
         gLh12/ZqwYU5wO/j8KDHv8idwPjElXksxb5TpQYJGL+RTyVI16+etw6tZCvdp9G9YJ/p
         Q8Oxkp58LwT08NE6cbhalHRncRXK2yGEWvdGZvJPbOAuRP+0+FPKmLT5WzmlOV493sdw
         958muENmkSarpdKOrhPo2pMGW3lROI1r94YCVYZeEuXxF9grHgmPkV7O1MaP1TVN5ZqT
         5jhg==
X-Gm-Message-State: AOAM532bFepabCf2RleAS/+BTbvbF42xLG9YH8XNLr5cpjYtmchzqmoh
        NeiS14krZVCcmeMOz4I6Pp+728R5MsUZVw==
X-Google-Smtp-Source: ABdhPJyUmP2A/X9x8Hhvqycvc0TH5yDoUw6+kktFzfKi5tLVmwmNvZSsUCg+OE0iKBHSvFmO9DsUPg==
X-Received: by 2002:a17:90a:53:: with SMTP id 19mr183729pjb.159.1630344882549;
        Mon, 30 Aug 2021 10:34:42 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id t42sm14757649pfg.30.2021.08.30.10.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:34:42 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next RFC v1 4/8] libbpf: Resolve invalid kfunc calls with imm = 0, off = 0
Date:   Mon, 30 Aug 2021 23:04:20 +0530
Message-Id: <20210830173424.1385796-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210830173424.1385796-1-memxor@gmail.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1874; h=from:subject; bh=0Ipz/Yi43rx5DJpjld7vtB0LLAwruqr1vRK9uMkuMkA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhLRX9Mu5LQIUGP+W5QKPzu9NrapcpPUMw1aj/KnJT CCXx7P+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYS0V/QAKCRBM4MiGSL8Rymu8D/ 93pXwEizs0lNBi2cR5bS+F6hyyOh04qqWu1gJH/5E3zje6haYDJD/B5BQFtRI3dexz0wDfFOEI1H8U w2VPgqyEvdcj9TdNPHKEin/XMCes7aWOIdEDlWu8+C5KSJyZF92lXP4cQhhlwpqOqYfQzgTsNf+URc 6dTfJgNknpTD6MNNp3QJin5Lr5syHl+eKnd+cNoH0sLIovZebJeTSUu+W3Dal2qLfgbPKaIQ0V4LGM GStyxRATNQ5R1HhXXiHI1S8tly0ycLc8FcN3WqutGPbFzrrmvvhUVRFfFXtWpX8K/hlGv+MmNGJg6d LUNzrzPVgKkTfG1Wxp27tVXD54cYHHkhuTtpKAUOJDjSGUddxgcnHWbLkX2i6P8XFcOV8ihscVI7M5 xkY6II67ZEyrKD+RtT9KIl1IfnYS+3/jacWS+ZGEdsMsFAb+UZJ2ME1UJNsptOvKUMSnlOnef1rcNx hRmjG9sanA1BQyZiCZKS7uYn0aIP9FNyIVJDLdY5s87ljedX7wJslkgCb19tOLNBU+E3pc28iotVby /6yT7homc24+naZrza5DB8xrLfmsAjcjACgoNRQcc+ZD1ZQEvfvpXbA/fWgt7Uwxgjb4L0txqNbJZw TRpqwTTj6wnntO6LlixNl5uaofL1I9HJv+pQ5i/prj9H6n9bD4sikJ2kIucg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preserve these calls as it allows verifier to succeed in loading the
program if they are determined to be unreachable after dead code
elimination during program load. If not, the verifier will fail at
runtime.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/libbpf.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c4677ef97caa..9df90098f111 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6736,9 +6736,14 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
 				    &kern_btf, &kern_btf_fd);
 	if (kfunc_id < 0) {
-		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
+		pr_warn("extern (func ksym) '%s': not found in kernel BTF, encoding btf_id as 0\n",
 			ext->name);
-		return kfunc_id;
+		/* keep invalid kfuncs, so that verifier can load the program if
+		 * they get removed during DCE pass in the verifier.
+		 * The encoding must be insn->imm = 0, insn->off = 0.
+		 */
+		kfunc_id = kern_btf_fd = 0;
+		goto resolve;
 	}
 
 	if (kern_btf != obj->btf_vmlinux) {
@@ -6798,11 +6803,18 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 		return -EINVAL;
 	}
 
+resolve:
 	ext->is_set = true;
 	ext->ksym.kernel_btf_obj_fd = kern_btf_fd;
 	ext->ksym.kernel_btf_id = kfunc_id;
-	pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
-		 ext->name, kfunc_id);
+	if (kfunc_id) {
+		pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
+			 ext->name, kfunc_id);
+	} else {
+		ext->ksym.offset = 0;
+		pr_debug("extern (func ksym) '%s': added special invalid kfunc with imm = 0\n",
+			 ext->name);
+	}
 
 	return 0;
 }
-- 
2.33.0

