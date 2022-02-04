Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FC14AA4CB
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378237AbiBDX67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378580AbiBDX64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:58:56 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D82DF3771B
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 15:58:54 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id u12-20020a25f80c000000b0061d5d996686so4069222ybd.15
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 15:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LMIBeix/VUud47vb1syBaEi+HAAPiTDgJPRgu2Qqg7E=;
        b=B31GRYpIJ18EazuZQ8NcHeRwuq9ZzoLaYzdiOcNLtk80g0wvHbBOHwwHRa7sPhwx5Q
         qlxPHik8tNtK9bigDev1lA5hWWLx9aQqdG5cRL+1MuPpQKxtjAxcLMINFtMBfaVt96se
         rkUaly2bUy8IdQPIKASNTLyqzqe0VZximtX9doHjTrEeGiDdfEw2lR2YaRMDqYVNqHCP
         aK5bVj8tKh/ruwUx4SSJRJLI5AGpmBV6vQ7UiaRJ8d8C66NoeIdsb1juP8dMkBfoSimh
         n2PaaqI7XcEf6zj1MzHlaRLXTa+aBzU+bIxUKU8l7Dv4pKET3NUErtxPotd8uiuP+Di0
         D9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LMIBeix/VUud47vb1syBaEi+HAAPiTDgJPRgu2Qqg7E=;
        b=Ihg0vj8q9TukTWHgwNLJftGI0cPMm0MYXJGcycfEd/aA4kimBzkS2dOeruDwtz3IBT
         VEAtRUFh+UNEH8Ju+50xpCJxfh17MS3FoSH01eKB65dKYn9A5BB3W/WwdsXq1ZidtCx2
         BJf1G+ET/SBc5L0jtlVud2Fx502GGYvWcLtnlcoIOrOvNknmTLk6NXQSEh2csJeBiHWW
         BbM+lJZUfr35Vtj12DBxMfVKQ1Ifde10yi29GHdJVf8vHJ3bz3A/yyArM/Wc1dwTIe3s
         qZWUw1B7w9D5/NKKIlRng4/PzwzsVCMRSQgsmGMHtGwW0lMMkpqQPpIyOa+q9y9NU6BT
         vDUQ==
X-Gm-Message-State: AOAM530sglPVmQAukQzwwzgU+t6mZfzFTNJxNEXAwSD//whV0IK219aP
        o0e8He16hLLkAkIDrnE6vfGY4ldflp8ULr6NRplcphX5Qn0lZYHxoRz9wATFrN0voOMSw0M1Nx/
        x/OsqfOB7vwvfs70D6FotH34ID1vEtzKaX6jS3RNXG8cG0QrcI6Rcrw==
X-Google-Smtp-Source: ABdhPJxu5jyHPmVmutaq15G1Cfhs4nGeB5BxVLIXZeEAnC2Rla0Jm7pwxWD/5HDffBvEVIgr6NTsVXc=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f002:9b32:36ff:cceb])
 (user=sdf job=sendgmr) by 2002:a25:e7cf:: with SMTP id e198mr1659399ybh.253.1644019134119;
 Fri, 04 Feb 2022 15:58:54 -0800 (PST)
Date:   Fri,  4 Feb 2022 15:58:49 -0800
In-Reply-To: <20220204235849.14658-1-sdf@google.com>
Message-Id: <20220204235849.14658-2-sdf@google.com>
Mime-Version: 1.0
References: <20220204235849.14658-1-sdf@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH bpf-next 2/2] bpf: test_run: fix overflow in bpf_test_finish
 frags parsing
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This place also uses signed min_t and passes this singed int to
copy_to_user (which accepts unsigned argument). I don't think
there is an issue, but let's be consistent.

Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Fixes: 7855e0db150ad ("bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/bpf/test_run.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 5819a7a5e3c6..cb150f756f3d 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -154,7 +154,8 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 			goto out;
 
 		if (sinfo) {
-			int i, offset = len, data_len;
+			int i, offset = len;
+			u32 data_len;
 
 			for (i = 0; i < sinfo->nr_frags; i++) {
 				skb_frag_t *frag = &sinfo->frags[i];
@@ -164,7 +165,7 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 					break;
 				}
 
-				data_len = min_t(int, copy_size - offset,
+				data_len = min_t(u32, copy_size - offset,
 						 skb_frag_size(frag));
 
 				if (copy_to_user(data_out + offset,
-- 
2.35.0.263.gb82422642f-goog

