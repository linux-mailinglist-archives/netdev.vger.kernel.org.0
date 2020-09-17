Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EE626E31E
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgIQSB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgIQRjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:39:32 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819AEC061797
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:31 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id j2so3127855ioj.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ZxAUcAmt6npTzXXqhjeGo2zTumi5Cj+Gk+e9dSx3UM=;
        b=cShgdx+JpWGQOxPqOVDTlma/AMvctg37njScDQ5XzSxzgIIimXiwGWPSI03EJxaIPj
         LX/9UKfkW/hSE0dxk70r3/CbNRUbVVc/1gIIRJ92pRk/yjrw/7fcY2mCO7dWlhcLRNEY
         LD8ZQZQpIln1joA2lEXC18vgLW0kTatul0Q3PUdy9H60ZEjzZChTHOBmyolPoR3WnRuA
         Ea3F3zinJ5ruO4J6csoTMHxxAM2TEQgAUeRe4w8bTVW9MKAEVvtRK+EHE7Qbou39Rtmi
         in/ATnGVmAbpQZPSxerSlarCL6ASTbeeznRn93R9t9WafZLwVrt/hmNTxx2fGQ3NJ1mv
         H2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ZxAUcAmt6npTzXXqhjeGo2zTumi5Cj+Gk+e9dSx3UM=;
        b=pRBSdbBpbPachuX9JsE8SxRpGpe3MKi1eJRiBc7tz4OySPZZny9tfbIyWvoJUoHyBg
         8ENUh3im/ZvtQ9BcCYx9Xk4sTb7ZnRfxqosBEdokJr9JsBP6bA7Ty0cTqsN7aXnPNF6J
         cTuVE6QJqM/muyCIQZtTRW2TeTdAGl/rIHV8XJcO1IQ8dckkgFKSF6KvvYhrrkHpVo6n
         cydH/GTTT8pqi2neEHo7oh6qnALc7D0TJFsQ/pmtR58PQTScDvoPQMtEDWz/m1TbMIHs
         BRvArYc3pxiUZQdnGXW8tZw7+FqCNUFjHgxwELiszA8WfSRO2BADhDoOjcbuXd74psR6
         JVuA==
X-Gm-Message-State: AOAM531ed4rn05Cn47HLB6sUu1nkWxEr57UheVvSJ5PTWRsiPOvYxLfG
        x/J06LMHVbdmOX61pqTX4gidZg==
X-Google-Smtp-Source: ABdhPJypMoW15gdVtEqB9xDXyHPrAfTthEFyW2SbFOwrIMod4BCI0p/Av/DlgxXkEyfSCsGOnx2d/g==
X-Received: by 2002:a6b:b7cf:: with SMTP id h198mr24360700iof.55.1600364370637;
        Thu, 17 Sep 2020 10:39:30 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l6sm192725ilt.34.2020.09.17.10.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:39:29 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/7] net: ipa: wake up system on RX available
Date:   Thu, 17 Sep 2020 12:39:19 -0500
Message-Id: <20200917173926.24266-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series arranges for the IPA driver to wake up a suspended
system if the IPA hardware has a packet to deliver to the AP.

Version 2 replaced the first patch from version 1 with three
patches, in response to David Miller's feedback.  And based on
Bjorn Andersson's feedback on version 2, this version reworks
the tracking of IPA clock references.  As a result, we no
longer need a flag to determine whether a "don't' suspend" clock
reference is held (though an bit in a bitmask is still used for
a different purpose).

In summary:
    - A refcount_t is used to track IPA clock references where an
      atomic_t was previously used.  (This may go away soon as well,
      with upcoming work to implement runtime PM.)
    - We no longer track whether a special reference has been taken
      to avoid suspending IPA.
    - A bit in a bitmask is used to ensure we only trigger a system
      resume once per system suspend.
And from the original series:
    - Suspending endpoints only occurs when suspending the driver,
      not when dropping the last clock reference.  Resuming
      endpoints is also disconnected from starting the clock.
    - The IPA SUSPEND interrupt is now a wakeup interrupt.  If it
      fires, it schedules a system resume operation.
    - The GSI interrupt is no longer a wakeup interrupt.

					-Alex

Alex Elder (7):
  net: ipa: use refcount_t for IPA clock reference count
  net: ipa: replace ipa->suspend_ref with a flag bit
  net: ipa: manage endpoints separate from clock
  net: ipa: use device_init_wakeup()
  net: ipa: repurpose CLOCK_HELD flag
  net: ipa: enable wakeup on IPA interrupt
  net: ipa: do not enable GSI interrupt for wakeup

 drivers/net/ipa/gsi.c           | 17 +++------
 drivers/net/ipa/gsi.h           |  1 -
 drivers/net/ipa/ipa.h           | 16 ++++++---
 drivers/net/ipa/ipa_clock.c     | 28 ++++++---------
 drivers/net/ipa/ipa_interrupt.c | 14 ++++++++
 drivers/net/ipa/ipa_main.c      | 64 +++++++++++++++++----------------
 6 files changed, 74 insertions(+), 66 deletions(-)

-- 
2.20.1

