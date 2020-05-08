Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48CB1CA430
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 08:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgEHGkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 02:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726937AbgEHGj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 02:39:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEB1C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 23:39:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r14so914692ybk.21
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 23:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JqKocGa5cimql1fp4DS+xPXwrVZ2Z2hJEVO/fiKh20k=;
        b=LSasER3WBqtfBg/bGE3PeVOf3C1Dim6JBLIEgeU3rioM9+MNBKorVZ4wLEoKOWeVEB
         WVpX2iRLeOoAaTH5FU79u0hIMkOIFUHESFKAB1oxCjCgjRvmMdaxTMqaBOwQHVR2u8SD
         YZHIpK0wPVJW+tg5pO++cjzhWrun5K+JyrZzWt5wXl2Y8cto4/QGzWXb3Z/TQ/PXtNRg
         qgUSdqGjHPbW9fg5ueq6bMEwFbpewcbkDB66XY25g0+h47IYWDzeNld91gofqSW4vQkh
         JGmHEsw+wh2w1youzj1UIYZYEk5FplV54amOTaCJkWNEEuH/6+HkYRwNtBmntewVUL2F
         WsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JqKocGa5cimql1fp4DS+xPXwrVZ2Z2hJEVO/fiKh20k=;
        b=F+dQ7RJhqlyRUKDytHFEYWPah5NMmk5Dm4xSuKApd6DRE152IlGpLMqZEKCGmVxJPM
         uvXOvQrFOh+p2R/ploCNPeMCRlr6kQzrp5lXZaCKzDe9UUlz7jq83jrpCeF683pHVaYo
         /aALY/OIgFpAOZoihuwvYhtFfV64M+26CT/FLsNWEE2Hn3OOCcUWaoTSflxYZwan7qtb
         +k3Ye/PGp4xqHzbpoUQh31qmyr18RAIjdIDv9Letk/2BKd+XrtOwH1iocdayDBorHK0o
         x9OJhK/WMcD1Aia/lkhSS0GFifXyDVLgY4kRv92ioHKTdL/vy7kFhFzKmJiG674gF+BV
         0dxA==
X-Gm-Message-State: AGi0Pua+shDOV0j9RwxzD3htBrAqJ5dnZUgYbr7hhVwoVIZYe463Z2zo
        1ynO4AksvvdjXSuEBJs37ynEIPPUR1xB
X-Google-Smtp-Source: APiQypIzG335LQcvib+amwZBO3RBTIJWyEl0ag5FnTDtNK3nU2gmInNWeH2R0b+Fk2aSWTZl0MrQJhBzEET6
X-Received: by 2002:a25:dbd2:: with SMTP id g201mr2328607ybf.17.1588919997600;
 Thu, 07 May 2020 23:39:57 -0700 (PDT)
Date:   Thu,  7 May 2020 23:39:54 -0700
Message-Id: <20200508063954.256593-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH] libbpf hashmap: fix undefined behavior in hash_bits
From:   Ian Rogers <irogers@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bits is 0, the case when the map is empty, then the >> is the size of
the register which is undefined behavior - on x86 it is the same as a
shift by 0. Fix by handling the 0 case explicitly.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/bpf/hashmap.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
index d5ef212a55ba..781db653d16c 100644
--- a/tools/lib/bpf/hashmap.h
+++ b/tools/lib/bpf/hashmap.h
@@ -19,6 +19,8 @@
 static inline size_t hash_bits(size_t h, int bits)
 {
 	/* shuffle bits and return requested number of upper bits */
+	if (bits == 0)
+		return 0;
 	return (h * 11400714819323198485llu) >> (__WORDSIZE - bits);
 }
 
-- 
2.26.2.645.ge9eca65c58-goog

