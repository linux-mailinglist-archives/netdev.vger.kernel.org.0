Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B023A9609
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhFPJ2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhFPJ2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:28:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE2CC061574;
        Wed, 16 Jun 2021 02:25:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ei4so1355242pjb.3;
        Wed, 16 Jun 2021 02:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/9xGQO8bEJSD3PnDhwpHnxOTBaFCvCSJbindxsfiZw=;
        b=cqYMVEUzyCHeqTyPjis0S9wEpzmyYyaZNhGqFlYmSnXmGYUMRBom5WFyVGdsIAxRlz
         NhXM+HgtJcKHo+ZiHrPWD1VrWBPF+wUYRQhlW54hZvp1/y/gJK5d2i+ryREkBDcuDsKC
         NyOesSpGcRXxrsIvRQxpRFAvfFz2i5Tu53hypk7UnYL41g4lWiEWVK7d4W4/chJArXFI
         DN+fL61mKjGcUkNu7VOjJUUk3089QbA+QTu44j3yyGq9KywqgU0IMmMB+QtvzQid1blS
         hXyrsoG8jOMsKhJPrJK7yo06NCOgZ7w6vCionr2lSMdvd7xEkIGeiZkgWnrful/vWbK1
         /HHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/9xGQO8bEJSD3PnDhwpHnxOTBaFCvCSJbindxsfiZw=;
        b=sYqkdUy/Ih9W3KTpFSwToKdNAWAPNhSwT61LeEXzJdVb/4Ad7w7nRxSqUCPFhZlK0a
         J5QFXmFuv5G75MQ80f6VknNC96OWQu2TUoxzvDGlhMsP5nJMR5U0WXaUlY+V7HYR58GX
         X4+R3VGsDrgRox+rsTofD4TuZ4uSsDs13kskJGiMvqCVzmrVywzawgHpZn1UlaUpCNHz
         hc8vqWh5HCpv/r+/5gOQ4NJjKVuF1Umd1L4EVYPzrCVi71VwI3mMxXz1rnQiFkPxyQXX
         QMtOzdWZZ8D/v4FFHomCMIsV9x71PSrHREJnT73ME7qyc1uRtjqyD7UdnYFuw87CXqLY
         6Wtw==
X-Gm-Message-State: AOAM530DHHY77MEudjme41aXlgLD1GOh5Wvrdhwm+BgTaRGgrtpNt3dZ
        /H+4gfk2EIu/5fzD/0Y84eQ=
X-Google-Smtp-Source: ABdhPJwz92nn5rZLYDwjJn8FOxg5YEdc6jkiNzPn7acEjtBgL0BjFG2L8ovNY0sEKm9UJWuFFY5UYw==
X-Received: by 2002:a17:902:b409:b029:114:afa6:7f4a with SMTP id x9-20020a170902b409b0290114afa67f4amr8256903plr.56.1623835553152;
        Wed, 16 Jun 2021 02:25:53 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:513e:1f2f:e06c:5fb8])
        by smtp.gmail.com with ESMTPSA id x36sm1640842pfu.39.2021.06.16.02.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 02:25:52 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
Date:   Wed, 16 Jun 2021 02:25:21 -0700
Message-Id: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While patching the .BTF_ids section in vmlinux, resolve_btfids writes type
ids using host-native endianness, and relies on libelf for any required
translation when finally updating vmlinux. However, the default type of the
.BTF_ids section content is ELF_T_BYTE (i.e. unsigned char), and undergoes
no translation. This results in incorrect patched values if cross-compiling
to non-native endianness, and can manifest as kernel Oops and test failures
which are difficult to debug.

Explicitly set the type of patched data to ELF_T_WORD, allowing libelf to
transparently handle the endian conversions.

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
Cc: stable@vger.kernel.org # v5.10+
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/CAPGftE_eY-Zdi3wBcgDfkz_iOr1KF10n=9mJHm1_a_PykcsoeA@mail.gmail.com/
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
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

