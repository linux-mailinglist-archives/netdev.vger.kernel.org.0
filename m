Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C3657CC61
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiGUNow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiGUNnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:43:43 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864C084EE4;
        Thu, 21 Jul 2022 06:43:06 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id d8so2343710wrp.6;
        Thu, 21 Jul 2022 06:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4cFR1T4lbutWstXHmbM2dbPlJKpl1mp7S3Dg2sFTtXY=;
        b=KVkLrWgddpuAVAWsP5eHNLEU1w+B9BdEyAOUBK9BHSL0zpNUPnM4tS1CuoI9ubKYH1
         SICjA7EYGI5EMSexVGs2Wdbsssu0jIbwwS8UhTla+iNk08CMBsWmf1+ZwQIKMMVOXZ6b
         ehIQxO9NXOi09puNJ1ada3vfb05Gel4msX+8z50QyLKcS1gU/Xp1jhG70Vmu6zyvtVWw
         y+SynLbjVa2fqpXkLLjDefpn27cGgteQH6SDGWeJWOC8A14CBosfb/bm/+N6hME9O2xp
         mVSEc6zfxFs8qEzMoG2jbpBDKVYNUllhWuI+fAXkUEwzHNw7qsvnhBuVoDTyrETtAo6i
         6Eew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4cFR1T4lbutWstXHmbM2dbPlJKpl1mp7S3Dg2sFTtXY=;
        b=23qBqFO+803T3s7srrzmPe2ghKkCPaER02nj7JNoPpZDhqCnxF/liwy48lsCXtR1LH
         VYunLLYoNFPg852YYb/hTBbAXp52lRb1hY8ErhibaVnCIZzgli4Gyrd/kV08US2FQLko
         17NdRSpS+Wr/tW9z1LySGNbfWB1iyLvfxixgcIxsyvcnVgZ5XgK+BuEnp2Ta/Lsktbh8
         1Qz1ji3zrgjKgbv8CiNK+OPaOMGVnewyny0CRDoml2rSrbRRVaOqhuj6UY2EGtMDwJfJ
         BmSaLOAVHqh0bbOHKC7gCVv3blGBrlYtE0cjqtpsZoh9vfc1i8hCT4V+KcY6rkKygH/S
         mCoA==
X-Gm-Message-State: AJIora8ZfOH6/BCwTMTQvhwmqn8BkLKJzzsmjCPkeyEr4CfPlOlckbYT
        ldJuL3ReJ+3mczFX0SZHm3n2J2R94hKn9g==
X-Google-Smtp-Source: AGRyM1tv8hG/p+LFkPwOIRJrObTsWd8EoZ1vcyWWlOCCMpqph2WBWggbYzK1jZVNASYsZQ/Xdzxu2A==
X-Received: by 2002:a5d:50c2:0:b0:21e:5ad5:39af with SMTP id f2-20020a5d50c2000000b0021e5ad539afmr1195241wrt.12.1658410984542;
        Thu, 21 Jul 2022 06:43:04 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id x10-20020adfec0a000000b0021d6c7a9f50sm2061688wrn.41.2022.07.21.06.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:03 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v7 13/13] selftests/bpf: Fix test_verifier failed test in unprivileged mode
Date:   Thu, 21 Jul 2022 15:42:45 +0200
Message-Id: <20220721134245.2450-14-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1029; i=memxor@gmail.com; h=from:subject; bh=avUxAzVXxTSlvvIczCgkt5Bck8b2xRF1My3q7b4wHho=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfOQgxaln2kgyqBnUL/mSLBYQq2oZzyQ+9iPSWL 0uAGw62JAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzgAKCRBM4MiGSL8RyiH4EA CztFjAuMJPfmhUCCB0S+c41xTfwCWXvVG4a6rEFugOpXn2w11Zt3DViPf12HWrF6AzLE9UWn/Bx17S iP+fhaHYrOP0aKYVwi1MSqrJvt5Yw3KuF1mqPclVPI/kCWnJ8P/ML5di7OK90VT0WTuagcJnRGh+3v LM319hMOVLQPR+Rt7Rz18mTfwl7ybj1f1+m8rpR7atMlc512v9pxiCJvoyJYWLiw0eSnUwMfFX7cIo 8ymTD3/zmdjHyv28gZEd/z2PZaMxTREduY42emQxT5DjCFERq2isJYKPeAx/p8snPU75+NS4OMaOyn q/awgHEWB52rBwOxs5/vjKQ5RrQY3WGc0EvbKl76V5UUqMxxC1PQlKXZFu2XpuGo2il5PabT4K/72C 1thoR4BGAFe5ARoujOvZ02GNgvpQ4z2FgdfWgohZ/r5sL23j1tngQfE3JpePAg3TNjzkt5MjYzIIO0 W+AUfK5yOHWjIVyWDFnXI2uDj2559wEgyR7I4/j2kbYuH4cy2bN57f3PSmC2dBT2SEH9w22ZOW8Y0u zXW5S3TYCl0U4UcbYomarqfG6UWgV9ZHFBgui+u7ecm/bmmYhXfN9/6AjM9IXtW8upAMWNy5IYczgR xBLKb/7SpyPfOs+GW6J73agE7rzLvvWLoY7YeABvf3YeFUNeecOAdJXPO7/Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
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

Loading the BTF won't be permitted without privileges, hence only test
for privileged mode by setting the prog type. This makes the
test_verifier show 0 failures when unprivileged BPF is enabled.

Fixes: 4118e9e9def ("selftest/bpf: Test for use-after-free bug fix in inline_bpf_loop")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/verifier/bpf_loop_inline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/verifier/bpf_loop_inline.c b/tools/testing/selftests/bpf/verifier/bpf_loop_inline.c
index 2d0023659d88..a535d41dc20d 100644
--- a/tools/testing/selftests/bpf/verifier/bpf_loop_inline.c
+++ b/tools/testing/selftests/bpf/verifier/bpf_loop_inline.c
@@ -251,6 +251,7 @@
 	.expected_insns = { PSEUDO_CALL_INSN() },
 	.unexpected_insns = { HELPER_CALL_INSN() },
 	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 	.func_info = { { 0, MAIN_TYPE }, { 16, CALLBACK_TYPE } },
 	.func_info_cnt = 2,
 	BTF_TYPES
-- 
2.34.1

