Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013C1392D7
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfFGRL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:11:28 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36615 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730290AbfFGRL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 13:11:27 -0400
Received: by mail-qt1-f194.google.com with SMTP id u12so3130243qth.3
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 10:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wV65jHmXxXYwEI5deTNY6dp3x/XfRTRroK95qm1AXzw=;
        b=phJjV8OS/Kp6CZAQGOf/4k5LaQy3VZustLDdJD0AQb1n/CCV8y24sI7aYYBRCEILHr
         25JDQ38p0fV6t/Rgo4ONy91cN+lAriSRzMXmQCYP05GFkZ8o32V16etQUYZheNDqYPql
         jGcq3Rc6qETLpvjNQugy6zMNh15ymtjfajlCqP6MlrdXRe03qQqlno1uWWrs+xf/Dls3
         49hFvcCz2AIdCIW/2ZHClvE3DHz19JJRpDnSuEXnHq5gblorX0bKRIQooOPL0C6fZagM
         FfcrX+uc9YPb5IZNxLCF/0X9hc9rxb3NoaFN0PrWDBM0a9P8zp7DchwAjqHYAl5hCAKd
         OqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wV65jHmXxXYwEI5deTNY6dp3x/XfRTRroK95qm1AXzw=;
        b=cFjaK7m/9QsThMcyKX4zqdKoCte2l0L5Sn336dvKFOsOc9I9tz97+xHi5WMBTJ7FaI
         dI5dQ2PHh916cuyAGR4qW6s5Vso2cxzsbkv3uAMwi8CUIYmcBageXT1XFzSwoiYJoWNr
         i8Ip0YfhsBiCVUBtZ5k0Cx0jk04pbpfDBZQR3SYOEjBoNrod+6ouu4W9VDnYxEN0WX37
         4hbnV1n1Gn/EpzuH3yh874UB3rgRPtpswTfNuy9+cODPR6qayvaV69N9gGd5zAusJr5i
         f07o8CNGnrLjnI+O2DP4U+ZzMwfgWFv/bzNINXv6KqJfKxL2CkegIVaYYt6HlCvvforA
         E2wA==
X-Gm-Message-State: APjAAAVD4xWSWiDVlYP2FGS3iygZA9LlVendSm5ma6/EXstN2BC+cInK
        dumYm56cbcs+H7GAHpTlzQwrww==
X-Google-Smtp-Source: APXvYqwiGoCKNJb3ycGShjtp56s2py2nMCvyTEGRhup71swNyv6Vc3Rto1jSiFCFCEReFvSgE46JrA==
X-Received: by 2002:a0c:f78d:: with SMTP id s13mr24081609qvn.156.1559927486643;
        Fri, 07 Jun 2019 10:11:26 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 15sm1517893qtf.2.2019.06.07.10.11.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 10:11:25 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     oss-drivers@netronome.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next] samples: bpf: don't run probes at the local make stage
Date:   Fri,  7 Jun 2019 10:11:16 -0700
Message-Id: <20190607171116.19173-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin reports that commit 07c3bbdb1a9b ("samples: bpf: print
a warning about headers_install") is producing the false
positive when make is invoked locally, from the samples/bpf/
directory.

When make is run locally it hits the "all" target, which
will recursively invoke make through the full build system.

Speed up the "local" run which doesn't actually build anything,
and avoid false positives by skipping all the probes if not in
kbuild environment (cover both the new warning and the BTF
probes).

Reported-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 samples/bpf/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4074a66a70ca..9eb5d733f575 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -206,6 +206,8 @@ HOSTCC = $(CROSS_COMPILE)gcc
 CLANG_ARCH_ARGS = -target $(ARCH)
 endif
 
+# Don't evaluate probes and warnings if we need to run make recursively
+ifneq ($(src),)
 HDR_PROBE := $(shell echo "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
 	$(HOSTCC) $(KBUILD_HOSTCFLAGS) -x c - -o /dev/null 2>/dev/null && \
 	echo okay)
@@ -232,6 +234,7 @@ ifneq ($(and $(BTF_LLC_PROBE),$(BTF_PAHOLE_PROBE),$(BTF_OBJCOPY_PROBE)),)
 	DWARF2BTF = y
 endif
 endif
+endif
 
 # Trick to allow make to be run from this directory
 all:
-- 
2.21.0

