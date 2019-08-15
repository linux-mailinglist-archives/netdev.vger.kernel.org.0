Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2838EE39
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732946AbfHOOcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:32:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51006 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732807AbfHOOce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:32:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so1463073wml.0
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 07:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GhCitZIE1rm8aD0lfIgbmHAyTkoG5GD5Cm1VynvrMAc=;
        b=gg/y4dqIYmFdyInphTX8Wt+EQGNKRRYTuP/SmzQe9iy6izjuTILacgzG2kklO2tmOu
         0Ffa2e0pTvph0ci0exTMriKMnlKiXSYpWR0+DtTO+5jJPGCqBIsVJAEvtzyx4gV7zp2x
         V8Iad5LDayftlcivVS/AMT4WO+8YbacgUJ+xnhE2/M9nrYMmxrMWBJQga2CVWmklxmUF
         FTDQEZljxwB0K5vdvWiN/E0hCiKqCTTu7+XLBNJbGb5Hv5bvhNfwyD81U8nIu/clMAd8
         0loOQMjFaFwWRbipRjuYZzEFi5B1LdF76Yhriag/LPmQMXcK+GA/R8C4m4ntuRLoVjIj
         +23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GhCitZIE1rm8aD0lfIgbmHAyTkoG5GD5Cm1VynvrMAc=;
        b=Eu4ejz9bZHECK54e4Ybhq2hYlzb+D919SVCv+NFKjgsycjOQCD8zvt76XaWS2fNS89
         iyxzUUNgpsZdV6EYsyxjppxVGyyGYZIxBTQzScYja+OnPNfKiVyJAi1snhUiXetn1Q8P
         l69hbM4VhSDKoATeTjRUH1b6R9KfPLG5PlrRSXuqvSjiO9bEo6M3cZe8LKsw7BIZZm73
         2EwORP3qoy+IpMUY1aIICQV/LLxA7yvlYT/78zTvRC4Q6ud9d4rm+DVlXTiTIeQeZ1nY
         EXjNHn/o8+3+G87rGkjAdoz9/Jf/iVB7w9VHd8rA6H7zN4oo3jIcsdlSNSJXQ1P0YbX7
         eZkw==
X-Gm-Message-State: APjAAAVdgaRcqa/75H0i9fjt6sALz62a+iMOHYro2jAsvM4G1mOUhMlT
        YA8Un8RW89nQBInWREHgJ6m84g==
X-Google-Smtp-Source: APXvYqwu8EjSUkIT4UxX6coE1H5WsFoQ4nq4Qgbh6FF0MIKH4BTnCJT3IFRQeqwHwb+Rt0xVn3zKKQ==
X-Received: by 2002:a1c:c747:: with SMTP id x68mr3222847wmf.14.1565879552510;
        Thu, 15 Aug 2019 07:32:32 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a19sm8857463wra.2.2019.08.15.07.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 07:32:31 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf 2/6] tools: bpftool: fix format strings and arguments for jsonw_printf()
Date:   Thu, 15 Aug 2019 15:32:16 +0100
Message-Id: <20190815143220.4199-3-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815143220.4199-1-quentin.monnet@netronome.com>
References: <20190815143220.4199-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some mismatches between format strings and arguments passed to
jsonw_printf() in the BTF dumper for bpftool, which seems harmless but
may result in warnings if the "__printf()" attribute is used correctly
for jsonw_printf(). Let's fix relevant format strings and type cast.

Fixes: b12d6ec09730 ("bpf: btf: add btf print functionality")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/btf_dumper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 8cafb9b31467..d66131f69689 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -26,9 +26,9 @@ static void btf_dumper_ptr(const void *data, json_writer_t *jw,
 			   bool is_plain_text)
 {
 	if (is_plain_text)
-		jsonw_printf(jw, "%p", *(unsigned long *)data);
+		jsonw_printf(jw, "%p", data);
 	else
-		jsonw_printf(jw, "%u", *(unsigned long *)data);
+		jsonw_printf(jw, "%lu", *(unsigned long *)data);
 }
 
 static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
@@ -216,7 +216,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 	switch (BTF_INT_ENCODING(*int_type)) {
 	case 0:
 		if (BTF_INT_BITS(*int_type) == 64)
-			jsonw_printf(jw, "%lu", *(__u64 *)data);
+			jsonw_printf(jw, "%llu", *(__u64 *)data);
 		else if (BTF_INT_BITS(*int_type) == 32)
 			jsonw_printf(jw, "%u", *(__u32 *)data);
 		else if (BTF_INT_BITS(*int_type) == 16)
@@ -229,7 +229,7 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 		break;
 	case BTF_INT_SIGNED:
 		if (BTF_INT_BITS(*int_type) == 64)
-			jsonw_printf(jw, "%ld", *(long long *)data);
+			jsonw_printf(jw, "%lld", *(long long *)data);
 		else if (BTF_INT_BITS(*int_type) == 32)
 			jsonw_printf(jw, "%d", *(int *)data);
 		else if (BTF_INT_BITS(*int_type) == 16)
-- 
2.17.1

