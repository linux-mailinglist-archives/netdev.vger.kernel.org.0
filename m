Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7E7560467
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiF2PTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiF2PTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:19:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232A422BC1;
        Wed, 29 Jun 2022 08:19:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l2so14822498pjf.1;
        Wed, 29 Jun 2022 08:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=peFkrkN4nYi58ApVeiNDHkxUCVe7+HUeNvG3DELjISc=;
        b=faFqr/nK9MhSs9cJs5VoyyLWaNbsLPSUyAXk3uEpY2wXlOyMsFslKYKblJHGoGstF+
         RmzqUzZ9d3AUz1LYKhi3wVDcZBgvar8rDqiniC1922vtSNpSq2/P+JoptANFmu6KplmU
         VrXUIVEqEOlEbISN/IJGak6mCNhLdKjpISj4GvANmKgbgC5a/NcVDGhnHMdAEUEuD2F/
         yF2ubdiDAyHk4vkiEXyw7v8Rmx8HSKJVyArh4VLeJqQNgvcqQR6UU2SzCMV3WFOoZaOR
         w9bfxFPVFTpYgGhatF8bf5oT75fA8DFsp9DoQPf9F6k3JTSlIXMuNFnNO9aYlPcL/7BB
         THYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=peFkrkN4nYi58ApVeiNDHkxUCVe7+HUeNvG3DELjISc=;
        b=253nvIh0rY+b03wTeOuQzpjwvPJ6LOOxe9VnaEp+/j/kHy+CD59IgUysAtRtLUB+wi
         tP/6FnkSF+E5NivG8aG2DKIOUA8DZbNGCz7pMXZ2bpF1WWNKndcY58qLytQxjm65sLNf
         hjm8vydirO8VTrVhmRF+becKjaWeP1XIwsjfKA4BWqoXHpHHMhjvXuT2nZFOQZa9uao8
         tZGcbOnkHdwD8mC3Wv9epVhpfLdoJbr87K+CSrCrdtABfOKkqSjqPHQthHExsvhi9xAl
         YkIWASMLITW9zxklZobF5AmVEdJudhPuyCRFKVwDR0Gb3/3FYukX5WjaITonEixZ7M+w
         +a9Q==
X-Gm-Message-State: AJIora+FJWcBJx2wOoukKhKQ5YLJ4S/0kMVNLK6Wct0017q19FW9s8FD
        u6Hn3JvQY8ANRjkmKO5bKfk=
X-Google-Smtp-Source: AGRyM1t9fvqN2nHCJpv2fXpxhBT3sO/vlOHImlVGBVMsons+ozc8ZyN2Li70319/JH4PqE9bO/jNGA==
X-Received: by 2002:a17:90a:b88c:b0:1ec:9449:219a with SMTP id o12-20020a17090ab88c00b001ec9449219amr6259772pjr.243.1656515974635;
        Wed, 29 Jun 2022 08:19:34 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id x20-20020a170902b41400b001676dac529asm11522657plr.146.2022.06.29.08.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:19:34 -0700 (PDT)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] libbpf: fix wrong variable used in perf_event_uprobe_open_legacy()
Date:   Wed, 29 Jun 2022 23:18:46 +0800
Message-Id: <20220629151848.65587-3-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629151848.65587-1-nashuiliang@gmail.com>
References: <20220629151848.65587-1-nashuiliang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "type" as opposed to "err" in pr_warn() after
determine_uprobe_perf_type_legacy() returns an error.

Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8a33a52e01a5..159b69d8b941 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10241,7 +10241,7 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	type = determine_uprobe_perf_type_legacy(probe_name, retprobe);
 	if (type < 0) {
 		pr_warn("failed to determine legacy uprobe event id for %s:0x%zx: %d\n",
-			binary_path, offset, err);
+			binary_path, offset, type);
 		return type;
 	}
 
-- 
2.34.1

