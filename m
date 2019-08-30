Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB430A2BDC
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfH3Auo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:50:44 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38006 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfH3Aun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:50:43 -0400
Received: by mail-lj1-f196.google.com with SMTP id x3so4817569lji.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xMuXLxwuJeSWopT/f8dXFbI5jVuji3StpvlKwxHupj4=;
        b=rnr4X0TQdkwszhW4r53DgSGbfSyqjshLRLQ9ru9r0hiQjF6Pmzl6cFSGIXGZDyX8FM
         kO4l69Gy3FILbmNq5bSUGsIpaZ9XaIHD/+YK6HPdgABmplST2YZNTLJo9RawuaCo+ute
         7rBOt9fScpmIQdED0bS9ysnX6D/5oXmASshjL3akOMkCpUlDb0m3RuUipo7CfFf44g5O
         NT/ccLrrYb5iZAFECZ3wB98QbOk+AWPIlhlBT8BwE0+tWyGIst3jCLaW5eI5KnWey2hK
         qT8PWkNXjiYDmWcUscqudRpRLzArq1rvEq/ytQzRBj7ZXjV1OCAHSjD94QTSqLHQkDUW
         ogiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xMuXLxwuJeSWopT/f8dXFbI5jVuji3StpvlKwxHupj4=;
        b=Qe2gyCJeJqoW9DgaezKAzNthjrX4UYdYIjMDCVbFSvwFQkYf6o3A+QsB4ySd8iDOtT
         jXfEbEY2VP7MJYYX34cYeCTreCY9mjF0BYRmyc+cyaBV2h3G+pYpJ33mmNlcnIvo52Sl
         AcKpyTljO2JKH4ERT57V/syf3RX61wbv71rnxIKQ28WiLSqqKEKh6Kjeco/8nkDUX3fd
         JRp/61C4Q8zM2Dk2DtCTumYWpsj5Dvcq25WKuO7NpKHvBqiNpJisqUh/shmBXPg7sWdT
         z82l39Unw5cm8IWzUrvVEE++XZlCi4PPM6zAGNHDUj78hEZVPSH9iHlgu07hlamIyfGn
         e3BA==
X-Gm-Message-State: APjAAAVGXzFGlUkLK80zXQWA5VOKWYmoSkDmRpsICmcex4+SmBhWJlO5
        UGAHbDhvf0dNT2+yKQOxubzkEQ==
X-Google-Smtp-Source: APXvYqxL710fHxqeBsIPyilVGaM4NIUyDBx68X3IEtdE/LKXFPKtMM8GtBcX4pfo/aWdd1ZNaV62/g==
X-Received: by 2002:a2e:9d9a:: with SMTP id c26mr7203774ljj.56.1567126241817;
        Thu, 29 Aug 2019 17:50:41 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id f19sm628149lfk.43.2019.08.29.17.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:50:41 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     linux@armlinux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH RFC bpf-next 00/10] improve/fix cross-compilation for bpf samples
Date:   Fri, 30 Aug 2019 03:50:27 +0300
Message-Id: <20190830005037.24004-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains mainly fixes/improvements for cross-compilation
(also verified on native platform build), tested on arm, but intended
for any arch.

The several patches are related to llvm clang and should be out of this
series or even fixed in another way, and here just to get comments:
  arm: include: asm: swab: mask rev16 instruction for clang
  arm: include: asm: unified: mask .syntax unified for clang

Also, only for armv7, there is one more problem related to long and
void type sizes for 32 bits, while the BPF LLVM back end still
operates in 64 bit, but that's another story.

Smth related not only for cross-compilation and can have impact on other
archs and build environments, so might be good idea to verify it in order
to add appropriate changes, some warn options can be tuned, so comment.

Ivan Khoronzhuk (10):
  samples: bpf: Makefile: use --target from cross-compile
  samples: bpf: Makefile: remove target for native build
  libbpf: Makefile: add C/CXX/LDFLAGS to libbpf.so and test_libpf
    targets
  samples: bpf: use own EXTRA_CFLAGS for clang commands
  samples: bpf: Makefile: use vars from KBUILD_CFLAGS to handle linux
    headers
  samples: bpf: makefile: fix HDR_PROBE
  samples: bpf: add makefile.prog for separate CC build
  samples: bpf: Makefile: base progs build on Makefile.progs
  arm: include: asm: swab: mask rev16 instruction for clang
  arm: include: asm: unified: mask .syntax unified for clang

 arch/arm/include/asm/swab.h    |   3 +
 arch/arm/include/asm/unified.h |   6 +-
 samples/bpf/Makefile           | 177 +++++++++++++++++++--------------
 samples/bpf/Makefile.prog      |  77 ++++++++++++++
 samples/bpf/README.rst         |   7 ++
 tools/lib/bpf/Makefile         |  11 +-
 6 files changed, 205 insertions(+), 76 deletions(-)
 create mode 100644 samples/bpf/Makefile.prog

-- 
2.17.1

