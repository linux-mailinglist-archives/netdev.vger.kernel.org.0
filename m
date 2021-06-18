Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8026A3AC32A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 08:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhFRGQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 02:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbhFRGQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 02:16:50 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D138C061574;
        Thu, 17 Jun 2021 23:14:42 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o21so4141063pll.6;
        Thu, 17 Jun 2021 23:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tZzDh0cilBRIFVtsjTfkPJ4Ams+KhjOfr0u5GSYffMU=;
        b=IhntsiIG4ttkSAz4oCUj8AajSpZZV4RFr5J9FmqI0zuieAmfYCXdo+cg5ISVjuOA20
         K5ciskAEH8rX8DQwC93nSvDqXJSW8sJngSUCN039H5Zzx75C6CsqWAPJ7cpTMt5dZvuW
         3LkrPG189bEfk6sfFNKnrdbbXZyNCYlhFtZ9fmnyiaILeGUn71wD5WppgSOAaLKgL9dG
         RVvxBXdC8VB/qcMSiAPkOvzRfBlgRVaT0Ky+F5b9SdwI3N5Yw1xWVEl4Rd/ONUhyCOMx
         GXTTvIIzVYXQ6CPcVIQ3bDLRSmBT3IFAhCgDUfE32WE1L99k63Z+AFyzM8rvdFBr4sgE
         2HOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tZzDh0cilBRIFVtsjTfkPJ4Ams+KhjOfr0u5GSYffMU=;
        b=Q6571qx/y0sZf3OffznnrlbZcAjGd6XWXaLv2tzlbUR4UpJ03V5/ULg/xDodx1lFN5
         lr7Q94yiXVWXWtg2MiwGPdS6AqXj4abfgSXpSwaN3ayGtjZ8iyt3CE+GxsDIlHF4Zntt
         8QW17fjF7b2g5kcjJABaoXSprZZrSUAYqZYN7BM93rEzII14X7OdzWgJpWz0qI0/RnEW
         fxaS1eHq8CTMMyIscrNaFR74LuuDEXfv7/khjZvaTWpjyAWOkdaq5VwHLKWEtRlBHGVS
         RhQg8p9Lw2lJltfjIqYL6b8xqtVJCCvg1GzCnL34cUhwo0Aaz/5tx5jbVlD1MBFBtfE0
         T4aA==
X-Gm-Message-State: AOAM531J7DM9/R5Bhc4DxAk3rhF09L1+mP2MnnDn4UKHFYqSHKsmIsvO
        hRncov/B6Vgjv3ak1uL+BM0=
X-Google-Smtp-Source: ABdhPJyG9F+P3nC94n7aSBkIaafjWob6oyt+eqbHZIdKyn9lssYRmLrvLdo6fQLbQdbywwuCFVETYg==
X-Received: by 2002:a17:90a:19c6:: with SMTP id 6mr9393454pjj.125.1623996881696;
        Thu, 17 Jun 2021 23:14:41 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:9d34:ce8a:7ace:b692])
        by smtp.gmail.com with ESMTPSA id v69sm695509pfc.18.2021.06.17.23.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 23:14:41 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        stable@vger.kernel.org, Frank Eigler <fche@redhat.com>,
        Mark Wielaard <mark@klomp.org>, Jiri Olsa <jolsa@kernel.org>,
        Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH bpf v2] bpf: fix libelf endian handling in resolv_btfids
Date:   Thu, 17 Jun 2021 23:14:04 -0700
Message-Id: <20210618061404.818569-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vmlinux ".BTF_ids" ELF section is declared in btf_ids.h to hold a list
of zero-filled BTF IDs, which is then patched at link-time with correct
values by resolv_btfids. The section is flagged as "allocable" to preclude
compression, but notably the section contents (BTF IDs) are untyped.

When patching the BTF IDs, resolve_btfids writes in host-native endianness
and relies on libelf for any required translation on reading and updating
vmlinux. However, since the type of the .BTF_ids section content defaults
to ELF_T_BYTE (i.e. unsigned char), no translation occurs. This results in
incorrect patched values when cross-compiling to non-native endianness,
and can manifest as kernel Oops and test failures which are difficult to
troubleshoot [1].

Explicitly set the type of patched data to ELF_T_WORD, the architecture-
neutral ELF type corresponding to the u32 BTF IDs. This enables libelf to
transparently perform any needed endian conversions.

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
Cc: stable@vger.kernel.org # v5.10+
Cc: Frank Eigler <fche@redhat.com>
Cc: Mark Wielaard <mark@klomp.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Link: [1] https://lore.kernel.org/bpf/CAPGftE_eY-Zdi3wBcgDfkz_iOr1KF10n=9mJHm1_a_PykcsoeA@mail.gmail.com/
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
---
v1 -> v2:
 * add context and elaborate on commit message per request
 * include ACK from Jiri Olsa
---
 tools/bpf/resolve_btfids/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index d636643ddd35..f32c059fbfb4 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -649,6 +649,9 @@ static int symbols_patch(struct object *obj)
 	if (sets_patch(obj))
 		return -1;
 
+	/* Set type to ensure endian translation occurs. */
+	obj->efile.idlist->d_type = ELF_T_WORD;
+
 	elf_flagdata(obj->efile.idlist, ELF_C_SET, ELF_F_DIRTY);
 
 	err = elf_update(obj->efile.elf, ELF_C_WRITE);
-- 
2.25.1

