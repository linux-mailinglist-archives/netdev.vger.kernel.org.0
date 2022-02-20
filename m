Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704994BCEB6
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243927AbiBTNtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243893AbiBTNtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:49:17 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE86021813;
        Sun, 20 Feb 2022 05:48:56 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id y16so4473678pjt.0;
        Sun, 20 Feb 2022 05:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zc9vhs9G+cyXNOZDjUOAkxyZIQRaNLzXarwKxHWmpLQ=;
        b=PW/q6Z9D7RxifY95IT2qq4If95So1cSsMDRmHAR+VFhmcnXuUMZ06+O6v9RxnvsAe2
         hacO8nMildUQ9KdKVY8s8YSoSoBVRU8VMyGK6AsRIF27tvZXtASWohCbOcJ1Z+Qc9jJu
         uQI1vTwj1Z9+yVT4PbiQVNLNMqN4jA1wpOqUF2bLTyFIJ3hrNr93YzpUhGnpuyWCkF5Y
         BIrb108eEeIhljhT+sgsb2uKcpWjYazcxeN/g+nWbx+ZFUm0XmSOlnWYykSid08PUT/R
         9NxcxvnQKEHRP88fg0Bma0BgJOo2/bOtjurZvptIo4rXm0DyQdxXV7h/2ACUbpE3UzeP
         jqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zc9vhs9G+cyXNOZDjUOAkxyZIQRaNLzXarwKxHWmpLQ=;
        b=hlozwdi4YQEr0TDaELFgaqJOB2Pjnt4F1tOHCLsjjgCWekz06O8jaZEF7Tvn1WBJ2a
         kCf/IXZtQZHXvlYvGAxJfvPwQDuuQuYuGeg1idBwWkILR4dJHGQP2WW7F+QnfUyu7nRQ
         BtnIplJ7UFeXXuPGAV9nWRSzfYKIt4O/8INiz0v8U9/lPTvhrmRappE+GCHEFsII7Rrn
         qNukUzdnSR5bnlj/THwHBuAVcj2s6Q8xdSoy4OMOtT4IpaMMdAS2fl6SeCEtr60J8rxu
         rR7tzWtgU2KjIy59Mgs7GQixwAto6oSUk6cM3e2ESYmIkZdCkQ0bN8+tF+xCmYicRGyd
         Gdxw==
X-Gm-Message-State: AOAM5326cW37OaHJk46mfR1lL95zea11ma5vOvNW0WCyIqOPL7ca8AQ6
        lv+Os8DFkeqj8RpMdWvTEeIMA7NXFWU=
X-Google-Smtp-Source: ABdhPJw07hfXuRWJYM+lPPKigrU9EJRsHaQA6Vt4BOdeWnHTLBfsgANKEhfzjB9Csf4pMPlmFTLeVw==
X-Received: by 2002:a17:90a:6882:b0:1bc:495:45e0 with SMTP id a2-20020a17090a688200b001bc049545e0mr5842615pjd.208.1645364936307;
        Sun, 20 Feb 2022 05:48:56 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id q2sm9687854pfj.94.2022.02.20.05.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:56 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 13/15] libbpf: Add __kptr* macros to bpf_helpers.h
Date:   Sun, 20 Feb 2022 19:18:11 +0530
Message-Id: <20220220134813.3411982-14-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1322; h=from:subject; bh=NZD5OPd+5AhwTtB95pR1jIO53bA/xGYfngUoa0qcWuM=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZYOKPlywQDBJ8xdF0F5WLgAw9iAlnqzark+xJY DRMqxniJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGWAAKCRBM4MiGSL8RyiwmD/ 4h7mPEqLQl8kqvNbCenKbfasSveHCrPpUz5rACzMCHB+LOPcy8jLY9sib8y73E4PhBh87gFgJVvgXJ zihkInfyQWV96xbMnKSMQXea2MwMrfItAQgCpctnUnmHcb9zKRN+lwoKM5CbszzCbFfuvqrCAifKl1 M/dj6bpEWnT7XgUOfJk8ry5B51K1cq4K3+DUujMWttQE0gqPnK8BNr9+3JIaWZXeA6GlUM/4X6RpFa 5OvecyeTCCl+htOGcTuVkGMK/5ubLYoMO2P+4Xzc9QiPwzCDrT91eyjCT+5KY2tDdQPDzxd9V6EkPU qG5Soh9toFHZHLWtzivwjvroWrxdrM73S8rWJ6QNNZl9OM8UCfO2w6au3K1Z8z+fxexlWmksCSP/dG StdhoM36txuEa17Z4hBnd2HdQubd6UMydFY6AsXm3SwmgQno3naxgbaVfdqYMhmS36RCiS6Vgfkrsa pbhHeK0FxO/0SgUyN6oRU0UsqS3Frc7Wd5bwg0o1kuX4/184Wx3rWBsi1HwuhTwW9ZMoWwsL3BBuIc 0yDFlgMvY0N1iJ8g+sydKJPsJrKDRDANHS1Uw8B8dawHcN9rF84IYLGFNG9APoddAS7pos6fD/UMjQ 4wbPpykof1DxLrvrmOyKwQARcI6LC41/ir8BxEzFtjoIZy+4WVgVGiYhjR9w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

Include convenience definitions:
__kptr:		Unreferenced BTF ID pointer
__kptr_ref:	Referenced BTF ID pointer
__kptr_percpu:	per-CPU BTF ID pointer
__kptr_user:	Userspace BTF ID pointer

Users can use them to tag the pointer type meant to be used with the new
support directly in the map value definition. Note that these attributes
require https://reviews.llvm.org/D119799 to be emitted in BPF object
BTF correctly when applied to a non-builtin type.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf_helpers.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index 44df982d2a5c..feb311fe1c72 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -149,6 +149,10 @@ enum libbpf_tristate {
 
 #define __kconfig __attribute__((section(".kconfig")))
 #define __ksym __attribute__((section(".ksyms")))
+#define __kptr __attribute__((btf_type_tag("kernel.bpf.btf_id")))
+#define __kptr_ref __kptr __attribute__((btf_type_tag("kernel.bpf.ref")))
+#define __kptr_percpu __kptr __attribute__((btf_type_tag("kernel.bpf.percpu")))
+#define __kptr_user __kptr __attribute__((btf_type_tag("kernel.bpf.user")))
 
 #ifndef ___bpf_concat
 #define ___bpf_concat(a, b) a ## b
-- 
2.35.1

