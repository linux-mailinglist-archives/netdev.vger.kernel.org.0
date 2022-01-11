Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CE848B743
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 20:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244011AbiAKTVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 14:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiAKTVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 14:21:55 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9051C061748
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:21:54 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id i82so239637ioa.8
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jrCLIqtuYbgNVouuG5ORa+RN8I/f0awMF+AbmNAh2sk=;
        b=pSL5HZQewq/WzDPLOeto5UPBPzkn94wdZDYMp6RSz3Kq2GpL+nCeyddASBCwKcJCPi
         2c4GmU+Z3dtTZgrwOw6V7exesG7M7EBxumJpPADTlCpZjABBNkG1MaSpCeI3sl6K1tAF
         VYnFUunoe2DC7rzi7DiKrKBb8RCFKR+ndMQFgCoAitZYO1m4fFKbs+AgZQtYkRXL6qHC
         B3ZkA8gzEY4vrN3/t8OXYJytf5KcCebC4sm1bQkykTvwC0yL/BpVxtlSP7w5i7dw+H8N
         L0/X+tw50ia2e5x6eYy5SZKxHyFp9CVKJTh9r9XHUUH59qWdT0AHZX1suMG6xPK/mkty
         CZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jrCLIqtuYbgNVouuG5ORa+RN8I/f0awMF+AbmNAh2sk=;
        b=CHczv5XFN/22S4CW2fZyNPW3/nsow744nXQNKtu5Nd+08PDZymRH1KPSqo1kQW1z6c
         3LcfGwsL0y8dMwv4NSZ05wT2XM0I/9Lrm3FfnCOqnFLOjGWz8l9fbvCgykiWRGGX+moT
         3N5O7euwvsBQImPa3WBMZLjuXNmn35In3LBDpx75w6+L39r8pn0J/JkVak5v5UL9NeKF
         1XVfqkVFPzqCHuy7klNS6IcFQzxaKcD7GhVlPNUz8WeKDpm+KEyTUi6mJJEMOudrlJKX
         HEvWNgz7EuuDAiIPnohuEDTuNd/1VM4VjpI2YjPeYL3kuRoW+qKqvvzIwhovxF++eY/E
         ct3g==
X-Gm-Message-State: AOAM530a7h4EQCrQ+2QTkrdegojZV8JDMBfm4HqEK6sNAHvmK00norpu
        JlOr3WSrzQ1JqzXK29EepXLG1g==
X-Google-Smtp-Source: ABdhPJyXCYjzn51tldUZtmuYgDix5KVd3x4gm85mkWgmJtlp6p8R3UGyMprSM68WdtVEjftIEy+D7w==
X-Received: by 2002:a02:7f97:: with SMTP id r145mr2982013jac.319.1641928914209;
        Tue, 11 Jan 2022 11:21:54 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e17sm6264544iow.30.2022.01.11.11.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 11:21:53 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     jponduru@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, agross@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: ipa: fix two replenish bugs
Date:   Tue, 11 Jan 2022 13:21:48 -0600
Message-Id: <20220111192150.379274-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains two fixes for bugs in the IPA receive buffer
replenishing code.  

					-Alex

Alex Elder (2):
  net: ipa: fix atomic update in ipa_endpoint_replenish()
  net: ipa: prevent concurrent replenish

 drivers/net/ipa/ipa_endpoint.c | 20 ++++++++++++++++----
 drivers/net/ipa/ipa_endpoint.h |  2 ++
 2 files changed, 18 insertions(+), 4 deletions(-)

-- 
2.32.0

