Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA9E4AC270
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355745AbiBGPFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442518AbiBGOwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:52:23 -0500
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0017C0401C1
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 06:52:22 -0800 (PST)
Received: by mail-ua1-x92b.google.com with SMTP id e17so23189006uad.9
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 06:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HfWfVAzwYYBOjlJMDmq+XjKAY8WYr/lc4t7p7lNwmtg=;
        b=cbXoz5y/hkJSL5j+9B0JJo3b/xbOB+bCvG2tWWf08bu0JslJHgjzBk+DSXu50PMI5l
         NQ92/csuKEr+J9qqdKQrhaiP3namjM4fS4RtUmmnU27j2wn760zHuENQajwDQL4B8UHL
         F9sKAv4ELWwNZItKGdw1O5IMAx0mddrZb7UNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HfWfVAzwYYBOjlJMDmq+XjKAY8WYr/lc4t7p7lNwmtg=;
        b=vOiQEa9yTbamFuxqVWRz362jzDJSXG8Hgyjxt9GAHzT3imdxAInFxMO5YS/yiWlHhb
         NTHYvfKG/vdYrrx4NIfPXtWcuOpaJqcVrR3lodZNWmJa/caRSTlm4XoOdew1ARBNrWjQ
         Od/r6xWHR/IJ125qh8XPUcT8AcS56bcmavKqMll75PEtkim32m9X/hXlhIihp21FcKoz
         uPF0xrka5hQG/stjsGaJgKIFDHDI0GHOmdqpYwBgePo76bhSdhgkI4KIk5HWRUzhIXjL
         zTRpC73lCja3zGjOaZv8jXQ4KyUbKKRlvJRsSNjZ2YYya9uCVU3mV+U/A7ZpZ0c+nIaK
         5CGw==
X-Gm-Message-State: AOAM532gV94Ad0f1F9ofEoJjQjtgMKRiBcVyn6wz+smz2NvbkQxNQhdJ
        FSnuKFdsDca/HugVwEpa8AxA9fWBEpkokWieoqDGi6WkviMIYA30qQ90ppYNbhLC8SIB5YLek1n
        ssZY5ZIAUyJR/bX92C4/Z7SgHynHXGCVf1yj4PvBciZCSNGOQ/VIa6IbQLX7AdCxkgAiNdw==
X-Google-Smtp-Source: ABdhPJzI5/pNnsljUqywSTvACDJS4PXPU5UlhPL+S+99LesuUE+Z/RLEvd/P1L+vJ5nSSeEQcN1/Mw==
X-Received: by 2002:a05:6102:2f7:: with SMTP id j23mr4362219vsj.31.1644245539953;
        Mon, 07 Feb 2022 06:52:19 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id r14sm581347vke.20.2022.02.07.06.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 06:52:19 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 2/3] bpftool: Fix strict mode calculation
Date:   Mon,  7 Feb 2022 09:50:51 -0500
Message-Id: <20220207145052.124421-3-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220207145052.124421-1-mauricio@kinvolk.io>
References: <20220207145052.124421-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"(__LIBBPF_STRICT_LAST - 1) & ~LIBBPF_STRICT_MAP_DEFINITIONS" is wrong
as it is equal to 0 (LIBBPF_STRICT_NONE). Let's use
"LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS" now that the
previous commit makes it possible in libbpf.

Fixes: 93b8952d223a ("libbpf: deprecate legacy BPF map definitions")

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
---
 tools/bpf/bpftool/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 9d01fa9de033..490f7bd54e4c 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -478,14 +478,11 @@ int main(int argc, char **argv)
 	}
 
 	if (!legacy_libbpf) {
-		enum libbpf_strict_mode mode;
-
 		/* Allow legacy map definitions for skeleton generation.
 		 * It will still be rejected if users use LIBBPF_STRICT_ALL
 		 * mode for loading generated skeleton.
 		 */
-		mode = (__LIBBPF_STRICT_LAST - 1) & ~LIBBPF_STRICT_MAP_DEFINITIONS;
-		ret = libbpf_set_strict_mode(mode);
+		ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
 		if (ret)
 			p_err("failed to enable libbpf strict mode: %d", ret);
 	}
-- 
2.25.1

