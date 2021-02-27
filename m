Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9033A326A9F
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhB0AHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhB0AHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 19:07:43 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923A9C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:07:03 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id d5so9567321iln.6
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OSmlNKAH65bzlnQXsk21f+18mG93Ep8ybFIZEp9s10U=;
        b=Zb2vsPMYmiEqTdjWpz46Iy4Guw0uZfsmTR8lWFEGzTskhLkQtwu7rX8BTJ61kA9XZP
         4P/tjGg6FpU88o3v9O6XvZrGDP4NtyxelZCvZ9Eu98a9eXgj/MY0A+4uAodEbKaA+cWJ
         po9s6C9FB1Vr+WYeAzAbOnsyinTTfofwEpQag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OSmlNKAH65bzlnQXsk21f+18mG93Ep8ybFIZEp9s10U=;
        b=pMYJy6kU6qd0Al2ygLpP2XkI3NBUUYcjW3BJwIBHGmFBnjT7w8EDjWlxU9pLeOT4Wy
         cZv8Ijq9sSYM9b4LWmL6SwBUVSWTmq5Y6onGpudgeYEuqOMljHXZc9Adppx0PHXNNErU
         lDcxThELw2aYrGIcTyeNPDY0BohnFZM70sZ4Xwh6rYlooiLhXBFElhAi1M7rUXVGxrTH
         +cpGVEKeTk/Poq3uyY8kln+5ZMJphJuxBARhISI4lXOYcpiiYjtaDhvCgIiHOJ5CxVfZ
         BaokV9NnkgsdNUfymSycneRdrxDspuPMMJauir1xc9Ne7zg3Nxm/Qse+HR42ZssLdgNM
         9zfQ==
X-Gm-Message-State: AOAM532WhY7FGLLyBeCZN2406xooObH6NZjaM/NzpaS23xkKeswvEeSn
        wEUKdkmAi8D+bCpYUmVdZbpcQA==
X-Google-Smtp-Source: ABdhPJweVmTRywkMYBz2Qghux6InHjNKdPGIkkwPvC9/BRfhxBjqwSHM4Pnp6/Rz/easnQEPe+Li/w==
X-Received: by 2002:a92:4412:: with SMTP id r18mr4455803ila.170.1614384422849;
        Fri, 26 Feb 2021 16:07:02 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w16sm5228805ilh.35.2021.02.26.16.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 16:07:02 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] Add lockdep_assert_not_held()
Date:   Fri, 26 Feb 2021 17:06:57 -0700
Message-Id: <cover.1614383025.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some kernel functions must not be called holding a specific lock. Doing
so could lead to locking problems. Currently these routines call
lock_is_held() to check for lock hold followed by WARN_ON.

Adding a common lockdep interface will help reduce the duplication of this
logic in the rest of the kernel.

Add lockdep_assert_not_held() to be used in these functions to detect
incorrect calls while holding a lock.

lockdep_assert_not_held() provides the opposite functionality of
lockdep_assert_held() which is used to assert calls that require
holding a specific lock.

The need for lockdep_assert_not_held() came up in a discussion on
ath10k patch. ath10k_drain_tx() and i915_vma_pin_ww() are examples
of functions that can use lockdep_assert_not_held().

Link: https://lore.kernel.org/lkml/37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org/
Link: https://lore.kernel.org/linux-wireless/871rdmu9z9.fsf@codeaurora.org/

This patch series adds lockdep_assert_not_held() and uses it in the
second patch in ath10k_drain_tx() function.

Changes since v2:
-- Fixed coding style issues
-- Patch 2 uses new lock states in __lock_is_held() and
   lock_is_held_type

Patch 1 incorporates suggestions from Peter Zijlstra on v1 series
to avoid misfires when lockdep_off() is employed.

Patch 2 Johannes Berg's suggestions as it make it easier to read and
maintain the lock states. These are defines and a enum to avoid changes
to lock_is_held_type() and lockdep_is_held() return types.

Patch 2 is a separate patch because it adds defines to lockdep.h and
kernel/locking/lockdep.c now includes lockdep.h - decided make this
a separate patch just in case issues related to header dependencies
pop up. I can combine Patches 1&2 if that is preferred.

Patch 3 uses the new interface in ath10k_drain_tx() function. Added
Kalle Valo's Ack from v1 for this change.

Tested on the mainline from yesterday.

Shuah Khan (3):
  lockdep: add lockdep_assert_not_held()
  lockdep: add lockdep lock state defines
  ath10k: detect conf_mutex held ath10k_drain_tx() calls

 drivers/net/wireless/ath/ath10k/mac.c |  2 ++
 include/linux/lockdep.h               | 18 +++++++++++++++---
 kernel/locking/lockdep.c              | 15 ++++++++++-----
 3 files changed, 27 insertions(+), 8 deletions(-)

-- 
2.27.0

