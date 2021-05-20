Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BC938A078
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 10:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhETJAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 05:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhETJAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 05:00:01 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570FDC06175F
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 01:58:40 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id df21so18515937edb.3
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 01:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L4mndmkqjTSZztCeiOLL8O6jaDOjPUMAMSuwEf9K3dc=;
        b=fcvu08leEa9fLkbUNUdUTYvUgfM4ckRAPBKDCUdvptAM4/7YpxVaXi4bCRXfo7Hi9F
         qhyg+uYi1R/5UHzy6MItmkkGpNghrL6k/gU29wZlyhAsZn8dfHvQcCs9SeYhhcnpGyNC
         baX5YkTuggoXQgXLYFhbbo3RSPzwalMcD8DZPjghWVMd1RrvxpO0po1lDb8CR4EjPxen
         6Q5xE37udysYzE9LQdYWpc7ik1nUTWAwcHqxxZn3gn6hDsm5UYFrwxmp/frGsHOdyK+M
         FNWdYGxiEj5SWqdy+B799QI+bXq7cDC6hIEACcCigaLBfnN1BSgO78t6Mp6B/NmhIq4e
         BR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L4mndmkqjTSZztCeiOLL8O6jaDOjPUMAMSuwEf9K3dc=;
        b=ALXIfSW6wfqgjFXF5p9Woc4m1tbeyhbAL9AH951KEFdNmVW5AxmQ7CJMRHjI7MO5Oi
         UhD0alFv3MTQehBWapb41/2PkDn8irT/YIr65ehSBGbd2TfbkGPKICyCNkDuKZCgi8ue
         6l0ZgwTw0ac/LweGkMfUFgW6SDTiHC3IWS65bd/Y+njA4OkIeIOt4x/+0ygcTeqg0ZvW
         aiqviaRwd17ik6aRL2Bt2RTexByq2edu1d/qziEoN8KNNEYn97Xq5bHoGyLMizhLLGtq
         HAxV7E4M8EEtHvXpz79yfcYj8VZsW/1NHKQfUB3Qzt8pdbBcJLHlagIl1gHFKKjrRJZO
         +VCg==
X-Gm-Message-State: AOAM532VnzSbnI63y4oZkmakI1gpndDg7qJRr5UyxyFwwPDL8a1dKbqQ
        cAs/ny62JzOWCpPo99RHu3dbVg==
X-Google-Smtp-Source: ABdhPJxUr/6jrjYYzV2240KUrsI/pQ9j2JcQ4NuJ/OA7xDJJOkJq9eSbttUJD/EGJM4WOpCyqLlRTw==
X-Received: by 2002:aa7:d818:: with SMTP id v24mr3735202edq.290.1621501118908;
        Thu, 20 May 2021 01:58:38 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id d15sm1142301edu.86.2021.05.20.01.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 01:58:38 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH bpf] bpf: offload: reorder offload callback 'prepare' in verifier
Date:   Thu, 20 May 2021 10:58:34 +0200
Message-Id: <20210520085834.15023-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched the
order of resolve_pseudo_ldimm(), in which some pseudo instructions
are rewritten. Thus those rewritten instructions cannot be passed
to driver via 'prepare' offload callback.

Reorder the 'prepare' offload callback to fix it.

Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 kernel/bpf/verifier.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c58598ef4b5b..09849e43f035 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13368,12 +13368,6 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (is_priv)
 		env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
 
-	if (bpf_prog_is_dev_bound(env->prog->aux)) {
-		ret = bpf_prog_offload_verifier_prep(env->prog);
-		if (ret)
-			goto skip_full_check;
-	}
-
 	env->explored_states = kvcalloc(state_htab_size(env),
 				       sizeof(struct bpf_verifier_state_list *),
 				       GFP_USER);
@@ -13401,6 +13395,12 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (ret < 0)
 		goto skip_full_check;
 
+	if (bpf_prog_is_dev_bound(env->prog->aux)) {
+		ret = bpf_prog_offload_verifier_prep(env->prog);
+		if (ret)
+			goto skip_full_check;
+	}
+
 	ret = check_cfg(env);
 	if (ret < 0)
 		goto skip_full_check;
-- 
2.20.1

