Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FAA2B9DCA
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgKSWte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgKSWte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:49:34 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DC1C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:34 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id l22so583892iom.0
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lG84oj+KzplapoPBfyDcN5rycHsHCOPWyTIYNB3xyxc=;
        b=k1KWkJaxmwi21dpwLl2hsfdB5UEL21p9O2kibLzF6Jcdeiuv17Ob24iwSAq8KQkira
         Lwf98tZ1U8E/ZGwDbn32ctODmFK/LGz1s2+esx2mIiwomHaBER7I65/ASVYbbB8IRDY5
         NHUu6XK85cVxnSdfFBfFabZ3GCE9kzHLY7Nw0WX1gnTO2PgMuKeJIn/Xa0CI9kmfu2fL
         iOF5rW5t1/X0wjeB5gsAE8uMGu1GeKQPgIO0zoRgzC5S6Nox33dH/5qfsa+h0xKlrIHM
         Jixc3ivJ1T7du0ce12UfSd8SkDAiM/sob8rbDV40C35SJhNItCBV/3tQ0PaJ2/c6OvOw
         ApKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lG84oj+KzplapoPBfyDcN5rycHsHCOPWyTIYNB3xyxc=;
        b=UANcbtSWEqrOiy10A1/qaECbwFTyBqDYXQGZjG/DcFIWPAdMs8CaG4Gpyo4PjbQPJ7
         OrbNT7Cx/ji/76JqPuGMKQyp+jBwCJg1Ham1Ny+JggZ8xVhJWX5TFTquDvx6D+/wxWdN
         mxUrGRsMcufyztUDu+gYHf9GptLicW9SN26wrJvPAsvu3eFNn88+TZCiM9jnzHu3olVT
         FdQQc532ezzkmM5EtH+bonv8qHPNwrXWjk5d4/6a2bQWFxm6RWHziBKP/M7xaP9xpyvr
         11KBLz5vZ+gIRf5tZo3bFCqccxkNH8Pq1dP7OykPcoaLnKOhtHo4Z/pZwjmOqDC2qCIU
         1P/w==
X-Gm-Message-State: AOAM530O20JZSB1bDcmRCUIwcOy5yrrbMWkphPiKQPfYXnhdX8/zR2Lc
        IwwRLgpbhFLtRVOwPY9g1zSFAw==
X-Google-Smtp-Source: ABdhPJzn9N7oMO+PzNzu5FRBkzrXlXpune7+U0aZLjG+CufNvtVrLhUOPtISuxiQKnrtOque7+AN6w==
X-Received: by 2002:a02:70ce:: with SMTP id f197mr16715819jac.120.1605826173494;
        Thu, 19 Nov 2020 14:49:33 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i3sm446532iom.8.2020.11.19.14.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:49:32 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: add a driver shutdown callback
Date:   Thu, 19 Nov 2020 16:49:23 -0600
Message-Id: <20201119224929.23819-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The final patch in this series adds a driver shutdown callback for
the IPA driver.  The patches leading up to that address some issues
encountered while ensuring that callback worked as expected:
  - The first just reports a little more information when channels
    or event rings are in unexpected states
  - The second patch recognizes a condition where an as-yet-unused
    channel does not require a reset during teardown
  - The third patch explicitly ignores a certain error condition,
    because it can't be avoided, and is harmless if it occurs
  - The fourth properly handles requests to retry a channel HALT
    request
  - The fifth makes a second attempt to stop modem activity during
    shutdown if it's busy

The shutdown callback is implemented by calling the existing remove
callback function (reporting if that returns an error).

					-Alex

Alex Elder (6):
  net: ipa: print channel/event ring number on error
  net: ipa: don't reset an ALLOCATED channel
  net: ipa: ignore CHANNEL_NOT_RUNNING errors
  net: ipa: support retries on generic GSI commands
  net: ipa: retry modem stop if busy
  net: ipa: add driver shutdown callback

 drivers/net/ipa/gsi.c      | 101 ++++++++++++++++++++++++++++---------
 drivers/net/ipa/gsi.h      |   1 +
 drivers/net/ipa/ipa_main.c |  19 ++++++-
 3 files changed, 94 insertions(+), 27 deletions(-)

-- 
2.20.1

