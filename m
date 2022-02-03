Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D5E4A8954
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352511AbiBCRJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiBCRJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:09:33 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646F2C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:09:33 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id y17so2674292ilm.1
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0sm9twsYFfUl1R441+dZUp0hhjan8fnG22qNYzem82s=;
        b=K+67PkiyounXfx3XxuFDqeMRI9AsURutUzG0sKB4ty9jFEZfY7ApL2ijfwu1EmiTp7
         /bmeqBzbV9FzNgFAquA4o5Uut8m3JIiZdX6rCgiVvG09mjRyicRDAwjdp7JgX81X+8zE
         KcqCjlfQBjl7rpy203itqWJqjnnf7vT0G2k8E5EOLDEelqOHTtCQZMghThvHl35fX9c/
         hUPADzN/Wftr+GJbmG1esy6dIJAhd1ftiCKQynFhZm3UkQ9XirdThOj1tgp7S1OI6ke4
         rhnchifGkdstU5jlVX3MqRbJy5D7zyMzWtTuv3Crh1SewOMYjeJ0iw9mPZUuoK4KFiGB
         ll6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0sm9twsYFfUl1R441+dZUp0hhjan8fnG22qNYzem82s=;
        b=MueKqgfIua1bduOthv73VeTp+Bz8cSzSjpHVkqZcVoJfDs5w4yi1ugaztYIDJU6s98
         YO2KhVISAtS4De1OA69VNTzQEzFG5/F8VYKpabUC8H3M0EbTzH+4UOvikzE6tpQXYfP0
         9NpM/jmiP5xgh1bj1xRjvA9ODQ4jPM8sYnxEnFyDqzFn5OztW2vAu3FWocHQECBdSPz4
         bsGo2eBLjmw6kTaLdFWEHsMFm5Cd3RUHJXJneP9zutt6myWMnSOEro/tjUsBTGcupek3
         jdDqDjMVFc1QxNlZ7vFES560Z+nrKEz/rDL0957S2hnN1lqEiikX9Uo4hNRvIHBMMDut
         z1GA==
X-Gm-Message-State: AOAM533zQEMcdE1/I6rzhautcFGEdn14UV90xnw9JSjWyAb3DgUga+eF
        +pY6rWBZyr9CSOpQzS80SwvQRQ==
X-Google-Smtp-Source: ABdhPJwaQ52DTaKWHABJgB2ZMw/+Zx27WmRxJoY1MVrVdTPkQZCnfV42JqEEyHdQfZXOsuRhEBP5BA==
X-Received: by 2002:a05:6e02:188c:: with SMTP id o12mr11555055ilu.44.1643908172619;
        Thu, 03 Feb 2022 09:09:32 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m12sm21869671iow.54.2022.02.03.09.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:09:31 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/10] net: ipa: improve RX buffer replenishing
Date:   Thu,  3 Feb 2022 11:09:17 -0600
Message-Id: <20220203170927.770572-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series revises the algorithm used for replenishing receive
buffers on RX endpoints.  Currently there are two atomic variables
that track how many receive buffers can be sent to the hardware.
The new algorithm obviates the need for those, by just assuming we
always want to provide the hardware with buffers until it can hold
no more.

The first patch eliminates an atomic variable that's not required.
The next moves some code into the main replenish function's caller,
making one of the called function's arguments unnecessary.   The
next six refactor things a bit more, adding a new helper function
that allows us to eliminate an additional atomic variable.  And the
final two implement two more minor improvements.

					-Alex

Alex Elder (10):
  net: ipa: kill replenish_saved
  net: ipa: allocate transaction before pages when replenishing
  net: ipa: increment backlog in replenish caller
  net: ipa: decide on doorbell in replenish loop
  net: ipa: allocate transaction in replenish loop
  net: ipa: don't use replenish_backlog
  net: ipa: introduce gsi_channel_trans_idle()
  net: ipa: kill replenish_backlog
  net: ipa: replenish after delivering payload
  net: ipa: determine replenish doorbell differently

 drivers/net/ipa/gsi_trans.c    |  11 ++++
 drivers/net/ipa/gsi_trans.h    |  10 +++
 drivers/net/ipa/ipa_endpoint.c | 112 +++++++++++----------------------
 drivers/net/ipa/ipa_endpoint.h |   8 +--
 4 files changed, 60 insertions(+), 81 deletions(-)

-- 
2.32.0

