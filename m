Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA69627BA14
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgI2Bfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbgI2BbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D622080A;
        Tue, 29 Sep 2020 01:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343068;
        bh=oKlU8FM28e6ANTU8QXRTYh2YZok5VQeYlfNAw6/iHw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rwqDYGXYaz6lFOnrwDQf8zKGv3XiP3ss3qXiQWlEXklIBL8WrG4TysqovkOXyvYyR
         Mjw83+d279/UKSOnGIUtpOhmIf0idANfr+GEwJGR2aJJAO0P3uE0p7eYbSD5trbZZO
         NzQxEGiB9Xk7TOWJulmm3vy8m9eyXkUtMO9hhhxE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/18] libbpf: Remove arch-specific include path in Makefile
Date:   Mon, 28 Sep 2020 21:30:48 -0400
Message-Id: <20200929013105.2406634-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013105.2406634-1-sashal@kernel.org>
References: <20200929013105.2406634-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

[ Upstream commit 21e9ba5373fc2cec608fd68301a1dbfd14df3172 ]

Ubuntu mainline builds for ppc64le are failing with the below error (*):
    CALL    /home/kernel/COD/linux/scripts/atomic/check-atomics.sh
    DESCEND  bpf/resolve_btfids

  Auto-detecting system features:
  ...                        libelf: [ [32mon[m  ]
  ...                          zlib: [ [32mon[m  ]
  ...                           bpf: [ [31mOFF[m ]

  BPF API too old
  make[6]: *** [Makefile:295: bpfdep] Error 1
  make[5]: *** [Makefile:54: /home/kernel/COD/linux/debian/build/build-generic/tools/bpf/resolve_btfids//libbpf.a] Error 2
  make[4]: *** [Makefile:71: bpf/resolve_btfids] Error 2
  make[3]: *** [/home/kernel/COD/linux/Makefile:1890: tools/bpf/resolve_btfids] Error 2
  make[2]: *** [/home/kernel/COD/linux/Makefile:335: __build_one_by_one] Error 2
  make[2]: Leaving directory '/home/kernel/COD/linux/debian/build/build-generic'
  make[1]: *** [Makefile:185: __sub-make] Error 2
  make[1]: Leaving directory '/home/kernel/COD/linux'

resolve_btfids needs to be build as a host binary and it needs libbpf.
However, libbpf Makefile hardcodes an include path utilizing $(ARCH).
This results in mixing of cross-architecture headers resulting in a
build failure.

The specific header include path doesn't seem necessary for a libbpf
build. Hence, remove the same.

(*) https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9-rc3/ppc64el/log

Reported-by: Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200902084246.1513055-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index d045707e7c9a4..283caeaaffc30 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -59,7 +59,7 @@ FEATURE_USER = .libbpf
 FEATURE_TESTS = libelf libelf-mmap bpf reallocarray cxx
 FEATURE_DISPLAY = libelf bpf
 
-INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(ARCH)/include/uapi -I$(srctree)/tools/include/uapi
+INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi
 FEATURE_CHECK_CFLAGS-bpf = $(INCLUDES)
 
 check_feat := 1
-- 
2.25.1

