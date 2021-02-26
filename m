Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A2B326682
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 18:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhBZRxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 12:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhBZRw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 12:52:58 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80C5C061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 09:52:18 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id q5so8712739ilc.10
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 09:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dY88CmhEdqi8wt/ahIMuuDlu90hzE7DFVh5FsuKso0s=;
        b=GEozSIwSQMHght7BICfIen1ZuqO1Uu8LnD6oos4DAN9zjNzl+T9of+vQKxslcE2Bjl
         B+55kRiyHRj05v6DxQbsCcajyLUzb5WsFfKr2roMoSzknE6EsZ/a5Yc++mYmoMWZoxEj
         pCBOx2bG1l70JBbuNroc8ck/XWt9UWsOLppl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dY88CmhEdqi8wt/ahIMuuDlu90hzE7DFVh5FsuKso0s=;
        b=T1UPRLbaLZQ4CVRsThQwaT9M76z3HUJoFJk6HuvoukXc5vMVx1EPs/yB5+buMtCTdm
         DthzMVIFAxivMMwy1xHAGZYPTWX8qwi7FXUKH7Nz7lH+cgIcSaZKyRlJ9ONpFmWJ2u2b
         eNYoqZ5gtiLGzwFEiieMeiKNfd8JPG2rfb3dZ/I79C6uLzZ9Mtf6OYgMHXoTvVO6zSHA
         5bwY/cN7fs9XOfVtPAzc00YNsGsMoSqT2LFJ+bn50kweiwxJwAgsSP+AM5MSjX7eYK7/
         C3oCxkdbnQDGP+CUUNu6wHYPL7HXPn8U/8lmqjjcQ6AMHdtVIeodWFWgE3FjXiOrOvCD
         +3wQ==
X-Gm-Message-State: AOAM533uMc36yANGiK6MijXMBc42ysEn9j7BrFkmKo3La9yaZkQm5jW7
        6HNg+dluUhgsRTQc18AFKZls6oQJnaeFVQ==
X-Google-Smtp-Source: ABdhPJyk6Fd7CHK3TK6ZvIe6aA/9gQV5HhrgT8cwxOjO3hwk/x87J2J5g+K3jvzjCy1GS3+/u9qmFg==
X-Received: by 2002:a05:6e02:881:: with SMTP id z1mr3371733ils.288.1614361938177;
        Fri, 26 Feb 2021 09:52:18 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y25sm5594060ioa.5.2021.02.26.09.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 09:52:17 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Add lockdep_assert_not_held()
Date:   Fri, 26 Feb 2021 10:52:12 -0700
Message-Id: <cover.1614355914.git.skhan@linuxfoundation.org>
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
 kernel/locking/lockdep.c              |  6 +++++-
 3 files changed, 22 insertions(+), 4 deletions(-)

-- 
2.27.0

