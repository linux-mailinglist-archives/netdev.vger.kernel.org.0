Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AADA3D67E7
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhGZTbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbhGZTbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:31:11 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A3FC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:40 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id r18so13488895iot.4
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A9jwJu5xi4wkqd+cosT28d+xkLhRgxnSiCg6LQzktSs=;
        b=LKgln55ijSKVjdSPI0gxwva38SOmK0EEOnSgR5IcEnR+RMnWprvkZpykuWTtlpWehN
         m2gB3J8TWwOCYR68khUeYJMjCJ7rv1Wc9Ggts83uWJHAmkP8TLqtCx+WoFqnG8qb8x8g
         viyzUnACK3Xxrsig4PnFiUhgllSkCXjCPDN5XQH7grNl6lzLBFv1kA+MCE/NyOTDmQgL
         szbmzgX7Mjbz9ibuG5gJYMq8fb3hqqbqZqlZw2BveIRNM2tJZoOOFQlQxLPn8MJAJCGF
         ip9kaiput6aTO6Gd09Jy4D8pIRtM4dxWVCFtuSCLUD1PVYX6SCANZC47QayZ9dPY0htN
         5yOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A9jwJu5xi4wkqd+cosT28d+xkLhRgxnSiCg6LQzktSs=;
        b=sjt8lL9ebNQP61Jd2hcz8533DGOyYgFgAMFgi6q+tSYAncRbS5mQIiJ1hFpC3pBjYt
         S4CVTiZ2S0keLqpcf2qj9kvpSrt10JeU52sSEW1dshQSjQQrmRwVkqZ/vDeW5mRgKR++
         iFctQ04WWLhpc0WWV6oe3y4LYmiLE2EH5Ca34pub+f84B+Enyi43QB9mFlUoaIBfDETm
         INyrjvmw74RY8dHFzXNlR4FmDNQAPxFZA0BwcqglXEOJBqytFp/Q85nnpYPoFxnBdnLl
         JiNx2/0k67c8QS8Ia2cNDevucu5wLk4AxXIwbVgRyg9YtmWnNDQI5HmvELAukmwYO2vI
         hNbQ==
X-Gm-Message-State: AOAM532Tf6XcW/GdsHuE/EiIL5zOLidHd5dd9i7JE/SNipmp/RgPTHUs
        byvRX3DzfHBxF1yvRgwbGMEmRQ==
X-Google-Smtp-Source: ABdhPJw1BgCjvrOnf80g7WL2/+i36ERMwpKh07clz3M1BhruqGOrW+uRI71vQ1uhvnLzLWUHcUqmpA==
X-Received: by 2002:a02:ca58:: with SMTP id i24mr17910189jal.101.1627330299558;
        Mon, 26 Jul 2021 13:11:39 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z10sm425964iln.8.2021.07.26.13.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 13:11:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: defer taking uC proxy clock
Date:   Mon, 26 Jul 2021 15:11:31 -0500
Message-Id: <20210726201136.502800-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series rearranges some of the IPA initialization code.

The first patch gets rid of two trivial setup and teardown
functions, open-coding them in their callers instead.

The second patch has memory regions get configured before endpoints.

IPA interrupts do not depend on GSI being initialized.  Therefore
they can be initialized in the config phase rather than waiting for
setup.  The third patch moves this initialization earlier; memory
regions must already be defined, so it's done after memory config.

The microcontroller also has no dependency on GSI, though it does
require IPA interrupts to be configured.  The fourth patch moves
microcontroller initialization so it too happens during the config
phase rather than setup.

Finally, we currently take a "proxy clock" for the microcontroller
during the config phase, dropping it only after we learn the
microcontroller is initialized.  But microcontroller initialization
is started by the modem, so there's no point in taking that clock
reference before we know the modem has booted.  So the last patch
arranges to wait to take the "proxy clock" for the microcontroller
until we know the modem is about to boot.

					-Alex

Alex Elder (5):
  net: ipa: kill ipa_modem_setup()
  net: ipa: configure memory regions early
  net: ipa: set up IPA interrupts earlier
  net: ipa: set up the microcontroller earlier
  net: ipa: introduce ipa_uc_clock()

 drivers/net/ipa/ipa.h           |  2 ++
 drivers/net/ipa/ipa_interrupt.c |  8 ++---
 drivers/net/ipa/ipa_interrupt.h |  8 ++---
 drivers/net/ipa/ipa_main.c      | 56 ++++++++++++++++++---------------
 drivers/net/ipa/ipa_modem.c     | 12 ++-----
 drivers/net/ipa/ipa_modem.h     |  4 ---
 drivers/net/ipa/ipa_qmi.c       |  6 ++--
 drivers/net/ipa/ipa_qmi.h       | 19 +++++++++++
 drivers/net/ipa/ipa_uc.c        | 52 +++++++++++++++++-------------
 drivers/net/ipa/ipa_uc.h        | 22 ++++++++++---
 10 files changed, 112 insertions(+), 77 deletions(-)

-- 
2.27.0

