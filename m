Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F282A3252
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgKBRyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgKBRyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:54:04 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972ACC061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 09:54:04 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id n5so13719587ile.7
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 09:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hac4EHHsb72pc36SpERCNR7FLjk8MqPI23RxtaSl/AY=;
        b=xTWQoNDBg6avi/hzHisLuqKYMQosqjL+1hFEUDM1L1gZTZyrTmWgy7IcVIQQ4urUvm
         ut6kzWOx3IvKHvoXp15ATl1VN7i16409YDiv+8pX56o2j42OCQM5HEIxNjGdNqT3Rs4P
         BQRkuPwAc6wR1e0rl4lt+hwEDRInLHFXhiUB50S1G1SCcZ4qBLuujj3kG9+xfa+1cbFC
         kvlnHBDTItChMBWSI5XO6V4NaqTtzgk2Wl1y7HH5DqsqAejtJWBfHcCqvXfVpwul70dL
         G2Q951w7y6y8xJ1FsFDruelJ0LgQtCM+qLoZ4h5J3Gy/G9xH5V8bXXStkSDz3phW/aMa
         Y6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hac4EHHsb72pc36SpERCNR7FLjk8MqPI23RxtaSl/AY=;
        b=aCmJ6rjGduX4e3CXryPJ2VvnvINMdJMS0U8nZlP2zSEDrG1ThrhbxyDanNR9KorsBp
         mLApwCnTm+ugZKS0CiPQf++v4cqjmZ5oQr1I1CAjBKWOctEROqUAWBh57w/1JAU2nuAl
         37lCVAqg14Ou84q1KIFzsmMzVEaUhwx8uyyeLChAgDP5Fu2jrEJoaTqyuXLnvJ2mnJTo
         fFyMyIEk3lEvhgjBAnwFx8tXvrD9vczTsQIeD+AB5sAScLRIXr4YO2FkmTUW44v4rsOJ
         r5leuEDz1BUphxTyUGXB/pk7di9Mz7GeqOMttMq6sK2JSL6U6ncIVm4zZEl6WVOpoxBY
         kSYQ==
X-Gm-Message-State: AOAM531MODWjfXY9PigirV+D79VjhS31qPzLDthXikQbRC/kHt9jzKYo
        LIJMkG3Pk9SbZv2nTZzlui6P5A==
X-Google-Smtp-Source: ABdhPJzzutZSUzDEHG2wXCnoRLLnxGFac/K9vcamnzf1YDsmyKKENkqQLzcLcAygMUETD88imhdsfQ==
X-Received: by 2002:a92:85d5:: with SMTP id f204mr12121706ilh.45.1604339643948;
        Mon, 02 Nov 2020 09:54:03 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r4sm11089591ilj.43.2020.11.02.09.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 09:54:03 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: tell GSI the IPA version
Date:   Mon,  2 Nov 2020 11:53:54 -0600
Message-Id: <20201102175400.6282-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSI code that supports IPA avoids having knowledge about the
IPA layer it serves.  One result of this is that Boolean flags are
used during GSI initialization to convey that certain hardware
version-dependent special behaviors should be used.

A given version of IPA hardware uses a fixed/well-defined version
of GSI, so the IPA version really implies the GSI version.

If given only the IPA version, the GSI code supporting IPA can
use it to implement certain special behaviors required for IPA
*or* GSI.  This avoids the need to pass and maintain numerous
Boolean flags.

Note:  the last patch in this series depends on this patch posted
for review earlier today:
  https://lore.kernel.org/netdev/20201102173435.5987-1-elder@linaro.org

					-Alex

Alex Elder (6):
  net: ipa: expose IPA version to the GSI layer
  net: ipa: record IPA version in GSI structure
  net: ipa: use version in gsi_channel_init()
  net: ipa: use version in gsi_channel_reset()
  net: ipa: use version in gsi_channel_program()
  net: ipa: eliminate legacy arguments

 drivers/net/ipa/gsi.c          | 52 ++++++++++++++++++----------------
 drivers/net/ipa/gsi.h          | 24 +++++++++-------
 drivers/net/ipa/ipa_endpoint.c | 16 ++++-------
 drivers/net/ipa/ipa_main.c     | 14 ++-------
 4 files changed, 51 insertions(+), 55 deletions(-)

-- 
2.20.1

