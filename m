Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792C13E83A3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhHJT1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhHJT13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:27:29 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91037C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:07 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id c3so199016ilh.3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sACdsDyDQsF4yV+XkTB5JJNrhLHQe5xnvwvES9nsAV4=;
        b=wvgoQqvLEvW82Em5I64QcTOdjmrmncOcgqsxT1p7oqQ2uHkKHTFqet7M2MLzmmnRpV
         QmLAajHimETprqe/kHTqxzgQFmWwqu6T8Qk/+2dOpEEaxMUHQTS34FYN1ee5c+7SHp/v
         5IkCwNJz+ZK3CuDbPh7nGdN+uihg2GV5OpC+X7PdJM4TTs3fnUccuOVXA9UYJlP5YnQT
         6nKijHQQBoGZ0pdeVEeVk6RdwN1WfC/f42+CiCNgTflDRww31xDtTu8Q6NvhRXXL7REa
         w3YGIOu0E5Wb2I50MweGiBG9oh9pM1iL4aBeC4Uvib+4gNFSw0pLWSV8oqy4ZP64mKeO
         sdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sACdsDyDQsF4yV+XkTB5JJNrhLHQe5xnvwvES9nsAV4=;
        b=AHZxm5fcr42zBxZ+0g729pLfHFFjoPT8rebu/fM6j46LDA+LlEH4z9aAi+9qnpSG1G
         qHYyILmOi1dIN0iQ2IWxO7GS5t1g9RD7cnJ9ivce5vE+64zE9VjN17Sl7ogL3FuQ77ZV
         81l5wsyz2RAJVgAonAPLJXYE4PY6uxgWNA1DUQBKlP0R1nvLfbEtd9VH+ZbJQTphS9ip
         gQDcSBJz3Jkek0TDUTQizHVnnCTV68SnVXBkVB7Nx+0ha1psRmbpucFpy73EX9yv6Bly
         RIKVV/O5PJaBVaKHAf5+NN57npnPqO40Sp5TX5gLpyXIHVUrDmBGlhp0oi7jRSyDT1Hu
         39Ww==
X-Gm-Message-State: AOAM5337dxVTAbCAxofHD6RLVQb9bnB2fy0sY2FUEm3ed6hSPXlqAFlP
        nJijYAqhxsX7/GZFaVvrgzB9Dw==
X-Google-Smtp-Source: ABdhPJzHjWzV7Xx6Ap9v7F7ay9mxep4UjReaCxW31U7PdzcI24t3JarrHyv2/gHKX/8dBbi3JGauyg==
X-Received: by 2002:a92:6e12:: with SMTP id j18mr671211ilc.243.1628623626983;
        Tue, 10 Aug 2021 12:27:06 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c5sm3025356ioz.25.2021.08.10.12.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 12:27:06 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] net: ipa: use runtime PM reference counting
Date:   Tue, 10 Aug 2021 14:26:57 -0500
Message-Id: <20210810192704.2476461-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series does further rework of the IPA clock code so that we
rely on some of the core runtime power management code (including
its referencing counting) instead.

The first patch makes ipa_clock_get() act like pm_runtime_get_sync().

The second patch makes system suspend occur regardless of the
current reference count value, which is again more like how the
runtime PM core code behaves.

The third patch creates functions to encapsulate all hardware
suspend and resume activity.  The fourth uses those functions as
the ->runtime_suspend and ->runtime_resume power callbacks.  With
that in place, ipa_clock_get() and ipa_clock_put() are changed to
use runtime PM get and put functions when needed.

The fifth patch eliminates an extra clock reference previously used
to control system suspend.  The sixth eliminates the "IPA clock"
reference count and mutex.

The final patch replaces the one call to ipa_clock_get_additional()
with a call to pm_runtime_get_if_active(), making the former
unnecessary.

					-Alec

Alex Elder (7):
  net: ipa: have ipa_clock_get() return a value
  net: ipa: disable clock in suspend
  net: ipa: resume in ipa_clock_get()
  net: ipa: use runtime PM core
  net: ipa: get rid of extra clock reference
  net: ipa: kill IPA clock reference count
  net: ipa: kill ipa_clock_get_additional()

 drivers/net/ipa/ipa_clock.c     | 165 +++++++++++---------------------
 drivers/net/ipa/ipa_clock.h     |  18 ++--
 drivers/net/ipa/ipa_interrupt.c |   9 +-
 drivers/net/ipa/ipa_main.c      |  35 +++----
 drivers/net/ipa/ipa_modem.c     |  15 ++-
 drivers/net/ipa/ipa_smp2p.c     |  33 ++++---
 drivers/net/ipa/ipa_uc.c        |  12 ++-
 7 files changed, 121 insertions(+), 166 deletions(-)

-- 
2.27.0

