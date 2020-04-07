Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B9A1A0741
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 08:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgDGG2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 02:28:53 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33279 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgDGG2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 02:28:53 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay1so867719plb.0;
        Mon, 06 Apr 2020 23:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FrRoXhNSt3kKGmz9fpJmBBjRUgYD6dko1gvPNj4Jml8=;
        b=k5x5caIulOUhWZIaZBmQbLuGn0wBl5m+FP0gRjo+kwY8yC5Tk5FZF5VWcvyMiO7GAv
         7JzU6XgqWcMmbwUkf5+M6Rwo4oWYdkojssyGpPQxeAlETIry/PINaUgAldfG+04GUgT7
         JQZeXJGC1TTq+QHP7h5Zd5EAt08GR16700xCLgSLa0Xa6XpXKTPteTeZ0k58jkEnAkVX
         4GhiFkcG3zp20igF3xKhL4BL49mNDfuD+qVd9mlAgbAMl+UnuBV6HNgtAYCTFOyMvZ29
         4edoC/hWATgum37iPDjtpTm2JSjWUuIBxYEB4MDzPemwLul1NJaKrb0jlUiRP2jLdJnA
         oGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FrRoXhNSt3kKGmz9fpJmBBjRUgYD6dko1gvPNj4Jml8=;
        b=CvGHoeCUIQwF3dxEBonYz1cPQjlZcZ3Y7wJSMd38bQHWAWPdPYqo5OTrgv9dVkDTzS
         ZrQRHgGnJRGuPFAnYGmn+5UVCs+3XRhb8T6+6SUj5EUpK4lYsW9TORCkNkP4EZBo0rhh
         oaJuHB2hBQStZyPlaFDJFT5zUsDMkBIiaeKuDUZ847VyFuaC5cLIsbxXh3iHstX58Yd7
         /dGuzrQD8roVaNIgsRC0iX91xyxArQETZQFkcz60H0+kkYfbBobiDLN7Evh2XxKa2kVV
         +oqGM4TlVA5kQw8r/BKGE08S87cz/HlHfwFLC1gJzGWwr3cyjEeyzZUUG+ynzABSTnPh
         yRLA==
X-Gm-Message-State: AGi0PuYyn4hFjys54pwbzIOVSsqRdK2qci0HCfe7dJQG/c3FN+HoiNbX
        tcJpXlsCq36GTaQnit9gsB0=
X-Google-Smtp-Source: APiQypLjjr2iwGDC7DK9g1lf1F6aMnklHVLnUIsQiPLBAhE2tpb4umeSh8nPm9b6pmVSlcYMv0Oh3A==
X-Received: by 2002:a17:902:7603:: with SMTP id k3mr1048685pll.100.1586240931879;
        Mon, 06 Apr 2020 23:28:51 -0700 (PDT)
Received: from dali.ht.sfc.keio.ac.jp (dali.ht.sfc.keio.ac.jp. [133.27.170.2])
        by smtp.gmail.com with ESMTPSA id v20sm12376925pgo.34.2020.04.06.23.28.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 06 Apr 2020 23:28:50 -0700 (PDT)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] libbpf: Make bpf/bpf_helpers.h self-contained
Date:   Tue,  7 Apr 2020 15:28:24 +0900
Message-Id: <1586240904-14176-1-git-send-email-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I tried to compile a bpf program including bpf_helpers.h, however it
resulted in failure as below:

  # clang -I./linux/tools/lib/ -I/lib/modules/$(uname -r)/build/include/ \
    -O2 -Wall -target bpf -emit-llvm -c bpf_prog.c -o bpf_prog.bc
  ...
  In file included from linux/tools/lib/bpf/bpf_helpers.h:5:
  linux/tools/lib/bpf/bpf_helper_defs.h:56:82: error: unknown type name '__u64'
  ...

This is because bpf_helpers.h depends on linux/types.h and it is not
self-contained. This has been like this long time, but since bpf_helpers.h
was moved from selftests private file to libbpf header file, IMO it 
should include linux/types.h by itself.

Fixes: e01a75c15969 ("libbpf: Move bpf_{helpers, helper_defs, endian, tracing}.h into libbpf")
Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 tools/lib/bpf/bpf_helpers.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index f69cc208778a..d9288e695eb1 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -2,6 +2,7 @@
 #ifndef __BPF_HELPERS__
 #define __BPF_HELPERS__
 
+#include <linux/types.h>
 #include "bpf_helper_defs.h"
 
 #define __uint(name, val) int (*name)[val]
-- 
2.24.1

