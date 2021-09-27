Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6638F4196FC
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhI0PCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbhI0PBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:01:53 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35952C06177A;
        Mon, 27 Sep 2021 08:00:12 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n2so11939367plk.12;
        Mon, 27 Sep 2021 08:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JgNyFr51slssP3bhc3yykZKy36rLj3siDcsI+KkBHs4=;
        b=qPbXuG4bTnnni4lEo7J3b4TZubygDchx6c/mHMVPjjwqqevV40RG7FjN+8BrXAgiWO
         8KKSj6DjCD8iim722xL1YK2kMHY7imWzIhwV/130B7rmR+JnfHBYGnq9m+ljEfJd2mTo
         xcCsipTe0DaKtvEF6Bw/rtC7ZOCvVmH8sZvG3GC3Nm6zvCVMNKTQS7WMsoxOLpSKve5d
         V+OtWZT4YIcm/2trSDd2tblUs6boD8+x50p1elFWgD4SP6ALjSsFZWK/0143kj9UtPKr
         0zREsOn6krzn7vDInW3IeaSCIpHeiCJbTNsPL+F/FMhh1hycL2hLyrtCBUvJ/uTzYzrN
         TuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JgNyFr51slssP3bhc3yykZKy36rLj3siDcsI+KkBHs4=;
        b=icZBh23Q6zW/mR0er/TLlzCogUXbqaknba15vLSU0eDQch7zpWdLw0b0t15NH2JR9p
         Zb6oSVJ/DHLjRJhvaNgyx9rbbRsqBiap03VWLbUOremI2BRudTK+anIikxvPbtCJiKU6
         BpjIphrZv3jTSyVp1AzLy4xKIZX2KCnE0pebDzLP4cXJoe8FkhFdY9mWlfOPhoFllD87
         6dJAzqPDB8/whxQ8F4V9t5isYVzQ3BVlyNN9z6OvILxea4Yy1oerHa6Gnp2AyRe0MDOR
         cm5EZQuaU5Tp7V/cbIjxFBDQj6X6Qty5gBPpLMAkEdFAc8zbPxt1MEK7itbvq55XZzZZ
         7Ubw==
X-Gm-Message-State: AOAM532sDglCV9ts5iHNXZaMv81LWoNdQMvGUwN/vyiijenaNgj/iMNW
        T2lw7Ih5Z9SRz+851ywfT2HaFli3TcI=
X-Google-Smtp-Source: ABdhPJxp1HIVz3BceARgXwzQZSfy3TNdv4hzf+EbV/5qck3DLWTozynqWe2eFB42jwByOvBRZRzmew==
X-Received: by 2002:a17:902:c184:b0:13e:2e49:8a92 with SMTP id d4-20020a170902c18400b0013e2e498a92mr284757pld.2.1632754810714;
        Mon, 27 Sep 2021 08:00:10 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id g27sm18214183pfk.173.2021.09.27.08.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:00:10 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 08/12] libbpf: Make gen_loader data aligned.
Date:   Mon, 27 Sep 2021 20:29:37 +0530
Message-Id: <20210927145941.1383001-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1157; i=memxor@gmail.com; h=from:subject; bh=BpTAouLmASMkUTTW2rl1vdawRxwdtufN6uz0MPaNZ7o=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxPnHrX6N9UhfkxogwpVC7f85lVGqZtHZurK6Xl H0Khi6iJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTwAKCRBM4MiGSL8Ryn/JEA CK113XGjkFqRU4jQYtao3vB8BLO1tw7GBpl1fxYOB9GGUIYL1Zo9YhY93dH1Ok4K2Ff3ix9HqB3/Y3 TJd38C5uprNpTQnmi7TokRgQHOb+jkSpckLrqPQAiUq0UlgV4wmOQj1+kxkNK6LU+u1hkvIxUV0bFP d4RB1FGpnK4dIPtP63v5W32g7h2vLKSniu/GkJonV85AdgOzcwMIcZeSG+4Ly9sPjpVWh3rKoOzmXc A1LlcdbjbCswocu8v7BKrCojZ04FLop8PBY1GiKb62H6hyBNAaWN39M4ZGlUwOaePOgsVkXWqfWp2S zqFzIpqyKWtcpJMW90HW+CgzfGrwAO37pqjw1V/ijm73stRAZqowCRCOmlaOEQSKo3EgObutwxBsP3 TOqE81an4Y6jGuU+QCYceG19u97IaQARTMQi2ChFpOQUno0UXc7FPFYIjKfI38DIBBQs9sDI4R/vyJ xbmgOq2PmaiD35fkpJSM8913wQl542qmY+UVzoDef9AsRJzg3FwPaKg8lJJVU04QZA54+aIe2iCRMz NaOk1dDu8YuL+16hjTk2AREjIDICI5UZIZo6mGDsAqLgciahIY/Ne2GyLLrJeMGrXH4xhWlQoVQb+V 8ZNdBwUgpfnPFrnHMEe27Up9gJDIJoEfytqfmUfA2Lpl3c56CsmRZmHUn5pw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Align gen_loader data to 8 byte boundary to make sure union bpf_attr,
bpf_insns and other structs are aligned.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 8df718a6b142..80087b13877f 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -5,6 +5,7 @@
 #include <string.h>
 #include <errno.h>
 #include <linux/filter.h>
+#include <sys/param.h>
 #include "btf.h"
 #include "bpf.h"
 #include "libbpf.h"
@@ -135,13 +136,17 @@ void bpf_gen__init(struct bpf_gen *gen, int log_level)
 
 static int add_data(struct bpf_gen *gen, const void *data, __u32 size)
 {
+	__u32 size8 = roundup(size, 8);
+	__u64 zero = 0;
 	void *prev;
 
-	if (realloc_data_buf(gen, size))
+	if (realloc_data_buf(gen, size8))
 		return 0;
 	prev = gen->data_cur;
 	memcpy(gen->data_cur, data, size);
 	gen->data_cur += size;
+	memcpy(gen->data_cur, &zero, size8 - size);
+	gen->data_cur += size8 - size;
 	return prev - gen->data_start;
 }
 
-- 
2.33.0

