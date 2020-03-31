Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E0719932C
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 12:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgCaKLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 06:11:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41998 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729997AbgCaKLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 06:11:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id 22so10113577pfa.9;
        Tue, 31 Mar 2020 03:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=csmtkrkkAbdjV6T9mGVCcadIQKTYqskGmkUxceMKIBU=;
        b=R6Jg645Ekhoa+9H2sclU0mGXjw1I9gI37D5bmWOunwlXVWOR25umHenRIYpp5VvaVd
         zcA3dD5WcrTkmIDeWIXG9cRVYfS5MAOSg++iD5npWGxhH00bZ51t6HNM1V7+bU7v+V4d
         BlPpwQJam7d4Mx/9G0XPi0bcWuHY8VnFLLN84cKY8psXRhG/Ua7XxQjr/n/vdE8l6/ev
         urf1CVBCnex1NW02kG5+dhF15YKk5S7U23r8N5LZ762KzSgInxbV03Xov0coy+lNMP9V
         3vNTmOzRYrFDvE85WSzLBozbxDKMP3YoXBbU1vMatIQuEOzahWXSCShJPIpDcrEpUsqW
         jUWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=csmtkrkkAbdjV6T9mGVCcadIQKTYqskGmkUxceMKIBU=;
        b=r1aURfMTSoHPORz32+A44OBA2smnm70TzBt9rrdWD9A2wmWH/DnBn5HAzedANxYiQg
         2MklWS5iX37sddPy4+r+r9Ij6RrOFTzC+BA4kHILelLmcZ930cZ6WzgUwqulTCftf06q
         xyyyzkXbBMka/EsUgV5UO6EfMW6iL70wC4gBwFkLOFurvPL24sV81JvCHrG1rta9XUuO
         fuMsmcHK2LFDK9L1B1Q9m+i7/wWD5PnOaDTI+QYYpr9x3lF9siBOU8khGoUepO9KxQCX
         d0o0bP8v570tQnL8aAvtKJySrQQS87GbYOh4SPHF2mkugw+/gA5mG2b+lwmtDM/BoWHm
         rqeA==
X-Gm-Message-State: AGi0PuZih71Vdpx169ii4NIlSzZu5XP4tTz5Ss1LZwdndF1EViLCaSaE
        9PNYJ0ANdbrPt6UyAhqZz0VR1ndfVa8=
X-Google-Smtp-Source: APiQypKiHHBSPaH2cLzNzRTC2404m7jq5F7xMao/oPIuL6IzPYmJYJXDbFSpcE6XHhJFs9EXH2dnSg==
X-Received: by 2002:a63:f117:: with SMTP id f23mr3325427pgi.44.1585649460961;
        Tue, 31 Mar 2020 03:11:00 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id ck3sm1535258pjb.44.2020.03.31.03.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 03:11:00 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, Damien.LeMoal@wdc.com,
        hch@infradead.org, kbuild test robot <lkp@intel.com>
Subject: [PATCH bpf] riscv: remove BPF JIT for nommu builds
Date:   Tue, 31 Mar 2020 12:10:46 +0200
Message-Id: <20200331101046.23252-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF JIT fails to build for kernels configured to !MMU. Without an
MMU, the BPF JIT does not make much sense, therefore this patch
disables the JIT for nommu builds.

This was reported by the kbuild test robot:

   All errors (new ones prefixed by >>):

      arch/riscv/net/bpf_jit_comp64.c: In function 'bpf_jit_alloc_exec':
   >> arch/riscv/net/bpf_jit_comp64.c:1094:47: error: 'BPF_JIT_REGION_START' undeclared (first use in this function)
       1094 |  return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
            |                                               ^~~~~~~~~~~~~~~~~~~~
      arch/riscv/net/bpf_jit_comp64.c:1094:47: note: each undeclared identifier is reported only once for each function it appears in
   >> arch/riscv/net/bpf_jit_comp64.c:1095:9: error: 'BPF_JIT_REGION_END' undeclared (first use in this function)
       1095 |         BPF_JIT_REGION_END, GFP_KERNEL,
            |         ^~~~~~~~~~~~~~~~~~
      arch/riscv/net/bpf_jit_comp64.c:1098:1: warning: control reaches end of non-void function [-Wreturn-type]
       1098 | }
            | ^

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 8672e77a5b7a..bd35ac72fe24 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -55,7 +55,7 @@ config RISCV
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MMIOWB
 	select ARCH_HAS_DEBUG_VIRTUAL
-	select HAVE_EBPF_JIT
+	select HAVE_EBPF_JIT if MMU
 	select EDAC_SUPPORT
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
-- 
2.20.1

