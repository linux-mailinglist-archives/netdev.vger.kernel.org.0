Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123322EE7BE
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbhAGVoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGVoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 16:44:10 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1016C0612F6
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 13:43:29 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id w17so8171213ilj.8
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 13:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJ4v45NoIZ+t1M1C1eHleEMvQbIjZTEYVfq//dDizkw=;
        b=EQU3k60PvNiGGG7GPIgzpKNA/pxjiUJ19/U+90uG1U+JWM1AU52EV5T1AEIRGId6lI
         5JtApHQedmgEq8iJTLJrvsaMKF/ipq+A7VAiw6yMzmzBEaz0DsQfp4BgwO8DPSKd+e5/
         3JTngG+kGTwf/JQF6uYyGPFqa3pHj99Bidmbs+wKigvQnt6CS3L8YYS86U/AU7bdv+9L
         uhECRwxZuBnTQ1BwUrjiKvnNrvXSmIiqQwYlQitlMf1jJKuefXbO4Cryc7mDFoC8y4Ha
         LSXSO1EvZfDO1CK5Tdm3Zk2tHr8MrRSprj8yW7qvcdpPpMfg3bh2fkgyFwSrpibRaBPb
         KTuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJ4v45NoIZ+t1M1C1eHleEMvQbIjZTEYVfq//dDizkw=;
        b=buP1vbI9jE0ioxbBS04yifSE+yhRjJ9GSlZ/bFRNjpLyf/VDfpstuogf5SEFRZtKB/
         b/uON5LfjDg+udSXuvluWa/dU9RVg/WgXStaJSqJIiKeqyEQwabt4z2oxBfOyu5dE0+A
         6iG2AjeDCV8PQ+HDAmHYgyYAifGkeYdCSs9bEu9BI/z+F0PUfYWikEIMUg8CbvkYLtSk
         hd3aU4paZkJVb5xGsjziOMmshjdP/7Wd5OudADLoAZzYoz7MIvxBaYpunMfHq5XZ0j7n
         ErpjxLH5Qd2bnt1X8jqHo/EzQ9qOAiIejIW1XRgL4PN4NwLdZm8CZvbfoeoFO0CmvFnT
         Nfpg==
X-Gm-Message-State: AOAM533aXaxTX5CIfF57AZu9OLyfH7r7Mzy7HGvKwMBuhATFQZ7n3HrG
        r8a8uyGE09mTHP3Zbppio7Zr0Q==
X-Google-Smtp-Source: ABdhPJwzeb220It6gmQeLbWKNHQwLJQyt9s/3fSdsC0Kr4fcw9s1ZxgCLHedhMJoJ+M1g/oBGUgfhw==
X-Received: by 2002:a92:d348:: with SMTP id a8mr824917ilh.255.1610055809270;
        Thu, 07 Jan 2021 13:43:29 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f10sm5218260ilq.64.2021.01.07.13.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:43:28 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: ipa: fix a suspend hang
Date:   Thu,  7 Jan 2021 15:43:23 -0600
Message-Id: <20210107214325.7077-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPA driver's PM suspend callback stops all channels, and its
resume callback restarts them again.  Part of stopping a channel is
disabling NAPI and disabling its I/O completion interrupt.

When stopping a channel, the IPA driver currently disables NAPI
before disabling the interrupt.  It also re-enables interrupts
before re-enabling NAPI.  The interrupt handler can therefore be
called while NAPI is disabled.

If the interrupt signaling a transfer completion occurs while NAPI
is disabled, NAPI polling will not be scheduled to process that
completion.  That processing will be delayed, occuring only when a
subsequent interrupt schedules NAPI polling when NAPI is enabled
again.

The second patch in this series reorders the NAPI and interrupt
control calls.  The completion interrupt is disabled before NAPI
when stopping a channel, and re-enabled after NAPI when starting.
This way polling to handle the completion of a transfer can begin
immediately when handling its interrupt.  And if a completion occurs
while the interrupt is disabled, the handler will trigger polling
when interrupts are enabled again.

The first patch adds a flag that prevents the poll function from
re-enabling the interrupt when stopping.

Without this fix in place we would occasionally see a hang while
stopping channels during suspend.

					-Alex

Alex Elder (2):
  net: ipa: introduce atomic channel STOPPING flag
  net: ipa: re-enable NAPI before enabling interrupt

 drivers/net/ipa/gsi.c | 15 ++++++++++++---
 drivers/net/ipa/gsi.h |  6 ++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

-- 
2.20.1

