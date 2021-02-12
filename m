Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3230D31A853
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhBLX3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbhBLX31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 18:29:27 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B76DC061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:28:47 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p132so885960iod.11
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ly2pdmyYXxhtuoCSAgENg5OM8ycLhypf9tqgVFI+2u4=;
        b=Quwx0P+JxiRRGABjyX8i1pZUR+H9o5Hl34uy0BwJ7eFj4lvVU96Vykv/nM2Dydp3ML
         G/yDWtiOunz2xOr0YULsBP7PFBcOIt5N6bt2iOF78QXuanm0WPWyH/bvm4HAXhjJWllG
         nDCORLO4+L50RQF0iD9IeL2GARF74lzgtxyaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ly2pdmyYXxhtuoCSAgENg5OM8ycLhypf9tqgVFI+2u4=;
        b=ULlB8HM6UeFeywZ+6dxdnyLcFSpMStM0OTcp/dXE3mWKwcvGbnci9Bsa+UfcXNesNX
         fuMc/nw8/Vm0D+QpeqzT3tTr3DkIcB+nE96Dd5L4iiSj4W6awfkQ66xw3HFSSdsO7vjW
         CxQhPMuxNI9bAgRyB+6ApsKESFbBPyBN9UmzdK1YdJ7rDKgj70Pqafh/wN2ZXzFpstot
         1OHUIZKQBc0dfu4d2UqtTHRgXK7cbWy7WqGd4D3W57YQJ3+1OPBZdf2MGVPHa6WvLgVC
         rFhFwnUydg6en4lKIu1Qa0SoRqStSHSWwVmgkPutRIgQaWrKwrzzKddZrQ6X1Vc1XqbM
         WYQg==
X-Gm-Message-State: AOAM532w8jvXqbv5wrcX5HR7NW/pHmZTxcajKA8079Gx6EBdpIXEtsPP
        /I9XJeuILxYAHvCT1tfdrz/A7A==
X-Google-Smtp-Source: ABdhPJx5/tVjrSIJi6dtsF0msO8kox5c0tpNk2scRoWwMHOQysCBrTJMjAFHSVV4uHQd7THpyBdRHA==
X-Received: by 2002:a02:9042:: with SMTP id y2mr4808243jaf.94.1613172526761;
        Fri, 12 Feb 2021 15:28:46 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i20sm5180328ilc.2.2021.02.12.15.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 15:28:46 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add lockdep_assert_not_held()
Date:   Fri, 12 Feb 2021 16:28:41 -0700
Message-Id: <cover.1613171185.git.skhan@linuxfoundation.org>
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

Link: https://lore.kernel.org/linux-wireless/871rdmu9z9.fsf@codeaurora.org/

This patch series adds lockdep_assert_not_held() and uses it in the
second patch in ath10k_drain_tx() function.

Shuah Khan (2):
  lockdep: add lockdep_assert_not_held()
  ath10k: detect conf_mutex held ath10k_drain_tx() calls

 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 include/linux/lockdep.h               | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

-- 
2.27.0

