Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF84621B91A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 17:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgGJPII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 11:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgGJPIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 11:08:07 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B36C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 08:08:07 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 17so6243578wmo.1
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 08:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eSUBIu0ybhU8+dsOX2xJvZoNOHyRpVa4hcaol+Gn28E=;
        b=tLoTOaK1tP0nzNL4sEJ3OaYuBTW4ISdwxPITjr0VwZRTKMXjZ/8OV2Jvb1HdL57/NR
         sQ3fX1ImjvmbDF22H8mcGDoHvqYyzRUXSIiajGlyB02L55CUMdazbymN0l20OC4ITlKj
         aKrSz0vR1q+TJtfKPYt8PoVhRSgy5DwEPUZtqLD2ESuaTyK0RLloMeyO0s93FdOj/kEO
         R5Blj/lkIvMUY+5fGM+F/sgx1UaTSZaq+oixjDn87aV5EzoHjMKyQU43zKEODz6cJnte
         FqEbh9MdaP1ydNNtonZzkkr90aZBDPUlVQff5C1YBLcUEYDad29b7vfcVnan5q3Y8k14
         LFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eSUBIu0ybhU8+dsOX2xJvZoNOHyRpVa4hcaol+Gn28E=;
        b=qMXT38yM1FcCc0SwSKqUNqbGn7CoUSvs0QZUeXllYNU1JbPK6moAyi+Y/VJ9BxTMeI
         f/oMDTaTUwgkePjWNMWfnSu+ihCCzqRhWfCOG8gdjNN02K9gY3TW3ODbab3jk1vSXGS8
         bpY6u4uCysLWK2hMksYggQ8Hrxzs7bVeEFMcAo7bP+nixylxgLOlRDYQXseyyfM5zZoL
         PAsGk+JfG158SEJqbSLuOwKPDGIoVX7KcGGdQV4Cpwe6hU+BlQYIewpl2U93GbW6somW
         zVeBLVU2Ys19HkTkZkv3lCv/S5x3n6MGRKp3ec9uEuXV8k27N6w/Vg93TCFLS/1ROezc
         dqSA==
X-Gm-Message-State: AOAM530yoDJqT2To6zT8eaEBy8t+Dw+1oP/O0UAzKj7KUCvBYqGiq9Dw
        8hvlEssTi+9feWrBrasiwiG+NC/yD4g=
X-Google-Smtp-Source: ABdhPJzDhxC4AVpUUe9gaRUGpzwdby1UcySHB4TERLn/FaVLk7R6BCk+Y2S498TgjbzOx3DSB/1Agw==
X-Received: by 2002:a7b:c313:: with SMTP id k19mr5658340wmj.67.1594393686171;
        Fri, 10 Jul 2020 08:08:06 -0700 (PDT)
Received: from localhost.localdomain ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id u65sm10215648wmg.5.2020.07.10.08.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 08:08:05 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, sdf@google.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH bpf] selftests/bpf: Fix cgroup sockopt verifier test
Date:   Fri, 10 Jul 2020 17:04:40 +0200
Message-Id: <20200710150439.126627-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the BPF_PROG_TYPE_CGROUP_SOCKOPT verifier test does not set an
attach type, bpf_prog_load_check_attach() disallows loading the program
and the test is always skipped:

 #434/p perfevent for cgroup sockopt SKIP (unsupported program type 25)

Fix the issue by setting a valid attach type.

Fixes: 0456ea170cd6 ("bpf: Enable more helpers for BPF_PROG_TYPE_CGROUP_{DEVICE,SYSCTL,SOCKOPT}")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 tools/testing/selftests/bpf/verifier/event_output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/verifier/event_output.c b/tools/testing/selftests/bpf/verifier/event_output.c
index 99f8f582c02b..c5e805980409 100644
--- a/tools/testing/selftests/bpf/verifier/event_output.c
+++ b/tools/testing/selftests/bpf/verifier/event_output.c
@@ -112,6 +112,7 @@
 	"perfevent for cgroup sockopt",
 	.insns =  { __PERF_EVENT_INSNS__ },
 	.prog_type = BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	.expected_attach_type = BPF_CGROUP_SETSOCKOPT,
 	.fixup_map_event_output = { 4 },
 	.result = ACCEPT,
 	.retval = 1,
-- 
2.27.0

