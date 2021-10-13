Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA28342C38E
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhJMOlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235971AbhJMOle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:41:34 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C17C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:39:31 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g10so11268350edj.1
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 07:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Xr4QlVVMXPSmrbTmLyTDQF4srJ+z80CGj21V4jrf3LQ=;
        b=G4L/5u+x+y++eBSDwdARPefhZBGwvEWeGgj5wl142+n4KDhHLGjEIUjssXVpmCHxat
         RYe7zCHQ50Acj6JYXQ2jJs9mdvSFywUsh5ivTdmT/hJkuuMaxtdRdYuft+0hIbP4XnUC
         OgIbcG1bZhRZaCRySIDURPXhZPN70ip3bsjuflkiWKv3nAfMtk5GRHKJOn2R8MxHWswc
         CpqhaxSzrhz9cHWsa3c4+0PMIqIIwsGlz1K3Iq5knoYX5ImX4RxFQ9OtSYybFtRIYx5T
         rCS0lRLK9wag+g2kH/Mhh7POaFLgeHoA31ToxPODLukts26LCdvzgbkcchqBVfxZiTva
         BNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Xr4QlVVMXPSmrbTmLyTDQF4srJ+z80CGj21V4jrf3LQ=;
        b=Q2vaIhpbW1CzM4ifhcH/5f2h23njFPq0K1cxtH3b2UPkABWJKWrtiGHvO+GInW7nB/
         3w7E46uxAzOoBY3HNej1bQrw+drM2P4seKeaKegdbSZuHvbdORF5NnSdFz2p1rHyQIcF
         XuNcPE6KBYNJio1zJV07kVvO7O89ke2wvLSQVzFa9mE9SVqs2d4sWgQHhXn2z80EIPvc
         bZLGm1HrHJaOKBOx3+6ncB/CiukBZhNFMa1TnxDr147qP0s27IaM49/c0VuppCG7YYQN
         OukbkWW5xb+qtvFzx+7Alc8517/Sh6Kc8eBiCIV9pDag6lB/P++tR25ZJV2BsgYRoCsp
         zG1w==
X-Gm-Message-State: AOAM530yJyUDpefq3HZft47X0kuJiDagjtAbRal9dggTeIkpa1kdwTe6
        kLI9VBskm5RTIHP6kpdHzLvrGGPiuAitfjo=
X-Google-Smtp-Source: ABdhPJysZobK/qwjrnLG+wOBoyoA4rCH8vmE+InH1sssEbm/5w8C5SRygi9dFf/+yK2sAnyfcI1kOQ==
X-Received: by 2002:a05:6402:7:: with SMTP id d7mr10321435edu.265.1634135969962;
        Wed, 13 Oct 2021 07:39:29 -0700 (PDT)
Received: from Mem ([2a02:a210:a823:400:b40d:eaab:5cbd:ab7b])
        by smtp.gmail.com with ESMTPSA id l23sm6966455ejn.15.2021.10.13.07.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 07:39:29 -0700 (PDT)
Date:   Wed, 13 Oct 2021 16:39:27 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2] lib/bpf: fix map-in-map creation without
 prepopulation
Message-ID: <20211013143927.GA38205@Mem>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating map-in-maps, the outer map can be prepopulated using the
inner_idx field of inner maps. That field defines the index of the inner
map in the outer map. It is ignored if set to -1.

Commit 6d61a2b55799 ("lib: add libbpf support") however started using
that field to identify inner maps. While iterating over all maps looking
for inner maps, maps with inner_idx set to -1 are erroneously skipped.
As a result, trying to create a map-in-map with prepopulation disabled
fails because the inner_id of the outer map is not correctly set.

This bug can be observed with strace -ebpf (notice the zero inner_map_fd
for the outer map creation):

    bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_ARRAY, key_size=4, value_size=130996, max_entries=1, map_flags=0, inner_map_fd=0, map_name="maglev_inner", map_ifindex=0, btf_fd=0, btf_key_type_id=0, btf_value_type_id=0}, 128) = 32
    bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_HASH_OF_MAPS, key_size=2, value_size=4, max_entries=65536, map_flags=BPF_F_NO_PREALLOC, inner_map_fd=0, map_name="maglev_outer", map_ifindex=0, btf_fd=0, btf_key_type_id=0, btf_value_type_id=0}, 128) = -1 EINVAL (Invalid argument)

Fixes: 6d61a2b55799 ("lib: add libbpf support")
Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 lib/bpf_legacy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 275941dd..23854f17 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -3287,8 +3287,7 @@ bool iproute2_is_map_in_map(const char *libbpf_map_name, struct bpf_elf_map *ima
 			continue;
 
 		if (!ctx->maps[i].id ||
-		    ctx->maps[i].inner_id ||
-		    ctx->maps[i].inner_idx == -1)
+		    ctx->maps[i].inner_id)
 			continue;
 
 		*imap = ctx->maps[i];
-- 
2.25.1

