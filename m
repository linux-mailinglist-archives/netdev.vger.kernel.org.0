Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8859C2FDC4E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 23:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391167AbhATWTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 17:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732154AbhATWEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 17:04:46 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E365C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:05 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n2so70046iom.7
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 14:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V3TcYAR0KycrKsgY4roTY2MFZq0U/ncsPStDv/MM68g=;
        b=eXW1xreQZ3gRIkREKhHF+sAztlPHMdxhtwI3mWQj0eOAZ27j2/gTrK3KQjLsuzu/dF
         0p6DFIVWwoj+X/bjAUX9Cw/0Bx5SBUNp8fuPh6uhCcImw6kojoPhOev0R7IGBBgHGgTv
         Behmzkz2LYgR0UcWBZofnK07+1DNm3quWH1lKaOXgSvWFZtZeVBum/XB5wa+llHrbRqZ
         Zv691RCn3z9wiS01J+vUmOlAWmcXSQByDSiR+s9pKiW2yTmtUrPo/7pjXhdil+yNRsNr
         JH4d+uUu5eItQ/Y5j89KR9vSR03bNPdQRq0gyhdKy5VokWY4DSqSMZnV+MaKnO0HhMcm
         H0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V3TcYAR0KycrKsgY4roTY2MFZq0U/ncsPStDv/MM68g=;
        b=FYgfxloasAqz9YTKhBGd8ENBvDHWuuKRAYKnqZmp84wwnu+WXxAcPl44INfDFbHeUR
         48KGcnQccTX7QnU9M0xiQQvmIQ5mKBZSkOS2KIdSiXWdnCPmKFMpgiS8/w1zW2mmQ9jM
         lsTstmzkH0rv/K59A8XWFF0dZQtcGw3I8MvRPhvigF/i+cmf4mLjyxY5tKu0DPDDnxD5
         IzlH3Nc1D88jiS/koFGw9jcgcMv27yYgMqBmDpLWQmnkV78uZCpr7iWQei3BlN6ym+yf
         We5LnKYrBJ9VaNUeZwd5yiFZacUWkeIYBbXhF4NDYWNd0XH9v5V1EIxRCWcRk+ePxhOz
         jfCg==
X-Gm-Message-State: AOAM532QpOt7ZTiaSigaNpNGIbBokfTVboZlCW3C7PPnFxi3I0foN06A
        7wIK8IB1bsk16rm2Jtq0o+TJsA==
X-Google-Smtp-Source: ABdhPJy3FIBbDw1zvduVWfsv6dGPkGtZSJ8PBXTh3kTkclilDwG+2lNNe7410hE5jAVEnezQ0fnf5A==
X-Received: by 2002:a02:a584:: with SMTP id b4mr8883276jam.135.1611180244502;
        Wed, 20 Jan 2021 14:04:04 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e5sm1651712ilu.27.2021.01.20.14.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 14:04:03 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: NAPI poll updates
Date:   Wed, 20 Jan 2021 16:03:56 -0600
Message-Id: <20210120220401.10713-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reviewing the IPA NAPI polling code in detail I found two
problems.  This series fixes those, and implements a few other
improvements to this part of the code.

The first two patches are minor bug fixes that avoid extra passes
through the poll function.  The third simplifies code inside the
polling loop a bit.

The last two update how interrupts are disabled; previously it was
possible for another I/O completion condition to be recorded before
NAPI got scheduled.

					-Alex

Alex Elder (5):
  net: ipa: count actual work done in gsi_channel_poll()
  net: ipa: heed napi_complete() return value
  net: ipa: have gsi_channel_update() return a value
  net: ipa: repurpose gsi_irq_ieob_disable()
  net: ipa: disable IEOB interrupts before clearing

 drivers/net/ipa/gsi.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

-- 
2.20.1

