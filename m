Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C533744DA2F
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhKKQTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbhKKQTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 11:19:20 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D6EC06127A
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:16:31 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id n29so10652174wra.11
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zZzTrI1QtHZbOvnogUJcn8Oi+ZOfkI6aUO7akFnlCjA=;
        b=SAM5agZP3GMBP/IpB7d3S+lK9AY9976cRX6uEoH9Ok3+8wwrdcx6oDUDosZ8KW1MfM
         sqsvdreXTsXqay/E9oknCW4WUkKyNeLQLJGkuK6dS/LZijturuN1oosyxo0PKbYMXTxc
         vrU0PczUHvUGWbNNIR4uZg0V5NIQe7m9PU3ZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zZzTrI1QtHZbOvnogUJcn8Oi+ZOfkI6aUO7akFnlCjA=;
        b=mI583yhKrbXGDBNxqwfkHWqtWoSpFoM26Sj+LvNzA6iKQcGAGRW8rJsI6ugouSgcZT
         v65ydEZQkOUeQHN2+j7SAhWzhD5KbWul0mtQ4ySP+O+48MgZ5qWDU2TqNQXHqZm1DsXz
         QPGVG4+0vily6PnNNIfVBbXBBRFCPoZD261urhIw+DCueRzVGPJqWPtSqpid2b0kwYgM
         L5eiMgZLJhUyoZ/LMl7lxxlsGl1qUJ0fSwdwJK+RG+CbvdSJ9xTqy8JpsWLiAAoKOSYK
         WBEor0v/Cp2YhWOR9cA/tfWjlIWzRXmlSxjlqaf2o8Ck2UTp6qzsxtdQvFy5FK1WGU8y
         tATw==
X-Gm-Message-State: AOAM531tdr/iPaSENBNsGaMhrQUAOV0RBRKIMDY3XIFeL+JiVaurnYVB
        sE63q4x/Pjrxiu/TC+w+Pyt3v36UCJwhNw==
X-Google-Smtp-Source: ABdhPJwjaosR8hkghnBSlj44uWNymczb7pey8hyaK4vEct0nk/EoziO0oAKUmdzuY5E5nEgXdFTCzA==
X-Received: by 2002:a5d:6351:: with SMTP id b17mr9796155wrw.151.1636647389927;
        Thu, 11 Nov 2021 08:16:29 -0800 (PST)
Received: from altair.lan (e.2.7.a.0.3.c.5.8.8.6.b.d.5.0.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:805d:b688:5c30:a72e])
        by smtp.googlemail.com with ESMTPSA id o5sm3219857wrx.83.2021.11.11.08.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 08:16:29 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf] selftests: bpf: check map in map pruning
Date:   Thu, 11 Nov 2021 16:14:52 +0000
Message-Id: <20211111161452.86864-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that two registers with a map_value loaded from a nested
map are considered equivalent for the purpose of state pruning
and don't cause the verifier to revisit a pruning point.

This uses a rather crude match on the number of insns visited by
the verifier, which might change in the future. I've therefore
tried to keep the code as "unpruneable" as possible by having
the code paths only converge on the second to last instruction.

Should you require to adjust the test in the future, reducing the
number of processed instructions should always be safe. Increasing
them could cause another regression, so proceed with caution.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Link: https://lore.kernel.org/bpf/CACAyw99hVEJFoiBH_ZGyy=+oO-jyydoz6v1DeKPKs2HVsUH28w@mail.gmail.com/
---
 .../selftests/bpf/verifier/map_in_map.c       | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/map_in_map.c b/tools/testing/selftests/bpf/verifier/map_in_map.c
index 2798927ee9ff..f46c7121e216 100644
--- a/tools/testing/selftests/bpf/verifier/map_in_map.c
+++ b/tools/testing/selftests/bpf/verifier/map_in_map.c
@@ -18,6 +18,39 @@
 	.fixup_map_in_map = { 3 },
 	.result = ACCEPT,
 },
+{
+	"map in map state pruning",
+	.insns = {
+	BPF_ST_MEM(0, BPF_REG_10, -4, 0),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, -4),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 11),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
+	BPF_EXIT_INSN(),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_in_map = { 4, 14 },
+	.flags = BPF_F_TEST_STATE_FREQ,
+	.result = VERBOSE_ACCEPT,
+	.errstr = "processed 25 insns",
+},
 {
 	"invalid inner map pointer",
 	.insns = {
-- 
2.32.0

