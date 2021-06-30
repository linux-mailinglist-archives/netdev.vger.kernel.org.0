Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1E13B893A
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 21:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhF3Tne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 15:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhF3Tnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 15:43:33 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2E1C061756;
        Wed, 30 Jun 2021 12:41:04 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id g5so994727iox.11;
        Wed, 30 Jun 2021 12:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lkJQOGiwT+DGB6+eIh/APUPWuOaqVm+NgY9lIiOSbgc=;
        b=laziTJ5wKMko/fU+k9K3zBUSgTXZo2afuHDsgRIpmjOkyH5r+C4m7WzIzeesjfSBk/
         PWF7KbkVuUnhiSWG9Lp23mLjAAgvvelJBHWWEOWrKX0mmfbjy1ptkkJKyxipOoDND9+G
         HvWYdbabW8uKZNqjwZQgI+NhYHXMqIO5k5+9udEX5v2mchnS4sUm23AksOtv6nTAEAaU
         cO5icYgpyEXbVijw//VJt0YOFKy7KveH00L3HBHUlHXEUKqkQ7cQroAmgdcGMNGmEf/J
         ZPZO93MSDVd0ZYcm0YQRXl0t/CDclO4936LfNEyYcc9QGQ5p/OQu8OR/Edt9w8GOnRCz
         dEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lkJQOGiwT+DGB6+eIh/APUPWuOaqVm+NgY9lIiOSbgc=;
        b=nP8f+Mjl9gW0XiZTdp/HRofkWC6hzHpOO95R2qnHeFlzL/8jewmINh+wLT59snR3bX
         8xDbVB1XM7HSF+t2HwHukZW5O1DthZ2gIPHDYuI+cKwYq4qvJMDq+U8lIBCNgXtggUbA
         jyhEzH7lkuvWX5DOHkEAAsLTFitBOGwuJkIzIybVjQQIFYYWzB0bHmuscuUiPx3c2dmM
         ag5pRNadfQ3p2ytYHhOD7lh+4ii2mN1ZWRs1r0fFyAA0B9oGR7RAOirko1XhecwppHAN
         oFvTse/c4z7+UvolKTxde3DlWxCYSiLMFtXGvXeggx/rKYMQpGo3rYvwoIrAZar0gx62
         zaGQ==
X-Gm-Message-State: AOAM5334apkqHIekOUcIXfAWpRCpYTCWh5GYKW/Qi+wpX24LvckP0H+B
        7C+TFfwRzInRgbK7LEGHblg=
X-Google-Smtp-Source: ABdhPJy71U8CLIJNbFkD+02PQpqpZSqvJE1enxegE3+CIiiQJqF0AiJ+90F00npWoIJUWFLViq/aJw==
X-Received: by 2002:a05:6638:110e:: with SMTP id n14mr10250052jal.4.1625082064179;
        Wed, 30 Jun 2021 12:41:04 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id p9sm10977680iod.48.2021.06.30.12.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 12:41:03 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf 0/2] bpf, fix for subprogs with tailcalls
Date:   Wed, 30 Jun 2021 12:40:47 -0700
Message-Id: <20210630194049.46453-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes a use-after-free when using subprogs and tailcalls and adds
a test case to trigger the use-after-free.

John Fastabend (2):
  bpf: track subprog poke correctly, fix use-after-free
  bpf: selftest to verify mixing bpf2bpf calls and tailcalls with insn
    patch

 arch/x86/net/bpf_jit_comp.c                   |  4 ++
 include/linux/bpf.h                           |  1 +
 kernel/bpf/core.c                             |  7 +++-
 kernel/bpf/verifier.c                         | 39 ++++---------------
 .../selftests/bpf/prog_tests/tailcalls.c      | 36 ++++++++++++-----
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   | 21 +++++++++-
 6 files changed, 64 insertions(+), 44 deletions(-)

-- 
2.25.1

